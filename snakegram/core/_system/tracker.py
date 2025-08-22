import asyncio
from ..handlers import SystemRouter

from ... import filters, helpers
from ...tl import types
from ...models import _local_event as event

tracker = SystemRouter(__name__)

def _get_update_tracker():
    return event.client._update_tracker


@tracker.on_result(
    filters.proxy % types.updates.UpdateShortSentMessage
)
async def handle_short_sent_result(result):
    random_id = getattr(
        event.request.query,
        'random_id',
        None
    )
    if random_id is not None:
        ut = _get_update_tracker()
        try:
            peer_id, future = ut.pop_random(random_id)

        except TypeError: # unpack non-iterable ( None )
            pass

        else:
            ut.add_message(result.id, peer_id, future=future)


@tracker.on_update(
    filters.proxy % (
        types.UpdateNewMessage,
        types.UpdateEditMessage,
        types.UpdateNewChannelMessage,
        types.UpdateEditChannelMessage,
        types.UpdateNewScheduledMessage
    )
    & ~(filters.proxy.message % types.MessageEmpty)
    & filters.proxy.message.out
)
def handle_outgoing_message(update):
    ut = _get_update_tracker()
 
    try:
        future = ut.pop_message(
            update.message.id,
            peer_id=helpers.get_peer_id(update.message.peer_id)
        )
        if future is not None:
            future.set_result(update)

    except asyncio.InvalidStateError:
        pass


@tracker.on_update(
    filters.proxy % types.update.UpdateMessageID
)
def handle_update_message_id(update):
    ut = _get_update_tracker()

    try:
        peer_id, future = ut.pop_random(update.random_id)

    except TypeError:
        pass

    else:
        ut.add_message(update.id, peer_id, future=future)

