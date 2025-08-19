import typing as t
from .parser import BaseParser, Rule, Production, Terminal, NonTerminal
from ..lexer import BaseLexer, token

if t.TYPE_CHECKING:
    from .parser import _ProductCallback


HIDDEN = object()
OPTIONAL = object()

# non-terminals
ROOT = NonTerminal('root')
NAME = NonTerminal('name')
EXPR = NonTerminal('expr')
ITEM = NonTerminal('item')
FACTOR = NonTerminal('factor')



class GrammarLexer(BaseLexer):
    OR = '|'
    HIDDEN = '!'
    OPTIONAL = '?'
    OPEN_PAR = '('
    CLOSE_PAR = ')'

    @token('WS', ignore=True)
    def ws_handler(self, value: str):
        if value.isspace():
            return value

    @token('TERMINAL')
    def terminal_handler(self, value: str):
        if value == '`':
            buffer = ''
            for next_char in self.iter():
                if next_char == value:
                    break

                if next_char.isspace():
                    raise SyntaxError(f'Unexpected character {next_char!r}')

                buffer += next_char

            else:
                raise SyntaxError(f'Unterminated terminal sequence: missing closing {value!r}.')

            return buffer

    @token('NON-TERMINAL')
    def non_terminal_handler(self, value: str):
        if value.isidentifier():
            buffer = value
            for next_char in self.iter():
                if not next_char.isidentifier():
                    self.set_position(-1)
                    break

                buffer += next_char

            return buffer

class GrammarParser(BaseParser):
    START = ROOT
    LEXER = GrammarLexer

    def _parse_or(self, left, right):
        return {'_': 'or', 'left': left, 'right': self._term_as_expr(right)}

    def _parse_name(self, value):
        return {'_': value.name.lower(), 'name': value.value}

    def _parse_item(self, value, modifier=None):
        if modifier:
            return {'_': modifier, 'value': value}
        return value

    def _parse_term(self, item_or_items, item=None):
        item = item or []
        if not isinstance(item, list):
            item = [item]
        if not isinstance(item_or_items, list):
            item_or_items = [item_or_items]
        return item_or_items + item

    def _parse_factor(self, value):
        node_type = value.get('_')
        if node_type == 'expr' and len(value['value']) == 1:
            return value['value'][0]
        return value

    def _term_as_expr(self, value):
        return {'_': 'expr', 'value': value}

    def _parse_as_expr(self, value):
        node_type = value.get('_')
        if node_type != 'expr':
            if not isinstance(value, list): # term
                value = [value]

            return {'_': 'expr', 'value': value}
        return value

    def _parse_modifier(self, value):
        return value.name.lower()

    def _to_context_free_grammar(self, value):
        def pretty(data):
            rhs = []
            hidden = set()
            optional = set()

            for index, (status, value) in enumerate(data, start=1):
                if OPTIONAL in status:
                    optional.add(index)

                if HIDDEN in status:
                    hidden.add(index)

                if OPTIONAL not in status:
                    rhs.append(value)

            return tuple(hidden), tuple(optional), tuple(rhs)

        def wrapper(value: dict):
            node_type = value.get('_')

            if node_type == 'or':
                return wrapper(value['left']) + wrapper(value['right'])

            if node_type == 'expr':
                results = [[]]
                for child_node in value['value']:
                    results = [
                        current + child
                        for current in results
                        for child in wrapper(child_node)
                    ]
                return results

            if node_type == 'hidden':
                return [
                    [
                        (other + [HIDDEN], node)
                        for other, node in sub_result
                    ]
                    for sub_result in wrapper(value['value'])
                ]

            if node_type == 'optional':
                sub_results = wrapper(value['value'])
                return sub_results + [
                    [
                        (other + [OPTIONAL], node)
                        for other, node in sub_result
                    ]
                    for sub_result in sub_results
                ]

            if node_type == 'terminal':
                return [
                    [
                        ([], Terminal(value['name']))
                    ]
                ]

            if node_type == 'non-terminal':
                return [
                    [
                        ([], NonTerminal(value['name']))
                    ]
                ]

        # set: removing redundant grammars
        return {pretty(item)
                for item in wrapper(self._parse_as_expr(value))}

    # grammar rules

    rules = {
        START: Rule(
            START,
            productions=[
                Production(
                    START,
                    rhs=[EXPR],
                    callback=_to_context_free_grammar
                )
            ]
        ),
        NAME: Rule(
            NAME,
            productions=[
                Production(
                    NAME,
                    rhs=[Terminal('TERMINAL')],
                    callback=_parse_name
                ),
                Production(
                    NAME,
                    rhs=[Terminal('NON-TERMINAL')],
                    callback=_parse_name
                )
            ]
        ),
        EXPR: Rule(
            EXPR,
            productions=[
                Production(
                    EXPR,
                    rhs=[EXPR, Terminal('OR'), NonTerminal('term')],
                    hidden=(2,),
                    callback=_parse_or
                ),
                Production(
                    EXPR,
                    rhs=[NonTerminal('term')],
                    callback=_term_as_expr
                )
            ]
        ),
        NonTerminal('term'): Rule(
            NonTerminal('term'),
            productions=[
                Production(
                    NonTerminal('term'),
                    rhs=[NonTerminal('term'), ITEM],
                    callback=_parse_term
                ),
                Production(
                    NonTerminal('term'),
                    rhs=[ITEM],
                    callback=_parse_term
                )
            ]
        ),
        ITEM: Rule(
            ITEM,
            productions=[
                Production(
                    ITEM,
                    rhs=[NAME, NonTerminal('modifier')],
                    callback=_parse_item
                ),
                Production(
                    ITEM,
                    rhs=[NAME],
                    callback=_parse_item
                ),
                Production(
                    ITEM,
                    rhs=[FACTOR, NonTerminal('modifier')],
                    callback=_parse_item
                ),
                Production(
                    ITEM,
                    rhs=[FACTOR],
                    callback=_parse_item
                )
            ]
        ),
        NonTerminal('modifier'): Rule(
            NonTerminal('modifier'),
            productions=[
                Production(
                    NonTerminal('modifier'),
                    rhs=[Terminal('HIDDEN')],
                    callback=_parse_modifier
                ),
                Production(
                    NonTerminal('modifier'),
                    rhs=[Terminal('OPTIONAL')],
                    callback=_parse_modifier
                )
            ]
        ),
        FACTOR: Rule(
            FACTOR,
            productions=[
                Production(
                    FACTOR,
                    rhs=[Terminal('OPEN_PAR'), EXPR, Terminal('CLOSE_PAR')],
                    hidden=(1, 3),
                    callback=_parse_factor
                )
            ]
        )
    }

def grammar(value: str, name: str):
    """
    This decorator is used to define grammar rules.
    The provided pattern (value) specifies the right-hand side (RHS) of the grammar rule,  
    while `name` determines the left-hand side (LHS).

    In this grammar system, terminals are symbols enclosed in backticks ( \\`\\` ),
    such as \\`PLUS\\`, while non-terminals are written without backticks, like `expr`.
    The OR operator (|) allows for choice between symbols, meaning `term | factor` can match either term or factor.
    Additionally, two modifiers affect how symbols are processed: ? makes a symbol optional
    allowing it to appear or be omitted, 
    while ! removes the symbol from the output and prevents it from being passed as an argument to the processing function.

    Args:
        value (str): The pattern defining the right-hand side of the grammar rule.
        name (str): The name of the non-terminal associated with this rule.

    Example:
    ```python
    class MyParser(BaseParser):
        @grammar('expr (`SUB` | `ADD`) term', name='expr')
        def bin_op(self, left, op, right):
            return {'_': op.name.lower(), 'left': left, 'right': right}
    ```
    """

    lhs = NonTerminal(name)
    def wrapper(callback: '_ProductCallback'):
        productions = []
        for hidden, optional, rhs in grammar_parser.parse(value, name=callback.__name__):
            productions.append(
                Production(lhs,
                           rhs=list(rhs),
                           hidden=hidden,
                           optional=optional,
                           callback=callback)
            )

        class _Wrapper(Rule):
            def __call__(self, *args, **kwds):
                return callback(self, *args, **kwds)

        return _Wrapper(lhs, productions=productions)

    return wrapper

grammar_parser = GrammarParser()