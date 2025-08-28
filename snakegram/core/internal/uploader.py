import os
import time
import math
import asyncio
import logging
import typing as t

from pathlib import Path

from ... import alias, errors
from ...tl import types, functions
from ...crypto import utils, aes_ige256_encrypt
from ...gadgets.utils import env
from ...gadgets.byteutils import Long

if t.TYPE_CHECKING:
    from ..telegram import Telegram
    from ...network import MediaConnection


logger = logging.getLogger(__name__)


_END_STREAM = object()
# https://core.telegram.org/api/files#uploading-files
MAX_CHUNK_SIZE = 512 * 1024
UPLOAD_CHUNK_AUTO  = env('UPLOAD_CHUNK_AUTO', True, bool)
UPLOAD_CHUNK_SIZE = env('UPLOAD_CHUNK_SIZE', MAX_CHUNK_SIZE, int)

if UPLOAD_CHUNK_SIZE > MAX_CHUNK_SIZE:
    logger.warning(
        '`UPLOAD_CHUNK_SIZE` exceeds 512KB. Reset to %d bytes.',
        MAX_CHUNK_SIZE
    )
    UPLOAD_CHUNK_SIZE = MAX_CHUNK_SIZE


if UPLOAD_CHUNK_SIZE % 1024 != 0:
    UPLOAD_CHUNK_SIZE = round(UPLOAD_CHUNK_SIZE / 1024) * 1024
    logger.warning(
        'UPLOAD_CHUNK_SIZE must be a multiple of 1024. '
        'Adjusted to %d bytes.',
        UPLOAD_CHUNK_SIZE
    )


class Uploader:
    def __init__(
        self,
        client: 'Telegram',
        file: t.Optional[alias.LikeFile],
        *,
        key: t.Optional[bytes] = None,
        iv: t.Optional[bytes] = None,
        file_id: int = None,
        uploaded: int = 0,
        part_size: int = None,
        file_name: str = None
    ):
        
        if file is not None:
            if isinstance(file, (str, Path)):
                if file_name is None:
                    file_name = os.path.basename(file)

                file_size = os.path.getsize(file)

            else:
                if file_name is None:
                    file_name = getattr(file, 'name', None)

                # seek to the end file to determine `file_size`
                file.seek(0, os.SEEK_END)
                file_size = file.tell()

                # back to the beginning of the file
                file.seek(0, os.SEEK_SET)
        else:
            file_size = -1

        if file_name is None:
            file_name = f'{file_id}.bin'

        self.client = client

        self._file = file
        self._key = key
        self._iv = iv
        self._file_id = file_id or Long()
        self._file_name = file_name

        # 
        self._future = asyncio.Future()
        self._lock_event = asyncio.Event()
        self._lock_event.set() # unlocked
        
        self._fingerprint = (
            utils.get_key_fingerprint(key, iv)
            if key and iv else
            None
        )

        #
        self._file_size = file_size
        self._part_size = part_size or self._get_part_size()

        #
        self._lock = asyncio.Lock()
        self._buffer = bytearray()

        #
        self._uploaded = uploaded
        self._done_time: t.Optional[float] = None
        self._start_time: t.Optional[float] = None
        self._connection: t.Optional[MediaConnection] = None

    # https://core.telegram.org/api/files#streamed-uploads
    async def __call__(self, chunk: bytes):
        if self.is_done:
            raise RuntimeError(
                'Upload is already completed or cancelled, '
                'no more data can be sent.'
            )

        if not self.is_stream:
            raise RuntimeError(
                'Uploader is initialized for normal (non-stream) upload.'
            )
        
        async with self._lock:
            if chunk is not _END_STREAM:
                self._buffer.extend(chunk)

            while not self.is_done:
                if len(self._buffer) < self._part_size:
                    # if chunk is `_END` this indicates end of stream
                    if chunk is _END_STREAM:
                        break
                    return

                await self._upload(self._buffer[:self._part_size])
                self._buffer = self._buffer[self._part_size:]

            if chunk is _END_STREAM:
                # send remaining buffer (may be less than part size or even empty)
                await self._upload(self._buffer)
                self._buffer.clear()

        if self.is_done:
            return await self._future

    
    @property
    def rate(self):
        elapsed_time = self.elapsed_time
    
        if elapsed_time is None:
            return 0.0

        return (
            0.0
            if elapsed_time <= 0 else 
            self._uploaded / elapsed_time
        )

    @property
    def is_big(self) -> bool:
        return self._file_size > 10 * 1024 * 1024

    @property
    def is_done(self):
        return self._future.done()

    @property
    def is_paused(self) -> bool:
        return not self._lock_event.is_set()

    @property
    def is_stream(self):
        return self._file is None

    @property
    def is_cancelled(self):
        return self._future.cancelled()

    @property
    def file_id(self):
        return self._file_id

    @property
    def uploaded(self):
        return self._uploaded

    @property
    def file_size(self):
        return self._file_size

    @property
    def file_name(self):
        return self._file_name

    @property
    def done_time(self):
        return self._done_time

    @property
    def start_time(self):
        return self._start_time

    @property
    def elapsed_time(self):
        if self._start_time is None:
            return None
        
        return (self._done_time or time.time()) - self._start_time

    @property
    def fingerprint(self):
        return self._fingerprint

    #  
    def pause(self):
        self._lock_event.clear()
        logger.info('file upload paused: %d', self._file_id)

    def resume(self):
        self._lock_event.set()
        logger.info('file upload resumed: %d', self._file_id)

    def cancel(self):
        self._future.cancel()
        self._done_time = time.time()
        logger.info('file upload cancelled: %d', self._file_id)
    
    def close(self):
        if self._connection:
            self._connection.release()

        self._connection = None

    async def _upload(self, chunk: bytes, total_parts: int = -1):
        if not self.client.is_connected():
            return self.cancel()

        if self._connection is None:
            logger.info('creating new media connection...')
            self._start_time = time.time()
            self._connection = await self.client.create_media_connection()

        chunk_size = len(chunk)
        is_encrypted_file = bool(self._key and self._iv)
    
        if chunk and is_encrypted_file:
            chunk = aes_ige256_encrypt(
                chunk,
                key=self._key,
                iv=self._iv
            )


        file_part = self._uploaded // self._part_size

        if self.is_stream and chunk_size != self._part_size:
            total_parts = math.ceil((self._uploaded + chunk_size) / self._part_size)
            
        if self.is_stream or self.is_big:
            request = functions.upload.SaveBigFilePart(
                self._file_id,
                file_part,
                total_parts,
                bytes=chunk
            )

        else:
            request = functions.upload.SaveFilePart(
                self._file_id,
                file_part,
                bytes=chunk
            )
        
        while not self.is_done:
            if not self._lock_event.is_set():
                logger.debug('Upload paused, waiting for resume signal...')

            await self._lock_event.wait()

            try:
                await self._connection.invoke(request)
    
            except errors.FloodPremiumWaitError as exc:
                logger.info(
                    'flood wait error: waiting %ds file_id=%d',
                    exc.seconds,
                    self._file_id
                    
                )

                await asyncio.sleep(exc.seconds)

            except Exception as exc:
                logger.exception(
                    'error uploading part %d, file_id=%d',
                    file_part,
                    self._file_id
                )
                self._future.set_exception(exc)

            else:
                logger.debug(
                    'uploaded part %d successfully: file_id=%d',
                    file_part,
                    self._file_id
                )

                self._uploaded += chunk_size
                break

        if not self.is_done:
            if (
                file_part > total_parts
                or
                (total_parts == -1 and chunk)
            ):
                return

            self._done_time = time.time()
            if self.is_big:
                if is_encrypted_file:
                    result = types.InputEncryptedFileBigUploaded(
                        self._file_id,
                        parts=total_parts,
                        key_fingerprint=self._fingerprint
                    )

                else:
                    result = types.InputFileBig(
                        self._file_id,
                        parts=total_parts,
                        name=self._file_name
                    )

            else:
                # https://github.com/DrKLO/Telegram/blob/f106432682da4cdef7dc2a88adf87897d5fd2c32/TMessagesProj/src/main/java/org/telegram/messenger/FileUploadOperation.java#L597
                if is_encrypted_file:
                    result = types.InputEncryptedFileUploaded(
                        self._file_id,
                        parts=total_parts,
                        md5_checksum='',
                        key_fingerprint=self._fingerprint
                    )

                else:
                    result = types.InputFile(
                        self._file_id,
                        parts=total_parts,
                        name=self._file_name,
                        md5_checksum=''
                    )

            logger.info(
                'file upload completed: %r, file_id=%d',
                self._file_name,
                self._file_id
            )
            self._future.set_result(result)

    async def _upload_file(self):
        if self.is_done:
            logger.debug(
                'upload already completed: file_id=%d',
                self._file_id
            )
            return await self._future
        
        if self.is_stream:
            if self.uploaded:
                return await self(_END_STREAM)

            raise RuntimeError(
                'Uploader is initialized for streaming mode, '
                'awaiting the uploader directly is not supported'
            )

        if self._file_size <= 0:
            raise ValueError('File is empty and cannot be uploaded')

        fp = (
            open(self._file, 'rb')
            if isinstance(self._file, (str, Path)) else 
            self._file
        )

        try:
            total_parts = math.ceil(self._file_size / self._part_size)

            logger.info(
                'starting file upload: %r, file_id=%d, size=%d, parts=%d',
                self._file_name,
                self._file_id,
                self._file_size,
                total_parts
            )

            if self.uploaded > 0:
                fp.seek(self.uploaded)

            start_part = self._uploaded // self._part_size

            for file_part in range(start_part, total_parts):
                chunk = fp.read(self._part_size)
                await self._upload(chunk, total_parts=total_parts)

                if self.is_done:
                    if file_part + 1 != total_parts:
                        logger.debug(
                            'upload was interrupted at part %d,  parts=%d, file_id=%d',
                            file_part + 1,
                            total_parts,
                            self._file_id
                        )
                    break 

        finally:
            self.close()
            if fp is not self._file:
                fp.close()

        return await self._future

    def _get_part_size(self):
        if self.is_stream or self._file_size <= 0:
            return MAX_CHUNK_SIZE

        if UPLOAD_CHUNK_AUTO:
            if self._file_size <= 104857600:
                return 128 * 1024

            elif self._file_size <= 786432000:
                return 256 * 1024

            return MAX_CHUNK_SIZE

        else:
            return UPLOAD_CHUNK_SIZE

    def __await__(self):
        coro = self._upload_file()
        return coro.__await__()
