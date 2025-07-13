import sys
import time
import socket
import asyncio
import logging
import ipaddress
import typing as t
import typing_extensions as te
from abc import ABC, abstractmethod
from urllib.parse import urlparse

from ... import alias
from ...errors import TransportError
from ...gadgets.utils import maybe_await, to_async

logger = logging.getLogger(__name__)


class AbstractTransport(ABC):
    def __init__(self):
        self._lock = asyncio.Lock()
        self._event = asyncio.Event()

        self._writer: t.Optional[asyncio.StreamWriter] = None
        self._reader: t.Optional[asyncio.StreamReader] = None
        self._on_disconnect: t.Optional[t.Callable[[Exception], t.Any]] = None

    async def wait(
        self,
        timeout: t.Optional[float] = None
    ):
        """
        wait until the connection is ready or the timeout is reached.

        Waits for the internal event to be set, indicating a successful connection.  
        If a timeout is given and the connection isn't ready in time, a `TimeoutError` is raised.

        """
        logger.info(
            'Waiting for connection... (timeout: %r)',
            (
                'none'
                if timeout is None else
                f'{timeout} seconds'
            )
        )

        if self.is_connected():
            logger.debug('Already connected; skipping wait.')
            return

        try:
            start = time.time()
            await asyncio.wait_for(self._event.wait(), timeout)

        except asyncio.TimeoutError:
            logger.error(
                'Connection timed out after %.2f seconds.',
                timeout
            )
            raise

        logger.debug('Connected in %.2f seconds.', time.time() - start)

    async def read(self):
        if not self.is_connected():
            logger.error('Read attempt failed: transport is disconnected')
            raise ConnectionError('Transport is disconnected')

        try:
            logger.info('Starting read operation...')
            result = await self.read_packet()

        except (
            TransportError,
            asyncio.TimeoutError,
            asyncio.CancelledError
        ):
            # Known exceptions are propagated as is
            raise

        except Exception as exc:
            logger.exception(
                'Unexpected error during read: %s',
                type(exc).__name__
            )

            # Clean up connection state
            self._writer = None
            self._reader = None
            self._event.clear()

            if self._on_disconnect:
                await maybe_await(self._on_disconnect(exc))

            raise OSError(f'Unexpected read error: {exc}') from exc

        logger.debug('Read operation completed successfully.')

        return result

    async def write(self, data: t.ByteString):
        if not data:
            logger.warning('Write skipped: empty data')
            return

        async with self._lock:
            if not self.is_connected():
                logger.error('Write failed: transport is disconnected.')
                raise ConnectionError('Transport is disconnected')

            try:
                logger.debug('Writing data...')
                await self.send_packet(data)
        
            except asyncio.CancelledError:
                raise

            except Exception as exc:
                logger.exception(
                    'Error while writing: %r',
                    type(exc).__name__
                )
                raise OSError(f'Failed to write: {exc}') from exc

            logger.info('Write completed successfully.')

    async def connect(
        self,
        address: 'alias.Address',
        timeout: t.Optional[float] = None,
        on_disconnect: t.Optional[t.Callable[[Exception], t.Any]] = None
    ):
        """
        Connects to the address within the specified timeout.

        Marks the transport as ready on success,
        raises an exception if the connection times out or fails.

        """

        if self.is_connected():
            logger.error(
                'Connect failed: already connected to a transport (target: %r)', address
            )
            raise ConnectionError('Transport is already connected') 

        try:
            logger.info(
                'Connecting to %r (timeout: %s)...',
                address,
                (
                    'none'
                    if timeout is None else
                    f'{timeout} seconds'
                )
            )

            self._reader, self._writer = await self.open_connection(address, timeout)

        except asyncio.TimeoutError as exc:
            logger.error('Connection to %r timed out after %s seconds', address, timeout)


            raise TimeoutError(
                f'Connection to {address!r} timed out after {timeout} seconds'
            ) from exc


        except Exception as exc:
            logger.exception(
                'Error while connecting to %r: %s',
                address, exc
            )
            raise OSError(f'Error while connecting: {exc}') from exc

        self._event.set()
        self._on_disconnect = on_disconnect

        logger.info('Connected to %r', address)

    async def disconnect(self):
        """Disconnects the transport and cleans."""

        if not self.is_connected():
            logger.error('Disconnect failed: transport is already disconnected')
            raise RuntimeError('Transport is already disconnected')

        logger.info('Disconnecting...')
        
        if self._writer:
            logger.debug('Closing writer stream...')
            self._writer.close()

            # https://docs.python.org/3/library/asyncio-stream.html#asyncio.StreamWriter.wait_closed
            if sys.version_info >= (3, 7):
                try:
                    await self._writer.wait_closed()
                    logger.debug('Writer stream closed successfully')
                except Exception as err:
                    logger.warning('Error while closing writer: %s', err)

        self._writer = None
        self._reader = None
        self._event.clear()

        logger.info('Disconnected successfully')

    async def connect_socket(
        self,
        sock: 'socket.socket',
        address: t.Tuple[str, int],
        timeout: t.Optional[float] = None
    ):
        """
        async connect the given socket to the specified address. 

        Attempts the connection within the provided timeout
        if it fails, the socket is closed and an `OSError` is raised.

        Note: designed for use in subclasses to simplify the connection process,  
        especially when extra steps like SSL handshakes are needed.
        """

        _async_connect = to_async(sock.connect)

        try:
            await asyncio.wait_for(_async_connect(address), timeout=timeout)

        except Exception as exc:
            sock.close()
            raise OSError(f'Failed to connect to {address}: {exc}') from exc

        return sock

    async def open_connection(
        self,
        address: 'alias.Address',
        timeout: t.Optional[float] = None
    ):
        
        """
        Connects to the specified address and returns an async socket stream.

        Resolves the address, creates a socket with the correct family, and connects to the host.
        The socket is then set to non-blocking mode.

        Returns:
            tuple[asyncio.StreamReader, asyncio.StreamWriter]: 
                The reader and writer for the open connection.
        """

        address, family = self.resolve(address)

        sock = self.create_socket(family)
        await self.connect_socket(sock, address, timeout)

        sock.setblocking(False)

        return await asyncio.wait_for(
            asyncio.open_connection(sock=sock),
            timeout=timeout
        )

    # 
    def is_connected(self) -> bool:
        """
        Check whether the transport is currently connected.

        A connection is considered active if the writer exists, it's not closing,
        and the internal "ready" flag is set.
        """

        if (
            self._writer
            and sys.version_info >= (3, 7)
            and self._writer.is_closing()
        ):
            return False
        
        return bool(self._writer and self._event.is_set())
    
    # static methods

    @staticmethod
    def resolve(
        address: 'alias.Address'
    ) -> t.Tuple[alias.NetAddr, 'socket.AddressFamily']:
        """
        Resolves the given address to
        socket compatible `(host, port)` and address family.
        """

        if isinstance(address, str):
            result = urlparse(address)
            address = (
                result.hostname,
                result.port or (
                    80 
                    if result.scheme == 'http' else
                    443
                )
            )
            address_family = socket.AF_INET

        else:
            address_family = (
                socket.AF_INET
                if isinstance(
                    ipaddress.ip_address(address[0]),
                    ipaddress.IPv4Address
                )
                else socket.AF_INET6
            )

        return address, address_family

    @staticmethod
    def create_socket(family: 'socket.AddressFamily'):
        """
        Create a `TCP` socket for the given address family (`IPv4` | `IPv6`).

        Note: This method is meant to be used by subclasses to simplify socket creation.
        """

        return socket.socket(family, socket.SOCK_STREAM)

    # abstract methods
    @abstractmethod
    def spawn(self) -> te.Self:
        """Create a new instance of this transport."""
        raise NotImplementedError

    @abstractmethod
    def get_address(
        self,
        dc_id: int,
        is_cdn: bool,
        is_media: bool,
        use_ipv6: bool
    ) -> 'alias.Address':
        """Returns the address for the given dc."""
        raise NotImplementedError

    @abstractmethod
    async def read_packet(self) -> t.ByteString:
        """Reads a packet at the transport (low-level) layer."""
        raise NotImplementedError

    @abstractmethod
    async def send_packet(self, data: t.ByteString):
        """Sends a packet at the transport (low-level) layer."""
        raise NotImplementedError
