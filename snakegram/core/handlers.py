import logging
import typing as t

from .internal.event_handler import EventHandler

from .. import alias, errors
from ..models import _local_event
from ..gadgets.utils import dualmethod, decorator


if t.TYPE_CHECKING:
    from .telegram import Telegram
    from ..tl.types import TypeUpdate
    from ..network.utils import Request
    from ..gadgets.filter import BaseFilter
    from ..gadgets.tlobject import TLObject

logger = logging.getLogger(__name__)

Obj = t.Union['Telegram', t.Type['Telegram']]
_valid_event_types = {'error', 'update', 'result', 'request'}


class Handlers:
    _global_error_handlers = []
    _global_update_handlers = []
    _global_result_handlers = []
    _global_request_handlers = []

    @dualmethod
    def _register_handler(
        obj: Obj,
        event_type: alias.EventType,
        callback: t.Callable,
        filter_expr: t.Optional['BaseFilter'] = None,
    ):
        if event_type not in _valid_event_types:
            raise ValueError(f'Invalid handler type: {event_type!r}')

        handler_list: list = getattr(
            obj,
            (
                f'_global_{event_type}_handlers'
                if isinstance(obj, type) else
                f'_{event_type}_handlers'
            )
        )

        result = EventHandler(
            f'<{event_type}: {callback!r}>',
            callback,
            filter_expr,
            handler_list
        )
        handler_list.append(result)
        return result

    @decorator
    @dualmethod
    def on_error(
        obj: Obj,
        callback: t.Callable[[errors.RpcError], t.Any],
        filter_expr: t.Optional['BaseFilter'] = None
    ):
        """
        Register a handler for `RpcError`.

        Use this to handle requests that raise errors. For example, if a request
        causes a `FloodWaitError`, you can catch it and retry after waiting
        for the specified time.

        Args:
            callback (Callable[[RpcError], Any]):
                Function to call when an error occurs.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific error events.

        Example:
            ```python
            @client.on_error(filters.proxy % errors.FloodWaitError)
            async def flood_wait_handler(error):
                if error.seconds < 60:
                    await asyncio.sleep(error.seconds)
                    await error.request.set_result(
                        await event.client(event.request.query)
                    )
            ```

            You can also register the handler manually without using the decorator:

            ```python
            async def flood_wait_handler(error):
                ...

            client.on_error(flood_wait_handler, filters.proxy % errors.FloodWaitError)
            ```

        Note:
            When called on the class (`Telegram.on_error`), the handler is registered globally for all instances.
        """
        return obj._register_handler('error', callback, filter_expr=filter_expr)

    @decorator
    @dualmethod
    def on_update(
        obj: Obj,
        callback: t.Callable[['TypeUpdate'], t.Any],
        filter_expr: t.Optional['BaseFilter'] = None
    ):
        """
        Register a handler for incoming updates.

        This lets you listen for any updates received.

        Args:
            callback (Callable[[TypeUpdate], Any]):
                Function that handles the incoming update.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific updates.

        Example:
            ```python
            @client.on_update(
                filters.proxy % (
                    types.UpdateNewMessage,
                    types.UpdateNewChannelMessage
                )
            )
            async def handle_new_messages(update):
                print('New message:', update.message)
            ```

            You can also register the handler manually without using the decorator:

            ```python
            client.on_update(
                handle_new_messages,
                filters.proxy % (
                    types.UpdateNewMessage,
                    types.UpdateNewChannelMessage
                )
            )
            ```

        Note:
            When called on the class (`Telegram.on_update`), the handler is registered globally for all instances.
        """
        return obj._register_handler('update', callback, filter_expr=filter_expr)

    @decorator
    @dualmethod
    def on_result(
        obj: Obj,
        callback: t.Callable[['TLObject'], t.Any],
        filter_expr: t.Optional['BaseFilter'] = None
    ):
        """
        Register a handler for `RpcResult`.

        This lets you intercept and process the result of any request before
        it's returned to the original caller.

        Args:
            callback (Callable[[TLObject], Any]):
                Function to handle the result.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific results.

        Example:
            ```python
            @client.on_result(
                filters.proxy % types.update.UpdateConfig
            )
            async def set_config(result):
                ...
            ```

            You can also register the handler manually without using the decorator:

            ```python
            client.on_result(set_config, filters.proxy % types.update.UpdateConfig)
            ```

        Note:
            When called on the class (`Telegram.on_result`), the handler is registered globally for all instances.
        """
        return obj._register_handler('result', callback, filter_expr=filter_expr)

    @decorator
    @dualmethod
    def on_request(
        obj: Obj,
        callback: t.Callable[['Request'], t.Any],
        filter_expr: t.Optional['BaseFilter'] = None
    ):
        """
        Register a handler to intercept outgoing requests before they're sent.

        Use this to handle requests before they're dispatched to the server.
        For example, if you anticipate a `FloodWaitError`, you can wait the
        required time.

        Args:
            callback (Callable[[Request], Any]):
                Function to handle the outgoing request
    
            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific requests.

            
        Example:
        ```python
        
        @client.on_request
        async def flood_wait(request):
            wait_until = flood_wait_cache.get(type(request.query))

            if wait_until:
                delay = int(wait_until - time.time())
                if delay > 0:
                    await asyncio.sleep(delay)
        ```

        You can also register the handler manually without using the decorator:
        ```python
        client.on_request(flood_wait)
        ```

        Note:
            When called on the class (`Telegram.on_request`), the handler is registered globally for all instances.
        """
        return obj._register_handler('request', callback, filter_expr=filter_expr)

    @dualmethod
    def get_handlers(
        obj: Obj,
        event_type: alias.EventType,
        *,
        scope: t.Literal['all', 'local', 'global'] = 'all'
    ) -> t.Iterable[EventHandler]:
        """
        Get event handlers for a given event type and scope.

        Args:
            event_type (alias.EventType):
                The type of event handlers.

            scope (Literal['all', 'local', 'global'], optional):
                The scope of handlers to include:
                - "all": both local and global handlers (default).
                - "local": local handlers registered.
                - "global": global handlers registered.
        """
        if event_type not in _valid_event_types:
            raise ValueError(f'Invalid handler type: {event_type!r}')

        if isinstance(obj, type):
            if scope == 'local':
                raise RuntimeError(
                    'Local scope is not available when called from the class'
                )

            scope = 'global'

        def _iter_handlers(): 
            if scope in ('all', 'local'):
                yield from getattr(
                    obj,
                    f'_{event_type}_handlers',
                    []
                )

            if scope in ('all', 'global'):
                handlers = getattr(
                    obj,
                    f'_global_{event_type}_handlers',
                    []
                )

                if isinstance(obj, type):
                    yield from handlers

                else:
                    for handler in handlers:
                        if handler not in obj._disabled_global_handlers:
                            yield handler

        return _iter_handlers()

    @classmethod
    def is_global_handler(cls, handler: EventHandler) -> bool:
        """check if the handler is registered as a global handler."""

        for handler_list in [
            cls._global_error_handlers,
            cls._global_update_handlers,
            cls._global_result_handlers,
            cls._global_request_handlers
        ]:
            if handler in handler_list:
                return True
        return False

    def enable_global_handler(self: 'Telegram', handler: EventHandler):
        """
        Enable a previously disabled global handler.
        
        Args:
            handler (EventHandler): The global handler to enable.
 
        Returns:
            bool: True if the handler was enabled, False if it was not disabled before.

        """
        if handler not in self._disabled_global_handlers:
            return False

        self._disabled_global_handlers.discard(handler)
        return True

    def disable_global_handler(self: 'Telegram', handler: EventHandler):
        """
        Disable a global handler for this instance.
        
        global handlers are enabled by default for all instances.
        use this method to disable a global handler only for the current instance.
        
        Args:
            handler (EventHandler): The global handler to disable.
        
        Returns:
            bool: True if the handler was successfully disabled, False if the handler was already disabled.
        """
        if handler in self._disabled_global_handlers:
            return False
        
        if not self.is_global_handler(handler):
            raise ValueError(f'Handler {handler.name!r} is not a global handler.')

        self._disabled_global_handlers.add(handler)
        return True

    #
    async def _update_callback(self, update: 'TypeUpdate'):
        """Execute `update` handlers."""

        update_type = type(update).__name__
        logger.debug(f'Start handling update: {update_type!r}')
        _local_event._set_event(self, update=update)

        for handler in self.get_handlers('update'):

            try:
                await handler.execute(update)
            
            except errors.StopPropagation:
                logger.info(
                    f'Handler {handler.name!r} stopped propagation.'
                )

                return 

            except Exception:
                logger.exception(
                    'Unexpected error in handler '
                    f'{handler.name!r} while handling update: {update_type!r}'
                )

        logger.info(f'Finished handling update: {update_type!r}')

    async def _error_callback(self, error: errors.BaseError, request: 'Request'):
        """Execute `error` handlers."""
        
        request_id = request.msg_id or id(request)
        logger.debug(
            f'Start handling error for request {request_id}',
            exc_info=error
        )
        _local_event._set_event(
            self,
            error=error,
            request=request
        )

        for handler in self.get_handlers('error'):

            try:
                await handler.execute(error)

            except errors.StopPropagation:
                logger.info(
                    f'Handler {handler.name!r} stopped propagation.'
                )

                return 
    
            except errors.BaseError as exc:
                await request.set_exception(exc)

            except Exception:
                logger.exception(
                    'Unexpected error in handler '
                    f'{handler.name!r} while handling request {request_id} error.'
                )

            if request.done():
                if logger.isEnabledFor(logging.INFO):
                    exc = request.exception()
                    if exc:
                        error_type = type(exc).__name__
            
                        logger.info(
                            f'Handler {handler.name!r} registered exception '
                            f'({error_type!r}) for request {request_id}: {exc}'
                        )
                            
                    else:
                        logger.info(
                            f'Handler {handler.name!r} '
                            'resolved error and set result for request '
                            f'{request_id}: {request.result()}'
                        )

                return

        logger.info(f'Finished handling error for request {request_id}.')

    async def _result_callback(self, result: 'TLObject', request: 'Request'):
        """Execute `result` handlers."""

        request_id = request.msg_id or id(request)
        logger.debug(f'Start handling result for request {request_id}.')
        _local_event._set_event(
            self,
            result=result,
            request=request
        )
        for handler in self.get_handlers('result'):

            try:
                await handler.execute(result)

            except errors.StopPropagation:
                logger.info(
                    f'Handler {handler.name!r} stopped propagation.'
                )
                return 
    
            except errors.BaseError as err:
                await request.set_exception(err)

            except Exception:
                logger.exception(
                    'Unexpected error in handler '
                    f'{handler.name!r} while handling result for result: {request_id!r}'
                )

            if request.done():
                if logger.isEnabledFor(logging.INFO):
                    exc = request.exception()
                    if exc:
                        error_type = type(exc).__name__
            
                        logger.info(
                            f'Handler {handler.name!r} registered exception '
                            f'({error_type!r}) for request {request_id}: {exc}'
                        )
        
                    else:
                        logger.info(
                            f'Handler {handler.name!r} set the result '
                            f'for request ({request_id}): {request.result()}'
                        )
                return

        logger.info(f'Finished handling result for request {request_id}.')

    async def _request_callback(self, request: 'Request'):
        """Execute pre-send `request` handlers."""

        request_id = request.msg_id or id(request)
        logger.debug(
            'Start pre-send '
            f'request handling for {request.name!r} ({request_id})'
        )
        _local_event._set_event(self, request=request)

        for handler in self.get_handlers('request'):
            print(handler)
            try:
                await handler.execute(request)

            except errors.StopPropagation:
                logger.info(
                    f'Handler {handler.name!r} stopped propagation.'
                )
                return

            except errors.BaseError as exc:
                # errors of type `BaseError` prevent the request from being sent to the server.
                await request.set_exception(exc)
    
            except Exception:
                logger.exception(
                    'Unexpected error in handler '
                    f'{handler.name!r} while handling pre-send request {request_id!r}'
                )

            if request.done():
                if logger.isEnabledFor(logging.INFO):
                    exception = request.exception()
                    if exception:
                        error_type = type(exception).__name__
                        logger.info(
                            f'Handler {handler.name!r} registered exception '
                            f'({error_type!r}) for request {request_id}: {exc}'
                        )
                    else:
                        logger.info(
                            f'Handler {handler.name!r} returned a '
                            f'final result for request {request_id}. '
                            f'the request will not be sent: {request.result()}'
                        )

                return

        logger.info(
            'Finished pre-send request '
            f'handling for {request.name!r} ({request_id})'
        )
