import logging
import typing as t

from ... import errors, alias, helpers
from ...tl import types, functions
from ...gadgets.utils import split_list, is_like_list

if t.TYPE_CHECKING:
    from ..telegram import Telegram

logger = logging.getLogger(__name__)

EntityType: t.TypeAlias = t.Union[types.TypeUser, types.TypeChat]
FullEntityType: t.TypeAlias = t.Union[
    types.users.TypeUsersUserFull,
    types.messages.TypeMessagesChatFull
]

class Common:
    async def get_me(self: 'Telegram') -> t.Optional[types.User]:
        """
        Gets the currently logged-in user or bot, or `None` if not authenticated.

        Returns:
            Optional[types.User]: The current user or bot, or `None`.

        Example:
        ```python
        me = await client.get_me()
        if me:
            print(f"You're logged in as {helper.get_display_name(me)!r}")
        else:
            print("You're not logged in")
        """

        try:
            result = await self.get_entity('me')

        except errors.UnauthorizedError:
            self._authorized = False

        else:        
            self._authorized = True
            return result

    # get entity
    if t.TYPE_CHECKING:
        @t.overload
        async def get_entity(
            self: 'Telegram',
            targets: alias.LikeEntity,
            *,
            full: t.Literal[False] = False
        ) -> EntityType: ...

        @t.overload
        async def get_entity(
            self: 'Telegram',
            targets: alias.LikeEntity,
            *,
            full: t.Literal[True]
        ) -> FullEntityType: ...

        @t.overload
        async def get_entity(
            self: 'Telegram',
            targets: t.List[alias.LikeEntity],
            *,
            full: t.Literal[False] = False,
            limit_per_request: int = 200,
        ) -> t.List[EntityType]: ...

        @t.overload
        async def get_entity(
            self: 'Telegram',
            targets: t.List[alias.LikeEntity],
            *,
            full: t.Literal[True]
        ) -> t.List[FullEntityType]: ...

    async def get_entity(
        self: 'Telegram',
        targets: t.Union[alias.LikeEntity, t.List[alias.LikeEntity]],
        *,
        full: bool = False,
        limit_per_request: int = 200
    ) -> t.Union[
        EntityType,
        FullEntityType,
        t.List[EntityType],
        t.List[FullEntityType]
    ]:
        """
        Fetch info about one or multiple entities.
    
        Args:
            targets (`EntityLike` | `List[EntityLike]`):
                The entity or list of entities to fetch.

            full (bool, optional):
                Whether to fetch full information for the entities. Defaults to False.


            limit_per_request (int, optional):
                Maximum number of entities per API request. Defaults to 200.
                ignored when `full` is True, as each entity requires a separate request.
        
        Returns:
            `EntityType` or `FullEntityType` or list of them, depending on `full` flags

        Example:
        ```python
        me = await self.get_entity("me")
        print(f"You're logged in as {helper.get_display_name(me)!r}")

        users = await client.get_entity(["user1", "user2"], full=True)
        print(users)
        ```
        """
        is_single = not is_like_list(targets)
        if is_single:
            targets = [targets]

        results = {}
        grouped ={}

        for idx, target in enumerate(targets):
            entity = None
            cache_entity = self.get_cache_entity(target)

            if cache_entity is None:
                if isinstance(target, str):
                    # remove username perfix
                    username = helpers.parse_username(target)
                    if username is None:
                        raise ValueError(f'username is invalid or empty: {target!r}')

                    result = await self(
                        functions.contacts.ResolveUsername(username)
                    )
                    self._entities.add_users(*result.users)
                    self._entities.add_chats(*result.chats)

                    peer_id = helpers.get_peer_id(result.peer)
                    for item in (
                        result.users
                        if isinstance(result.peer, types.PeerUser) else
                        result.chats
                    ):
                        if item.id == peer_id:
                            if not full:
                                results[idx] = item

                            else:
                                entity = helpers.cast_to_input_peer(item)

                            break

            else:
                entity = cache_entity.to_input_peer()

            if isinstance(entity, types.InputPeerUser):
                item = helpers.cast_to_input_user(entity)
                entity_type = 'user'

            elif isinstance(entity, types.InputPeerChat):
                item = entity.chat_id
                entity_type = 'chat'

            elif isinstance(entity, types.InputPeerChannel):
                item = helpers.cast_to_input_channel(entity)
                entity_type = 'channel'

            else:
                if idx in results:
                    continue

                raise ValueError(f'Could not resolve entity: {target!r}')  

            if entity_type not in grouped:
                grouped[entity_type] = []

            grouped[entity_type].append((idx, item))

        if full:
            for entity_type, entities in grouped.items():
                for idx, entity in entities:
                    if entity_type == 'user':
                        request = functions.users.GetFullUser(entity)
                        
                    elif entity_type == 'chat':
                        request = functions.messages.GetFullChat(entity)

                    else:
                        request = functions.channels.GetFullChannel(entity)

                    results[idx] = await self(request) 
        
        else:
            for entity_type, entities in grouped.items():
                for chunk in split_list(entities, limit_per_request):
                    indices, inputs = zip(*chunk)
                    
                    if entity_type == 'user':
                        result = await self(functions.users.GetUsers(inputs))
        
                    elif entity_type == 'chat':
                        result = (
                            await self(
                                functions.messages.GetChats(inputs)
                            )
                        ).chats
    
                    else:
                        result = (
                            await self(
                                functions.channels.GetChannels(inputs)
                            )
                        ).chats
                    
                    for idx, entity in zip(indices, result):
                        results[idx] = entity 

        ordered = [results[i] for i in sorted(results)]
        return ordered[0] if is_single else ordered

    def get_cache_entity(self: 'Telegram', entity: alias.LikeEntity):
        if isinstance(entity, int):
            return self._entities.get(entity)

        peer_id = helpers.get_peer_id(
            entity,
            raise_error=False
        )

        if peer_id is not None:
            return self._entities.get(peer_id)

        input_peer = helpers.cast_to_input_peer(
            entity,
            raise_error=False
        )
        if isinstance(input_peer, types.InputPeerSelf):
            return self.session.me

        # if entity is `str`, try parsing it as `username` or `phone_number`
        if isinstance(entity, str):
            username = helpers.parse_username(entity)
            if username:
                _entity = self.session.get_entity(username=username)

                if _entity is not None:
                    return _entity

            phone_number = helpers.parse_phone_number(entity)
            if phone_number:
                return self.session.get_entity(phone_number=phone_number)
