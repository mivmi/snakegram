import pytest
from snakegram.filters import proxy
from snakegram.gadgets.filter import run_filter


class DummyObj:
    def __init__(self):
        self.value = 42
        self.nested = {'key': 'value'}

    def greet(self, name):
        return f'Hello, {name}!'

    async def async_greet(self, name):
        return f'async: Hello, {name}!'

obj = DummyObj()

@pytest.mark.asyncio
async def test_getattr():
    f = proxy.value
    result = await run_filter(f, obj)
    assert result == 42


@pytest.mark.asyncio
async def test_getitem():
    f = proxy.nested['key']
    result = await run_filter(f, obj)
    assert result == 'value'


@pytest.mark.asyncio
async def test_method_call():
    f = proxy.greet('World')
    result = await run_filter(f, obj)
    assert result == 'Hello, World!'


@pytest.mark.asyncio
async def test_async_method_call():
    f = proxy.async_greet('World')
    result = await run_filter(f, obj)
    assert result == 'async: Hello, World!'
