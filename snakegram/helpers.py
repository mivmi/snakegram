import re
import os
import mimetypes
import typing as t
from inspect import cleandoc

from . import alias, models
from .tl import LAYER, types
from .about import __update_command__
from .core.internal import Uploader
from .gadgets.utils import is_like_list

T = t.TypeVar('T')

def _unwrap_message(obj: T) -> t.Union[types.Message, T]:
    if isinstance(obj, types.TypeUpdate):
        message = getattr(obj, 'message', None)
        if isinstance(message, types.Message):
            obj = message

    return obj

def _get_document_name(document: types.Document):
    for attr in document.attributes:
        if isinstance(attr, types.DocumentAttributeFilename):
            return attr.file_name

    ext = mimetypes.guess_extension(document.mime_type) or '.bin'
    return f'document_{document.id}{ext}'


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
        obj = obj._future.result()

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
            cast_to_input_document(obj),
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

def cast_to_input_document(obj, *, raise_error: bool = True):
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

# 
def get_photo_size(
    sizes: t.List[types.TypePhotoSize],
    type_code: str = None,
    max_size: int = None
):

    def _get_size(size: types.TypePhotoSize) -> int:
        if hasattr(size, 'size'):
            return size.size

        if hasattr(size, 'sizes'):
            return max(size.sizes)

        return 0

    if type_code:
        result = next(
            (
                e
                for e in sizes
                if e.type == type_code
            ),
            None
        )

    elif max_size is not None:
        result = max(
            (
                e
                for e in sizes
                if (
                    getattr(e, 'w', 0) <= max_size 
                    and
                    getattr(e, 'h', 0) <= max_size
                )
            ),
            key=_get_size,
            default=None
        )

    else:
        result = max(sizes, key=_get_size, default=None)

    return _get_size(result), result


# https://core.telegram.org/api/files#vector-thumbnails
def decode_vector_thumbnail(encoded: bytes):
    """decode compressed vector thumbnail bytes into `SVG`."""
    path = 'M'
    lookup = 'AACAAAAHAAALMAAAQASTAVAAAZaacaaaahaaalmaaaqastava.az0123456789-,'

    for byte in encoded:
        num = byte
        if num >= 192:
            path += lookup[num - 192]
        else:
            if num >= 128:
                path += ','
            elif num >= 64:
                path += '-'
            path += str(num & 63)

    path += 'z'

    svg = f'''
    <?xml version="1.0" encoding="utf-8"?>
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        viewBox="0 0 512 512" xml:space="preserve">
    <path d="{path}"/>
    </svg>
    '''
    return cleandoc(svg).encode(encoding='utf-8')

# https://core.telegram.org/api/files#stripped-thumbnails
def decode_stripped_thumbnail(data: bytes):
    """convert stripped thumbnail bytes into `JPG`."""

    if len(data) < 3 or data[0] != 1:
        return data

    footer = b'\xff\xd9'
    header = (
        b'\xff\xd8\xff\xe0\x00\x10\x4a\x46\x49'
		b'\x46\x00\x01\x01\x00\x00\x01\x00\x01\x00\x00\xff\xdb\x00\x43\x00\x28\x1c'
		b'\x1e\x23\x1e\x19\x28\x23\x21\x23\x2d\x2b\x28\x30\x3c\x64\x41\x3c\x37\x37'
		b'\x3c\x7b\x58\x5d\x49\x64\x91\x80\x99\x96\x8f\x80\x8c\x8a\xa0\xb4\xe6\xc3'
		b'\xa0\xaa\xda\xad\x8a\x8c\xc8\xff\xcb\xda\xee\xf5\xff\xff\xff\x9b\xc1\xff'
		b'\xff\xff\xfa\xff\xe6\xfd\xff\xf8\xff\xdb\x00\x43\x01\x2b\x2d\x2d\x3c\x35'
		b'\x3c\x76\x41\x41\x76\xf8\xa5\x8c\xa5\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8'
		b'\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8'
		b'\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8\xf8'
		b'\xf8\xf8\xf8\xf8\xf8\xff\xc0\x00\x11\x08\x00\x00\x00\x00\x03\x01\x22\x00'
		b'\x02\x11\x01\x03\x11\x01\xff\xc4\x00\x1f\x00\x00\x01\x05\x01\x01\x01\x01'
		b'\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x03\x04\x05\x06\x07\x08'
		b'\x09\x0a\x0b\xff\xc4\x00\xb5\x10\x00\x02\x01\x03\x03\x02\x04\x03\x05\x05'
		b'\x04\x04\x00\x00\x01\x7d\x01\x02\x03\x00\x04\x11\x05\x12\x21\x31\x41\x06'
		b'\x13\x51\x61\x07\x22\x71\x14\x32\x81\x91\xa1\x08\x23\x42\xb1\xc1\x15\x52'
		b'\xd1\xf0\x24\x33\x62\x72\x82\x09\x0a\x16\x17\x18\x19\x1a\x25\x26\x27\x28'
		b'\x29\x2a\x34\x35\x36\x37\x38\x39\x3a\x43\x44\x45\x46\x47\x48\x49\x4a\x53'
		b'\x54\x55\x56\x57\x58\x59\x5a\x63\x64\x65\x66\x67\x68\x69\x6a\x73\x74\x75'
		b'\x76\x77\x78\x79\x7a\x83\x84\x85\x86\x87\x88\x89\x8a\x92\x93\x94\x95\x96'
		b'\x97\x98\x99\x9a\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xb2\xb3\xb4\xb5\xb6'
		b'\xb7\xb8\xb9\xba\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xd2\xd3\xd4\xd5\xd6'
		b'\xd7\xd8\xd9\xda\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xf1\xf2\xf3\xf4'
		b'\xf5\xf6\xf7\xf8\xf9\xfa\xff\xc4\x00\x1f\x01\x00\x03\x01\x01\x01\x01\x01'
		b'\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x01\x02\x03\x04\x05\x06\x07\x08'
		b'\x09\x0a\x0b\xff\xc4\x00\xb5\x11\x00\x02\x01\x02\x04\x04\x03\x04\x07\x05'
		b'\x04\x04\x00\x01\x02\x77\x00\x01\x02\x03\x11\x04\x05\x21\x31\x06\x12\x41'
		b'\x51\x07\x61\x71\x13\x22\x32\x81\x08\x14\x42\x91\xa1\xb1\xc1\x09\x23\x33'
		b'\x52\xf0\x15\x62\x72\xd1\x0a\x16\x24\x34\xe1\x25\xf1\x17\x18\x19\x1a\x26'
		b'\x27\x28\x29\x2a\x35\x36\x37\x38\x39\x3a\x43\x44\x45\x46\x47\x48\x49\x4a'
		b'\x53\x54\x55\x56\x57\x58\x59\x5a\x63\x64\x65\x66\x67\x68\x69\x6a\x73\x74'
		b'\x75\x76\x77\x78\x79\x7a\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x92\x93\x94'
		b'\x95\x96\x97\x98\x99\x9a\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xb2\xb3\xb4'
		b'\xb5\xb6\xb7\xb8\xb9\xba\xc2\xc3\xc4\xc5\xc6\xc7\xc8\xc9\xca\xd2\xd3\xd4'
		b'\xd5\xd6\xd7\xd8\xd9\xda\xe2\xe3\xe4\xe5\xe6\xe7\xe8\xe9\xea\xf2\xf3\xf4'
		b'\xf5\xf6\xf7\xf8\xf9\xfa\xff\xda\x00\x0c\x03\x01\x00\x02\x11\x03\x11\x00'
		b'\x3f\x00'
    )

    header[164] = data[1]
    header[166] = data[2]
    return header + data[3:] + footer

#
def get_file_info(obj, thumb_size: str = ''):
    """Get file info for downloading file."""

    obj = _unwrap_message(obj)

    # unwrap media
    if isinstance(obj, types.Message):
        obj = obj.media

    if isinstance(obj, types.MessageMediaStory):
        obj = getattr(obj.story, 'media', None)

    # unsupported media
    if isinstance(obj, types.MessageMediaUnsupported):
        raise RuntimeError(
            f'This media type is not supported in layer {LAYER}. '
            f'To fix this, update the package by running: {__update_command__}'
        )

    # inner
    if isinstance(obj, types.MessageMediaPhoto):
        obj = obj.photo

    elif isinstance(obj, types.MessageMediaDocument):
        obj = obj.document

    elif (
        isinstance(obj, types.MessageService)
        and
        isinstance(obj.action, types.MessageActionChatEditPhoto)
    ):
        obj = obj.action.photo

    elif (
        isinstance(obj, types.MessageMediaWebPage)
        and
        isinstance(obj.webpage, types.WebPage)
    ):
        obj = obj.webpage.document or obj.webpage.photo

    dc_id = None
    file_size = -1
    file_name = None
    input_file_location = (
        obj
        if isinstance(obj, types.TypeInputFileLocation) else 
        None
    )

    if isinstance(obj, types.Photo):
        dc_id = obj.dc_id
        file_size, photo_size = get_photo_size(obj.sizes, thumb_size)

        input_file_location = types.InputPhotoFileLocation(
            obj.id,
            obj.access_hash,
            obj.file_reference,
            thumb_size=photo_size.type
        )

    elif isinstance(obj, types.Document):
        if thumb_size:
            file_size, photo_size = get_photo_size(obj.thumbs, thumb_size)
            thumb_size = photo_size.type

        else:
            file_size = obj.size
            file_name = _get_document_name(obj)

        dc_id = obj.dc_id
        input_file_location = types.InputDocumentFileLocation(
            obj.id,
            obj.access_hash,
            obj.file_reference,
            thumb_size=thumb_size or ''
        )

    if input_file_location is None:
        raise TypeError(f'Unsupported media type: {type(obj).__name__}')

    if (
        file_name is None
        and getattr(obj, 'id', None)
        and getattr(input_file_location, 'thumb_size', None) # photo
    ):
        file_name = f'image_{obj.id}.jpg'

    return models.FileInfo(
        input_file_location,
        dc_id=dc_id,
        file_size=file_size,
        file_name=file_name
    )
