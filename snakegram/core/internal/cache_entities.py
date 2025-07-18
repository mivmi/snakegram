import typing as t

from ...tl import types # type: ignore
from ... import helpers, models, enums
from ...gadgets.utils import env, Cache

if t.TYPE_CHECKING:
    from ...session.abstract import AbstractSession


MAX_CACHE_ENTITY_SIZE = env('MAX_CACHE_ENTITY_SIZE', 200, int)
ENTITY_CACHE_EVICTION_POLICY = env('ENTITY_CACHE_EVICTION_POLICY', 'LRU', str)


class CacheEntities(Cache):
    def __init__(self, session: 'AbstractSession'):
        self.session = session

        super().__init__(
            MAX_CACHE_ENTITY_SIZE,
            eviction_policy=ENTITY_CACHE_EVICTION_POLICY
        )

    def pop(self, key, save: bool = True):
        value = super().pop(key)

        if save and isinstance(value, models.Entity):
            self.session.upsert_entity(value)

        return value

    def get(self, id: int) -> models.Entity:
        result =  super().get(id)

        if result is None:
            result = self.session.get_entity(id=id)

            if result is not None:
                self.add_or_update(result.id, result)

        return result

    def add_users(self, *users: types.TypeUser):
        for user in users:
            if isinstance(user, types.UserEmpty):
                self.pop(user.id, save=False)
                continue

            if user.access_hash and not user.min:
                name = helpers.get_display_name(user)
                user_type = (
                    enums.EntityType.BOT 
                    if user.bot else
                    enums.EntityType.USER
                )
        
                value = models.Entity(
                    user.id,
                    user_type,
                    user.access_hash,
                    name=name,
                    is_self=user.is_self,
                    username=user.username,
                    phone_number=user.phone
                )

                self.add_or_update(user.id, value, check=False)
        
        self.check()

    def add_chats(self, *chats: types.TypeChat):
        for chat in chats:
            if isinstance(
                chat,
                (
                    types.ChatForbidden,
                    types.ChannelForbidden
                )
            ):
                self.pop(chat.id, save=False)
                continue

            is_min = getattr(chat, 'min', None)
            access_hash = getattr(chat, 'access_hash', None)

            if access_hash and not is_min:
                name = helpers.get_display_name(chat)
                chat_type = (
                    enums.EntityType.MEGAGROUP
                    if chat.megagroup else (
                        enums.EntityType.GIGAGROUP
                        if getattr(chat, 'gigagroup', None) else 
                        enums.EntityType.CHANNEL
                    )
                )

                value = models.Entity(
                    chat.id,
                    chat_type,
                    chat.access_hash,
                    name=name             
                )

                self.add_or_update(chat.id, value, check=False)

        self.check()
