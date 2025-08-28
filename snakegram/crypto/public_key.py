import typing as t
from inspect import cleandoc
from .._rust import crypto


PublicKey = crypto.PublicKey

if t.TYPE_CHECKING:
    class PublicKey:
        def __init__(self, pem: str): ...
        def encrypt(self, plain_text: bytes) -> bytes: ...


PUBLIC_KEY_MAP: t.Dict[int, PublicKey] = {}


def add_public_key(data: str):
    public_key = PublicKey(data)
    PUBLIC_KEY_MAP[public_key.fingerprint] = public_key

    return public_key

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
    cleandoc(
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
)

# product
PUBLIC_KEY_MAP[-0X2F62E27A219B027B] = PublicKey(
    cleandoc(
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
)
