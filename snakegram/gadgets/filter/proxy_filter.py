import typing as t
from .base import BaseFilter
from ..utils import to_string, maybe_await


class ProxyFilter(BaseFilter):
    """
    A dynamic filter that lets you access attributes, items, and method calls 
    in a chainable.


    Example:
    ```python
    proxy = ProxyFilter()
    filter = proxy.user.username.startswith('@')

    result = await run_filter(filter, obj) # like: obj.user.username.startswith('@')
    ```
    """
    
    def __repr__(self) -> str:
        return self.to_string()

    def to_dict(self) -> dict:
        return {
            '_': type(self).__name__,
            'chains': self._chains
        }

    def to_string(self, indent: t.Optional[int] = None) -> str:
        return to_string(self.to_dict(), indent=indent)

    def __init__(self, *chains: t.Callable[[t.Any], t.Any]):
        self._chains = list(chains)

    def __call__(self, *args, **kwargs):
        async def method_call(value: t.Any):
            result = value(*args, **kwargs)
            return await maybe_await(result)

        method_call.__name__ = f'call<{args}, {kwargs}>'
        return ProxyFilter(*self._chains, method_call)

    async def evaluate(self, value: t.Any):
        """
        Applies the chain of filters to the given value.

        Returns:
            Any: The final result after applying all filters
        """
        current_value = value
        for index, func in enumerate(self._chains):
            try:
                current_value = await maybe_await(
                    func(current_value)
                )

            except Exception as err:
                message = f'Error at chain {index} ({to_string(func)}): {err}'
                raise RuntimeError(message) from err
        return current_value

    def __getattr__(self, name: str) :
        def get_attr(value: t.Any):
            return getattr(value, name)

        get_attr.__name__ = f'getattr<{name!r}>'
        return ProxyFilter(*self._chains, get_attr)

    def __getitem__(self, item: t.Union[str, int]):
        def get_item(value):
            return value[item]

        get_item.__name__ = f'getitem<{item!r}>'
        return ProxyFilter(*self._chains, get_item)

