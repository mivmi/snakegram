import asyncio
import warnings
import typing as t

from ..internal import Uploader
from ... import alias, errors, helpers
from ...tl import secret, types, functions
from ...enums import MessageEntityType
from ...gadgets.utils import env, to_timestamp, time_difference, is_like_list
from ...gadgets.parser import parse_html, parse_markdown

if t.TYPE_CHECKING:
    from ..telegram import Telegram

T = t.TypeVar('T')

TypeReply = t.Union[
    int,
    types.Message,
    types.TypeInputReplyTo
]

LikeMessageId = t.Union[int, types.Message]
LikeInputFile = t.Union[Uploader, alias.LikeFile, types.TypeInputFile]
LikeInputMedia = t.Union[LikeInputFile, types.TypeInputMedia]

PARSE_MODE = env('PARSE_MODE', 'md', str)


class Messages:
    async def send_text(
        self: 'Telegram',
        target: alias.LikeEntity,
        message: t.Union[str, types.Message],
        *,
        reply_to: t.Optional[TypeReply] = None,
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

        effect: t.Optional[int] = None,
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

            reply_to (`TypeReply`, optional):
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
                If `True`, moves the used stickerset to the top.
            
            effect (`int`, optional):
                Specifies a message effect to use for the message.
                To get the list of available effects, use the function `messages.GetAvailableEffects`.

            entities (`List[MessageEntity]`, optional):
                List of message formatting `entities`.
                If provided, parsing will be skipped and the message will be formatted directly using this list.
            
            parse_mode (`str`, optional):
                Specifies the parsing mode for text formatting: `'md'`, `'markdown'`, or `'html'`.
                Defaults to the client's global parse mode.
            
            quick_reply (`str` | `int` | `TypeInputQuickReplyShortcut`, optional)
                Adds the message to a quick reply shortcut by `id`, `name`, or input object.
            
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

            effect = effect or message.effect
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
                message_text,
                parse_mode=parse_mode or PARSE_MODE
            )

        input_peer = await self.get_input_peer(target)
        if send_as is not None:
            send_as = await self.get_input_peer(send_as)
        
        if (
            reply_to
            and not isinstance(reply_to, types.TypeInputReplyTo)
        ):
            reply_to = await self.get_input_reply(msg=reply_to)

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
            schedule_date=(
                None
                if schedule_date is None else
                to_timestamp(schedule_date)
            ),
            entities=entities,
            send_as=send_as,
            effect=effect,
            quick_reply_shortcut=quick_reply
        )
        
        return await self._invoke_wait_updates(request, input_peer)

    async def send_media(
        self: 'Telegram',
        target: alias.LikeEntity,
        media: LikeInputFile,
        *,
        message: t.Union[str, types.Message] = '',
        reply_to: t.Optional[TypeReply] = None,
        send_as: alias.LikeEntity = None,
        schedule_date: alias.LikeTime = None,
        
        silent: bool = False,
        spoiler: bool = False,
        force_file: bool = False,
        noforwards: bool = False,
        background: bool = False,
        clear_draft: bool = False,
        invert_media: bool = False,
        nosound_video: bool = False,
        allow_paid_floodskip: bool = False,
        update_stickersets_order: bool = False,

        ttl: t.Optional[alias.LikeTime] = None,
        effect: t.Optional[int] = None,

        thumb: t.Optional[LikeInputFile] = None,
        entities: t.List[types.TypeMessageEntity] = None,
        stickers: t.Optional[t.List[types.TypeInputDocument]] = None,
        attributes: t.List[types.TypeDocumentAttribute] = None,

        parse_mode: alias.ParseMode = None,
        quick_reply: t.Union[int, str, types.TypeInputQuickReplyShortcut] = None,
        reply_markup: t.Optional[types.TypeReplyMarkup] = None     
    ):
        """Sends a media message to the specified `user`, `chat`, or `channel`.

        Args:
            target (`LikeEntity`):
                The `user` or `chat` to whom the message will be sent.

            media (`LikeInputFile`):
                Attached media to send.
                such as a file path, file-like, `types.TypeInputFile` or `types.TypeInputMedia` object.
            
            message (`str` | `types.Message`):
                Optional caption for the media.
                Can be `str` or `types.Message` object to reuse formatting entities.

            reply_to (`TypeReply`, optional):
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
            
            spoiler (`bool`, optional):
                If `True`, marks the media as a spoiler (blurred until tapped).

            force_file (`bool`, optional):
                If `True`, sends the media as a file instead.

            noforwards (`bool`, optional):
                *Bots only*. Prevents the message from being forwarded or saved by users.
            
            background (`bool`, optional):
                If `True`, sends the message in the background.
            
            clear_draft (`bool`, optional):
                If `True`, clears existing draft message in the target chat.
            
            invert_media (`bool`, optional):
                If `True`, places the media above the message instead of below
            
            nosound_video (`bool`, optional):
                If `True`, specifies that the attached document is a video file
                with no audio tracks (for example, a GIF animation, even if encoded as MPEG4).

            allow_paid_floodskip (`bool`, optional):
                *Bots only*. If `True`, enables paid broadcasts of up to 1000 messages per second, bypassing the free limit of 30 messages/sec.  
                Each message beyond the free limit costs 0.1 Stars, deducted from the bot's balance.  
                To use this feature, the bot must have at least 100.000 Stars and 100.000 monthly active users.  
                Only successfully delivered messages are charged.

            update_stickersets_order (`bool`, optional):
                If `True`, moves the used stickerset to the top.
            
            ttl (`LikeTime`, optional):
                Self destruct timer for the media, in seconds or as date/time.

            effect (`int`, optional):
                Specifies a message effect to use for the message.
                To get the list of available effects, use the function `messages.GetAvailableEffects`.

            thumb (`LikeInputFile`, optional):
                Optional thumbnail for the media.
            
            entities (`List[MessageEntity]`, optional):
                List of message formatting `entities` for the caption.
                If provided, parsing will be skipped and the caption will be formatted directly.
            
            stickers (`List[InputDocument]`, optional):
                Stickers to attach to the media.
            
            attributes (`List[DocumentAttribute]`, optional):
                Attributes that specify the type of the document (`video`, `audio`, `voice`, `sticker`, etc.).
            
            parse_mode (`str`, optional):
                Specifies the parsing mode for the caption: `'md'`, `'markdown'`, or `'html'`.
                Defaults to the client's global parse mode.

            quick_reply (`str` | `int` | `TypeInputQuickReplyShortcut`, optional):
                Adds the message to a quick reply shortcut by `id`, `name`, or input object.

            reply_markup (`ReplyMarkup`, optional):
                *Bot only*. Markup for attaching reply buttons (`inline`, `keyboard`, etc.) to the message.

        Example:
        ```python

        # sending file
        await client.send_media('me', 'photo.jpg', message='My photo')
        
        # sending a document with custom filename
        await client.send_media(
            chat,
            'report.pdf',
            attributes=[types.DocumentAttributeFilename('custom-name.pdf')]
        )
        
        # sending with inline buttons
        await client.send_media(
            chat,
            'photo.jpg',
            reply_markup=types.ReplyInlineMarkup(
                [
                    [types.KeyboardButtonUrl('Url', url='https://example.com/photo.jpg')]
                ]
            )
        )
        
        # sending a dice using `types.TypeInputMedia`
        await client.send_media(chat, types.InputMediaDice('🎲'))
        ```
        """
        input_media = await self.get_input_media(
            media,
            ttl=ttl,
            spoiler=spoiler,
            force_file=force_file,
            nosound_video=nosound_video,
            thumb=thumb,
            stickers=stickers,
            attributes=attributes 
        )

        if isinstance(message, types.Message):
            if entities is None:
                entities = message.entities

            effect = effect or message.effect
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
                message_text,
                parse_mode=parse_mode or PARSE_MODE
            )

        if quick_reply is not None:
            if isinstance(quick_reply, str):
                quick_reply = types.InputQuickReplyShortcut(
                    shortcut=quick_reply
                )

            elif isinstance(quick_reply, int):
                quick_reply = types.InputQuickReplyShortcutId(
                    shortcut_id=quick_reply
                )

        input_peer = await self.get_input_peer(target)
        if send_as is not None:
            send_as = await self.get_input_peer(send_as)
        
        if (
            reply_to
            and not isinstance(reply_to, types.TypeInputReplyTo)
        ):
            reply_to = await self.get_input_reply(msg=reply_to)

        request = functions.messages.SendMedia(
            input_peer,
            input_media,
            message=message_text,
            silent=silent,
            background=background,
            clear_draft=clear_draft,
            noforwards=noforwards,
            update_stickersets_order=update_stickersets_order,
            invert_media=invert_media,
            allow_paid_floodskip=allow_paid_floodskip,
            reply_to=reply_to,
            reply_markup=reply_markup,
            schedule_date=(
                None
                if schedule_date is None else
                to_timestamp(schedule_date)
            ),
            entities=entities,
            send_as=send_as,
            effect=effect,
            quick_reply_shortcut=quick_reply
        )
        return await self._invoke_wait_updates(request, input_peer)

    async def send_message(
        self: 'Telegram',
        target: alias.LikeEntity,
        message: t.Union[str, types.Message] = '',
        *,
        media: LikeInputFile = None,
        reply_to: t.Optional[TypeReply] = None,
        send_as: alias.LikeEntity = None,
        schedule_date: alias.LikeTime = None,

        silent: bool = False,
        noforwards: bool = False,
        background: bool = False,
        clear_draft: bool = False,
        invert_media: bool = False,
        allow_paid_floodskip: bool = False,
        update_stickersets_order: bool = False,

        no_webpage: bool = False,
        spoiler: bool = False,
        force_file: bool = False,
        nosound_video: bool = False,
        ttl: t.Optional[alias.LikeTime] = None,
        thumb: t.Optional[LikeInputFile] = None,
        stickers: t.Optional[t.List[types.TypeInputDocument]] = None,
        attributes: t.List[types.TypeDocumentAttribute] = None,

        effect: t.Optional[int] = None,
        entities: t.List[types.TypeMessageEntity] = None,
        parse_mode: alias.ParseMode = None,

        quick_reply: t.Union[int, str, types.TypeInputQuickReplyShortcut] = None,
        reply_markup: t.Optional[types.TypeReplyMarkup] = None
    ):
        """
        Sends a message to the specified `user`, `chat`, or `channel`.


        Args:
            target (`LikeEntity`):
                The `user` or `chat` to whom the message will be sent.

            message (`str` | `types.Message`, optional):
                The text of the message, or a `types.Message` object
                to reuse its content and entities.  
                When `media` is provided, this becomes the caption.

            media (`LikeInputFile`, optional):
                Attached media to send.
                If `None` the method will use media from `message` if available.
                otherwise, the message is sent as text.

            reply_to (`TypeReply`, optional):
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

            clear_draft (`bool`, optional):
                If `True`, clears existing draft message in the target chat.

            invert_media (`bool`, optional):
                If `True`, places the media above the message instead of below.

            allow_paid_floodskip (`bool`, optional):
                *Bots only*. If `True`, enables paid broadcasts of up to 1000 messages per second, bypassing the free limit of 30 messages/sec.  
                Each message beyond the free limit costs 0.1 Stars, deducted from the bot's balance.  
                To use this feature, the bot must have at least 100.000 Stars and 100.000 monthly active users.  
                Only successfully delivered messages are charged.

            update_stickersets_order (`bool`, optional):
                If `True`, moves the used stickerset to the top.

            no_webpage (`bool`, optional):
                *Text only*. If `True`, disables webpage preview.

            spoiler (`bool`, optional):
                *Media only*. If `True`, marks the media as a spoiler (blurred until tapped).

            force_file (`bool`, optional):
                *Media only*. If `True`, sends the media as a file.

            nosound_video (`bool`, optional):
                *Media only*. If `True`, specifies that the attached document is a video file
                with no audio tracks (for example, a GIF animation, even if encoded as MPEG4).

            ttl (`LikeTime`, optional):
                *Media only*. self destruct timer for the media, in seconds or as date/time..

            thumb (`LikeInputFile`, optional):
                *Media only*. Optional thumbnail for the media.

            stickers (`List[InputDocument]`, optional):
                *Media only*. Stickers to attach to the media.

            attributes (`List[DocumentAttribute]`, optional):
                *Media only*. Attributes that specify the type of the document (`video`, `audio`, `voice`, `sticker`, etc.).

            effect (`int`, optional):
                Specifies a message effect to use for the message.
                To get the list of available effects, use the function `messages.GetAvailableEffects`.

            entities (`List[MessageEntity]`, optional):
                List of message formatting `entities` for the caption.
                If provided, parsing will be skipped and the caption will be formatted directly.

            parse_mode (`str`, optional):
                Specifies the parsing mode for the text/caption: `'md'`, `'markdown'`, or `'html'`.
                Defaults to the client's global parse mode.

            quick_reply (`str` | `int` | `TypeInputQuickReplyShortcut`, optional):
                Adds the message to a quick reply shortcut by `id`, `name`, or input object.

            reply_markup (`ReplyMarkup`, optional):
                *Bot only*. Markup for attaching reply buttons (`inline`, `keyboard`, etc.) to the message.

        Example:
        ```python

        # send text 
        await client.send_message('me', 'Hello world!')

        # send photo with caption
        await client.send_message('me', 'Look at this!', media='photo.jpg')

        # reply to a message
        upd = await client.send_message('me', 'First')
        await client.send_message('me', 'Replying', reply_to=upd)

        # send media with inline buttons
        await client.send_message(
            chat,
            'Click this out:',
            media='file.pdf',
            reply_markup=types.ReplyInlineMarkup(
                [
                    [types.KeyboardButtonUrl('Open site', url='https://example.com')]
                ]
            )
        )
        ```
        """

        if media is None: 
            if isinstance(message, types.Message):
                media = message.media

        if isinstance(media, types.MessageMediaWebPage):
            media = None
            no_webpage = False

        if media is not None:
            return await self.send_media(
                target,
                media,
                message=message,
                reply_to=reply_to,
                send_as=send_as,
                schedule_date=schedule_date,
                silent=silent,
                spoiler=spoiler,
                force_file=force_file,
                noforwards=noforwards,
                background=background,
                clear_draft=clear_draft,
                invert_media=invert_media,
                nosound_video=nosound_video,
                allow_paid_floodskip=allow_paid_floodskip,
                update_stickersets_order=update_stickersets_order,
                ttl=ttl,
                effect=effect,
                thumb=thumb,
                entities=entities,
                stickers=stickers,
                attributes=attributes,
                parse_mode=parse_mode,
                quick_reply=quick_reply,
                reply_markup=reply_markup
            )
        else:
            return await self.send_text(
                target,
                message,
                reply_to=reply_to,
                send_as=send_as,
                schedule_date=schedule_date,
                silent=silent,
                noforwards=noforwards,
                background=background,
                no_webpage=no_webpage,
                clear_draft=clear_draft,
                invert_media=invert_media,
                allow_paid_floodskip=allow_paid_floodskip,
                update_stickersets_order=update_stickersets_order,
                effect=effect,
                entities=entities,
                parse_mode=parse_mode,
                quick_reply=quick_reply,
                reply_markup=reply_markup
            )

    # forward messages
    if t.TYPE_CHECKING:
        @t.overload
        async def forward_messages(
            self: 'Telegram',
            target: alias.LikeEntity,
            source: alias.LikeEntity,
            messages: LikeMessageId,
            *,
            silent: bool = False,
            noforwards: bool = False,
            background: bool = False,
            with_my_score: bool = False,
            drop_author: bool = False,
            drop_media_captions: bool = False,
            allow_paid_floodskip: bool = False,
            top_msg_id: t.Optional[int] = None,
            schedule_date: alias.LikeTime = None,
            send_as: alias.LikeEntity = None,
            quick_reply: t.Union[int, str, types.TypeInputQuickReplyShortcut] = None
        ) -> types.TypeUpdate: ...
        
        @t.overload
        async def forward_messages(
            self: 'Telegram',
            target: alias.LikeEntity,
            source: alias.LikeEntity,
            messages: t.List[LikeMessageId],
            *,
            silent: bool = False,
            noforwards: bool = False,
            background: bool = False,
            with_my_score: bool = False,
            drop_author: bool = False,
            drop_media_captions: bool = False,
            allow_paid_floodskip: bool = False,
            top_msg_id: t.Optional[int] = None,
            schedule_date: alias.LikeTime = None,
            send_as: alias.LikeEntity = None,
            quick_reply: t.Union[int, str, types.TypeInputQuickReplyShortcut] = None
        ) -> t.List[types.TypeUpdate]: ...

    async def forward_messages(
        self: 'Telegram',
        target: alias.LikeEntity,
        source: alias.LikeEntity,
        messages: t.Union[LikeMessageId, t.List[LikeMessageId]],
        *,
        silent: bool = False,
        noforwards: bool = False,
        background: bool = False,
        with_my_score: bool = False,
        drop_author: bool = False,
        drop_media_captions: bool = False,
        allow_paid_floodskip: bool = False,
        top_msg_id: t.Optional[int] = None,
        schedule_date: alias.LikeTime = None,
        send_as: alias.LikeEntity = None,
        quick_reply: t.Union[int, str, types.TypeInputQuickReplyShortcut] = None
    ) -> t.List[types.TypeUpdate]:
        """
        Forwards messages to the specified `user`, `chat`, or `channel`.

        Args:
            target (`LikeEntity`):
                The `user` or `chat` to whom the message will be sent.

            source (`LikeEntity`):
                The `user` or `chat` where the message is located.

            messages (`LikeMessageId` | `List[LikeMessageId]`):
                The message(s) to forward.
                Can be a `msg_id` (int), a `types.Message` object, or a list of these.

            silent (`bool`, optional):
                If `True`, forwards messages silently (no notification).

            noforwards (`bool`, optional):
                *Bots only*. Prevents the messages from being forwarded or saved by users.

            background (`bool`, optional):
                If `True`, forwards the messages in the background.
            
            with_my_score (`bool`, optional):
                If `True`, includes your score when forwarding games.

            drop_author (`bool`, optional):
                If `True`, forwards messages without quoting the original author.

            drop_media_captions (`bool`, optional):
                If `True`, strips captions from media.

            allow_paid_floodskip (`bool`, optional):
                *Bots only*. If `True`, enables paid broadcasts of up to 1000 messages per second, bypassing the free limit of 30 messages/sec.  
                Each message beyond the free limit costs 0.1 Stars, deducted from the bot's balance.  
                To use this feature, the bot must have at least 100.000 Stars and 100.000 monthly active users.  
                Only successfully delivered messages are charged.

            top_msg_id (`int`, optional):
                The message id of the topic. Messages will be forwarded to this topic.
                If not set, messages are sent to the general topic.

            schedule_date (`LikeTime`, optional):
                The date and time when the messages should be forwarded, if scheduling is desired.

            send_as (`LikeEntity`, optional):
                The entity to send the messages as.

            quick_reply (`str` | `int` | `TypeInputQuickReplyShortcut`, optional):
                Adds the messages to a quick reply shortcut by `id`, `name`, or input object.

        Returns:
            `List[TypeUpdate]`: List of update objects for the forwarded messages.

        Example:
        ```python
        # Forward a single message
        update = await client.send_text('source_chat', 'Hello!')
        await client.forward_messages(
            update.message.peer_id,
            'source_chat',
            update.message
        )

        # Forward with options
        await client.forward_messages(
            update.message.peer_id,
            'source_chat',
            update.message,
            drop_author=True
        )

        # Forward multiple messages ids
        await client.forward_messages(
            'source_chat',
            'target_chat'
            [123, 124, 125]
        )

        ```
        """
        is_single = not is_like_list(messages)
        if is_single:
            messages = [messages]

        ids = []
        video_timestamp = None
        for index, msg in enumerate(messages):
            msg = helpers._unwrap_message(msg)

            if isinstance(msg, int):
                ids.append(msg)
            
            elif isinstance(msg, types.Message):
                ids.append(msg.id)

                if is_single and isinstance(
                    msg.media,
                    types.MessageMediaDocument
                ):
                    video_timestamp = msg.media.video_timestamp

            else:
                if is_single:
                    raise TypeError(
                        "Expected 'messages' to be a "
                        "msg_id (int) or types.Message, or list of these, "
                        f"not {type(msg).__name__}."
                    )

                raise TypeError(
                    f'Invalid item at index {index}: '
                    f'Expected a msg_id (int) or types.Message, not {type(msg).__name__}'
                )

        if not ids:
            raise ValueError(
                'You must provide at least one message.'
            )

        # Handle quick reply shortcut
        if quick_reply is not None:
            if isinstance(quick_reply, str):
                quick_reply = types.InputQuickReplyShortcut(
                    shortcut=quick_reply
                )

            elif isinstance(quick_reply, int):
                quick_reply = types.InputQuickReplyShortcutId(
                    shortcut_id=quick_reply
                )

        # Get input peers
        input_peer_to = await self.get_input_peer(target)
        input_peer_from = await self.get_input_peer(source)

        if send_as is not None:
            send_as = await self.get_input_peer(send_as)

        request = functions.messages.ForwardMessages(
            from_peer=input_peer_from,
            id=ids,
            to_peer=input_peer_to,
            silent=silent,
            background=background,
            with_my_score=with_my_score,
            drop_author=drop_author,
            drop_media_captions=drop_media_captions,
            noforwards=noforwards,
            allow_paid_floodskip=allow_paid_floodskip,
            top_msg_id=top_msg_id,
            schedule_date=(
                None
                if schedule_date is None else
                to_timestamp(schedule_date)
            ),
            send_as=send_as,
            quick_reply_shortcut=quick_reply,
            video_timestamp=video_timestamp
        )

        result = await self._invoke_wait_updates(
            request,
            input_peer_to
        )
        if isinstance(result, list) and is_single:
            result = result[0]
        return result

    # delete messages
    async def delete_messsages(
        self: 'Telegram',
        messages: t.Union[LikeMessageId, t.List[LikeMessageId]],
        *,
        revoke: bool = True,
        channel: t.Optional[alias.LikeEntity] = None
    ):
        """Delete the specified messages.

        Args:
            messages (`LikeMessageId` | `List[LikeMessageId]`):
                The message(s) to delete.
                Can be a `msg_id` (int), a `types.Message` object, or a list of these.

            revoke (bool, optional):
                If `True`.
                Delete messages for all participants of the chat.
                Ignored when deleting channel/supergroup messages. Defaults to `True`.

            channel (`LikeEntity`, optional):
                Required only if `messages` contains `msg_id`
                from a channel/supergroup, if at least one item in the list
                is a `types.Message` object, The channel will be detected automatically.

        Example:
        ```python
        
        # Delete single message
        await client.delete_messages(12345)
        
        # Delete multiple messages
        message_ids = [12345, 12346, 12347]
        await client.delete_messages(message_ids)
                
        # Delete messages only for yourself
        await client.delete_messages([123, 124], revoke=False)
        
        # Delete messages from a specific channel
        await client.delete_messages([101, 102, 103], channel='@example')
        ```
        """
        is_single = not is_like_list(messages)
        if is_single:
            messages = [messages]
        
        if len(messages) > 100:
            raise ValueError(
                'Too many messages provided. '
                'You can delete up to 100 messages per request.'
            )

        if channel is not None:
            try:
                input_peer = await self.get_input_peer(channel)
                input_channel = helpers.cast_to_input_channel(input_peer)

            except TypeError:
                input_channel = None
        
        else:
            input_channel = None

        ids = []
        for index, msg in enumerate(messages):
            msg = helpers._unwrap_message(msg)

            if isinstance(msg, int):
                ids.append(msg)

            elif isinstance(msg, types.Message):
                if input_channel:
                    if (
                        not isinstance(msg.peer_id, types.PeerChannel)
                        or 
                        not msg.peer_id.channel_id == input_channel.channel_id
                    ):
                        raise errors.MsgIdInvalidError(request=None)

                elif isinstance(msg.peer_id, types.PeerChannel):
                    input_peer = await self.get_input_peer(msg.peer_id)
                    input_channel = helpers.cast_to_input_channel(input_peer)

                ids.append(msg.id)
            else:
                if is_single:
                    raise TypeError(
                        "Expected 'messages' to be a "
                        "msg_id (int) or types.Message, or list of these, "
                        f"not {type(msg).__name__}."
                    )

                raise TypeError(
                    f'Invalid item at index {index}: '
                    f'Expected a msg_id (int) or types.Message, not {type(msg).__name__}'
                )

        if not ids:
            raise ValueError(
                'You must provide at least one message.'
            )

        if input_channel:
            request = functions.channels.DeleteMessages(
                input_channel,
                id=ids
            )

        else:
            request = functions.messages.DeleteMessages(
                ids,
                revoke=revoke
            )

        return await self(request)

    # helper
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
            text, message_entities = parse_html(message)
        
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
                entity_type = entity.type

                if entity_type is MessageEntityType.Url:
                    item = types.MessageEntityUrl(
                        entity.offset,
                        length=entity.length
                    )
                
                elif entity_type is MessageEntityType.Code:
                    item = types.MessageEntityCode(
                        entity.offset,
                        length=entity.length
                    )

                elif entity_type is MessageEntityType.Bold:
                    item = types.MessageEntityBold(
                        entity.offset,
                        length=entity.length
                    )

                elif entity_type is MessageEntityType.Italic:
                    item = types.MessageEntityItalic(
                        entity.offset,
                        length=entity.length
                    )

                elif entity_type is MessageEntityType.MentionName:
                    item = types.MessageEntityMentionName(
                        entity.offset,
                        length=entity.length,
                        user_id=entity.user_id
                    )

                elif entity_type in (
                    MessageEntityType.Pre,
                    MessageEntityType.PreCode
                ):
                    item = types.MessageEntityPre(
                        entity.offset,
                        length=entity.length,
                        language=entity.data or ''
                    )

                elif entity_type is MessageEntityType.TextUrl:
                    item = types.MessageEntityTextUrl(
                        entity.offset,
                        length=entity.length,
                        url=entity.data
                    )

                # layer >= 101
                elif entity_type is MessageEntityType.Underline:
                    if not _layer_at_least(101):
                        continue
                    
                    item = types.MessageEntityUnderline(
                        entity.offset,
                        length=entity.length
                    )

                elif entity_type in (
                    MessageEntityType.BlockQuote,
                    MessageEntityType.ExpandableBlockQuote
                ):
                    if not _layer_at_least(101):
                        continue

                    collapsed = entity_type is MessageEntityType\
                        .ExpandableBlockQuote

                    if secret_layer: # no support collapsed
                        item = secret.MessageEntityBlockquote(
                            entity.offset,
                            length=entity.length
                        )

                    else:

                        item = types.MessageEntityBlockquote(
                            entity.offset,
                            length=entity.length,
                            collapsed=collapsed
                        )

                elif entity_type is MessageEntityType.Strikethrough:
                    if not _layer_at_least(101):
                        continue
                    
                    item = types.MessageEntityStrike(
                        entity.offset,
                        length=entity.length
                    )

                # layer >= 144
                elif entity_type is MessageEntityType.Spoiler:
                    if not _layer_at_least(144):
                        continue
                    
                    item = types.MessageEntitySpoiler(
                        entity.offset,
                        length=entity.length
                    )

                elif entity_type is MessageEntityType.CustomEmoji:
                    if not _layer_at_least(144):
                        continue
                    
                    item = types.MessageEntityCustomEmoji(
                        entity.offset,
                        length=entity.length,
                        document_id=entity.custom_emoji_id
                    )
                
                else:
                    warnings.warn(
                        'Skipping unsupported entity type: %r at offset=%d, length=%d' % (
                            entity_type.name,
                            entity.offset,
                            entity.length
                        ),
                        UserWarning
                    )
                    continue

                entities.append(item)

        return text, entities

    async def get_input_media(
        self: 'Telegram',
        media: LikeInputMedia,
        *,
        ttl: t.Optional[alias.LikeTime] = None,
        spoiler: bool = False,
        force_file: bool = False,
        nosound_video: bool = False,
        thumb: t.Optional[LikeInputFile] = None,
        video_cover: types.TypeInputPhoto = None,
        stickers=None,
        attributes=None
    ):

        async def get_uploaded_file(obj: LikeInputFile):
            if isinstance(obj, alias.LikeFile):
                return await self.upload(obj)

            if isinstance(obj, Uploader):
                return await obj

            return obj

        uploaded = await get_uploaded_file(media)
        input_media = helpers.cast_to_input_media(uploaded, force_file)


        _ttl_seconds = (
            0
            if ttl is None else
            time_difference(ttl)
        )
        if _ttl_seconds <= 0:
            _ttl_seconds = None

        if thumb is not None:
            if not isinstance(
                input_media,
                types.InputMediaUploadedDocument
            ):
                raise ValueError(
                    f"{type(input_media).__name__!r} does not support 'thumb'."
                )

            input_media.thumb = await get_uploaded_file(thumb)

        if isinstance(input_media, types.InputMediaUploadedDocument):
            if attributes is not None:
                input_media.attributes.extend(attributes)

        return input_media.replace(
            spoiler=spoiler,
            force_file=force_file,
            ttl_seconds=_ttl_seconds,
            nosound_video=nosound_video,
            stickers=(
                None
                if stickers is None else
                [helpers.cast_input_document(s) for s in stickers]
            ),
            video_cover=(
                None
                if video_cover is None else
                helpers.cast_to_input_photo(video_cover)
            ) 
        )

    async def get_input_reply(
        self: 'Telegram',
        msg: t.Optional[TypeReply] = None,
        entity: t.Optional[alias.LikeEntity] = None,
        story_id: t.Optional[int] = None,
        top_msg_id: t.Optional[int] = None
    ):
        peer_id = (
            None
            if entity is None else
            await self.get_entity(entity)
        )

        msg = helpers._unwrap_message(msg)
        if msg is not None:
            msg_id = None
            topic_id = None

            if isinstance(msg, int):
                msg_id = msg

            elif isinstance(msg, types.Message):
                msg_id = msg.id
                if (
                    isinstance(msg.reply_to, types.MessageReplyHeader)
                    and msg.reply_to.forum_topic
                ):
                    topic_id = (
                        msg.reply_to.reply_to_top_id
                        or
                        msg.reply_to.reply_to_msg_id
                    )

            else:
                raise TypeError(
                    f"'msg' should be a msg_id or types.Message, not {type(msg).__name__}"
                )

            return types.InputReplyToMessage(
                msg_id,
                top_msg_id=top_msg_id or topic_id,
                reply_to_peer_id=peer_id
            )

        if story_id:
            if not isinstance(story_id, int):
                raise TypeError(
                    f"'story_id' should be an int, not {type(story_id).__name__}"
                )

            if peer_id is None:
                raise ValueError("To reply to a story, you need to provide 'entity'.")

            return types.InputReplyToStory(
                peer_id,
                story_id=story_id
            )

        raise ValueError("You must provide either 'story_id' or 'msg'.")

    # privates
    async def _invoke_wait_updates(
        self: 'Telegram',
        request,
        peer_id: types.TypeInputPeer,
        *,
        timeout: t.Optional[float] = None
    ) -> t.Union[types.TypeUpdate, t.List[types.TypeUpdate]]:
        
        peer_id = helpers.get_peer_id(peer_id)

        futures = []
        random_ids = []
        message_ids = []
        if hasattr(request, 'random_id'):
            is_single = not is_like_list(request.random_id)
            random_ids = (
                [request.random_id]
                if is_single else 
                request.random_id
            )

            for random_id in random_ids:
                future = self._update_tracker.add_random(
                    random_id,
                    peer_id=peer_id
                )
                futures.append(future)

        else:
            is_single = True
            message_ids = [request.id]

            future = self._update_tracker.add_message(
                request.id,
                peer_id=peer_id
            )
            
            futures.append(future)

        try:
            result = await self(request)

            response = await asyncio.wait_for(
                asyncio.gather(*futures),
                timeout
            )
            
            return response[0] if is_single else list(response)

        except asyncio.TimeoutError:
            return result

        finally:
            for random_id in random_ids:
                self._update_tracker.pop_random(random_id)

            for message_id in message_ids:
                self._update_tracker.pop_message(message_id, peer_id)
