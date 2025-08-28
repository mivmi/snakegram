# https://core.telegram.org/api/srp#checking-the-password-with-srp

import typing as t
from hashlib import sha256, pbkdf2_hmac
from .utils import xor, is_safe_prime

from ..tl import types
from ..gadgets.byteutils import bytes_to_long, big_integer_bytes, Int256


def get_password_hash(
    salt1: bytes,
    salt2: bytes,
    my_password: t.Union[str, bytes]
):
    def sh(data: bytes, salt: bytes) -> bytes:
        return sha256(salt + data + salt).digest()

    if isinstance(my_password, str):
        my_password = my_password.encode('utf-8')

    ph1 = sh(sh(my_password, salt1), salt2)
    pbkdf2_result = pbkdf2_hmac('sha512', ph1, salt1, 100000)

    return sh(pbkdf2_result, salt2)


# https://github.com/DrKLO/Telegram/blob/17067dfc6a1f69618a006b14e1741b75c64b276a/TMessagesProj/src/main/java/org/telegram/messenger/SRPHelper.java#L50
def get_check_password_srp(
    data: types.account.Password,
    my_password: t.Union[str, bytes]
):
    """
    Computes the SRP parameters to verify a 2FA password.

    Args:
        data (types.account.Password): The result of `account.getPassword`.
        my_password (`str` | `bytes`): The user's current 2FA password (as string or UTF-8 encoded bytes).

    Returns:
        types.InputCheckPasswordSRP:
            The input object to be passed to `auth.CheckPassword` or `account.UpdatePasswordSettings`.

    """
    algorithm = data.current_algo
    if not isinstance(
        algorithm,
        types.PasswordKdfAlgoSHA256SHA256PBKDF2HMACSHA512iter100000SHA256ModPow
    ):
        raise RuntimeError(
            f'Unsupported password KDF algorithm: {type(algorithm).__name__}'
        )

    srp_b: bytes = data.srp_B
    srp_id: int = data.srp_id

    p_int = bytes_to_long(algorithm.p)
    
    if not is_safe_prime(p_int, algorithm.g):
        raise ValueError('not is_safe_prime(p_int, g)')

    b_int = bytes_to_long(srp_b)
    if b_int <= 0 or b_int >= p_int:
        raise ValueError('b_int <= 0 or b_int >= p_int')

    b_bytes = big_integer_bytes(b_int)
    g_bytes = big_integer_bytes(algorithm.g)


    k_bytes = sha256(algorithm.p + g_bytes).digest()
    k = bytes_to_long(k_bytes)

    x_bytes = get_password_hash(
        algorithm.salt1,
        algorithm.salt2,
        my_password
    )
    x = bytes_to_long(x_bytes)
    
    a = Int256()
    # a_bytes = long_to_bytes(a)
    
    a2 = pow(algorithm.g, a, p_int)
    a2_bytes = big_integer_bytes(a2)
    

    u_bytes = sha256(a2_bytes + srp_b).digest()
    u = bytes_to_long(u_bytes)
    
    if u == 0:
        raise ValueError('u == 0')
    
    # B.subtract(k.multiply(g.modPow(x, p)).mod(p));
    b_kgx = (b_int - (k * pow(algorithm.g, x, p_int)) % p_int)

    if b_kgx < 0:
        b_kgx += p_int

    if b_kgx <= 1 or b_kgx >= p_int - 1:
        raise ValueError('b_kgx <= 1 or b_kgx >= p_int - 1')
    
    s = pow(b_kgx, a + u * x, p_int)
    s_bytes = big_integer_bytes(s)
    
    k2_bytes = sha256(s_bytes).digest()

    g_hash = sha256(g_bytes).digest()
    p_hash = xor(g_hash, sha256(algorithm.p).digest())
    
    m1 = sha256(
        p_hash
        + sha256(algorithm.salt1).digest()
        + sha256(algorithm.salt2).digest()
        + a2_bytes
        + b_bytes
        + k2_bytes
    ).digest()

    # return a2_bytes, m1
    return types.InputCheckPasswordSRP(srp_id, a2_bytes, m1)

