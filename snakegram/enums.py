import enum

class Operation(enum.Enum):
    In = enum.auto()
    Eq = enum.auto()
    Lt = enum.auto()
    Gt = enum.auto()
    Le = enum.auto()
    Ge = enum.auto()
    Ne = enum.auto()
    Or = enum.auto()
    And = enum.auto()
    Not = enum.auto()
    TypeOf = enum.auto()

    @property
    def is_logical(self):
        return self in (Operation.Or, Operation.And, Operation.Not)

class EventType(enum.Enum):
    Null = enum.auto()
    Error = enum.auto()
    Result = enum.auto()
    Update = enum.auto()
    Request = enum.auto()

class EntityType(enum.IntEnum):
    Bot = enum.auto()
    User = enum.auto()
    Group = enum.auto()
    Channel = enum.auto()
    Megagroup = enum.auto()
    Gigagroup = enum.auto()

    @property
    def char(self):
        return self.name[0]

    @property
    def is_user(self):
        return self in (EntityType.Bot, EntityType.User)
    
    @property
    def is_group(self):
        return self is EntityType.Group

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


class MessageEntityType(enum.IntEnum):
    Mention = 0
    Hashtag = 1
    BotCommand = 2
    Url = 3
    EmailAddress = 4
    Bold = 5
    Italic = 6
    Code = 7
    Pre = 8
    PreCode = 9
    TextUrl = 10
    MentionName = 11
    Cashtag = 12
    PhoneNumber = 13
    Underline = 14
    Strikethrough = 15
    BlockQuote = 16
    BankCardNumber = 17
    MediaTimestamp = 18
    Spoiler = 19
    CustomEmoji = 20
    ExpandableBlockQuote = 21
