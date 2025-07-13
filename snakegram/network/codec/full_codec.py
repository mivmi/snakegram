from zlib import crc32

from .abstract import AbstractCodec
from ...gadgets.byteutils import Int
from ...errors import SecurityError, TransportError

# +----+----+----...----+----+
# |len.|seq.|  payload  |crc.|
# +----+----+----...----+----+

class FullCodec(AbstractCodec):
    """
    [Full](https://core.telegram.org/mtproto/mtproto-transports#full) codec
    (Overhead medium)
    """
    def __init__(self):
        self.seqno = 0
        self.server_seqno = 0

    def encode(self, data):
        length = len(data) + 12

        header = (
            Int.to_bytes(length, signed=False)
            + Int.to_bytes(self.seqno, signed=False)
        )

        payload = header + data
        payload += Int.to_bytes(crc32(payload), signed=False)        

        self.seqno += 1
        return payload

    async def from_reader(self, reader):
        length_bytes = await reader.readexactly(4)
        packet_length = Int.from_bytes(length_bytes)

        if packet_length < 0:
            raise TransportError.from_code(abs(packet_length))

        seqno_bytes = await reader.readexactly(4)

        SecurityError.check(
            Int.from_bytes(seqno_bytes) != self.server_seqno, 
            'server_seqno mismatch'
        )

        payload = await reader.readexactly(packet_length - 12)

        checksum = Int.from_bytes(
            await reader.readexactly(4),
            signed=False
        )

        SecurityError.check(
            crc32(length_bytes + seqno_bytes + payload) != checksum, 
            'checksum mismatch'
        )

        self.server_seqno += 1
        return payload
