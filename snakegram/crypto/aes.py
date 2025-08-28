from .._rust import crypto

def aes_ctr256(data: bytes, key: bytes, nonce: bytes) -> bytes:
    """Encrypts or decrypts data using `AES-CTR-256`."""
    return crypto.aes_ctr256(data, key, nonce)


def aes_ige256_encrypt(
    plain_text: bytes,
    key: bytes,
    iv: bytes,
    hash: bool=False
) -> bytes:
    """Encrypts plain-text using `AES-IGE-256`."""

    return crypto.aes_ige256_encrypt(
        plain_text,
        key,
        iv,
        hash
    )

def aes_ige256_decrypt(
    cipher_text: bytes,
    key: bytes,
    iv: bytes,
    hash: bool=False
) -> bytes:
    """Decrypts cipher-text using `AES-IGE-256`."""
    
    return crypto.aes_ige256_decrypt(
        cipher_text,
        key,
        iv,
        hash
    )
