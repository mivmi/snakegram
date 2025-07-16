import os
import typing as t
from cryptography.hazmat.primitives import serialization

from .aes import aes_ige256_encrypt
from .utils import xor, sha1, sha256
from ..gadgets.byteutils import Long, long_to_bytes, bytes_to_long
from ..tl.mtproto.types import RsaPublicKey


PUBLIC_KEY_MAP: t.Dict[int, 'PublicKey'] = {}


class PublicKey:
    def __init__(
        self,
        data: t.Union[str, bytes]
    ):
        if isinstance(data, str):
            data = data.encode('utf-8')

        self._key = serialization.load_pem_public_key(data)
        self._numbers = self._key.public_numbers()
        

    def encrypt(self, plain_text: bytes):
        padding_length = 255 - len(plain_text)
        if padding_length > 0:
            plain_text += os.urandom(padding_length)

        return long_to_bytes(
            pow(
                bytes_to_long(plain_text),
                self._numbers.e,
                self._numbers.n
            )
        )

    # https://core.telegram.org/mtproto/auth_key#41-rsa-paddata-server-public-key-mentioned-above-is-implemented-as-follows
    def encrypt_with_pad(self, plain_text: bytes):
        if len(plain_text) > 144:
            raise ValueError(
                'plain_text is too long, maximum length is 144 bytes.'
            )

        data_with_padding = (
            plain_text 
            + os.urandom(192 - len(plain_text))
        )
        data_pad_reversed = data_with_padding[::-1]

        while True:
            key = os.urandom(32)
            plain_text = (
                data_pad_reversed 
                + sha256(key + data_with_padding)
            )
            aes_encrypted = aes_ige256_encrypt(
                plain_text,
                key=key,
                iv=bytes(32)
            )

            temp_key_xor = xor(key, sha256(aes_encrypted))
            key_aes_encrypted = temp_key_xor + aes_encrypted

            if self._numbers.n > bytes_to_long(key_aes_encrypted):
                return self.encrypt(key_aes_encrypted)

    def get_fingerprint(self):
        result = sha1(
            RsaPublicKey(
                long_to_bytes(self._numbers.n),
                long_to_bytes(self._numbers.e)
            )
            .to_bytes()
        )
        return Long.from_bytes(result.finalize()[-8:])

def add_public_key(data: t.Union[str, bytes]):
    public_key = PublicKey(data)
    PUBLIC_KEY_MAP[public_key.get_fingerprint()] = public_key

def get_public_key(fingerprints: t.List[int]):
    for fingerprint in fingerprints:
        public_key = PUBLIC_KEY_MAP.get(fingerprint)
        
        if public_key:
            return fingerprint, public_key

    else:
        raise ValueError(
            f'no matching fingerprint found in: {fingerprints}'
        )


# test
PUBLIC_KEY_MAP[-0X4DA76720DF72D9FD] = PublicKey(
    '''
    -----BEGIN RSA PUBLIC KEY-----
    MIIBCgKCAQEAyMEdY1aR+sCR3ZSJrtztKTKqigvO/vBfqACJLZtS7QMgCGXJ6XIR
    yy7mx66W0/sOFa7/1mAZtEoIokDP3ShoqF4fVNb6XeqgQfaUHd8wJpDWHcR2OFwv
    plUUI1PLTktZ9uW2WE23b+ixNwJjJGwBDJPQEQFBE+vfmH0JP503wr5INS1poWg/
    j25sIWeYPHYeOrFp/eXaqhISP6G+q2IeTaWTXpwZj4LzXq5YOpk4bYEQ6mvRq7D1
    aHWfYmlEGepfaYR8Q0YqvvhYtMte3ITnuSJs171+GDqpdKcSwHnd6FudwGO4pcCO
    j4WcDuXc2CTHgH8gFTNhp/Y8/SpDOhvn9QIDAQAB
    -----END RSA PUBLIC KEY-----
    '''
)

# product
PUBLIC_KEY_MAP[-0X2F62E27A219B027B] = PublicKey(
    '''
    -----BEGIN RSA PUBLIC KEY-----
    MIIBCgKCAQEA6LszBcC1LGzyr992NzE0ieY+BSaOW622Aa9Bd4ZHLl+TuFQ4lo4g
    5nKaMBwK/BIb9xUfg0Q29/2mgIR6Zr9krM7HjuIcCzFvDtr+L0GQjae9H0pRB2OO
    62cECs5HKhT5DZ98K33vmWiLowc621dQuwKWSQKjWf50XYFw42h21P2KXUGyp2y/
    +aEyZ+uVgLLQbRA1dEjSDZ2iGRy12Mk5gpYc397aYp438fsJoHIgJ2lgMv5h7WY9
    t6N/byY9Nw9p21Og3AoXSL2q/2IJ1WRUhebgAdGVMlV1fkuOQoEzR7EdpqtQD9Cs
    5+bfo3Nhmcyvk5ftB0WkJ9z6bNZ7yxrP8wIDAQAB
    -----END RSA PUBLIC KEY-----
    '''
)
