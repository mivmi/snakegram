import typing as t

TRANSPORT_ERRORS: t.Dict[int, t.Type['TransportError']] = {}


class BaseError(Exception):
    """
    Base class for all custom exceptions.

    This class serves as a foundation for defining other error types.
    """
    pass

class SecurityError(BaseError):
    """Raised when a security violation is detected."""

    @staticmethod
    def check(
        test: bool,
        message: str = 'Security check failed'
    ):
        """Raise `SecurityError` if test is True."""

        if test:
            raise SecurityError(message)

class StopPropagation(BaseError):
    """Stop event propagation to subsequent handlers"""
    pass

class StopRouterPropagation(BaseError):
    """Stop only the current router's event processing."""
    pass

class HandshakeFailedError(BaseError):
    """Raised when the handshake fails"""
    pass


class TransportError(BaseError):
    """
    Base class for [transport-errors](https://core.telegram.org/mtproto/mtproto-transports#transport-errors).
    """
    error_code: int = -500

    def __init__(
        self,
        message: str,
        error_code: t.Optional[int] = None
    ):
    
        self.error_code = (
            error_code
            or self.__class__.error_code
        )
        super().__init__(
            f'[error_code: {self.error_code}] {message}'
        )

    def __init_subclass__(cls, error_code: int):
        cls.error_code = error_code
        TRANSPORT_ERRORS[error_code] = cls

    @staticmethod
    def from_code(error_code: int):
        if error_code not in TRANSPORT_ERRORS:
            return TransportError(
                'Unknown transport error',
                error_code=-500
            )

        return TRANSPORT_ERRORS[error_code]()


# Transport Error Subclasses
class ForbiddenError(TransportError, error_code=400):
    """
    Access to the requested resource is denied.

    This error occurs when the user does not have the necessary permissions 
    to perform the requested action, similar to an `HTTP 403` error.
    """

    def __init__(self):
        super().__init__(
            'Access denied: '
            'You do not have permission to perform this action.'
        )

class AuthKeyNotFoundError(TransportError, error_code=404):
    """
    Raised when the specified `auth_key_id` cannot be found by server.

    This error typically occurs during the initial MTProto handshake or when 
    certain MTProto fields are incorrect.
    """

    def __init__(self):
        super().__init__(
            'The specified auth key is invalid or missing.'
        )

class TransportFloodError(TransportError, error_code=429):
    """
    Raised when too many transport connections are established to the same IP 
    in a short period.

    This error usually indicates that the client is making too many requests 
    within a short time.
    """

    def __init__(self):
        super().__init__(
            'Too many transport connections have been established '
            'to the same IP in a short time.'
        )

class InvalidDcError(TransportError, error_code=444):
    """
    Raised when an invalid `dc_id` is specified.

    This error may occur while creating an auth key, connecting to an MTProxy, 
    or if an incorrect `dc_id` is provided.
    """

    def __init__(self):
        super().__init__(
            'The specified dc_id is incorrect. This may happen '
            'while creating an auth key, connecting to an MTProxy, or if an invalid dc_id is used.'
        )
