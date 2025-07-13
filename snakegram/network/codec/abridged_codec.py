from .abstract import AbstractCodec
from ...gadgets.byteutils import Int
from ...errors import TransportError

# +-+----...----+
# |l|  payload  |
# +-+----...----+
# OR
# +-+---+----...----+
# |h|len|  payload  +
# +-+---+----...----+

class AbridgedCodec(AbstractCodec):
    """
    [Abridged](https://core.telegram.org/mtproto/mtproto-transports#abridged) codec
    (Overhead Very small)
    """

    H = b'\x7f'
    FIRST = b'\xef'
    QUICK_ACK = True

    def encode(self, data):

        length = len(data) // 4
        if length < 127:
            length_byte = length.to_bytes(1, 'little')

        else:
            length_byte = (
                self.H
                + length.to_bytes(3, 'little')
            )

        return length_byte + data

    async def from_reader(self, reader):
        first_byte = await reader.readexactly(1)

        if first_byte == self.H:
            length = await reader.readexactly(3)
            length = int.from_bytes(length, 'little')

        else:
            length = ord(first_byte)

        length *= 4
        result = await reader.readexactly(length)

        if length == 4: # 32-bit number
            error_code = Int.from_bytes(result)
            if error_code < 0:
                raise TransportError.from_code(abs(error_code))

        return result
