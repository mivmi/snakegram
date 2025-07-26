from .filter import (
    BaseFilter,
    FilterExpr,
    CustomFilter,
    build_filter, run_filter
)
from .proxy_filter import ProxyFilter

magic = ProxyFilter()

__all__ = [
    'magic',
    'BaseFilter',
    'FilterExpr',
    'CustomFilter',
    'build_filter', 'run_filter',
    'ProxyFilter'
]