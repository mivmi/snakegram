import re
from ...models import MessageEntity
from ...enums import MessageEntityType


class BaseParser:
    # https://core.telegram.org/api/entities#entity-length
    @staticmethod
    def utf16_len(text: str) -> int:
        return len(text.encode('utf-16-le')) // 2

    @staticmethod
    def _handle_link(url: str, offset: int, length: int):
        emoji_match = re.match(r'^(?:emoji:|tg://emoji\?id=)(\d+)$', url)

        if emoji_match:
            return MessageEntity(
                MessageEntityType.CustomEmoji,
                offset=offset,
                length=length,
                custom_emoji_id=int(emoji_match.group(1))
            )

        mention_match = re.match(r'^(?:mention:|tg://user\?id=)(\d+)', url)
        if mention_match:
            return MessageEntity(
                MessageEntityType.MentionName,
                offset=offset,
                length=length,
                user_id=int(mention_match.group(1))
            )
        
        return MessageEntity(
            MessageEntityType.Url,
            offset=offset,
            length=length,
            url=url
        )
