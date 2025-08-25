import typing as t

from .base import BaseParser
from ...enums import MessageEntityType
from ...models import MessageEntity

GT = '>'
NOT = '!'
STAR = '*'
UNDERSCORE = '_'
BACKTICK = '`'
TRIPLE_BACKTICK = '```'
TILDE = '~'
DOUBLE_UNDERSCORE = '__'
DOUBLE_PIPE = '||'

BRACKET_OPEN = '['
BRACKET_CLOSE = ']'

PAREN_OPEN = '('
PAREN_CLOSE = ')'

_PRE_CODE = object()
_BLOCK_QUOTE = object()

def build(markers: t.List[str]):
    table = {}
    final = {}
    last_state = 1

    for marker in markers:
        state = 0
        for ch in marker:
            if (state, ch) not in table:
                table[(state, ch)] = last_state
                last_state += 1
            state = table[(state, ch)]
        final[state] = marker

    return table, final


class Markdown(BaseParser):
    markers = [
        GT,
        NOT,
        BRACKET_OPEN,
        BRACKET_CLOSE,
        PAREN_OPEN,
        PAREN_CLOSE
    ]

    delimiters = [
        STAR,
        UNDERSCORE,
        BACKTICK,
        TILDE,
        DOUBLE_UNDERSCORE,
        DOUBLE_PIPE,
        TRIPLE_BACKTICK
    ]
    markers.extend(delimiters)
    state_table, final = build(markers)

    @classmethod
    def tokenize(cls, text: str):
        buffer = ''
        tokens = []
        stacks = {}

        index = 0
        length = len(text)

        while index < length:
            char = text[index]

            # handle escaped like "\*"
            if char == '\\' and index + 1 < length:
                index += 2
                buffer += text[index - 1]
                continue

            state = 0
            last_final = None
            last_final_pos = None

            state_index = index
            while state_index < length:
                next_char = text[state_index]
                if (state, next_char) not in cls.state_table:
                    break

                state = cls.state_table[(state, next_char)]
                state_index += 1

                if state in cls.final:
                    marker = cls.final[state]
                    last_final = marker
                    last_final_pos = state_index

            if last_final is not None:
                if buffer:
                    # flush the `buffer` as a text token before the marker
                    tokens.append((None, buffer))
                    buffer = ''

                if last_final in cls.delimiters:
                    is_close = stacks.pop(last_final, None)
                    if is_close is None:
                        stacks[last_final] = len(tokens)

                index = last_final_pos
                tokens.append((last_final, last_final))

            else:
                index += 1
                buffer += char

        if buffer:
            tokens.append((None, buffer))

        # mark unclosed markers as text
        for marker, index in stacks.items():
            tokens[index] = (None, marker)

        return tokens

    @classmethod
    def parse(cls, text: str) -> t.Tuple[str, t.List[MessageEntity]]:
        stacks = {}
        entities = []
        raw_text = ''

        tokens = cls.tokenize(text)
        offset = 0
        token_id = 0

        while token_id < len(tokens):
            ignore = _PRE_CODE in stacks
            token_type, value = tokens[token_id]

            if token_type == TRIPLE_BACKTICK:
                entity_type, stack_offset, language = stacks.pop(_PRE_CODE, (None, None, None))

                if entity_type is None:
                    next_type, next_value = tokens[token_id + 1]
                    if next_type is None:
                        raw_lang, *remainder = next_value.split('\n', 1)

                        if remainder and not any(
                            e.isspace()
                            for e in raw_lang.rstrip()
                        ):

                            rest = ''.join(remainder)
                            language = raw_lang.strip()
                            offset += cls.utf16_len(rest)
                            raw_text += rest
                            token_id += 1

                    if language is None:
                        entity_type = MessageEntityType.Pre

                    else:
                        entity_type = MessageEntityType.PreCode

                    stacks[_PRE_CODE] = (entity_type, offset, language)
    
                else:
                    entities.append(
                        MessageEntity(
                            entity_type,
                            stack_offset,
                            offset - stack_offset,
                            data=language
                        )
                    )

            elif token_type == BRACKET_OPEN and not ignore:
                values = []

                for index, expect in enumerate(
                    [
                        None,
                        BRACKET_CLOSE,
                        PAREN_OPEN,
                        None,
                        PAREN_CLOSE
                    ],
                    start=1
                ):
                    if token_id + index >= len(tokens):
                        raw_text += token_type
                        break

                    next_type, next_value = tokens[token_id + index]

                    if next_type != expect:
                        raw_text += token_type
                        break

                    if next_type is None:
                        values.append(next_value)

                else:
                    text_value = values[0]
                    length = cls.utf16_len(text_value)
    
                    entities.append(
                        cls._handle_link(
                            values[1],
                            offset,
                            length
                        )
                    )

                    offset += length
                    raw_text += text_value
                    token_id += 5
    
            elif (
                (
                    token_type == GT
                    or (
                        token_type == NOT
                        and token_id + 1 < len(tokens)
                        and tokens[token_id + 1][0] == GT
                    )
                )
                and (
                    not raw_text
                    or raw_text[-1] == '\n'
                )
                and not ignore
            ):
                if token_type == NOT:
                    token_id += 1
                    entity_type = MessageEntityType.ExpandableBlockQuote

                else:
                    entity_type = MessageEntityType.BlockQuote

                stacks[_BLOCK_QUOTE] = (entity_type, offset)

            elif token_type in cls.delimiters and not ignore:                
                types = {
                    STAR: MessageEntityType.Bold,
                    TILDE: MessageEntityType.Strikethrough,
                    BACKTICK: MessageEntityType.Code,
                    UNDERSCORE: MessageEntityType.Italic,
                    DOUBLE_PIPE: MessageEntityType.Spoiler,
                    DOUBLE_UNDERSCORE: MessageEntityType.Underline
                }

                entity_type = types[token_type]
                stack_offset = stacks.pop(entity_type, None)

                if stack_offset is None:
                    stacks[entity_type] = offset
    
                else:
                    length = offset - stack_offset
                    entities.append(
                        MessageEntity(
                            entity_type,
                            stack_offset,
                            length
                        )
                    )

            else:
                offset += cls.utf16_len(value)
                raw_text += value

                if (
                    (
                        value.endswith('\n')
                        or
                        token_id + 1 >= len(tokens)
                    )
                    and _BLOCK_QUOTE in stacks
                ):
                    entity_type, stack_offset = stacks.pop(_BLOCK_QUOTE)

                    entities.append(
                        MessageEntity(
                            entity_type,
                            stack_offset,
                            offset - stack_offset
                        )
                    )

            token_id += 1

            # ensure open blockquote is closed at the end
            if (
                token_id >= len(tokens)
                and _BLOCK_QUOTE in stacks
            ):
                tokens.append((None, '')) 

        return cls._trim_entities(raw_text, entities)

def parse_markdown(text: str):
    """
    parses `markdown-formatted` message and returns its `plain-text` representation
    along with a list of message entities.
    """
    return Markdown.parse(text)
