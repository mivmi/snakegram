import asyncio
import logging
import platform
import typing as t

from .methods import Methods

from .. import about, errors, helpers

from ..tl import LAYER, types, functions
from ..gadgets.tlobject import TLObject, TLRequest

from ..session import SqliteSession, MemoryPfsSession
from ..session.abstract import AbstractSession, AbstractPfsSession

from ..network import Connection, datacenter
from ..network.codec import AbridgedCodec
from ..network.transport import TcpTransport
from ..network.transport.abstract import AbstractTransport


T = t.TypeVar('T')
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
        lang_pack: str = '',
        lang_code: str = 'en',
        app_version: str = about.__version__,
        device_model: str = None,
        system_version: str = None,
        system_lang_code: str = 'en',
        params: t.Optional[dict] = None,
        transport: AbstractTransport = DEFAULT_TRANSPORT,
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
        

        self.connection = Connection(
            session,
            transport.spawn(),
            pfs_session,
            connected_callback=self._init_connection_callback
        )
        
        self._authorized = False

    @t.overload
    async def __call__(self, query: TLRequest[T]) -> T: ...

    @t.overload
    async def __call__(self, *queries: TLObject[T], ordered: bool = False) -> asyncio.Future[t.Tuple[T, ...]]: ...

    async def __call__(self, *queries: TLObject[T], ordered: bool = False):
        try:
            return await self.connection.invoke(
                *queries,
                ordered=ordered
            )
 
        except errors.SeeOtherError as exc:
            me = await self.get_me()
            if me is not None:
                logger.exception(
                    'Got a "SeeOtherError" from the server, but the session appears to be valid. '
                    'to prevent accidental loss of the "auth_key", migration was skipped.'
                    'this is an unexpected situation that may indicate a server-side problem or an internal bug. '
                    '**Please report this issue.**'
                )

                raise

            await self.connection.migrate(
                exc.dc_id,
                exception=exc
            )
            return await self.connection.resend(exc.request)


    def is_connected(self):
        return self.connection.is_connected()

    async def connect(self):
        await self.connection.connect()

    async def disconnect(self):
        await self.connection.disconnect()

    async def wait_until_disconnected(self):
        if self.connection._future:
            await self.connection._future

    async def _init_connection_callback(self, connection: Connection):
        if not connection.is_cdn:
            self.params.update(
                {
                    'tz_offset': self.connection.state.time_offset
                }
            )

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
                        query=functions.help.GetConfig()
                    )
                )
            )

            if self._config is None:
                Telegram._config = result
                datacenter.update_dc_address(result.dc_options)
