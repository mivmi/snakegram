import typing as t
from abc import ABC, abstractmethod

if t.TYPE_CHECKING:
    from ..alias import StoredEntityType
    from ..models import UserEntity
    from ..crypto import AuthKey

DEFAULT_STATE_DATE = 2 ** 31 - 1

class AbstractSession(ABC):
    @abstractmethod
    def clear(self) -> None:
        """clears all session data."""
        raise NotImplementedError

    @property
    @abstractmethod
    def me(self) -> t.Optional['UserEntity']:
        """the current user's entity, if available."""
        raise NotImplementedError

    @property
    @abstractmethod
    def dc_id(self) -> int:
        """the `dc_id` this session should connect to."""
        raise NotImplementedError

    @property
    @abstractmethod
    def auth_key(self) -> 'AuthKey':
        """the auth key for this session."""
        raise NotImplementedError

    @property
    @abstractmethod
    def created_at(self) -> int:
        """the timestamp when the `auth_key` was created."""
        return 0

    @property
    @abstractmethod
    def time_offset(self) -> int:
        """
        the difference in seconds between the client's local time and the server's time.
        """
        return 0

    @abstractmethod
    def set_dc(self, dc_id: int) -> None:
        """set the `dc_id` for this session."""
        raise NotImplementedError


    @abstractmethod
    def set_auth_key(self, auth_key: bytes, created_at: int) -> None:
        """
        set the auth key.

        Note: server salts are tied to the auth key. when changing the key,
        existing salts should be cleared.

        """
        raise NotImplementedError

    @abstractmethod
    def set_time_offset(self, time_offset: int) -> None:
        """
        set time offset between the client's local time and the server's time
        """
        raise NotImplementedError

    @abstractmethod
    def add_server_salt(
        self,
        salt: int,
        valid_since: int,
        valid_until: int,
    ) -> None:
        """adds server salt to valid salts."""
        raise NotImplementedError

    @abstractmethod
    def get_server_salt(self, now: int) -> t.Tuple[int, int]:
        """
        get a valid server salt for the given time. (`salt`, `valid_until`)
        """
        return 0, 0

    @abstractmethod
    def get_server_salts(self) -> t.List[t.Tuple[int, int, int]]:
        """get all server salts. (`salt`, `valid_since`, `valid_until`)"""
        return []

    @abstractmethod
    def get_server_salts_count(self, now: int) -> int:
        """
        get number of valid server salts at the given time.

        Note: This method also removes expired salts
        """
        raise NotImplementedError

    # entity
    @abstractmethod
    def get_entity(
        self,
        *,
        id: int = None,
        phone: str = None,
        username: str = None
    ) -> t.Optional['StoredEntityType']:
        """get entity by `id`, `phone`, `username`."""
        pass

    @abstractmethod
    def upsert_entity(self, entity: 'StoredEntityType') -> None: 
        """inserts or updates entity."""
        pass
    
    # state
    @abstractmethod
    def set_state(
        self,
        pts: int,
        qts: int,
        seq: int,
        date: int
    ) -> None:
        """set state values."""
        raise NotImplementedError

    @abstractmethod
    def get_state(self) -> t.Tuple[int, int, int, int]:
        """get state as (pts, qts, seq, date)."""
        raise NotImplementedError
    
    @abstractmethod
    def get_channel_pts(self, id: int) -> int:
        """get `pts` for channel by its `id`."""
        raise NotImplementedError

    @abstractmethod
    def set_channel_pts(self, id: int, pts: int) -> None:
        """set `pts` for channel by its `id`."""
        raise NotImplementedError

class AbstractPfsSession(ABC):
    @abstractmethod
    def clear(self):
        """clears all session data."""
        raise NotImplementedError

    @property
    @abstractmethod
    def auth_key(self) -> 'AuthKey':
        """the auth key for this pfs session."""
        raise NotImplementedError

    @property
    @abstractmethod
    def created_at(self) -> int:
        """the timestamp when the `auth_key` was created."""
        return 0
 
    @property
    @abstractmethod
    def expires_at(self) -> int:
        """the timestamp when the `auth_key` expires."""
        raise NotImplementedError

    @abstractmethod
    def set_auth_key(
        self,
        auth_key: bytes,
        created_at: int,
        expires_at: int
    ) -> None:
        """set the auth key."""
        raise NotImplementedError

    @abstractmethod
    def add_server_salt(
        self,
        salt: int,
        valid_since: int,
        valid_until: int,
    ) -> None:
        """adds server salt to valid salts."""
        raise NotImplementedError

    @abstractmethod
    def get_server_salt(self, now: int) -> t.Tuple[int, int]:
        """
        get a valid server salt for the given time. (`salt`, `valid_until`)
        """
        return 0, 0

    @abstractmethod
    def get_server_salts(self) -> t.List[t.Tuple[int, int, int]]:
        """get all server salts. (`salt`, `valid_since`, `valid_until`)"""
        return []

    @abstractmethod
    def get_server_salts_count(self, now: int) -> int:
        """
        get number of valid server salts at the given time.

        Note: This method also removes expired salts
        """
        raise NotImplementedError
