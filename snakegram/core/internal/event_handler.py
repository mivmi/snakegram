import asyncio
import logging
import typing as t
import typing_extensions as te

from ... import errors
from ...filters import run_filter, BaseFilter
from ...gadgets.utils import to_string, maybe_await


T = t.TypeVar('T')
P = te.ParamSpec('P')

logger = logging.getLogger(__name__)


class EventHandler(t.Generic[P, T]):
    def __repr__(self) -> str:
        return self.to_string()

    def to_dict(self):
        return {
            'name': self.name,
            'callback': self.callback,
            'filter_expr': self.filter_expr,
            'is_paused': self.is_paused,
            'is_stopped': self.is_stopped
        }

    def to_string(self, indent: t.Optional[int] = None) -> str:
        return to_string(self.to_dict(), indent=indent)

    def __init__(
        self,
        name: str,
        callback: t.Callable[P, T],
        filter_expr: t.Optional[BaseFilter],
        handler_list: t.List['EventHandler']
    ):

        self.name = name
        self.callback = callback
        self.filter_expr = filter_expr
        self._handler_list = handler_list

        #
        self._lock_event = asyncio.Event()
        self._stop_event = asyncio.Event()
        self._lock_event.set()

    def __call__(self, *args: P.args, **kwargs: P.kwargs) -> T:
        return self.callback(*args, **kwargs)

    @property
    def is_paused(self) -> bool:
        return not self._lock_event.is_set()

    @property
    def is_stopped(self) -> bool:
        return self._stop_event.is_set()

    # methods
    def stop(self) :
        self._stop_event.set()
        logger.debug('Stopped handler %r', self.name)

    def start(self):
        self._stop_event.clear()
        logger.debug('Started handler %r', self.name)

    def pause(self):
        self._lock_event.clear()
        logger.debug('Paused handler %r (locked)', self.name)

    def resume(self):
        self._lock_event.set()
        logger.debug('Resumed handler %r (unlocked)', self.name)

    def unregister(self):
        if self in self._handler_list:
            success = True
            self._handler_list.remove(self)
            logger.debug('Successfully unregistered handler %r', self.name)

        else:
            success = False
            logger.debug('Failed to unregister handler %r: not found.', self.name)
        return success


    async def execute(self, value):
        logger.debug('Running handler %r', self.name)

        if self.is_stopped:
            logger.debug('Handler %r is stopped: skipping...', self.name)

        else:
            if self.filter_expr:
                try:
                    result = await run_filter(self.filter_expr, value)
    
                except Exception:
                    logger.exception(
                        'Error while evaluating filter for handler %r',
                        self.name
                    )
                    return

                if not result:
                    logger.debug('Filter did not match, skipping...')
                    return

            if self.is_paused:
                logger.debug('Handler %r is paused, waiting to resume', self.name)

            await self._lock_event.wait()
            try:
                result = self.callback(value)
                return await maybe_await(result)

            except errors.StopPropagation:
                raise 

            except Exception:
                logger.exception('Unexpected error while running handler %r', self.name)
                raise 
