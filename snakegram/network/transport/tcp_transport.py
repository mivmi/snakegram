import typing as t
from .abstract import AbstractTransport
from ..datacenter import get_dc_address

if t.TYPE_CHECKING:
    from ..codec.abstract import AbstractCodec

class TcpTransport(AbstractTransport):
    """[Tcp](https://core.telegram.org/mtproto/transports#tcp) Transport."""

    def __init__(self, codec: 'AbstractCodec'):
        self.codec = codec
        self.first_packet = True
        super().__init__()

    def spawn(self):
        return TcpTransport(self.codec.spawn())

    def get_address(self, dc_id, is_cdn, is_media, use_ipv6):
        results = get_dc_address(
            dc_id,
            is_cdn=is_cdn,
            is_media=is_media,
            force_ipv6=use_ipv6
        )
    
        for ip_address, port, secret in results:
            if secret is None:
                return ip_address, port

        raise RuntimeError(f'No suitable address found for dc_id={dc_id}')

    async def send_packet(self, data):
        if self.first_packet:

            if self.codec.FIRST:
                self._writer.write(self.codec.FIRST)
            self.first_packet = False

        self._writer.write(self.codec.encode(data))
        await self._writer.drain()

    async def read_packet(self):
        return await self.codec.from_reader(self._reader)
