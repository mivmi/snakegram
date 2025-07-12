from cryptography.hazmat.primitives import hashes

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

