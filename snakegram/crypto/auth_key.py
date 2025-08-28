import os
import typing as t
from hashlib import sha1, sha256

from .aes import aes_ige256_encrypt, aes_ige256_decrypt
from ..errors import SecurityError
from ..gadgets.byteutils import Long


FROM_CLIENT = 0
FROM_SERVER = 8

class AuthKey:
    def __bool__(self):
        return bool(self._key)

    def __init__(self, auth_key: bytes = None):
        if auth_key is not None:
            self.set_auth_key(auth_key)

        else:
            self.clear() # set attrs

    @property
    def key(self):
        return self._key

    @property
    def key_id(self):
        return self._key_id
    
    @property
    def key_hash(self):
        return self._key_hash

    @property
    def fingerprint(self):
        return self._fingerprint
    
    # methods
    def clear(self):
        self._key = None
        self._key_id = None
        self._key_hash = None
        # 
        self._key_id = None
        self._fingerprint = None

    def set_auth_key(self, auth_key: bytes):
        self._key = auth_key
        self._key_hash = sha1(auth_key).digest()

        #
        self._key_id = self._key_hash[-8:]
        self._fingerprint = Long.from_bytes(self._key_id)

    def get_aux_hash(self) -> t.Optional[bytes]:
        return self._key_hash[:8] if self._key_hash else None
    
    #
    def encrypt(
        self,
        plain_text: bytes,
        *,
        version: t.Literal[1, 2] = 2,
        from_client: bool = True
    ) -> bytes:
        if not self._key:
            raise RuntimeError('auth key is not set.')

        
        x = (
            FROM_CLIENT 
            if from_client else
            FROM_SERVER
        )

        if version == 2:
            plain_text += os.urandom(-(len(plain_text) + 12) % 16 + 12)

        msg_key = self.get_msg_key(
            plain_text,
            x=x,
            version=version
        )
        aes_key, aes_iv = self.compute_aes_key_iv(
            msg_key,
            x=x,
            version=version
        )
        return (
            self._key_id
            + msg_key
            + aes_ige256_encrypt(plain_text, aes_key, aes_iv)
        )
    
    def decrypt(
        self,
        cipher_text: bytes,
        *,
        version: t.Literal[1, 2] = 2,
        from_server: bool = True
    ):
        if not self._key:
            raise RuntimeError('auth key is not set.')

        SecurityError.check(
            cipher_text[:8] != self._key_id,
            'auth_id mismatch: auth_id != auth_key.id'
        )
        x = (
            FROM_SERVER 
            if from_server else
            FROM_CLIENT
        )

        msg_key = cipher_text[8: 8 + 16] # 128-bit
        aes_key, aes_iv = self.compute_aes_key_iv(
            msg_key,
            x=x,
            version=version
        )

        plain_text = aes_ige256_decrypt(
            cipher_text[8 + 16:],
            aes_key,
            aes_iv
        )

        # https://core.telegram.org/mtproto/security_guidelines#checking-sha256-hash-value-of-msg-key
        computed_msg_key = self.get_msg_key(
            plain_text,
            x=x,
            version=version
        )
        SecurityError.check(
            computed_msg_key != msg_key,
            'msg_key mismatch: computed_msg_key != msg_key'
        )

        return plain_text

    def compute_aes_key_iv(
        self,
        msg_key: bytes,
        x: t.Literal[0, 8],
        version: t.Literal[1, 2] = 2
    ):
        if not self._key:
            raise RuntimeError('auth key is not set')
    
        # x: from client = 0
        # X: from server = 8
        if version == 1:
            # https://core.telegram.org/mtproto/description_v1#defining-aes-key-and-initialization-vector
            sha1_a = sha1(msg_key + self._key[x: x + 32]).digest()
            sha1_b = sha1(
                    self._key[x + 32: x + 32 + 16]
                    + msg_key
                    + self._key[x + 48: x + 48 + 16]
                ).digest()

            sha1_c = sha1(
                self._key[x + 64: x + 64 + 32] + msg_key).digest()
            sha1_d = sha1(
                msg_key + self._key[x + 96: x + 96 + 32]).digest()

            return (
                sha1_a[:8] + sha1_b[8: 12 + 8] + sha1_c[4: 4 + 12],
                sha1_a[8: 8 + 12] + sha1_b[:8] + sha1_c[16: 16 + 4] + sha1_d[:8]
            )

        else:
            hash_a = sha256(
                msg_key + self._key[x: x + 36]).digest()

            hash_b = sha256(
                self._key[x + 40: x + 40 + 36] + msg_key).digest()

            return (
                hash_a[:8] + hash_b[8: 8 + 16] + hash_a[24: 24 + 8],
                hash_b[:8] + hash_a[8: 8 + 16] + hash_b[24: 24 + 8]
            )

    # https://core.telegram.org/mtproto/description#message-key-msg-key
    def get_msg_key(
        self,
        plain_text: bytes,
        x: t.Literal[0, 8],
        version: t.Literal[1, 2] = 2
    ):

        if version == 1:
            # msg_key = substr (SHA1 (plaintext), 4, 16);
            return sha1(plain_text).digest()[4: 4 + 16]

        else:
            if not self._key:
                raise RuntimeError('auth key is not set')

            # msg_key_large = SHA256 (substr (auth_key, 88+x, 32) + plaintext + random_padding);
            # msg_key = substr (msg_key_large, 8, 16);
            msg_key_large = sha256(
                self._key[x + 88: x + 88 + 32] + plain_text).digest()

            return msg_key_large[8: 8 + 16]
