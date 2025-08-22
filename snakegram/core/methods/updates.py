import time
import logging
import typing as t

from ..internal import UpdateState
from ...enums import EventType
from ... import alias, models, errors, helpers
from ...tl import types, functions
from ...gadgets.utils import env

if t.TYPE_CHECKING:
    from ..telegram import Telegram

T = t.TypeVar('T')
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)


# https://core.telegram.org/api/updates
PTS_LIMIT = env('PTS_LIMIT', 1000, int)
PTS_TOTAL_LIMIT = env('PTS_TOTAL_LIMIT', 100_000, int)
MAX_CHANNEL_POLLING = env('MAX_CHANNEL_POLLING', 10, int)


class Updates:
    _update_states: t.Dict[models.StateId, UpdateState]

    async def _prepare_updates(
        self: 'Telegram',
        updates: t.Union[types.updates.Updates, types.updates.UpdatesCombined]
    ):
        for update in updates.updates:
            update._chats = updates.chats
            update._users = updates.users

        for item in updates.chats:
            if isinstance(
                item,
                (
                    types.Channel,
                    types.ChannelForbidden
                )
            ):
                state_id = models.StateId(item.id)
                update_state = self._update_states.get(state_id)

                if update_state is None:
                    continue

                if isinstance(item, types.ChannelForbidden):
                    # channel is no longer accessible, stop timers and remove state
                    logger.info(f'channel {item.id} is forbidden: removing state')
                    await self._delete_update_state(update_state)
                    continue
    
                if not item.left:
                    if update_state in self._channel_polling:
                        # user is a member of the channel, no need to poll for updates
                        logger.info(f'user is member of channel {item.id}: stopping polling')
                        await self.remove_channel_polling(item.id)
                    
                else:
                    # user has left the channel, stop polling if it was enabled
                    if update_state not in self._channel_polling:
                        logger.info(f'user has left channel {item.id}: clearing state')
                        await self._delete_update_state(update_state)

        self._entities.add_users(*updates.users)
        self._entities.add_chats(*updates.chats)

        return updates

    async def _process_update(
        self: 'Telegram',
        update: types.update.TypeUpdate
    ):
        if isinstance(update, types.update.UpdateChannelTooLong):
            channel_id = helpers.get_update_channel_id(update)

            await self._fetch_channel_difference(
                self._get_update_state(channel_id)
            )

        coro = self._main_router(EventType.Update, update)
        self._create_new_task(coro)

    #
    async def _updates_dispatcher(
        self: 'Telegram',
        update: types.updates.TypeUpdates
    ):
        try:
            if isinstance(update,
                (
                    types.updates.Updates,
                    types.updates.UpdatesCombined
                )
            ):
                update = await self._prepare_updates(update)
                await self._handle_seq_updates(update)

            elif isinstance(update, types.updates.UpdateShort):
                await self._handle_single_update(update.update)

            elif isinstance(update, types.updates.UpdatesTooLong):
                await self._handle_updates_too_long()
            
            elif isinstance(update, (
                    types.updates.UpdateShortMessage,
                    types.updates.UpdateShortChatMessage,
                    types.updates.UpdateShortSentMessage
                )
            ):
                await self._handle_short_update(update)
            
            else:
                await self._handle_single_update(update)

        except Exception:
            logger.exception(f'Failed to process update due to unexpected error: {update}')

    #
    async def _handle_pts_update(self: 'Telegram', update):
        channel_id = helpers.get_update_channel_id(update)
        update_state = self._get_update_state(channel_id)
        
        pts = update.pts
        local_pts = update_state.state_info.pts
        pts_count: int = getattr(update, 'pts_count', 0)
    
        logger.debug(
            'Processing pts update: '
            f'pts={pts}, pts_count={pts_count}, local_pts={local_pts}'
        )

        if local_pts == 0 or local_pts + pts_count == pts:

            update_state.state_info.pts = pts
            await update_state.process_update(update)
            await self._process_update(update)

        elif local_pts + pts_count > pts:
            logger.info(
                'the update was already applied: '
                f'pts={pts}, pts_count={pts_count}, local_pts={local_pts}'
            )
            await update_state.process_update(update)
            return

        elif local_pts + pts_count < pts:
            logger.debug(
                'gap detected: '
                f'pts={pts}, pts_count={pts_count}, local_pts={local_pts}'
            )
            
            await update_state.add(update)

    async def _handle_qts_update(self: 'Telegram', update):
        update_state = self._get_update_state()
        
        qts = update.qts
        local_qts = update_state.state_info.qts
    
        logger.debug(
            'Processing qts update: '
            f'qts={qts}, local_qts={local_qts}'
        )

        if local_qts == 0 or local_qts + 1 == qts:

            update_state.state_info.qts = qts
            await update_state.process_update(update)
            await self._process_update(update)

        elif local_qts + 1 > qts:
            logger.info(
                'the update was already applied: '
                f'qts={qts}, local_qts={local_qts}'
            )
            await update_state.process_update(update)
            return

        elif local_qts + 1 < qts:
            logger.debug(
                'gap detected: '
                f'qts={qts}, local_qts={local_qts}'
            )

            await update_state.add(update)

    async def _handle_seq_updates(self: 'Telegram', update):
        update_state = self._get_update_state()
    
        seq = update.seq
        local_seq = update_state.state_info.seq
        seq_start = getattr(update, 'seq_start', seq)

        logger.debug(
            'Processing seq update: '
            f'local_seq={local_seq}, seq_start={seq_start}, seq={seq}'
        )

        if seq_start == 0 or local_seq + 1 == seq_start:
            for single_update in update.updates:
                await self._handle_single_update(single_update)

            if seq != 0:
                update_state.state_info.seq = seq
                update_state.state_info.date = update.date
                logger.debug(f'Updated seq to {seq}, date to {update.date}')

        elif local_seq + 1 > seq_start:
            logger.info(
                'the update was already applied: '
                f'local_seq={local_seq}, seq_start={seq_start}'
            )
            return

        elif local_seq + 1 < seq_start:
            logger.debug(
                'gap detected: '
                f'local_seq={local_seq}, seq={seq} seq_start={seq_start}'
            )
            await self._fetch_difference(update_state)

    async def _handle_short_update(self: 'Telegram', update):
        if isinstance(update, types.updates.UpdateShortMessage):
            from_id = helpers.cast_to_peer(
                await self.get_input_peer(
                    'me' if update.out else update.user_id
                ),
                raise_error=False
            )

            transformed = types.UpdateNewMessage(
                message=types.Message(
                    id=update.id,
                    peer_id=types.PeerUser(update.user_id),
                    from_id=from_id,
                    message=update.message,
                    out=update.out,
                    mentioned=update.mentioned,
                    media_unread=update.media_unread,
                    silent=update.silent,   
                    date=update.date,
                    fwd_from=update.fwd_from,
                    via_bot_id=update.via_bot_id,
                    reply_to=update.reply_to,
                    entities=update.entities,
                    ttl_period=update.ttl_period
                ),
                pts=update.pts,
                pts_count=update.pts_count
            )
        
        elif isinstance(update, types.updates.UpdateShortChatMessage):
            transformed = types.UpdateNewMessage(
                message=types.Message(
                    id=update.id,
                    peer_id=types.PeerChat(update.chat_id),
                    from_id=types.PeerUser(update.from_id),
                    message=update.message,
                    out=update.out,
                    mentioned=update.mentioned,
                    media_unread=update.media_unread,
                    silent=update.silent,
                        
                    date=update.date,
                    fwd_from=update.fwd_from,
                    via_bot_id=update.via_bot_id,
                    reply_to=update.reply_to,
                    entities=update.entities,
                    ttl_period=update.ttl_period
                ),
                pts=update.pts,
                pts_count=update.pts_count
            )
        
        elif isinstance(update, types.updates.UpdateShortSentMessage):
            update_state = self._get_update_state()
            await self._fetch_difference(update_state)
            return

        else:
            logger.warning(f'Unexpected short update type: {update}')
            return 

        await self._handle_single_update(transformed)

    async def _handle_single_update(self: 'Telegram', update):
        try:
            if getattr(update, 'pts', None):
                await self._handle_pts_update(update)

            elif getattr(update, 'qts', None):
                await self._handle_qts_update(update)

            else:
                await self._process_update(update)

        except Exception:
            logger.exception(f'Failed to process update due to unexpected error: {update}')
    
    async def _handle_updates_too_long(self: 'Telegram'):
        logger.info('update too long: get current state')

        try:
            state = await self(functions.updates.GetState())
            update_state = self._get_update_state()

            if update_state.state_info.pts > 0 and not self.drop_update:
                await self._fetch_difference(update_state)

            update_state.state_info.pts = state.pts
            update_state.state_info.qts = state.qts
            update_state.state_info.seq = state.seq
            update_state.state_info.date = state.date
        
        except errors.AuthKeyUnregisteredError:
            logger.debug(
                'GetState failed: client is not authorized (auth key unregistered)'
            )
            self._authorized = False

    #
    async def _fetch_difference(self: 'Telegram', update_state: UpdateState):
        state_info = update_state.state_info
        try:
            logger.debug(
                'fetching difference: '
                f'pts={state_info.pts}, qts={state_info.qts}, '
                f'seq={state_info.seq}, date={state_info.date}'
            )
            if state_info.pts <= 0:
                logger.debug(
                    'Skipping difference fetch: '
                    f'invalid pts={state_info.pts}, likely no prior state available'
                )
                return 

            async with update_state:
                while True:
                    result = await self(
                        functions.updates.GetDifference(
                            pts=state_info.pts,
                            qts=state_info.qts,
                            date=state_info.date,
                            pts_limit=PTS_LIMIT,
                            pts_total_limit=PTS_TOTAL_LIMIT
                        )
                    )
                    if isinstance(result, types.updates.DifferenceEmpty):
                        state_info.seq = result.seq
                        state_info.date = result.date
                        logger.debug(
                            'difference empty: '
                            f'updated seq={result.seq}, date={result.date}'
                        )
                        break

                    elif isinstance(result, types.updates.DifferenceTooLong):
                        state_info.pts = result.pts
                        
                        logger.debug(f'difference too long: pts={result.pts}')
                        break
        
                    if isinstance(result, types.updates.Difference):
                        state = result.state

                    else:
                        state = result.intermediate_state

                    updates = result.other_updates
                    for message in result.new_messages:
                        new_message = types.update.UpdateNewMessage(
                            message,
                            pts=state.pts,
                            pts_count=0
                        )
                        updates.append(new_message)
                    
                    for qts, message in enumerate(
                        result.new_encrypted_messages,
                        start=(state_info.qts or 1) - 1
                    ):
                        new_message = types.update.UpdateNewEncryptedMessage(
                            message,
                            qts=qts
                        )
                        updates.append(new_message)
                    
                    update = types.updates.Updates(
                        updates,
                        result.users,
                        result.chats,
                        date=0,
                        seq=0
                    )
                                        
                    state_info.pts = state.pts
                    state_info.seq = state.seq
                    state_info.date = state.date
                    await self._updates_dispatcher(update)

                    if isinstance(result, types.updates.DifferenceSlice):
                        logger.debug('difference slice: fetching more differences')
                        continue

                    break

        finally:
            logger.debug(
                'difference fetching done:'
                f'pts={state_info.pts}, qts={state_info.qts}, '
                f'seq={state_info.seq}, date={state_info.date}'
            )

            self._save_state(state_info)

    async def _fetch_channel_difference(
        self: 'Telegram',
        update_state: UpdateState
    ):
        state_info = update_state.state_info
        if not state_info.is_channel:
            logger.warning(
                'skipping channel difference fetch: '
                'state_info does not refer to a valid channel'
            )
            return

        async with update_state:
            try:
                logger.debug(
                    'fetching channel difference: '
                    f'pts={state_info.pts}, channel_id={state_info.channel_id}'
                )

                while state_info.pts > 0:
                    result = await self(
                        functions.updates.GetChannelDifference(
                            state_info.to_input_channel(),
                            pts=state_info.pts,
                            limit=PTS_LIMIT,
                            filter=types.ChannelMessagesFilterEmpty()
                        )
                    )

                    if isinstance(result, types.updates.ChannelDifferenceEmpty):
                        state_info.pts = result.pts
                        logger.debug(
                            'channel difference empty: '
                            f'pts={state_info.pts}, channel_id={state_info.channel_id}'
                        )
                        break

                    if isinstance(result, types.updates.ChannelDifferenceTooLong):
                        # more: https://core.telegram.org/constructor/updates.channelDifferenceTooLong
                        state_info.pts = result.dialog.pts
                        logger.debug(
                            'channel difference too long:'
                            f'pts={state_info.pts}, channel_id={state_info.channel_id}'
                        )
                        break

                    updates = result.other_updates
                    # in polling mode, no need to handle `new_messages` and `new_encrypted_messages` here:
                    # they are already included as `UpdateNewMessage` and `UpdateNewEncryptedMessage` in `other_updates`.
                    if not update_state.is_polling:
                        for message in result.new_messages:
                            new_message = types.update.UpdateNewChannelMessage(
                                message,
                                pts=result.pts,
                                pts_count=0
                            )
                            updates.append(new_message)

                    update = types.updates.Updates(
                        updates,
                        result.users,
                        result.chats,
                        date=0,
                        seq=0
                    )
                    state_info.pts = result.pts
                    await self._updates_dispatcher(update)

                    if result.final:
                        logger.debug(
                            'Final difference reached: '
                            f'pts={state_info.pts}, channel_id={state_info.channel_id}'
                        )
                        break

            except (errors.ChannelInvalidError,
                    errors.ChannelPrivateError) as exc:
                logger.info(
                    f'Skipping channel difference fetch for state_id='
                    f'{update_state.state_id} due to {type(exc).__name__!r} '
                    '(probably the user left the channel, was kicked, or lost access)'
                )

                await self._delete_update_state(update_state)

            finally:
                logger.debug(f'channel difference fetching done: pts={state_info.pts}')
                if state_info.pts > 0:
                    self._save_state(state_info)

    # state
    def _save_state(
        self: 'Telegram',
        state_info: models.StateInfo
    ):
        if state_info.is_channel:
            logger.debug(
                f'Saving channel state: state_info={state_info}'
            )    
            self.session.set_channel_pts(
                state_info.channel_id,
                pts=state_info.pts
            )

        else:
            logger.debug(
                f'Saving state: state_info={state_info}'
            )

            self.session.set_state(
                pts=state_info.pts,
                qts=state_info.qts,
                seq=state_info.seq,
                date=state_info.date
            )

    def _get_update_state(
        self: 'Telegram',
        channel_id: t.Optional[int] = None
    ) -> UpdateState:

        state_id = models.StateId(channel_id)
        update_state = self._update_states.get(state_id)

        if update_state is None:
            if channel_id is not None:
                pts = self.session.get_channel_pts(channel_id)
                entity = self._entities.get(channel_id)
                
                if entity is None:
                    entity = models.ChannelEntity(channel_id, 0)
                    self._entities.add_or_update(channel_id, entity)

                state_info = models.StateInfo(
                    pts,
                    entity=entity
                )
                fetch_callback = self._fetch_channel_difference

            else:
                pts, qts, seq , date  = self.session.get_state()
    
                state_info = models.StateInfo(
                    pts,
                    qts=qts,
                    seq=seq,
                    date=date
                )

                fetch_callback = self._fetch_difference

            self._update_states[state_id] = update_state = UpdateState(
                state_info,
                fetch_callback,
                single_update_handler=self._handle_single_update,
                check_polling_callback=lambda e: e in self._channel_polling
            )


        return update_state

    async def _delete_update_state(self, update_state: UpdateState):
        self._save_state(update_state.state_info)
        self._update_states.pop(update_state.state_id, None)

        await update_state.destroy()

    async def add_channel_polling(self: 'Telegram', entity: alias.LikeEntity):
        """Starts polling a **public** channel or supergroup that you're not a member of.

        Telegram only pushes updates for channels you're a member of
        this method manually enables polling for a public channel or supergroup 
        so you can receive updates even without joining.


        Args:
            entity (`LikeEntity`): The channel or supergroup to poll.

        """
        if len(self._channel_polling) >= MAX_CHANNEL_POLLING:
            raise OverflowError('Maximum polling channels reached.')

        result = await self.get_entity(entity, full=True)
        full_chat = getattr(result, 'full_chat', None)

        if not isinstance(full_chat, types.ChannelFull):
            raise TypeError(
                'Polling is only supported for public channels or supergroups.'
            )

        if not next(
            (
                c.left
                for c in result.chats
                if isinstance(c, types.Channel) and c.id == full_chat.id
            ),
            False
        ):
            raise ValueError(
                'You are a member of this channel or supergroup, polling is not required.'
            )

        update_state = self._get_update_state(full_chat.id)
        update_state.state_info.pts = full_chat.pts

        if update_state not in self._channel_polling:
            self._channel_polling.add(update_state)
            await update_state.reset_auto_fetch_timer()

    async def remove_channel_polling(self: 'Telegram', entity: alias.LikeEntity):
        """Stops polling updates from a public channel or supergroup.

        If the given channel was previously added to polling, this method disables
        auto fetching updates for it

        Args:
            entity (`LikeEntity`): The channel or supergroup to stop polling.

        """
        cached = self.get_cache_entity(entity)
        
        if cached is None:
            channel = await self.get_entity(entity)

            if not isinstance(channel, types.Channel):
                return False

            update_state = self._get_update_state(channel.id)

        else:
            if isinstance(cached, models.ChannelEntity):
                return False

            update_state = self._get_update_state(cached.id)

        if update_state not in self._channel_polling:
            return False

        self._channel_polling.discard(update_state)
    
    def get_polled_channel_ids(self: 'Telegram') -> t.List[int]:
        """Get list of channel ids currently being polled."""

        return [
            state.state_id.channel_id
            for state in self._channel_polling
        ]
