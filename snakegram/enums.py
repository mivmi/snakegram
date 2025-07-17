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
