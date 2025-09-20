from __future__ import annotations

import asyncio
import ipaddress
import typing as t
from urllib.parse import urlparse
from collections import OrderedDict
from collections.abc import Mapping, MutableMapping

from .utils import to_string

T = t.TypeVar('T')

MAX_HEADER_LINE = 8192
MAX_HEADER_COUNT = 100
MAX_HEADERS_TOTAL = 65536


def get_hostname(url: str) -> str:
    result = urlparse(url)
    
    if result.hostname is None:
        raise ValueError('invalid url (no hostname).')
    
    try:
        ipaddress.ip_address(result.hostname)
    
    except ValueError:
        return result.hostname
    
    else:
        if result.scheme is None:
            raise ValueError('invalid url (no scheme).')

        if result.port is None:
            scheme = result.scheme.lower()
            
            if scheme in {'ws', 'http'}:
                port = 80

            elif scheme in {'wss', 'https'}:
                port = 443

            else:
                raise ValueError(f'unknown scheme: {scheme!r}')

        else:
            port = result.port

        return f'{result.hostname}:{port}'



class Headers(MutableMapping[str, str]):
    def __init__(self, initial=None):
        self._data = OrderedDict()
        if initial is not None:
            self.update(initial)

    def copy(self):
        return Headers(dict(self.items()))

    def to_dict(self):
        return dict(self.items())

    def get_lower(self, key):
        return self.get(key, '').lower()

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self.to_dict(), indent=indent)

    def to_bytes(self):
        lines = []
        
        for _, (key, value) in self._data.items():
            lines.append(f'{key}: {value}')

        return bytes('\r\n'.join(lines), 'iso-8859-1')

    @staticmethod
    async def from_reader(reader: asyncio.StreamReader):
        headers = Headers()
        count = 0
        total_size = 0

        while True:
            line = await reader.readline()
            if line in (b'\r\n', b'\n', b''):
                break
            
            count += 1
            total_size += len(line)

            if (
                len(line) > MAX_HEADER_LINE
                or
                count > MAX_HEADER_COUNT
                or
                total_size > MAX_HEADERS_TOTAL
            ):
                raise ValueError('HTTP headers too large')
            
            data = str(line, 'iso-8859-1')
            item = data.split(':', maxsplit=1)
            
            if len(item) != 2:
                raise ValueError(f'Invalid header line: {data!r}')

            headers[item[0].strip()] = item[1].strip()

        return headers

    def __eq__(self, other):
        if isinstance(other, Mapping):
            def wrapper(data: Headers):
                return (
                    (key, value[1])
                    for (key, value) in dict(data).items()
                )
            
            other = Headers(other)
            return wrapper(self) == wrapper(other)

    def __repr__(self):
        return self.to_string()
    
    def __len__(self):
        return len(self._data)

    def __iter__(self):
        for lk, _ in self._data.values():
            yield lk

    def __getitem__(self, key):
        return self._data[key.lower()][1]

    def __delitem__(self, key):
        del self._data[key.lower()]

    def __setitem__(self, key, value):
        self._data[key.lower()] = (key, value)

class Message:
    def __repr__(self):
        return self.to_string()

    def to_dict(self):
        result = {
            'version': self.version,
            'headers': self.headers
        }
        if self.is_request:
            result.update(
                {
                    'method': self.method,
                    'path': self.path,
                }
            )
        elif self.is_response:
            result.update(
                {
                    'status': self.status,
                    'reason': self.reason,
                    'length': self.length,
                }
            )
        return result

    def to_bytes(self):
        v = '.'.join(map(str, self.version))
        if self.is_request:
            line = f'{self.method} {self.path} HTTP/{v}\r\n'
        else:
            if self.reason:
                line = f'HTTP/{v} {self.status} {self.reason}\r\n'
            else:
                line = f'HTTP/{v} {self.status}\r\n'

        return (
            bytes(line, 'iso-8859-1')
            + self.headers.to_bytes()
            + b'\r\n' * 2
        )

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent=indent)

    def __init__(
        self,
        *,
        method: t.Optional[str] = None,
        path: str = '/',
        length: t.Optional[int] = None,
        status: t.Optional[int] = None,
        reason: t.Optional[str] = None,
        version: t.Tuple[int, int] = (1, 1),
        headers: t.Optional['Mapping'] = None
    ):
        self.version = version
        self.headers = Headers(headers)

        # request
        self._method = (
            method.upper()
            if method else None
        )
        self.path = path
        self.length = length
        # response
        self.status = status
        self.reason = reason

    @property
    def is_request(self) -> bool:
        return self._method is not None

    @property
    def is_response(self) -> bool:
        return self.status is not None

    @property
    def method(self):
        return self._method

    @method.setter
    def method(self, value: str):
        self._method = value.upper()

    @classmethod
    async def from_reader(
        cls,
        reader: asyncio.StreamReader,
        request: t.Optional['Message'] = None
    ):

        while True:
            version, status, reason = await cls._read_status(reader)
            if status != 100:
                break
            await Headers.from_reader(reader)  # skip continue headers

        headers = await Headers.from_reader(reader)
        length_header = headers.get('content-length')

        if length_header and headers.get('transfer-encoding') != 'chunked':
            try:
                length = int(length_header)
                if length < 0:
                    length = None
            except ValueError:
                length = None
        else:
            length = None

        if (
            100 <= status < 200
            or status in (204, 304)
            or (request and request.method == 'HEAD')
        ):
            length = 0

        return cls(
            status=status,
            headers=headers,
            version=version,
            length=length,
            reason=reason or None
        )

    @staticmethod
    async def _read_status(reader: asyncio.StreamReader):
        line = str(await reader.readline(), 'iso-8859-1')
        if not line:
            raise ConnectionError('Empty response from server.')

        try:
            version, status, reason = line.split(None, 2)

        except ValueError:
            reason = ''
            try:
                version, status = line.split(None, 1)
            except ValueError:
                version = ''

        if not version.startswith('HTTP/'):
            raise ValueError(f'Invalid status line: {line}')

        version = version[5:]
        try:
            major, minor = (
                int(e)
                for e in version.split('.', maxsplit=1)
            )

        except Exception:
            raise ValueError(f'Invalid HTTP version format: {version!r}')

        try:
            status = int(status)
        except ValueError:
            raise ValueError(f'Invalid status code: {line}')

        return (major, minor), status, reason.strip()
