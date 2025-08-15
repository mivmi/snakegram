import io
import typing as t

from ... import alias, helpers, models
from ...tl import types
from ..internal import Uploader, Downloader

if t.TYPE_CHECKING:
    from ..telegram import Telegram

class _LazyDownloader:
    def __init__(self, creator):
        self._creator = creator
        self._downloader: Downloader = None

    async def _init(self):
        self._downloader = await self._creator()

    async def _download(self):
        await self._init()
        return await self._downloader._download()
    
    async def _iter_download(self):
        await self._init()
        async for chunk in self._downloader:
            yield chunk

    def __await__(self):
        coro = self._download()
        return coro.__await__()

    def __getattr__(self, name: str):
        try:
            return object.__getattribute__(self, name)

        except AttributeError:
            if self._downloader is None:
                raise RuntimeError('Downloader not initialized.')

            return getattr(self._downloader, name)

    def __aiter__(self):
        return self._iter_download()


class Upload:
    def upload(
        self: 'Telegram',
        file: t.Optional[alias.LikeFile],
        *,
        key: t.Optional[bytes] = None,
        iv: t.Optional[bytes] = None,
        file_id: int = None,
        uploaded: int = 0,
        part_size: int = None,
        file_name: str = None
    ):
        """
        Creates an uploader.

        Args:
            file (`LikeFile`, optional):
                The file to upload. Can be a file path or file-like object.
                If `None`, a streaming uploader is created for manual chunked uploads.
                Streaming upload is not supported for photos.

            key (`bytes`, optional):
                Encryption key for secret chats.

            iv (`bytes`, optional):
                IV used for secret chat encryption.

            file_id (`int`, optional):
                File ID used to identify the upload session. required for resuming.

            uploaded (`int`, optional):
                Number of bytes already uploaded. upload will resume from this offset.
                `file_id` and `part_size` must match the values used during the original uploader.

            part_size (`int`, optional):
                Size of each upload part, in bytes. must be divisible by 1024 and less than 512 KB.

            file_name (`str`, optional):
                The name to assign to the uploaded file. If not set, it will be inferred
                from the file path or the file object's `name` attribute.

        Example:
        ```python
        
        uploader = client.upload('video.mp4')
        result = await uploader

        # or manually stream chunks
        fp = open('video.mp4', 'rb')
        uploader = client.uploader(None)

        while True:
            chunk = fp.read(4096)
            if not chunk:
                break

            await uploader(chunk)

        result = await uploader # await final result after all chunks sent
        ```
        """
        return Uploader(
            self,
            file,
            key=key,
            iv=iv,
            file_id=file_id,
            uploaded=uploaded,
            part_size=part_size,
            file_name=file_name
        )

    def download(
        self: 'Telegram',
        dc_id: int,
        location: types.TypeInputFileLocation,
        *,
        file: t.Optional[alias.LikeFile] = None,
        key: t.Optional[bytes] = None,
        iv: t.Optional[bytes] = None,
        file_size: int = -1,
        downloaded: int = 0,
        is_precise: bool = False,
        chunk_size: int = None,
        cdn_supported: bool = True
    ):
        """
        Creates a Downloader.

        Args:
            dc_id (int):
                `dc_id` where the file is stored.

            location (`types.TypeInputFileLocation`):
                File location object.

            file (`LikeFile`, optional):
                Destination path or file-like object.
                If None, file can be downloaded in chunks.

            key (`bytes`, optional):
                Decryption key for secret chats.

            iv (`bytes`, optional):
                IV for secret chat decryption.
    
            file_size (`int`, optional):
                Total file size in bytes (for display or progress).

            downloaded (`int`, optional):
                Number of bytes already downloaded, upload will resume from this offset.

            is_precise (`bool`, optional):
                If `True`, Disable some checks on limit and offset values,
                useful for example to stream videos by keyframes.

            chunk_size (`int`, optional):
                Size of each download chunk in bytes. rules depend on `is_precise`.

            cdn_supported (`bool`, optional):
                Whether downloading via CDN is allowed.

        Example:
        ```python

        # Simple download
        result = await client.download(dc_id, location, file='video.mp4')
        
        # Chunked download
        import io

        buffer = io.BytesIO()
        downloader = client.download(dc_id, location)

        async for chunk in downloader:
            buffer.write(chunk)
            print(f'{downloader.downloaded:,} - {downloader.rate} bytes/s')
        ```
        """
        return Downloader(
            self,
            dc_id,
            location,
            file=file,
            key=key,
            iv=iv,
            file_size=file_size,
            downloaded=downloaded,
            is_precise=is_precise,
            chunk_size=chunk_size,
            cdn_supported=cdn_supported
        )

    def download_media(
        self: 'Telegram',
        media,
        *,
        file: t.Optional[alias.LikeFile] = None,
        dc_id: int = None,
        downloaded: int = 0,
        is_precise: bool = False,
        chunk_size: int = None,
        cdn_supported: bool = True
    ) -> Downloader:
        """
        Creates a Downloader for any media (`photo`, `document`, `profile`, etc.)
        
        Args:
            media:
                The media object to download (`photo`, `document`, `profile`, etc.).
            
            file (`LikeFile`, optional):
                Destination path or file-like object.
                If None, file can be downloaded in chunks.
            
            downloaded (`int`, optional):
                Number of bytes already downloaded, upload will resume from this offset.

            is_precise (`bool`, optional):
                If `True`, Disable some checks on limit and offset values,
                useful for example to stream videos by keyframes.

            chunk_size (`int`, optional):
                Size of each download chunk in bytes. rules depend on `is_precise`.

            cdn_supported (`bool`, optional):
                Whether downloading via CDN is allowed.

        Example:
        ```python
        
        chat = await client.get_entity('snakegram')
        downloader = client.download_media(chat, file='snakegram_profile.jpg')

        result = await downloader # Downloader is created here
        print('path:', result)

        #
        @client.on_update(
            filters.new_message
            &
            filters.proxy.message.media
            &
            filters.proxy.message.message.lower() == 'save' # caption
        )
        async def save_file_message(update):
        
            downloader = client.download_media(update)
            print('start download, size:', downloader.file_size)

            buffer = io.BytesIO()
            async for chunk in downloader:
                buffer.write(chunk)
                print(f'{downloader.downloaded:,} - {downloader.rate} bytes/s')
            ...

        ```
        Note:
            This object is **lazy**. The Downloader is only created when awaited or async-iterated.
            Accessing attributes before that will raise `RuntimeError`.

        """
        async def _create():
            nonlocal dc_id
            info = await self.get_file_info(media)

            if dc_id is None:
                if not info.dc_id:
                    raise ValueError(
                        '`dc_id` is missing, cannot download the file.'
                    )

                dc_id = info.dc_id

            file_size = info.file_size
            if isinstance(file, io.BytesIO):
                setattr(file, 'name', info.file_name)

            return Downloader(
                self,
                dc_id,
                info.location,
                file=file,
                file_size=file_size,
                downloaded=downloaded,
                is_precise=is_precise,
                chunk_size=chunk_size,
                cdn_supported=cdn_supported  
            )
        
        return _LazyDownloader(_create)

    async def get_file_info(
        self: 'Telegram',
        media,
        *,
        big: bool = True,
        entity: alias.LikeEntity = None,
        thumb_size: str = ''
    ):
        if isinstance(media, models.FileInfo):
            return media

        if isinstance(media, (types.Chat, types.User)):
            if entity is None:
                entity = media.id
 
            media = media.photo

        if isinstance(media, (types.ChatPhoto, types.UserProfilePhoto)):
            if entity is None:
                raise ValueError(
                    '`entity` is missing, cannot download the chat/profile photo'
                )

            peer_id = await self.get_input_peer(entity)

            return models.FileInfo(
                types.InputPeerPhotoFileLocation(
                    peer_id,
                    media.photo_id,
                    big=big
                ),
                dc_id=media.dc_id,
                file_name=f'profile_{media.photo_id}.jpg'
            )

        return helpers.get_file_info(media, thumb_size)
