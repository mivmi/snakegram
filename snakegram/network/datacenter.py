import typing as t
from .. import alias
from ..gadgets.utils import env, ArcheDict

if t.TYPE_CHECKING:
    from ..tl.types import DcOption # type: ignore


TEST_MODE = env('TEST_MODE', False, bool)


IPV4_CDN_DC = ArcheDict()
IPV6_CDN_DC = ArcheDict()

IPV4_MEDIA_DC = ArcheDict()
IPV6_MEDIA_DC = ArcheDict()

DEFAULT_DC_ID = 2
DEFAULT_DC_PORT = 443

# static dc addresses
# https://github.com/DrKLO/Telegram/blob/289c4625035feafbfac355eb01591b726894a623/TMessagesProj/jni/tgnet/ConnectionsManager.cpp#L1809
if TEST_MODE:
    IPV4_DC = ArcheDict(
        {
            1: {'149.154.175.40'},
            2: {'149.154.167.40'},
            3: {'149.154.175.117'}
        }
    )
    IPV6_DC = ArcheDict(
        {
            1: {'2001:b28:f23d:f001:0000:0000:0000:000e'},
            2: {'2001:67c:4e8:f002:0000:0000:0000:000e'},
            3: {'2001:b28:f23d:f003:0000:0000:0000:000e'}
        }
    )

else:
    IPV4_DC = ArcheDict(
        {
            1: {'149.154.175.50'},
            2: {'149.154.167.51'},
            3: {'149.154.175.100'},
            4: {'149.154.167.91'},
            5: {'149.154.171.5'}
        }
    )

    IPV6_DC = ArcheDict(
        {
            1: {'2001:b28:f23d:f001:0000:0000:0000:000a'},
            2: {'2001:67c:4e8:f002:0000:0000:0000:000a'},
            3: {'2001:b28:f23d:f003:0000:0000:0000:000a'},
            4: {'2001:67c:4e8:f004:0000:0000:0000:000a'},
            5: {'2001:b28:f23f:f005:0000:0000:0000:000a'}
        }
    )



def get_dc_name(dc_id: int):
    """get the dc `name` from its `dc_id`."""
    names = {
        1: 'pluto',
        2: 'venus',
        3: 'aurora',
        4: 'vesta',
        5: 'flora'  
    }
    return names.get(dc_id)

def get_dc_address(
    dc_id: int,
    is_cdn: bool,
    is_media: bool,
    *,
    force_ipv6: bool = False
) -> t.List[t.Tuple[str, int]]:
    """Return a list of (`ip`, `port`) tuples for the given dc."""

    if is_cdn:
        target = (
            IPV6_CDN_DC
            if force_ipv6 or not IPV4_CDN_DC else
            IPV4_CDN_DC
        )
    
    elif is_media:
        target = (
            IPV6_MEDIA_DC 
            if force_ipv6 or not IPV4_MEDIA_DC else
            IPV4_MEDIA_DC
        )
        if dc_id not in target:
            return get_dc_address(
                dc_id,
                False,
                False,
                force_ipv6=force_ipv6)

    else:
        target = (
            IPV6_DC
            if force_ipv6 or not IPV4_DC else
            IPV4_DC
        )
    
    result = []
    for item in target[dc_id]:
        if isinstance(item, str):
            item = (item, DEFAULT_DC_PORT)

        result.append(item)
    
    if not result:
        raise RuntimeError(
            f'No suitable address found for dc_id={dc_id}'
        )

    return result

# https://core.telegram.org/mtproto/transports#uri-format
def get_dc_url_format(
    dc_id: int,
    *,
    domain: bool = True,
    ws: bool = False,
    cors: bool = False,
    secure: bool = False,
    extended_limit: bool = True
) -> alias.URL:

    ip_address = None
    if not domain:
        result = get_dc_address(dc_id, False, False)
        ip_address = result[0][0]

    url_path = 'api'
    if cors:
        url_path += 'w'

    if ws:
        url_path += 's'

    if TEST_MODE and domain and not ip_address:
        url_path += '_test'


    port = 443 if secure else 80
    protocol = 'ws' if ws else 'http'
    if secure:
        protocol += 's'
    
    if ws and not secure and domain:
        raise RuntimeError(
            'Plain WebSocket (`ws://`) with domain is not supported'
        )

    if ip_address:
        return f'{protocol}://{ip_address}/{url_path}'

    name = get_dc_name(dc_id)
    subdomain = f'{name}-1' if extended_limit else name
    return f'{protocol}://{subdomain}.web.telegram.org:{port}/{url_path}'


def update_dc_address(dc_options: t.List['DcOption']):
    """reset and `update` dc address mappings from list of `DcOption`."""

    IPV4_DC.reset()
    IPV6_DC.reset()

    IPV4_CDN_DC.reset()
    IPV6_CDN_DC.reset()

    IPV4_MEDIA_DC.reset()
    IPV6_MEDIA_DC.reset()

    for dc in dc_options:
        if dc.tcpo_only:
            continue

        if dc.cdn:
            target = (
                IPV6_CDN_DC if dc.ipv6 else IPV4_CDN_DC
            )

        elif dc.media_only:
            target = (
                IPV6_MEDIA_DC if dc.ipv6 else IPV4_MEDIA_DC
            )

        else:
            target = IPV6_DC if dc.ipv6 else IPV4_DC

        if dc.id not in target:
            target[dc.id] = set()

        target[dc.id].add((dc.ip_address, dc.port))
