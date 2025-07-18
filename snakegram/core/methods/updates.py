import time
import logging
import typing as t

from ..internal import UpdateState
from ... import models, errors, helpers
from ...tl import types, functions
from ...gadgets.utils import env

if t.TYPE_CHECKING:
    from ..telegram import Telegram

T = t.TypeVar('T')
logger = logging.getLogger(__name__)


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
            update.__chats = updates.chats
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
            
        self._create_new_task(self._update_callback(update))

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
                return await self._handle_seq_updates(update)

            elif isinstance(update, types.updates.UpdateShort):
                return await self._handle_single_update(update.update)

            elif isinstance(update, types.updates.UpdatesTooLong):
                return await self._handle_updates_too_long()
            

            elif isinstance(update, (
                    types.updates.UpdateShortMessage,
                    types.updates.UpdateShortChatMessage,
                    types.updates.UpdateShortSentMessage
                )
            ):
                return await self._handle_short_update(update)

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
        update_state = self._get_update_state(None)
        
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
        update_state = self._get_update_state(None)
    
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
            if update.out:
                if self.session.me:
                    from_id = self.session.me.id

                else:
                    me = await self.get_me()
                    from_id = me.id

            else:
                from_id = update.user_id
    
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
            transformed = types.UpdateNewMessage(
                message=types.Message(
                    id=update.id,
                    pts=update.pts,
                    pts_count=update.pts_count,
                    date=update.date,
                    media=update.media,
                    entities=update.entities,
                    ttl_period=update.ttl_period
                )
            )
        
        else:
            logger.warning(f'Unexpected short update type: {update}')
            return 

        await self._handle_single_update(transformed)

    async def _handle_single_update(self: 'Telegram', update):
        if getattr(update, 'pts', None):
            await self._handle_pts_update(update)

        elif getattr(update, 'qts', None):
            await self._handle_qts_update(update)

        else:
            await self._process_update(update)
    
    async def _handle_updates_too_long(self: 'Telegram'):
        logger.info('update too long: get current state')

        try:
            state = await self(functions.updates.GetState())
            update_state = self._get_update_state(None)

            if not self.drop_update:
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
    async def _fetch_difference(
        self: 'Telegram',
        update_state: UpdateState
    ):
        
        state_info = update_state.state_info
        try:

            pts = state_info.pts
            qts = state_info.qts
            seq = state_info.seq
            date = state_info.date
            
            
            logger.debug(
                'fetching difference: '
                f'pts={pts}, qts={qts}, seq={seq}, date={date}'
            )
            if pts <= 0:
                logger.debug(
                    'Skipping difference fetch: '
                    f'invalid pts={pts}, likely no prior state available'
                )
                return 

            await update_state.destroy()
    
            while True:
                difference = await self(
                    functions.updates.GetDifference(
                        pts=pts,
                        qts=qts,
                        date=date,
                        pts_limit=PTS_LIMIT,
                        pts_total_limit=PTS_TOTAL_LIMIT
                    )
                )
                if isinstance(difference, types.updates.DifferenceEmpty):
                    seq = difference.seq
                    date = difference.date
                    logger.debug(
                        'difference empty: '
                        f'updated seq={seq}, date={date}'
                    )
                    break

                elif isinstance(difference, types.updates.DifferenceTooLong):
                    pts = difference.pts
                    logger.debug(f'difference too long: pts={pts}')
                    break
    
                if isinstance(difference, types.updates.Difference):
                    state = difference.state

                else:
                    state = difference.intermediate_state

      
                updates = difference.other_updates
                for message in difference.new_messages:
                    updates.append(
                        types.update.UpdateNewMessage(
                            message,
                            pts=state.pts,
                            pts_count=0
                        )
                    )

                for message in difference.new_encrypted_messages:
                    updates.append(
                        types.update.UpdateNewEncryptedMessage(
                            message,
                            qts=state.qts
                        )
                    )

                update = types.updates.UpdatesCombined(
                    updates,
                    users=difference.users,
                    chats=difference.chats,
                    date=state.date,
                    seq_start=0,
                    seq=state.seq
                )

                state_info.pts = pts = state.pts
                state_info.qts = qts = state.qts
                state_info.seq = seq = state.seq
                state_info.date = date = state.date

                await self._updates_dispatcher(update)
                if isinstance(difference, types.updates.DifferenceSlice):
                    logger.debug('difference slice: fetching more differences')
                    continue

                break
        
        except (
            errors.PersistentTimestampEmptyError,
            errors.PersistentTimestampInvalidError
        ):
            logger.info(
                'invalid or empty pts: fetching fresh state from server'
            )
            state = await self(functions.updates.GetState())
    
            pts = state.pts
            qts = state.qts
            seq = state.seq
            date = state.date

        finally:
            logger.debug(
                'difference fetching done:'
                f'pts={pts}, qts={qts}, seq={seq}, date={date}'
            )
    
            state_info.pts = pts
            state_info.qts = qts
            state_info.seq = seq
            state_info.date = date

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

        await update_state.destroy()
    
        try:
            pts = state_info.pts
    
            logger.debug(
                'fetching channel difference: '
                f'pts={pts}, channel_id={state_info.channel_id}'
            )
    
            while True:
                difference = await self(
                    functions.updates.GetChannelDifference(
                        state_info.to_input_channel(),
                        pts=pts,
                        limit=PTS_LIMIT,
                        filter=types.ChannelMessagesFilterEmpty()
                    )
                )

                if isinstance(difference, types.updates.ChannelDifferenceEmpty):
                    pts = difference.pts
                    logger.debug(
                        'channel difference empty: '
                        f'pts={pts}, channel_id={state_info.channel_id}'
                    )
                    break

                if isinstance(difference, types.updates.ChannelDifferenceTooLong):
                    # more: https://core.telegram.org/constructor/updates.channelDifferenceTooLong
                    pts = difference.dialog.pts
                    logger.debug(
                        'channel difference too long:'
                        f'pts={pts}, channel_id={state_info.channel_id}'
                    )
                    break

                updates = difference.other_updates
                for message in difference.new_messages:
                    updates.append(
                        types.update.UpdateNewChannelMessage(
                            message,
                            pts=difference.pts,
                            pts_count=0
                        )
                    )

                #
                update = types.updates.UpdatesCombined(
                    updates,
                    users=difference.users,
                    chats=difference.chats,
                    date=int(time.time()),
                    seq_start=0,
                    seq=0
                )

                state_info.pts = pts = difference.pts
                await self._updates_dispatcher(update)

                if difference.final:
                    logger.debug(
                        'Final difference reached: '
                        f'pts={pts}, channel_id={state_info.channel_id}'
                    )
                    break

        except (errors.ChannelInvalidError,
                errors.ChannelPrivateError) as err:
            logger.info(
                f'Skipping channel difference fetch for state_id='
                f'{update_state.state_id} due to {type(err).__name__!r} '
                '(probably the user left the channel, was kicked, or lost access)'
            )

            await self._delete_update_state(update_state)
            

        finally:
            logger.debug(f'channel difference fetching done: pts={pts}')
            state_info.pts = pts
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
        channel_id: t.Optional[int],
        create: bool=True
    ) -> UpdateState:

        state_id = models.StateId(channel_id)
        update_state = self._update_states.get(state_id)

        if update_state is None and create:
            if channel_id is not None:
                pts = self.session.get_channel_pts(channel_id)
                entity = self._entities.get(channel_id)
                
                if entity is None:
                    entity = models.Entity(
                        channel_id,
                        None,
                        access_hash=0
                    )
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


    async def add_channel_polling(self: 'Telegram', entity):
        pass

    async def remove_channel_polling(self: 'Telegram', entity):
        pass
