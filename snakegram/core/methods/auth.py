import re
import logging
import warnings
import typing as t
from random import randint
from getpass import getpass


from ... import errors, alias, helpers
from ...tl import types, functions
from ...crypto import get_check_password_srp
from ...gadgets.utils import env, retry, adaptive

if t.TYPE_CHECKING:
    from ..telegram import Telegram


logger = logging.getLogger(__name__)

# type aliases
LikePassword = t.Union[
    str,
    bytes,
    types.TypeInputCheckPasswordSRP
]

CodeCallback = t.Callable[
    [types.auth.SentCode], t.Union[str]
]

PasswordOrCallback = t.Union[
    LikePassword,  # string/bytes/SRP
    t.Callable[[types.account.Password], LikePassword]
]

PhoneOrTokenOrCallback = t.Union[
    alias.PhoneOrToken,
    t.Callable[[], alias.PhoneOrToken]
]

# evn
TEST_MODE = env('TEST_MODE', False, bool)
AUTH_ATTEMPTS = env('AUTH_ATTEMPTS', 3, int)


def _sent_via(sent_code: types.auth.SentCode):
    mapping = {
        0X9FD736: 'Firebase SMS',
        0X3DBB5986: 'Telegram app',
        0XC000BBA2: 'SMS',
        0X5353E5A7: 'phone call',
        0XAB03C6D9: 'flash call',
        0X82006484: 'missed call',
        0XF450F59B: 'email',
        0XA5491DEA: 'email setup required',
        0XD9565C39: 'fragment SMS',
        0XA416AC81: 'SMS word',
        0XB37794AF: 'SMS phrase',
    }

    return mapping.get(sent_code.type._id, 'unknown method')

def _warn_conflicts(
    user: types.User,
    *,
    bot_id: t.Optional[int] = None,
    phone_number: t.Optional[alias.Phone] = None
):
    if (
        (bot_id and bot_id != user.id)
        or
        (phone_number and user.phone != phone_number)
    ):
        type_name = 'bot token' if bot_id else 'phone number'
        warnings.warn(
            'The current session is already authorized '
            f'({helpers.get_display_name(user)!r}) with a different user. '
            f'the provided {type_name!r} was not used to log in. '
            'if you expected to authorize a different account, '
            'please check if you are reusing an existing session.',
            stacklevel=3
        )

    return user

def _parse_phone_or_token(value: str):
    bot_id = None
    bot_token = None
    phone_number = None

    if isinstance(value, str):
        result = re.match(
            r'^(\d{6,10}):([A-Za-z0-9_-]{35})$',
            value
        )
        if result:
            bot_id = int(result.group(1))
            bot_token = value

        else:
            phone_number = helpers.parse_phone_number(value)

    return bot_id, bot_token, phone_number


class Auth:
    _phone_code_hash_map: t.Dict[str, str] = {}

    @adaptive
    async def start(
        self: 'Telegram',
        phone_or_token: t.Optional[PhoneOrTokenOrCallback] = None,
        *,
        password: t.Optional[PasswordOrCallback] = None,
        code_callback: t.Optional[CodeCallback] = None,
        first_name: str = 'New User',
        last_name: str = '',
        code_settings: types.CodeSettings = types.CodeSettings(),
        email_verification: t.Optional[types.TypeEmailVerification] = None,
        no_joined_notifications: bool = False
    ):

        """
        Starts the Telegram client.

        This method ensures the client is connected and authenticated.

        Args:
            phone_or_token (`PhoneOrTokenOrCallback`, optional):
                The phone number (e.g., '+1 (234) 567-8901') or bot token (e.g., '12345:ABC...').
                Alternatively, a callable that returns one of these strings.
                If not provided, the value will be requested from the terminal input.

            password (`PasswordOrCallback`, optional):
                The password for accounts with two-factor authentication enabled.
                Can be a string, bytes, or a `TypeInputCheckPasswordSRP` object,
                or a callable that takes a `types.account.Password` and returns one of these types.
                If not provided, the password will be requested from terminal input when needed.

            code_callback (`CodeCallback`, optional):
                A callable that receives a `SentCode` object and returns the login code as a string.
                If not provided, the code will be requested from terminal input by default.

            first_name (str, optional):
                The first name to use when signing up a new account, if needed.
                Defaults to 'New User'.

            last_name (str, optional):
                The last name to use when signing up a new account, if needed.
                Defaults to an empty string.

            code_settings (types.CodeSettings, optional):
                Settings used by Telegram servers for sending the confirmation code.
                Defaults to `CodeSettings()`.

            email_verification (types.TypeEmailVerification, optional):
                Email verification code or token, if required.

            no_joined_notifications (bool, optional):
                Whether to suppress "joined Telegram" notifications.

        Returns:
            Telegram: The client instance after successful login.
        
        Example:
        ```
        python
        
        await client.start('12345:ABC...')
        
        # or 
        await client.start('+1 (234) 567-8901')
        
        >>> Enter the login code sent via "app": 12345
        >>> 2FA Password ( "my-hint" ): *****

        >>> Successfully logged in as "New User"
        ```
        """

        if not (
            callable(phone_or_token)
            or isinstance(phone_or_token, str)
        ):
            if phone_or_token is None:
                phone_or_token = lambda: input('Phone number or bot token: ')

            else:
                raise TypeError(
                    '"phone_or_token" must be a string '
                    '(phone number or token) or a callable returning one, '
                    f'not a {type(phone_or_token).__name__!r}'
                )

        if not (
            callable(password)
            or isinstance(password, str)
        ):
            if password is None:
                password = lambda p: getpass(f'2FA Password ({p.hint!r}): ')

            else:
                raise TypeError(
                    '"password" must be a '
                    'string or a callable returning one, '
                    f'not a {type(password).__name__!r}'
                )
        
        if not callable(code_callback):
            if code_callback is None:
                code_callback = lambda c: input(
                    f'Enter the login code sent via ({_sent_via(c)!r}): '
                )

            else:
                raise TypeError(
                    'code_callback must be a '
                    'callable that returns the login code, '
                    f'not a {type(code_callback).__name__!r}'
                )

        if not self.is_connected():
            await self.connect()

        code = None
        state = None
        passwd = None
        account_password = None
        sign_up_required = False

        target_phone_or_token = (
            None
            if callable(phone_or_token) else
            phone_or_token
        )

        is_fixed_password = not callable(password)
        is_fixed_phone_or_token = not callable(phone_or_token)

        me = await self.get_me()
        if me is not None:
            if is_fixed_phone_or_token:
                bot_id, _, phone = _parse_phone_or_token(phone_or_token)
                _warn_conflicts(
                    me,
                    bot_id=bot_id,
                    phone_number=phone
                )

            return self

        attempts = 0
        while attempts < AUTH_ATTEMPTS:
            try:
                if sign_up_required:
                    state = await self.sign_up(
                        target_phone_or_token, # phone number
                        first_name=first_name,
                        last_name=last_name,
                        no_joined_notifications=no_joined_notifications
                    )

                else:
                    # get phone or token
                    while not target_phone_or_token:
                        if TEST_MODE:
                            # https://core.telegram.org/api/auth#test-accounts

                            target_phone_or_token = f'99966{self.session.dc_id}{randint(0, 9999):04d}'

                        else:
                            target_phone_or_token = phone_or_token()

                    if isinstance(account_password, types.account.Password):
                        if not is_fixed_password:
                            raw_password = password(account_password)

                            if not isinstance(raw_password, str):
                                raise errors.PasswordHashInvalidError(None)

                        else:
                            raw_password = password

                        if not isinstance(
                            raw_password,
                            types.TypeInputCheckPasswordSRP
                        ):
                            passwd = get_check_password_srp(
                                account_password,
                                raw_password
                            )

                        else:
                            passwd = raw_password

                    elif isinstance(state, types.auth.SentCode):
                        if TEST_MODE:
                            # In `TEST_MODE`, the login code is always the string of dc_id repeated "5" times.
                            # For example, if dc_id = 2, the code will be "22222"

                            code = str(self.session.dc_id) * 5
                        else:
                            code = code_callback(state)
                            if not code:
                                raise errors.PhoneCodeEmptyError(None)

                    state = await self.sign_in(
                        target_phone_or_token,
                        code=code,
                        password=passwd,
                        code_settings=code_settings,
                        email_verification=email_verification
                    )

            except (
                errors.AuthRestartError,
                errors.PhoneCodeExpiredError
            ):
                code = None
                state = None
                passwd = None
                account_password = None
                logger.exception(
                    'Auth interrupted; auth restart required ...'
                )

            except (
                errors.AuthTokenInvalidError,
                errors.PhoneNumberInvalidError
            ):
                if is_fixed_phone_or_token:
                    raise 

                logger.error(
                    'Invalid phone number or bot token: %r',
                    target_phone_or_token
                )
                target_phone_or_token = None

            except (
                errors.PhoneCodeEmptyError,
                errors.PhoneCodeInvalidError
            ):
                if TEST_MODE:
                    raise 

                code = None
                logger.error('The code is empty or invalid.')

            except errors.PasswordHashInvalidError:
                if is_fixed_password:
                    logger.exception('Password invalid and password is fixed')
                    raise
    
                passwd = None
                logger.error('Invalid password.')

            except errors.SessionPasswordNeededError:
                code = None
                attempts = 0
                account_password = await self(functions.account.GetPassword())
                logger.info('Session password required (hint: %r)', account_password.hint)
                continue

            except errors.PhoneNumberOccupiedError:
                sign_up_required = False
                logger.info('Phone number is already occupied. proceeding with sign in.')

            except errors.PhoneNumberUnoccupiedError:
                sign_up_required = True
                logger.info('Phone number is unoccupied. proceeding with sign up.')

            if isinstance(
                state,
                types.auth.AuthorizationSignUpRequired
            ):
                sign_up_required = True
                logger.info('Authorization indicates sign-up is required.')

            elif isinstance(
                state,
                (
                    types.TypeUser,
                    types.auth.Authorization
                )
            ):
                break

            attempts += 1

        else:
            raise RuntimeError(
                f'Failed to sign in after {attempts} of attempts'
            )

        return self

    async def sign_up(
        self: 'Telegram',
        phone_number: alias.Phone,
        first_name: str,
        last_name: str = '',
        code_settings: types.CodeSettings = types.CodeSettings(),
        phone_code_hash: t.Optional[str] = None,
        no_joined_notifications: bool = False
    ):

        """
        Registers a new Telegram account.

        Args:
            phone_number (str):
                The phone number to register (e.g., `+1 (234) 567-8901`).

            first_name (str):
                First name of the user to create.

            last_name (str, optional):
                Last name of the user to create.

            code_settings (CodeSettings, optional):
                Settings used by telegram servers for sending the confirm code.
                Defaults to `CodeSettings()`.

            phone_code_hash (str, optional):
                Hash returned from a previous `auth.sendCode` call.
                If `None`, a cached value will be used if available, otherwise a new code will be sent.

            no_joined_notifications (bool, optional):
                Whether to suppress "joined Telegram" notifications.

        Returns:
            - `types.TypeUser` if already signed in with an existing session.
            - `types.auth.SentCode` if `phone_code_hash` is not found.
            - `types.auth.TypeAuthAuthorization` on successful registration.

        Example:
            ```python
            phone = '+1 (234) 567-8901'
    
            await client.sign_in(phone)
            code = input('code: ')
            result = await client.sign_in(phone, code=code)
            if isinstance(result, AuthorizationSignUpRequired):
                result = await client.sign_up(phone, first_name='John')
            print(result.user)
            ```

        Note:
            This method is typically used internally during `start()`.
            To simplify the login or sign-up process, use `start()` instead.
        """
        me = await self.get_me()
        phone = helpers.parse_phone_number(phone_number)

        if me is not None:
            return _warn_conflicts(
                me,
                phone_number=phone
            )

        phone_code_hash = (
            phone_code_hash
            or
            self._phone_code_hash_map.get(phone)
        )

        if phone_code_hash is None:
            logger.debug(
                'No phone_code_hash for %r, sending code.',
                phone
            )
            return await self.sign_in(
                phone,
                code_settings=code_settings
            )

        result = await self(
            functions.auth.SignUp(
                phone_number=phone,
                phone_code_hash=phone_code_hash,
                first_name=first_name,
                last_name=last_name,
                no_joined_notifications=no_joined_notifications
            )
        )

        if isinstance(result, types.auth.Authorization):
            logger.info(
                'Successfully signed up as %r',
                helpers.get_display_name(result.user)
            )
            self._authorized = True
            await self._handle_updates_too_long()

        return result

    async def sign_in(
        self: 'Telegram',
        phone_or_token: alias.PhoneOrToken,   
        *,
        code: t.Optional[str] = None,
        password: t.Optional[LikePassword] = None,
        code_settings: types.CodeSettings = types.CodeSettings(),
        phone_code_hash: t.Optional[str] = None,
        email_verification: t.Optional[types.TypeEmailVerification] = None
    ):
        """
        Signs in to a Telegram account (user or bot).

        ## If you're already signed in, the current user is returned and no further action is taken.

        Args:
            phone_or_token (str):
                phone number (e.g., `+1 (234) 567-8901`) for user accounts,
                or bot token (e.g., `12345:ABC...`) for bots

            code (str, optional):
                The verification code sent to the phone.
                Only required after `send_code(phone)` or `sign_in(phone)`.

            password (str | bytes, optional):
                The 2FA password for accounts with two-step verification enabled.
                Required only if `SessionPasswordNeededError` is raised during sign-in.

            code_settings (CodeSettings, optional):
                Settings used by telegram servers for sending the confirm code.
                Defaults to `CodeSettings()`.

            phone_code_hash (str, optional):
                Hash returned from a previous `auth.sendCode` call.
                - If `None`, a cached value will be used if available.
                - If no cached hash is found, a new code will be sent.

            email_verification (TypeEmailVerification, optional):
                Email verification code or token.


        Returns:
            - `types.TypeUser` if already signed in with an existing session.
            - `types.auth.SentCode` if only the phone number is provided or if `phone_code_hash` is not found.
            - `types.auth.TypeAuthAuthorization` otherwise, upon successful auth.


        Example:
            ```python
            phone = '+1 (234) 567-8901'
            await client.sign_in(phone)  # Sends code

            code = input('Code: ')
            try:
                result = await client.sign_in(phone, code=code)
            except errors.SessionPasswordNeededError:
                password = input('2FA Password: ')
                result = await client.sign_in(phone, password=password)

            print(result.user)
            ```

        Note:
            This method is typically used internally during `start()`.
            To simplify the login or sign-up process, use `start()` instead.
        """

        me = await self.get_me()
        bot_id, bot_token, phone = _parse_phone_or_token(phone_or_token)
  
        if me is not None:
            return _warn_conflicts(
                me,
                bot_id=bot_id,
                phone_number=phone
            )

        if not bot_token and not phone:
            logger.error(
                'Invalid phone number or bot token provided: %r',
                phone_or_token
            )
            raise ValueError('Invalid phone number or bot token provided')

        request = None
        if bot_token:
            logger.debug('Signing in using bot token.')
            request = functions.auth.ImportBotAuthorization(
                flags=0,
                api_id=self.api_id,
                api_hash=self.api_hash,
                bot_auth_token=bot_token
            )

        else:
            phone_code_hash = (
                phone_code_hash
                or
                self._phone_code_hash_map.get(phone)
            )

            if phone_code_hash is None:
                logger.debug(
                    'No phone_code_hash for %r, sending code.',
                    phone
                )
                return await self.send_code(
                    phone,
                    code_settings=code_settings
                )

            if code:
                logger.debug(
                    'Preparing "SignIn" request with phone code:%r for %r',
                    code,
                    phone
                )
                request = functions.auth.SignIn(
                    phone,
                    phone_code=code,
                    phone_code_hash=phone_code_hash,
                    email_verification=email_verification
                )

            elif password is not None:
                logger.debug(
                    'Preparing "CheckPassword" request with phone code for %r',
                    phone
                )
    
                if not isinstance(password, types.TypeInputCheckPasswordSRP):
                    data = await self(functions.account.GetPassword())
                    password = get_check_password_srp(data, password)
                
                errors.CodeInvalidError

                request = functions.auth.CheckPassword(password)

        if request is None:
            raise RuntimeError(
                'Unable to determine the auth step: neither bot token'
                ', verification code, nor password was provided. '
                'To proceed with sign-in, at least one of these must be supplied.'
            )

        try:
            result = await self(request)

        except errors.SeeOtherError as exc:
            self._phone_code_hash_map.pop(phone, None)
            await self.connection.migrate(
                exc.dc_id,
                exception=exc
            )
            return await self.sign_in(
                phone_or_token,
                code_settings=code_settings,
                email_verification=email_verification
            )

        except errors.PhoneCodeExpiredError:
            self._phone_code_hash_map.pop(phone, None)
            raise

        if isinstance(result, types.auth.Authorization):
            logger.info(
                'Successfully logged in as %r',
                helpers.get_display_name(result.user)
            )
            self._authorized = True
            await self._handle_updates_too_long()
    
        return result

    async def send_code(
        self: 'Telegram',
        phone_number: alias.Phone,
        *,
        code_settings: types.CodeSettings = types.CodeSettings(),
        phone_code_hash: t.Optional[str] = None,
        resend_code_reason: t.Optional[str] = None
    ):

        """
        Sends or resends a login code to phone number.

        Args:
            phone_number (Phone): The phone number.

            code_settings (CodeSettings, optional): 
                Settings used by telegram servers for sending the confirm code.
                Defaults to `CodeSettings()`.

            phone_code_hash (str, optional): 
                Hash returned from a previous `auth.sendCode` call.

                - If `None`, a cached value will be used if available.
                - If no cached hash is found, a new code will be sent.
                - If a valid hash exists, the code will be resent using that hash.

            resend_code_reason (str, optional):
                Reason for resending the code.  
                This is only used by official Telegram clients **if device integrity verification fails**
                and no secret can be obtained to invoke `auth.RequestFirebaseSms`.
                In such cases, the reason for the integrity verification failure must be passed here.

        Example:
        ```python
        await client.send_code('+1 (234) 567-8901')
        SentCode(...)
        ```
        """

        phone = helpers.parse_phone_number(phone_number)

        phone_code_hash = (
            phone_code_hash
            or self._phone_code_hash_map.get(phone)
        )

        for attempt in retry(AUTH_ATTEMPTS):
            try:
                if phone_code_hash:
                    logger.debug('Resending code to: %r ...', phone)

                    result = await self(
                        functions.auth.ResendCode(
                            phone,
                            phone_code_hash=phone_code_hash,
                            reason=resend_code_reason
                        )
                    )

                else:
                    logger.debug('Sending code to %r ...', phone)

                    result = await self(
                        functions.auth.SendCode(
                            phone,
                            api_id=self.api_id,
                            api_hash=self.api_hash,
                            settings=code_settings
                        )
                    )
            except errors.SeeOtherError as exc:
                self._phone_code_hash_map.pop(phone, None)
                await self.connection.migrate(
                    exc.dc_id,
                    exception=exc
                )
                return await self.send_code(
                    phone_number,
                    code_settings=code_settings
                )

            except errors.AuthRestartError as exc:
                logger.error(f'Sending code failed due to: {exc}')

                if attempt < AUTH_ATTEMPTS:
                    continue
                raise

            except errors.PhoneCodeExpiredError as exc:
                logger.warning(f'Sending code failed due to: {exc}')

                if attempt < AUTH_ATTEMPTS:
                    phone_code_hash = None
                    self._phone_code_hash_map.pop(phone, None)
                    continue
                raise

            else:
                if isinstance(result, types.auth.SentCodeSuccess):
                    logger.info('Logged in using future auth tokens.')
                    return result.authorization

                logger.info('Code sent successfully to %r', phone)
                self._phone_code_hash_map[phone] = result.phone_code_hash
                return result

        raise RuntimeError(
            f'Failed to send code after {AUTH_ATTEMPTS} attempts.'
        )
