import re
import typing as t

from . import alias
from .tl import types
from .gadgets.utils import is_like_list

def parse_json(data):
    """
    Convert Python value to TL JSON object.

    Example:
    >>> parse_json({'key': 'value'})
    JsonObject([JsonObjectValue('key', JsonString('value'))])
    """
    if data is None:
        return types.JsonNull()

    elif isinstance(data, bool):
        return types.JsonBool(data)
    
    elif isinstance(data, str):
        return types.JsonString(data)

    elif isinstance(data, (int, float)):
        return types.JsonNumber(data)
    
    elif isinstance(data, dict):
        return types.JsonObject(
            [
                types.JsonObjectValue(
                    key=key,
                    value=parse_json(value)
                )
                for key, value in data.items()
            ]
        )

    elif is_like_list(data):
        return types.JsonArray(
            [parse_json(value) for value in data]
        )
    
    else:
        raise ValueError(f'Unsupported data type: {type(data).__name__!r}')

def parse_username(value: str) -> t.Optional[alias.Username]:
    """Remove username prefixes."""

    result = re.match(
        r'(?:@|https?://(?:t\.me|telegram\.me)/)?([a-z_][a-z0-9_]{4,32})',
        value.strip(),
        flags=re.IGNORECASE
    )
    if result:
        return alias.Username(result.group(1))

def parse_phone_number(value: t.Union[int, str]) -> t.Optional[alias.Phone]:
    """Remove `non-digit` characters from a phone number."""
    if value is not None:
        if isinstance(value, int):
            return alias.Phone(str(value))

        phone = ''.join(re.findall(r'\d+', value))
        if phone:
            return alias.Phone(phone)

#
def get_display_name(obj: t.Union[types.User, types.TypeChat]):
    """Computes the display name from a User's names or Chat title"""

    result = []
    if isinstance(obj, types.User):
        result.extend([obj.first_name, obj.last_name])
    
    else:
        result.append(getattr(obj, 'title', None))

    return ''.join(filter(None, result))

def get_active_username(obj: t.Union[types.User, types.TypeChat]) -> t.Optional[alias.Username]:
    """Get active username for a user or chat."""
    username = getattr(obj, 'username', None)
    if isinstance(username, str):
        return alias.Username(username)

    for item in (getattr(obj, 'usernames', None) or []):
        if item.active:
            return alias.Username(item.username)

def update_order_key(update) -> int:
    """get sort key for the update based on `pts`/`qts` for ordering."""

    pts = getattr(update, 'pts', None)
    if pts is not None:
        return pts - getattr(update, 'pts_count', 0)

    qts = getattr(update, 'qts', None)
    if qts is not None:
        return qts - 1

    return 0

def get_update_channel_id(update: types.update.TypeUpdate) -> t.Optional[int]:
    """get `channel_id` from a `types.update.TypeUpdate`, if available."""

    channel_id = getattr(update, 'channel_id', None)
    if channel_id is not None:
        return channel_id
    
    # from message
    message = getattr(update, 'message', None)
    if message:
        peer_id = getattr(message, 'peer_id', None)
        if isinstance(peer_id, types.PeerChannel):
            return peer_id.channel_id

#
def cast_to_peer(obj, *, raise_error: bool = True) -> t.Optional[types.TypePeer]:
    """Attempts to cast an `obj` to `types.TypePeer`"""
    
    if isinstance(obj, int):
        return get_peer_from_id(obj)

    elif isinstance(obj, types.TypePeer):
        return obj

    elif isinstance(obj, types.TypeUser):
        return types.PeerUser(obj.id)

    elif isinstance(obj, (types.Chat, types.ChatEmpty, types.ChatForbidden)):
        return types.PeerChat(obj.id)
    
    elif isinstance(obj, (types.Channel, types.ChannelForbidden)):
        return types.PeerChannel(obj.id)
    
    for attr, cls, in (
        ('peer', None),
        ('user_id', types.PeerUser),
        ('chat_id', types.PeerChat),
        ('channel_id', types.PeerChannel)
    ):
        value = getattr(obj, attr, None)
        if value is not None:
            if isinstance(value, types.TypePeer):
                return value

            if cls is not None:
                return cls(value)

    input_peer = cast_to_input_peer(obj, raise_error=False)
    if isinstance(
        input_peer,
        (
            types.InputPeerUser,
            types.InputUserFromMessage
        )
    ):
        return types.PeerUser(input_peer.user_id)

    if isinstance(input_peer, types.InputPeerChat):
        return types.PeerChat(input_peer.chat_id)

    if isinstance(
        input_peer,
        (
            types.InputPeerChannel,
            types.InputPeerChannelFromMessage
        )
    ):
        return types.PeerChannel(input_peer.channel_id)
    
    if raise_error:
        raise TypeError(
            f'Cannot cast {type(obj).__name__!r} to any kind of "types.TypePeer".'
        )

def get_peer_id(obj, *, mark: bool = False, raise_error: bool = True):
    """convert `obj` to `peer_id`"""
    peer = cast_to_peer(obj, raise_error=raise_error)

    if peer is not None:
        if isinstance(peer, types.PeerUser):
            return peer.user_id

        if isinstance(peer, types.PeerChat):
            return -peer.chat_id if mark else peer.chat_id

        return -(10 ** 12 + peer.channel_id) if mark else peer.channel_id

def get_peer_from_id(marked_id: int):
    """convert `marked_id` to `types.TypePeer`"""

    if marked_id >= 0:
        return types.PeerUser(marked_id)

    raw = abs(marked_id)
    if raw > 10 ** 12:
        return types.PeerChannel(raw - 10 ** 12)

    return types.PeerChat(raw)

#
def cast_to_input_peer(obj, *, raise_error: bool = True):
    """attempts to cast an `obj` to `types.TypeInputPeer`"""

    if isinstance(obj, types.TypeInputPeer):
        return obj

    if (
        isinstance(obj, types.InputUserSelf)
        or
        isinstance(obj, str) and obj.lower() == 'me'
    ):
        return types.InputPeerSelf()

    # user
    if isinstance(obj, types.User):
        return types.InputPeerUser(
            obj.id,
            access_hash=obj.access_hash
        )

    if isinstance(obj, types.InputUser):
        return types.InputPeerUser(
            obj.user_id,
            access_hash=obj.access_hash
        )

    if isinstance(obj, types.InputUserFromMessage):
        return types.InputPeerUserFromMessage(
            obj.peer,
            msg_id=obj.msg_id,
            user_id=obj.user_id
        )

    if isinstance(
        obj,
        (
            types.UserEmpty,
            types.InputUserEmpty,
            types.InputChannelEmpty
        )
    ):
        return types.InputPeerEmpty()

    # chat
    if isinstance(obj, types.TypeChat):
        if isinstance(
            obj,
            (types.Channel, types.ChannelForbidden)
        ):
            return types.InputPeerChannel(
                obj.id,
                access_hash=obj.access_hash
            )

        else:
            return types.InputPeerChat(obj.id)

    if isinstance(obj, types.PeerChat):
        return types.InputPeerChat(obj.chat_id)

    # channel
    if isinstance(obj, types.InputChannel):
        return types.InputPeerChannel(
            obj.channel_id,
            access_hash=obj.access_hash
        )

    if isinstance(obj, types.InputChannelFromMessage):
        return types.InputPeerChannelFromMessage(
            obj.peer,
            msg_id=obj.msg_id,
            channel_id=obj.channel_id
        )

    if raise_error:
        raise TypeError(
            f'Cannot cast {type(obj).__name__!r} '
            'to any kind of "types.TypeInputPeer".'
        )

def cast_to_input_user(obj, *, raise_error: bool = True):
    """attempts to cast an `obj` to `types.TypeInputUser`"""
    input_peer = cast_to_input_peer(obj, raise_error=False)

    if input_peer:
        if isinstance(input_peer, types.InputPeerEmpty):
            return types.InputUserEmpty()
        
        elif isinstance(input_peer, types.InputPeerSelf):
            return types.InputUserSelf()
        
        elif isinstance(input_peer, types.InputPeerUser):
            return types.InputUser(
                input_peer.user_id,
                access_hash=input_peer.access_hash
            )

        elif isinstance(input_peer, types.InputPeerUserFromMessage):
            return types.InputUserFromMessage(
                input_peer.peer,
                msg_id=input_peer.msg_id,
                user_id=input_peer.user_id
            )

    if raise_error:
        raise TypeError(
            f'Cannot cast {type(obj).__name__!r} '
            'to any kind of "types.TypeInputUser".'
        )

def cast_to_input_channel(obj, *, raise_error: bool = True):
    """attempts to cast an `obj` to `types.TypeInputChannel`"""
    input_peer = cast_to_input_peer(obj, raise_error=False)

    if input_peer:
        if isinstance(input_peer, types.InputPeerEmpty):
            return types.InputChannelEmpty()

        elif isinstance(input_peer, types.InputPeerChannel):
            return types.InputChannel(
                input_peer.channel_id,
                access_hash=input_peer.access_hash
            )

        elif isinstance(input_peer, types.InputPeerChannelFromMessage ):
            return types.InputChannelFromMessage(
                input_peer.peer,
                msg_id=input_peer.msg_id,
                channel_id=input_peer.channel_id
            )

    if raise_error:
        raise TypeError(
            f'Cannot cast {type(obj).__name__!r} '
            'to any kind of "types.TypeInputChannel".'
        )