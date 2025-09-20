import typing as t
from .._rust import crypto
 

# backends
if t.TYPE_CHECKING:
    class Aes256Ctr:
        def __init__(self, key: bytes, nonce: bytes): ...
        def __call__(self, data: bytes) -> bytes: ...
    
    class Aes256Ige:
        def __init__(self, key: bytes, iv: bytes): ...
        def encrypt(self, plain_text: bytes, hash: bool=False) -> bytes: ...
        def decrypt(self, cipher_text: bytes, hash: bool=False) -> bytes: ...


Aes256Ctr = crypto.Aes256Ctr
Aes256Ige = crypto.Aes256Ige


def aes_ctr256(data: bytes, key: bytes, nonce: bytes):
    """Encrypts or decrypts data using `AES-CTR-256`."""
    return Aes256Ctr(key, nonce)(data)

def aes_ige256_encrypt(
    plain_text: bytes,
    key: bytes,
    iv: bytes,
    hash: bool=False
) -> bytes:
    """Encrypts plain-text using `AES-IGE-256`."""
    return Aes256Ige(key, iv).encrypt(plain_text, hash)

def aes_ige256_decrypt(
    cipher_text: bytes,
    key: bytes,
    iv: bytes,
    hash: bool=False
) -> bytes:
    """Decrypts cipher-text using `AES-IGE-256`."""
    return Aes256Ige(key, iv).decrypt(cipher_text, hash)
