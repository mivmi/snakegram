from .tl import types
from .gadgets.filter import ProxyFilter, build_filter

proxy = ProxyFilter()

# Filter for new message updates
new_message = proxy % (
    types.UpdateNewMessage,
    types.UpdateNewChannelMessage
)


# Filter for edited message updates
edit_message = proxy % (
    types.UpdateEditMessage,
    types.UpdateEditChannelMessage
)


__all__ = [
    'proxy',
    'build_filter',
    'new_message', 'edit_message'
]