class BaseError(Exception):
    """
    Base class for all custom exceptions.

    This class serves as a foundation for defining other error types.
    """
    pass

class SecurityError(BaseError):
    """Raised when a security violation is detected."""
    pass
