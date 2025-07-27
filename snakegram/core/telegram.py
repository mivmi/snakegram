import time
import asyncio
import logging
import platform
import typing as t

from .methods import Methods
from .handlers import Handlers
from .internal import CacheEntities
from .. import about, helpers


from ..tl import LAYER, types, functions
from ..crypto import get_public_key, add_public_key
from ..gadgets.utils import adaptive
from ..gadgets.tlobject import TLObject

from ..session import SqliteSession, MemorySession, MemoryPfsSession
from ..session.abstract import AbstractSession, AbstractPfsSession

from ..network import Connection, MediaConnection, datacenter
from ..network.utils import Request
from ..network.codec import AbridgedCodec
from ..network.transport import TcpTransport
from ..network.transport.abstract import AbstractTransport



T = t.TypeVar('T')
logger = logging.getLogger(__name__)


DEFAULT_TRANSPORT = TcpTransport(codec=AbridgedCodec())
DEFAULT_SESSION_CLASS = SqliteSession
DEFAULT_PFS_SESSION_CLASS = MemoryPfsSession

class Telegram(Handlers, Methods):
    _config: t.Optional[types.Config] = None

    def __init__(
        self,
        session: t.Union[str, AbstractSession],
        api_id: t.Union[str, int],
        api_hash: str,
        *,
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
        
        self.session = session
        self.connection = Connection(
            session,
            transport.spawn(),
            pfs_session,
            error_callback=self._error_callback,
            result_callback=self._result_callback,
            request_callback=self._request_callback,
            updates_callback=self._updates_dispatcher,
            init_connection_callback=self._init_connection_callback
        )
        self.drop_update = drop_update

        self._tasks = set()
        self._authorized = False
        
        #
        self._error_handlers = []
        self._update_handlers = []
        self._result_handlers = []
        self._request_handlers = []
        self._disabled_global_handlers = set()

        # Dict[models.StateId, UpdateState]
        self._update_states = {}
        self._channel_polling = set()

        self._entities = CacheEntities(session)

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
                error_callback=self._error_callback,
                result_callback=self._result_callback,
                request_callback=self._request_callback,
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
