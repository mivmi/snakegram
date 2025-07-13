import os
import sys
import asyncio
import inspect
import typing as t
import typing_extensions as te

from functools import wraps, partial
from types import GeneratorType


T_1 = t.TypeVar('T_1')
P_1 = te.ParamSpec('P_1')

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

def is_like_list(obj) -> t.TypeGuard[t.Iterable[T_1]]:
    """Return True if the object is iterable and not str, bytes, or bytearray."""
    return (
        hasattr(obj, '__iter__')
        and not isinstance(obj, (str, bytes, bytearray))
    )


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

def is_async(
    obj: t.Callable[P_1, T_1]
) -> t.TypeGuard[t.Callable[P_1, t.Awaitable[T_1]]]:
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

async def maybe_await(value: t.Union[T_1, t.Awaitable[T_1]]) -> T_1:
    """await the value if it is awaitable, otherwise return it directly."""
    if inspect.isawaitable(value):
        return await value

    return value


# classes
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
