import typing as t

from ... import errors, alias, helpers
from ...tl import types, functions
from ...models import _local_event as event
from ...gadgets.utils import split_list, is_like_list

if t.TYPE_CHECKING:
    from ..telegram import Telegram


EntityType = t.Union[types.TypeUser, types.TypeChat]
FullEntityType = t.Union[
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

    async def is_bot(self: 'Telegram', entity: alias.LikeEntity = 'me'):
        """
        Checks if the given entity is bot or user.

        Args:
            entity (`LikeEntity`): The target entity to check. Defaults to `'me'`.

        Returns:
            bool: True if the entity is a bot, False otherwise.

        Example:
        ```python
        if await client.is_bot():
            print("Logged in as a bot")
        else:
            print("Logged in as a user")
        ```
        """

        # try to resolve quickly
        result = await self.get_entity(entity)
        return isinstance(result, types.User) and result.bot

    # get entity
    if t.TYPE_CHECKING:
        @t.overload
        async def get_entity(
            self: 'Telegram',
            targets: alias.LikeEntity,
            *,
            full: t.Literal[False] = False,
            force_request: bool = False
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
            force_request: bool = False,
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
        force_request: bool = False,
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
            targets (`LikeEntity` | `List[LikeEntity]`):
                The entity or list of entities to fetch.

            full (bool, optional):
                Whether to fetch full information for the entities. Defaults to False.

            force_request (bool):
                If True, forces a fresh request even if cached data is available. 
                Defaults to False.

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
            input_peer = None
            cache_entity = self.get_cache_entity(target)

            if cache_entity is None:
                input_peer = helpers.cast_to_input_peer(
                    target,
                    raise_error=False
                )

                if input_peer is None and isinstance(target, str):
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
                                input_peer = helpers.cast_to_input_peer(item)

                            break
            else:
                input_peer = cache_entity.to_input_peer()

            # if `get_entity` is called while handling an update, the required data
            # might already be included in the update
            # we cache this data in `_prepare_updates`, so we can avoid making
            # an extra request by using the cached version instead.
            # this only applies when `full` is False and `force_request` is not set.
            is_user = isinstance(
                input_peer,
                (
                    types.InputPeerSelf,
                    types.InputPeerUser,
                    types.InputPeerUserFromMessage
                )
            )

            if (
                event.is_update
                and (
                    input_peer is None
                    or (not full and not force_request)
                )
            ):
                peer_id = helpers.get_peer_id(
                    input_peer or target,
                    raise_error=False
                )

                if peer_id is not None:
                    if is_user:
                        value = next(
                            (
                                u
                                for u in getattr(event.update, '_users', [])
                                if peer_id == helpers.get_peer_id(u, raise_error=False)
                            ),
                            None
                        )
                    else:
                        value = next(
                            (
                                c
                                for c in getattr(event.update, '_chats', [])
                                if peer_id == helpers.get_peer_id(c, raise_error=False)
                            ),
                            None
                        )

                    if value is not None:
                        if not full and not force_request:
                            results[idx] = value
                            continue

                        if input_peer is None:
                            input_peer = helpers.cast_to_input_peer(value)
                    
            if is_user:
                item = helpers.cast_to_input_user(input_peer)
                entity_type = 'user'

            elif isinstance(input_peer, types.InputPeerChat):
                item = input_peer.chat_id
                entity_type = 'chat'

            elif isinstance(
                input_peer,
                (
                    types.InputPeerChannel,
                    types.InputPeerChannelFromMessage
                )
            ):
                item = helpers.cast_to_input_channel(input_peer)
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
                    
                    results[idx] = result = await self(request)

                    self._entities.add_users(*result.users)
                    self._entities.add_chats(*result.chats)

        else:
            for entity_type, entities in grouped.items():
                for chunk in split_list(entities, limit_per_request):
                    indices, inputs = zip(*chunk)

                    if entity_type == 'user':
                        result = await self(functions.users.GetUsers(inputs))
                        self._entities.add_users(*result)

                    else:
                        if entity_type == 'chat':
                            result = await self(
                                functions.messages.GetChats(inputs)
                            )

                        else:
                            result = await self(
                                functions.channels.GetChannels(inputs)
                            )

                        result = result.chats
                        self._entities.add_chats(*result)

                    for idx, entity in zip(indices, result):
                        results[idx] = entity 

        ordered = [results[i] for i in sorted(results)]
        return ordered[0] if is_single else ordered

    #
    async def get_input_peer(self: 'Telegram', entity: alias.LikeEntity) -> types.TypeInputPeer:
        input_peer = helpers.cast_to_input_peer(
            entity,
            raise_error=False
        )

        if input_peer is not None:
            return input_peer

        cache_entity = self.get_cache_entity(entity)
        if cache_entity is not None:
            return cache_entity.to_input_peer()

        result = await self.get_entity(entity)
        return helpers.cast_to_input_peer(result, raise_error=False)

    # sync
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

            phone = helpers.parse_phone_number(entity)
            if phone:
                return self.session.get_entity(phone=phone)
