import datetime
import typing as t
from pathlib import Path

from .tl import types # type: ignore

LikeFile: t.TypeAlias = t.Union[
    str,
    Path,
    t.BinaryIO,
    types.TypeInputFile,
    types.TypeMessageMedia,
    types.TypeInputFileLocation
]
EventType: t.TypeAlias = t.Literal['error', 'result', 'update', 'request']

LikeTime: t.TypeAlias = t.Union[
    int,
    float,
    datetime.date,
    datetime.datetime,
    datetime.timedelta
]

ParseMode: t.TypeAlias = t.Literal['html', 'md', 'markdown']

URL = t.NewType('URL', str)
Host = t.NewType('Host', str)
NetAddr: t.TypeAlias = t.Tuple[Host, int]
Address: t.TypeAlias = t.Union[URL, NetAddr]

#
Phone = t.NewType('Phone', str)
Token = t.NewType('Token', str)
PhoneOrToken: t.TypeAlias = t.Union[Phone, Token]

#
UserId = t.NewType('UserId', int)
ChatId = t.NewType('ChatId', int)
ChannelId = t.NewType('ChannelId', int)

Username = t.NewType('Username', str)

AnyPeerId: t.TypeAlias = t.Union[UserId, ChatId, ChannelId]
LikeEntity: t.TypeAlias = t.Union[
    str,
    int,
    types.TypePeer,
    types.TypeInputPeer
]
