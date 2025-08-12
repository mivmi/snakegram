import re
import mimetypes
import typing as t

from . import alias
from .tl import LAYER, types
from .core.internal import Uploader
from .gadgets.utils import is_like_list

T = t.TypeVar('T')

def _unwrap_message(obj: T) -> t.Union[types.Message, T]:
    if isinstance(obj, types.TypeUpdate):
        message = getattr(obj, 'message', None)
        if isinstance(message, types.Message):
            obj = message

    return obj

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
def guess_file_type(path: str):
    mime_type, _ = mimetypes.guess_type(path)

    if mime_type is None:
        raise ValueError(
            f'Failed to detect MIME type for file: {path!r}'
        )

    media_type = mime_type.split('/', maxsplit=1)[0]
    return media_type, mime_type

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


# media
def cast_to_input_media(obj, force_file: bool = False, *, raise_error: bool = True):
    """attempts to cast an `obj` to `types.TypeInputMedia`"""
    if isinstance(obj, types.TypeInputMedia):
        return obj

    obj = _unwrap_message(obj)
    
    if isinstance(obj, types.Message):
        obj = obj.media

    spoiler = getattr(obj, 'spoiler', False)
    ttl_seconds = getattr(obj, 'ttl_seconds', None)
    video_cover = getattr(obj, 'video_cover', None)
    video_timestamp = getattr(obj, 'video_timestamp', None)

    if isinstance(obj, types.MessageMediaUnsupported):
        raise RuntimeWarning(
            'This type of media'
            f' is not supported in the current layer (Layer: {LAYER}).'
        )

    if isinstance(obj, Uploader):
        obj = obj.result()
        if obj is None:
            raise RuntimeError('Upload has not been completed yet.')

    if isinstance(obj, types.MessageMediaPhoto):
        obj = obj.photo

    if isinstance(obj, types.MessageMediaWebPage):
        obj = obj.webpage

    if isinstance(
        obj,
        (
            types.MessageMediaDocument,
            types.InputBotInlineResultDocument
        )
    ):
        obj = obj.document
    
    if isinstance(
        obj,
        ( 
            types.InputFileStoryDocument,
            types.TypeInputStickeredMedia,
            types.InputStickeredMediaDocument
        )
    ):
        obj = obj.id

    # upload
    if isinstance(obj, (types.InputFile, types.InputFileBig)):
        media_type, mime_type = guess_file_type(obj.name)

        if media_type == 'image' and not force_file:
            return types.InputMediaUploadedPhoto(
                obj,
                spoiler=spoiler,
                ttl_seconds=ttl_seconds
            )

        else:
            return types.InputMediaUploadedDocument(
                obj,
                mime_type=mime_type,
                attributes=[
                    types.DocumentAttributeFilename(obj.name)
                ],
                spoiler=spoiler,
                video_cover=video_cover,
                ttl_seconds=ttl_seconds
            )

    # photo
    if isinstance(
        obj,
        (
            types.TypePhoto,
            types.photos.Photo,
            types.TypeInputPhoto
        )
    ):
        return types.InputMediaPhoto(
            cast_to_input_photo(obj),
            spoiler=spoiler,
            ttl_seconds=ttl_seconds
        )

    # contact
    if isinstance(obj, types.users.UserFull):
        obj = next(
            (
                u for u in obj.users
                if u.id == obj.full_user.id
            )
        )

    if isinstance(obj, types.User):
        return types.InputMediaContact(
            obj.phone,
            obj.first_name,
            obj.last_name
        )

    if isinstance(obj, types.MessageMediaContact):
        return types.InputMediaContact(
            obj.phone_number,
            obj.first_name,
            obj.last_name,
            vcard=obj.vcard
        )

    # document
    if isinstance(
        obj,
        (
            types.Document,
            types.InputDocument,
            types.TypeInputDocument
        )
    ):
        return types.InputMediaDocument(
            cast_input_document(obj),
            spoiler=spoiler,
            ttl_seconds=ttl_seconds,
            video_cover=video_cover,
            video_timestamp=video_timestamp
        )

    # webpage
    if isinstance(obj, types.TypeWebPage):
        if isinstance(obj, types.WebPageNotModified):
            raise ValueError
        
        if obj.url is None:
            raise ValueError

        return types.InputMediaWebPage(obj.url)

    if raise_error:
        raise TypeError(
            f'Cannot cast {type(obj).__name__!r} to "types.TypeInputMedia".'
        )

def cast_input_document(obj, *, raise_error: bool = True):
    """attempts to cast an `obj` to `types.TypeInputDocument`"""

    if isinstance(obj, types.TypeInputDocument):
        return obj
    
    obj = _unwrap_message(obj)

    if isinstance(obj, types.Message):
        obj = obj.media
    
    if isinstance(obj, types.Document):
        return types.InputDocument(
            obj.id,
            obj.access_hash,
            file_reference=obj.file_reference
        )
    
    if isinstance(obj, types.DocumentEmpty):
        return types.InputDocumentEmpty()

    if raise_error:
        raise TypeError(
            f'Cannot cast {type(obj).__name__!r} to "types.TypeInputDocument".'
        )

def cast_to_input_photo(obj, *, raise_error: bool = True) -> t.Optional[types.TypeInputPhoto]:
    """attempts to cast an `obj` to `types.TypeInputPhoto`"""

    if isinstance(obj, types.TypeInputPhoto):
        return obj

    obj = _unwrap_message(obj)

    if isinstance(
        obj,
        (
            types.photos.Photo,
            types.MessageMediaPhoto
        )
    ):
        obj = obj.photo

    if isinstance(obj, types.Photo):
        return types.InputPhoto(
            obj.id,
            obj.access_hash,
            file_reference=obj.file_reference
        )

    if isinstance(obj, types.PhotoEmpty):
        return types.InputPhotoEmpty()

    if isinstance(obj, types.UserFull):
        return cast_to_input_photo(obj.profile_photo)

    if isinstance(obj, (types.Channel, types.Chat, types.User)):
        return cast_to_input_photo(obj.photo)

    if raise_error:
        raise TypeError(
            f'Cannot cast {type(obj).__name__!r} to "types.InputPhoto".'
        )