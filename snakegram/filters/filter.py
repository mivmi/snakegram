import operator
import typing as t
import typing_extensions as te


from inspect import isclass
from abc import ABC, abstractmethod

from ..enums import Operation
from ..gadgets.utils import decorator, to_string, maybe_await

T = t.TypeVar('T')
P = te.ParamSpec('P')

OPERATION_STRATEGIES = {
    Operation.EQ: operator.eq,
    Operation.NE: operator.ne,
    Operation.LT: operator.lt,
    Operation.LE: operator.le,
    Operation.GT: operator.gt,
    Operation.GE: operator.ge,
    Operation.IN: operator.contains,
    Operation.NOT: operator.not_,

    #
    Operation.OR: lambda a, b: a or b,
    Operation.AND: lambda a, b: a and b,
    Operation.TYPE_OF: lambda a, b: (
        issubclass(a, b)
        if isclass(a) else
        isinstance(a, b)
    )
}


class BaseFilter(ABC):
    def __lt__(self, other: t.Any):
        return FilterExpr(Operation.LT, self, other)

    def __gt__(self, other: t.Any):
        return FilterExpr(Operation.GT, self, other)

    def __le__(self, other: t.Any):
        return FilterExpr(Operation.LE, self, other)

    def __ge__(self, other: t.Any):
        return FilterExpr(Operation.GE, self, other)

    def __eq__(self, other: t.Any):
        return FilterExpr(Operation.EQ, self, other)

    def __ne__(self, other: t.Any):
        return FilterExpr(Operation.NE, self, other)

    def __and__(self, other: t.Any):
        return FilterExpr(Operation.AND, self, other)

    def __or__(self, other: t.Any):
        return FilterExpr(Operation.OR, self, other)

    def __invert__(self):
        return FilterExpr(Operation.NOT, self)

    def __lshift__(self, other: t.Any):
        return FilterExpr(Operation.IN, other, self)

    def __rshift__(self, other: t.Any):
        return FilterExpr(Operation.IN, self, other)

    def __mod__(self, other: t.Any):
        return FilterExpr(Operation.TYPE_OF, self, other)

    @abstractmethod
    async def evaluate(self, value: t.Any) -> t.Any:
        """Apply the filter to the input value."""
        raise NotImplementedError

class FilterExpr(BaseFilter):
    def __repr__(self):
        return self.to_string()

    def __init__(self, op: Operation, left, right = None):
        self.op = op
        self.left = left
        self.right = right
    
    def to_dict(self):
        def wrapper(value):
            if hasattr(value, 'to_dict'):
                value = value.to_dict()
            
            return value

        return {
            '_': type(self).__name__,
            'op': self.op,
            'left': wrapper(self.left),
            'right': wrapper(self.right)
        }

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent=indent)

    async def evaluate(self, value: t.Any):
        async def resolve(operand):
            if isinstance(operand, BaseFilter):
                operand = operand.evaluate(value)

            return await maybe_await(operand)

        strategy = OPERATION_STRATEGIES.get(self.op)
        if not strategy:
            raise ValueError(f'Unsupported operation: {self.op!r}')

        left = await resolve(self.left)
    
        # Short-circuit logical operations
        if self.op is Operation.NOT:
            return strategy(left)
        
        if self.op is Operation.OR and left:
            return left
        
        if self.op is Operation.AND and not left:
            return False

        return strategy(left, await resolve(self.right))

class CustomFilter(t.Generic[P, T], BaseFilter):
    def __repr__(self):
        return self.to_string()

    def to_dict(self) -> dict:
        return {
            'type': type(self).__name__,
            'func': self.func
        }

    def __init__(self, func: t.Callable[P, T]):
        self.func = func 

    def to_string(self, indent: t.Optional[int] = None):
        return to_string(self, indent=indent)

    def __call__(self, *args: P.args, **kwargs: P.kwargs) -> T:
        return self.func(*args, **kwargs)

    async def evaluate(self, value: t.Any) -> t.Any:
        return await maybe_await(self.func(value))


@decorator
def build_filter(func: t.Callable[P, T]):
    """Converts a callable into filter."""

    if not callable(func):
        raise TypeError(
            f'Expected a callable, got {type(func).__name__}'
        )

    return CustomFilter(func)

async def run_filter(expr: BaseFilter, value):
    """Apply the filter to the value."""
    return await maybe_await(expr.evaluate(value))
