from __future__ import annotations

import os
import base64
import hashlib
import typing as t
from urllib.parse import urlparse

from .transport import (
    Transport,
    BaseMTProtoTransport,
    BaseAbridgedTransport,
    BaseIntermediateTransport,
    BasePaddedIntermediateTransport
)
from ...errors import ProxyError, TransportError
from ...gadgets import http
from ..datacenter import get_dc_url_format


if t.TYPE_CHECKING:
    from .. import Connection
    from ...models import Proxy


MAX_FRAME_SIZE = 64 * 1024 # 64 KB


def _xor_mask(data: bytes, mask: bytes) -> bytes:
    assert len(mask) == 4, 'Invalid mask size'
    return bytes(b ^ mask[i % 4] for i, b in enumerate(data))

def _generate_key():
    key = os.urandom(16)
    return base64.b64encode(key)

def _generate_accept_key(key: bytes) -> str:
    key += b'258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
    data = hashlib.sha1(key).digest()
    return base64.b64encode(data).decode()


class WsTransport(Transport):
    def __init__(self, *, proxy: t.Optional[Proxy] = None):
        if proxy and proxy.secret is not None:
            raise ProxyError(
                'websocket transport does not support MTProto proxy'
            )

        self._buffer = bytearray()
        self._headers = http.Headers(
            {
                'Upgrade': 'websocket',
                'Connection': 'Upgrade',
                'Sec-WebSocket-Version': '13',
                'Sec-WebSocket-Protocol': 'binary'
            }
        )
        super().__init__(proxy=proxy)

    async def read(self, n: int):
        while len(self._buffer) < n:
            try:
                data, opcode, _ = await self._read_frame()

                if opcode == 0x8: # close frame
                    error_code = None
                    try:
                        decoded = data[2:].decode('utf-8').strip()
                        if decoded.isdigit():
                            error_code = int(decoded)

                    except UnicodeDecodeError:
                        pass

                    if error_code is not None:
                        raise TransportError.from_code(error_code)

                    raise ConnectionError('web socket closed')

                elif opcode == 0x9: # ping frame
                    await self._send_pong(data)

                elif opcode in (0x0, 0x1, 0x2): # continuation, text or binary
                    self._buffer.extend(data)

            except Exception as exc:
                await self.disconnect(exc)
                raise

        result = self._buffer[:n]
        self._buffer = self._buffer[n:]
        return bytes(result)

    async def write(self, data: bytes):
        offset = 0
        length = len(data)

        while offset < length:
            chunk_end = min(offset + MAX_FRAME_SIZE, length)
            frame_data = data[offset:chunk_end]

            # first frame is binary (opcode: 0x2)
            # others are continuation (opcode: 0x0)
            opcode = (
                0x2 if offset == 0 else 0x0
            )

            frame = self._encode_frame(
                frame_data,
                opcode,
                final_frame=bool(chunk_end == length)
            )

            try:
                await super().write(frame)
            
            except Exception as exc:
                await self.disconnect(exc)
            
            offset = chunk_end 

    async def connect(
        self,
        url: str,
        *,
        ssl: bool = False,
        timeout: t.Optional[float] = None
    ):
        parsed_url = urlparse(url)
        
        if parsed_url.hostname is None:
            raise ValueError('invalid url (no hostname).')

        host = parsed_url.hostname
        port = parsed_url.port

        if port is None:
            scheme = parsed_url.scheme.lower()
            if scheme in {'ws', 'http'}:
                port = 80

            elif scheme in {'wss', 'https'}:
                port = 443

            else:
                raise ValueError(f'unknown scheme: {scheme!r}')

        await super().connect(
            host,
            port,
            ssl=ssl,
            timeout=timeout
        )

        self._headers['Host'] = http.get_hostname(url)

        try:
            await self._ws_handshake(parsed_url.path)

        except Exception as exc:
            await self.disconnect(exc)
            raise

    # https://datatracker.ietf.org/doc/html/rfc6455
    def _encode_frame(
        self,
        data: bytes,
        opcode: int,
        final_frame: bool = True
    ) -> bytes:
        b1 = (0x80 if final_frame else 0x0) | (opcode & 0x0F)

        length = len(data)
        if length < 126:
            header = bytes([b1, 0x80 | length])

        elif length < 2 ** 16:
            header = bytes(
                [
                    b1,
                    0x80 | 126, (length >> 8) & 0xFF,
                    length & 0xFF
                ]
            )

        else:
            header = bytes([b1, 0x80 | 127])
            header += length.to_bytes(8)

        mask = os.urandom(4)
        return header + mask + _xor_mask(data, mask)

    async def _send_pong(self, data: bytes):
        self._writer.write(self._encode_frame(data, 0xA)) # pong opcode 
        await self._writer.drain()

    async def _read_frame(self) -> tuple[bytes, int, bool]:
        b1, b2 = await self._reader.readexactly(2)

        opcode = b1 & 0x0F
        masked = b2 & 0x80
        length = b2 & 0x7F

        if length == 126:
            a, b = await self._reader.readexactly(2)
            length = (a << 8) | b

        elif length == 127:
            length = int.from_bytes(
                await self._reader.readexactly(8)
            )

        mask = (
            await self._reader.readexactly(4)
            if masked else None
        )

        data = await self._reader.readexactly(length)
        if mask:
            data = _xor_mask(data, mask)

        return data, opcode, bool(b1 & 0x80)

    async def _ws_handshake(self, path: str):
        sec_key = _generate_key()
        request = http.Message(
            method='GET',
            path=path,
            headers=self._headers
        )

        request.headers['Sec-WebSocket-Key'] = sec_key.decode()

        await super().write(request.to_bytes())
        response = await http.Message.from_reader(
            self._reader,
            request=request
        )

        if response.status != 101:
            raise ConnectionError(
                f'Handshake failed: Invalid response status {response.status}'
            )

        if response.headers.get_lower('upgrade') != 'websocket':
            raise ConnectionError(
                'Handshake failed: Invalid "upgrade" header'
            )

        if response.headers.get_lower('connection') != 'upgrade':
            raise ConnectionError(
                'Handshake failed: Invalid "connection" header'
            )

        accept_key = response.headers.get('sec-websocket-accept')
        if accept_key != _generate_accept_key(sec_key):
            raise ConnectionError(
                'Handshake failed: Invalid "sec-websocket-accept" header'
            )

class BaseMTProtoWsTransport(BaseMTProtoTransport):
    # web socket requires obfuscation
    # see: https://core.telegram.org/mtproto/mtproto-transports#transport-obfuscation
    obfuscate = True
    _transport: WsTransport

    def __init__(
        self,
        connection: Connection,
        *,
        proxy: t.Optional[Proxy] = None
    ):
        super().__init__(connection, proxy=proxy)
        transport = WsTransport(proxy=proxy)
        self.set_transport(transport)


    async def connect(self, *, timeout = None):
        url = get_dc_url_format(
            self.dc_id,
            ws=True,
            domain=False
        )

        await self._transport.connect(
            url,
            timeout=timeout
        )
        await self.init()

class BaseMTProtoWssTransport(BaseMTProtoWsTransport):
    extended_limit = True

    async def connect(self, *, timeout = None):
        url = get_dc_url_format(
            self.dc_id,
            ws=True,
            cors=True,
            domain=True,
            secure=True,
            extended_limit=self.extended_limit
        )

        await self._transport.connect(
            url,
            ssl=True,
            timeout=timeout
        )

        await self.init()


# websocket
class AbridgedWsTransport(
    BaseMTProtoWsTransport,
    BaseAbridgedTransport
):
    """Abridged MTProto transport over `WS`."""

class IntermediateWsTransport(
    BaseMTProtoWsTransport,
    BaseIntermediateTransport
):
    """Intermediate MTProto transport over `WS`."""

class PaddedIntermediateWsTransport(
    BaseMTProtoWsTransport,
    BasePaddedIntermediateTransport
):
    """Padded Intermediate MTProto transport over `WS`."""
    
# secure websocket
class AbridgedWssTransport(
    BaseMTProtoWssTransport,
    BaseAbridgedTransport
):
    """Abridged MTProto transport over `WSS`."""

class IntermediateWssTransport(
    BaseMTProtoWssTransport,
    BaseIntermediateTransport
):
    """Intermediate MTProto transport over `WSS`."""

class PaddedIntermediateWssTransport(
    BaseMTProtoWssTransport,
    BasePaddedIntermediateTransport
):
    """Padded Intermediate MTProto transport over `WSS`."""