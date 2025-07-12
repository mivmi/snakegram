from math import gcd
from functools import lru_cache
from random import randrange, randint

from cryptography.hazmat.primitives import hashes
from ..gadgets.byteutils import long_to_bytes, bytes_to_long


def xor(term1: bytes, term2: bytes) -> bytes:
    """
    performs a bitwise `XOR` operation between two byte sequences.

    Args:
        term1 (bytes): The first byte sequence.
        term2 (bytes): The second byte sequence.
    
    Note: The two input sequences must be of equal length.
    """
    if len(term1) != len(term2):
        raise ValueError('Input byte sequences must have the same length.')

    return bytes([x ^ y for x, y in zip(term1, term2)])

def sha1(data: bytes) -> bytes:
    """computes the `SHA-1` hash of the given data."""

    digit = hashes.Hash(hashes.SHA1())
    digit.update(data)
    return digit.finalize()


def sha256(data: bytes) -> bytes:
    """Computes the `SHA-256` hash of the given data."""
    digit = hashes.Hash(hashes.SHA256())
    digit.update(data)
    return digit.finalize()


def is_prime(n: int, trials: int = 16) -> bool:
    """Tests if a number is prime (Rabin Miller)."""

    if n <= 1:
        return False
    if n <= 3:
        return True
    if n % 2 == 0:
        return False

    # n - 1 as 2^r * d
    r, d = 0, n - 1
    while d % 2 == 0:
        d //= 2
        r += 1

    for _ in range(trials):
        a = randrange(2, n - 2)
        x = pow(a, d, n)

        if x == 1 or x == n - 1:
            continue

        for _ in range(r - 1):
            x = pow(x, 2, n)
            if x == n - 1:
                break
        else:
            return False  # definitely composite

    return True  # probably prime

def is_safe_prime(p: int, g: int) -> bool:
    """Checks whether `p` is a 2048-bit safe prime."""

    if (
        p <= 0
        or not 2 <= g <= 7
        or p.bit_length() != 2048
        or not is_prime(p)
        or not is_prime((p - 1) // 2)
    ):
        return False

    if g == 2:
        return p % 8 == 7

    elif g == 3:
        return p % 3 == 2

    elif g == 4:
        return True

    elif g == 5:
        return p % 5 in {1, 4}

    elif g == 6:
        return p % 24 in {19, 23}

    elif g == 7:
        return p % 7 in {3, 5, 6}
    
    return True

def pq_factorize(pq: bytes):
    """
    This function factors a natural number, provided in big-endian byte format, 
    into two distinct prime factors. The input `pq` represents the product of two distinct primes, 
    `p` and `q`, and is typically less than or equal to `2^63 - 1`.
    """
    num = bytes_to_long(pq)

    @lru_cache
    def brent(value: int):

        if not value & 1:
            return 2

        if value <= 2 or value > 1 << 63:
            return 1

        x = ys = 0
        g = r = q = 1
        y, c, m = (randint(1, value - 1) for _ in range(3))

        while g == 1:
            x = y
            for _ in range(r):
                y = (pow(y, 2, value) + c) % value

            k = 0
            while k < r and g == 1:
                ys = y
                for _ in range(min(m, r - k)):
                    y = (pow(y, 2, value) + c) % value
                    q = q * (abs(x - y)) % value

                k += m
                g = gcd(q, value)

            r *= 2

        if g == value:
            while True:
                ys = (pow(ys, 2, value) + c) % value
                g = gcd(abs(x - ys), value)
                if g > 1:
                    break

        return g

    g = brent(num)
    p, q = sorted((g, num // g))
    return long_to_bytes(p), long_to_bytes(q)

