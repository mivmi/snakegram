import os
import sys
import time
import asyncio
import inspect
import datetime
import typing as t
import typing_extensions as te

from types import GeneratorType
from contextvars import ContextVar
from functools import wraps, partial


T_1 = t.TypeVar('T_1')
P_1 = te.ParamSpec('P_1')

_EPOCH = datetime.datetime(1970, 1, 1, tzinfo=datetime.timezone.utc)
_NOTING = object()


def env(name: str, default: t.Any, var_type: t.Type[T_1] = str) -> T_1:
    """
    Get an env variable and cast it to the given type.

    Note: if the type is `bool`, values like "false", "no", and "0" are treated as False.
    """
    value = os.environ.get(name)

    if value is None:
        return default

    if var_type is bool:
        if isinstance(value, str):
            value = value.lower() not in {'false', 'no', '0', ''}

        return bool(value)

    return var_type(value)

#
class decorator(t.Generic[P_1, T_1]):
    """
    Base decorator to support optional arguments.

    Example:
    ```python
    @decorator
    def repeat(_func, count: int = 2):
        @wraps(_func)
        def wrapper(message: str):
            for _ in range(count):
                _func(message)
        return wrapper

    # Usage with arguments
    example_1 = repeat(print, count=4)
    example_1("Hello")

    # Usage as a decorator, with or without arguments
    @repeat  # or @repeat(count=4)
    def example_2(message: str):
        print(message, end=" ")

    example_2("Hello")
    ```
    """

    def __init__(self, fn: te.Callable[P_1, T_1]):
        self.fn = fn
    
    def __call__(self, *args: P_1.args, **kwargs: P_1.kwargs) -> T_1:
        if self._is_no_args(args, kwargs):
            return self.fn(*args, **kwargs)

        def wrapper(actual_fn):
            return self.fn(actual_fn, *args, **kwargs)

        return wrapper
    
    def __get__(self, instance, owner) :
        def bound(*args: P_1.args, **kwargs: P_1.kwargs) -> T_1:
            if self._is_no_args(args, kwargs):
                return self.fn(instance or owner, *args, **kwargs)

            def wrapper(actual_fn):
                return self.fn(instance or owner, actual_fn, *args, **kwargs)
            return wrapper

        return bound

    @staticmethod
    def _is_no_args(args: t.Tuple, kwargs: t.Dict) -> bool:
        return len(args) == 1 and callable(args[0]) and not kwargs

class dualmethod(t.Generic[P_1, T_1]):
    """
    a decorator that allows a method to be called both on a class and on object.

    Example:
    ```python
    class MyClass:
        @dualmethod
        def greet(obj, name: str) -> None:
            if isinstance(obj, type):
                print(f"Hello {name} from class {obj.__name__!r}")

            else:
                print(f"Hello {name} from object of {obj.__class__.__name__!r}")

    MyClass.greet("James")
    MyClass().greet("James")
    ```
    """

    def __init__(self, fn: te.Callable[te.Concatenate[object, P_1], T_1]):
        self.fn = fn

    def __call__(self, *args: P_1.args, **kwargs: P_1.kwargs) -> T_1:
        return self.fn(*args, **kwargs)

    def __get__(self, instance, owner) -> te.Callable[P_1, T_1]:
        @wraps(self.fn)
        def wrapper(*args: P_1.args, **kwargs: P_1.kwargs) -> T_1:
            return self(instance or owner, *args, **kwargs)

        return wrapper

#
@t.overload
def retry(
    count: int,
    *,
    start: int = 1,
    sequence: None = ...
) -> t.Iterable[int]: ...

@t.overload
def retry(
    count: int,
    *, start: int = 1,
    sequence: t.Iterable[T_1]
) -> t.Iterable[t.Tuple[int, T_1]]: ...

def retry(
    count: int = -1,
    *,
    start: int = 1,
    sequence: t.Optional[t.Iterable[T_1]] = None
) -> t.Iterator[t.Union[int, t.Tuple[int, T_1]]]:

    """
    yields numbers or (number, item), looping over items if given

    Example:
    >>> list(retry(3))
    [1, 2, 3]
    >>> list(retry(4, sequence=['a', 'b']))
    [(1, 'a'), (2, 'b'), (3, 'a'), (4, 'b')]
    """

    _index = 0
    _counter = start
    _iterable = (
        None
        if sequence is None else
        list(sequence) # range
    )

    while count == -1 or _counter <= count:

        if _iterable is None:
            yield _counter

        else:
            if not _iterable:
                break  # is empty
    
            yield _counter, _iterable[_index]

            _index = (_index + 1) % len(_iterable)

        _counter += 1

#
def to_string(data, indent: t.Optional[int] = None) -> str:
    """
    Convert a data into a formatted string.
    Args:
        data (any): The input data to be converted to a string. If the data has a `to_dict` method, 
                    it will be called to convert the data to a dictionary.
        indent (int, optional): The number of spaces to use for indentation. If None, no indentation 
                                will be applied. Default is None.

    Returns:
        str: A formatted string with the specified indentation.

    Example:
        >>> data = {'key1': 'value1', 'key2': {1: 2}}
        >>> print(to_string(data, indent=2))
        {
          'key1': 'value1',
          'key2': {
            1:2
          }
        }
    """
    def parser(data):
        result = []

        if inspect.isclass(data):
            return [data.__name__]

        if hasattr(data, 'to_dict'):
            data_ = data.to_dict()
            if '_' not in data_:
                data_['_'] = type(data).__name__

            data = data_

        if isinstance(data, dict):
            if '_' in data:
                _eq = '='
                _close = ')'
                _default = str
                result.extend([str(data.pop('_')), '('])

            else:
                _eq = ':'
                _close = '}'
                _default = repr
                result.append('{')

            for key, value in data.items():

                result.extend([1, _default(key), _eq, parser(value), ','])

            if data:
                result.pop() # Remove the last comma
                result.append(0)

            result.append(_close)

        elif is_like_list(data):
            if isinstance(data, set):
                _open, _close, _empty = '{', '}', 'set()'

            elif isinstance(data, tuple):
                _open, _close, _empty = '(', ')', 'tuple()'

            elif isinstance(data, frozenset):
                _open, _close, _empty = 'frozenset({', '})', 'frozenset()'

            else:
                _open, _close, _empty = '[', ']', '[]'

            if isinstance(data, (range, GeneratorType)):
                result.append(repr(data))

            elif data:
                result.append(_open)
                for value in data:
                    result.extend([1, parser(value), ','])

                result.pop() # remove the last comma
                result.extend([0, _close])
    
            else:
                result.append(_empty)

        elif callable(data):
            if inspect.iscoroutinefunction(data):
                result.extend(['async', ' '])
    
            result.append(
                getattr(data, '__name__', '<callable>')
            )
            result.append(str(inspect.signature(data)))

        else:
            result.append(repr(data))

        return result

    def wrapper(data, level: int):
        
        result = ''
        for value in data:
            # numbers indicate the change in indentation level
            if isinstance(value, int):
                if indent:
                    result += '\n'
                    result += ' ' * (indent * (level + value))

            elif isinstance(value, str):
                # If indent is not set and the value is a comma,
                # add a space for better readability
                if not indent and value == ',':
                    value += ' '

                result += value

            else:
                # another stack. level up
                result += wrapper(value, level=level + 1)

        return result

    return wrapper(parser(data), level=0)

def split_list(seq: t.List[T_1], size: int):
    """Split the list into smaller parts.
    
    Example:
        >>> list(split_list([1, 2, 3, 4, 5], 2))
        [[1, 2], [3, 4], [5]]
    """
    if size <= 0:
        raise ValueError('size must be > 0')

    for i in range(0, len(seq), size):
        yield seq[i:i + size]

def is_like_list(obj) -> te.TypeGuard[t.Iterable[T_1]]:
    """Return True if the object is iterable and not str, bytes, or bytearray."""
    return (
        hasattr(obj, '__iter__')
        and not isinstance(obj, (str, bytes, bytearray))
    )

def to_timestamp(obj) -> float:
    """convert various date/time inputs to a `UTC` timestamp."""
    def _to_timestamp(dt: datetime.datetime):
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=datetime.timezone.utc)

        return (dt - _EPOCH).total_seconds()

    if isinstance(obj, (int, float)):
        return obj

    if isinstance(obj, datetime.datetime):
        return _to_timestamp(obj)

    if isinstance(obj, datetime.date):
        return _to_timestamp(
            datetime.datetime.combine(obj, datetime.time.min)
        )

    if isinstance(obj, datetime.timedelta):
        return _to_timestamp(
            obj + datetime.datetime.now(datetime.timezone.utc)
        )
    
    raise TypeError(
        f'Unsupported type for ts conversion: {type(obj).__name__!r}'
    )

def time_difference(obj):
    """get number of seconds between `obj` and now."""
    now = datetime.datetime.now(datetime.timezone.utc)
    return to_timestamp(obj) - now.timestamp()

# asyncio helpers
@decorator
def to_async(
    func: t.Callable[P_1, T_1],
    executor: t.Optional[t.Any] = None
) -> t.Callable[P_1, t.Awaitable[T_1]]:
    """
    Converts a sync function to async.

    Args:
        func (Callable): 
            The sync function that will be converted to async.
        executor (Optional[Any], optional): 
            An `executor` object for running the function in a separate thread or process.
            If `None`, the default `asyncio` executor is used.

    Returns:
        Awaitable[Callable]: new async function.

    Example:
    ```python
    def sync_function(x: int) -> int:
        time.sleep(2)
        return x * 2

    async_function = to_async(sync_function)
    await async_function(5) # output 10
    ```
    """
    if is_async(func):
        raise ValueError('The function must be sync, not async.')

    @wraps(func)
    async def wrapper(*args: P_1.args, **kwargs: P_1.kwargs):
        loop = get_event_loop()
        return await loop.run_in_executor(executor, partial(func, *args, **kwargs))

    return wrapper

@decorator
def adaptive(
    func: t.Callable[P_1, t.Union[t.Awaitable[T_1], T_1]]
) -> t.Callable[P_1, t.Union[t.Awaitable[T_1], T_1]]:

    """
    Converts a function to handle both sync and async execution.

    This decorator allows a function to be executed either syncly or asyncly,
    depending whether the event loop is running.

    Example:
    ```python
    def sync_function(x: int) -> int:
        return x * 2

    adaptive(sync_function)(5)
    await adaptive(sync_function)(5)
    ```
    """

    @wraps(func)
    def wrapper(*args: P_1.args, **kwargs: P_1.kwargs):
        loop = get_event_loop()

        if is_async(func):
            result = func(*args, **kwargs)
            if not loop.is_running():
                result = loop.run_until_complete(result)

            return result

        else:
            if loop.is_running():
                return loop.run_in_executor(
                    None,
                    partial(func, *args, **kwargs)
                )

            else:
                return func(*args, **kwargs)

    return wrapper

def is_async(
    obj: t.Callable[P_1, T_1]
) -> te.TypeGuard[t.Callable[P_1, t.Awaitable[T_1]]]:
    """
    Return True if the object is a coroutine function.
    """
    return inspect.iscoroutinefunction(obj)

def get_event_loop():
    """
    Return the current event loop, or create one if none exists.

    Returns:
        asyncio.AbstractEventLoop: The active event loop.

    Example:
        >>> loop = get_event_loop()
    """
    if sys.platform == 'win32':
        policy = asyncio.get_event_loop_policy()

        if not isinstance(
            policy,
            asyncio.WindowsSelectorEventLoopPolicy
        ):
            asyncio.set_event_loop_policy(
                asyncio.WindowsSelectorEventLoopPolicy()
            )

    # https://docs.python.org/3.7/library/asyncio-eventloop.html#asyncio.get_running_loop
    if sys.version_info >= (3, 7):
        try:
            return asyncio.get_running_loop()

        except RuntimeError:
            policy = asyncio.get_event_loop_policy()
            return policy.get_event_loop()
    
    else:
        return asyncio.get_event_loop()

async def cancel(*tasks: asyncio.Task):
    """cancels given tasks and waits until they stop."""
    for task in tasks:
        if (
            not isinstance(task, asyncio.Task)
            or task.done()
        ):
            continue
        
        try:
            task.cancel()
            await task
        except (Exception, asyncio.CancelledError):
            pass
    
async def maybe_await(value: t.Union[T_1, t.Awaitable[T_1]]) -> T_1:
    """await the value if it is awaitable, otherwise return it directly."""
    if inspect.isawaitable(value):
        return await value

    return value


# classes
class Item:
    __slots__ = ('value', 'eviction_value')

    def __init__(
        self,
        value,
        eviction_value: float = 0
    ):

        self.value = value
        self.eviction_value = eviction_value

class Cache:
    """
    A mini caching system with support for three different eviction policies:

    - "LFU": items that are accessed less frequently are evicted first
    - "LRU": items that haven't been accessed for the longest time are evicted first
    - "TTL": items are first removed if they have expired,
      if the cache is still over capacity, the oldest items may also be evicted

    Example:
    ```python
    c = Cache(max_size=3)

    c.add_or_update('key1', 10)
    c.add_or_update('key2', 11)
    c.add_or_update('key3', 12)
    c.add_or_update('key4', 13)
    c.get('key2')

    for k, v in c:
        print(k, v.value)

    >>> key2 11
    >>> key3 12
    >>> key4 13
    ```
    """
    def __len__(self):
        return len(self._cache_data)

    def __init__(
        self,
        max_size: int = 1000,
        time_to_live: int = 3600,
        eviction_policy: t.Literal['LFU', 'LRU', 'TTL'] = 'LFU'
    ):

        self.max_size = max_size
        self.time_to_live = time_to_live
        self.eviction_policy = eviction_policy
    
        self._cache_data: t.Dict[t.Any, Item] = {}

    def pop(self, key):
        result = self._cache_data.pop(key, None) 
        if result:
            return result.value

    def get(self, key, is_value: bool = True):
        item = self._cache_data.get(key)
        
        if isinstance(item, Item):
            if self.eviction_policy == 'LFU':
                item.eviction_value += 1

            if self.eviction_policy == 'LRU':
                item.eviction_value = time.monotonic()

        if item:
            return item.value if is_value else item

    def check(self):
        excess = len(self._cache_data) - self.max_size

        if excess > 0:
            if self.eviction_policy == 'TTL':
                now = time.monotonic()
                to_delete = []

                for key, v in self._cache_data.items():
                    if v.eviction_value < now:
                        to_delete.append(key)

                if to_delete:
                    self.delete(*to_delete)

                excess = len(self._cache_data) - self.max_size

            if excess > 0:
                items = sorted(
                    self._cache_data.items(),
                    key=lambda e: e[1].eviction_value
                )
                to_delete = (key for key, _ in items[:excess])

                if to_delete:
                    self.delete(*to_delete)

    def delete(self, *keys):
        for key in keys:
            Cache.pop(self, key)

    def add_or_update(self, key: t.Any, value, *, check: bool=True) -> Item:
        item = Cache.get(self, key, is_value=False)

        if item is None:
            if self.eviction_policy == 'LFU':
                item = Item(
                    value,
                    eviction_value=0
                )

            elif self.eviction_policy == 'LRU':
                item = Item(
                    value,
                    eviction_value=time.monotonic()
                )

            elif self.eviction_policy == 'TTL':
                item = Item(
                    value,
                    eviction_value=time.monotonic() + self.time_to_live
                )

            self._cache_data[key] = item

            if check:
                self.check()

        item.value = value
        return item

    def __iter__(self):
        return iter(self._cache_data.items())

class Timer:
    """
    A resettable timer

    Starts a countdown for `n` seconds and calls the `callback` when time runs out,
    unless it's reset or stopped before that
        
    Example:
    ```python
    
    async def on_timeout(timer):
        print('No activity detected.')
    
    timer = Timer(10, on_timeout)
    timer.start()

    ...
    print(timer.remaining) # 2
    await timer.reset(10)
    print(timer.remaining) # 10

    ```

    """
    def __init__(
        self,
        n: float,
        callback: t.Callable[['Timer'], t.Any]
    ):
        self.n = n
        self.callback = callback

        self._event = asyncio.Event()
        self._stopped = False
        self._start_time: t.Optional[int] = None
        self._timer_task: t.Optional[asyncio.Task] = None

    async def _timer(self):
        try:
            self._start_time = time.time()
            await asyncio.wait_for(self._event.wait(), self.n)

        except asyncio.TimeoutError:
            if not self._stopped:
                await asyncio.shield(self.callback(self))

        except asyncio.CancelledError:
            pass
    
    @property
    def remaining(self):
        """Seconds remaining before the timer expires."""
        if not self._start_time:
            return 0.0

        elapsed = time.time() - self._start_time
        return max(0.0, self.n - elapsed)

    def is_running(self) -> bool:
        """Check if the timer is currently running."""
        return (
            self._timer_task is not None
            and not self._timer_task.done()
        )

    async def stop(self):
        """Stop the timer."""
        self._stopped = True
        self._start_time = None

        if self.is_running():
            self._timer_task.cancel()
            try:
                await self._timer_task
            except asyncio.CancelledError:
                pass
        self._event.set()

    async def done(self):
        """Stop the timer and run the callback."""
        await self.stop()
        await self.callback(self)

    def start(self):
        """Start the timer if it's not already running."""
        if not self.is_running():
            self._event.clear()
            self._stopped = False
            self._timer_task = asyncio.create_task(self._timer())

        return self

    async def reset(self, n: float):
        """Restart the timer with a new duration."""
        self.n = n
        await self.stop()
        return self.start()

    def __repr__(self) -> str:
        return f'<Timer(remaining={self.remaining}, running={self.is_running()})>'

class Lookup:
    """
    Descriptor for dynamic attribute/method lookup from a context-local object.

    This descriptor allows `Local` instances to forward operations such as `__str__`,
    `__getattr__`, and `__getitem__` to the actual object stored in the current context

    """

    def __init__(self,fn: t.Callable, is_attr: bool = False):
        self.fn = fn
        self.is_attr = is_attr

    def __get__(self, local: 'Local', owner: t.Type['Local']):
        try:
            obj = local._ctx.get()

        except LookupError:
            obj = (
                owner
                if local._ctx_default is _NOTING else
                local._ctx_default
            )

        result = partial(
            self.fn,
            local._ctx.get(obj)
        )
        return result() if self.is_attr else result

class Local(t.Generic[T_1]):
    """
    A context-local container for dynamic scoped values using `ContextVar`.

    `Local` allows you to bind a value to the current
    execution context (`asyncio.Task` / `threading.Thread`) in a way that's safe and isolated.
    It behaves like the underlying object forwarding attribute access, item access,
    and magic methods such as `__str__`, `__getitem__`, etc.
    
    Example:
    ```python
    
    message = Local(default='empty')

    async def print_message():
        print(message)

    async def create_task(id: int):
        set_local(message, f'Hello from task {id}')
        await asyncio.sleep(0.1)  # simulate async delay
        await print_message()

    print(message) # empty
    await asyncio.gather(
        create_task(1),
        create_task(2)
    )
    ```
    """

    def __init__(self, ctx: ContextVar[T_1] = None, default=_NOTING):
        if ctx is None:
            ctx = ContextVar(f'local<{id(self)}>')

        object.__setattr__(self, '_ctx', ctx)
        object.__setattr__(self, '_ctx_default', default)

    __str__ = Lookup(str)
    __repr__ = Lookup(repr)
    __bool__ = Lookup(bool)

    __getattr__ = Lookup(getattr)
    __setattr__ = Lookup(setattr)
    __delattr__ = Lookup(delattr)

    __class__ = Lookup(type, is_attr=True)

class ArcheDict(dict):
    """
    A dict subclass that can reset itself to its original state.

    Handy for mutable configs or states that you want to revert
    without rebuilding the dict from scratch.

    Example:
        >>> d = ArcheDict({'id': 10})
        >>> d['id'] = 15
        >>> d.reset()
        >>> print(d['id'])
        10
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._initial_state = self.copy()

    def reset(self):
        """Restore the dict to its initial contents."""
        self.clear()
        self.update(self._initial_state)
