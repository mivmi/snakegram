import enum

class Operation(enum.Enum):
    IN = enum.auto()
    EQ = enum.auto()
    LT = enum.auto()
    GT = enum.auto()
    LE = enum.auto()
    GE = enum.auto()
    NE = enum.auto()
    OR = enum.auto()
    AND = enum.auto()
    NOT = enum.auto()
    TYPE_OF = enum.auto()

    @property
    def is_logical(self):
        return self in (Operation.OR, Operation.AND, Operation.NOT)


class EntityType(enum.IntEnum):
    BOT = enum.auto()
    USER = enum.auto()
    GROUP = enum.auto()
    CHANNEL = enum.auto()
    MEGAGROUP = enum.auto()
    GIGAGROUP = enum.auto()

    @property
    def char(self):
        return self.name[0]

    @property
    def is_user(self):
        return self in (EntityType.BOT, EntityType.USER)
    
    @property
    def is_group(self):
        return self is EntityType.GROUP

    @property
    def is_channel(self):
        return not any((self.is_user, self.is_group))

    @classmethod
    def from_char(cls, char: str):
        if len(char) == 1:
            char = char.upper()
            for etype in EntityType:
                if etype.char == char:
                    return etype

        raise ValueError(f'invalid entity type char: {char!r}')