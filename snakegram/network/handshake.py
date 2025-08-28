import asyncio
import logging
import typing as t
from hashlib import sha1
from random import getrandbits

from .. import errors, crypto
from ..tl import mtproto, functions
from .message import RawMessage, EncryptedMessage
from ..gadgets.utils import env, retry

from ..gadgets.byteutils import Reader, Long, Int128, Int256, bytes_to_long, long_to_bytes
from ..session.abstract import AbstractSession, AbstractPfsSession

if t.TYPE_CHECKING:
    from .utils import State, Request
    from ..gadgets.tlobject import TLRequest


TEST_MODE = env('TEST_MODE', False, bool)
FORCE_TEMP_KEY = env('FORCE_TEMP_KEY', False, bool)

TIMEOUT = env('TIMEOUT', 10, int)
TEMP_KEY_LIFETIME = env('TEMP_KEY_LIFETIME', 86400, int)
CREATE_KEY_ATTEMPTS = env('CREATE_KEY_ATTEMPTS', 3, int)


logger = logging.getLogger(__name__)

class Handshake:
    def __init__(
        self,
        state: 'State',
        invoke: t.Callable[['TLRequest'], 'Request'],
        *,
        is_media: bool = False,
        public_key_getter: t.Callable[[t.List[int]], t.Tuple[int, crypto.PublicKey]] = None
    ):

        self.state = state
        self.invoke = invoke

        self.is_media = is_media
        self.public_key_getter = public_key_getter or crypto.get_public_key

    @property
    def done(self):
        return self.state.is_handshake_completed()

    async def do_handshake(self):
        self.state.begin_handshake()

        if not self.state.session.auth_key:
            logger.debug('perm auth key not found')

            if self.state.pfs_session:
                # no perm key found, discard the temp key and create a new
                self.state.pfs_session.clear()

            try:
                auth_key, created_at = await self.auth_key_generation(self.state.session)

            except Exception as exc:
                logger.exception('Failed to generate perm auth key')
        
                raise errors.HandshakeFailedError(
                    'Failed to generate perm auth key'
                ) from exc
            
            else:
                self.state.session.set_auth_key(auth_key.key, created_at)

        if self.state.pfs_session:
            now = self.state.server_time()

            auth_key = self.state.pfs_session.auth_key
            expires_at = self.state.pfs_session.expires_at

            if not auth_key or expires_at <= now:
                logger.debug('valid temp auth key not found')

                try:
                    auth_key, created_at = await self.auth_key_generation(self.state.pfs_session)

                except Exception as exc:
                    logger.exception('Failed to generate temp auth key')

                    if not FORCE_TEMP_KEY:
                        logger.warning(
                            'temp key generation failed. falling back to perm key: '
                            'to force the use of temp auth keys, set FORCE_TEMP_KEY=True'
                        )                        
    
                    else:
                        raise errors.HandshakeFailedError(
                            'Failed to generate temp auth key'
                        ) from exc

                else:
                    await self.bind_temp_auth_key(auth_key, created_at)

            else:
                logger.info('using valid temp auth key')

        # if no valid server salt is available,
        # wait for `NewSessionCreated` to provide one.
        now = self.state.server_time()
        if self.state.session.get_server_salt(now) == 0:
            logger.debug(
                'no valid server salt found. waiting for "NewSessionCreated" ...'
            )

            try:
                await self.state.wait_for_new_session(TIMEOUT)

            except asyncio.TimeoutError:
                logger.warning(
                    'wait for "NewSessionCreated" timed out. continuing without server salt'
                )

        self.state.complete_handshake()

    async def bind_temp_auth_key(self, auth_key: crypto.AuthKey, created_at: int):
        nonce = Long()
        perm_key = self.state.session.auth_key
        expires_at = created_at + TEMP_KEY_LIFETIME

        logger.info(
            'Binding temp auth key: '
            'nonce=%d, expires_at=%d, perm_id=%d, temp_id=%d',
            nonce,
            expires_at,
            perm_key.fingerprint,
            auth_key.fingerprint
        )

        # `server_salt` and `session_id` must be random 64-bit int
        # seqno must be 0
        # ** `msg_id` must match the one from the original `BindTempAuthKey` request
        msg_id = self.state.generate_msg_id()
        auth_key_inner = mtproto.types.BindAuthKeyInner(
            nonce,
            perm_auth_key_id=perm_key.fingerprint,
            temp_auth_key_id=auth_key.fingerprint,
            temp_session_id=self.state.session_id,
            expires_at=expires_at
        )

        body = RawMessage(auth_key_inner)
        factory = EncryptedMessage(
            Long(),
            Long(),
            message=mtproto.types.Message(
                msg_id,
                seqno=0,
                bytes=len(body),
                body=body
            )
        )

        # encrypt using the perm auth key and v1
        bind_temp_auth_key = functions.auth.BindTempAuthKey(
            perm_key.fingerprint,
            nonce=nonce,
            expires_at=expires_at,
            encrypted_message=perm_key.encrypt(
                factory.to_bytes(),
                version=1  # v1
            )
        )

        try:
            request = self.invoke(bind_temp_auth_key)
            request.set_msg_id(msg_id)
            self.state.auth_key.set_auth_key(auth_key.key)

            if not await request:
                logger.error('failed to bind temp auth key')
                self.state.auth_key.clear()

                if not FORCE_TEMP_KEY:
                    logger.warning(
                        'binding failed. falling back to perm auth key. '
                        'to force the use of temp auth keys, set FORCE_TEMP_KEY=True'
                    )

                else:
                    raise errors.HandshakeFailedError('failed to bind temp auth key')

            else:
                logger.info('temp auth key successfully bind')
                self.state.pfs_session.set_auth_key(
                    auth_key.key,
                    created_at=created_at,
                    expires_at=expires_at
                )

            return True

        except errors.EncryptedMessageInvalidError as exc:
            self.state.auth_key.clear()
            # if the perm auth key is older than 60s both perm and temp keys must be discarded
            # both keys must then be regenerated 
            # for details, see: https://core.telegram.org/api/pfs

            now = self.state.server_time()
            if now - self.state.session.created_at >= 60:
                logging.info(
                    'perm key is older than 60s discarding both keys. '
                    'See: https://core.telegram.org/api/pfs'
                )

                self.state.session.clear()
                self.state.pfs_session.clear()
                return await self.do_handshake()

            raise errors.HandshakeFailedError('Failed to bind temp auth key') from exc

    async def auth_key_generation(self, session: t.Union[AbstractSession, AbstractPfsSession]):
        last_error = None

        for attempt in retry(CREATE_KEY_ATTEMPTS):
            logger.info(
                'Trying to create auth key (attempt %d/%d)...',
                attempt,
                CREATE_KEY_ATTEMPTS
            )

            try:
                logger.debug('Auth key generation: step %d', 1)
                
                # https://core.telegram.org/mtproto/auth_key#1-client-sends-query-to-server
                nonce = Int128()
                result = await self.invoke(
                    mtproto.functions.ReqPqMulti(nonce=nonce)
                )

                # https://core.telegram.org/mtproto/auth_key#2-server-sends-response-of-the-form
                logger.debug('Auth key generation: step %d', 2)
                errors.SecurityError.check(
                    nonce != result.nonce,
                    f'nonce mismatch: {nonce} != {result.nonce}'
                )
                
                public_key_fingerprint, public_key = self.public_key_getter(
                    result.server_public_key_fingerprints
                )
                
                logger.info('Auth key generation: public_key_fingerprint=%d', public_key_fingerprint)
                
                # https://core.telegram.org/mtproto/auth_key#proof-of-work
                logger.debug('Auth key generation: step [%d]', 3)
                
                pq = result.pq
                p, q = crypto.utils.pq_factorize(pq)
                
                if len(p + q) != 8:
                    raise ValueError(
                        'sum of factors p, q: len(%r + %r) != 8, pq=%r', p, q, pq
                    )
                
                # https://core.telegram.org/mtproto/auth_key#4-encrypted-data-payload-generation
                logger.debug('Auth key generation: step [%d]', 4)
                
                dc_id = self.state.dc_id
                server_nonce = result.server_nonce

                if TEST_MODE:
                    dc_id += 10_000

                if self.is_media:
                    dc_id *= -1
                
                logger.debug(
                    'Auth key generation: dc_id=%d, test_mode=%r, media=%r',
                    dc_id,
                    TEST_MODE,
                    0 > dc_id
                )
                
                new_nonce = Int256()
                if isinstance(session, AbstractSession):
                    inner_data = mtproto.types.PQInnerDataDc(
                        pq,
                        p=p, q=q,
                        nonce=nonce,
                        server_nonce=server_nonce,
                        new_nonce=new_nonce,
                        dc=dc_id
                    )

                else:
                    inner_data = mtproto.types.PQInnerDataTempDc(
                        pq,
                        p=p, q=q,
                        nonce=nonce,
                        server_nonce=server_nonce,
                        new_nonce=new_nonce,
                        dc=dc_id,
                        expires_in=TEMP_KEY_LIFETIME
                    )
                
                logger.debug('Auth key generation: inner data=%r', inner_data)

                # https://core.telegram.org/mtproto/auth_key#41-rsa-paddata-server-public-key-mentioned-above-is-implemented-as-follows
                logger.debug('Auth key generation: step [%d]', 4.1)
                
                encrypted_data = public_key.encrypt(
                    inner_data.to_bytes()
                )

                logger.debug('Auth key generation: encrypted_data length %d', len(encrypted_data))

                # https://core.telegram.org/mtproto/auth_key#5-send-req-dh-params-query-with-generated-encrypted-data
                logger.debug('Auth key generation: step [%d]', 5)

                result = await self.invoke(mtproto.functions.ReqDHParams(
                        nonce=nonce,
                        server_nonce=server_nonce,
                        p=p,
                        q=q,
                        public_key_fingerprint=public_key_fingerprint,
                        encrypted_data=encrypted_data
                    )
                )
                
                # https://core.telegram.org/mtproto/auth_key#6-server-responds-with
                errors.SecurityError.check(
                    nonce != result.nonce,
                    f'nonce mismatch {nonce} != {result.nonce}'
                )
                errors.SecurityError.check(
                    server_nonce != result.server_nonce,
                    f'server nonce mismatch {server_nonce} != {result.server_nonce}'
                )

                term1 = Int256.to_bytes(new_nonce)
                term2 = Int128.to_bytes(server_nonce)
                
                # term1: byte new_nonce
                # term2: byte server_nonce
                # tmp_aes_key: SHA1(term1 + term2) + substr (SHA1(term2 + term1), 0, 12);
                # tmp_aes_iv: substr (SHA1(term2 + term1), 12, 8) + SHA1(term1 + term1) + substr (term1, 0, 4);
                nn_hash = sha1(term1 + term1).digest()
                ns_hash = sha1(term1 + term2).digest()
                sn_hash = sha1(term2 + term1).digest()

                aes_ige_key, aes_ige_iv = (
                    ns_hash + sn_hash[:12],
                    sn_hash[12:] + nn_hash + term1[:4]
                )
                
                try:
                    answer = crypto.aes_ige256_decrypt(
                        result.encrypted_answer,
                        key=aes_ige_key,
                        iv=aes_ige_iv,
                        hash=True
                    )

                except ValueError:
                    logger.exception('Failed to generate auth key: answer_hash != sha1(answer)')
                    raise
                
                reader = Reader(answer)
                result = reader.object()
                assert isinstance(result, mtproto.types.TypeServerDHInnerData), 'step 6.1 wrong answer %r' % result
                
                errors.SecurityError.check(
                    nonce != result.nonce,
                    f'nonce mismatch {nonce} != {result.nonce}'
                )
                errors.SecurityError.check(
                    server_nonce != result.server_nonce,
                    f'server nonce mismatch {server_nonce} != {result.server_nonce}'
                )
                
                self.state.update_time_offset(result.server_time)

                g_a = bytes_to_long(result.g_a)
                dh_prime = bytes_to_long(result.dh_prime)
                
                # https://core.telegram.org/mtproto/security_guidelines#g-a-and-g-b-validation
                errors.SecurityError.check(g_a <= 1, 'g_a <= 1')
                errors.SecurityError.check(g_a >= (dh_prime - 1), 'g_a >= (dh_prime - 1)')
                errors.SecurityError.check(g_a < 2 ** (2048 - 64), 'g_a < 2 ** (2048 - 64)')
                errors.SecurityError.check(g_a > dh_prime - (2 ** (2048 - 64)), 'g_a > dh_prime - (2 ** (2048 - 64))')
                
                # https://core.telegram.org/mtproto/auth_key#7-client-computes-random-2048-bit-number-b-using-a-sufficient-amount-of-entropy-and-sends-the-server-a-message
                logger.debug('Auth key generation: step [%d]', 7)
                # for retry_id ? 

                b = getrandbits(2048)
                g_b = pow(result.g, b, dh_prime)

                # https://core.telegram.org/mtproto/security_guidelines#g-a-and-g-b-validation
                errors.SecurityError.check(g_b <= 1, 'g_b <= 1')
                errors.SecurityError.check(g_b >= (dh_prime - 1), 'g_b >= (dh_prime - 1)')
                errors.SecurityError.check(g_b < 2 ** (2048 - 64), 'g_b < 2 ** (2048 - 64)')
                errors.SecurityError.check(g_b > dh_prime - (2 ** (2048 - 64)), 'g_b > dh_prime - (2 ** (2048 - 64))')
                
                client_dh_inner = mtproto.types.ClientDHInnerData(
                    nonce=nonce,
                    server_nonce=server_nonce,
                    retry_id=0,
                    g_b=long_to_bytes(g_b)
                )

                logger.debug('Auth key generation: client_dh_inner=%r', client_dh_inner)


                encrypted_data = crypto.aes_ige256_encrypt(
                    client_dh_inner.to_bytes(),
                    key=aes_ige_key,
                    iv=aes_ige_iv,
                    hash=True
                )
                
                # https://core.telegram.org/mtproto/auth_key#8-thereafter-auth-key-equals-powg-ab-mod-dh-prime-on-the-server-it-is-computed-as-powg-b-a-mod-dh-prime-and-on-the-client-as-g-ab-mod-dh-prime
                logger.debug('Auth key generation: step [%d]', 8)
                
                
                result = await self.invoke(mtproto.functions.SetClientDHParams(
                        nonce=nonce,
                        server_nonce=server_nonce,
                        encrypted_data=encrypted_data
                    )
                )
                # https://core.telegram.org/mtproto/auth_key#9-server-responds-in-one-of-three-ways
                logger.debug('Auth key generation: step [%d]', 9)
                
                errors.SecurityError.check(
                    nonce != result.nonce,
                    f'nonce mismatch {nonce} != {result.nonce}'
                )
                errors.SecurityError.check(
                    server_nonce != result.server_nonce,
                    f'server nonce mismatch {server_nonce} != {result.server_nonce}'
                )

                auth_key = long_to_bytes(pow(g_a, b, dh_prime))
                
                auth_key = crypto.AuthKey(auth_key)

                # result.new_nonce_hash1..3 are obtained as the 128 lower-order bits of SHA1
                # of the byte string derived from the new_nonce string by adding a single byte with the value of 1, 2, or 3
                # and followed by another 8 bytes with `auth_key.get_aux_hash()`
                nonce_name: str = None
                for index in range(1, 4):
                    nonce_name = 'new_nonce_hash%d' % index
                    if hasattr(result, nonce_name):
                        nonce_number = index.to_bytes(1, 'little')
                        break

                nonce_hash = sha1(
                        term1
                        + nonce_number
                        + auth_key.get_aux_hash()
                    ).digest()
                nonce_hash = Int128.from_bytes(nonce_hash[4:])

                new_nonce_hash = getattr(result, nonce_name)
                errors.SecurityError.check(
                    nonce_hash != new_nonce_hash,
                    f'nonce hash mismatch: {nonce_hash} != {new_nonce_hash} ({nonce_name!r})'
                )
                
                if isinstance(result, mtproto.types.DhGenFail):
                    raise errors.HandshakeFailedError('Failed to generate DH key')

                if isinstance(result, mtproto.types.DhGenRetry):
                    logger.info(f'Retrying DH key exchange: new_nonce_hash={new_nonce_hash}')
                    # goto step 7 ?
                    continue
                
                salt = Long.from_bytes(
                    crypto.utils.xor(term1[:8], term2[:8])
                )
                created_at = self.state.server_time()
   
                session.add_server_salt(
                    salt,
                    valid_since=created_at,
                    valid_until=created_at + 1800
                )
                self.state.set_server_salt(salt)

            except Exception as exc:
                last_error = exc
                logger.exception('Failed to generate auth key, retrying ...')

            else:
                return auth_key, created_at

        logger.error(
            f'Auth key generation failed after {CREATE_KEY_ATTEMPTS} time(s)'
        )
        raise errors.HandshakeFailedError('Failed to generate auth key') from last_error
