import os
from .utils import sha1, xor
from ..errors import SecurityError

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes


def aes_ctr256_encrypt(plain_text: bytes, key: bytes, nonce: bytes) -> bytes:
    """Encrypts plain-text using `AES-CTR-256`."""

    if len(key) != 32:
        raise ValueError(
            'Invalid key length: '
            f'expected 32 bytes for AES-256, got {len(key)}'
        )

    if len(nonce) != 16:
        raise ValueError(
            'Invalid nonce length: '
            f'expected 16 bytes (AES block size), got {len(nonce)}'
        )

    cipher = Cipher(
        algorithms.AES(key),
        mode=modes.CTR(nonce)
    )

    encryptor = cipher.encryptor()
    return encryptor.update(plain_text) + encryptor.finalize()

def aes_ctr256_decrypt(cipher_text: bytes, key: bytes, nonce: bytes) -> bytes:
    """Decrypts cipher-text using `AES-CTR-256`."""

    if len(key) != 32:
        raise ValueError(
            'Invalid key length: '
            f'expected 32 bytes for AES-256, got {len(key)}'
        )
    if len(nonce) != 16:
        raise ValueError(
            'Invalid nonce length: '
            f'expected 16 bytes (AES block size), got {len(nonce)}'
        )

    cipher = Cipher(
        algorithms.AES(key),
        mode=modes.CTR(nonce)
    )
    decryptor = cipher.decryptor()
    return decryptor.update(cipher_text) + decryptor.finalize()

def aes_ige256_encrypt(plain_text: bytes, key: bytes, iv: bytes) -> bytes:
    """Encrypts plain-text using `AES-IGE-256`."""

    if len(key) != 32 or len(iv) != 32:
        raise ValueError('Key and IV must both be 32 bytes.')

    result = b''
    length = len(plain_text)

    # Padding data to match the block size
    if length % 16 != 0:
        padding_length = 16 - (length % 16)
        length += padding_length
        plain_text += os.urandom(padding_length)

    iv1 = iv[:16]
    iv2 = iv[16:]
    cipher = Cipher(
        algorithms.AES(key),
        mode=modes.ECB()
    )
    encryptor = cipher.encryptor()

    for index in range(0, length, 16):
        chunk = plain_text[index: index + 16]
        # Encrypt the block and update iv1 and iv2
        block = encryptor.update(xor(chunk, iv1))

        iv1 = xor(block, iv2)
        iv2 = chunk
        result += iv1

    return result + encryptor.finalize()

def aes_ige256_decrypt(cipher_text: bytes, key: bytes, iv: bytes) -> bytes:
    """Decrypts cipher-text using `AES-IGE-256`."""

    if len(key) != 32 or len(iv) != 32:
        raise ValueError('Key and IV must both be 32 bytes.')

    length = len(cipher_text)
    if length % 16 != 0:
        raise ValueError(
            'Cipher-text length must be a multiple of 16.'
        )

    iv1 = iv[:16]
    iv2 = iv[16:]

    result = b''
    cipher = Cipher(
        algorithms.AES(key),
        mode=modes.ECB()
    )

    decryptor = cipher.decryptor()

    for index in range(0, length, 16):
        chunk: bytes = cipher_text[index: index + 16]
        block = decryptor.update(xor(chunk, iv2))

        iv2 = xor(block, iv1)
        iv1 = chunk

        result += iv2

    return result + decryptor.finalize()

def aes_ige256_encrypt_with_hash(plain_text: bytes, key: bytes, iv: bytes) -> bytes:
    """Encrypts plain-text using `AES-IGE-256` with `SHA-1` hash."""

    return aes_ige256_encrypt(
        sha1(plain_text) + plain_text,
        key=key, iv=iv
    )

def aes_ige256_decrypt_with_hash(cipher_text: bytes, key: bytes, iv: bytes) -> bytes:
    """
    Decrypts cipher-text using `AES-IGE-256` and verifies plain-text with `SHA-1` hash.
    """
    decrypted = aes_ige256_decrypt(cipher_text, key, iv)
    plain_hash, plain_text = decrypted[:20], decrypted[20:]

    for padding in range(0, 16):
        if sha1(plain_text[:-padding]) == plain_hash:
            return plain_text[:-padding]

    raise SecurityError(
        'SHA-1 hash verification failed. '
        'The decrypted data does not match the expected integrity check. '
        'Possible causes: incorrect decryption key, data corruption, or tampering.'
    )
