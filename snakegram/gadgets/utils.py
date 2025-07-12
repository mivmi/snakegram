import inspect
import typing as t

from types import GeneratorType


T_1 = t.TypeVar('T_1')

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
