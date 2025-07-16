import typing as t
from .common import BaseError

if t.TYPE_CHECKING:
    from ..network.utils import Request


BAD_MESSAGE_ERRORS = {}
BAD_MESSAGE_DESCRIPTIONS = {
    16: 'msg_id too low (most likely, client time is wrong)',
    17: 'msg_id too high (most likely, client time is wrong)',
    18: 'incorrect two lower order msg_id bits (the server expects client message msg_id to be divisible by 4)',
    19: 'container msg_id is the same as msg_id of a previously received message (this must never happen)',
    20: 'message too old, and it cannot be verified whether the server has received a message with this msg_id or not',
    32: 'msg_seqno too low (the server has already received a message with a lower msg_id but with either a higher or an equal and odd seqno)',
    33: 'msg_seqno too high (similarly, there is a message with a higher msg_id but with either a lower or an equal and odd seqno)',
    34: 'an even msg_seqno expected (irrelevant message), but odd received',
    35: 'odd msg_seqno expected (relevant message), but even received',
    48: 'incorrect server salt (expected updated server_salt)',
    64: 'invalid container'
}


# https://core.telegram.org/mtproto/service_messages_about_messages#notice-of-ignored-error-message
class BadMessageError(BaseError):
    index: int = 0

    def __init__(
        self,
        request: 'Request',
        message: str,
        error_code: int
    ):
        self.request = request
        self.error_code = error_code
        super().__init__(f'[error_code: {error_code}] {message}')

    def __init_subclass__(cls, index: int):
        cls.index = index
        BAD_MESSAGE_ERRORS[index] = cls

    @staticmethod
    def build(request: 'Request', error_code: int):
        message = BAD_MESSAGE_DESCRIPTIONS.get(error_code)

        if message is None:
            return BadMessageError(
                request,
                message='Unknown bad message error',
                error_code=error_code
            )

        index = error_code >> 4
        return BAD_MESSAGE_ERRORS.get(index, BadMessageError)(
            request,
            message,
            error_code=error_code
        )

# Bad Message Error Subclasses
class InvalidMsgIdError(BadMessageError, index=1):
    """
    Raised when the `msg_id` is invalid (too low or too high).
    """
    pass

class InvalidMsgSeqnoError(BadMessageError, index=2):
    """
    Raised when the `msg_seqno` is incorrect.
    """
    pass

class InvalidServerSaltError(BadMessageError, index=3):
    """
    Raised when the `server_salt` is incorrect.
    """
    pass

class InvalidContainerError(BadMessageError, index=4):
    """
    Raised when the message container is invalid.
    """
    pass
