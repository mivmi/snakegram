# Lexer (Lexical Analyzer) -> Dragon Book. page 81
# The lexer is the first stage in the process of compiler or an interpreter.
# The main task of the lexer is to read the raw source code as a stream of 
# characters and convert it into a sequence of meaningful tokens that can be processed by the 
# parser in subsequent stages.
#
# This lexer performs the conversion of the input string into tokens using two methods:
#
# 1. Using DAWG for fixed-value tokens:
#    For keywords, operators, and separators that have fixed values, 
#    the lexer uses a DAWG (Directed Acyclic Word Graph).
#
#    DAWG is a space-efficient data structure for storing a set of words.
#    It maps each word to a unique path in a Directed Acyclic Graph (DAG) 
#    and shares common paths between words to save memory.
#    This feature makes pattern matching and searching in large string sets 
#    very fast and efficient.
#
#    For example, if our words are `cat`, `bat`, and `rat`, the DAWG state table would look like this:
#
#    | State | Character | Next State | Matched Token |
#    |-------|-----------|------------|---------------|
#    | 0     | c         | 1          |               |
#    | 1     | a         | 2          |               |
#    | 2     | t         | `CAT`      | 'cat'         |
#    | 0     | b         | 4          |               |
#    | 4     | a         | 2          |               |
#    | 2     | t         | `BAT`      | 'bat'         |
#    | 0     | r         | 6          |               |
#    | 6     | a         | 2          |               |
#    | 2     | t         | `RAT`      | 'rat'         |
#
#   https://www.geeksforgeeks.org/introduction-to-directed-acyclic-graph/
#
# 2. Using dynamic handlers for `strings`, `numbers`, and `identifiers`:
#    For tokens with patterns that can vary, such as string literals, `numbers`, and `identifiers`,
#    the lexer uses a custom handler to recognize and process these tokens.
#    This approach allows the lexer to handle dynamic tokens like numbers efficiently.
#
# The combination of DAWG and dynamic handlers ensures that the lexer offers high performance 
# in recognizing fixed tokens while maintaining flexibility for dynamic and complex tokens.

import typing as t
from collections import deque
from . import errors, utils

TypeHandlerCallback = t.Callable[['BaseLexer', str], t.Any]

class Token:
    def __init__(self, name: str, value, position: t.Tuple[int, int]):
        self.name = name
        self.value = value
        self.position = position

    def __repr__(self) -> str:
        if self.value is None or self.name == self.value:
            value = repr(self.name)

        else:
            value = f'{self.name!r}, {self.value!r}'

        return f'{self.__class__.__name__}({value})'

class Handler:
    def __repr__(self):
        return f'{self.__class__.__name__}({self.name!r})'

    def __init__(
        self,
        name: str,
        ignore: bool,
        callback: TypeHandlerCallback
    ):
        self.name = name
        self.ignore = ignore
        self.callback = callback

    def __call__(self, lexer: 'BaseLexer', start_char: str):
        return self.callback(lexer, start_char)

class MetaLexer(type):
    def __new__(
        cls,
        name: str,
        bases: t.Tuple[type, ...],
        attrs: t.Dict[str, t.Any]
    ) -> type:

        if bases:
            tokens = attrs.get('tokens', {})
            dawg_table = attrs.get('dawg_table', {})

            last_state_id = 0
            for key, value in attrs.items():

                if key.startswith('__'):
                    continue

                elif isinstance(value, Handler):
                    if value.name is None:
                        value.name = key

                    if value.name not in tokens:
                        tokens[value.name] = []

                    tokens[value.name].append(value)
                    continue

                elif isinstance(value, str):
                    values = {value}

                elif (
                    isinstance(value, (set, list, tuple))
                    and all(isinstance(e, str) for e in value)
                ):
                    values = set(value)

                else:
                    continue

                for value in values:
                    state_id = 0
                    for char in value:
                        if (state_id, char) not in dawg_table:
                            last_state_id += 1
                            dawg_table[(state_id, char)] = last_state_id

                        state_id = dawg_table[(state_id, char)]

                    dawg_table[(state_id, '$')] = key

            attrs['tokens'] = tokens
            attrs['dawg_table'] = dawg_table

        return super().__new__(cls, name, bases, attrs)

class BaseLexer(metaclass=MetaLexer):
    """
    The `BaseLexer` class is responsible for tokenizing input strings based on defined handlers.
    It utilizes a meta-class (`MetaLexer`) to dynamically handle token definitions and processing.
    This class serves as the foundation for creating custom lexers by extending and defining token handlers.

    # How to Define Tokens
    * To define a token, create a method in your lexer subclass and use the `token` decorator with the token name as an argument.
    The method should handle input starting with a specific character and return the token's value.
    If no valid token is found, `None` should be returned.

    ```python
    class MyLexer(BaseLexer):
        @token('WS', ignore=True)
        def ws_handler(self, value: str):
            if value.isspace():
                return value
    ```

    # Defining Constant Tokens
    * You can define tokens directly as constants. 
    ```python
    class MyLexer(BaseLexer):
        SUB = '-'
        ADD = '+'
        DIV = '/'
        MULTI = '*'

        # You can also define tokens within a list, set, or tuple:
        OPERATORS = {'-', '+', '/', '*'}
    ```

    ## Attributes
        tokens (Dict[str, List[Handler]]):
            A dictionary where the keys are token names and the values are lists of handlers for matching.

        dawg_table (Dict[Tuple[int, str], Union[int, str]]):
            A DAWG (Directed Acyclic Word Graph) transition table.
            The keys are tuples where the first element is the current state ID (int)
            and the second element is the input character (str).
            The values are either the next state ID (int) for valid transitions
            or a token name (str) if the state is terminal and represents a matched token

    """
    tokens: t.Dict[str, t.List['Handler']]
    dawg_table: t.Dict[t.Tuple[int, str], t.Union[int, str]]

    def __init__(self, content: str, name: str = '<stdin>') -> None:
        self.content = content
        self.name = name
        self.position = 0

    def read(self, length: int):
        self.position += length
        return self.content[self.position - length: self.position]

    def iter(self):
        while True:
            char = self.read(length=1)

            if not char:
                break
            yield char

    def readline(self):
        index = self.content.find('\n', self.position)

        if index < 0:
            index = len(self.content)

        return self.read(index - self.position)

    def tokenize(self):
        result = deque()
        while True:
            item = self.get_next_token()
            result.append(item)
            if item.name == '$EOF':
                break

        return result

    def set_position(self, position: int, current: bool = True):
        if current:
            position = self.position + position

        self.position = position
        return self.position

    def get_next_token(self) -> 'Token':
        if self.position >= len(self.content):
            return Token('$EOF', None, (-1, -1))

        result = None
        ignore = False

        # Check for a valid token match using the DAWG.
        state_id = 0
        rollback = False
        response = ''
        position = self.position

        for char in self.iter():
            if (state_id, char) not in self.dawg_table:
                rollback = True
                break
            response += char
            state_id = self.dawg_table[(state_id, char)]

        if rollback:
            # rollback to the previous position
            self.set_position(position=-1)

        name = self.dawg_table.get((state_id, '$'))

        # Check if the end of the string matches a valid token
        if isinstance(name, str):
            result = Token(
                name,
                value=response,
                position=(position, self.position)
            )

        # Handler-based token matching
        self.set_position(position, current=False)
        try:
            start_char = self.read(1)
            for name, handlers in self.tokens.items():
                for handler in handlers:
                    self.set_position(position + 1, current=False)
                    response = handler(self, start_char=start_char)
                    if response is not None:
                        if not result or result.position[1] < self.position:
                            result = Token(
                                name,
                                value=response,
                                position=(position, self.position)
                            )
                            ignore = handler.ignore

            if result is None:
                self.set_position(position, current=False)

                raise SyntaxError(f'Unexpected character {start_char!r}')

        except SyntaxError as error:
            if not isinstance(error, errors.LexerError):
                lineno, column, line = utils.get_position_info(
                    self.content,
                    position=self.position
                )
                error = errors.LexerError(
                    error.msg,
                    (self.name, lineno, column + 1, line)
                )

            raise error from error

        else:
            self.set_position(result.position[1], current=False)

            # Recursively skip ignored tokens
            if ignore:
                return self.get_next_token()

            return result

def token(name: str, *, ignore: bool=False):
    """
    A decorator to define a token pattern in a lexer.

    Use this decorator to link a token name to a function that handles it.
    When the lexer encounters an input matching the token's pattern, it calls the handler

    Args:
        name (str): The name of the token (e.g., 'NUMBER', 'IDENTIFIER').
        ignore (bool, optional): If `True`, the token is ignored during tokenization (default is `False`).

    Returns:
        callable[_LexicalHandler]: A decorator that attaches the token name and ignore argument to the handler function.

    """
    def wrapper(callback: TypeHandlerCallback):
        return Handler(name, ignore=ignore, callback=callback)

    return wrapper

