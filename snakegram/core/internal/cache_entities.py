import typing as t

from ...tl import types # type: ignore
from ... import helpers, models, alias
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

        if save and isinstance(
            value,
            (
                models.UserEntity,
                models.ChannelEntity
            )
        ):
            self.session.upsert_entity(value)

        return value

    def get(self, peer_id: int) -> t.Optional[alias.StoredEntityType]:
        result =  super().get(peer_id)

        if result is None:
            result = self.session.get_entity(id=peer_id)

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
                value = models.UserEntity(
                    user.id,
                    user.access_hash,
                    name,
                    user.bot,
                    user.is_self,
                    phone=user.phone,
                    username=helpers.get_active_username(user)
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

            is_min: bool = getattr(chat, 'min', False)
            access_hash: t.Optional[int] = getattr(chat, 'access_hash', None)

            if access_hash and not is_min:
                value = models.ChannelEntity(
                    chat.id,
                    access_hash,
                    helpers.get_display_name(chat),
                    username=helpers.get_active_username(chat)
                )

                self.add_or_update(chat.id, value, check=False)

        self.check()
