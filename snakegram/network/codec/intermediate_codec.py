from os import urandom
from random import randint
from .abstract import AbstractCodec

from ...errors import TransportError
from ...gadgets.byteutils import Int

# +----+----...----+
# +len.+  payload  +
# +----+----...----+
class IntermediateCodec(AbstractCodec):
    """
    [Intermediate](https://core.telegram.org/mtproto/mtproto-transports#intermediate) codec
    (Overhead small)
    """
    FIRST = b'\xee\xee\xee\xee'
    QUICK_ACK = True

    def encode(self, data):
        length = len(data)
        return Int.to_bytes(length) + data

    async def from_reader(self, reader):
        length = Int.from_bytes(
            await reader.readexactly(4)
        )
        result = await reader.readexactly(length)
        if length == 4: # 32-bit n
            error_code = Int.from_bytes(result)
            if error_code < 0:
                raise TransportError.from_code(abs(error_code))
    
        return result

# +----+----...----+----...----+
# |tlen|  payload  |  padding  |
# +----+----...----+----...----+
class PaddedIntermediateCodec(IntermediateCodec):
    """
    [Padded intermediate](https://core.telegram.org/mtproto/mtproto-transports#padded-intermediate) codec
    (Overhead small-medium)
    """

    FIRST = b'\xdd\xdd\xdd\xdd'
    QUICK_ACK = True

    def encode(self, data):
        return super().encode(data + urandom(randint(0, 16)))
