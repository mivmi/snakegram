import os
import pytest

from snakegram.crypto import AuthKey
from snakegram.errors import SecurityError


@pytest.fixture
def auth_key():
    return os.urandom(256)

@pytest.fixture
def another_key():
    return os.urandom(256)


@pytest.mark.parametrize(
    'version',
    [1, 2]
)
def test_encrypt_client_message(version, auth_key):
    key = AuthKey(auth_key)
    message = os.urandom(64)

    encrypted = key.encrypt(
        message,
        version=version
    )
    decrypted = key.decrypt(
        encrypted,
        version=version,
        from_server=False
    )

    assert decrypted.startswith(message) # padding



@pytest.mark.parametrize(
    'version',
    [1, 2]
)
def test_decrypt_server_message(version, auth_key):
    key = AuthKey(auth_key)
    message = os.urandom(64)

    encrypted = key.encrypt(
        message,
        version=version,
        from_client=False
    )
    decrypted = key.decrypt(
        encrypted,
        version=version
    )

    assert decrypted.startswith(message) # padding


@pytest.mark.parametrize(
    'version',
    [1, 2]
)
def test_decrypt_with_wrong_key(version, auth_key, another_key):
    key = AuthKey(auth_key)
    message = os.urandom(64)

    encrypted = key.encrypt(
        message,
        version=version,
        from_client=False
    )

    bad_key = AuthKey(another_key)

    with pytest.raises(SecurityError, match='auth_id mismatch'):
        bad_key.decrypt(encrypted, version=version)


def test_msg_key_mismatch_detection(auth_key):
    key = AuthKey(auth_key)
    message = os.urandom(64)
    
    encrypted = key.encrypt(message, from_client=False)
    encrypted = bytearray(encrypted)

    encrypted[8:24] = os.urandom(16)
    with pytest.raises(SecurityError, match='msg_key mismatch'):
        key.decrypt(bytes(encrypted))
