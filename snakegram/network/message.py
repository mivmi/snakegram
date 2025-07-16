import typing as t
from ..tl import types, mtproto
from ..errors import SecurityError
from ..gadgets.byteutils import Reader, Writer, Int
from ..gadgets.tlobject import TLObject, TLRequest


T = t.TypeVar('T')

class RawMessage(TLRequest):
    def __len__(self):
        return len(self.data)

    def __init__(self, data: t.Union[TLRequest[T], bytes]):
        if isinstance(data, TLObject):
            data = data.to_bytes()
    
        self.data = data

    def to_bytes(self, boxed = True):
        return self.data[0 if boxed else 4:]
    
    @property
    def _id(self):
        return Int.from_bytes(self.data[:4])


# https://core.telegram.org/mtproto/description#encrypted-message
class EncryptedMessage(TLObject):
    def __init__(
        self,
        salt: int,
        session_id: int,
        message: mtproto.types.Message
    ):

        self.salt = salt
        self.session_id = session_id
        self.message = message

    def to_bytes(self, boxed: bool=True):
        with Writer() as writer:
            writer.long(self.salt)
            writer.long(self.session_id)
            
            writer.object(
                self.message,
                boxed=boxed,
                base_type=mtproto.types.Message
            )

            return writer.getvalue()

    @classmethod
    def from_reader(cls, reader: 'Reader'):
        return EncryptedMessage(
            reader.long(),
            reader.long(),
            message=reader.object(
                boxed=False,
                base_type=mtproto.types.TypeMessage
            )
        )

# https://core.telegram.org/mtproto/description#unencrypted-message
class UnencryptedMessage(TLObject):
    def __init__(
        self,
        msg_id: int,
        message: TLObject
    ):

        self.msg_id = msg_id
        self.message = message

    def to_bytes(self, boxed: bool=True):
        body = RawMessage(self.message.to_bytes(boxed))

        with Writer() as writer:
            writer.long(0) # auth key
            writer.long(self.msg_id)
            writer.int(len(body))
            writer.object(body)

            return writer.getvalue()

    @classmethod
    def from_reader(cls, reader: 'Reader'):        
        SecurityError.check(
            reader.long() != 0,
            'unencrypted message auth_key_id != 0'
        )

        msg_id = reader.long()
        reader.int() # length

        return cls(
            msg_id=msg_id,
            message=reader.object()
        )
