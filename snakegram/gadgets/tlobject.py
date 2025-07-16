import typing as t
import typing_extensions as te

from .utils import to_string, dualmethod
from abc import ABC, abstractmethod


if t.TYPE_CHECKING:
    from .byteutils import Reader

T = t.TypeVar('T')
P = te.ParamSpec('P')

TYPES_MAP: t.Dict[int, 'TLObject'] = {}
TYPES_GROUP_MAP: t.Dict[int, t.Tuple[t.Set['TLObject'], str]] = {}


class TLObject(t.Generic[T], ABC):
    """
    type language object.

    This class defines abstract methods for serialization and deserialization.
    
    Attributes:
        _id (Optional[int]): Unique id for each type.
        _group_id (Optional[int]): Group id associated with this type.
    """

    _id: t.Optional[int] = None
    _group_id: t.Optional[int] = None

    def __repr__(self):
        return self.to_string()

    def to_dict(self) -> t.Dict[str, t.Any]:
        result = {
            '_': self.__class__.__qualname__
        }
        for name, value in self.__dict__.items():
            if name.startswith('_'):
                continue

            if hasattr(value, 'to_dict'):
                value = value.to_dict()

            result[name] = value
        return result

    def to_tuple(self):
        result = []

        for name, value in self.__dict__.items():
            if name.startswith('_'):
                continue

            if hasattr(value, 'to_tuple'):
                value = value.to_tuple()
            
            result.append(value)
        
        return tuple(result)   

    def to_string(self, indent: int = None):
        return to_string(self.to_dict(), indent=indent)

    def replace(self, **kwargs) -> te.Self:
        """
        Creates a new instance of the class with updated values for its parameters.

        This method uses the current values of the object and any new values passed
        via `kwargs` to create a new instance of the same class, effectively "replacing"
        the current object's values with those provided. If a value for a parameter
        is not provided in `kwargs`, the method will use the current value of that
        parameter from the object itself.

        Parameters:
            **kwargs: The keyword arguments containing the new values for the object's
                    parameters. If a parameter is not present in `kwargs`, the method
                    will use the existing value from the current instance.

        Returns:
            A new instance of the class with updated values for its parameters.
        
        Example:
            >>> obj = SomeClass(a=1, b=2)
            >>> obj.replace(a=3)
            >>> SomeClass(a=3, b=2)
        """
        init_method = type(self).__init__

        return type(self)(
            **{
                name: (
                    kwargs.get(name)
                    or getattr(self, name)
                )
                for name in init_method.__annotations__.keys()
            }
        )

    def __init_subclass__(cls, family: t.Optional[str] = None):
        """
        Automatically executed when a subclass is defined.

        If the subclass defines an `_id`, it is registered in `TYPES_MAP`.
        """

        if not hasattr(cls, '_result_type'): # is type
            if cls._id:
                TYPES_MAP[cls._id] = cls

            if cls._group_id not in TYPES_GROUP_MAP:
                TYPES_GROUP_MAP[cls._group_id] = ({cls}, family)

            else:
                TYPES_GROUP_MAP[cls._group_id][0].add(cls)


    @abstractmethod
    def to_bytes(self, boxed: bool = True) -> t.ByteString:
        """
        Serializes the object into byte.

        Args:
            boxed (bool, default=True): If `True`,
                the `obj._id` (32-bit integer) will be prepended to the byte.

        Returns:
            ByteString: The serialized byte data.
        """

        raise NotImplementedError

    @classmethod  
    @abstractmethod  
    def from_reader(cls, reader: 'Reader') -> te.Self:
        """
        Deserializes byte into an object using a `Reader`.

        Args:
            reader (Reader): The reader object that processes byte.
        
        Returns:
            Self: An instance of the subclass created from the parsed byte.

        """
        raise NotImplementedError


class TLRequest(TLObject[T], ABC):
    _id: int
    _result_id: t.Optional[int] = None

    @abstractmethod
    def to_bytes(self, boxed: bool = True) -> bytes:
        return None

    @classmethod
    def from_reader(cls, reader: 'Reader'):
        raise RuntimeError(
            f'Cannot deserialize {cls.__name__!r}: '
            f'functions cannot be deserialized (pos: {reader.tell() - 4})'
        )

    def _get_origin(self) -> 'TLRequest':
        cls = self.__class__
        if cls.__orig_bases__:
            result_type, = t.get_args(cls.__orig_bases__[0])

            if isinstance(result_type, t.TypeVar):
                for name, tp in cls.__init__.__annotations__.items():
                    args = t.get_args(tp)
                    if args and args[0] == result_type:
                        return getattr(self, name)._get_origin()

        return self

    @dualmethod
    def _result_type(obj) -> t.Optional[t.Tuple[TLObject]]:
        if obj._result_id:
            return get_group_types(obj._result_id)

        # the return type is based on a generic
        # to resolve the result type, the class must be init first
        if not isinstance(obj, type):
            root = obj._get_origin()
            return root._result_type()


def get_group_name(group_id: int):
    """get group name for the given `group_id`.."""
    return TYPES_GROUP_MAP[group_id][1]

def get_group_types(group_id: int):
    """get types for the given `group_id`."""
    return tuple(TYPES_GROUP_MAP[group_id][0])
