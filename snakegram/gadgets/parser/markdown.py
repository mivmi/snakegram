import typing as t

from .base import BaseParser
from ...enums import MessageEntityType
from ...models import MessageEntity

# https://www.geeksforgeeks.org/introduction-to-directed-acyclic-graph/
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
        '>',         # > blockquote
        '!>',        # collapsed blockquote
        '[', ']',
        '(', ')'
    ]
    delimiters = ['*', '_', '`', '~', '__', '||', '```']
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

                    # check if `blockquote` markers (">", "!>") appear at the start of line
                    if marker in ('>', '!>') and not (
                        index == 0
                        or text[index - 1] == '\n'
                    ):
                        break

                    last_final = marker
                    last_final_pos = state_index

            if last_final is not None:
                if buffer:
                    # flush the `buffer` as a plain text token before the marker
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
            entity = None
            token_type, value = tokens[token_id]
            ignore_token = (
                token_type != '```'
                and '```' in stacks
            )

            if token_type == '[' and not ignore_token:
                values = []
        
                for index, expect in enumerate(
                    [None, ']', '(', None, ')'], # [text](url)
                    start=1 # skip [
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
                    text = values[0]
                    length = cls.utf16_len(text)
                    entity = cls._build_entity(
                        'url',
                        offset,
                        length,
                        values[1]
                    )

                    offset += length
                    raw_text += text
                    token_id += 5

            elif token_type in ('>', '!>') and not ignore_token:
                buffer = ''

                while token_id + 1 < len(tokens):
                    if tokens[token_id][0] != token_type:
                        token_id -= 1
                        break

                    next_type, next_value = tokens[token_id + 1]
                    if next_type is not None:
                        break

                    buffer += next_value
                    token_id += 2

                if buffer:
                    length = cls.utf16_len(buffer)
                    entity = cls._build_entity(
                        token_type,
                        offset,
                        length
                    )

                    offset += length
                    raw_text += buffer

            elif token_type in cls.delimiters and not ignore_token:
                stack_offset, arguemnt = stacks.pop(token_type, (None, None))

                if stack_offset is None:
                    if token_type == '```':
                        next_type, next_value = tokens[token_id + 1]

                        if next_type is None:
                            lang_code, *remainder = next_value.split('\n', 1)

                            if remainder and not any(
                                e.isspace()
                                for e in lang_code.rstrip()
                            ):
                                rest = ''.join(remainder)
                                arguemnt = lang_code.strip()

                                offset += cls.utf16_len(rest)
                                raw_text += rest
                                token_id += 1

                    stacks[token_type] = (offset, arguemnt)

                else:
                    length = offset - stack_offset
                    entity = cls._build_entity(
                        token_type,
                        stack_offset,
                        length,
                        arguemnt
                    )

            else:
                offset += cls.utf16_len(value)
                raw_text += value

            token_id += 1
            if entity is not None:
                entities.append(entity)

        return raw_text, entities

    @classmethod
    def _build_entity(
        cls,
        entity: str,
        offset: int,
        length: int,
        arguemnt: t.Optional[str] = None
    ):
        types_map = {
            '*': MessageEntityType.Bold,
            '_': MessageEntityType.Italic,
            '`': MessageEntityType.Code,
            '~': MessageEntityType.Strikethrough,
            '__': MessageEntityType.Underline,
            '||': MessageEntityType.Spoiler
        }

        entity_type = types_map.get(entity)
        if entity_type is not None:
            return MessageEntity(
                entity_type,
                offset=offset,
                length=length
            )

        if entity == '```':
            entity_type = (
                MessageEntityType.PreCode
                if arguemnt else
                MessageEntityType.Pre
            )

            return MessageEntity(
                entity_type,
                offset=offset,
                length=length,
                lang_code=arguemnt
            )

        if entity in ('>', '!>'):
            return MessageEntity(
                MessageEntityType.BlockQuote,
                offset=offset,
                length=length,
                collapsed=(entity == '!>')
            )

        if arguemnt and entity == 'url':
            return cls._handle_link(arguemnt, offset, length)


def parse_markdown(text: str):
    """
    parses `markdown-formatted` message and returns its `plain-text` representation
    along with a list of message entities.
    """
    return Markdown.parse(text)
