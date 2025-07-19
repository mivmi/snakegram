import re
import typing as t
from .common import BaseError

if t.TYPE_CHECKING:
    from ..network.utils import Request

RPC_ERRORS: t.Dict[str, 'RpcError'] = {}
REGEX_RPC_ERRORS: t.Dict[re.Pattern, 'RpcError'] = {}

class RpcError(BaseError):
    """
    This class is designed to process and manage errors returned from the Telegram server.
    
    Features:
        - Converts specific error messages into corresponding error classes.
        - Supports both direct matching (`error_message`) and regex-based (`regex`) identification.
    """

    error_code: int

    @classmethod
    def __init_subclass__(
        cls,
        pattern: t.Optional[t.Union[str, re.Pattern]] = None
    ):
        # auto registers error patterns for subclasses
        

        if not hasattr(cls, 'error_code'):
            raise AttributeError(
                'The "error_code" attribute must be set.'
            )

        if isinstance(pattern, str):
            RPC_ERRORS[pattern] = cls

        elif isinstance(pattern, re.Pattern):
            REGEX_RPC_ERRORS[pattern] = cls


    def __init__(
        self,
        request: 'Request',
        message: str,
        error_code: t.Optional[int] = None
    ):
        self.request = request
        self.message = message
        self.error_code = error_code or getattr(self, 'error_code', -1)

        details = self.message
        if self.error_code != -1:
            details = f'[error_code: {self.error_code}] {details}'

        super().__init__(f'{details} (caused by {request.name!r})')

    @staticmethod
    def build(
        request: 'Request',
        message: str,
        error_code: int
    ):
        """
        Creates an appropriate `RpcError` instance based on the error message.
        
        Args:
            request (Request): The associated request object.
            message (str): The received error message.
            error_code (int): The received error code.
        
        Returns:
            RpcError: An instance of a subclass corresponding to the error.
            If no match is found, a general `RpcError` instance is returned.
        """

        # Check for direct error matches (O(1))
        error_cls = RPC_ERRORS.get(message)
        if error_cls:
            return error_cls(request)

        # Check for regex-based error matches (O(n))
        for pattern, error_cls in REGEX_RPC_ERRORS.items():
            match = pattern.match(message)
            if match:
                kwargs = {
                    k: int(v) if v.isdigit() else v
                    for k, v in match.groupdict().items()
                }
                return error_cls(request, **kwargs)

        # If no specific error is found, return a general UnknownError instance
        return UnknownError(request, message, error_code)



# Rpc Error Subclasses
class TimedoutError(RpcError, pattern='Timeout'):
    """
    Timeout error.

    This error occurs when the request takes too long to complete, and the server times out.
    """
    error_code = -503

    def __init__(self, request: 'Request', message, error_code=None):
        super().__init__(
            request,
            f'Timeout while fetching data: {message}',
            error_code=error_code
        )

class SeeOtherError(RpcError):
    """
    See other data center error.
    
    This error occurs when a request needs to be retried, but must be directed to another data center.
    """
    dc_id: int
    error_code = 303

class BadRequestError(RpcError):
    """
    Bad request error.
    
    This error occurs when a query is invalid or contains incorrectly generated data.
    You must correct the data before resubmitting the request.
    """

    error_code = 400

class UnauthorizedError(RpcError):
    """
    Unauthorized error.

    This error occurs when there is an unauthorized attempt to use functionality
    that is available only to authorized users.

    """
    error_code = 401

class ForbiddenError(RpcError):
    """
    Forbidden error.

    This error occurs when a privacy violation happens, such as trying to 
    access a resource that the user does not have permission to access.

    """
    error_code = 403

class NotFoundError(RpcError):
    """
    Not found error.

    This error occurs when an attempt is made to access a value or resource that does not exist.
    """
    error_code = 404

class NotAcceptableError(RpcError):
    """
    Not acceptable error.

    This error occurs when the server cannot process the request due to the content type or
    other aspects that the server cannot handle.
    This error occurs when the server cannot process the request
    due to issues like invalid content type or an invalid or duplicated authorization key that the server rejects.

    """
    error_code = 406

class FloodError(RpcError):
    """
    Flood Error.
    
    This error occurs when too many requests are sent in a short period.
    
    """

    error_code = 420

class InternalError(RpcError):
    """
    Internal server error.

    This error occurs when the server encounters an unexpected issue while processing 
    the request. It indicates 
    that the server is unable to fulfill the request due to a problem on the server-side.
    """
    error_code = 500

class UnknownError(RpcError):
    """
    Unknown error.

    This error occurs when an undefined or unclassified error happens. It should be reported 
    so that it can be properly defined and handled in the future.

    """
    error_code = -500

    def __init__(self, request: 'Request', message, error_code = None):
        super().__init__(
            request,
            f'{message!r}. This error should be reported '
            'so that it can be properly defined and handled in the future.',
            error_code=error_code
        )

