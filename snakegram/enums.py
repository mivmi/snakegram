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
    Error = enum.auto()
    Result = enum.auto()
    Update = enum.auto()
    Request = enum.auto()
    
    @property
    def title(self):
        return self.name.lower()

class MessageEntityType(enum.IntEnum):
    Mention = enum.auto()
    Hashtag = enum.auto()
    BotCommand = enum.auto()
    Url = enum.auto()
    EmailAddress = enum.auto()
    Bold = enum.auto()
    Italic = enum.auto()
    Code = enum.auto()
    Pre = enum.auto()
    PreCode = enum.auto()
    TextUrl = enum.auto()
    MentionName = enum.auto()
    Cashtag = enum.auto()
    PhoneNumber = enum.auto()
    Underline = enum.auto()
    Strikethrough = enum.auto()
    BlockQuote = enum.auto()
    BankCardNumber = enum.auto()
    MediaTimestamp = enum.auto()
    Spoiler = enum.auto()
    CustomEmoji = enum.auto()
    ExpandableBlockQuote = enum.auto()