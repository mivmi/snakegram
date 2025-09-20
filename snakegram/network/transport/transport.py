from __future__ import annotations

import os
import sys
import time
import hmac
import random
import socket
import base64
import asyncio
import logging
import hashlib
import typing as t
from copy import deepcopy
from abc import ABC, abstractmethod

from ...models import Proxy
from ...enums import ProxyType
from ...errors import ProxyError, TransportError
from ...gadgets import http
from ...gadgets.byteutils import Int
from ...crypto.aes import Aes256Ctr # use backend for continuous mode

try:
    import ssl as _ssl_module

except ImportError:
    _ssl_module = None

if t.TYPE_CHECKING:
    from ..connection import Connection

logger = logging.getLogger(__name__)

_MOD = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED
_POW = 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6
_MAX_GREASE = 8
_MAX_TLS_MSG = 16 * 1024 # 16 KB
_TLS_HELLO_OPS = [
    ('string', b'\x16\x03\x01\x02\x00\x01\x00\x01\xfc\x03\x03'),
    ('zero', 32),
    ('string', b'\x20'),
    ('id', None),
    ('string', b'\x00\x20'),
    ('grease', 0),
    (
        'string',
        b'\x13\x01\x13\x02\x13\x03\xc0\x2b\xc0\x2f\xc0'
        b'\x2c\xc0\x30\xcc\xa9\xcc\xa8\xc0\x13\xc0\x14'
        b'\x00\x9c\x00\x9d\x00\x2f\x00\x35\x01\x00\x01\x93'
    ),
    ('grease', 2),
    ('string', b'\x00\x00'),
    (
        'permutation',
        [
            [
                ('string', b'\x00\x00'),
                ('begin_scope', None),
                ('begin_scope', None),
                ('string', b'\x00'),
                ('begin_scope', None),
                ('domain', None),
                ('end_scope', None),
                ('end_scope', None),
                ('end_scope', None)
            ],
            [('string', b'\x00\x05\x00\x05\x01\x00\x00\x00\x00')],
            [
                ('string', b'\x00\x0a\x00\x0a\x00\x08'),
                ('grease', 4),
                ('string', b'\x00\x1d\x00\x17\x00\x18')
            ],
            [('string', b'\x00\x0b\x00\x02\x01\x00')],
            [
                (
                    'string',
                    b'\x00\x0d\x00\x12\x00\x10\x04\x03\x08\x04\x04'
                    b'\x01\x05\x03\x08\x05\x05\x01\x08\x06\x06\x01'
                )
            ],
            [
                (
                    'string',
                    b'\x00\x10\x00\x0e\x00\x0c\x02\x68\x32\x08\x68'
                    b'\x74\x74\x70\x2f\x31\x2e\x31'
                )
            ],
            [('string', b'\x00\x12\x00\x00')],
            [('string', b'\x00\x17\x00\x00')],
            [('string', b'\x00\x1b\x00\x03\x02\x00\x02')],
            [('string', b'\x00\x23\x00\x00')],
            [
                ('string', b'\x00\x2b\x00\x07\x06'),
                ('grease', 6),
                ('string', b'\x03\x04\x03\x03')
            ],
            [('string', b'\x00\x2d\x00\x02\x01\x01')],
            [
                ('string', b'\x00\x33\x00\x2b\x00\x29'),
                ('grease', 4),
                ('string', b'\x00\x01\x00\x00\x1d\x00\x20'),
                ('k', None)
            ],
            [('string', b'\x44\x69\x00\x05\x00\x03\x02\x68\x32')],
            [('string', b'\xff\x01\x00\x01\x00')]
        ]
    ),
    ('grease', 3),
    ('string', b'\x00\x01\x00\x00\x15')
]

def _lp_encoding(data: t.Union[str, bytes]):
    if isinstance(data, str):
        data = data.encode('utf-8')

    length = len(data)
    if length > 255:
        raise ValueError('string too long (max 255 bytes)')
    return bytes([length]) + data

# https://github.com/DrKLO/Telegram/blob/ddc90f16be1ab952114005347e0102365ba6460b/TMessagesProj/jni/tgnet/ConnectionSocket.cpp#L79
def _get_y2(x: int) -> int:
    return (x ** 3 + 486662 * x ** 2 + x) % _MOD

def _get_double_x(x: int) -> int:
    y2 = _get_y2(x)
    numer = ((x*x - 1) % _MOD)**2 % _MOD
    denom = pow(4 * y2 % _MOD, -1, _MOD)
    return (numer * denom) % _MOD

def _generate_public_key() -> bytes:
    while True:
        key_bytes = bytearray(os.urandom(32))
        key_bytes[31] &= 0x7F
        x = int.from_bytes(key_bytes, 'big')
        x = (x * x) % _MOD

        if pow(_get_y2(x), _POW, _MOD) == 1:
            break

    for _ in range(3):
        x = _get_double_x(x)

    key = bytearray(x.to_bytes(32, 'big'))
    for i in range(16):
        key[i], key[31-i] = key[31-i], key[i]

    return bytes(key)

def _decode_mtproto_proxy_secret(value: str):
    data = None
    if len(value) % 2 == 0:
        try:
            data = bytes.fromhex(value)

        except ValueError:
            pass

    if data is None:
        padding = len(value) % 4
        if padding:
            value += '=' * (4 - padding)

        try:
            data = base64.urlsafe_b64decode(value)

        except Exception as exc:
            raise ValueError('Invalid MTProto proxy secret') from exc

    proto = None
    secret = data
    server_hostname = None

    if len(data) >= 17:
        proto = data[0]        
        secret = data[1: 17]
        if proto == 0xee:
            server_hostname = data[17:].strip(b'\x00')

    return proto, secret, server_hostname

class Transport:
    def __init__(self, *, proxy: t.Optional[Proxy] = None):
        self._proxy = proxy
        self._buffer = bytearray()

        self._host: t.Optional[str] = None
        self._port: t.Optional[int] = None
        self._writer: t.Optional[asyncio.StreamWriter] = None
        self._reader: t.Optional[asyncio.StreamReader] = None
        self._is_fake_tls = False

    def is_connected(self) -> bool:
        if self._writer and self._writer.is_closing():
            return False

        return self._writer is not None

    #
    async def read(self, n: int) -> bytes:
        if not self.is_connected():
            raise ConnectionError('Transport is not connected')

        try:
            if self._is_fake_tls:
                # remove `TLS` header, keep only payload
                # reading `TLS` records until we have enough data

                while len(self._buffer) < n:
                    _, frame = await self._read_tls_record()
                    self._buffer.extend(frame)

                data = bytes(self._buffer[:n])
                self._buffer = self._buffer[n:]
            else:
                data = await self._reader.readexactly(n)

            logger.info('Read %d bytes successfully', len(data))
            return data

        except Exception as exc:
            logger.debug('Failed to read %d bytes: %s', n, exc)
            raise

    async def write(self, data: bytes):
        if not self.is_connected():
            raise ConnectionError('Transport is not connected')

        if not data:
            logger.info('Write skipped: empty data')
            return

        try:
            if self._is_fake_tls:
                # split data into `TLS` records and add headers
                for offset in range(0, len(data), _MAX_TLS_MSG):
                    chunk = data[offset: offset + _MAX_TLS_MSG]

                    message = (
                        b'\x17' # data record type
                        + b'\x03\x03' # TLS version (TLS 1.2)
                        + len(chunk).to_bytes(2, 'big')
                        + chunk
                    )
                    self._writer.write(message)
                    logger.debug('write %d bytes (fake TLS frame)', len(message))

            else:
                self._writer.write(data)
                logger.debug('write %d bytes', len(data))

            await self._writer.drain()

        except Exception as exc:
            logger.debug('Failed to read %d bytes: %s', len(data), exc)
            raise

    async def connect(
        self,
        host: str,
        port: int,
        *,
        ssl: bool = False,
        timeout: t.Optional[float] = None
    ):

        if self.is_connected():
            logger.debug(
                'connect skipped: already connected to "%s:%d"',
                self._host, self._port
            )

            if self._host != host or self._port != port:
                raise ConnectionError(
                    'transport already connected to another host'
                )

            return

        self._host = host
        self._port = port
        logger.info('starting connection to "%s:%d"', host, port)

        if self._proxy is None:
            logger.debug('no proxy set, connecting directly ...')

            reader, writer = await self._open_connection(
                host,
                port,
                timeout=timeout
            )

        else:
            if self._proxy.type is ProxyType.MTProto:
                # mtproto proxy are not standard `TCP` proxies
                # they can only connect to telegram DCs.
                # support for `MTProto` proxies must be implemented at higher layer.

                raise ProxyError(
                    'MTProto is not supported for raw TCP connections'
                )

            logger.debug(
                'Connecting to %s proxy "%s:%d" ...',
                self._proxy.type.value,
                self._proxy.host,
                self._proxy.port
            )

            try:
                reader, writer = await self._open_connection(
                    self._proxy.host,
                    self._proxy.port,
                    timeout=timeout
                )

            except Exception as exc:
                logger.error(
                    'Failed to connect to proxy "%s:%d"',
                    self._proxy.host,
                    self._proxy.port
                )

                raise ProxyError(
                    'Failed to connect to the proxy server'
                ) from exc

            await self._negotiate_proxy(reader, writer)

        if ssl:
            await self._start_tls(reader, writer, host)

        self._reader = reader
        self._writer = writer
        logger.debug('successfully connected to "%s:%d"', host, port)

    async def reconnect(
        self,
        exc: t.Optional[Exception] = None,
        *,
        timeout: t.Optional[float] = None
    ):
        logger.debug('starting reconnect, reason: %s', exc)

        if self.is_connected():
            logger.debug('disconnecting the previous connection')
            try:
                await self.disconnect(exc)

            except Exception as exc:
                logger.warning('disconnect failed: %s', exc)

        logger.debug(f'reconnecting to {self._host}:{self._port} ...')
        return await self.connect(timeout=timeout)

    async def disconnect(self, exc: t.Optional[Exception] = None):
        logger.debug('starting disconnect, reason: %s', exc)

        if self.is_connected():
            await self._close_writer(self._writer)

        self._writer = None
        self._reader = None
        self._is_fake_tls = False

        logger.debug('disconnected successfully.')

    # privates
    async def _start_tls(
        self,
        reader: asyncio.StreamReader,
        writer: asyncio.StreamWriter,
        server_hostname: t.Optional[str] = None
    ):
        logger.info('starting TLS handshake ...')

        if _ssl_module is None:
            logger.error('SSL module is not available')
            raise RuntimeError(
                'python SSL module is not available'
            )

        ssl_context = _ssl_module.create_default_context()
        logger.info(
            'created default SSL context for server_hostname=%s',
            server_hostname
        )

        try:
            # writer.start_tls was added in python 3.11
            # https://docs.python.org/3/library/asyncio-stream.html#asyncio.StreamWriter.start_tls
            if sys.version_info >= (3, 11):
                await writer.start_tls(
                    ssl_context,
                    server_hostname=server_hostname
                )

            else:
                loop = asyncio.get_running_loop()
                protocol = writer.transport.get_protocol()
                new_transport = await loop.start_tls(
                    writer.transport,
                    protocol,
                    ssl_context,
                    server_hostname=server_hostname
                )
                if new_transport is None:
                    raise RuntimeError('SSL negotiation failed')

                reader._transport = new_transport 
                writer._transport = new_transport

        except Exception as exc:
            logger.error('TLS handshake failed: %s', exc)
            raise

        logger.info('TLS handshake completed')

    async def _start_fake_tls(
        self,
        key: bytes,
        server_hostname: bytes
    ):
        logger.info('starting fake TLS handshake ...')

        # https://datatracker.ietf.org/doc/html/rfc8446?utm_source=chatgpt.com#section-4.1.2
        stack = []
        buffer = bytearray()
        session_id = os.urandom(32)

        # https://github.com/DrKLO/Telegram/blob/ddc90f16be1ab952114005347e0102365ba6460b/TMessagesProj/jni/tgnet/ConnectionSocket.cpp#L134
        grease = bytearray(os.urandom(_MAX_GREASE))
        for i in range(_MAX_GREASE):
            g = (grease[i] & 0xF0) + 0x0A

            if i % 2 == 1 and g == grease[i - 1]:
                g ^= 0x10

            grease[i] = g

        def _write_ops(ops):
            for op, value in ops:
                if op == 'k':
                    buffer.extend(_generate_public_key())

                elif op == 'id':
                    buffer.extend(session_id)   

                elif op == 'zero':
                    buffer.extend(b'\x00' * value)

                elif op == 'string':
                    buffer.extend(value)

                elif op == 'grease':
                    g = grease[value]
                    buffer.extend(bytes([g, g]))

                elif op == 'domain':
                    buffer.extend(server_hostname[:253])

                elif op == 'begin_scope':
                    stack.append(len(buffer))
                    buffer.extend(b'\x00\x00') 

                elif op == 'end_scope':
                    start = stack.pop()
                    length = len(buffer) - start - 2
                    buffer[start] = (length >> 8) & 0xFF
                    buffer[start + 1] = length & 0xFF

                elif op == 'permutation':
                    parts = deepcopy(value)
                    random.shuffle(parts)
                    for part in value:
                        _write_ops(part)

        _write_ops(_TLS_HELLO_OPS)

        # add padding
        length = len(buffer)
        if length > 515:
            raise ConnectionError('handshake buffer too large for padding')

        pad_size = 515 - len(buffer)
        buffer.extend(pad_size.to_bytes(2, 'big') + b'\x00' * pad_size)
        logger.debug(
            'Added %d bytes padding, final handshake buffer size: %d bytes',
            pad_size,
            len(buffer)
        )

        # set random
        # https://github.com/DrKLO/Telegram/blob/ddc90f16be1ab952114005347e0102365ba6460b/TMessagesProj/jni/tgnet/ConnectionSocket.cpp#L888
        digest = bytearray(
            hmac.new(
                key,
                buffer,
                digestmod=hashlib.sha256
            )
            .digest()
        )

        old_value = int.from_bytes(
            digest[28: 32],
            'little'
        )
        new_value = old_value ^ int(time.time())
        digest[28: 32] = new_value.to_bytes(4, 'little')
        buffer[11: 11 + 32] = client_random = digest[:32]

        logger.debug('client random generated: %s', client_random.hex())

        try:
            logger.debug('sending fake TLS client hello: %d bytes', len(buffer))

            self._writer.write(buffer)
            await self._writer.drain()

        except Exception as exc:
            logger.error('Failed to send client hello: %s', exc)
            raise ConnectionError('Failed to send client hello') from exc

        else:
            logger.debug('client hello sent successfully')

        # receive server hello
        try:
            header, payload = await self._read_tls_record()

        except Exception as exc:
            logger.error('Failed to read server hello: %s', exc)
            raise ConnectionError('Failed to read server hello') from exc

        else:
            logger.debug('received server hello: %d bytes', len(payload))

        if len(payload) < 38:
            raise ConnectionError('server hello too short')

        if payload[0] != 0x02: # server hello
            raise ConnectionError(
                f'unexpected handshake type: {hex(payload[0])}'
            )

        length = int.from_bytes(payload[1:4]) # `handshake` length
        if length + 4 != len(payload):
            raise ConnectionError('handshake length mismatch')

        major, minor = payload[4:6]
        version = (major << 8) | minor
        if version != 0x0303:
            raise ConnectionError(
                f'unexpected TLS version: {major}.{minor} ({hex(version)})'
            )

        # compute hash
        server_digest = payload[6: 38]
        payload_zeroed = bytearray(payload)
        payload_zeroed[6:38] = b'\x00' * 32

        #  change cipher spec record
        try:
            logger.debug('starting to read change cipher spec record.')
            next_header, next_payload = await self._read_tls_record()

        except Exception as exc:
            logger.error('Failed to read change cipher spec: %s', exc)
            raise ConnectionError(
                'Failed to read change cipher spec'
            ) from exc

        else:
            if next_header[0] != 0x14:
                raise ConnectionError(
                    f'unexpected TLS record: {hex(next_header[0])}'
                )

            logger.debug('change cipher spec received')
            payload_zeroed.extend(next_header + next_payload)

        # read app data (random bytes)
        try:
            logger.debug('starting to read random data.')
            next_header, next_payload = await self._read_tls_record()

        except Exception as exc:
            logger.error('Failed to read random data: %s', exc)
            raise ConnectionError(
                'Failed to read random data'
            ) from exc

        else:
            if next_header[0] != 0x17:
                raise ConnectionError(
                    f'unexpected TLS record: {hex(next_header[0])}'
                )

            logger.debug(
                'random data received: %d bytes',
                len(next_payload)
            )
            payload_zeroed.extend(next_header + next_payload)

        computed_digest = (
            hmac.new(
                key,
                client_random + header + payload_zeroed,
                digestmod=hashlib.sha256
            )
            .digest()
        )

        if server_digest != computed_digest:
            raise ConnectionError('TLS hash mismatch')

        self._is_fake_tls = True
        logger.debug('Fake TLS handshake completed successfully')

    async def _read_tls_record(self):

        try:
            header = await self._reader.readexactly(5)
            if len(header) < 5:
                raise ConnectionError('unexpected EOF in TLS header')

            content, major, minor, msb, lsb = header
            version = (major << 8) | minor

            if version != 0x0303:
                raise ConnectionError(
                    f'unexpected TLS version: {major}.{minor} ({hex(version)})'
                )

            length = (msb << 8) | lsb
            if length > 64 * 1024 - 5:
                raise ConnectionError(f'TLS record too large: {length=}')

            logger.debug(
                'read TLS record: type=%s, version=%s, length=%d',
                hex(content),
                hex(version),
                length
            )

            payload = await self._reader.readexactly(length)
            if content == 0x16: # handshake
                if self._is_fake_tls:
                    raise ConnectionError(
                        'unexpected handshake record after handshake'
                    )

                return header, payload

            elif content in (0x14, 0x17):
                return header, payload

            else:
                # 0x15: alert ?
                raise ConnectionError(
                    f'unexpected TLS record type: {hex(content)}'
                )

        except Exception as exc:
            logger.error('Failed to read TLS record: %s', exc)
            raise

    async def _get_address_info(self, host: str, port: int):
        loop = asyncio.get_running_loop()
        result = await loop.getaddrinfo(
            host,
            port,
            type=socket.SOCK_STREAM,
            proto=socket.IPPROTO_TCP,
            flags=socket.AI_ADDRCONFIG,
            family=socket.AF_UNSPEC
        )

        if not result:
            raise OSError(f'Failed to resolve {host}:{port}')

        return result[0][0], result[0][4][0]

    # static methods
    @staticmethod
    async def _close_writer(
        writer: asyncio.StreamWriter,
        *,
        timeout: t.Optional[float] = None
    ):
        logger.debug('Closing writer stream...')
        writer.close()

        # https://docs.python.org/3/library/asyncio-stream.html#asyncio.StreamWriter.wait_closed
        if sys.version_info >= (3, 7):
            try:
                await asyncio.wait_for(
                    writer.wait_closed(),
                    timeout=timeout
                )
                logger.debug('Writer stream closed successfully')
            except Exception as exc:
                logger.warning('Error while closing writer: %s', exc)

    @staticmethod
    async def _open_connection(
        host: str,
        port: int,
        *,
        timeout: t.Optional[float] = None,
    ) -> t.Tuple[asyncio.StreamReader, asyncio.StreamWriter]:

        coro = asyncio.open_connection(
            host,
            port
        )

        return await asyncio.wait_for(
            coro,
            timeout=timeout
        )

    # proxies 
    async def _negotiate_proxy(
        self,
        reader: asyncio.StreamReader,
        writer: asyncio.StreamWriter
    ):
        if self._proxy.type is ProxyType.HTTP:
            await self._negotiate_http_proxy(reader, writer)

        elif self._proxy.type is ProxyType.HTTPS:
            await self._negotiate_https_proxy(reader, writer)

        elif self._proxy.type is ProxyType.SOCKS4:
            await self._negotiate_socks4_proxy(reader, writer)

        elif self._proxy.type is ProxyType.SOCKS5:
            await self._negotiate_socks5_proxy(reader, writer)

    # https://datatracker.ietf.org/doc/rfc9484/
    async def _negotiate_http_proxy(
        self,
        reader: asyncio.StreamReader,
        writer: asyncio.StreamWriter
    ):
        try:
            logger.info(
                'HTTP negotiate started for "%s:%d"',
                self._host, self._port
            )
            # CONNECT {host}:{port} HTTP/1.1\r\nHost: {host}
            host = (
                self._host
                if self._proxy.rdns else 
                socket.gethostbyname(self._host)
            )

            message = http.Message(
                method='CONNECT',
                path=f'{host}:{self._port}',
                headers={
                    'Host': self._host
                }
            )

            username = self._proxy.username
            password = self._proxy.password
            if username and password:
                proxy_auth = (
                    base64.b64encode(
                        bytes(f'{username}:{password}', 'utf-8')
                    )
                    .decode('utf-8')
                )

                message.headers['Proxy-Authorization'] = proxy_auth

            writer.write(message.to_bytes())
            await writer.drain()

            response = await http.Message.from_reader(
                reader,
                request=message
            )

            if not response.is_response:
                raise ValueError(
                    'Invalid server response (not an HTTP response)'
                )

            if response.status != 200:
                raise ValueError(
                    f'Invalid status code: {response.status}, {response.reason}'
                )

            logger.info(
                'HTTP proxy connected to "%s:%d"',
                self._host, self._port
            )

        except Exception as exc:
            await self._close_writer(writer)
            raise ProxyError('HTTP proxy negotiate failed') from exc

    async def _negotiate_https_proxy(
        self,
        reader: asyncio.StreamReader,
        writer: asyncio.StreamWriter
    ):
        # `https` proxy behaves like `http` proxy but requires `ssl` layer.
        if self._proxy.type is ProxyType.HTTPS:
            await self._start_tls(
                reader,
                writer,
                server_hostname=self._proxy.host
            )

        await self._negotiate_http_proxy(reader, writer)

    # https://www.openssh.com/txt/socks4.protocol
    async def _negotiate_socks4_proxy(
        self,
        reader: asyncio.StreamReader,
        writer: asyncio.StreamWriter 
    ):
        try:
            logger.info(
                'SOCKS4 negotiate started for "%s:%d"',
                self._host, self._port
            )

            is_socks4a = False
            try:
                dst_host = socket.inet_aton(self._host)

            except socket.error:
                if self._proxy.rdns:
                    logger.debug(
                        'using socks4a for host: %s',
                        self._host
                    )
                    dst_host = b'\x00\x00\x00\x01' # 0.0.0.x (socks4a)
                    is_socks4a = True

                else:
                    dst_host = socket.inet_aton(
                        socket.gethostbyname(self._host)
                    )

            # version, connect-cmd, dst-port
            writer.write(b'\x04\x01' + self._port.to_bytes(2)) # bytes([0x04, 0x01])
            writer.write(dst_host) # dst_host

            if self._proxy.username: # user_id
                writer.write(bytes(self._proxy.username, 'idna'))

            writer.write(b'\x00') # null
            # https://www.openssh.com/txt/socks4a.protocol
            if is_socks4a:
                writer.write(bytes(self._host, 'idna') + b'\x00')

            await writer.drain()
            logger.debug('SOCKS4 connect request sent')

            vn, status = await reader.readexactly(2)
            if vn != 0x00:
                raise ValueError('Invalid reply data (vn != 0)')

            if status != 0x5a:
                replies = {
                    0x5b: 'request rejected or failed',
                    0x5c: (
                        'request rejected becasue SOCKS server '
                        'cannot connect to identd on the client'
                    ),
                    0x5d: (
                        'request rejected because the client '
                        'program and identd report different user-ids'
                    )
                }
                msg = replies.get(status, f'Unknown error: {hex(status)}')
                raise IOError(msg)

            await reader.readexactly(6) # dsthost + dstport
            logger.info(
                'SOCKS4 proxy connected to "%s:%d"',
                self._host, self._port
            )

        except Exception as exc:
            await self._close_writer(writer)
            raise ProxyError('SOCKS4 proxy negotiate failed') from exc

    # https://datatracker.ietf.org/doc/html/rfc1928
    async def _negotiate_socks5_proxy(
        self,
        reader: asyncio.StreamReader,
        writer: asyncio.StreamWriter
    ):
        try:
            logger.info(
                'SOCKS5 negotiate started for "%s:%d"',
                self._host, self._port
            )

            username = self._proxy.username
            password = self._proxy.password

            methods = [0x00]
            if username and password:
                methods.append(0x02)

            # version, method-length, methods
            data = bytes([0x05, len(methods)] + methods)

            logger.debug('sending SOCKS5 auth methods: %s', methods)

            writer.write(data)
            await writer.drain()

            version, chosen = await reader.readexactly(2)

            if version != 0x05:
                raise ValueError(
                    f'Invalid reply SOCKS version: {hex(version)}'
                )

            if chosen not in methods: # 0xFF
                raise ValueError(
                    'SOCKS5 server rejected all auth methods'
                )

            logger.debug('server selected auth method: %r', hex(chosen))
            if chosen == 0x02:
                # connect-cmd, username, password
                data = (
                    b'\x01'
                    + _lp_encoding(username)
                    + _lp_encoding(password)
                )

                writer.write(data)
                await writer.drain()

                r1, r2 = await reader.readexactly(2)

                if r1 != 0x01 or r2 != 0x00:
                    raise OSError('Proxy auth failed')

            # version, connect-cmd, reserved (0x00)
            writer.write(b'\x05\x01\x00')
            logger.debug(
                'sending connect request to "%s:%d"',
                self._host, self._port
            )

            # https://datatracker.ietf.org/doc/html/rfc1928#section-5
            for family in (socket.AF_INET, socket.AF_INET6):
                try:
                    dst_host = socket.inet_pton(family, self._host)

                except socket.error:
                    pass

                else:
                    writer.write(
                        b'\x01' # ipv4
                        if family is socket.AF_INET else 
                        b'\x04' # ipv6
                    )

                    writer.write(dst_host)        
                    break

            else:
                # if `rdns` is enabled, send hostname
                if self._proxy.rdns:
                    logger.debug('using rdns for host: %s', self._host)

                    writer.write(b'\x03') # domain
                    writer.write(_lp_encoding(self._host.encode('idna')))

                else:
                    # resolve hostname
                    family, dst_host = await self._get_address_info(
                        self._host,
                        self._port
                    )
                    writer.write(
                        b'\x01'
                        if family is socket.AF_INET else 
                        b'\x04'
                    )

                    writer.write(socket.inet_pton(family, dst_host))

            writer.write(self._port.to_bytes(2, byteorder='big')) # dst port

            await writer.drain()
            version, reply, _ = await reader.readexactly(3)

            if version != 0x05:
                raise ValueError(
                    f'Invalid reply SOCKS version: {hex(version)}'
                )

            # https://datatracker.ietf.org/doc/html/rfc1928#section-6
            if reply != 0x00:
                replies = {
                    0x01: 'general SOCKS server failure',
                    0x02: 'connection not allowed by ruleset',
                    0x03: 'Network unreachable',
                    0x04: 'Host unreachable',
                    0x05: 'Connection refused',
                    0x06: 'TTL expired',
                    0x07: 'Command not supported',
                    0x08: 'Address type not supported',
                }
                msg = replies.get(reply, f'Unknown error: {hex(reply)}')
                raise OSError(msg)

            atyp = ord(await reader.readexactly(1))
            if atyp == 0x03: # domain
                length = int.from_bytes(await reader.readexactly(1))

            else:
                # ipv4, ipv6
                length = 4 if atyp == 0x01 else 16

            await reader.readexactly(length + 2) # + port
            logger.info(
                'SOCKS5 proxy connected to "%s:%d"',
                self._host, self._port
            )

        except Exception as exc:
            await self._close_writer(writer)
            raise ProxyError('SOCKS5 proxy negotiate failed') from exc

class BaseMTProtoTransport(ABC):
    tag: bytes = None
    obfuscate: bool = False

    def __init__(
        self,
        connection: Connection,
        *,
        proxy: t.Optional[Proxy] = None

    ):
        self._connection = connection
        self._proxy = proxy

        self._buffer = bytearray()
        self._encryptor = None
        self._decryptor = None
        self._transport: Transport = None

    @property
    def dc_id(self):
        return self._connection.dc_id

    @property
    def connection(self):
        return self._connection    

    def is_connected(self):
        return self._transport.is_connected()

    def set_transport(self, transport: Transport):
        self._transport = transport

    #
    async def init(self):
        if self.tag is None:
            return 

        if self.obfuscate:
            secret = None
            protocol_id = (self.tag * 4)[:4]

            if self._proxy and self._proxy.type is ProxyType.MTProto:
                proto, secret, sni = _decode_mtproto_proxy_secret(
                    self._proxy.secret
                )

                if proto == 0xee:
                    await self._transport._start_fake_tls(
                        secret,
                        server_hostname=sni
                    )

            while True:
                init = os.urandom(56)

                if init[0] == 0xEF:
                    continue

                if init[:4] in {
                    b'HEAD',   # 0x44414548
                    b'POST',   # 0x54534f50
                    b'GET ',   # 0x20544547
                    b'OPTI',   # 0x4954504f
                    b'\x02\x01\x03\x16',
                    b'\xdd\xdd\xdd\xdd',  # padded intermediate
                    b'\xee\xee\xee\xee',  # intermediate
                }:
                    continue

                if init[4: 8] == b'\x00' * 4:
                    continue

                init += (
                    protocol_id
                    + (self.dc_id).to_bytes(
                        2,
                        'little',
                        signed=True
                    )
                    + os.urandom(2)
                )

                break

            init_rev = init[::-1]
            enc_key, enc_nonce = init[8:40], init[40:56]
            dec_key, dec_nonce = init_rev[8:40], init_rev[40:56]

            if secret is not None:
                enc_key = hashlib.sha256(enc_key + secret).digest()
                dec_key = hashlib.sha256(dec_key + secret).digest()

            encryptor = Aes256Ctr(
                enc_key,
                enc_nonce
            )

            decryptor = Aes256Ctr(
                dec_key,
                dec_nonce
            )
            header = init[:56] + encryptor(init)[56: 64]

            await self.write(header)
            self._encryptor = encryptor
            self._decryptor = decryptor

        else:
            await self.write(self.tag)

    async def read(self, n: int):
        data = await self._transport.read(n)
        if self._decryptor:
            data = self._decryptor(data)

        return data

    async def write(self, data: bytes):
        if self._encryptor:
            data = self._encryptor(data)

        await self._transport.write(data)

    async def disconnect(self, exc: t.Optional[Exception] = None):
        await self._transport.disconnect(exc)

    @abstractmethod
    async def connect(self, *, timeout: t.Optional[float] = None):
        raise NotImplementedError

    @abstractmethod
    async def read_packet(self) -> bytes:
        raise NotImplementedError

    @abstractmethod
    async def send_packet(self, data: bytes):
        raise NotImplementedError

# +-+----...----+
# |l|  payload  |
# +-+----...----+
# OR
# +-+---+----...----+
# |h|len|  payload  +
# +-+---+----...----+
class BaseAbridgedTransport(BaseMTProtoTransport):
    """
    [Abridged](https://core.telegram.org/mtproto/mtproto-transports#abridged) Transport
    (Overhead Very small)
    """
    tag = b'\xef'

    async def read_packet(self):
        first_byte = await self.read(1)

        if first_byte == b'\x7f':
            length = await self.read(3)
            length = int.from_bytes(length, 'little')

        else:
            length = ord(first_byte)

        length *= 4
        result = await self.read(length)

        if length == 4: # 32-bit number
            error_code = Int.from_bytes(result)
            if error_code < 0:
                raise TransportError.from_code(abs(error_code))

        return result

    async def send_packet(self, data):

        length = len(data) // 4
        if length < 127:
            length_byte = length.to_bytes(1, 'little')

        else:
            length_byte = (
                b'\x7f'
                + length.to_bytes(3, 'little')
            )

        await self.write(length_byte + data)

# +----+----...----+
# +len.+  payload  +
# +----+----...----+
class BaseIntermediateTransport(BaseMTProtoTransport):
    """
    [Intermediate](https://core.telegram.org/mtproto/mtproto-transports#intermediate) Transport
    (Overhead small)
    """
    tag = b'\xee\xee\xee\xee'

    async def read_packet(self):
        length = Int.from_bytes(
            await self.read(4)
        )
        result = await self.read(length)
        if length == 4: # 32-bit n
            error_code = Int.from_bytes(result)
            if error_code < 0:
                raise TransportError.from_code(abs(error_code))

        return result

    async def send_packet(self, data):
        length = len(data)
        await self.write(Int.to_bytes(length) + data)

# +----+----...----+----...----+
# |tlen|  payload  |  padding  |
# +----+----...----+----...----+
class BasePaddedIntermediateTransport(BaseIntermediateTransport):
    """
    [Padded intermediate](https://core.telegram.org/mtproto/mtproto-transports#padded-intermediate) Transport
    (Overhead small-medium)
    """

    tag = b'\xdd\xdd\xdd\xdd'

    async def send_packet(self, data):
        return await super().send_packet(
            data + os.urandom(random.randint(0, 3))
        )

    async def read_packet(self):
        result = await super().read_packet()

        padding = len(result) % 4
        if padding > 0:
            return result[: -padding]

        return result
