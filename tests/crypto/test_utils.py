import pytest
from snakegram.crypto.utils import is_prime, is_safe_prime, pq_factorize
from snakegram.gadgets.byteutils import long_to_bytes, bytes_to_long


@pytest.mark.parametrize(
    'n, expected',
    [
        (2, True),
        (3, True),
        (4, False),
        (7919, True),
        (7920, False)
    ]
)
def test_is_prime(n, expected):
    assert is_prime(n) == expected, (
        f'is_prime({n}) should be {expected}'
    )


@pytest.mark.parametrize(
    'p, g, expected',
    [
        (29, 5, False),
        (23, 1, False),
        (23, 8, False),
        (23, 5, False)
    ]
)
def test_is_safe_prime(p, g, expected):
    assert is_safe_prime(p, g) == expected, (
        f'is_safe_prime({p}, {g}) should be {expected}'
    )
    

@pytest.mark.parametrize(
    'p, q',
    [
        (1123945139, 1831905013),
        (1234319417, 1429400213),
        (1421501969, 1466626253)
    ]
)

def test_pq_factorize(p, q):
    pq = long_to_bytes(p * q)
    pb, qb = pq_factorize(pq)

    p_res, q_res = sorted(
        [
            bytes_to_long(pb),
            bytes_to_long(qb)
        ]
    )
    assert (p_res, q_res) == (p, q), f'Failed to factorize {p * q}'
