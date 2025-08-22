from __future__ import annotations

import asyncio
import logging
import typing as t
import typing_extensions as te

from .. import errors
from ..enums import EventType
from ..models import _local_event, EventContext
from ..gadgets.utils import decorator, maybe_await
from ..gadgets.filter import BaseFilter, run_filter

if t.TYPE_CHECKING:
    from .telegram import Telegram
    from ..tl.types import TypeUpdate # type: ignore
    from ..network.utils import Request
    from ..gadgets.tlobject import TLObject

T = t.TypeVar('T')
P = te.ParamSpec('P')

logger = logging.getLogger(__name__)



class Router:
    """
    Router for handling events and subrouters.

    Use it to register handlers for `updates`, `requests`, `results`, and `errors`.
    Supports nested subrouters and lets you `start`, `stop`, `pause`, or `resume`
    routers.

    Example:
    ```python
    
    # Create new router
    my_router = Router('my-router')
    
    @my_router.on_update(filters.new_message)
    async def new_message(update):
        print(update.message.to_string(indent=2))


    # Create a subrouter to manage AppConfig

    app_config = Router('app-config')

    # Only for hold shared state
    class AppState:
        def __init__(self):
            self.config = None

        @property
        def hash(self):
            return self.config.hash if self.config else 0

    state = AppState()

    # Refresh `AppConfig` when an `UpdateConfig` is received

    @app_config.on_update(
        filters.proxy % types.update.UpdateConfig
    )
    async def config_updated(_):
        await client(functions.help.GetAppConfig())


    # set the cached hash before sending a `GetAppConfig` request
    @app_config.on_request(
        filters.proxy.query % functions.help.GetAppConfig
    )
    def set_app_config_hash(request):
        request.query.hash = state.hash


    # Handle the result of `GetAppConfig` requests
    @app_config.on_result(
        filters.proxy % types.help.TypeHelpAppConfig
    )
    async def result_app_config(result):
        if isinstance(result, types.help.AppConfigNotModified):
            # set the cached `AppConfig` if unchanged
            await event.request.set_result(state.config)

        else:
            state.config = result

    # Add the subrouter to the `my_router`
    my_router.add_router(app_config)
 
    ```
    """

    def __init__(self, name: str):
        self.name = name
        self._handlers: t.Dict[str, t.List[Handler]] = {
            'error': [],
            'update': [],
            'result': [],
            'request': []
        }
        self._subrouters: t.List[Router] = []
        
        #
        self._lock_event = asyncio.Event()
        self._stop_event = asyncio.Event()
        self._lock_event.set()
    
    @property
    def is_paused(self) -> bool:
        return not self._lock_event.is_set()

    @property
    def is_stopped(self) -> bool:
        return self._stop_event.is_set()

    def pause(self):
        if self._lock_event.is_set():
            self._lock_event.clear()
            logger.info('Router %r paused.', self._name)

    def resume(self):
        if not self._lock_event.is_set():
            self._lock_event.set()
            logger.info('Router %r resumed.', self._name)

    def stop(self):
        if not self._stop_event.is_set():
            self._stop_event.set()
            logger.info('Router %r stopped.', self._name)

    def start(self):
        if self._stop_event.is_set():
            self._stop_event.clear()
            logger.info('Router %r started.', self._name)
        
    async def __call__(self, event_type: EventType, event):
        logger.debug(
            'Running router %r: event=%r.',
            self.name,
            event_type.title
        )

        if self.is_stopped:
            logger.info(
                'Router %r is stopped: skipping...',
                self.name
            )

        else:
            if self.is_paused:
                logger.info(
                    'Router %r is paused, waiting to resume',
                    self.name
                )

                await self._lock_event.wait()

            for handler in self.get_handlers(event_type):
                logger.info(
                    'Router %r dispatching to handler %r.',
                    self.name,
                    handler.name
                )
    
                try:
                    await handler.execute(event)

                except errors.StopPropagation:
                    logger.info(
                        'Router %r propagation stopped by handler %r.',
                        self.name,
                        handler.name
                    )
                    raise 

                except errors.StopRouterPropagation:
                    logger.info(
                        'Router %r stopped by handler %r.',
                        self.name,
                        handler.name
                    )
        
                    return
                    
                except Exception as exc:
                    logger.exception(
                        'Unexpected error while running handler %r: %s',
                        handler.name,
                        exc
                    )

            for sub in list(self._subrouters):
                logger.debug(
                    'Router forwarding event to subrouter %r',
                    sub.name
                )
                await sub(event_type, event)

    #
    @property
    def subrouters(self) -> t.List[Router]:
        return list(self._subrouters)

    #
    def register(
        self,
        func: t.Callable[P, T],
        event_type: EventType,
        filter_expr: t.Optional[BaseFilter] = None
    ):
        """
        Register a handler for a specific event type.

        Args:
            func (Callable):
                The function to call when the event occurs.

            event_type (`EventType`):
                The type of event to handle.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific events.

        Example:
            ```python
            async def print_rpc_errors(error):
                print(f'Error: {error}, Request: {error.request}')

            my_router = Router('my-router')
            my_router.register(
                rpc_errors,
                EventType.Error,
                filters.proxy % errors.RpcError
            )
            ```

        Note:
            You can skip calling `register` directly.
            The decorators `on_update`, `on_request`, `on_result`, `on_error`
            do the same thing in a simpler way.
        """
        if isinstance(func, Handler):
            func = func.func

        try:
            handler = Handler(
                f'<{self.name}.{event_type.title}: {func}>',
                func,
                event_type,
                filter_expr=filter_expr,
                unregister_callback=self.unregister
            )
            self._handlers[event_type.title].append(handler)

        except (KeyError, AttributeError):
            raise ValueError(f'Invalid handler type: {event_type!r}')
        
        return handler

    def unregister(self, handler: Handler) -> bool:
        """
        Unregister a handler from this router.

        Args:
            handler (Handler): The handler to remove.
        """
        try:
            kind = handler.event_type.title
            self._handlers[kind].remove(handler)

        except ValueError:
            raise ValueError(
                f'Handler {handler.name!r} not found in {self.name!r}'
            )

        except (KeyError, AttributeError):
            raise ValueError(f'Invalid handler type: {handler.event_type!r}')
          
        return True


    def get_handlers(self, event_type: EventType) -> t.List[Handler]:
        """
        Get all handlers for a given event type.

        Args:
            event_type (EventType): The type of event.

        Returns:
            List[Handler]: A list of handlers for the event type.

        """
        try:
            return list(self._handlers[event_type.title])

        except (KeyError, AttributeError):
            raise ValueError(f'Invalid handler type: {event_type!r}')

    def add_router(self, *routers: Router):
        """
        Add a subrouter to this router.

        Args:
            router (`Router`): The router to add as a subrouter.

        """
        for router in routers:
            if router in self._subrouters:
                raise ValueError(
                    f'Subrouter {router.name!r} is already added in {self.name!r}'
                )

            if isinstance(router, MainRouter):
                raise ValueError('Cannot add a MainRouter as a subrouter.')

            self._subrouters.append(router)
            logger.debug('Added subrouter %r into %r.', router.name, self.name)

    def remove_router(self, *routers: Router):
        """
        Remove a subrouter from this router.

        Args:
            router (Router): The router to remove.

        """
        for router in routers:
            try:
                if isinstance(router, SystemRouter):
                    raise RuntimeError(
                        f'Cannot remove system router {router.name!r}. '
                        'This router is critical for core system.'
                    )

                self._subrouters.remove(router)
                logger.debug(
                    'Removed subrouter %r from %r',
                    router.name, self.name
                )

            except ValueError:
                raise ValueError(
                    f'Subrouter {router.name!r} not found in {self.name!r}'
                )

    #
    @decorator
    def on_error(
        self,
        func: t.Callable[[errors.RpcError], t.Any],
        filter_expr: t.Optional[BaseFilter] = None
    ):
        """
        Register a handler for `RpcError`.

        Use this to handle requests that raise errors. For example, if a request
        causes a `FloodWaitError`, you can catch it and retry after waiting
        for the specified time.

        Args:
            func (Callable[[RpcError], Any]):
                Function to call when an error occurs.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific error events.

        Example:
            ```python
            my_router = Router('my-router')

            @my_router.on_error(filters.proxy % errors.FloodWaitError)
            async def flood_wait_handler(error):
                if error.seconds < 60:
                    await asyncio.sleep(error.seconds)
                    await error.request.set_result(
                        await event.client(event.request.query)
                    )
            ```

            You can also register the handler manually without using the decorator:

            ```python
            my_router.on_error(flood_wait_handler, filters.proxy % errors.FloodWaitError)
            ```
        """

        return self.register(
            func,
            EventType.Error,
            filter_expr=filter_expr
        )

    @decorator
    def on_update(
        self,
        func: t.Callable[['TypeUpdate'], t.Any],
        filter_expr: t.Optional[BaseFilter] = None
    ):
        """
        Register a handler for incoming updates.

        This lets you listen for any updates received.

        Args:
            func (Callable[[TypeUpdate], Any]):
                Function that handles the incoming update.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific updates.

        Example:
            ```python
            my_router = Router('my-router')

            @my_router.on_update(filters.new_message)
            async def handle_new_messages(update):
                print('New message:', update.message)
            ```

            You can also register the handler manually without using the decorator:

            ```python
            my_router.on_update(
                handle_new_messages,
                filters.proxy % filters.new_message
            )
            ```
        """
        return self.register(
            func,
            EventType.Update,
            filter_expr=filter_expr
        )

    @decorator
    def on_result(
        self,
        func: t.Callable[['TLObject'], t.Any],
        filter_expr: t.Optional[BaseFilter] = None
    ):
        """
        Register a handler for `RpcResult`.

        This lets you intercept and process the result of any request before
        it's returned to the original caller.

        Args:
            func (Callable[[TLObject], Any]):
                Function to handle the result.

            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific results.

        Example:
            ```python
            my_router = Router('my-router')

            @my_router.on_result(filters.proxy % types.Config)
            async def set_config(result):
                ...
            ```

            You can also register the handler manually without using the decorator:

            ```python
            my_router.on_result(set_config, filters.proxy % types.Config)
            ```
        """
        return self.register(
            func,
            EventType.Result,
            filter_expr=filter_expr
        )

    @decorator
    def on_request(
        self,
        func: t.Callable[['Request'], t.Any],
        filter_expr: t.Optional[BaseFilter] = None
    ):
        """
        Register a handler to intercept outgoing requests before they're sent.

        Use this to handle requests before they're dispatched to the server.
        For example, if you anticipate a `FloodWaitError`, you can wait the
        required time.

        Args:
            func (Callable[[Request], Any]):
                Function to handle the outgoing request
    
            filter_expr (`BaseFilter`, optional):
                Optional filter to match specific requests.

            
        Example:
        ```python
        my_router = Router('my-router')
        
        @my_router.on_request
        async def flood_wait(request):
            wait_until = flood_wait_cache.get(request.query._id)

            if wait_until:
                delay = int(wait_until - time.time())
                if delay > 0:
                    await asyncio.sleep(delay)
        ```

        You can also register the handler manually without using the decorator:
        ```python
        my_router.on_request(flood_wait)
        ```
        """
        return self.register(
            func,
            EventType.Request,
            filter_expr=filter_expr
        )

class Handler(t.Generic[P, T]):
    def __init__(
        self,
        name: str,
        func: t.Callable[P, T],
        event_type: EventType,
        filter_expr: t.Optional[BaseFilter] = None,
        unregister_callback: t.Callable[['Handler'], bool] = None
    ):

        self.name = name
        self.func = func
        self.event_type = event_type
        self.filter_expr = filter_expr
        self._unregister_callback = unregister_callback

    def __call__(self, *args: P.args, **kwargs: P.kwargs) -> T:
        return self.func(*args, **kwargs)

    def unregister(self):
        if self._unregister_callback is None:
            raise RuntimeError(
                f'Handler {self.name!r} cannot be unregistered: '
                'no unregister callback is set.'
            )

        status = self._unregister_callback(self)
        if status:
            logger.debug(
                'Successfully unregistered handler %r.',
                self.name
            )

        return status

    async def execute(self, value) -> t.Optional[T]:
        logger.debug('Running handler %r.', self.name)

        if self.filter_expr:
            try:
                result = await run_filter(self.filter_expr, value)

            except Exception:
                logger.exception(
                    'Error while run filter for handler %r.',
                    self.name
                )
                return

            if not result:
                logger.debug(
                    'Filter did not match for handler %r, skipping...',
                    self.name
                )
                return

        return await maybe_await(self.func(value))

#
class MainRouter(Router):
    def __init__(self, client: 'Telegram', routers: t.List[Router]):
        super().__init__('__main__')

        self.client = client
        self.add_router(*routers)

    async def __call__(self, type, event, request: 'Request' = None):
        _local_event._ctx.set(
            EventContext(
                self.client,
                type,
                event,
                request=request
            )
        )

        try:
            await super().__call__(type, event)

        except errors.StopPropagation:
            pass

class SystemRouter(Router):
    pass
