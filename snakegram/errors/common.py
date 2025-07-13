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
