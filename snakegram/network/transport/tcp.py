from __future__ import annotations

import logging
import typing as t
from zlib import crc32

from .transport import (
    _decode_mtproto_proxy_secret,
    Transport,
    BaseMTProtoTransport,
    BaseAbridgedTransport,
    BaseIntermediateTransport,
    BasePaddedIntermediateTransport
)
from ..datacenter import get_dc_address
from ...gadgets.byteutils import Int
from ...errors import ProxyError, SecurityError, TransportError

if t.TYPE_CHECKING:
    from ..connection import Connection
    from ...models import Proxy


logger = logging.getLogger(__name__)


class BaseTcpTransport(BaseMTProtoTransport):
    """[Tcp](https://core.telegram.org/mtproto/transports#tcp) Transport."""
    def __init__(self, connection, *, proxy = None):
        super().__init__(connection, proxy=proxy)

        if proxy and proxy.secret is not None:
            if isinstance(self, FullTcpTransport):
                raise ProxyError(
                    'FullTcp transport does not support MTProto proxy'
                ) 

            # obfuscate must be enabled
            if not self.obfuscate:
                raise ProxyError(
                    'Obfuscation must be enabled to use MTProto proxy'
                )

            proto = _decode_mtproto_proxy_secret(proxy.secret)[0]
            if (
                proto in (0xdd, 0xee)
                and not isinstance(self, BasePaddedIntermediateTransport)
            ):
                name = self.__class__.__name__
                raise ProxyError(
                    f'This type of proxy cannot be used with {name!r}. '
                    f'use `ObfuscatedPaddedIntermediateTcpTransport` transport.'
                )

            proxy = None

        self.set_transport(Transport(proxy=proxy))

    async def connect(self, *, timeout = None):
        if self._proxy and self._proxy.secret is not None: # is MTProto
            try:
                logger.debug(
                    'Connecting to mtproto proxy "%s:%d" ...',
                    self._proxy.host,
                    self._proxy.port
                )

                await self._try_connect(
                    self._proxy.host,
                    self._proxy.port,
                    timeout=timeout
                )

            except Exception as exc:
                logger.error(
                    'Failed to connect to mtproto proxy "%s:%d": %s',
                    self._proxy.host,
                    self._proxy.port,
                    exc
                )
                raise

        else:
            last_exc = None
            addresses = get_dc_address(
                self.dc_id,
                is_cdn=self._connection._is_cdn,
                is_media=self._connection._is_media,
                force_ipv6=self._connection._use_ipv6
            )
            for host, port in addresses:
                try:
                    await self._try_connect(
                        host,
                        port,
                        timeout=timeout
                    )
                    break # success: stop iterating

                except (OSError, ConnectionRefusedError) as exc:
                    last_exc = exc
                    continue

            else:
                raise ConnectionError(
                    f'Failed to connect DC: {self.dc_id}'
                ) from last_exc

        await self.init()

    async def _try_connect(
        self,
        host: str,
        port: int,
        *,
        timeout: t.Optional[float] = None
    ):
        logger.debug('Trying to connect to "%s:%d"', host, port)

        try:
            await self._transport.connect(
                host,
                port,
                timeout=timeout
            )

        except Exception as exc:
            logger.debug(
                'Connection to "%s:%d" failed: %s',
                host, port, exc
            )
            await self.disconnect(exc)
            raise

# the `Full` transport works only over `Tcp`
# `Http` has its own structure, and `Websocket` requires obfuscation,
# which this transport does not support
class FullTcpTransport(BaseTcpTransport):
    """[Full](https://core.telegram.org/mtproto/mtproto-transports#full) Transport."""

    def __init__(
        self,
        connection: Connection,
        *,
        proxy: t.Optional[Proxy] = None
    ):

        self._local_seqno = 0
        self._server_seqno = 0
        super().__init__(connection, proxy=proxy)

    async def read_packet(self):
        length_bytes = await self.read(4)
        packet_length = Int.from_bytes(length_bytes)

        if packet_length < 0:
            raise TransportError.from_code(abs(packet_length))

        seqno_bytes = await self.read(4)

        SecurityError.check(
            Int.from_bytes(seqno_bytes) != self._server_seqno, 
            'server_seqno mismatch'
        )

        payload = await self.read(packet_length - 12)
        checksum = Int.from_bytes(
            await self.read(4),
            signed=False
        )

        SecurityError.check(
            crc32(length_bytes + seqno_bytes + payload) != checksum, 
            'checksum mismatch'
        )

        self._server_seqno += 1
        return payload

    async def send_packet(self, data):
        length = len(data) + 12

        header = (
            Int.to_bytes(length, signed=False)
            + Int.to_bytes(self._local_seqno, signed=False)
        )

        payload = header + data
        payload += Int.to_bytes(crc32(payload), signed=False)        

        self._local_seqno += 1
        await self.write(payload)


class AbridgedTcpTransport(
    BaseTcpTransport,
    BaseAbridgedTransport
):
    """Abridged MTProto transport over `Tcp`."""

class IntermediateTcpTransport(
    BaseTcpTransport,
    BaseIntermediateTransport
):
    """Intermediate MTProto transport over `Tcp`."""

class PaddedIntermediateTcpTransport(
    BaseTcpTransport,
    BasePaddedIntermediateTransport
):
    """Padded intermediate MTProto transport over `Tcp`."""

#
class ObfuscatedAbridgedTcpTransport(AbridgedTcpTransport):
    """Abridged MTProto transport over `Tcp` with obfuscation."""
    obfuscate = True

class ObfuscatedIntermediateTcpTransport(IntermediateTcpTransport):
    """Intermediate MTProto transport over `Tcp` with obfuscation."""
    obfuscate = True

class ObfuscatedPaddedIntermediateTcpTransport(PaddedIntermediateTcpTransport):
    """Padded intermediate MTProto transport over `Tcp` with obfuscation."""
    obfuscate = True
