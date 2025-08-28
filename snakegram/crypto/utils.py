from hashlib import md5
from functools import lru_cache

from .._rust import crypto
from ..gadgets.byteutils import Int, bytes_to_long, long_to_bytes


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


def is_prime(n: int, trials: int = 8) -> bool:
    """Tests if a number is prime (Rabin Miller)."""
    return crypto.math.is_prime(n, trials)

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

@lru_cache
def pq_factorize(pq: bytes):
    """
    This function factors a natural number, provided in big-endian byte format, 
    into two distinct prime factors. The input `pq` represents the product of two distinct primes, 
    `p` and `q`, and is typically less than or equal to `2^63 - 1`.
    """
    num = bytes_to_long(pq)
    p, q = crypto.math.factorization(num)
    return long_to_bytes(p), long_to_bytes(q)

# https://core.telegram.org/api/end-to-end#sending-encrypted-files
def get_key_fingerprint(key: bytes, iv: bytes):
    digest = md5(key + iv).digest()

    # fingerprint = substr(digest, 0, 4) XOR substr(digest, 4, 4)
    fingerprint = xor(digest[:4], digest[4: 4 + 4])

    return Int.from_bytes(fingerprint)
