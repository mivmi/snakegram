import re
from html.parser import HTMLParser
from snakegram.enums import MessageEntityType
from snakegram.models import MessageEntity
from snakegram.gadgets.parser.base import BaseParser


class Html(HTMLParser, BaseParser):
    tags = {
        'pre': MessageEntityType.Pre,
        'code': MessageEntityType.Code, # or PreCode 
        'tg-emoji': MessageEntityType.CustomEmoji,
        'tg-spoiler': MessageEntityType.Spoiler,
        'blockquote': MessageEntityType.BlockQuote,

        # bold
        'b': MessageEntityType.Bold,
        'strong': MessageEntityType.Bold,

        # italic
        'i': MessageEntityType.Italic,
        'em': MessageEntityType.Italic,

        # underline
        'u': MessageEntityType.Underline,
        'ins': MessageEntityType.Underline,

        # strikethrough
        's': MessageEntityType.Strikethrough,
        'del': MessageEntityType.Strikethrough,
        'strike': MessageEntityType.Strikethrough
    }

    def __init__(self, *, convert_charrefs = True):
        self._tokens = []
        super().__init__(convert_charrefs=convert_charrefs)

    def handle_data(self, data):
        self._tokens.append((None, data))
    
    def handle_endtag(self, tag):
        self._tokens.append((2, tag))
    
    def handle_starttag(self, tag, attrs):
        self._tokens.append((1, (tag, dict(attrs))))

    @classmethod
    def tokenize(cls, text: str):
        lexer = cls()
        lexer.feed(text)
        return lexer._tokens

    @classmethod
    def parse(cls, text: str):
        stacks = {}
        entities = []

        offset = 0
        raw_text = ''

        tokens = cls.tokenize(text)
        token_id = 0

        while token_id < len(tokens):
            token_type, value = tokens[token_id]
            
            if token_type == 1: # start tag
                tagname, attrs = value

                if tagname not in stacks:
                    stacks[tagname] = []

                stacks[tagname].append((offset, attrs))

            elif token_type == 2: # close tag
                tagname = value

                try:
                    stack_offset, attrs = stacks[tagname].pop()

                except (KeyError, IndexError):
                    token_id += 1
                    continue

                else:
                    data = None
                    entity = None
                    entity_type = None

                    if tagname == 'a':
                        entity = cls._handle_link(
                            attrs.get('href'),
                            stack_offset,
                            length=offset - stack_offset
                        )

                    elif (
                        tagname == 'span'
                        and
                        attrs.get('class') == 'tg-spoiler'
                    ):
                        entity_type = MessageEntityType.Spoiler
                    
                    else:
                        entity_type = cls.tags.get(tagname)
                    
                    if entity_type:
                        custom_emoji_id = None
                        
                        if (
                            stacks.get('pre')
                            and entity_type is MessageEntityType.Code
                        ):
                            language = attrs.get('class')
                            if language is not None:
                                result = re.match(
                                    r'^language\-(\S+)$',
                                    language,
                                    re.IGNORECASE
                                )

                                if result is not None:
                                    data = result.group(1)

                            if (
                                data is not None
                                and token_id + 1 < len(tokens)
                            ):
                                index, next_type, next_value = next(
                                    (
                                        (index, *token)
                                        for index, token in enumerate(
                                            tokens[token_id + 1:],
                                            start=1
                                        )
                                        if token[0] is not None # not text
                                    ),
                                    (None, None, None)
                                    
                                )

                                if next_type == 2 or next_value == 'pre': # </pre>
                                    stacks['pre'].pop()
                                    del tokens[token_id + index]
                                    entity_type = MessageEntityType.PreCode

                            if (
                                data
                                and entity_type is not MessageEntityType.PreCode
                            ):
                                data = None
    
    
                        if entity_type is MessageEntityType.BlockQuote:
                            if 'expandable' in attrs:
                                entity_type = MessageEntityType.ExpandableBlockQuote

                        if entity_type is MessageEntityType.CustomEmoji:
                            custom_emoji_id = attrs.get('emoji-id')
    
                            if (
                                custom_emoji_id is None
                                or not custom_emoji_id.isdigit()
                            ):
                                token_id += 1
                                continue
                            
                            custom_emoji_id = int(custom_emoji_id)

                        if entity_type is not None:
                            entity = MessageEntity(
                                entity_type,
                                stack_offset,
                                offset - stack_offset,
                                data=data,
                                custom_emoji_id=custom_emoji_id
                            )

                    if entity and entity.length > 0:
                        entities.append(entity)

            else:
                if value:
                    offset += cls.utf16_len(value)
                    raw_text += value

            token_id += 1

        return cls._trim_entities(raw_text, entities)


def parse_html(text: str):
    """
    parses `html-formatted` message and returns its `plain-text` representation
    along with a list of message entities.
    """
    return Html.parse(text)
