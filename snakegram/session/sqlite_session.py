import os
import sys
import sqlite3
import typing as t
import typing_extensions as te

from functools import wraps

from .. import models, alias
from ..about import __version__, __update_command__

from ..crypto import AuthKey
from .abstract import (
    DEFAULT_STATE_DATE,
    AbstractSession,
    AbstractPfsSession
)
from ..network.datacenter import DEFAULT_DC_ID


T = te.TypeVar('T')
P = te.ParamSpec('P')

VERSION = 1


def with_cursor(
    method: te.Callable[te.Concatenate[object, sqlite3.Cursor, P], T]
) -> te.Callable[te.Concatenate[object, P], T]:
    """
    decorator that provides an `sqlite3.Cursor` to a method and ensures it is
    properly committed and closed

    """
    @wraps(method)
    def wrapper(obj: 'BaseSqlite', *args: P.args, **kwargs: P.kwargs):
        cursor = obj._conn.cursor()

        try:
            return method(obj, cursor, *args, **kwargs)

        finally:
            obj._conn.commit()
            cursor.close()

    return wrapper


class BaseSqlite:
    def __init__(self, database: str = None):
        self._tables: t.Set[str] = set()
        
        if database is None:
            database = ':memory:'

        elif isinstance(database, str):
            if not database.endswith('.sqlite'):
                database += '.sqlite'

            folder = os.path.dirname(database)

            if folder: 
                if not os.path.exists(folder):
                    os.makedirs(folder)

        self._conn = sqlite3.connect(database, check_same_thread=False)
        
        #
        self._auth_key = AuthKey(None)
        self._created_at = 0

        self._on_connect()
    
    @with_cursor
    def _on_connect(self, cursor: sqlite3.Cursor):
        try:
            cursor.execute(
                '''
                SELECT
                    `version`,
                    `lib_version`
                FROM `version` LIMIT 1;
                '''
            )
            version, lib_version = cursor.fetchone()

        except TypeError as exc:
            raise ValueError(
                f'Failed to load session: {exc}'
            ) from exc

        except sqlite3.OperationalError:
            version = None
            self._create(cursor)

        else:
            if version > VERSION:
                raise RuntimeError(
                    f'session version {version} (package: {lib_version!r}) is not supported.'
                    f'current package version is {__version__!r}, '
                    f'max supported session version is {VERSION}.'
                    f'to fix this, update the package: {__update_command__!r}'
                )

        if version != VERSION:
            # update db version
            cursor.execute(
                '''
                INSERT OR REPLACE INTO `version`
                (
                    `id`,
                    `version`,
                    `lib_version`
                )
                VALUES (1, ?, ?);
                ''',
                (VERSION, __version__) 
            )

            # self._update_session(version, VERSION)

        self._load_session(cursor)

    def _create_table(self, cursor: sqlite3.Cursor, _name: str, **columns: str):
        trim_chars = ", \n"
        table_columns = ', '.join(
            f'{k} {v.rstrip(trim_chars)}'
            for k, v in columns.items()
        )

        cursor.execute(
            f'CREATE TABLE IF NOT EXISTS "{_name}" ({table_columns})'
        )

        self._tables.add(_name)
    
    def _create(self, cursor: sqlite3.Cursor):
        self._create_table(
            cursor,
            'version',
            #
            id='INTEGER PRIMARY KEY CHECK (`id` = 1)',
            version='INTEGER NOT NULL',
            lib_version='TEXT NOT NULL'
        )
    
        self._create_table(
            cursor,
            'server-salts',
            #,
            salt='INTEGER PRIMARY KEY',
            valid_since='INTEGER',
            valid_until='INTEGER'
        )


    @property
    def auth_key(self):
        return self._auth_key

    @property
    def created_at(self):
        return self._created_at

    def set_auth_key(
        self,
        cursor: sqlite3.Cursor,
        auth_key: bytes,
        created_at: int
    ):
        self._created_at = created_at
        self._auth_key.set_auth_key(auth_key)

        # remove all server salts
        cursor.execute('DELETE FROM `server-salts` WHERE 1;')

    @with_cursor
    def clear(self, cursor: sqlite3.Cursor):
        if sys.version_info >= (3, 12):
            self._conn.setconfig(sqlite3.SQLITE_DBCONFIG_RESET_DATABASE)
            self._conn.execute('VACUUM')
            self._conn.setconfig(sqlite3.SQLITE_DBCONFIG_RESET_DATABASE, False)

        else:
            for table in self._tables:
                cursor.execute('DROP TABLE IF EXISTS "%s";', (table,))

        self._auth_key.clear()
        self._on_connect()

    # server salts
    @with_cursor
    def add_server_salt(
        self,
        cursor: sqlite3.Cursor,
        salt: int,
        valid_since: int,
        valid_until: int,
    ):

        cursor.execute(
            '''
            INSERT OR REPLACE INTO `server-salts` 
            (
                `salt`,
                `valid_since`,
                `valid_until`
            )
            VALUES (?, ?, ?);
            ''',
            (salt, valid_since, valid_until)
        )

    @with_cursor
    def get_server_salt(
        self, 
        cursor: sqlite3.Cursor,
        now: int
    ) -> t.Tuple[int, int]:

        cursor.execute(
            '''
            SELECT
                `salt`,
                `valid_until`
            FROM `server-salts`
            WHERE `valid_since` < ? AND `valid_until` > ? LIMIT 1;
            ''',
            (now, now)
        )

        result = cursor.fetchone()
        return result if result else (0, 0)

    @with_cursor
    def get_server_salts(self, cursor: sqlite3.Cursor) -> t.List[t.Tuple[int, int, int]]:
        cursor.execute('SELECT * FROM `server-salts` WHERE 1;')

        return [
            (salt, valid_since, valid_until)
            for _, salt, valid_since, valid_until in cursor.fetchall() 
        ]

    @with_cursor
    def get_server_salts_count(self, cursor: sqlite3.Cursor, now: int):
        cursor.execute(
            'DELETE FROM `server-salts` WHERE `valid_until` < ?;',
            (now,)
        )

        cursor.execute('SELECT COUNT(*) FROM `server-salts`;')
        result = cursor.fetchone()
        return result[0] if result else 0

class SqliteSession(BaseSqlite, AbstractSession):
    def _create(self, cursor: sqlite3.Cursor):
        # session
        self._create_table(
            cursor, 
            'session',
            # columns
            id='INTEGER PRIMARY KEY CHECK (`id` = 1)',
            dc_id=f'INTEGER DEFAULT {DEFAULT_DC_ID}',
            user_id='INTEGER CHECK(user_id > 0)',
            auth_key='BLOB CHECK(LENGTH(`auth_key`) = 256)',
            created_at='INTEGER',
            time_offset='INTEGER DEFAULT 0',
        )

        # state
        self._create_table(
            cursor,
            'state',
            id='INTEGER PRIMARY KEY CHECK (id = 1)',
            pts='INTEGER',
            qts='INTEGER',
            seq='INTEGER',
            date='INTEGER DEFAULT 0'
        )

        #
        self._create_table(
            cursor,
            'users',
            id='INTEGER PRIMARY KEY',
            access_hash='INTEGER',
            name='TEXT',
            is_bot='TINYINT DEFAULT 0',
            phone='TEXT',
            username='TEXT'
        )

        self._create_table(
            cursor,
            'channels',
            id='INTEGER PRIMARY KEY',
            access_hash='INTEGER',
            title='TEXT',
            username='TEXT',
            pts='INTEGER DEFAULT 0'
        )

        super()._create(cursor)
        self._load_session(cursor)

    def _load_session(self, cursor: sqlite3.Cursor):
        self._dc_id: int = DEFAULT_DC_ID
        self._created_at: int = 0
        self._time_offset: int = 0

        #
        self._pts: int = 0
        self._qts: int = 0
        self._seq: int = 0
        self._user_id: t.Optional[int] = None
        self._state_date: int = DEFAULT_STATE_DATE
        self._self_entity: t.Optional[models.UserEntity] = None

        cursor.execute(
            '''
            SELECT
                `dc_id`,
                `user_id`,
                `auth_key`,
                `created_at`,
                `time_offset`
            FROM `session` WHERE `id` = 1;
            '''
        )
        session = cursor.fetchone()
        
        if session:
            self._dc_id = session[0]
            self._user_id = session[1]
            self._created_at = session[3]
            self._time_offset = session[4]

            if session[2] is not None:
                self._auth_key.set_auth_key(session[2])

        # state
        cursor.execute(
            '''
            SELECT
                `pts`,
                `qts`,
                `seq`,
                `date`
            FROM `state` WHERE `id` = 1;
            '''
        )
        state = cursor.fetchone()
        if state:
            self._pts = state[0]
            self._qts = state[1]
            self._seq = state[2]
            self._state_date = state[3]
        
        if self._user_id:
            self._self_entity = self.get_entity(id=self._user_id)

    @property
    def me(self):
        return self._self_entity

    @property
    def dc_id(self):
        return self._dc_id

    @property
    def time_offset(self):
        return self._time_offset

    @with_cursor
    def set_dc(self, cursor: sqlite3.Cursor, dc_id: int):
        self.clear()
        self._dc_id = dc_id

        cursor.execute(
            '''
            INSERT INTO `session` 
            (
                `id`,
                `dc_id`
            )
            VALUES (1, ?);
            ''',
            (dc_id,)
        )

    @with_cursor
    def set_auth_key(self, cursor, auth_key, created_at):
        cursor.execute('SELECT 1 FROM `session` WHERE `id` = 1;')
        if cursor.fetchone():
            cursor.execute(
                '''
                UPDATE `session` SET
                    `auth_key` = ?,
                    `created_at` = ?
                WHERE `id` = 1;
                ''',
                (auth_key, created_at)
            )
        else:
            cursor.execute(
                '''
                INSERT INTO `session`
                    (id, auth_key, created_at)
                VALUES (1, ?, ?);
                ''',
                (auth_key, created_at)
            )

        super().set_auth_key(cursor, auth_key, created_at)
    
    @with_cursor
    def set_time_offset(
        self,
        cursor: sqlite3.Cursor,
        time_offset: int
    ):
        self._time_offset = time_offset

        cursor.execute('SELECT 1 FROM `session` WHERE `id` = 1;')
        if cursor.fetchone():
            cursor.execute(
                '''
                UPDATE `session` SET
                    `time_offset` = ?
                WHERE `id` = 1;
                ''',
                (time_offset,)
            )
        else:
            cursor.execute(
                '''
                INSERT INTO `session`
                    (
                        `id`,
                        `time_offset`
                    )
                VALUES (1, ?);
                ''',
                (time_offset,)
            )

    # entities
    @with_cursor
    def get_entity(
        self,
        cursor: sqlite3.Cursor,
        *,
        id: int = None,
        phone: str = None,
        username: str = None,
    ) -> t.Optional[alias.StoredEntityType]:

        wheres = {}
        is_channel = None

        if id is not None:
            wheres['id'] = id

        elif phone is not None:
            is_channel = False
            wheres['phone'] = phone

        elif username is not None:
            wheres['username'] = username

        else:
            raise ValueError(
                'WHERE clause is empty (no id, username, or phone given).'
            )

        if not wheres:
            return None

        result = None
        where_sql = ' AND '.join(f'{k} = ?' for k in wheres)

        if not is_channel:
            cursor.execute(
                f'''
                SELECT
                    `id`,
                    `access_hash`,
                    `name`,
                    `is_bot`,
                    `phone`,
                    `username`
                FROM `users` WHERE {where_sql} LIMIT 1;
                ''',
                tuple(wheres.values())
            )
            result = cursor.fetchone()
            if result is not None:
                is_channel = False

        if result is None and (is_channel or is_channel is None):
            cursor.execute(
                f'''
                SELECT
                    `id`,
                    `access_hash`,
                    `title`,
                    `username`
                FROM `channels` WHERE {where_sql} LIMIT 1;
                ''',
                tuple(wheres.values())
            )
            result = cursor.fetchone()
            if result is not None:
                is_channel = True

        if result is not None:
            if is_channel:
                return models.ChannelEntity(
                    result[0],
                    result[1],
                    result[2],
                    username=result[3]
                )
            else:
                return models.UserEntity(
                    result[0],
                    result[1],
                    result[2],
                    bool(result[3]),
                    (result[0] == self._user_id),
                    phone=result[4],
                    username=result[5]
                )

        return None

    @with_cursor
    def upsert_entity(
        self,
        cursor: sqlite3.Cursor,
        entity: alias.StoredEntityType
    ):
        is_channel = isinstance(entity, models.ChannelEntity)

        if is_channel:
            cursor.execute(
                'SELECT 1 FROM `channels` WHERE `id` = ?;',
                (entity.id,)
            )

            if cursor.fetchone():
                cursor.execute(
                    '''
                    UPDATE `channels` SET
                        `access_hash` = ?,
                        `title` = ?,
                        `username` = ?
                    WHERE `id` = ?;
                    ''',
                    (
                        entity.access_hash,
                        entity.title,
                        entity.username,
                        entity.id
                    )
                )

            else:
                cursor.execute(
                    '''
                    INSERT INTO `channels` 
                        (
                            `id`,
                            `access_hash`,
                            `title`,
                            `username`
                        )
                    VALUES (?, ?, ?, ?);
                    ''',
                    (
                        entity.id,
                        entity.access_hash,
                        entity.title,
                        entity.username
                    )
                )

        else:
            cursor.execute(
                '''
                INSERT OR REPLACE INTO `users` 
                    (
                        `id`,
                        `access_hash`,
                        `name`,
                        `is_bot`,
                        `phone`,
                        `username`
                    )
                VALUES (?, ?, ?, ?, ?, ?);
                ''',
                (
                    entity.id,
                    entity.access_hash,
                    entity.name,
                    entity.is_bot,
                    entity.phone,
                    entity.username
                )
            )

            if entity.is_self:
                
                if self._user_id is None:
                    cursor.execute(
                        '''
                        UPDATE `session` SET
                            `user_id` = ?
                        WHERE `id` = ?;
                        ''',
                        (entity.id, 1)
                    )

                self._user_id = entity.id
                self._self_entity = entity

    # update state
    @with_cursor
    def set_state(
        self,
        cursor: sqlite3.Cursor,
        pts: int = None,
        qts: int = None,
        seq: int = None,
        date: int = None
    ):
        self._pts = pts or self._pts
        self._qts = qts or self._qts
        self._seq = seq or self._seq
        self._state_date = date or self._state_date

        cursor.execute(
            '''
            INSERT OR REPLACE INTO `state` 
            (
                `id`,
                `pts`,
                `qts`,
                `seq`,
                `date`
            )
            VALUES (1, ?, ?, ?, ?);
            ''',
            (self._pts, self._qts, self._seq, self._state_date)
        )

    def get_state(self):
        date = self._state_date or DEFAULT_STATE_DATE
        return self._pts, self._qts, self._seq, date

    @with_cursor
    def get_channel_pts(self, cursor: sqlite3.Cursor, id: int) -> int:
        cursor.execute(
            '''
            SELECT 
                `pts`
            FROM `channels` WHERE `id` = ?;
            ''',
            (id,)
        )
        result = cursor.fetchone()
        return result[0] if result else 0

    @with_cursor
    def set_channel_pts(self, cursor: sqlite3.Cursor, id: int, pts: int):
        cursor.execute(
            'SELECT 1 FROM `channels` WHERE `id` = ?;',
            (id,)
        )
        if cursor.fetchone():
            cursor.execute(
                '''
                UPDATE `channels` SET
                    `pts` = ?
                WHERE `id` = ?;
                ''',
                (pts, id)
            )
        else:
            cursor.execute(
                '''
                INSERT INTO `channels`
                (
                    `id`,
                    `pts`
                )
                VALUES (?, ?);
                ''',
                (id, pts)
            )


class SqlitePfsSession(BaseSqlite, AbstractPfsSession):
    def _create(self, cursor: sqlite3.Cursor):
        self._create_table(
            cursor, 
            'session',
            #
            id='INTEGER PRIMARY KEY CHECK (`id` = 1)',
            auth_key='BLOB CHECK(LENGTH(`auth_key`) = 256)',
            created_at='INTEGER',
            expires_at='INTEGER',
        )

        super()._create(cursor)
        self._load_session(cursor)

    def _load_session(self, cursor: sqlite3.Cursor):
        self._expires_at: int = 0

        cursor.execute(
            '''
            SELECT
                `auth_key`,
                `created_at`,
                `expires_at`
            FROM `session` WHERE `id` = 1;
            '''
        )
        session = cursor.fetchone()
        
        if session:
            self._created_at = session[1]
            self._expires_at = session[2]

            if session[0] is not None:
                self._auth_key.set_auth_key(session[0])
        

    @property
    def expires_at(self):
        return self._expires_at
    
    @with_cursor
    def set_auth_key(self, cursor, auth_key, created_at, expires_at):
        cursor.execute('SELECT 1 FROM `session` WHERE `id` = 1')
        if cursor.fetchone():
            cursor.execute(
                '''
                UPDATE `session` SET
                    `auth_key` = ?,
                    `created_at` = ?,
                    `expires_at` = ?
                WHERE `id` = 1;
                ''',
                (auth_key, created_at, expires_at)
            )
        else:
            cursor.execute(
                '''
                INSERT INTO `session`
                (
                    `id`,
                    `auth_key`,
                    `created_at`,
                    `expires_at`
                )
                VALUES (1, ?, ?, ?);
                ''',
                (auth_key, created_at, expires_at)
            )
            
        self._expires_at = expires_at
        super().set_auth_key(cursor, auth_key, created_at)
