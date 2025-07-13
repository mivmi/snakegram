import asyncio
import typing as t
from abc import ABC, abstractmethod

# https://core.telegram.org/mtproto/mtproto-transports
class AbstractCodec(ABC):
    FIRST: t.Optional[bytes] = None
    QUICK_ACK: bool = False

    def spawn(self):
        """Create a new instance of this codec class."""

        return self.__class__() # type: ignore

    @abstractmethod
    def encode(self, data: t.ByteString) -> t.ByteString:
        "Encode data."
        raise NotImplementedError

    @abstractmethod
    async def from_reader(self, reader: asyncio.StreamReader) -> t.ByteString:
        "Decode data from stream reader."
        raise NotImplementedError
