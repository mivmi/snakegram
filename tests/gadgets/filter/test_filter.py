import pytest
from snakegram.enums import Operation
from snakegram.gadgets.filter import build_filter, run_filter, FilterExpr


def test_callable_custom_filter():
    double_filter = build_filter(lambda x: x * 2)
    assert double_filter(3) == 6


@pytest.mark.asyncio
async def test_run_filter():
    add_ten_filter = build_filter(lambda x: x + 10)
    result = await run_filter(add_ten_filter, 5)
    assert result == 15


@pytest.mark.asyncio
async def test_filter_expr_logical():
    always_true = build_filter(lambda _: True)
    always_false = build_filter(lambda _: False)

    not_expr = FilterExpr(Operation.Not, always_false)
    assert await run_filter(not_expr, None) is True

    or_expr = FilterExpr(Operation.Or, always_true, always_false)
    assert await run_filter(or_expr, None) is True

    and_expr = FilterExpr(Operation.And, always_false, always_true)
    assert await run_filter(and_expr, None) is False

@pytest.mark.asyncio
async def test_filter_expr_comparison():
    identity_filter = build_filter(lambda x: x)
    constant_value = 10

    less_than_expr = FilterExpr(Operation.Lt, identity_filter, constant_value)
    assert await run_filter(less_than_expr, 5) is True

    combined_expr = FilterExpr(
        Operation.And,
        FilterExpr(Operation.Gt, identity_filter, 3),
        FilterExpr(Operation.Lt, identity_filter, 8)
    )
    assert await run_filter(combined_expr, 5) is True


@pytest.mark.asyncio
async def test_filter_expr_type_check():
    class_check_expr = FilterExpr(Operation.TypeOf, int, int)
    assert await run_filter(class_check_expr, None) is True

    instance_check_expr = FilterExpr(Operation.TypeOf, 5, int)
    assert await run_filter(instance_check_expr, None) is True
