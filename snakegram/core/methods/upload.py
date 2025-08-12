import typing as t

from ... import alias
from ..internal import Uploader

if t.TYPE_CHECKING:
    from ..telegram import Telegram


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