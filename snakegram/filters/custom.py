from ..tl import types
from .proxy_filter import magic

# Filter for new message updates
new_message = magic % (
    types.UpdateNewMessage,
    types.UpdateNewChannelMessage
)


# Filter for edited message updates
edit_message = magic % (
    types.UpdateEditMessage,
    types.UpdateEditChannelMessage
)