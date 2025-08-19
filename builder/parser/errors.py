class LexerError(SyntaxError):
    """
    Raised when an error occurs during the lexical analysis phase.
    """
    pass

class ParseError(SyntaxError):
    """
    Raised when an error occurs during the parsing phase of input processing.
    """
    pass

class ConflictError(ValueError):
    """
    A base class for conflicts encountered in grammar parsing.
    """
    pass

class RRConflictError(ConflictError):
    """
    Raised when a Reduce-Reduce conflict occurs during parsing.
    """
    pass

class SRConflictError(ConflictError):
    """
    Raised when a Shift-Reduce conflict occurs during parsing.
    """
    pass
