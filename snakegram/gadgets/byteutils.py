import io
import gzip
import typing as t
from random import randint
from struct import pack, unpack
from contextlib import contextmanager
from .tlobject import TLObject, TYPES_MAP, get_group_name


VECTOR_ID = 0x1cb5c415
STRING_ERROR = 'replace'
STRING_ENCODE = 'utf-8'


class Int(int):
    length = 32
    def __new__(cls, signed: bool = True):
        """Generate a random integer."""

        if signed:
            return randint(
                a=-(2 ** (cls.length - 1)),
                b=2 ** (cls.length - 1) - 1
            )

        else:
            return randint(
                a=0,
                b=2 ** cls.length - 1
            )

    @classmethod
    def to_bytes(cls,
                 value: t.Union[int, float],
                 signed: bool = True,
                 byteorder: t.Literal['big', 'little'] = 'little'):
        """Convert an integer to  bytes."""

        value = int(value)
        return value.to_bytes(cls.length // 8, byteorder, signed=signed)

    @classmethod
    def from_reader(cls,
                    reader: 'Reader',
                    signed: bool = True,
                    byteorder: t.Literal['big', 'little'] = 'little'):
        """Read a number from a `Reader` object."""

        value = reader.read(cls.length // 8)
        return cls.from_bytes(value, signed, byteorder)

    @classmethod
    def from_bytes(
        cls,
        value: t.ByteString,
        signed: bool = True,
        byteorder: t.Literal['big', 'little'] = 'little'
    ):
        """Convert a bytes to integer."""

        return int.from_bytes(value, byteorder, signed=signed)

class Long(Int):
    length = 64

class Int128(Int):
    length = 128

class Int256(Int):
    length = 256

class Reader(io.BytesIO):

    def flag(self):
        """Reads an integer value and returns a function that checks if a specific bit is set in that integer.

        This method first reads a 32-bit integer and returns a wrapper function that can be used
        to check if a specific flag (bit) is set.

        Returns:
            callable: A function that takes an index and returns True if the bit at that index is set, False otherwise.

        Example:
            >>> func = reader.flag()
            >>> print(func(3))
        """
        value = self.int(signed=False)
        
        def wrapper(index: int):
            return bool(value & (1 << index))
        
        return wrapper

    def int(self, signed: bool = True):
        """Reads a 32-bit integer."""
        return Int.from_reader(self, signed)

    def long(self, signed: bool = True):
        """Reads a 64-bit integer."""
        return Long.from_reader(self, signed)

    def int128(self, signed: bool = True):
        """Reads a 128-bit integer."""
        return Int128.from_reader(self, signed)

    def int256(self, signed: bool = True):
        """Reads a 256-bit integer."""
        return Int256.from_reader(self, signed)

    def double(self) -> float:
        """Reads a [double](https://core.telegram.org/type/double)."""

        return unpack('<d', self.read(8))[0]

    def bytes(self):
        """Reads a [bytes](https://core.telegram.org/type/bytes)."""
        length = ord(self.read(1))

        if length == 254:
            length = int.from_bytes(self.read(3), 'little')

            padding_length = (-length) % 4
        else:
            padding_length = (3 - length) % 4

        result = self.read(length)

        # skip padding
        if padding_length > 0:
            self.read(padding_length)

        return result

    def string(self):
        """Reads a string."""
        result = self.bytes()
        return result.decode(STRING_ENCODE, STRING_ERROR)
 
    def object(
        self,
        boxed: bool = True,
        group_id: t.Optional[int] = None,
        base_type: t.Type[TLObject] = TLObject,
    ):
        """Reads a `TLObject`."""

        if boxed:
            object_id = self.int(signed=False)
            
            if object_id == VECTOR_ID:
                return self.vector(self.object, boxed=False)

            object_type = TYPES_MAP.get(object_id)
            if object_type is None:
                raise ValueError(f'Constructor with ID {hex(object_id)!r} not found.')

        else:
            object_type = base_type

        if not issubclass(object_type, base_type):
            raise TypeError(
                f'Expected an instance of {base_type.__name__!r},'
                f' but got {object_type.__name__!r}.'
            ) 

        if isinstance(group_id, int):
            if group_id != object_type._group_id:
                raise ValueError(
                    f'Expected an instance of {get_group_name(group_id)!r}, '
                    f'but got {object_type.__name__!r}.'
                )

        result = object_type.from_reader(self)

        if isinstance(result, TypeBool):
            result = isinstance(result, BoolTrue) 

        elif isinstance(result, GzipPacked):
            with Reader(gzip.decompress(result.packed_data)) as reader:
                result = reader.object()

        return result


    def vector(self, callback: t.Callable[[], t.Any], boxed: bool = True):
        """Reads a [Vector](https://core.telegram.org/constructor/vector)."""
        if boxed:
            object_id = self.int(signed=False)
            if object_id != VECTOR_ID:
                raise ValueError(
                f'Invalid constructor ID {hex(object_id)!r}. Expected {hex(VECTOR_ID)!r}.'
            )

        result = []
        for index in range(self.int(signed=False)):
            try:
                result.append(callback())

            except Exception as err:
                raise ValueError(f'Error at index {index}') from err

        return result

class Writer(io.BytesIO):
    def __init__(self, initial=b''):
        super().__init__(initial)
        self.seek(0, io.SEEK_END)

    @contextmanager
    def flag(self):
        """A context manager to manage a flag.

        The flag is a 4-byte value that can be modified based on a condition during the context block.

        Yields:
            callable: A wrapper to modify the flag.
                - The first argument (test) is any condition to check if the flag should be set.
                - The second argument (value) is an integer that indicates the flag value.

        Example:
            ```python
            value = 'this is test'
            with writer.flag() as flag:
                if flag(value, 1):
                    writer.string(value)
            ```
        """
        result = 0
        cache = {}
        offset = self.tell()
        # Write 4 bytes and reserve space for the flag
        self.write(b'\x00\x00\x00\x00')

        def wrapper(test, value: int):
            nonlocal result, cache

            test = bool(test)
            if test:
                result |= 1 << value

            if value not in cache:
                cache[value] = test

            elif test != cache[value]:
                raise ValueError(f'Parameters related to flag {value} must either all be exist or none of them.')

            return bool(test)

        try:
            yield wrapper
        
        finally:
            # If the flag is changed, write the result at the appropriate position
            if result > 0:
                self.seek(offset)
                self.write(Int.to_bytes(result, signed=False))
                self.seek(0, io.SEEK_END)

    def int(self, value: t.Union[int, float], signed: bool = True, byteorder: t.Literal['big', 'little'] = 'little'):
        """Write a 32-bit integer."""
        self.write(Int.to_bytes(value, signed, byteorder))

    def long(self, value: t.Union[int, float], signed: bool = True, byteorder: t.Literal['big', 'little'] = 'little'):
        """Write a 64-bit integer."""
        self.write(Long.to_bytes(value, signed, byteorder))

    def int128(self, value: t.Union[int, float], signed: bool = True, byteorder: t.Literal['big', 'little'] = 'little'):
        """Write a 128-bit integer."""
        self.write(Int128.to_bytes(value, signed, byteorder))

    def int256(self, value: t.Union[int, float], signed: bool = True, byteorder: t.Literal['big', 'little'] = 'little'):
        """Write a 256-bit integer."""
        self.write(Int256.to_bytes(value, signed, byteorder))

    def double(self, value: t.Union[int, float]):
        """Write a [double](https://core.telegram.org/type/double)."""
        if isinstance(value, int):
            value = float(value)

        self.write(pack('<d', value))

    def bytes(self, value: t.Union[str, bytes]):
        """Write a [bytes](https://core.telegram.org/type/bytes)."""

        length = len(value)
        if length < 254:
            header = length.to_bytes(1, 'little')
        else:
            header = b'\xfe' + length.to_bytes(3, 'little')

        result = header + value
        padding_length = -len(result) % 4

        if padding_length > 0:
            result += b'\x00' * padding_length
    
        self.write(result)

    def string(self, value: t.Union[str, bytes]):
        """Write a string or bytes."""
        if isinstance(value, str):
            value = value.encode(STRING_ENCODE, STRING_ERROR)

        self.bytes(value)

    def object(
        self,
        value: TLObject,
        boxed: bool = True,
        group_id: int = None,
        base_type: t.Type[TLObject] = TLObject,
    ):
        """Write a `TLObject`."""

        if (
            group_id == BoolTrue._group_id # BoolTrue._group_id == BoolFalse._group_id
            and not isinstance(value, TypeBool)
        ):
            value = BoolTrue() if value else BoolFalse()

        if not isinstance(value, base_type):
            raise TypeError(f'Expected an instance of {base_type.__name__!r},'
                            f' but got {type(value).__name__!r}.')

        if isinstance(group_id, int):
            if group_id != value._group_id:    
                raise ValueError(
                    f'Expected an instance of {get_group_name(group_id)!r}, '
                    f'but got {type(value).__name__!r}.'
                )

        self.write(value.to_bytes(boxed))

    def vector(self, value: t.Iterable, callback: t.Callable, boxed: bool = True):
        """Write a [Vector](https://core.telegram.org/constructor/vector)."""

        if boxed:
            self.write(b'\x15\xc4\xb5\x1c')  # self.int(VECTOR_ID)

        # Check if `value` is an object with a `__len__` method
        if hasattr(value, '__len__'):
            length = len(value)
            pointer = -1

        else:
            length = 0
            pointer = self.tell()

        self.int(length)
        actual_length = 0

        for index, item in enumerate(value):
            actual_length += 1
            try:
                callback(item)

            except Exception as err:
                raise ValueError(
                    f'Error at index {index}, item type: {type(item).__name__!r}.'
                ) from err

        # If `pointer` exists and lengths don't match, update the new length in the stream
        if pointer >= 0 and length != actual_length:
            self.seek(pointer)
            self.write(Int.to_bytes(length, signed=False))
            self.seek(0, io.SEEK_END)


def long_to_bytes(value: int):
    """Unsigned long integer to bytes in big-endian order."""

    return int.to_bytes(
        value,
        (value.bit_length() + 7) // 8
    )

def bytes_to_long(value: bytes):
    """bytes to an unsigned long integer in big-endian order."""
    return int.from_bytes(value, byteorder='big', signed=False)

# https://github.com/DrKLO/Telegram/blob/17067dfc6a1f69618a006b14e1741b75c64b276a/TMessagesProj/src/main/java/org/telegram/messenger/SRPHelper.java#L9
def big_integer_bytes(value: int):
    """Converts an integer to a 256-byte big-endian order."""
    bytes_value = long_to_bytes(value)

    if len(bytes_value) > 256:
        return bytes_value[1:257]

    elif len(bytes_value) < 256:
        return bytes_value.rjust(256, b'\x00')

    return bytes_value

# circular import
from ..tl.types.bool import TypeBool, BoolTrue, BoolFalse  # type: ignore
from ..tl.mtproto.types import GzipPacked # type: ignore
