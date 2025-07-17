import re
import typing as t

from . import alias
from .tl import types
from .gadgets.utils import is_like_list

def parse_json(data):
    """
    Convert Python value to TL JSON object.

    Example:
    >>> parse_json({'key': 'value'})
    JsonObject([JsonObjectValue('key', JsonString('value'))])
    """
    if data is None:
        return types.JsonNull()

    elif isinstance(data, bool):
        return types.JsonBool(data)
    
    elif isinstance(data, str):
        return types.JsonString(data)

    elif isinstance(data, (int, float)):
        return types.JsonNumber(data)
    
    elif isinstance(data, dict):
        return types.JsonObject(
            [
                types.JsonObjectValue(
                    key=key,
                    value=parse_json(value)
                )
                for key, value in data.items()
            ]
        )

    elif is_like_list(data):
        return types.JsonArray(
            [parse_json(value) for value in data]
        )
    
    else:
        raise ValueError(f'Unsupported data type: {type(data).__name__!r}')

def parse_phone_number(value: t.Union[int, str]) -> t.Optional[alias.Phone]:
    """Remove `non-digit` characters from a phone number."""
    if value is not None:
        if isinstance(value, int):
            return str(value)

        return ''.join(re.findall(r'\d+', value))

def get_display_name(obj: t.Union[types.User, types.TypeChat]):
    """Computes the display name from a User's names or Chat title"""

    result = []
    if isinstance(obj, types.User):
        result.extend([obj.first_name, obj.last_name])
    
    else:
        result.append(getattr(obj, 'title', None))

    return ''.join(filter(None, result))