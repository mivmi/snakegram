from __future__ import annotations

import typing as t
from .transport import _decode_mtproto_proxy_secret

if t.TYPE_CHECKING:
    from .. import Connection
    from ...models import Proxy

from .tcp import (
    FullTcpTransport,
    AbridgedTcpTransport,
    IntermediateTcpTransport,
    PaddedIntermediateTcpTransport,
    ObfuscatedAbridgedTcpTransport,
    ObfuscatedIntermediateTcpTransport,
    ObfuscatedPaddedIntermediateTcpTransport
)

from .web_socket import (
    AbridgedWsTransport,
    AbridgedWssTransport,
    IntermediateWsTransport,
    IntermediateWssTransport,
    PaddedIntermediateWsTransport,
    PaddedIntermediateWssTransport
)


def auto_transport_factory(connection: Connection, *, proxy: Proxy = None):
    if proxy and proxy.secret is not None: # mtproto
        proto = _decode_mtproto_proxy_secret(proxy.secret)[0]
        if proto in (0xee, 0xdd):
            return ObfuscatedPaddedIntermediateTcpTransport(
                connection,
                proxy=proxy
            )

        return ObfuscatedAbridgedTcpTransport(
            connection,
            proxy=proxy
        )

    return AbridgedTcpTransport(connection, proxy=proxy)
     

__all__ = [
    'FullTcpTransport',
    'AbridgedTcpTransport',
    'IntermediateTcpTransport',
    'PaddedIntermediateTcpTransport',
    'ObfuscatedAbridgedTcpTransport',
    'ObfuscatedIntermediateTcpTransport',
    'ObfuscatedPaddedIntermediateTcpTransport',
 
    # websocket transports
    'AbridgedWsTransport',
    'AbridgedWssTransport',
    'IntermediateWsTransport',
    'IntermediateWssTransport',
    'PaddedIntermediateWsTransport',
    'PaddedIntermediateWssTransport',
    'auto_transport_factory'
]
