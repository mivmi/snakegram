import re
import typing as t

from ...models import MessageEntity
from ...enums import MessageEntityType


class BaseParser:
    # https://core.telegram.org/api/entities#entity-length
    @staticmethod
    def utf16_len(text: str) -> int:
        return len(text.encode('utf-16-le')) // 2

    @classmethod
    def _trim_entities(cls, text: str, entities: t.List[MessageEntity]):
        stripped = text.lstrip()
        
        if text != stripped:
            trim_len = len(text) - len(stripped)
            
            for entity in entities:
                entity.offset -= trim_len

            text = stripped
        
        stripped = text.rstrip()
        
        if text != stripped:
            length = cls.utf16_len(stripped)
            trim_len = cls.utf16_len(text) - length
            
            new_entities = []
            for entity in entities:
                end = entity.offset + entity.length
                
                if end > length:
                    entity.length = max(0, length - entity.offset)

                if entity.length > 0:
                    new_entities.append(entity)

            text = stripped
            entities = new_entities
    
        return text, sorted(entities, key=lambda e: e.offset)

    @staticmethod
    def _handle_link(url: str, offset: int, length: int):
        if not url:
            return None

        emoji_match = re.match(r'^(?:emoji:|tg://emoji\?id=)(\d+)$', url)

        if emoji_match:
            return MessageEntity(
                MessageEntityType.CustomEmoji,
                offset,
                length,
                custom_emoji_id=int(emoji_match.group(1))
            )

        mention_match = re.match(r'^(?:mention:|tg://user\?id=)(\d+)', url)
        if mention_match:
            return MessageEntity(
                MessageEntityType.MentionName,
                offset,
                length,
                user_id=int(mention_match.group(1))
            )
        
        return MessageEntity(
            MessageEntityType.TextUrl,
            offset,
            length,
            data=url
        )
