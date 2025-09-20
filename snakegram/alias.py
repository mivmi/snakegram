from __future__ import annotations

import datetime
import typing as t
from pathlib import Path

from .tl import types # type: ignore
from .models import UserEntity, ChannelEntity

if t.TYPE_CHECKING:
    from .models import Proxy
    from .network import Connection
    from .network.transport.transport import BaseMTProtoTransport


class TransportFactory(t.Protocol):
    def __call__(
        self,
        connection: Connection,
        *,
        proxy: t.Optional[Proxy] = None,
    ) ->BaseMTProtoTransport: ...


LikeFile = t.Union[str, Path, t.BinaryIO]

LikeTime = t.Union[
    int,
    float,
    datetime.date,
    datetime.datetime,
    datetime.timedelta
]

ParseMode = t.Literal['html', 'md', 'markdown']

URL = t.NewType('URL', str)
Host = t.NewType('Host', str)
NetAddr = t.Tuple[Host, int]
Address = t.Union[URL, NetAddr]

#
Phone = t.NewType('Phone', str)
Token = t.NewType('Token', str)
PhoneOrToken = t.Union[Phone, Token]

#
UserId = t.NewType('UserId', int)
ChatId = t.NewType('ChatId', int)
ChannelId = t.NewType('ChannelId', int)

Username = t.NewType('Username', str)

AnyPeerId = t.Union[UserId, ChatId, ChannelId]
LikeEntity = t.Union[
    str,
    int,
    types.TypePeer,
    types.TypeInputPeer
]

StoredEntityType = t.Union[UserEntity, ChannelEntity]
