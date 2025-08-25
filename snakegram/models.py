import asyncio
import typing as t
import threading

from . import enums, errors
from .tl import types
from .gadgets.utils import to_string, Local

if t.TYPE_CHECKING:
    from .core import Telegram
    from .alias import Phone, Username
    from .network.utils import Request
    from .gadgets.byteutils import TLObject

class FileInfo:
    def __repr__(self):
        return self.to_string()

    def to_dict(self):
        return {
            'location': self.location,
            'dc_id': self.dc_id,
            'file_size': self.file_size,
            'file_name': self.file_name
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent)

    def __init__(
        self,
        location: types.TypeInputFileLocation,
        *,
        dc_id: t.Optional[int] = None,
        file_size: int = -1,
        file_name: t.Optional[str] = None
    ):

        self.dc_id = dc_id
        self.location = location
        self.file_size = file_size
        self.file_name = file_name

class UserEntity:
    def __repr__(self):
        return self.to_string()

    def to_dict(self):
        return {
            'id': self.id,
            'access_hash': self.access_hash,
            'name': self.name,
            'is_bot': self.is_bot,
            'is_self': self.is_self,
            'phone': self.phone,
            'username': self.username
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent)

    def __init__(
        self,
        id: int,
        access_hash: int,
        name: str,
        is_bot: bool,
        is_self: bool,
        *,
        phone: t.Optional['Phone'] = None,
        username: t.Optional['Username'] = None,
    ):

        self.id = id
        self.access_hash = access_hash
        self.name = name
        self.is_bot = is_bot
        self.is_self = is_self

        self.phone = phone
        self.username = username

    def to_input_peer(self):
        return types.InputPeerUser(
            self.id,
            access_hash=self.access_hash or 0
        )

class ChannelEntity:
    def __repr__(self):
        return self.to_string()

    def to_dict(self):
        return {
            'id': self.id,
            'access_hash': self.access_hash,
            'title': self.title,
            'username': self.username
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent)

    def __init__(
        self,
        id: int,
        access_hash: int,
        title: str,
        *,
        username: t.Optional['Username'] = None
    ):

        self.id = id
        self.access_hash = access_hash

        self.title = title
        self.username = username

    def to_input_peer(self):
        return types.InputPeerChannel(
            self.id,
            access_hash=self.access_hash or 0
        )

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
        entity: t.Optional['ChannelEntity'] = None
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

class EventExtra:
    def __init__(self):
        self._data = {}
        self._lock = threading.Lock()

    def set(self, name, value):
        with self._lock:
            self._data[name] = value

    def get(self, name, default=None):
        with self._lock:
            return self._data.get(name, default)

    def all(self):
        with self._lock:
            return dict(self._data)

    def delete(self, name):
        with self._lock:
            self._data.pop(name, None)

class EventContext:
    def __bool__(self):
        return self.client is not None

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
        type: t.Optional[enums.EventType] = None,
        data: t.Optional[t.Any] = None,
        *,
        request: t.Optional['Request'] = None
    ):
        self.client = client

        #
        self._type = type
        self._data = data
        
        error = None
        result = None
        update = None
        
        if self.is_error:
            error = data
            if (
                request is None
                and isinstance(error, errors.RpcError)
            ):
                request = error.request

        if self.is_result:
            result = data
        
        if self.is_update:
            update = data

        if self.is_request:
            request = data

        self._error = error
        self._result = result
        self._update = update
        self._request = request

    @property
    def type(self):
        return self._type

    @property
    def data(self):
        return self._data
    
    @property
    def extra(self):
        return self.client.extra if self.client else None

    @property
    def error(self) -> t.Optional[Exception]:
        return self._error
    
    @property
    def update(self) -> t.Optional[types.update.TypeUpdate]:
        return self._update
    
    @property
    def result(self) -> t.Optional['TLObject']:
        return self._result
    
    @property
    def request(self) -> t.Optional['Request']:
        return self._request
    
    # flags
    @property
    def is_error(self):
        return self.type is enums.EventType.Error

    @property
    def is_result(self):
        return self.type is enums.EventType.Result

    @property
    def is_update(self):
        return self.type is enums.EventType.Update

    @property
    def is_request(self):
        return self.type is enums.EventType.Request

class MessageEntity:
    def __repr__(self):
        return self.to_string()
    
    def to_dict(self):
        return {
            'type': self.type,
            'offset': self.offset,
            'length': self.length,
            'data': self.data,
            'user_id': self.user_id,
            'custom_emoji_id': self.custom_emoji_id
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent=indent)

    def __init__(
        self,
        type: enums.MessageEntityType,
        offset: int,
        length: int,
        *,
        data: t.Optional[str] = None,
        user_id: t.Optional[int] = None,
        custom_emoji_id: t.Optional[int] = None,
    ):

        self.type = type
        self.offset = offset
        self.length = length
        
        self.data = data
        self.user_id = user_id
        self.custom_emoji_id = custom_emoji_id

class UpdateTracker:
    def __init__(self):
        self._random = {}
        self._pending = {}

    def add_random(
        self,
        id: int,
        peer_id: int,
        *,
        future: asyncio.Future = None
    ) -> asyncio.Future:
        if future is None:
            future = asyncio.Future()
        self._random[id] = (peer_id, future)

        return future

    def pop_random(self, id: int) -> t.Optional[t.Tuple[int, asyncio.Future]]:
        return self._random.pop(id, None)

    def add_message(
        self,
        id: int,
        peer_id: int,
        *,
        future: asyncio.Future = None
    ) -> asyncio.Future:
        if future is None:
            future = asyncio.Future()

        self._pending[(id, peer_id)] = future
        return future

    def pop_message(self, id: int, peer_id: int) -> t.Optional[asyncio.Future]:
        return self._pending.pop((id, peer_id), None)


_local_event: EventContext = Local(default=EventContext())
