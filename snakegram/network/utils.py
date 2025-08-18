import time
import asyncio
import typing as t
from gzip import compress
from collections import deque

from .message import RawMessage, EncryptedMessage, UnencryptedMessage
from ..tl import mtproto, functions
from ..enums import EventType
from ..errors import RpcError, BaseError, SecurityError

from ..gadgets.utils import env, maybe_await
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
        dc_id: t.Optional[int],
        session: 'AbstractSession',
        pfs_session: t.Optional['AbstractPfsSession'] = None
    ):

        self._dc_id = dc_id
        self.session = session
        self.pfs_session = pfs_session

        self._init_event = asyncio.Event()
        self._handshake_event = asyncio.Event()
        self._new_session_event = asyncio.Event()
        self.reset()

    @property
    def dc_id(self):
        return self._dc_id or self.session.dc_id

    def set_dc(self, value: int):
        self._dc_id = value
        self.session.set_dc(value)

        if self.pfs_session is not None:
            self.pfs_session.clear()

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

    def on_init(self):
        self._init_event.set()

    def on_new_session(self):
        self._new_session_event.set()

    def begin_handshake(self):
        self._init_event.clear()
        self._handshake_event.clear()
        self._new_session_event.clear()
    
    def complete_handshake(self):
        self._salt_valid_until = 0
        self._handshake_event.set()

    def is_handshake_complete(self):
        return self._handshake_event.is_set()
    
    async def wait_for_init(self, timeout: t.Optional[float] = None):
        try:
            await asyncio.wait_for(
                self._init_event.wait(),
                timeout=timeout
            )
        except asyncio.TimeoutError:
            raise asyncio.TimeoutError(
                'Timed out waiting for init'
            )

    async def wait_for_handshake(self, timeout: t.Optional[float] = None):
        try:
            await asyncio.wait_for(
                self._handshake_event.wait(),
                timeout=timeout
            )
        except asyncio.TimeoutError:
            raise asyncio.TimeoutError(
                'Timed out waiting for handshake'
            )

    async def wait_for_new_session(self, timeout: t.Optional[float] = None):
        try:
            await asyncio.wait_for(
                self._new_session_event.wait(),
                timeout=timeout
            )
        except asyncio.TimeoutError:
            raise asyncio.TimeoutError(
                'Timed out waiting for new session'
            )

class Request(t.Generic[T]):
    def __repr__(self):
        return f'<Request name={self.name!r}, done={self.done()}>'

    def __init__(
        self,
        query: TLRequest[T],
        *,
        msg_id: int = None,
        invoke_after: 'Request' = None,
        event_callback: t.Callable[[EventType, t.Any, 'Request'], t.Any] = None
    ):
        self.query = query
        self.msg_id = msg_id
        self.invoke_after = invoke_after
        self.event_callback = event_callback

        #

        self.acked = False
        self.container_id: t.Optional[int] = None
        self._future: asyncio.Future[T] = asyncio.Future()

    def __await__(self):
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

    def clear(self):
        self.msg_id = None
        self.container_id = None

        if self.done():
            self._future = asyncio.Future()

    def set_msg_id(self, value: int):
        self.msg_id = value

    def set_container_id(self, value: int):
        self.container_id = value

    def add_done_callback(self, fn: t.Callable[['Request'], t.Any]):
        self._future.add_done_callback(lambda _: fn(self))

    async def set_result(self, result: T):
        if self.event_callback is not None:
            try:
                coro = self.event_callback(
                    EventType.Result,
                    result,
                    self
                )
                await maybe_await(coro)

            except BaseError as exc: 
                await self.set_exception(exc)
                return

        if not self.done():
            self._future.set_result(result)

    async def set_exception(self, exception: Exception):
        if isinstance(exception, RpcError):
            if self.event_callback is not None:
                try:
                    coro = self.event_callback(
                        EventType.Error,
                        exception,
                        self
                    )
                    await maybe_await(coro)

                except BaseError as exc:
                    exception = exc

        if not self.done():
            self._future.set_exception(exception)

class RequestQueue:
    def __init__(
        self,
        state: State,
        event_callback: t.Callable[[EventType, t.Any], t.Any] = None,
    ):

        self.state = state
        self.event_callback = event_callback
  
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

            if self.event_callback is not None:
                coro = self.event_callback(
                    EventType.Request,
                    request
                )
                new_request = await maybe_await(coro)

                # if it returned a new `Request`, replace it
                if isinstance(new_request, Request):
                    request = new_request

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
