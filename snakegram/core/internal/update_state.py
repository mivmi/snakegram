import asyncio
import typing as t
from ... import helpers, models
from ...gadgets.utils import Timer, env, to_string

if t.TYPE_CHECKING:
    from ...tl import types


POLLING_TIMEOUT = env('POLLING_TIMEOUT', 1, float)
MAX_GAP_TIMEOUT = env('MAX_GAP_TIMEOUT', .5, float)
NO_UPDATE_TIMEOUT = env('NO_UPDATE_TIMEOUT', 15 * 60, float)


class UpdateState:
    def __repr__(self):
        return self.to_string()

    def to_dict(self):
        return {
            'is_polling': self.is_polling,
            'state_info': self.state_info.to_dict(),
            'fetch_callback': self.fetch_callback,
            'single_update_handler': self.single_update_handler
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent)

    def __init__(
        self,
        state_info: models.StateInfo,
        fetch_callback: t.Callable[['UpdateState'], t.Awaitable],
        single_update_handler: t.Callable[['types.TypeUpdate'], t.Awaitable],
        check_polling_callback: t.Callable[['UpdateState'], bool],
    ):
        self.state_info = state_info
        self.fetch_callback = fetch_callback
        self.single_update_handler = single_update_handler
        self.check_polling_callback = check_polling_callback

        self._lock = asyncio.Lock()
        self._pending_updates: t.Set['types.TypeUpdate'] = set()
        self._update_gap_timer: t.Optional[Timer] = None
        self._auto_fetch_timer: t.Optional[Timer] = None

    @property
    def state_id(self):
        return models.StateId(self.state_info.channel_id)

    @property
    def is_polling(self):
        return self.check_polling_callback(self)

    async def add(self, update):
        if update in self._pending_updates:
            # if the update is already pending, it means the gap is not yet filled
            # keep waiting until the missing updates arrive
            return False

        self._pending_updates.add(update)

        if len(self._pending_updates) > 1:
            # if more than one update is pending, attempt to re process all
            # the gap may have been filled by the server
            for update in sorted(
                self._pending_updates,
                key=helpers.update_order_key
            ):
                await self.single_update_handler(update)

        if (
            self._pending_updates
            and (
                self._update_gap_timer is None
                or not self._update_gap_timer.is_running()
            )
        ):
            # if there are still pending updates and the timer is inactive or expired
            # restart the gap timer to ensure resolution attempt
            await self.reset_gap_timer()

        return update in self._pending_updates

    async def process_update(self, update: 'types.TypeUpdate'):
        """start the "no update / polling" timer and removes the applied update from the pending set."""

        await self.reset_auto_fetch_timer()
        if update not in self._pending_updates:
            return

        self._pending_updates.discard(update)

        if not self._pending_updates:
            # no remaining pending updates means the gap is filled
            if self._update_gap_timer:
                await self._update_gap_timer.stop()
            return

        await self.reset_gap_timer()

    async def destroy(self):
        """Stop and remove any active timers."""
        if self._update_gap_timer is not None:
            await self._update_gap_timer.stop()

        if self._auto_fetch_timer is not None:
            await self._auto_fetch_timer.stop()

        self._update_gap_timer = None
        self._auto_fetch_timer = None

    async def reset_gap_timer(self):
        """starts or resets the update gap timer."""
        if self._update_gap_timer is None:
            async def _gap_filler(timer: Timer):
                if self._pending_updates:
                    await self.fetch_callback(self)

                await timer.stop()

            timer = Timer(MAX_GAP_TIMEOUT, _gap_filler)
            self._update_gap_timer = timer.start()
        else:
            await self._update_gap_timer.reset(MAX_GAP_TIMEOUT)

    async def reset_auto_fetch_timer(self):
        timeout = (
            POLLING_TIMEOUT
            if self.is_polling else
            NO_UPDATE_TIMEOUT
        )

        if self._auto_fetch_timer is None:
            async def _auto_fetch(timer: Timer):
                timeout = (
                    POLLING_TIMEOUT
                    if self.is_polling else
                    NO_UPDATE_TIMEOUT
                )

                await self.fetch_callback(self)
                return await timer.reset(timeout)

            timer = Timer(timeout, _auto_fetch)
            self._auto_fetch_timer = timer.start()

        if (
            not self.is_polling
            or not self._auto_fetch_timer.is_running()
        ):
            await self._auto_fetch_timer.reset(timeout)

    async def __aenter__(self):
        await self.destroy()
        await self._lock.acquire()

    async def __aexit__(self, exc_type, exc_value, exc_tb):
        self._lock.release()
