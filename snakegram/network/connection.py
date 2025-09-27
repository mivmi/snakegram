from __future__ import annotations

import time
import asyncio
import logging
import typing as t
from collections import deque
from inspect import iscoroutine

from .utils import State, Request, RequestQueue, is_service_message
from .message import EncryptedMessage, UnencryptedMessage
from .handshake import Handshake

from .. import alias, errors
from ..tl import types, mtproto
from ..gadgets.tlobject import TLObject
from ..gadgets.utils import Timer, env, retry, cancel
from ..gadgets.byteutils import Reader

if t.TYPE_CHECKING:
    from ..models import Proxy
    from ..session.abstract import AbstractSession, AbstractPfsSession
    


T = t.TypeVar('T')

logger = logging.getLogger(__name__)

# timeout
TIMEOUT = env('TIMEOUT', 10, int)
CONNECT_TIMEOUT = env('CONNECT_TIMEOUT', 10, int)

CONNECT_ATTEMPTS = env('CONNECT_ATTEMPTS', 5, int)
MEDIA_CONNECTION_IDLE_TIMEOUT = env('MEDIA_CONNECTION_IDLE_TIMEOUT ', 60, int)

#
MIN_VALID_SALTS = env('MIN_VALID_SALTS', 5, int)
FUTURE_SALTS_COUNT = env('FUTURE_SALTS_COUNT', 32, int)
SALT_CHECK_INTERVAL = env('SALT_CHECK_INTERVAL', 600, int)

#
CONNECT_DELAY = env('CONNECT_DELAY', 1, int)
PING_DISCONNECT_DELAY = env('PING_DISCONNECT_DELAY', 35, int)

#
MAX_PENDING_ACKS = env('MAX_PENDING_ACKS', 16, int)
MAX_CACHE_SERVICE_REQUESTS = env('MAX_CACHE_SERVICE_REQUESTS', 10, int)

#
AUTO_RECONNECT = env('AUTO_RECONNECT', True, bool)



class Connection:
    def __init__(
        self,
        session: AbstractSession,
        pfs_session: t.Optional[AbstractPfsSession],
        transport_factory: alias.TransportFactory,
        *,
        dc_id: int = None,
        is_cdn: bool = False,
        is_media: bool = False,
        use_ipv6: bool = False,
        proxy: t.Optional[Proxy] = None,
        event_callback: t.Callable = None,  
        updates_callback: t.Callable = None,
        public_key_getter: t.Callable = None,
        init_connection_callback: t.Callable = None
    ):

        self._proxy = proxy
        self._transport_factory = transport_factory

        self._is_cdn = is_cdn
        self._is_media = is_media
        self._use_ipv6 = use_ipv6

        self._event_callback = event_callback
        self._updates_callback = updates_callback
        self._init_connection_callback = init_connection_callback

        # 
        self._state = State(
            dc_id,
            session,
            pfs_session=pfs_session,
        )
        self._handshake = Handshake(
            self._state,
            self.invoke,
            is_media=is_media,
            public_key_getter=public_key_getter
        )
        self._request_queue = RequestQueue(
            self._state,
            event_callback=self._event_callback
        )

        # events
        self._reconnect_event = asyncio.Event()

        #
        self._tasks: t.Set[asyncio.Task] = set()
        self._pending_acks: t.Set[int] = set()

        self._pending_requests: t.Dict[int, Request] = {}
        # service requests (like `MsgsAcks`) don't receive responses from the server.
        # so if we add them to `pending_requests`, they will never be removed.
        self._pending_service_requests: deque[Request] = deque(
            maxlen=MAX_CACHE_SERVICE_REQUESTS
        )

        # for requests whose responses are `NOT` wrapped in `RpcResult`:
        # the server response does not include the request's `msg_id`,
        # so we can't match responses to requests using `msg_id`.
        # instead, we check the response type to figure out which request it belongs to.
        # this `dict` keeps track of requests and their expected response types using `isinstance`.
        # If multiple requests of the same type are sent at the same time,
        # and responses come back out of order, it might cause mismatches !
        self._pending_non_rpc_requests: t.Dict[Request, t.Any] = {}

        #
        self._future: asyncio.Future = None
        self._transport = None
        self._last_send_ack_time = 0
        self._last_check_salt_time = 0

    @property
    def dc_id(self):
        return self._state.dc_id

    @t.overload
    def invoke(self, query: TLObject[T]) -> Request[T]: ...
    @t.overload
    def invoke(self, *queries: TLObject[T], ordered: bool = False) -> t.Tuple[Request[T], ...]: ...

    def invoke(self, *queries, ordered: bool = False):
        requests: t.List[Request] = []
        skip_salt_check = (
            self._is_media
            or not self._state.is_handshake_complete()
        )

        for query in queries:
            after = None

            if ordered and requests:
                after = requests[-1]

            if isinstance(query, mtproto.functions.GetFutureSalts):
                skip_salt_check = True
    
            request = Request(
                query,
                invoke_after=after,
                event_callback=self._event_callback
            )

            requests.append(request)
            request.add_done_callback(self._on_complete_process)

        if not skip_salt_check:
            # check if the number of valid server salts is below the threshold
            # if so, request new server salts from the server
            now = self._state.server_time()
            if SALT_CHECK_INTERVAL <= now - self._last_check_salt_time:
                self._last_check_salt_time = now
                count = self._state.session.get_server_salts_count(now)

                if count <= MIN_VALID_SALTS:
                    logger.info(
                        'valid server salts (%d) below threshold (%d), '
                        'requesting %d new salts.',
                        count,
                        MIN_VALID_SALTS,
                        FUTURE_SALTS_COUNT
                    )

                    # on background
                    self.invoke(
                        mtproto.functions.GetFutureSalts(
                            num=FUTURE_SALTS_COUNT
                        )
                    )

                else:
                    logger.debug('found %d valid server salts', count)

        self._request_queue.add(*requests)
        return requests[0] if len(requests) == 1 else tuple(requests)

    def is_connected(self):
        return (
            self._transport
            and self._transport.is_connected()
        )

    # async methods
    async def migrate(
        self,
        dc_id: int,
        *,
        exception: t.Optional[Exception] = None
    ):
        logger.info(
            'Migrating dc from %d to %d',
            self.dc_id,
            dc_id
        )
        self._state.set_dc(dc_id)
        return await self.reconnect(exception)

    async def connect(self):
        if self.is_connected():
            logger.debug('already connected to dc %d.', self.dc_id)
            return True

        self._transport = self._transport_factory(
            self,
            proxy=self._proxy
        )

        for attempt in retry(CONNECT_ATTEMPTS):
            logger.info(
                'connecting to dc %d (attempt %d/%d)...',
                self.dc_id,
                attempt,
                CONNECT_ATTEMPTS
            )

            try:
                await self._transport.connect(
                    timeout=CONNECT_TIMEOUT
                )

            except Exception as exc:
                logger.error(
                    'connection attempt %d to dc %d failed: %s',
                    attempt,
                    self.dc_id,
                    exc
                )

            else:
                logger.info('connected on attempt %d.', attempt)
                
                self._create_new_task(
                    self._sender_worker(),
                    self._receiver_worker()
                )

                try:
                    await self._handshake.do_handshake()

                    if callable(self._init_connection_callback):
                        await self._init_connection_callback(self)

                    self._state.on_init()
                    self._create_new_task(self._ping_worker())

                except errors.HandshakeFailedError as exc:
                    logger.exception('Handshake failed.')
                    await self._destroy_connection(exc)
                    raise

                if self._future is None or self._future.done():
                    self._future = asyncio.Future()

                return True

            # delay before retry
            if attempt != CONNECT_ATTEMPTS:
                logger.debug('Retrying in %d seconds...', CONNECT_DELAY)
                await asyncio.sleep(CONNECT_DELAY)

        logger.error(
            'All %d connection attempts to dc %d failed',
            CONNECT_ATTEMPTS,
            self.dc_id
        )

        raise ConnectionError(f'Connection to DC {self.dc_id} failed')

    async def reconnect(self, exc: Exception = None):
        self._reconnect_event.set()
        try:
            # send pending message acks to inform the server
            # which messages have already been received, preventing duplicates
            self._send_pending_acks()

            await self.disconnect(exc)
            return await self.connect()

        except Exception as exc:
            logger.error('reconnect failed: %s', exc)
            raise

        finally:
            # sending pending acks that were not sent due to disconnection
            self._send_pending_acks()
            self._reconnect_event.clear()

    async def disconnect(self, exc: Exception = None):
        if not self.is_connected():
            logger.info('No active connection found. Skipping.')
            return

        await cancel(*self._tasks)
        await self._transport.disconnect(exc)

    # worker's
    async def _ping_worker(self):
        logger.info('ping worker started')

        while self.is_connected():
            # https://core.telegram.org/mtproto/service_messages#deferred-connection-closure--ping
            ping_id = self._state.ping_id + 1

            try:
                logger.debug(
                    'Sending new ping request with ping_id %d',
                    ping_id
                )
                send_time = time.time()
                await self.invoke(
                    mtproto.functions.PingDelayDisconnect(
                        ping_id=ping_id,
                        disconnect_delay=PING_DISCONNECT_DELAY
                    )
                )

            except asyncio.CancelledError:
                break

            except Exception as exc:
                logger.info(
                    'Failed to send ping %d: %s, retrying...',
                    ping_id,
                    type(exc).__name__
                )

            else:
                logger.debug(
                    'Received pong for ping_id %d in %d ms',
                    ping_id,
                    (time.time() - send_time) * 1000
                )

                self._state.ping_id = ping_id
            
            await asyncio.sleep(PING_DISCONNECT_DELAY - TIMEOUT)

        logger.info('ping worker stopped.')

    async def _sender_worker(self):
        logger.info('sender worker started')

        while self.is_connected():
            logger.debug('waiting for request from queue')
            try:
                requests, message = await self._request_queue.resolve(TIMEOUT)
            
            except asyncio.TimeoutError:
                continue
            
            logger.info('sending %d request(s) ...', len(requests))

            try:
                data = message.to_bytes()
                if isinstance(message, EncryptedMessage):
                    data = self._state.auth_key.encrypt(data)

                await self._transport.send_packet(data)

            except Exception as exc:
                logger.exception(
                    'Failed to send message: %s',
                    exc
                )
                self._resend(*requests)
                continue

            for request in requests:
                logger.debug(
                    'Sent request %r (msg_id: %d)',
                    request.name,
                    request.msg_id
                )

                if (
                    isinstance(message, UnencryptedMessage)
                    or
                    isinstance(
                        request.query,
                        (  
                            mtproto.functions.DestroyAuthKey,
                            mtproto.functions.DestroySession
                        )
                    )
                ):
                    logger.debug(
                        'Added %r (msg_id: %d) to non-rpc pending list',
                        request.name,
                        request.msg_id
                    )
                    result_type = request.query._result_type()
                    self._pending_non_rpc_requests[request] = result_type

                elif is_service_message(request):
                    logger.debug(
                        'Added %r (msg_id: %d) to service pending list',
                        request.name,
                        request.msg_id
                    )
                    self._pending_service_requests.append(request)

                else:
                    logger.debug(
                        'Added %r (msg_id: %d) to pending list',
                        request.name,
                        request.msg_id
                    )
                    self._pending_requests[request.msg_id] = request

        logger.info('Sender worker stopped')

    async def _receiver_worker(self):
        logger.info('Receiver worker started')

        while self.is_connected():
            try:
                data = await asyncio.wait_for(
                    self._transport.read_packet(),
                    timeout=TIMEOUT
                )
            
            except asyncio.TimeoutError:
                continue
            
            except asyncio.CancelledError:
                break

            except (OSError, asyncio.IncompleteReadError) as exc:
                asyncio.create_task(self._on_disconnect_process(exc))
                break

            except errors.AuthKeyNotFoundError as exc:
                logger.warning('Auth key not found, reconnecting...')
                self._state.reset()
                self._state.active_session.clear()
                asyncio.create_task(self.reconnect(exc))
                break

            if len(data) < 8:
                logger.warning('packet too short: %d bytes', len(data))
                continue

            # check the first 8 bytes (auth_id). in unencrypted packets this is zero
            if data[:8] != b'\x00' * 8:
    
                logger.debug('encrypted packet detected (auth_id != 0)')
                self._create_new_task(self._incoming_packet_process(data))

            else:
                logger.debug('unencrypted packet detected (auth_id == 0)')
                self._create_new_task(self._incoming_unencrypted_packet_process(data))

        logger.info('Receiver worker stopped')

    #
    def _new_update_handler(self, message: types.updates.TypeUpdates):
        if not self._is_media:
            if callable(self._updates_callback):
                return asyncio.create_task(self._updates_callback(message))

            else:
                logger.warning('no callback set for updates: %r', message)

    def _msgs_ack_handler(self, message: mtproto.types.TypeMsgsAck):
        logger.info('Received acks for msg_ids: %s', message.msg_ids)

        for msg_id in message.msg_ids:
            request = self._pending_requests.get(msg_id)

            if request is not None:
                request.acked = True

            else:
                for request in self._pending_non_rpc_requests.keys():
                    if request.msg_id == msg_id:
                        request.acked = True
                        break

    def _on_complete_process(self, request: Request):
        if request.msg_id in self._pending_requests:
            logger.debug(
                'completed %r (msg_id: %s), removed from pending list.',
                request.name,
                request.msg_id
            )
            self._pending_requests.pop(request.msg_id)

        elif request in self._pending_non_rpc_requests:
            logger.debug(
                'completed %r (msg_id: %s), removed from non-rpc pending list.',
                request.name,
                request.msg_id
            )
            self._pending_non_rpc_requests.pop(request)


    async def _destroy_connection(self, exception: Exception):
        if self.is_connected():
            await self.disconnect(exception)

        if self._future and not self._future.done():
            # only set an exception if the Future is actually being awaited
            # to avoid "Future exception was never retrieved" warnings
            blocked = getattr(self._future, '_asyncio_future_blocking', None)
            if blocked and exception:
                self._future.set_exception(exception)

            else:
                self._future.set_result(True)

        self._state.reset()
        self._pending_acks.clear()
        self._pending_service_requests.clear()

        for request in self._pending_requests.values():
            await request.set_exception(exception)

        for request in self._pending_non_rpc_requests.keys():
            await request.set_exception(exception)

        await cancel(*self._tasks)


    async def _on_disconnect_process(self, exc: Exception = None):
        logger.info('disconnected due to: %s', exc)

        if AUTO_RECONNECT:
            logger.debug('auto reconnect is enabled, reconnecting ...')
            asyncio.create_task(self.reconnect(exc))
            return

        await self._destroy_connection(exc)

    async def _on_message_process(self, message: 'mtproto.types.Message'):
        logger.debug('Processing message: %s', type(message.body).__name__)

        # https://core.telegram.org/mtproto/service_messages_about_messages#acknowledgment-of-receipt
        if not is_service_message(message.body):
            self._pending_acks.add(message.msg_id)
        
        # route message to handler if available
        dispatcher = self._dispatcher_mapping.get(message.body._group_id)
        if dispatcher is not None:
            result = dispatcher(self, message.body)
            if iscoroutine(result):
                await result

        else:
            logger.warning(
                'No dispatcher for message type: %r, %r',
                type(message.body).__name__,
                message.body
            )

        if not self._state.is_handshake_complete():
            return 

        # send acks if enough collected or enough time passed
        now = self._state.server_time()
        if self._pending_acks and (
            60 <= now - self._last_send_ack_time
            or
            len(self._pending_acks) >= MAX_PENDING_ACKS
        ):
            self._send_pending_acks()
            self._last_send_ack_time = now

    async def _incoming_packet_process(self, cipher_text: t.ByteString):
        try:
            data = self._state.auth_key.decrypt(cipher_text)

            with Reader(data) as reader:
                result = EncryptedMessage.from_reader(reader)

                # padding should be between 12 and 1024 bytes.
                errors.SecurityError.check(
                    not (12 <= len(reader.read()) <= 1024),
                    'not (12 <= len(padding) <= 1024)'
                )

                errors.SecurityError.check(
                    result.session_id != self._state.session_id,
                    'result.session_id != handshake.state.session_id'
                )

                return await self._on_message_process(result.message)

        except Exception as exc:
            logger.exception('Failed to process packet')

            if isinstance(exc, errors.SecurityError):
                await self.reconnect(exc)
                return

            raise
    
    async def _incoming_unencrypted_packet_process(self, packet: t.ByteString):
        try:
            with Reader(packet) as reader:
                result = UnencryptedMessage.from_reader(reader)
    
            message = result.message
            requests = list(self._pending_non_rpc_requests.items())

            for request, result_types in requests:
                if not isinstance(message, result_types):
                    continue
                
                await request.set_result(message)
                break
            
            else:
                 logger.warning('Missing unencrypted message: %r', message)
        
        except Exception:
            logger.exception('Failed to process unencrypted packet')

    # handlers
    def _send_pending_acks(self): 
        if not self._pending_acks or not self.is_connected():
            return

        msg_ids = list(self._pending_acks) # copy
        self.invoke(
            mtproto.types.MsgsAck(
                msg_ids=msg_ids
            )
        )
        self._pending_acks.clear()
        logger.debug('sent %d ack(s): %r', len(msg_ids), msg_ids)

    async def _pong_handler(self, message: mtproto.types.TypePong):
        logger.info('Received pong for ping_id: %d', message.ping_id)

        request = self._pending_requests.get(message.msg_id)
        if request:
            await request.set_result(message)

        else:
            logger.info('pong for unknown ping_id: %d', message.ping_id)

    async def _rpc_result_handler(self, message: mtproto.types.TypeRpcResult):
        request = self._pending_requests.get(message.req_msg_id)
        if request is None:
            logger.warning(
                'Received RPC result for unknown msg_id %d: %r',
                message.req_msg_id,
                message
            )

            return

        logger.info('Received RPC result for msg_id %d', message.req_msg_id)

        try:
            if isinstance(message.result, mtproto.types.TypeRpcError):
                logger.debug(
                    'Server returned error for msg_id %d: code=%d, message=%r',
                    message.req_msg_id,
                    message.result.error_code,
                    message.result.error_message
                )

                await request.set_exception(
                    errors.RpcError.build(
                        request,
                        message.result.error_message,
                        error_code=message.result.error_code
                    )
                )

            else:
                logger.debug(
                    'Result set successfully for msg_id: %d',
                    message.req_msg_id
                )
                await request.set_result(message.result)

                if isinstance(message.result, types.updates.TypeUpdates):
                    self._new_update_handler(message.result)

        except Exception as exc:
            logger.exception(
                'Error while processing msg_id %d',
                message.req_msg_id
            )
            await request.set_exception(exc)

    async def _future_salts_handler(self, message: mtproto.types.TypeFutureSalts):
        # Server salts tied to auth key, not session
        for salt in message.salts:
            self._state.session.add_server_salt(
                salt.salt,
                valid_since=salt.valid_since,
                valid_until=salt.valid_until
            )

        logger.debug('Added %d new server salts to session', len(message.salts))

        request = self._pending_requests.get(message.req_msg_id)
        if request:
            await request.set_result(message)

        else:
            logger.warning(
                'Received future salts for unknown msg_id %d',
                message.req_msg_id
            )

    async def _message_container_handler(self, message: mtproto.types.TypeMessageContainer):
        length = len(message.messages)
        logger.info('Processing message container with %d messages', length)

        for index, item in enumerate(message.messages):
            try:
                await self._on_message_process(item) # preserve order

            except Exception as exc:
                logger.exception(
                    'Error %r while processing message %d in container: %r',
                    type(exc).__name__,
                    index,
                    item
                )

    async def _new_session_created_handler(self, message: mtproto.types.TypeNewSession):
        logger.info(
            'New session created: unique_id=%d, new_server_salt=%d',
            message.unique_id,
            message.server_salt
        )

        self._state.on_new_session()
        # old server salts may be expired or missing
        # server provides a fresh salt upon new session creation.
        self._state.set_server_salt(message.server_salt)

        if not self._is_media:
            # send `UpdatesTooLong` update to indicate missed update gap,
            # triggering the client to call `updates.GetDifference` for a full sync

            logger.debug(
                'sending "UpdatesTooLong" update '
                'to trigger "updates.GetDifference" for full sync'
            )
            await self._state.wait_for_init(TIMEOUT)
            self._new_update_handler(types.updates.UpdatesTooLong())

    async def _bad_msg_notification_handler(self, message: mtproto.types.TypeBadMsgNotification):
        logger.debug(
            'Bad msg notification received: bad_msg_id=%d, bad_msg_seqno=%d',
            message.bad_msg_id,
            message.bad_msg_seqno
        )

        requests = self._get_pending_request(message.bad_msg_id)

        if isinstance(message, mtproto.types.BadServerSalt):
            # update server salt if it's incorrect
            self._state.set_server_salt(message.new_server_salt)

            if requests:
                logger.info(
                    'Bad server salt for msg_id %d:'
                    'resending request with new server salt.',
                    message.bad_msg_id,
                )
                self._resend(*requests)

        else:
            logger.debug(
                'bad message error for msg_id %d: error_code=%d',
                message.bad_msg_id,
                message.error_code
            )

            for request in requests:
                await request.set_exception(
                    errors.BadMessageError.build(
                        request,
                        error_code=message.error_code
                    )
                )

    async def _destroy_auth_key_handler(self, message: mtproto.types.TypeDestroyAuthKeyRes):
        # some times the server closes the connection, 
        # before responding to `DestroyAuthKey` request, the only way to handle this is to reconnect.

        if isinstance(
            message,
            mtproto.types.DestroyAuthKeyOk
        ):
            logger.debug(
                'auth key destroyed. '
                'resetting state and clearing active session'
            )

            self._state.reset()
            self._state.active_session.clear()

        requests = list(self._pending_non_rpc_requests.items())
        for request, result_types in requests:
            if not isinstance(message, result_types):
                continue

            await request.set_result(message)
            break

        else:
            logger.warning('Missing destroy auth key request: %r', message)

    async def _destroy_session_id_handler(self, message: mtproto.types.TypeDestroySessionRes):
        # sessions can only be destroyed by other sessions
        # if destroy request targets the current session, the server returns `DestroySessionNone`
        # so no need to check `session_id`.

        requests = list(self._pending_non_rpc_requests.items())
        for request, result_types in requests:
            if not isinstance(message, result_types):
                continue

            await request.set_result(message)
            break

        else:
            logger.warning('Missing destroy session request: %r', message)
 
    # helpers
    def _resend(self, *requests: Request):
        for request in requests:
            is_done = request.done()

            request.clear()
            if is_done:
                request.add_done_callback(self._on_complete_process)

        self._request_queue.add(*requests)

    def _create_new_task(self, *cores: t.Coroutine):
        tasks = []
        for core in cores:
            task = asyncio.create_task(core)

            tasks.append(task)
            self._tasks.add(task)
            task.add_done_callback(self._tasks.discard)

        return tasks

    def _get_pending_request(self, msg_id: int, delete: bool = False) -> t.List[Request]:
        request = self._pending_requests.get(msg_id)
        if request:
            # msg_id is direct request (not container)
            return [request]

        # msg_id might be a container_id
        msg_ids = [
            req.msg_id for req in self._pending_requests.values()
            if req.container_id == msg_id
        ]

        if msg_ids:
            return [
                (
                    self._pending_requests.pop(mid)
                    if delete else
                    self._pending_requests.get(mid)
                )
                for mid in msg_ids
            ]

        # check in service requests
        buffer = []
        for request in self._pending_service_requests.copy():
            if (
                request.msg_id == msg_id
                or request.container_id == msg_id
            ):
                if delete:
                    self._pending_service_requests.remove(request)

                buffer.append(request)

        return buffer

    # this dict links each `group_id` to  handler function
    # each key stands for certain kind of message coming from the server
    # and the function next to it takes care of handling that message
    _dispatcher_mapping = {
        0X3760733C: _pong_handler,
        0XDE0E74A8: _msgs_ack_handler,
        0X59E6F659: _rpc_result_handler,
        0XD68D29C0: _new_update_handler,
        0XE61DEDD4: _future_salts_handler,
        0XE599B727: _message_container_handler,
        0X6533A8E4: _new_session_created_handler,
        0X36B199EF: _bad_msg_notification_handler,
        0XEB073753: _destroy_auth_key_handler,
        0XC69A3660: _destroy_session_id_handler
    }

class MediaConnection(Connection):
    def __init__(
        self,
        session,
        transport_factory,
        *,
        dc_id = None,
        is_cdn = False,
        use_ipv6 = False,
        proxy: t.Optional[Proxy] = None,
        event_callback = None,
        public_key_getter = None,
        init_connection_callback = None
    ):
        super().__init__(
            session,
            None,
            transport_factory,
            dc_id=dc_id,
            is_cdn=is_cdn,
            is_media=True,
            use_ipv6=use_ipv6,
            proxy=proxy,
            event_callback=event_callback,
            public_key_getter=public_key_getter,
            init_connection_callback=init_connection_callback
        )

        self._lock = asyncio.Lock()
        self._last_error = None
        self._active_sessions = 0
        self._disconnect_timer = Timer(
            MEDIA_CONNECTION_IDLE_TIMEOUT,
            lambda _: self._schedule_disconnect()
        )

    def release(self):
        self._active_sessions = max(0, self._active_sessions - 1)
        if self._active_sessions == 0:
            self._disconnect_timer.start()

    async def migrate(self, dc_id, *, exception=None):
        raise RuntimeError(
            "Media connections cannot be migrated."
        )

    async def connect(self):
        async with self._lock:
            if self._disconnect_timer.is_running():
                await self._disconnect_timer.stop()

            if (
                not self.is_connected()
                and not self._reconnect_event.is_set()
            ):
                await super().connect()

            self._active_sessions += 1

    async def disconnect(self, exc: Exception = None):
        async with self._lock:
            self.release()
            self._last_error = exc

    async def _schedule_disconnect(self):
        async with self._lock:
            if self._active_sessions > 0:
                return
            await super().disconnect(self._last_error)
