import typing as t

from . import enums
from .tl import types
from .gadgets.utils import to_string, Local

if t.TYPE_CHECKING:
    from .core import Telegram
    from .network.utils import Request
    from .gadgets.byteutils import TLObject


class Entity:
    def __repr__(self):
        return self.to_string()

    def to_dict(self):
        return {
            'id': self.id,
            'type': self.type,
            'access_hash': self.access_hash,
            'name': self.name,
            'is_self': self.is_self,
            'username': self.username,
            'phone_number': self.phone_number
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent)

    def __init__(
        self,
        id: int,
        type: t.Optional[enums.EntityType],
        access_hash: t.Optional[int],
        *,
        name: t.Optional[str] = None,
        is_self: t.Optional[bool] = None,
        username: t.Optional[str] = None,
        phone_number: t.Optional[str] = None
    ):
        
        self.id = id
        self.type = type
        self.access_hash = access_hash

        self.name = name
        self.is_self = bool(is_self)
        self.username = username
        self.phone_number = phone_number

    @property
    def is_bot(self):
        return self.type is enums.EntityType.Bot


# state
class StateId:
    def __eq__(self, value):
        return (
            isinstance(value, StateId)
            and self.channel_id == value.channel_id
        )

    def __repr__(self):
        return f'StateId({(self.channel_id or "COMMON")!r})'

    def __hash__(self):
        return hash(self.channel_id)

    def to_dict(self):
        return {
            'channel_id': self.channel_id
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent)

    def __init__(self, channel_id: t.Optional[int] = None):
        self.channel_id = channel_id

class StateInfo:
    def __repr__(self):
        return self.to_string()

    def to_dict(self):
        return {
            'pts': self.pts,
            'qts': self.qts,
            'seq': self.seq,
            'date': self.date,
            'entity': self.entity
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent)

    def __init__(
        self,
        pts: int,
        qts: t.Optional[int] = None,
        seq: t.Optional[int] = None,
        date: t.Optional[int] = None,
        entity: t.Optional['Entity'] = None
    ):
        self.pts = pts
        self.qts = qts 
        self.seq = seq 
        self.date = date
        self.entity = entity

    @property
    def channel_id(self):
        if self.entity:
            return self.entity.id
            
    @property
    def is_channel(self):
        return self.entity is not None

    def to_input_channel(self):
        if self.entity is not None:
            return types.InputChannel(
                self.entity.id,
                access_hash=self.entity.access_hash
            )

class EventContext:
    def __bool__(self):
        return bool(self._client)

    def __repr__(self):
        return self.to_string()

    def to_dict(self):
        return {
            'type': self.type,
            'client': self.client,
            'error': self.error,
            'result': self.result,
            'update': self.update,
            'request': self.request 
        }
    
    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent=indent)

    def __init__(
        self,
        client: t.Optional['Telegram'] = None,
        *,
        error: t.Optional[Exception] = None,
        result: t.Optional['TLObject'] = None,
        update: t.Optional[types.TypeUpdate] = None,
        request: t.Optional['Request'] = None
    ):
        
        self.client = client
        self.error = error
        self.result = result
        self.update = update
        self.request = request

    @property
    def type(self) -> enums.EventType:
        if self.client is None:
            return enums.EventType.Null

        elif self.error is not None:
            return enums.EventType.Error
        
        elif self.result is not None:
            return enums.EventType.Result
        
        elif self.update is not None:
            return enums.EventType.Update
        
        else:
            return enums.EventType.Request

    @property
    def data(self):
        return (
            self.error 
            or self.result
            or self.update
            or self.request
            or None
        )

    def is_set(self):
        return self.type is not enums.EventType.Null

    def is_error(self):
        return self.type is enums.EventType.Error

    def is_result(self):
        return self.type is enums.EventType.Result

    def is_update(self):
        return self.type is enums.EventType.Update

    def is_request(self):
        return self.type is enums.EventType.Request

    @classmethod
    def _set_event(
        cls,
        client: t.Optional['Telegram'] = None,
        *,
        error: t.Optional[Exception] = None,
        result: t.Optional['TLObject'] = None,
        update: t.Optional[types.TypeUpdate] = None,
        request: t.Optional['Request'] = None
    ):
        _local_event._ctx.set(
            cls(
                client,
                error=error,
                result=result,
                update=update,
                request=request
            )
        )


class MessageEntity:
    def __repr__(self):
        return self.to_string()
    
    def to_dict(self):
        return {
            'type': self.type,
            'offset': self.offset,
            'length': self.length,
            'url': self.url,
            'user_id': self.user_id,
            'collapsed': self.collapsed,
            'lang_code': self.lang_code,
            'custom_emoji_id': self.custom_emoji_id
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent=indent)

    def __init__(
        self,
        type: enums.MessageEntityType,
        offset: int,
        length: int,
        url: t.Optional[str] = None,
        user_id: t.Optional[int] = None,
        collapsed: t.Optional[bool] = None,
        lang_code: t.Optional[str] = None,
        custom_emoji_id: t.Optional[int] = None,
    ):

        self.type = type
        self.offset = offset
        self.length = length
        
        self.url = url
        self.user_id = user_id
        self.collapsed = collapsed
        self.lang_code = lang_code
        self.custom_emoji_id = custom_emoji_id

_local_event: EventContext = Local(default=EventContext())
