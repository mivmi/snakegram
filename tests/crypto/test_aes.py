import os
import pytest

from snakegram.crypto import (
    aes_ctr256,
    aes_ige256_encrypt,
    aes_ige256_decrypt
)


@pytest.fixture
def random_iv():
    return os.urandom(32)

@pytest.fixture
def random_key():
    return os.urandom(32)

@pytest.fixture
def random_nonce():
    return os.urandom(16)


def test_aes_ctr256_encrypt_decrypt(random_key, random_nonce):
    plaintext = os.urandom(64)  # 64 bytes random data
    ciphertext = aes_ctr256(plaintext, random_key, random_nonce)
    decrypted = aes_ctr256(ciphertext, random_key, random_nonce)
    assert decrypted == plaintext

def test_aes_ige256_encrypt_decrypt(random_key, random_iv):
    plaintext = os.urandom(100)  # arbitrary length > 16 bytes
    ciphertext = aes_ige256_encrypt(plaintext, random_key, random_iv)
    decrypted = aes_ige256_decrypt(ciphertext, random_key, random_iv)
    assert decrypted[:len(plaintext)] == plaintext

def test_aes_ige256_encrypt_decrypt_with_hash(random_key, random_iv):
    plaintext = os.urandom(50)
    ciphertext = aes_ige256_encrypt(plaintext, random_key, random_iv, True)
    decrypted = aes_ige256_decrypt(ciphertext, random_key, random_iv, True)
    assert decrypted == plaintext

def test_aes_ige256_decrypt_with_hash_fails(random_key, random_iv):
    plaintext = os.urandom(32)
    ciphertext = aes_ige256_encrypt(plaintext, random_key, random_iv, True)

    tampered = ciphertext[:-1] + os.urandom(1)

    with pytest.raises(ValueError, match='hash verification failed'):
        aes_ige256_decrypt(tampered, random_key, random_iv, True)
