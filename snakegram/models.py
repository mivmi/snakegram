import typing as t

from .tl import types
from .enums import EntityType
from .gadgets.utils import to_string


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
        type: t.Optional[EntityType],
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
        return self.type is EntityType.BOT


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