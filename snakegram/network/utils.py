import time
import asyncio
import typing as t
from gzip import compress
from collections import deque

from .message import RawMessage, EncryptedMessage, UnencryptedMessage
from ..tl import mtproto, functions
from ..errors import RpcError, BaseError, SecurityError

from ..gadgets.utils import env
from ..gadgets.tlobject import TLRequest, TLObject
from ..gadgets.byteutils import Long


if t.TYPE_CHECKING:
    from ..session.abstract import AbstractSession, AbstractPfsSession

T  = t.TypeVar('T')

MIN_SIZE_GZIP = env('MIN_SIZE_GZIP', 512, int)
MAX_CONTAINER_LENGTH = env('MAX_CONTAINER_LENGTH', 512, int)

class State:
    def __init__(
        self,
        session: 'AbstractSession',
        pfs_session: t.Optional['AbstractPfsSession'] = None
    ):
        self.session = session
        self.pfs_session = pfs_session

        self._handshake_event = asyncio.Event()
        self.reset()
    
    @property
    def ping_id(self):
        return self._ping_id

    @ping_id.setter
    def ping_id(self, value: int):
        self._ping_id = value
    
    @property
    def auth_key(self):
        return self.active_session.auth_key

    @property
    def active_session(self):
        return self.pfs_session or self.session

    @property
    def session_id(self):
        return self._session_id

    @property
    def time_offset(self):
        return self.session.time_offset

    def reset(self):
        # https://core.telegram.org/mtproto/description#session
        self._session_id = Long()
        self._handshake_event.clear()

        self._salt = 0
        self._ping_id = 0
        self._last_msg_id = 0
        self._last_msg_seqno = 0
        self._salt_valid_until = 0

    def local_time(self) -> int:
        return int(time.time())

    def server_time(self) -> int:
        return self.local_time() + self.time_offset

    def update_time_offset(self, server_timestamp: int):
        self._time_offset = server_timestamp - self.local_time()
        self.session.set_time_offset(self._time_offset)

    # https://core.telegram.org/mtproto/description#message-identifier-msg-id
    def generate_msg_id(self):
        msg_id = self.server_time() << 32

        if msg_id <= self._last_msg_id:
            msg_id = self._last_msg_id + 1

        while msg_id % 4 != 0:
            msg_id += 1

        self._last_msg_id = msg_id
        return msg_id

    # https://core.telegram.org/mtproto/description#message-sequence-number-msg-seqno
    def generate_seq_no(self, content_related: bool):
        seqno = self._last_msg_seqno * 2
        if content_related:
            seqno += 1
            self._last_msg_seqno += 1
        return seqno

    # https://core.telegram.org/mtproto/description#server-salt
    def set_server_salt(self, salt: int):
        self._salt = salt
        self._salt_valid_until = self.server_time() + 1800

    def get_server_salt(self):
        now = self.server_time()
        if self._salt_valid_until <= now:
            self._salt, self._salt_valid_until = self.active_session.get_server_salt(now)

        return self._salt

    def start_handshake(self):
        self._handshake_event.clear()
    
    def handshake_completed(self):
        self._salt_valid_until = 0
        self._handshake_event.set()

    def is_handshake_complete(self):
        return self._handshake_event.is_set()


class Request(t.Generic[T]):
    def __repr__(self):
        return f'<Request name={self.name!r}, done={self.done()}>'

    def __init__(
        self,
        query: TLRequest[T],
        msg_id: int = None,
        invoke_after: 'Request' = None,
        error_callback: t.Callable[[RpcError, 'Request'], t.Any] = None,
        result_callback: t.Callable[[T, 'Request'], t.Any] = None
    ):
        super().__init__()

        self.query = query
        self.msg_id = msg_id
        self.invoke_after = invoke_after

        #
        self.error_callback = error_callback
        self.result_callback = result_callback

        self.acked = False
        self.container_id: t.Optional[int] = None
        self._future: asyncio.Future[T] = asyncio.Future()

    def __await__(self) -> t.Generator[t.Any, None, T]:
        return self._future.__await__()

    @property
    def name(self):
        query = self.query
        if isinstance(query, TLRequest):
            query = query._get_origin()

        return type(query).__name__

    def done(self):
        return self._future.done()

    def result(self):
        return self._future.result()
    
    def exception(self):
        return self._future.exception()

    def set_msg_id(self, value: int):
        self.msg_id = value

    def set_container_id(self, value: int):
        self.container_id = value

    def add_done_callback(self, fn: t.Callable[['Request'], t.Any]):
        self._future.add_done_callback(lambda _: fn(self))

    async def set_result(self, result: T):
        if callable(self.result_callback):
            try:
                await self.result_callback(result, self)

            except BaseError as err: 
                return await self.set_exception(err)

            except Exception:
                pass

        if not self.done():
            return self._future.set_result(result)

    async def set_exception(self, exception: Exception):
        if isinstance(exception, RpcError):
            if callable(self.error_callback):
                try:
                    await self.error_callback(exception, self)

                except BaseError as err:
                    exception = err

                except Exception:
                    pass

        if not self.done():
            return self._future.set_exception(exception)

class RequestQueue:
    def __init__(
        self,
        state: State,
        request_callback: t.Optional[t.Callable[['Request'], t.Awaitable]] = None
    ):

        self.state = state
        self.request_callback = request_callback
  
        self._event = asyncio.Event()
        self._deque: deque[Request] = deque()
        self._tasks: t.Set[asyncio.Task] = set()
    
    def add(self, *requests: 'Request'):
        task = asyncio.create_task(
            self._request_callback_process(*requests)
        )
        self._tasks.add(task)
        task.add_done_callback(self._tasks.discard)
    
    async def get(self, wait: bool = True):
        if not self._deque:
            if not wait:
                raise asyncio.QueueEmpty
    
            self._event.clear()
            await self._event.wait()

        return self._deque.popleft()
    
    async def resolve(
        self,
        timeout: t.Optional[int] = None
    ) -> t.Tuple[
        t.List['Request'],
        t.Union[EncryptedMessage, UnencryptedMessage]
    ]:

        def to_message(id: int, body: bytes, content_related: bool):
            length = len(body)

            if MIN_SIZE_GZIP < length and content_related:
                packed = (
                    mtproto.types.GzipPacked(compress(body))
                    .to_bytes()
                )
                packed_length = len(packed)

                if length > packed_length:
                    # use the compressed only if it's actually smaller
                    body = packed
                    length = packed_length

            seqno = self.state.generate_seq_no(content_related)

            return mtproto.types.Message(
                id,
                seqno,
                length,
                body=RawMessage(body)
            )

        length = 0
        buffer = []

        while length < MAX_CONTAINER_LENGTH:
            try:
                request = await asyncio.wait_for(
                    self.get(not buffer),
                    timeout
                )

            except asyncio.QueueEmpty:
                break

            # set request `msg_id` if it hasn't been assigned yet
            if request.msg_id is None:
                request.set_msg_id(self.state.generate_msg_id())

            query = request.query
            if not self.state.is_handshake_complete():
                is_bind_request = isinstance(query, functions.auth.BindTempAuthKey)

                if not is_bind_request:
                    # https://core.telegram.org/mtproto/description#unencrypted-message

                    if not is_unencrypted_request(query):
                        await request.set_exception(
                            SecurityError('Handshake is not yet complete')
                        )

                    return [request], UnencryptedMessage(
                        request.msg_id,
                        message=query
                    )

            else:
                is_bind_request = False
    
            # 
            if request.invoke_after is not None:
                # wrap the query in `InvokeAfterMsg`
                query = functions.InvokeAfterMsg(
                    request.invoke_after.msg_id,
                    query=query
                )

            message = to_message(
                request.msg_id,
                query.to_bytes(),
                content_related=is_content_related(request.query)
            )

            length += 16 # msg_id + seqno + length
            length += message.bytes
            buffer.append((request, message))

            if is_bind_request:
                break

        # container
        requests = []
        messages = []

        container_id = (
            None 
            if len(buffer) == 1 else
            self.state.generate_msg_id()
        )

        for request, message in buffer:
            requests.append(request)
            messages.append(message)

            if container_id is not None:
                request.set_container_id(container_id)

        if container_id is not None:
            message_body = to_message(
                container_id,
                body=(
                    mtproto.types.MsgContainer(
                        messages
                    )
                    .to_bytes()
                ),
                content_related=False  
            )
        
        else:
            message_body = messages[0]

        salt = self.state.get_server_salt()
        session_id = self.state.session_id

        return requests, EncryptedMessage(
            salt,
            session_id,
            message=message_body
        )

    async def _request_callback_process(self, *requests: 'Request'):
        result = []
        for request in requests:

            if self.request_callback:
                new = await self.request_callback(request)

                # if it returned a new `Request`, replace it
                if isinstance(new, Request):
                    request = new

            if not request.done():
                result.append(request)

        if result:
            self._deque.extend(result)
            self._event.set()
  
# https://core.telegram.org/mtproto/description#content-related-message  
def is_content_related(message: TLObject):
    return not isinstance(
        message,
        (
            mtproto.types.MsgCopy,
            mtproto.types.MsgsAck,
            mtproto.types.GzipPacked,
            mtproto.types.MsgContainer
        )
    )

# https://core.telegram.org/mtproto/service_messages_about_messages
def is_service_message(obj: TLObject):
    return isinstance(
        obj,
        (
            mtproto.types.TypeMsgsAck,
            mtproto.types.TypeMsgsAllInfo,
            mtproto.types.TypeMsgsStateInfo,
            mtproto.types.TypeMsgDetailedInfo,
            mtproto.types.TypeBadMsgNotification
        )
    )

def is_unencrypted_request(request: TLRequest):
    return isinstance(
        request,
        (
            mtproto.functions.ReqPqMulti,
            mtproto.functions.ReqDHParams,
            mtproto.functions.SetClientDHParams # dual
        )
    )
