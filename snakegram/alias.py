import typing as t

URL = t.NewType('URL', str)
Host = t.NewType('Host', str)
NetAddr: t.TypeAlias = t.Tuple[Host, int]
Address: t.TypeAlias = t.Union[URL, NetAddr]
