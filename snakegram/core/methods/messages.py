import typing as t
from ... import alias, enums, helpers
from ...tl import secret, types, functions
from ...gadgets.utils import env, to_timestamp
from ...gadgets.parser import parse_markdown

if t.TYPE_CHECKING:
    from ..telegram import Telegram
    from ...gadgets.tlobject import TLRequest

T = t.TypeVar('T')

ReplyType: t.TypeAlias = t.Union[
    int,
    types.Message,
    types.TypeInputReplyTo
]

PARSE_MODE = env('PARSE_MODE', 'md', str)


class Messages:
    async def send_text(
        self: 'Telegram',
        target: alias.LikeEntity,
        message: t.Union[str, types.Message],
        *,
        reply_to: t.Optional[ReplyType] = None,
        send_as: alias.LikeEntity = None,
        schedule_date: alias.LikeTime = None,

        silent: bool = False,
        noforwards: bool = False,
        background: bool = False,
        no_webpage: bool = False,
        clear_draft: bool = False,
        invert_media: bool = False,
        allow_paid_floodskip: bool = False,
        update_stickersets_order: bool = False,

        entities: t.List[types.TypeMessageEntity] = None,
        parse_mode: alias.ParseMode = None,
        quick_reply: t.Union[int, str, types.TypeInputQuickReplyShortcut] = None,
        reply_markup: t.Optional[types.TypeReplyMarkup] = None        
    ) -> types.TypeUpdate:
        """
        Sends a text message to the specified `user`, `chat`, or `channel`.
        
        Args:
            target (`LikeEntity`):
                The `user` or `chat` to whom the message will be sent.
            
            message (`str` | `types.Message`):
                The text to send, or `types.Message` object to reuse its content.

            reply_to (`ReplyType`, optional):
                The message or story to reply to.
                If an integer is provided, it will be treated as `msg_id`.
                If `types.Message` is given, the reply will target that message directly.
                Also, you can pass an instance of `types.InputReplyTo` directly.

            send_as (`LikeEntity`, optional):
                The entity to send the message as.
            
            schedule_date (`LikeTime`, optional):
                The date and time when the message should be sent, if scheduling is desired.
            
            silent (`bool`, optional):
                If `True`, the message will be sent silently (no notification).
            
            noforwards (`bool`, optional):
                *Bots only*. Prevents the message from being forwarded or saved by users.
            
            background (`bool`, optional):
                If `True`, sends the message in the background.

            no_webpage (`bool`, optional):
                If `True`, disables webpage preview.
            
            clear_draft (`bool`, optional):
                If `True`, clears existing draft message in the target chat.
            
            invert_media (`bool`, optional):
                If `True`, places the link preview above the message instead of below.
            
            allow_paid_floodskip (`bool`, optional):
                *Bots only*. If `True`, enables paid broadcasts of up to 1000 messages per second, bypassing the free limit of 30 messages/sec.  
                Each message beyond the free limit costs 0.1 Stars, deducted from the bot's balance.  
                To use this feature, the bot must have at least 100.000 Stars and 100.000 monthly active users.  
                Only successfully delivered messages are charged.

            update_stickersets_order (`bool`, optional):
                If `True`, moves the used stickerset to the top. (For `UI` only, has no effect on core logic)
            
            entities (`List[MessageEntity]`, optional):
                List of message formatting `entities`.
                If provided, parsing will be skipped and the message will be formatted directly using this list.
            
            parse_mode (`str`, optional):
                Specifies the parsing mode for text formatting: `'md'`, `'markdown'`, or `'html'`.
                Defaults to the client's global parse mode.
            
            quick_reply (`str` | `int` | `TypeInputQuickReplyShortcut`, optional)
                Adds the message to a quick reply shortcut by `id`, `name`, or input object, instead of sending it normally.
            
            reply_markup (`ReplyMarkup`, optional):
                *Bot only*. Markup for attaching reply buttons (`inline`, `keyboard`, etc.) to the message.
                
        Example:
        ```python
            await client.send_text('me', 'Hello **World**!')

            # Replying to a message
            upd = await client.send_text('me', 'Original message')
            await client.send_text('me', 'This is a reply', reply_to=upd)

            # scheduling a message to be sent in 5 minutes
            await client.send_text(
                chat,
                'This is a scheduled message',
                schedule_date=timedelta(minutes=5)
            )

            # Sending with inline buttons
            await client.send_text(
                chat,
                'Click a button:',
                reply_markup=types.ReplyInlineMarkup(
                    [
                        [types.KeyboardButtonCallback('Button 1', data=b'btn1')],
                        [types.KeyboardButtonUrl('Open site', url='https://example.com')]
                    ]
                )
            )
        ```
        """

        if quick_reply is not None:
            if isinstance(quick_reply, str):
                quick_reply = types.InputQuickReplyShortcut(
                    shortcut=quick_reply
                )

            elif isinstance(quick_reply, int):
                quick_reply = types.InputQuickReplyShortcutId(
                    shortcut_id=quick_reply
                )

        if isinstance(message, types.Message):
            if entities is None:
                entities = message.entities

            reply_markup = (
                message.reply_markup
                if reply_markup is None else
                reply_markup
            )
            message_text = message.message
        
        else:
            message_text = message

        if entities is None:
            message_text, entities = self.parse_message_text(
                message,
                parse_mode=parse_mode or PARSE_MODE
            )

        input_peer = await self.get_input_peer(target)
        if send_as is not None:
            send_as = await self.get_input_peer(send_as)
        
        if reply_to:
            reply_to = await self._get_input_reply_to(reply_to, input_peer)

        request = functions.messages.SendMessage(
            peer=input_peer,
            message=message_text,
            no_webpage=no_webpage,
            silent=silent,
            background=background,
            clear_draft=clear_draft,
            noforwards=noforwards,
            update_stickersets_order=update_stickersets_order,
            invert_media=invert_media,
            allow_paid_floodskip=allow_paid_floodskip,
            reply_to=reply_to,
            reply_markup=reply_markup,
            schedule_date=to_timestamp(schedule_date),
            entities=entities,
            send_as=send_as,
            quick_reply_shortcut=quick_reply
        )
        return await self._resolve_response(request)

    @staticmethod
    def parse_message_text(
        message: str,
        parse_mode: alias.ParseMode,
        secret_layer: t.Optional[int] = None
    ):
        """Parses formatted message (`Markdown` or `HTML`) into text and message entities.

        Args:
            message (`str`):
                The text to be parsed.
            parse_mode (`str`):
                Specifies the parsing mode for text formatting: `'md'`, `'markdown'`, or `'html'`.

            secret_layer (`int`, optional):
                The secret chat layer of the receiving client.
                Because server can't access message content in secret chats, cannot generate message entities based on the receiver's layer.
                So, the sender needs to build message entities that work with the receiver's layer.
        """

        if parse_mode == 'html':
            raise NotImplementedError('HTML parse mode is not supported yet')
        
        elif parse_mode in ('md', 'markdown'):
            text, message_entities = parse_markdown(message)

        else:
            raise ValueError(f'Unsupported parse mode: {parse_mode!r}')

        def _layer_at_least(n: int):
            return not secret_layer or secret_layer >= n

        entities = []
        if _layer_at_least(45):
            # no message entities are supported below layer 46
            for entity in message_entities:
                item = None
                etype = entity.type

                if etype is enums.MessageEntityType.Url:
                    item = types.MessageEntityUrl(
                        entity.offset,
                        length=entity.length
                    )
                
                elif etype is enums.MessageEntityType.Code:
                    item = types.MessageEntityCode(
                        entity.offset,
                        length=entity.length
                    )

                elif etype is enums.MessageEntityType.Bold:
                    item = types.MessageEntityBold(
                        entity.offset,
                        length=entity.length
                    )

                elif etype is enums.MessageEntityType.Italic:
                    item = types.MessageEntityItalic(
                        entity.offset,
                        length=entity.length
                    )

                elif etype is enums.MessageEntityType.MentionName:
                    item = types.MessageEntityMentionName(
                        entity.offset,
                        length=entity.length,
                        user_id=entity.user_id
                    )

                elif etype is enums.MessageEntityType.Pre:
                    item = types.MessageEntityPre(
                        entity.offset,
                        length=entity.length,
                        language=entity.lang_code
                    )

                elif etype is enums.MessageEntityType.TextUrl:
                    item = types.MessageEntityTextUrl(
                        entity.offset,
                        length=entity.length,
                        url=entity.url
                    )

                # layer >= 101
                elif etype is enums.MessageEntityType.Underline:
                    if _layer_at_least(101):
                        item = types.MessageEntityUnderline(
                            entity.offset,
                            length=entity.length
                        )

                elif etype is enums.MessageEntityType.BlockQuote:
                    if _layer_at_least(101):
                        if secret_layer:
                            # no support collapsed
                            item = secret.MessageEntityBlockquote(
                                entity.offset,
                                length=entity.length
                            )
                        
                        else:
                            item = types.MessageEntityBlockquote(
                                entity.offset,
                                length=entity.length,
                                collapsed=entity.collapsed
                            )

                elif etype is enums.MessageEntityType.Strikethrough:
                    if _layer_at_least(101):
                        item = types.MessageEntityStrike(
                            entity.offset,
                            length=entity.length
                        )

                # layer >= 144
                elif etype is enums.MessageEntityType.Spoiler:
                    if _layer_at_least(144):
                        item = types.MessageEntitySpoiler(
                            entity.offset,
                            length=entity.length
                        )

                elif etype is enums.MessageEntityType.CustomEmoji:
                    if _layer_at_least(144):
                        item = types.MessageEntityCustomEmoji(
                            entity.offset,
                            length=entity.length,
                            document_id=entity.custom_emoji_id
                        )

                if item is not None:
                    entities.append(item)

        return text, entities

    # privates
    async def _resolve_response(self: 'Telegram', request: 'TLRequest[T]') -> types.TypeUpdate:
        result = await self(request)

        if isinstance(
            result,
            types.updates.UpdateShortSentMessage
        ):
            peer_id = helpers.cast_to_peer(request.peer)
            
            if request.send_as:
                from_id = helpers.cast_to_peer(request.send_as)
            
            else:
                me = await self.get_input_peer('me')
                from_id = helpers.cast_to_peer(me)

            message = types.Message(
                id=result.id,
                peer_id=helpers.cast_to_peer(request.peer),
                date=result.date,
                message=request.message,
                out=result.out,
                media=result.media,
                entities=result.entities,
                reply_markup=request.reply_markup,
                ttl_period=result.ttl_period,
                reply_to=request.reply_to,
                silent=request.silent,
                noforwards=request.noforwards,
                invert_media=request.invert_media,
                effect=request.effect,
                quick_reply_shortcut=request.quick_reply_shortcut,
                from_id=from_id
            )

            if not isinstance(peer_id, types.PeerChannel):
                return types.UpdateNewMessage(
                    message,
                    pts=result.pts,
                    pts_count=result.pts_count
                )

            else:
                return types.UpdateNewChannelMessage(
                    message,
                    pts=result.pts,
                    pts_count=result.pts_count
                )

        # updates
        if isinstance(
            result,
            (
                types.updates.Updates,
                types.updates.UpdatesCombined
            )
        ):
            updates = result.updates

        elif isinstance(result, types.TypeUpdate):
            updates = [result]

        else:
            return result

        update_ids = {}
        pending_ids = {}
        for update in updates:
            if isinstance(update, types.UpdateMessageID):
                pending_ids[update.random_id] = update.id
                continue
            
            if isinstance(
                update,
                (
                    
                    types.UpdateNewMessage,
                    types.UpdateEditMessage,
                    types.UpdateNewChannelMessage,
                    types.UpdateEditChannelMessage,
                    types.UpdateNewScheduledMessage
                )
            ):
                update_ids[update.message.id] = update

        random_id = getattr(request, 'random_id', None)
        if random_id is not None:
            message_id = pending_ids.get(random_id)

        else:
            message_id = getattr(request, 'id', None)

        if message_id is not None:
            return update_ids.get(message_id)

    async def _get_input_reply_to(
        self: 'Telegram',
        reply: ReplyType,
        input_peer: t.Optional[types.TypeInputPeer] = None,
    ) -> types.TypeInputReplyTo:

        if isinstance(reply, types.TypeInputReplyTo):
            return reply

        message = getattr(reply, 'message', None)
        if isinstance(message, types.Message):
            reply = message

        msg_id = None
        peer_id = None
        top_msg_id = None 

        
        if isinstance(reply, int):
            msg_id = reply

        elif isinstance(reply, types.Message):
            action = getattr(reply, 'action', None)
            if isinstance(
                action,
                (
                    types.MessageActionTopicEdit,
                    types.MessageActionTopicCreate,
                )
            ):
                top_msg_id = reply.id

            else:
                msg_id = reply.id
                peer_id = reply.peer_id
                if reply.reply_to is not None:
                    top_msg_id = (
                        reply.reply_to.reply_to_top_id
                        or
                        reply.reply_to.reply_to_msg_id
                    )

        if peer_id:
            if (
                input_peer is None
                or
                helpers.cast_to_peer(input_peer) == peer_id
            ):
                peer_id = None

            else:
                peer_id = await self.get_input_peer(peer_id)

        return types.InputReplyToMessage(
            msg_id,
            top_msg_id=top_msg_id,
            reply_to_peer_id=peer_id
        )