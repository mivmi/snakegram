import time
import asyncio
import logging
import platform
import typing as t
import typing_extensions as te

from .methods import Methods
from .handlers import Router, Handler, MainRouter
from .internal import CacheEntities
from ._system import system_routers

from .. import about, errors, helpers
from ..enums import EventType
from ..models import EventExtra, UpdateTracker

from ..tl import LAYER, types, functions
from ..crypto import get_public_key, add_public_key
from ..gadgets.utils import adaptive, decorator
from ..gadgets.tlobject import TLObject

from ..session import SqliteSession, MemorySession, MemoryPfsSession
from ..session.abstract import AbstractSession, AbstractPfsSession

from ..network import Connection, MediaConnection, datacenter
from ..network.utils import Request
from ..network.codec import AbridgedCodec
from ..network.transport import TcpTransport
from ..network.transport.abstract import AbstractTransport


if t.TYPE_CHECKING:
    from ..gadgets.filter import BaseFilter

T = t.TypeVar('T')
P = te.ParamSpec('P')

logger = logging.getLogger(__name__)


DEFAULT_TRANSPORT = TcpTransport(codec=AbridgedCodec())
DEFAULT_SESSION_CLASS = SqliteSession
DEFAULT_PFS_SESSION_CLASS = MemoryPfsSession


class Telegram(Methods):
    _config: t.Optional[types.Config] = None

    def __init__(
        self,
        session: t.Union[str, AbstractSession],
        api_id: t.Union[str, int],
        api_hash: str,
        *,
        routers: t.List[Router] = [],
        lang_pack: str = '',
        lang_code: str = 'en',
        app_version: str = about.__version__,
        device_model: str = None,
        system_version: str = None,
        system_lang_code: str = 'en',
        params: t.Optional[dict] = None,
        transport: AbstractTransport = DEFAULT_TRANSPORT,
        drop_update: bool = False,
        perfect_forward_secrecy: t.Union[str, bool, AbstractPfsSession] = False
    ):

        if not isinstance(session, AbstractSession):
            session = DEFAULT_SESSION_CLASS(session)
            
        if not isinstance(perfect_forward_secrecy, AbstractPfsSession):
            if isinstance(perfect_forward_secrecy, AbstractSession):
                raise TypeError(
                    'Invalid session type for PFS: expected an `AbstractPfsSession` '
                    '(optimized for PFS), but got an `AbstractSession`.'
                )

            if isinstance(perfect_forward_secrecy, str):
                pfs_session = DEFAULT_PFS_SESSION_CLASS(
                    perfect_forward_secrecy
                )

            elif perfect_forward_secrecy:
                pfs_session = DEFAULT_PFS_SESSION_CLASS()

            else:
                pfs_session = None

        else:
            pfs_session = perfect_forward_secrecy
        
        if not api_id or not api_hash:
            raise ValueError(
                'Both `api_id` and `api_hash` must be provided. '
                'You can obtain them from https://my.telegram.org.'
            )

        self.api_id = int(api_id)
        self.api_hash = api_hash
        self.lang_pack = lang_pack
        self.lang_code = lang_code
        self.app_version = app_version
        self.system_lang_code = system_lang_code
        
        #
        uname = platform.uname()

        self.device_model = device_model or f'{uname.system} ({uname.release})'
        self.system_version = system_version or uname.version
        self.params = params or {}
        
        #
        self._extra = EventExtra()
        self._main_router = MainRouter(self, system_routers)
        self._main_router.add_router(*routers)

        self.session = session
        self.connection = Connection(
            session,
            transport.spawn(),
            pfs_session,
            event_callback=self._main_router,
            updates_callback=self._updates_dispatcher,
            init_connection_callback=self._init_connection_callback
        )
        self.drop_update = drop_update

        self._tasks = set()
        self._authorized = False

        # Dict[models.StateId, UpdateState]
        self._update_states = {}
        self._channel_polling = set()

        #
        self._entities = CacheEntities(session)
        self._update_tracker = UpdateTracker()

        # _media_connections[(dc_id, is_cdn)]
        self._media_connections: t.Dict[t.Tuple[int, bool], MediaConnection] = {}

    @t.overload
    def __call__(self, query: TLObject[T]) -> Request[T]: ...
    @t.overload
    def __call__(self, *queries: TLObject[T], ordered: bool = False) -> t.Tuple[Request[T], ...]: ...

    def __call__(self, *queries: TLObject[T], ordered: bool = False):
        return self.connection.invoke(
            *queries,
            ordered=ordered
        )

    #
    @property
    def extra(self):
        return self._extra

    # connection
    def is_connected(self):
        return self.connection.is_connected()

    @adaptive
    async def connect(self):
        await self.connection.connect()

    async def disconnect(self):
        await self.connection.disconnect()

    @adaptive
    async def wait_until_disconnected(self):
        try:
            if self.connection._future:
                await self.connection._future
        
        finally:
            self._save_state_and_entities()

    async def create_media_connection(self, dc_id: int=None, is_cdn: bool=False):
        if dc_id is None:
            dc_id = self.session.dc_id

        connection = self._media_connections.get(
            (dc_id, is_cdn)
        )

        if connection is None:
            if self.session.dc_id == dc_id:
                session = self.session
            
            else:
                session = MemorySession()
            
            transport = self.connection.transport.spawn()
    
            connection = MediaConnection(
                session,
                transport,
                dc_id=dc_id,
                is_cdn=is_cdn,
                use_ipv6=self.connection.use_ipv6,
                event_callback=self._main_router,
                public_key_getter=self._find_cdn_public_key,
                init_connection_callback=self._init_connection_callback
            )
            self._media_connections[(dc_id, is_cdn)] = connection

        await connection.connect()
        return connection

        
    # privates
    def _save_state_and_entities(self):
        for _, item in self._entities:
            self.session.upsert_entity(item.value)

        for update_state in self._update_states.values():
            self._save_state(update_state.state_info)

    def _create_new_task(self, *cores: t.Coroutine):
        result = []
        for core in cores:
            task = asyncio.create_task(core)

            result.append(task)
            self._tasks.add(task)
            task.add_done_callback(self._tasks.discard)

        return result

    async def _find_cdn_public_key(self, fingerprints: t.List[int]):
        try:
            return get_public_key(fingerprints)

        except ValueError: # not-found
            result = await self(functions.help.GetCdnConfig())

            for pk in result.public_keys:
                add_public_key(pk.public_key)

            return get_public_key(fingerprints)

    async def _init_connection_callback(self, connection: Connection):
        if connection.is_cdn:
            # no need to send `InitConnection`  for `cdn` connections
            return 

        if (
            connection.is_media
            and
            self.session.dc_id != connection.state.dc_id
        ):
            # import auth if media `dc` is different from current session `dc`
            auth = await self(
                functions.auth.ExportAuthorization(
                    connection.state.dc_id
                )
            )

            init_query = functions.auth.ImportAuthorization(
                id=auth.id,
                bytes=auth.bytes
            )
        
        else:
            init_query = functions.help.GetConfig()

        tz_offset = self.session.time_offset
        self.params.update({'tz_offset': tz_offset})

        result = await connection.invoke(
            functions.InvokeWithLayer(
                layer=LAYER,
                query=functions.InitConnection(
                    api_id=self.api_id,
                    device_model=self.device_model,
                    system_version=self.system_version,
                    app_version=self.app_version,
                    system_lang_code=self.system_lang_code,
                    lang_pack=self.lang_pack,
                    lang_code=self.lang_code,
                    params=helpers.parse_json(self.params),
                    query=init_query
                )
            )
        )

        if (
            isinstance(result, types.Config)
            and (
                self._config is None
                or
                self._config.expires < time.time()
            )
        ):
            Telegram._config = result
            datacenter.update_dc_address(result.dc_options)

    #
    @property
    def routers(self):
        """Get all subrouters attached to this main router."""
        return self._main_router.subrouters

    @property
    def get_handlers(self):
        return self._main_router.get_handlers
    
    def add_router(self, router: Router):
        """
        Add a subrouter to main router.

        Args:
            router (`Router`): The router to add.
        """
        self._main_router.add_router(router)

    def remove_router(self, router: Router):
        """
        Remove a subrouter from main router.

        Args:
            router (Router): The router to remove.
        """
        if isinstance(router, MainRouter):
            for sub in list(router.subrouters):
                self.remove_router(sub)
        
        else:
            self._main_router.remove_router(router)

    def register_handler(
        self,
        func: t.Callable[P, T],
        event_type: EventType,
        filter_expr: t.Optional['BaseFilter'] = None
    ):
        """
        Register a handler for a specific event type.

        Args:
            func (Callable):
                The function to call when the event occurs.

            event_type (`EventType`):
                The type of event to handle.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific events.

        Example:
            ```python
            async def print_rpc_errors(error):
                print(f'Error: {error}, Request: {error.request}')

            client.register_handler(
                rpc_errors,
                EventType.Error,
                filters.proxy % errors.RpcError
            )
            ```

        Note:
            You can skip calling `register_handler` directly.
            The decorators `on_update`, `on_request`, `on_result`, `on_error`
            do the same thing in a simpler way.
        """

        return self._main_router.register(func, event_type, filter_expr)

    def unregister_handler(self, handler: Handler) -> bool:
        """
        Unregister a handler.

        Args:
            handler (Handler): The handler to remove.
        """
        return self._main_router.unregister(handler)

    # proxy to main router
    @decorator
    def on_error(
        self,
        func: t.Callable[[errors.RpcError], t.Any],
        filter_expr: t.Optional['BaseFilter'] = None
    ):
        """
        Register a handler for `RpcError`.

        Use this to handle requests that raise errors. For example, if a request
        causes a `FloodWaitError`, you can catch it and retry after waiting
        for the specified time.

        Args:
            func (Callable[[RpcError], Any]):
                Function to call when an error occurs.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific error events.

        Example:
            ```python
            @client.on_error(filters.proxy % errors.FloodWaitError)
            async def flood_wait_handler(error):
                if error.seconds < 60:
                    await asyncio.sleep(error.seconds)
                    await error.request.set_result(
                        await client(event.request.query)
                    )
            ```

            You can also register the handler manually without using the decorator:

            ```python
            client.on_error(flood_wait_handler, filters.proxy % errors.FloodWaitError)
            ```
        """

        return self.register_handler(
            func,
            EventType.Error,
            filter_expr=filter_expr
        )
    
    @decorator
    def on_update(
        self,
        func: t.Callable[[types.update.TypeUpdate], t.Any],
        filter_expr: t.Optional['BaseFilter'] = None
    ):
        """
        Register a handler for incoming updates.

        This lets you listen for any updates received.

        Args:
            func (Callable[[TypeUpdate], Any]):
                Function that handles the incoming update.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific updates.

        Example:
            ```python
            @client.on_update(filters.new_message)
            async def handle_new_messages(update):
                print('New message:', update.message)
            ```

            You can also register the handler manually without using the decorator:

            ```python
            client.on_update(
                handle_new_messages,
                filters.proxy % filters.new_message
            )
            ```
        """
        return self.register_handler(
            func,
            EventType.Update,
            filter_expr=filter_expr
        )

    @decorator
    def on_result(
        self,
        func: t.Callable[['TLObject'], t.Any],
        filter_expr: t.Optional['BaseFilter'] = None
    ):
        """
        Register a handler for `RpcResult`.

        This lets you intercept and process the result of any request before
        it's returned to the original caller.

        Args:
            func (Callable[[TLObject], Any]):
                Function to handle the result.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific results.

        Example:
            ```python

            @client.on_result(filters.proxy % types.Config)
            async def set_config(result):
                ...
            ```

            You can also register the handler manually without using the decorator:

            ```python
            client.on_result(set_config, filters.proxy % types.Config)
            ```
        """
        return self.register_handler(
            func,
            EventType.Result,
            filter_expr=filter_expr
        )
    
    @decorator
    def on_request(
        self,
        func: t.Callable[[Request], t.Any],
        filter_expr: t.Optional['BaseFilter'] = None
    ):
        """
        Register a handler to intercept outgoing requests before they're sent.

        Use this to handle requests before they're dispatched to the server.
        For example, if you anticipate a `FloodWaitError`, you can wait the
        required time.

        Args:
            func (Callable[[Request], Any]):
                Function to handle the outgoing request
    
            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific requests.

            
        Example:
        ```python
        
        @client.on_request
        async def flood_wait(request):
            wait_until = flood_wait_cache.get(request.query._id)

            if wait_until:
                delay = int(wait_until - time.time())
                if delay > 0:
                    await asyncio.sleep(delay)
        ```

        You can also register the handler manually without using the decorator:
        ```python
        client.on_request(flood_wait)
        ```
        """
        return self.register_handler(
            func,
            EventType.Request,
            filter_expr=filter_expr
        )
    