
import pytest
from snakegram.tl.types import BoolTrue
from snakegram.gadgets.tlobject import TLObject
from snakegram.gadgets.byteutils import Int, Reader, Writer

class DummyTLObject(TLObject, family='TypeDummy'):
    _id = 1
    _group_id = 2

    def to_bytes(self, boxed=True):
        return Int.to_bytes(self._id) if boxed else b''
    
    @classmethod
    def from_reader(cls, reader: Reader):
        return cls()


@pytest.mark.parametrize('signed', [True, False])
@pytest.mark.parametrize(
    'value',
    [
        lambda _: 0, # common
        lambda signed: signed and -0x80000000 or 0, # start
        lambda signed: signed and 0x7fffffff or 0xffffffff # end
    ]
)
def test_int(value, signed):
    # This test covers only the Int class because other numeric classes
    # (`Long`, `Int128`, `Int256`) inherit from it.
    # correct functionality of Int implies correct behavior of its subclasses.

    val = value(signed)
    data = Int.to_bytes(val, signed=signed)
    val_back = Int.from_bytes(data, signed=signed)
    assert val_back == val


def test_flag():
    writer = Writer()

    with writer.flag() as flag:
        flag(False, 0)
        flag(True, 1)   # set
        flag(True, 3)   # set
        flag(False, 2)

    data = writer.getvalue()

    reader = Reader(data)
    read_flag = reader.flag()

    assert read_flag(0) is False
    assert read_flag(1) is True
    assert read_flag(2) is False
    assert read_flag(3) is True


@pytest.mark.parametrize('length', [10, 253])
def test_bytes_small(length):
    data = b'a' * length
    writer = Writer()
    writer.bytes(data)
    raw = writer.getvalue()

    assert raw[0] == length

    start = 1
    end = start + length
    assert raw[start:end] == data

    assert len(raw) % 4 == 0

    reader = Reader(raw)
    result = reader.bytes()
    assert result == data

@pytest.mark.parametrize('length', [254, 300])
def test_bytes_large(length):
    data = b'b' * length
    writer = Writer()
    writer.bytes(data)
    raw = writer.getvalue()

    assert raw[0] == 254  # 0xfe

    length_in_header = int.from_bytes(raw[1:4], 'little')
    assert length_in_header == length

    start = 4
    end = start + length
    assert raw[start:end] == data

    assert len(raw) % 4 == 0

    reader = Reader(raw)
    result = reader.bytes()
    assert result == data


# Common between `tlobject` and `byteutils`

def test_writer_object_correct():
    writer = Writer()
    obj = DummyTLObject()
    writer.object(obj)
    data = writer.getvalue()
    assert Int.from_bytes(data) == 1


def test_writer_object_wrong_type():
    writer = Writer()
    with pytest.raises(TypeError):
        writer.object(123)


def test_writer_object_wrong_group():
    writer = Writer()
    obj = BoolTrue()
    with pytest.raises(ValueError):
        writer.object(obj, group_id=DummyTLObject._group_id)


def test_writer_object_bool_conversion():
    writer = Writer()
    writer.object(True, group_id=BoolTrue._group_id)
    data = writer.getvalue()

    assert Int.from_bytes(data, signed=False) == BoolTrue._id 

def test_writer_vector_normal():
    writer = Writer()
    items = [1, 2, 3]
    writer.vector(items, callback=lambda x: writer.int(x))
    data = writer.getvalue()

    assert data.startswith(Int.to_bytes(0x1cb5c415))
    assert Int.from_bytes(data[4:8], signed=False) == 3

def test_writer_vector_callback_error():
    writer = Writer()
    items = [1, 2]
    def bad_callback(x):
        if x == 2:
            raise ValueError('bad item')
        writer.int(x)

    with pytest.raises(ValueError):
        writer.vector(items, callback=bad_callback)
