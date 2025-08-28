import time
import asyncio
import logging
import typing as t

from pathlib import Path
from collections import deque

from ... import alias, errors
from ...crypto import utils, aes_ctr256, aes_ige256_decrypt

from ...tl import types, functions
from ...gadgets.utils import env
from ...gadgets.byteutils import Int

if t.TYPE_CHECKING:
    from ..telegram import Telegram
    from ...network import MediaConnection

logger = logging.getLogger(__name__)

logger.setLevel(logging.DEBUG)
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)

formatter = logging.Formatter('[%(name)s] %(levelname)s: %(message)s')
console_handler.setFormatter(formatter)
logger.addHandler(console_handler)


DOWNLOAD_CHUNK_SIZE = env('DOWNLOAD_CHUNK_SIZE', 512 * 1024, int)
MAX_DOWNLOAD_CACHE_SIZE = env('MAX_DOWNLOAD_CACHE_SIZE', 1024 * 1024 , int)


class Downloader:
    def __init__(
        self,
        client: 'Telegram',
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
        
        self.client = client
        #
        self._dc_id = dc_id
        self._location = location
        self._is_precise = is_precise

        #
        self._key = key
        self._iv = iv

        self._file = file
        self._file_size = file_size
        self._downloaded = downloaded
        self._chunk_size = chunk_size or DOWNLOAD_CHUNK_SIZE
        self._cdn_supported = cdn_supported

        #
        self._hashes: deque[types.TypeFileHash] = deque()
        self._file_token: t.Optional[bytes] = None
        self._cdn_encryption_iv: t.Optional[bytes] = None
        self._cdn_encryption_key: t.Optional[bytes] = None

        #
        self._buffer = bytearray()
        self._stream = (
            open(file, 'wb+')
            if isinstance(file, (str, Path)) else
            file
        )

        # events
        self._future = asyncio.Future()
        self._lock_event = asyncio.Event()
        self._lock_event.set()

        #
        self._done_time: t.Optional[float] = None
        self._start_time: t.Optional[float] = None
        
        # connections
        self._connection: t.Optional['MediaConnection'] = None
        self._cdn_connection: t.Optional['MediaConnection'] = None
    
    @property
    def rate(self):
        elapsed_time = self.elapsed_time
    
        if elapsed_time is None:
            return 0.0

        return (
            0.0
            if elapsed_time <= 0 else 
            self._downloaded / elapsed_time
        )

    @property
    def file_size(self):
        return self._file_size

    @property
    def downloaded(self):
        return self._downloaded

    #
    @property
    def is_cdn(self):
        # file_token is only set when a `FileCdnRedirect` is received
        # If it's not None, the file is currently being downloaded via CDN.
        return (
            self._cdn_supported
            and self._file_token is not None
        )

    @property
    def is_done(self):
        return self._future.done()

    @property
    def is_paused(self) -> bool:
        return not self._lock_event.is_set()

    @property
    def is_cancelled(self):
        return self._future.cancelled()
    
    def pause(self):
        self._flush_buffer()
        self._lock_event.clear()
        logger.info('Download paused at %d bytes.', self.downloaded)

    def resume(self):
        self._lock_event.set()
        logger.info('Download resumed at %d bytes.', self.downloaded)

    def cancel(self):
        self.close()
        self._future.cancel()
        logger.info('Download cancelled at %d bytes.', self.downloaded)

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

    def close(self):
        self._buffer.clear()
        self._hashes.clear()

        if (
            self._file is not self._stream
            and hasattr(self._stream, 'close')
        ):
            self._stream.close()

        if self._connection:
            self._connection.release()

        if self._cdn_connection:
            self._cdn_connection.release()
        
        self._done_time = time.time()

        self._connection = None
        self._cdn_connection = None

        self._file_token = None
        self._cdn_encryption_iv = None
        self._cdn_encryption_key = None

    def _flush_buffer(self):
        if self._buffer:
            self._stream.write(self._buffer)
            logger.debug('Saved %d bytes to output stream.', len(self._buffer))
            self._buffer.clear()

    async def _apply(self, chunk: bytes):
        if self._key and self._iv:
            chunk = aes_ige256_decrypt(
                chunk,
                self._key,
                self._iv
            )

        length = len(chunk)
        last_chunk = length < self._chunk_size
        self._downloaded += length

        if last_chunk:
            logger.info('Download finished.')

        return last_chunk, chunk

    async def _download(self) -> alias.LikeFile:
        file_size = (
            'unknown'
            if self.file_size < 0 else
            self.file_size
        )
        logger.info('Starting full download, file_size=%s bytes', file_size)
        
        while not self.is_done:
            try:
                last_chunk, chunk = await self._get_next()

                self._buffer.extend(chunk)
                if (
                    last_chunk
                    or len(self._buffer) >= MAX_DOWNLOAD_CACHE_SIZE
                ):
                    self._flush_buffer()

                if last_chunk:
                    self._future.set_result(self._file)

            except Exception as exc:
                logger.error('Download failed: %s', exc)
                self._future.set_exception(exc)

        self.close()
        return await self._future

    async def _get_next(self):
        if not self._lock_event.is_set():
            logger.debug('Download paused, waiting for resume signal...')

        await self._lock_event.wait()

        if not self.is_cdn:
            return await self._get_next_chunk()

        return await self._get_cdn_next_chunk()

    async def _get_next_chunk(self) -> t.Tuple[bool, bytes]:
        if not self.client.is_connected():
            self.cancel()
            await self._future # raise cancelled error

        if self._connection is None:
            self._connection = await self.client.create_media_connection(
                self._dc_id,
                is_cdn=False
            )

        try:
            result = await self._connection.invoke(
                functions.upload.GetFile(
                    self._location,
                    self._downloaded,
                    limit=self._chunk_size,
                    precise=self._is_precise,
                    cdn_supported=self._cdn_supported
                )
            )

        except errors.FileMigrateError as exc:
            logger.info('file migrate to dc %d, migrating...', exc.dc_id)

            self._connection.release()

            self._dc_id = exc.dc_id
            self._connection = None

            # retry with new DC
            return await self._get_next_chunk()
    

        if isinstance(result, types.upload.FileCdnRedirect):
            logger.debug('received CDN redirect. switching to CDN download...')
    
            self._hashes.clear()
            self._hashes.extend(result.file_hashes)

            self._cdn_encryption_iv = result.encryption_iv
            self._cdn_encryption_key = result.encryption_key

            # retry on CDN connection
            return await self._get_cdn_next_chunk()

        return await self._apply(result.bytes)

    async def _get_cdn_next_chunk(self) -> t.Tuple[bool, bytes]:
        if not self.client.is_connected():
            self.cancel()
            raise self._future # raise cancelled error

        if self._cdn_connection is None:
            self._cdn_connection = await self.client.create_media_connection(
                self._dc_id,
                is_cdn=True
            )

        # get file hashes if `file_hashs` is empty
        if not self._hashes:
            file_hashes = await self._connection.invoke(
                functions.upload.GetCdnFileHashes(
                    self._file_token,
                    offset=self._downloaded
                )
            )
            self._hashes.extend(file_hashes)
            logger.info('fetched new CDN file hashes')

        file_hash = self._hashes.popleft()
        try:
            result = await self._cdn_connection.invoke(
                functions.upload.GetCdnFile(
                    self._file_token,
                    offset=file_hash.offset, limit=file_hash.limit
                )
            )

        except errors.FileTokenInvalidError:
            logger.debug(
                'invalid file token detected, resetting CDN download'
            )
            self.close()
            return await self._get_next_chunk()

        if isinstance(result, types.upload.CdnFileReuploadNeeded):
            logger.debug('file needs reupload, requesting CDN reupload')
            self._hashes.clear() # clear old file hashes

            try:
                file_hashes = await self._connection.invoke(
                    functions.upload.ReuploadCdnFile(
                        self._file_token,
                        request_token=result.request_token
                    )
                )

            except errors.CdnUploadTimeoutError:
                logger.debug('CDN reupload timed out, turning off CDN support')

                self.close()
                self._cdn_supported = False # disable CDN fallback
                return await self._get_next_chunk()
        
            self._hashes.extend(file_hashes)
            return await self._get_cdn_next_chunk()

        chunk = aes_ctr256(
            result.bytes,
            key=self._cdn_encryption_key,
            nonce=(
                self._cdn_encryption_iv[:-4]
                + Int.to_bytes(file_hash.offset // 16, byteorder='big')
            )
        )

        errors.SecurityError.check(
            utils.sha256(chunk) != file_hash.hash,
            message='CDN chunk sha256 hash mismatch'
        )
        return await self._apply(chunk)

    #
    def __aiter__(self):
        self._start_time = time.time()

        return self

    def __await__(self):
        if self.is_done:
            return self._future.__await__()

        if self._stream is None:
            raise RuntimeError(
                'Cannot await this downloader (no output file-like object defined), '
                'use "async for chunk in downloader" instead.'
            )
        
        coro = self._download()
        self._start_time = time.time()

        return coro.__await__()

    async def __anext__(self) -> bytes:
        if self.is_done:
            if self._future.exception():
                await self._future

            raise StopAsyncIteration

        try:
            last_chunk, chunk = await self._get_next()

            if last_chunk:
                self.close()
                self._future.set_result(True)

            return chunk

        except Exception as exc:
            logger.error('Download failed: %s', exc)
            self._future.set_exception(exc)

            raise

    async def __aenter__(self):
        return self

    async def __aexit__(self, exc_type, exc, tb):
        self.close()
