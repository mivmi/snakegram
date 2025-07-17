import typing as t
from .sqlite_session import SqliteSession, SqlitePfsSession

class MemorySession(SqliteSession):
    def __init__(self, name: t.Optional[str] = None):
        self.name = name
        super().__init__(database=None) # :memory:

class MemoryPfsSession(SqlitePfsSession):
    def __init__(self, name: t.Optional[str] = None):
        self.name = name
        super().__init__(database=None)