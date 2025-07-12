
true#3fedd339 = True;
boolTrue#997275b5 = Bool;
boolFalse#bc799737 = Bool;

/*
Error.

@code Error code
@text Message
*/
error#c4b9f9bb code:int text:string = Error;

/*
Corresponds to an arbitrary empty object.
*/
null#56730bcc = Null;

/*
An empty constructor, no user or chat is defined.
*/
inputPeerEmpty#7f3b18ea = InputPeer;

/*
Defines the current user.
*/
inputPeerSelf#7da07ec9 = InputPeer;

/*
Defines a chat for further interaction.

@chat_id Chat identifier
*/
inputPeerChat#35a95cb9 chat_id:long = InputPeer;

/*
Defines a user for further interaction.

@user_id User identifier
@access_hash access_hash value from the [user](https://core.telegram.org/constructor/user) constructor
*/
inputPeerUser#dde8a54c user_id:long access_hash:long = InputPeer;

/*
Defines a channel for further interaction.

@channel_id Channel identifier
@access_hash access_hash value from the [channel](https://core.telegram.org/constructor/channel) constructor
*/
inputPeerChannel#27bcbbfc channel_id:long access_hash:long = InputPeer;

/*
Defines a [min](https://core.telegram.org/api/min) user that was seen in a certain message of a certain chat.

@peer The chat where the user was seen
@msg_id The message ID
@user_id The identifier of the user that was seen
*/
inputPeerUserFromMessage#a87b0a1c peer:InputPeer msg_id:int user_id:long = InputPeer;

/*
Defines a [min](https://core.telegram.org/api/min) channel that was seen in a certain message of a certain chat.

@peer The chat where the channel's message was seen
@msg_id The message ID
@channel_id The identifier of the channel that was seen
*/
inputPeerChannelFromMessage#bd2a0840 peer:InputPeer msg_id:int channel_id:long = InputPeer;

/*
Empty constructor, does not define a user.
*/
inputUserEmpty#b98886cf = InputUser;

/*
Defines the current user.
*/
inputUserSelf#f7c1b13f = InputUser;

/*
Defines a user for further interaction.

@user_id User identifier
@access_hash access_hash value from the [user](https://core.telegram.org/constructor/user) constructor
*/
inputUser#f21158c6 user_id:long access_hash:long = InputUser;

/*
Defines a [min](https://core.telegram.org/api/min) user that was seen in a certain message of a certain chat.

@peer The chat where the user was seen
@msg_id The message ID
@user_id The identifier of the user that was seen
*/
inputUserFromMessage#1da448e2 peer:InputPeer msg_id:int user_id:long = InputUser;

/*
Phone contact.

@client_id An arbitrary 64-bit integer: it should be set, for example, to an incremental number when using [contacts.importContacts](https://core.telegram.org/method/contacts.importContacts), in order to retry importing only the contacts that weren't imported successfully, according to the client_ids returned in [contacts.importedContacts](https://core.telegram.org/constructor/contacts.importedContacts). retry_contacts.
@phone Phone number
@first_name Contact's first name
@last_name Contact's last name
*/
inputPhoneContact#f392b7f4 client_id:long phone:string first_name:string last_name:string = InputContact;

/*
Defines a file saved in parts using the method [upload.saveFilePart](https://core.telegram.org/method/upload.saveFilePart).

@id Random file identifier created by the client
@parts Number of parts saved
@name Full name of the file
@md5_checksum In case the file's [md5-hash](https://en.wikipedia.org/wiki/MD5#MD5_hashes) was passed, contents of the file will be checked prior to use
*/
inputFile#f52ff27f id:long parts:int name:string md5_checksum:string = InputFile;

/*
Assigns a big file (over 10 MB in size), saved in part using the method [upload.saveBigFilePart](https://core.telegram.org/method/upload.saveBigFilePart).

@id Random file id, created by the client
@parts Number of parts saved
@name Full file name
*/
inputFileBig#fa4f0bb5 id:long parts:int name:string = InputFile;

/*
Used to [edit the thumbnail/static preview of a story, see here](https://core.telegram.org/api/stories#editing-stories) for more info on the full flow.

@id The old story video.
*/
inputFileStoryDocument#62dc8b48 id:InputDocument = InputFile;

/*
Empty media content of a message.
*/
inputMediaEmpty#9664f57f = InputMedia;

/*
Photo

@spoiler Whether this media should be hidden behind a spoiler warning
@file The [uploaded file](https://core.telegram.org/api/files)
@stickers Attached mask stickers
@ttl_seconds Time to live in seconds of self-destructing photo
*/
inputMediaUploadedPhoto#1e287d04 flags:# spoiler:flags.2?true file:InputFile stickers:flags.0?Vector<InputDocument> ttl_seconds:flags.1?int = InputMedia;

/*
Forwarded photo

@spoiler Whether this media should be hidden behind a spoiler warning
@id Photo to be forwarded
@ttl_seconds Time to live in seconds of self-destructing photo
*/
inputMediaPhoto#b3ba0635 flags:# spoiler:flags.1?true id:InputPhoto ttl_seconds:flags.0?int = InputMedia;

/*
Map.

@geo_point GeoPoint
*/
inputMediaGeoPoint#f9c44144 geo_point:InputGeoPoint = InputMedia;

/*
Phone book contact

@phone_number Phone number
@first_name Contact's first name
@last_name Contact's last name
@vcard Contact vcard
*/
inputMediaContact#f8ab7dfb phone_number:string first_name:string last_name:string vcard:string = InputMedia;

/*
New document

@nosound_video Whether the specified document is a video file with no audio tracks (a GIF animation (even as MPEG4), for example)
@force_file Force the media file to be uploaded as document
@spoiler Whether this media should be hidden behind a spoiler warning
@file The [uploaded file](https://core.telegram.org/api/files)
@thumb Thumbnail of the document, uploaded as for the file
@mime_type MIME type of document
@attributes Attributes that specify the type of the document (video, audio, voice, sticker, etc.)
@stickers Attached stickers
@video_cover  ... 
@video_timestamp  ... 
@ttl_seconds Time to live in seconds of self-destructing document

#DocError
*/
inputMediaUploadedDocument#37c9330 flags:# nosound_video:flags.3?true force_file:flags.4?true spoiler:flags.5?true file:InputFile thumb:flags.2?InputFile mime_type:string attributes:Vector<DocumentAttribute> stickers:flags.0?Vector<InputDocument> video_cover:flags.6?InputPhoto video_timestamp:flags.7?int ttl_seconds:flags.1?int = InputMedia;

/*
Forwarded document

@spoiler Whether this media should be hidden behind a spoiler warning
@id The document to be forwarded.
@video_cover  ... 
@video_timestamp  ... 
@ttl_seconds Time to live of self-destructing document
@query Text query or emoji that was used by the user to find this sticker or GIF: used to improve search result relevance.

#DocError
*/
inputMediaDocument#a8763ab5 flags:# spoiler:flags.2?true id:InputDocument video_cover:flags.3?InputPhoto video_timestamp:flags.4?int ttl_seconds:flags.0?int query:flags.1?string = InputMedia;

/*
Can be used to send a venue geolocation.

@geo_point Geolocation
@title Venue name
@address Physical address of the venue
@provider Venue provider: currently only "foursquare" and "gplaces" (Google Places) need to be supported
@venue_id Venue ID in the provider's database
@venue_type Venue type in the provider's database
*/
inputMediaVenue#c13d1c11 geo_point:InputGeoPoint title:string address:string provider:string venue_id:string venue_type:string = InputMedia;

/*
New photo that will be uploaded by the server using the specified URL

@spoiler Whether this media should be hidden behind a spoiler warning
@url URL of the photo
@ttl_seconds Self-destruct time to live of photo
*/
inputMediaPhotoExternal#e5bbfe1a flags:# spoiler:flags.1?true url:string ttl_seconds:flags.0?int = InputMedia;

/*
Document that will be downloaded by the telegram servers

@spoiler Whether this media should be hidden behind a spoiler warning
@url URL of the document
@ttl_seconds Self-destruct time to live of document
@video_cover  ... 
@video_timestamp  ... 

#DocError
*/
inputMediaDocumentExternal#779600f9 flags:# spoiler:flags.1?true url:string ttl_seconds:flags.0?int video_cover:flags.2?InputPhoto video_timestamp:flags.3?int = InputMedia;

/*
A game

@id The game to forward
*/
inputMediaGame#d33f43f3 id:InputGame = InputMedia;

/*
Generated invoice of a [bot payment](https://core.telegram.org/bots/payments)

@title Product name, 1-32 characters
@description Product description, 1-255 characters
@photo URL of the product photo for the invoice. Can be a photo of the goods or a marketing image for a service. People like it better when they see what they are paying for.
@invoice The actual invoice
@payload Bot-defined invoice payload, 1-128 bytes. This will not be displayed to the user, use for your internal processes.
@provider Payments provider token, obtained via [Botfather](https://t.me/botfather)
@provider_data JSON-encoded data about the invoice, which will be shared with the payment provider. A detailed description of required fields should be provided by the payment provider.
@start_param Unique [bot deep links start parameter](https://core.telegram.org/api/links#bot-links). If present, forwarded copies of the sent message will have a URL button with a [deep link](https://core.telegram.org/api/links#bot-links) to the bot (instead of a Pay button), with the value used as the start parameter. If absent, forwarded copies of the sent message will have a Pay button, allowing multiple users to pay directly from the forwarded message, using the same invoice.
@extended_media Deprecated
*/
inputMediaInvoice#405fef0d flags:# title:string description:string photo:flags.0?InputWebDocument invoice:Invoice payload:bytes provider:flags.3?string provider_data:DataJSON start_param:flags.1?string extended_media:flags.2?InputMedia = InputMedia;

/*
[Live geolocation](https://core.telegram.org/api/live-location)

@stopped Whether sending of the geolocation was stopped
@geo_point Current geolocation
@heading For [live locations](https://core.telegram.org/api/live-location), a direction in which the location moves, in degrees; 1-360.
@period Validity period of the current location
@proximity_notification_radius For [live locations](https://core.telegram.org/api/live-location), a maximum distance to another chat member for proximity alerts, in meters (0-100000)
*/
inputMediaGeoLive#971fa843 flags:# stopped:flags.0?true geo_point:InputGeoPoint heading:flags.2?int period:flags.1?int proximity_notification_radius:flags.3?int = InputMedia;

/*
A poll

@poll The poll to send
@correct_answers Correct answer IDs (for quiz polls)
@solution Explanation of quiz solution
@solution_entities [Message entities for styled text](https://core.telegram.org/api/entities)
*/
inputMediaPoll#f94e5f1 flags:# poll:Poll correct_answers:flags.0?Vector<bytes> solution:flags.1?string solution_entities:flags.1?Vector<MessageEntity> = InputMedia;

/*
Send a [dice-based animated sticker](https://core.telegram.org/api/dice)

@emoticon The emoji, for now ,  and  are supported
*/
inputMediaDice#e66fbf7b emoticon:string = InputMedia;

/*
Forwarded story

@peer Peer where the story was posted
@id Story ID
*/
inputMediaStory#89fdd778 peer:InputPeer id:int = InputMedia;

/*
Specifies options that will be used to generate the link preview for the caption, or even a standalone link preview without an attached message.

@force_large_media If set, specifies that a large media preview should be used.
@force_small_media If set, specifies that a small media preview should be used.
@optional If not set, a WEBPAGE_NOT_FOUND RPC error will be emitted if a webpage preview cannot be generated for the specified url; otherwise, no error will be emitted (unless the provided message is also empty, in which case a MESSAGE_EMPTY will be emitted, instead).
@url The URL to use for the link preview.
*/
inputMediaWebPage#c21b8849 flags:# force_large_media:flags.0?true force_small_media:flags.1?true optional:flags.2?true url:string = InputMedia;

/*
[Paid media, see here](https://core.telegram.org/api/paid-media) for more info.

@stars_amount The price of the media in [Telegram Stars](https://core.telegram.org/api/stars).
@extended_media Photos or videos.
@payload Bots only, specifies a custom payload that will then be passed in [updateBotPurchasedPaidMedia](https://core.telegram.org/constructor/updateBotPurchasedPaidMedia) when a payment is made (this field will not be visible to the user)
*/
inputMediaPaidMedia#c4103386 flags:# stars_amount:long extended_media:Vector<InputMedia> payload:flags.0?string = InputMedia;

/*
Empty constructor, remove group photo.
*/
inputChatPhotoEmpty#1ca48f57 = InputChatPhoto;

/*
New photo to be set as group profile photo.

@file File saved in parts using the method [upload.saveFilePart](https://core.telegram.org/method/upload.saveFilePart)
@video Square video for animated profile picture
@video_start_ts Floating point UNIX timestamp in seconds, indicating the frame of the video/sticker that should be used as static preview; can only be used if video or video_emoji_markup is set.
@video_emoji_markup Animated sticker profile picture, must contain either a [videoSizeEmojiMarkup](https://core.telegram.org/constructor/videoSizeEmojiMarkup) or a [videoSizeStickerMarkup](https://core.telegram.org/constructor/videoSizeStickerMarkup) constructor.
*/
inputChatUploadedPhoto#bdcdaec0 flags:# file:flags.0?InputFile video:flags.1?InputFile video_start_ts:flags.2?double video_emoji_markup:flags.3?VideoSize = InputChatPhoto;

/*
Existing photo to be set as a chat profile photo.

@id Existing photo
*/
inputChatPhoto#8953ad37 id:InputPhoto = InputChatPhoto;

/*
Empty GeoPoint constructor.
*/
inputGeoPointEmpty#e4c123d6 = InputGeoPoint;

/*
Defines a GeoPoint by its coordinates.

@lat Latitude
@long Longitude
@accuracy_radius The estimated horizontal accuracy of the location, in meters; as defined by the sender.
*/
inputGeoPoint#48222faf flags:# lat:double long:double accuracy_radius:flags.0?int = InputGeoPoint;

/*
Empty constructor.
*/
inputPhotoEmpty#1cd7bf0d = InputPhoto;

/*
Defines a photo for further interaction.

@id Photo identifier
@access_hash access_hash value from the [photo](https://core.telegram.org/constructor/photo) constructor
@file_reference [File reference](https://core.telegram.org/api/file_reference)
*/
inputPhoto#3bb3b94a id:long access_hash:long file_reference:bytes = InputPhoto;

/*
DEPRECATED location of a photo

@volume_id Server volume
@local_id File identifier
@secret Check sum to access the file
@file_reference [File reference](https://core.telegram.org/api/file_reference)
*/
inputFileLocation#dfdaabe1 volume_id:long local_id:int secret:long file_reference:bytes = InputFileLocation;

/*
Location of encrypted secret chat file.

@id File ID, id parameter value from [encryptedFile](https://core.telegram.org/constructor/encryptedFile)
@access_hash Checksum, access_hash parameter value from [encryptedFile](https://core.telegram.org/constructor/encryptedFile)
*/
inputEncryptedFileLocation#f5235d55 id:long access_hash:long = InputFileLocation;

/*
Document location (video, voice, audio, basically every type except photo)

@id Document ID
@access_hash access_hash parameter from the [document](https://core.telegram.org/constructor/document) constructor
@file_reference [File reference](https://core.telegram.org/api/file_reference)
@thumb_size Thumbnail size to download the thumbnail
*/
inputDocumentFileLocation#bad07584 id:long access_hash:long file_reference:bytes thumb_size:string = InputFileLocation;

/*
Location of encrypted telegram [passport](https://core.telegram.org/passport) file.

@id File ID, id parameter value from [secureFile](https://core.telegram.org/constructor/secureFile)
@access_hash Checksum, access_hash parameter value from [secureFile](https://core.telegram.org/constructor/secureFile)
*/
inputSecureFileLocation#cbc7ee28 id:long access_hash:long = InputFileLocation;

/*
Used to download a JSON file that will contain all personal data related to features that do not have a specialized [takeout method](https://core.telegram.org/api/takeout) yet, see [here](https://core.telegram.org/api/takeout) for more info on the takeout API.
*/
inputTakeoutFileLocation#29be5899 = InputFileLocation;

/*
Use this object to download a photo with [upload.getFile](https://core.telegram.org/method/upload.getFile) method

@id Photo ID, obtained from the [photo](https://core.telegram.org/constructor/photo) object
@access_hash Photo's access hash, obtained from the [photo](https://core.telegram.org/constructor/photo) object
@file_reference [File reference](https://core.telegram.org/api/file_reference)
@thumb_size The [PhotoSize](https://core.telegram.org/type/PhotoSize) to download: must be set to the type field of the desired PhotoSize object of the [photo](https://core.telegram.org/constructor/photo)
*/
inputPhotoFileLocation#40181ffe id:long access_hash:long file_reference:bytes thumb_size:string = InputFileLocation;

/*
DEPRECATED legacy photo file location

@id Photo ID
@access_hash Access hash
@file_reference File reference
@volume_id Volume ID
@local_id Local ID
@secret Secret
*/
inputPhotoLegacyFileLocation#d83466f3 id:long access_hash:long file_reference:bytes volume_id:long local_id:int secret:long = InputFileLocation;

/*
Location of profile photo of channel/group/supergroup/user

@big Whether to download the high-quality version of the picture
@peer The peer whose profile picture should be downloaded
@photo_id Photo ID
*/
inputPeerPhotoFileLocation#37257e99 flags:# big:flags.0?true peer:InputPeer photo_id:long = InputFileLocation;

/*
Location of stickerset thumbnail (see [files](https://core.telegram.org/api/files))

@stickerset Sticker set
@thumb_version Thumbnail version
*/
inputStickerSetThumb#9d84f3db stickerset:InputStickerSet thumb_version:int = InputFileLocation;

/*
Chunk of a livestream

@call Livestream info
@time_ms Timestamp in milliseconds
@scale Specifies the duration of the video segment to fetch in milliseconds, by bitshifting 1000 to the right scale times: duration_ms := 1000 >> scale
@video_channel Selected video channel
@video_quality Selected video quality (0 = lowest, 1 = medium, 2 = best)
*/
inputGroupCallStream#598a92a flags:# call:InputGroupCall time_ms:long scale:int video_channel:flags.0?int video_quality:flags.0?int = InputFileLocation;

/*
Chat partner

@user_id User identifier
*/
peerUser#59511722 user_id:long = Peer;

/*
Group.

@chat_id Group identifier
*/
peerChat#36c6019a chat_id:long = Peer;

/*
Channel/supergroup

@channel_id Channel ID
*/
peerChannel#a2a5371e channel_id:long = Peer;

/*
Unknown type.
*/
storage.fileUnknown#aa963b05 = storage.FileType;

/*
Part of a bigger file.
*/
storage.filePartial#40bc6f52 = storage.FileType;

/*
JPEG image. MIME type: image/jpeg.
*/
storage.fileJpeg#7efe0e = storage.FileType;

/*
GIF image. MIME type: image/gif.
*/
storage.fileGif#cae1aadf = storage.FileType;

/*
PNG image. MIME type: image/png.
*/
storage.filePng#a4f63c0 = storage.FileType;

/*
PDF document image. MIME type: application/pdf.
*/
storage.filePdf#ae1e508d = storage.FileType;

/*
Mp3 audio. MIME type: audio/mpeg.
*/
storage.fileMp3#528a0677 = storage.FileType;

/*
Quicktime video. MIME type: video/quicktime.
*/
storage.fileMov#4b09ebbc = storage.FileType;

/*
MPEG-4 video. MIME type: video/mp4.
*/
storage.fileMp4#b3cea0e4 = storage.FileType;

/*
WEBP image. MIME type: image/webp.
*/
storage.fileWebp#1081464c = storage.FileType;

/*
Empty constructor, non-existent user.

@id User identifier or 0
*/
userEmpty#d3bc4b7a id:long = User;

/*
Indicates info about a certain user.

@self Whether this user indicates the currently logged in user
@contact Whether this user is a contact When updating the [local peer database](https://core.telegram.org/api/peers), do not apply changes to this field if the min flag is set.
@mutual_contact Whether this user is a mutual contact. When updating the [local peer database](https://core.telegram.org/api/peers), do not apply changes to this field if the min flag is set.
@deleted Whether the account of this user was deleted. Changes to this flag should invalidate the local [userFull](https://core.telegram.org/constructor/userFull) cache for this user ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@bot Is this user a bot? Changes to this flag should invalidate the local [userFull](https://core.telegram.org/constructor/userFull) cache for this user ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@bot_chat_history Can the bot see all messages in groups?
@bot_nochats Can the bot be added to groups?
@verified Whether this user is verified
@restricted Access to this user must be restricted for the reason specified in restriction_reason
@min See [min](https://core.telegram.org/api/min)
@bot_inline_geo Whether the bot can request our geolocation in inline mode
@support Whether this is an official support user
@scam This may be a scam user
@apply_min_photo If set and min is set, the value of photo can be used to update the local database, see the documentation of that flag for more info.
@fake If set, this user was reported by many users as a fake or scam user: be careful when interacting with them.
@bot_attach_menu Whether this bot offers an [attachment menu web app](https://core.telegram.org/api/bots/attach)
@premium Whether this user is a Telegram Premium user Changes to this flag should invalidate the local [userFull](https://core.telegram.org/constructor/userFull) cache for this user ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info. Changes to this flag if the self flag is set should also trigger the following calls, to refresh the respective caches: - The [help.getConfig](https://core.telegram.org/method/help.getConfig) cache - The [messages.getTopReactions](https://core.telegram.org/method/messages.getTopReactions) cache if the bot flag is not set
@attach_menu_enabled Whether we installed the [attachment menu web app](https://core.telegram.org/api/bots/attach) offered by this bot. When updating the [local peer database](https://core.telegram.org/api/peers), do not apply changes to this field if the min flag is set.
@bot_can_edit Whether we can edit the profile picture, name, about text and description of this bot because we own it. When updating the [local peer database](https://core.telegram.org/api/peers), do not apply changes to this field if the min flag is set. Changes to this flag (if min is not set) should invalidate the local [userFull](https://core.telegram.org/constructor/userFull) cache for this user ID.
@close_friend Whether we marked this user as a [close friend, see here  for more info](https://core.telegram.org/api/privacy). When updating the [local peer database](https://core.telegram.org/api/peers), do not apply changes to this field if the min flag is set.
@stories_hidden Whether we have [hidden](https://core.telegram.org/api/stories#hiding-stories-of-other-users) all active stories of this user. When updating the [local peer database](https://core.telegram.org/api/peers), do not apply changes to this field if the min flag is set.
@stories_unavailable No stories from this user are visible.
@contact_require_premium If set, we can only write to this user if they have already sent some messages to us, if we are subscribed to [Telegram Premium](https://core.telegram.org/api/premium), or if they're a mutual contact ( [user](https://core.telegram.org/constructor/user). mutual_contact).  All the secondary conditions listed above must be checked separately to verify whether we can still write to the user, even if this flag is set (i.e. a mutual contact will have this flag set even if we can still write to them, and so on...); to avoid doing these extra checks if we haven't yet cached all the required information (for example while displaying the chat list in the sharing UI) the [users.getIsPremiumRequiredToContact](https://core.telegram.org/method/users.getIsPremiumRequiredToContact) method may be invoked instead, passing the list of users currently visible in the UI, returning a list of booleans that directly specify whether we can or cannot write to each user; alternatively, the [userFull](https://core.telegram.org/constructor/userFull). contact_require_premium flag contains the same (fully checked, i.e. it's not just a copy of this flag) info returned by [users.getIsPremiumRequiredToContact](https://core.telegram.org/method/users.getIsPremiumRequiredToContact). To set this flag for ourselves invoke [account.setGlobalPrivacySettings](https://core.telegram.org/method/account.setGlobalPrivacySettings), setting the settings.new_noncontact_peers_require_premium flag.
@bot_business Whether this bot can be [connected to a user as specified here](https://core.telegram.org/api/business#connected-bots).
@bot_has_main_app If set, this bot has configured a [Main Mini App](https://core.telegram.org/api/bots/webapps#main-mini-apps).
@id ID of the user, see [here](https://core.telegram.org/api/peers#peer-id) for more info.
@access_hash Access hash of the user, see [here](https://core.telegram.org/api/peers#access-hash) for more info. If this flag is set, when updating the [local peer database](https://core.telegram.org/api/peers), generate a virtual flag called min_access_hash, which is: - Set to true if min is set AND -- The phone flag is not set OR -- The phone flag is set and the associated phone number string is non-empty - Set to false otherwise. Then, apply both access_hash and min_access_hash to the local database if: - min_access_hash is false OR - min_access_hash is true AND -- There is no locally cached object for this user OR -- There is no access_hash in the local cache OR -- The cached object's min_access_hash is also true If the final merged object stored to the database has the min_access_hash field set to true, the related access_hash is only suitable to use in [inputPeerPhotoFileLocation](https://core.telegram.org/constructor/inputPeerPhotoFileLocation), to directly [download the profile pictures](https://core.telegram.org/api/files) of users, everywhere else a inputPeer*FromMessage constructor will have to be generated as specified [here](https://core.telegram.org/api/min). Bots can also use min access hashes in some conditions, by passing 0 instead of the min access hash.
@first_name First name. When updating the [local peer database](https://core.telegram.org/api/peers), apply changes to this field only if: - The min flag is not set OR - The min flag is set AND -- The min flag of the locally cached user entry is set.
@last_name Last name. When updating the [local peer database](https://core.telegram.org/api/peers), apply changes to this field only if: - The min flag is not set OR - The min flag is set AND -- The min flag of the locally cached user entry is set.
@username Main active username. When updating the [local peer database](https://core.telegram.org/api/peers), apply changes to this field only if: - The min flag is not set OR - The min flag is set AND -- The min flag of the locally cached user entry is set. Changes to this flag should invalidate the local [userFull](https://core.telegram.org/constructor/userFull) cache for this user ID if the above conditions are respected and the bot_can_edit flag is also set.
@phone Phone number. When updating the [local peer database](https://core.telegram.org/api/peers), apply changes to this field only if: - The min flag is not set OR - The min flag is set AND -- The min flag of the locally cached user entry is set.
@photo Profile picture of user. When updating the [local peer database](https://core.telegram.org/api/peers), apply changes to this field only if: - The min flag is not set OR - The min flag is set AND -- The apply_min_photo flag is set OR -- The min flag of the locally cached user entry is set.
@status Online status of user. When updating the [local peer database](https://core.telegram.org/api/peers), apply changes to this field only if: - The min flag is not set OR - The min flag is set AND -- The min flag of the locally cached user entry is set OR -- The locally cached user entry is equal to [userStatusEmpty](https://core.telegram.org/constructor/userStatusEmpty).
@bot_info_version Version of the [bot_info field in userFull](https://core.telegram.org/constructor/userFull), incremented every time it changes. Changes to this flag should invalidate the local [userFull](https://core.telegram.org/constructor/userFull) cache for this user ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@restriction_reason Contains the reason why access to this user must be restricted.
@bot_inline_placeholder Inline placeholder for this inline bot
@lang_code Language code of the user
@emoji_status [Emoji status](https://core.telegram.org/api/emoji-status)
@usernames Additional usernames. When updating the [local peer database](https://core.telegram.org/api/peers), apply changes to this field only if: - The min flag is not set OR - The min flag is set AND -- The min flag of the locally cached user entry is set. Changes to this flag (if the above conditions are respected) should invalidate the local [userFull](https://core.telegram.org/constructor/userFull) cache for this user ID.
@stories_max_id ID of the maximum read [story](https://core.telegram.org/api/stories).  When updating the [local peer database](https://core.telegram.org/api/peers), do not apply changes to this field if the min flag of the incoming constructor is set.
@color The user's [accent color](https://core.telegram.org/api/colors).
@profile_color The user's [profile color](https://core.telegram.org/api/colors).
@bot_active_users Monthly Active Users (MAU) of this bot (may be absent for small bots).
@bot_verification_icon  ... 

#DocError
*/
user#4b46c37e flags:# self:flags.10?true contact:flags.11?true mutual_contact:flags.12?true deleted:flags.13?true bot:flags.14?true bot_chat_history:flags.15?true bot_nochats:flags.16?true verified:flags.17?true restricted:flags.18?true min:flags.20?true bot_inline_geo:flags.21?true support:flags.23?true scam:flags.24?true apply_min_photo:flags.25?true fake:flags.26?true bot_attach_menu:flags.27?true premium:flags.28?true attach_menu_enabled:flags.29?true flags2:# bot_can_edit:flags2.1?true close_friend:flags2.2?true stories_hidden:flags2.3?true stories_unavailable:flags2.4?true contact_require_premium:flags2.10?true bot_business:flags2.11?true bot_has_main_app:flags2.13?true id:long access_hash:flags.0?long first_name:flags.1?string last_name:flags.2?string username:flags.3?string phone:flags.4?string photo:flags.5?UserProfilePhoto status:flags.6?UserStatus bot_info_version:flags.14?int restriction_reason:flags.18?Vector<RestrictionReason> bot_inline_placeholder:flags.19?string lang_code:flags.22?string emoji_status:flags.30?EmojiStatus usernames:flags2.0?Vector<Username> stories_max_id:flags2.5?int color:flags2.8?PeerColor profile_color:flags2.9?PeerColor bot_active_users:flags2.12?int bot_verification_icon:flags2.14?long = User;

/*
Profile photo has not been set, or was hidden.
*/
userProfilePhotoEmpty#4f11bae1 = UserProfilePhoto;

/*
User profile photo.

@has_video Whether an [animated profile picture](https://core.telegram.org/api/files#animated-profile-pictures) is available for this user
@personal Whether this profile photo is only visible to us (i.e. it was set using [photos.uploadContactProfilePhoto](https://core.telegram.org/method/photos.uploadContactProfilePhoto)).
@photo_id Identifier of the respective photo
@stripped_thumb [Stripped thumbnail](https://core.telegram.org/api/files#stripped-thumbnails)
@dc_id DC ID where the photo is stored
*/
userProfilePhoto#82d1f706 flags:# has_video:flags.0?true personal:flags.2?true photo_id:long stripped_thumb:flags.1?bytes dc_id:int = UserProfilePhoto;

/*
User status has not been set yet.
*/
userStatusEmpty#9d05049 = UserStatus;

/*
Online status of the user.

@expires Time to expiration of the current online status
*/
userStatusOnline#edb93949 expires:int = UserStatus;

/*
The user's offline status.

@was_online Time the user was last seen online
*/
userStatusOffline#8c703f was_online:int = UserStatus;

/*
Online status: last seen recently

@by_me If set, the exact user status of this user is actually available to us, but to view it we must first purchase a [Premium](https://core.telegram.org/api/premium) subscription, or allow this user to see our exact last online status. See [here](https://core.telegram.org/constructor/privacyKeyStatusTimestamp) for more info.
*/
userStatusRecently#7b197dc8 flags:# by_me:flags.0?true = UserStatus;

/*
Online status: last seen last week

@by_me If set, the exact user status of this user is actually available to us, but to view it we must first purchase a [Premium](https://core.telegram.org/api/premium) subscription, or allow this user to see our exact last online status. See [here](https://core.telegram.org/constructor/privacyKeyStatusTimestamp) for more info.
*/
userStatusLastWeek#541a1d1a flags:# by_me:flags.0?true = UserStatus;

/*
Online status: last seen last month

@by_me If set, the exact user status of this user is actually available to us, but to view it we must first purchase a [Premium](https://core.telegram.org/api/premium) subscription, or allow this user to see our exact last online status. See [here](https://core.telegram.org/constructor/privacyKeyStatusTimestamp) for more info.
*/
userStatusLastMonth#65899777 flags:# by_me:flags.0?true = UserStatus;

/*
Empty constructor, group doesn't exist

@id Group identifier
*/
chatEmpty#29562865 id:long = Chat;

/*
Info about a group.

@creator Whether the current user is the creator of the group
@left Whether the current user has left the group
@deactivated Whether the group was [migrated](https://core.telegram.org/api/channel)
@call_active Whether a group call is currently active
@call_not_empty Whether there's anyone in the group call
@noforwards Whether this group is [protected](https://telegram.org/blog/protected-content-delete-by-date-and-more), thus does not allow forwarding messages from it
@id ID of the group, see [here](https://core.telegram.org/api/peers#peer-id) for more info
@title Title
@photo Chat photo
@participants_count Participant count
@date Date of creation of the group
@version Used in basic groups to reorder updates and make sure that all of them were received.
@migrated_to Means this chat was [upgraded](https://core.telegram.org/api/channel) to a supergroup
@admin_rights [Admin rights](https://core.telegram.org/api/rights) of the user in the group
@default_banned_rights [Default banned rights](https://core.telegram.org/api/rights) of all users in the group
*/
chat#41cbf256 flags:# creator:flags.0?true left:flags.2?true deactivated:flags.5?true call_active:flags.23?true call_not_empty:flags.24?true noforwards:flags.25?true id:long title:string photo:ChatPhoto participants_count:int date:int version:int migrated_to:flags.6?InputChannel admin_rights:flags.14?ChatAdminRights default_banned_rights:flags.18?ChatBannedRights = Chat;

/*
A group to which the user has no access. E.g., because the user was kicked from the group.

@id User identifier
@title Group name
*/
chatForbidden#6592a1a7 id:long title:string = Chat;

/*
Channel/supergroup info

@creator Whether the current user is the creator of this channel
@left Whether the current user has left or is not a member of this channel
@broadcast Is this a channel?
@verified Is this channel verified by telegram?
@megagroup Is this a supergroup? Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@restricted Whether viewing/writing in this channel for a reason (see restriction_reason)
@signatures Whether signatures are enabled (channels)
@min See [min](https://core.telegram.org/api/min)
@scam This channel/supergroup is probably a scam Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@has_link Whether this channel has a linked [discussion group](https://core.telegram.org/api/discussion) (or this supergroup is a channel's discussion group). The actual ID of the linked channel/supergroup is contained in [channelFull](https://core.telegram.org/constructor/channelFull). linked_chat_id. Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@has_geo Whether this chanel has a geoposition
@slowmode_enabled Whether slow mode is enabled for groups to prevent flood in chat. Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@call_active Whether a group call or livestream is currently active
@call_not_empty Whether there's anyone in the group call or livestream
@fake If set, this [supergroup/channel](https://core.telegram.org/api/channel) was reported by many users as a fake or scam: be careful when interacting with it. Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@gigagroup Whether this [supergroup](https://core.telegram.org/api/channel) is a gigagroup Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@noforwards Whether this channel or group is [protected](https://telegram.org/blog/protected-content-delete-by-date-and-more), thus does not allow forwarding messages from it
@join_to_send Whether a user needs to join the supergroup before they can send messages: can be false only for [discussion groups](https://core.telegram.org/api/discussion), toggle using [channels.toggleJoinToSend](https://core.telegram.org/method/channels.toggleJoinToSend) Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@join_request Whether a user's join request will have to be [approved by administrators](https://core.telegram.org/api/invites#join-requests), toggle using [channels.toggleJoinToSend](https://core.telegram.org/method/channels.toggleJoinRequest) Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@forum Whether this supergroup is a [forum](https://core.telegram.org/api/forum). Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@flags2  ... 
@stories_hidden Whether we have [hidden all stories posted by this channel](https://core.telegram.org/api/stories#hiding-stories-of-other-users).
@stories_hidden_min If set, indicates that the stories_hidden flag was not populated, and its value must cannot be relied on; use the previously cached value, or re-fetch the constructor using [channels.getChannels](https://core.telegram.org/method/channels.getChannels) to obtain the latest value of the stories_hidden flag.
@stories_unavailable No stories from the channel are visible.
@signature_profiles If set, messages sent by admins to this channel will link to the admin's profile (just like with groups).
@id ID of the channel, see [here](https://core.telegram.org/api/peers#peer-id) for more info
@access_hash Access hash, see [here](https://core.telegram.org/api/peers#access-hash) for more info
@title Title
@username Main active username.
@photo Profile photo
@date Date when the user joined the supergroup/channel, or if the user isn't a member, its creation date
@restriction_reason Contains the reason why access to this channel must be restricted. Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@admin_rights Admin rights of the user in this channel (see [rights](https://core.telegram.org/api/rights))
@banned_rights Banned rights of the user in this channel (see [rights](https://core.telegram.org/api/rights))
@default_banned_rights Default chat rights (see [rights](https://core.telegram.org/api/rights))
@participants_count Participant count
@usernames Additional usernames
@stories_max_id ID of the maximum read [story](https://core.telegram.org/api/stories).
@color The channel's [accent color](https://core.telegram.org/api/colors).
@profile_color The channel's [profile color](https://core.telegram.org/api/colors).
@emoji_status [Emoji status](https://core.telegram.org/api/emoji-status)
@level [Boost level](https://core.telegram.org/api/boost). Changes to this flag should invalidate the local [channelFull](https://core.telegram.org/constructor/channelFull) cache for this channel/supergroup ID, see [here](https://core.telegram.org/api/peers#full-info-database) for more info.
@subscription_until_date Expiration date of the [Telegram Star subscription](https://core.telegram.org/api/stars#star-subscriptions) the current user has bought to gain access to this channel.
@bot_verification_icon  ... 

#DocError
*/
channel#e00998b7 flags:# creator:flags.0?true left:flags.2?true broadcast:flags.5?true verified:flags.7?true megagroup:flags.8?true restricted:flags.9?true signatures:flags.11?true min:flags.12?true scam:flags.19?true has_link:flags.20?true has_geo:flags.21?true slowmode_enabled:flags.22?true call_active:flags.23?true call_not_empty:flags.24?true fake:flags.25?true gigagroup:flags.26?true noforwards:flags.27?true join_to_send:flags.28?true join_request:flags.29?true forum:flags.30?true flags2:# stories_hidden:flags2.1?true stories_hidden_min:flags2.2?true stories_unavailable:flags2.3?true signature_profiles:flags2.12?true id:long access_hash:flags.13?long title:string username:flags.6?string photo:ChatPhoto date:int restriction_reason:flags.9?Vector<RestrictionReason> admin_rights:flags.14?ChatAdminRights banned_rights:flags.15?ChatBannedRights default_banned_rights:flags.18?ChatBannedRights participants_count:flags.17?int usernames:flags2.0?Vector<Username> stories_max_id:flags2.4?int color:flags2.7?PeerColor profile_color:flags2.8?PeerColor emoji_status:flags2.9?EmojiStatus level:flags2.10?int subscription_until_date:flags2.11?int bot_verification_icon:flags2.13?long = Chat;

/*
Indicates a channel/supergroup we can't access because we were banned, or for some other reason.

@broadcast Is this a channel
@megagroup Is this a supergroup
@id Channel ID
@access_hash Access hash
@title Title
@until_date The ban is valid until the specified date
*/
channelForbidden#17d493d5 flags:# broadcast:flags.5?true megagroup:flags.8?true id:long access_hash:long title:string until_date:flags.16?int = Chat;

/*
Full info about a [basic group](https://core.telegram.org/api/channel#basic-groups).

@can_set_username Can we change the username of this chat
@has_scheduled Whether [scheduled messages](https://core.telegram.org/api/scheduled-messages) are available
@translations_disabled Whether the [real-time chat translation popup](https://core.telegram.org/api/translation) should be hidden.
@id ID of the chat
@about About string for this chat
@participants Participant list
@chat_photo Chat photo
@notify_settings Notification settings
@exported_invite Chat invite
@bot_info Info about bots that are in this chat
@pinned_msg_id Message ID of the last [pinned message](https://core.telegram.org/api/pin)
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@call Group call information
@ttl_period Time-To-Live of messages sent by the current user to this chat
@groupcall_default_join_as When using [phone.getGroupCallJoinAs](https://core.telegram.org/method/phone.getGroupCallJoinAs) to get a list of peers that can be used to join a group call, this field indicates the peer that should be selected by default.
@theme_emoticon Emoji representing a specific chat theme
@requests_pending Pending [join requests](https://core.telegram.org/api/invites#join-requests)
@recent_requesters IDs of users who requested to join recently
@available_reactions Allowed [message reactions](https://core.telegram.org/api/reactions)
@reactions_limit This flag may be used to impose a custom limit of unique reactions (i.e. a customizable version of [appConfig.reactions_uniq_max](https://core.telegram.org/api/config#reactions-uniq-max)).
*/
chatFull#2633421b flags:# can_set_username:flags.7?true has_scheduled:flags.8?true translations_disabled:flags.19?true id:long about:string participants:ChatParticipants chat_photo:flags.2?Photo notify_settings:PeerNotifySettings exported_invite:flags.13?ExportedChatInvite bot_info:flags.3?Vector<BotInfo> pinned_msg_id:flags.6?int folder_id:flags.11?int call:flags.12?InputGroupCall ttl_period:flags.14?int groupcall_default_join_as:flags.15?Peer theme_emoticon:flags.16?string requests_pending:flags.17?int recent_requesters:flags.17?Vector<long> available_reactions:flags.18?ChatReactions reactions_limit:flags.20?int = ChatFull;

/*
Full info about a [channel](https://core.telegram.org/api/channel#channels), [supergroup](https://core.telegram.org/api/channel#supergroups) or [gigagroup](https://core.telegram.org/api/channel#gigagroups).

@can_view_participants Can we view the participant list?
@can_set_username Can we set the channel's username?
@can_set_stickers Can we [associate](https://core.telegram.org/method/channels.setStickers) a stickerpack to the supergroup?
@hidden_prehistory Is the history before we joined hidden to us?
@can_set_location Can we set the geolocation of this group (for geogroups)
@has_scheduled Whether scheduled messages are available
@can_view_stats Can the user view [channel/supergroup statistics](https://core.telegram.org/api/stats)
@blocked Whether any anonymous admin of this supergroup was blocked: if set, you won't receive messages from anonymous group admins in [discussion replies via @replies](https://core.telegram.org/api/discussion)
@flags2  ... 
@can_delete_channel Can we delete this channel?
@antispam Whether [native antispam](https://core.telegram.org/api/antispam) functionality is enabled in this supergroup.
@participants_hidden Whether the participant list is hidden.
@translations_disabled Whether the [real-time chat translation popup](https://core.telegram.org/api/translation) should be hidden.
@stories_pinned_available Whether this user has some [pinned stories](https://core.telegram.org/api/stories#pinned-or-archived-stories).
@view_forum_as_messages Users may also choose to display messages from all topics of a [forum](https://core.telegram.org/api/forum) as if they were sent to a normal group, using a "View as messages" setting in the local client.  This setting only affects the current account, and is synced to other logged in sessions using the [channels.toggleViewForumAsMessages](https://core.telegram.org/method/channels.toggleViewForumAsMessages) method; invoking this method will update the value of this flag.
@restricted_sponsored Whether ads on this channel were [disabled as specified here](https://core.telegram.org/api/boost#disable-ads-on-the-channel) (this flag is only visible to the owner of the channel).
@can_view_revenue If set, this user can view [ad revenue statistics](https://core.telegram.org/api/revenue#revenue-statistics) for this channel.
@paid_media_allowed Whether the current user can send or forward [paid media](https://core.telegram.org/api/paid-media) to this channel.
@can_view_stars_revenue If set, this user can view [Telegram Star revenue statistics](https://core.telegram.org/api/stars#revenue-statistics) for this channel.
@paid_reactions_available If set, users may send [paid Telegram Star reactions](https://core.telegram.org/api/reactions#paid-reactions) to messages of this channel.
@stargifts_available  ... 
@id ID of the channel
@about Info about the channel
@participants_count Number of participants of the channel
@admins_count Number of channel admins
@kicked_count Number of users [kicked](https://core.telegram.org/api/rights) from the channel
@banned_count Number of users [banned](https://core.telegram.org/api/rights) from the channel
@online_count Number of users currently online
@read_inbox_max_id Position up to which all incoming messages are read.
@read_outbox_max_id Position up to which all outgoing messages are read.
@unread_count Count of unread messages
@chat_photo Channel picture
@notify_settings Notification settings
@exported_invite Invite link
@bot_info Info about bots in the channel/supergroup
@migrated_from_chat_id The chat ID from which this group was [migrated](https://core.telegram.org/api/channel)
@migrated_from_max_id The message ID in the original chat at which this group was [migrated](https://core.telegram.org/api/channel)
@pinned_msg_id Message ID of the last [pinned message](https://core.telegram.org/api/pin)
@stickerset Associated stickerset
@available_min_id Identifier of a maximum unavailable message in a channel due to hidden history.
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@linked_chat_id ID of the linked [discussion chat](https://core.telegram.org/api/discussion) for channels (and vice versa, the ID of the linked channel for discussion chats).
@location Location of the geogroup
@slowmode_seconds If specified, users in supergroups will only be able to send one message every slowmode_seconds seconds
@slowmode_next_send_date Indicates when the user will be allowed to send another message in the supergroup (unixtime)
@stats_dc If set, specifies the DC to use for fetching channel statistics
@pts Latest [PTS](https://core.telegram.org/api/updates) for this channel
@call Livestream or group call information
@ttl_period Time-To-Live of messages in this channel or supergroup
@pending_suggestions A list of [suggested actions](https://core.telegram.org/api/config#suggestions) for the supergroup admin, [see here for more info](https://core.telegram.org/api/config#suggestions).
@groupcall_default_join_as When using [phone.getGroupCallJoinAs](https://core.telegram.org/method/phone.getGroupCallJoinAs) to get a list of peers that can be used to join a group call, this field indicates the peer that should be selected by default.
@theme_emoticon Emoji representing a specific chat theme
@requests_pending Pending [join requests](https://core.telegram.org/api/invites#join-requests)
@recent_requesters IDs of users who requested to join recently
@default_send_as Default peer used for sending messages to this channel
@available_reactions Allowed [message reactions](https://core.telegram.org/api/reactions)
@reactions_limit This flag may be used to impose a custom limit of unique reactions (i.e. a customizable version of [appConfig.reactions_uniq_max](https://core.telegram.org/api/config#reactions-uniq-max)).
@stories Channel [stories](https://core.telegram.org/api/stories)
@wallpaper [Wallpaper](https://core.telegram.org/api/wallpapers)
@boosts_applied The number of [boosts](https://core.telegram.org/api/boost) the current user has applied to the current supergroup.
@boosts_unrestrict The number of [boosts](https://core.telegram.org/api/boost) this supergroup requires to bypass slowmode and other restrictions, see [here](https://core.telegram.org/api/boost#bypass-slowmode-and-chat-restrictions) for more info.
@emojiset [Custom emoji stickerset](https://core.telegram.org/api/custom-emoji) associated to the current supergroup, set using [channels.setEmojiStickers](https://core.telegram.org/method/channels.setEmojiStickers) after reaching the appropriate boost level, see [here](https://core.telegram.org/api/boost#setting-a-custom-emoji-stickerset-for-supergroups) for more info.
@bot_verification  ... 
@stargifts_count  ... 

#DocError
*/
channelFull#52d6806b flags:# can_view_participants:flags.3?true can_set_username:flags.6?true can_set_stickers:flags.7?true hidden_prehistory:flags.10?true can_set_location:flags.16?true has_scheduled:flags.19?true can_view_stats:flags.20?true blocked:flags.22?true flags2:# can_delete_channel:flags2.0?true antispam:flags2.1?true participants_hidden:flags2.2?true translations_disabled:flags2.3?true stories_pinned_available:flags2.5?true view_forum_as_messages:flags2.6?true restricted_sponsored:flags2.11?true can_view_revenue:flags2.12?true paid_media_allowed:flags2.14?true can_view_stars_revenue:flags2.15?true paid_reactions_available:flags2.16?true stargifts_available:flags2.19?true id:long about:string participants_count:flags.0?int admins_count:flags.1?int kicked_count:flags.2?int banned_count:flags.2?int online_count:flags.13?int read_inbox_max_id:int read_outbox_max_id:int unread_count:int chat_photo:Photo notify_settings:PeerNotifySettings exported_invite:flags.23?ExportedChatInvite bot_info:Vector<BotInfo> migrated_from_chat_id:flags.4?long migrated_from_max_id:flags.4?int pinned_msg_id:flags.5?int stickerset:flags.8?StickerSet available_min_id:flags.9?int folder_id:flags.11?int linked_chat_id:flags.14?long location:flags.15?ChannelLocation slowmode_seconds:flags.17?int slowmode_next_send_date:flags.18?int stats_dc:flags.12?int pts:int call:flags.21?InputGroupCall ttl_period:flags.24?int pending_suggestions:flags.25?Vector<string> groupcall_default_join_as:flags.26?Peer theme_emoticon:flags.27?string requests_pending:flags.28?int recent_requesters:flags.28?Vector<long> default_send_as:flags.29?Peer available_reactions:flags.30?ChatReactions reactions_limit:flags2.13?int stories:flags2.4?PeerStories wallpaper:flags2.7?WallPaper boosts_applied:flags2.8?int boosts_unrestrict:flags2.9?int emojiset:flags2.10?StickerSet bot_verification:flags2.17?BotVerification stargifts_count:flags2.18?int = ChatFull;

/*
Group member.

@user_id Member user ID
@inviter_id ID of the user that added the member to the group
@date Date added to the group
*/
chatParticipant#c02d4007 user_id:long inviter_id:long date:int = ChatParticipant;

/*
Represents the creator of the group

@user_id ID of the user that created the group
*/
chatParticipantCreator#e46bcee4 user_id:long = ChatParticipant;

/*
Chat admin

@user_id ID of a group member that is admin
@inviter_id ID of the user that added the member to the group
@date Date when the user was added
*/
chatParticipantAdmin#a0933f5b user_id:long inviter_id:long date:int = ChatParticipant;

/*
Info on members is unavailable

@chat_id Group ID
@self_participant Info about the group membership of the current user
*/
chatParticipantsForbidden#8763d3e1 flags:# chat_id:long self_participant:flags.0?ChatParticipant = ChatParticipants;

/*
Group members.

@chat_id Group identifier
@participants List of group members
@version Group version number
*/
chatParticipants#3cbc93f8 chat_id:long participants:Vector<ChatParticipant> version:int = ChatParticipants;

/*
Group photo is not set.
*/
chatPhotoEmpty#37c1011c = ChatPhoto;

/*
Group profile photo.

@has_video Whether the user has an animated profile picture
@photo_id Photo ID
@stripped_thumb [Stripped thumbnail](https://core.telegram.org/api/files#stripped-thumbnails)
@dc_id DC where this photo is stored
*/
chatPhoto#1c6e1c11 flags:# has_video:flags.0?true photo_id:long stripped_thumb:flags.1?bytes dc_id:int = ChatPhoto;

/*
Empty constructor, non-existent message.

@id Message identifier
@peer_id Peer ID, the chat where this message was sent
*/
messageEmpty#90a6ca84 flags:# id:int peer_id:flags.0?Peer = Message;

/*
A message

@out Is this an outgoing message
@mentioned Whether we were [mentioned](https://core.telegram.org/api/mentions) in this message
@media_unread Whether there are unread media attachments in this message
@silent Whether this is a silent message (no notification triggered)
@post Whether this is a channel post
@from_scheduled Whether this is a [scheduled message](https://core.telegram.org/api/scheduled-messages)
@legacy This is a legacy message: it has to be refetched with the new layer
@edit_hide Whether the message should be shown as not modified to the user, even if an edit date is present
@pinned Whether this message is [pinned](https://core.telegram.org/api/pin)
@noforwards Whether this message is [protected](https://telegram.org/blog/protected-content-delete-by-date-and-more) and thus cannot be forwarded; clients should also prevent users from saving attached media (i.e. videos should only be streamed, photos should be kept in RAM, et cetera).
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@flags2  ... 
@offline If set, the message was sent because of a scheduled action by the message sender, for example, as away, or a greeting service message.
@video_processing_pending The video contained in the message is currently being processed by the server (i.e. to generate alternative qualities, that will be contained in the final [messageMediaDocument](https://core.telegram.org/constructor/messageMediaDocument). alt_document), and will be sent once the video is processed, which will happen approximately at the specified date (i.e. messages with this flag set should be treated similarly to [scheduled messages](https://core.telegram.org/api/scheduled-messages), but instead of the scheduled date, date contains the estimated conversion date). See [here](https://core.telegram.org/api/files#video-qualities) for more info.
@id ID of the message
@from_id ID of the sender of the message
@from_boosts_applied Supergroups only, contains the number of [boosts](https://core.telegram.org/api/boost) this user has given the current supergroup, and should be shown in the UI in the header of the message. Only present for incoming messages from non-anonymous supergroup members that have boosted the supergroup. Note that this counter should be locally overridden for non-anonymous outgoing messages, according to the current value of [channelFull](https://core.telegram.org/constructor/channelFull). boosts_applied, to ensure the value is correct even for messages sent by the current user before a supergroup was boosted (or after a boost has expired or the number of boosts has changed); do not update this value for incoming messages from other users, even if their boosts have changed.
@peer_id Peer ID, the chat where this message was sent
@saved_peer_id Messages fetched from a [saved messages dialog](https://core.telegram.org/api/saved-messages) will have peer= [inputPeerSelf](https://core.telegram.org/constructor/inputPeerSelf) and the saved_peer_id flag set to the ID of the saved dialog.
@fwd_from Info about forwarded messages
@via_bot_id ID of the inline bot that generated the message
@via_business_bot_id Whether the message was sent by the [business bot](https://core.telegram.org/api/business#connected-bots) specified in via_bot_id on behalf of the user.
@reply_to Reply information
@date Date of the message
@message The message
@media Media attachment
@reply_markup Reply markup (bot/inline keyboards)
@entities Message [entities](https://core.telegram.org/api/entities) for styled text
@views View count for channel posts
@forwards Forward counter
@replies Info about [post comments (for channels) or message replies (for groups)](https://core.telegram.org/api/threads)
@edit_date Last edit date of this message
@post_author Name of the author of this message for channel posts (with signatures enabled)
@grouped_id Multiple media messages sent using [messages.sendMultiMedia](https://core.telegram.org/method/messages.sendMultiMedia) with the same grouped ID indicate an [album or media group](https://core.telegram.org/api/files#albums-grouped-media)
@reactions Reactions to this message
@restriction_reason Contains the reason why access to this message must be restricted.
@ttl_period Time To Live of the message, once message.date+message.ttl_period === time(), the message will be deleted on the server, and must be deleted locally as well.
@quick_reply_shortcut_id If set, this message is a [quick reply shortcut message](https://core.telegram.org/api/business#quick-reply-shortcuts) (note that quick reply shortcut messages sent to a private chat will not have this field set).
@effect A [message effect that should be played as specified here](https://core.telegram.org/api/effects).
@factcheck Represents a [fact-check](https://core.telegram.org/api/factcheck).
@report_delivery_until_date  ... 

#DocError
*/
message#96fdbbe9 flags:# out:flags.1?true mentioned:flags.4?true media_unread:flags.5?true silent:flags.13?true post:flags.14?true from_scheduled:flags.18?true legacy:flags.19?true edit_hide:flags.21?true pinned:flags.24?true noforwards:flags.26?true invert_media:flags.27?true flags2:# offline:flags2.1?true video_processing_pending:flags2.4?true id:int from_id:flags.8?Peer from_boosts_applied:flags.29?int peer_id:Peer saved_peer_id:flags.28?Peer fwd_from:flags.2?MessageFwdHeader via_bot_id:flags.11?long via_business_bot_id:flags2.0?long reply_to:flags.3?MessageReplyHeader date:int message:string media:flags.9?MessageMedia reply_markup:flags.6?ReplyMarkup entities:flags.7?Vector<MessageEntity> views:flags.10?int forwards:flags.10?int replies:flags.23?MessageReplies edit_date:flags.15?int post_author:flags.16?string grouped_id:flags.17?long reactions:flags.20?MessageReactions restriction_reason:flags.22?Vector<RestrictionReason> ttl_period:flags.25?int quick_reply_shortcut_id:flags.30?int effect:flags2.2?long factcheck:flags2.3?FactCheck report_delivery_until_date:flags2.5?int = Message;

/*
Indicates a service message

@out Whether the message is outgoing
@mentioned Whether we were mentioned in the message
@media_unread Whether the message contains unread media
@reactions_are_possible  ... 
@silent Whether the message is silent
@post Whether it's a channel post
@legacy This is a legacy message: it has to be refetched with the new layer
@id Message ID
@from_id ID of the sender of this message
@peer_id Sender of service message
@reply_to Reply (thread) information
@date Message date
@action Event connected with the service message
@reactions  ... 
@ttl_period Time To Live of the message, once message.date+message.ttl_period === time(), the message will be deleted on the server, and must be deleted locally as well.

#DocError
*/
messageService#d3d28540 flags:# out:flags.1?true mentioned:flags.4?true media_unread:flags.5?true reactions_are_possible:flags.9?true silent:flags.13?true post:flags.14?true legacy:flags.19?true id:int from_id:flags.8?Peer peer_id:Peer reply_to:flags.3?MessageReplyHeader date:int action:MessageAction reactions:flags.20?MessageReactions ttl_period:flags.25?int = Message;

/*
Empty constructor.
*/
messageMediaEmpty#3ded6320 = MessageMedia;

/*
Attached photo.

@spoiler Whether this media should be hidden behind a spoiler warning
@photo Photo
@ttl_seconds Time to live in seconds of self-destructing photo
*/
messageMediaPhoto#695150d7 flags:# spoiler:flags.3?true photo:flags.0?Photo ttl_seconds:flags.2?int = MessageMedia;

/*
Attached map.

@geo GeoPoint
*/
messageMediaGeo#56e0d474 geo:GeoPoint = MessageMedia;

/*
Attached contact.

@phone_number Phone number
@first_name Contact's first name
@last_name Contact's last name
@vcard VCARD of contact
@user_id User identifier or 0, if the user with the given phone number is not registered
*/
messageMediaContact#70322949 phone_number:string first_name:string last_name:string vcard:string user_id:long = MessageMedia;

/*
Current version of the client does not support this media type.
*/
messageMediaUnsupported#9f84f49e = MessageMedia;

/*
Document (video, audio, voice, sticker, any media type except photo)

@nopremium Whether this is a normal sticker, if not set this is a premium sticker and a premium sticker animation must be played.
@spoiler Whether this media should be hidden behind a spoiler warning
@video Whether this is a video.
@round Whether this is a round video.
@voice Whether this is a voice message.
@document Attached document
@alt_documents Videos only, contains alternative qualities of the video.
@video_cover  ... 
@video_timestamp  ... 
@ttl_seconds Time to live of self-destructing document

#DocError
*/
messageMediaDocument#52d8ccd9 flags:# nopremium:flags.3?true spoiler:flags.4?true video:flags.6?true round:flags.7?true voice:flags.8?true document:flags.0?Document alt_documents:flags.5?Vector<Document> video_cover:flags.9?Photo video_timestamp:flags.10?int ttl_seconds:flags.2?int = MessageMedia;

/*
Preview of webpage

@force_large_media If set, specifies that a large media preview should be used.
@force_small_media If set, specifies that a small media preview should be used.
@manual If set, indicates that the URL used for the webpage preview was specified manually using [inputMediaWebPage](https://core.telegram.org/constructor/inputMediaWebPage), and may not be related to any of the URLs specified in the message.
@safe If set, the webpage can be opened directly without user confirmation; otherwise, user confirmation is required, showing the exact URL that will be opened.
@webpage Webpage preview
*/
messageMediaWebPage#ddf10c3b flags:# force_large_media:flags.0?true force_small_media:flags.1?true manual:flags.3?true safe:flags.4?true webpage:WebPage = MessageMedia;

/*
Venue

@geo Geolocation of venue
@title Venue name
@address Address
@provider Venue provider: currently only "foursquare" and "gplaces" (Google Places) need to be supported
@venue_id Venue ID in the provider's database
@venue_type Venue type in the provider's database
*/
messageMediaVenue#2ec0533f geo:GeoPoint title:string address:string provider:string venue_id:string venue_type:string = MessageMedia;

/*
Telegram game

@game Game
*/
messageMediaGame#fdb19008 game:Game = MessageMedia;

/*
Invoice

@shipping_address_requested Whether the shipping address was requested
@test Whether this is an example invoice
@title Product name, 1-32 characters
@description Product description, 1-255 characters
@photo URL of the product photo for the invoice. Can be a photo of the goods or a marketing image for a service. People like it better when they see what they are paying for.
@receipt_msg_id Message ID of receipt: if set, clients should change the text of the first [keyboardButtonBuy](https://core.telegram.org/constructor/keyboardButtonBuy) button always attached to the [message](https://core.telegram.org/constructor/message) to a localized version of the word Receipt
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code, or XTR for [Telegram Stars](https://core.telegram.org/api/stars).
@total_amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@start_param Unique bot deep-linking parameter that can be used to generate this invoice
@extended_media Deprecated
*/
messageMediaInvoice#f6a548d3 flags:# shipping_address_requested:flags.1?true test:flags.3?true title:string description:string photo:flags.0?WebDocument receipt_msg_id:flags.2?int currency:string total_amount:long start_param:string extended_media:flags.4?MessageExtendedMedia = MessageMedia;

/*
Indicates a [live geolocation](https://core.telegram.org/api/live-location)

@geo Geolocation
@heading For [live locations](https://core.telegram.org/api/live-location), a direction in which the location moves, in degrees; 1-360
@period Validity period of provided geolocation
@proximity_notification_radius For [live locations](https://core.telegram.org/api/live-location), a maximum distance to another chat member for proximity alerts, in meters (0-100000).
*/
messageMediaGeoLive#b940c666 flags:# geo:GeoPoint heading:flags.0?int period:int proximity_notification_radius:flags.1?int = MessageMedia;

/*
Poll

@poll The poll
@results The results of the poll
*/
messageMediaPoll#4bd6e798 poll:Poll results:PollResults = MessageMedia;

/*
[Dice-based animated sticker](https://core.telegram.org/api/dice)

@value [Dice value](https://core.telegram.org/api/dice)
@emoticon The emoji, for now ,  and  are supported
*/
messageMediaDice#3f7ee58b value:int emoticon:string = MessageMedia;

/*
Represents a forwarded [story](https://core.telegram.org/api/stories) or a story mention.

@via_mention If set, indicates that this someone has mentioned us in this story (i.e. by tagging us in the description) or vice versa, we have mentioned the other peer (if the message is outgoing).
@peer Peer that posted the story.
@id Story ID
@story The story itself, if absent fetch it using [stories.getStoriesByID](https://core.telegram.org/method/stories.getStoriesByID) and the peer/ id parameters specified above.
*/
messageMediaStory#68cb6283 flags:# via_mention:flags.1?true peer:Peer id:int story:flags.0?StoryItem = MessageMedia;

/*
Contains info about a [giveaway, see here](https://core.telegram.org/api/giveaways) for more info.

@only_new_subscribers If set, only new subscribers starting from the giveaway creation date will be able to participate to the giveaway.
@winners_are_visible If set, giveaway winners are public and will be listed in a [messageMediaGiveawayResults](https://core.telegram.org/constructor/messageMediaGiveawayResults) message that will be automatically sent to the channel once the giveaway ends.
@channels The channels that the user must join to participate in the giveaway.
@countries_iso2 If set, only users residing in these countries can participate in the giveaway, (specified as a list of two-letter ISO 3166-1 alpha-2 country codes); otherwise there are no country-based limitations.
@prize_description Can contain a textual description of additional giveaway prizes.
@quantity Number of [Telegram Premium](https://core.telegram.org/api/premium) subscriptions given away.
@months Duration in months of each [Telegram Premium](https://core.telegram.org/api/premium) subscription in the giveaway.
@stars For [Telegram Star giveaways](https://core.telegram.org/api/stars#star-giveaways), the total number of Telegram Stars being given away.
@until_date The end date of the giveaway.
*/
messageMediaGiveaway#aa073beb flags:# only_new_subscribers:flags.0?true winners_are_visible:flags.2?true channels:Vector<long> countries_iso2:flags.1?Vector<string> prize_description:flags.3?string quantity:int months:flags.4?int stars:flags.5?long until_date:int = MessageMedia;

/*
A [giveaway](https://core.telegram.org/api/giveaways) with public winners has finished, this constructor contains info about the winners.

@only_new_subscribers If set, only new subscribers starting from the giveaway creation date participated in the giveaway.
@refunded If set, the giveaway was canceled and was fully refunded.
@channel_id ID of the channel/supergroup that was automatically [boosted](https://core.telegram.org/api/boost) by the winners of the giveaway for duration of the Premium subscription.
@additional_peers_count Number of other channels that participated in the giveaway.
@launch_msg_id Identifier of the message with the giveaway in channel_id.
@winners_count Total number of winners in the giveaway.
@unclaimed_count Number of not-yet-claimed prizes.
@winners Up to 100 user identifiers of the winners of the giveaway.
@months Duration in months of each [Telegram Premium](https://core.telegram.org/api/premium) subscription in the giveaway.
@stars For [Telegram Star giveaways](https://core.telegram.org/api/stars#star-giveaways), the total number of Telegram Stars being given away.
@prize_description Can contain a textual description of additional giveaway prizes.
@until_date Point in time (Unix timestamp) when the winners were selected. May be bigger than winners selection date specified in initial parameters of the giveaway.
*/
messageMediaGiveawayResults#ceaa3ea1 flags:# only_new_subscribers:flags.0?true refunded:flags.2?true channel_id:long additional_peers_count:flags.3?int launch_msg_id:int winners_count:int unclaimed_count:int winners:Vector<long> months:flags.4?int stars:flags.5?long prize_description:flags.1?string until_date:int = MessageMedia;

/*
[Paid media, see here](https://core.telegram.org/api/paid-media) for more info.

@stars_amount The price of the media in [Telegram Stars](https://core.telegram.org/api/stars).
@extended_media Either the paid-for media, or super low resolution media previews if the media wasn't purchased yet, [see here](https://core.telegram.org/api/paid-media#viewing-paid-media) for more info.
*/
messageMediaPaidMedia#a8852491 stars_amount:long extended_media:Vector<MessageExtendedMedia> = MessageMedia;

/*
Empty constructor.
*/
messageActionEmpty#b6aef7b0 = MessageAction;

/*
Group created

@title Group name
@users List of group members
*/
messageActionChatCreate#bd47cbad title:string users:Vector<long> = MessageAction;

/*
Group name changed.

@title New group name
*/
messageActionChatEditTitle#b5a1ce5a title:string = MessageAction;

/*
Group profile changed

@photo New group profile photo
*/
messageActionChatEditPhoto#7fcb13a8 photo:Photo = MessageAction;

/*
Group profile photo removed.
*/
messageActionChatDeletePhoto#95e3fbef = MessageAction;

/*
New member in the group

@users Users that were invited to the chat
*/
messageActionChatAddUser#15cefd00 users:Vector<long> = MessageAction;

/*
User left the group.

@user_id Leaving user ID
*/
messageActionChatDeleteUser#a43f30cc user_id:long = MessageAction;

/*
A user joined the chat via an invite link

@inviter_id ID of the user that created the invite link
*/
messageActionChatJoinedByLink#31224c3 inviter_id:long = MessageAction;

/*
The channel was created

@title Original channel/supergroup title
*/
messageActionChannelCreate#95d2ac92 title:string = MessageAction;

/*
Indicates the chat was [migrated](https://core.telegram.org/api/channel) to the specified supergroup

@channel_id The supergroup it was migrated to
*/
messageActionChatMigrateTo#e1037f92 channel_id:long = MessageAction;

/*
Indicates the channel was [migrated](https://core.telegram.org/api/channel) from the specified chat

@title The old chat title
@chat_id The old chat ID
*/
messageActionChannelMigrateFrom#ea3948e9 title:string chat_id:long = MessageAction;

/*
A message was pinned
*/
messageActionPinMessage#94bd38ed = MessageAction;

/*
Chat history was cleared
*/
messageActionHistoryClear#9fbab604 = MessageAction;

/*
Someone scored in a game

@game_id Game ID
@score Score
*/
messageActionGameScore#92a72876 game_id:long score:int = MessageAction;

/*
A user just sent a payment to me (a bot)

@recurring_init Whether this is the first payment of a recurring payment we just subscribed to
@recurring_used Whether this payment is part of a recurring payment
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code, or XTR for [Telegram Stars](https://core.telegram.org/api/stars).
@total_amount Price of the product in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@payload Bot specified invoice payload
@info Order info provided by the user
@shipping_option_id Identifier of the shipping option chosen by the user
@charge Provider payment identifier
@subscription_until_date Expiration date of the [Telegram Star subscription](https://core.telegram.org/api/stars#star-subscriptions).
*/
messageActionPaymentSentMe#ffa00ccc flags:# recurring_init:flags.2?true recurring_used:flags.3?true currency:string total_amount:long payload:bytes info:flags.0?PaymentRequestedInfo shipping_option_id:flags.1?string charge:PaymentCharge subscription_until_date:flags.4?int = MessageAction;

/*
A payment was sent

@recurring_init Whether this is the first payment of a recurring payment we just subscribed to
@recurring_used Whether this payment is part of a recurring payment
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code, or XTR for [Telegram Stars](https://core.telegram.org/api/stars).
@total_amount Price of the product in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@invoice_slug An invoice slug taken from an [invoice deep link](https://core.telegram.org/api/links#invoice-links) or from the [premium_invoice_slug app config parameter](https://core.telegram.org/api/config#premium-invoice-slug)
@subscription_until_date Expiration date of the [Telegram Star subscription](https://core.telegram.org/api/stars#star-subscriptions).
*/
messageActionPaymentSent#c624b16e flags:# recurring_init:flags.2?true recurring_used:flags.3?true currency:string total_amount:long invoice_slug:flags.0?string subscription_until_date:flags.4?int = MessageAction;

/*
A phone call

@video Is this a video call?
@call_id Call ID
@reason If the call has ended, the reason why it ended
@duration Duration of the call in seconds
*/
messageActionPhoneCall#80e11a7f flags:# video:flags.2?true call_id:long reason:flags.0?PhoneCallDiscardReason duration:flags.1?int = MessageAction;

/*
A screenshot of the chat was taken
*/
messageActionScreenshotTaken#4792929b = MessageAction;

/*
Custom action (most likely not supported by the current layer, an upgrade might be needed)

@message Action message
*/
messageActionCustomAction#fae69f56 message:string = MessageAction;

/*
We have given the bot permission to send us direct messages.

@attach_menu We have authorized the bot to send us messages by installing the bot's [attachment menu](https://core.telegram.org/api/bots/attach).
@from_request We have allowed the bot to send us messages using [bots.allowSendMessage](https://core.telegram.org/method/bots.allowSendMessage).
@domain We have authorized the bot to send us messages by logging into a website via [Telegram Login](https://core.telegram.org/widgets/login); this field contains the domain name of the website on which the user has logged in.
@app We have authorized the bot to send us messages by opening the specified [bot mini app](https://core.telegram.org/api/bots/webapps).
*/
messageActionBotAllowed#c516d679 flags:# attach_menu:flags.1?true from_request:flags.3?true domain:flags.0?string app:flags.2?BotApp = MessageAction;

/*
Secure [telegram passport](https://core.telegram.org/passport) values were received

@values Vector with information about documents and other Telegram Passport elements that were shared with the bot
@credentials Encrypted credentials required to decrypt the data
*/
messageActionSecureValuesSentMe#1b287353 values:Vector<SecureValue> credentials:SecureCredentialsEncrypted = MessageAction;

/*
Request for secure [telegram passport](https://core.telegram.org/passport) values was sent

@types Secure value types
*/
messageActionSecureValuesSent#d95c6154 types:Vector<SecureValueType> = MessageAction;

/*
A contact just signed up to telegram
*/
messageActionContactSignUp#f3f25f76 = MessageAction;

/*
A user of the chat is now in proximity of another user

@from_id The user or chat that is now in proximity of to_id
@to_id The user or chat that subscribed to [live geolocation proximity alerts](https://core.telegram.org/api/live-location#proximity-alert)
@distance Distance, in meters (0-100000)
*/
messageActionGeoProximityReached#98e0d697 from_id:Peer to_id:Peer distance:int = MessageAction;

/*
The group call has ended

@call Group call
@duration Group call duration
*/
messageActionGroupCall#7a0d7f42 flags:# call:InputGroupCall duration:flags.0?int = MessageAction;

/*
A set of users was invited to the group call

@call The group call
@users The invited users
*/
messageActionInviteToGroupCall#502f92f7 call:InputGroupCall users:Vector<long> = MessageAction;

/*
The Time-To-Live of messages in this chat was changed.

@period New Time-To-Live of all messages sent in this chat; if 0, autodeletion was disabled.
@auto_setting_from If set, the chat TTL setting was set not due to a manual change by one of participants, but automatically because one of the participants has the [default TTL settings enabled](https://core.telegram.org/method/messages.setDefaultHistoryTTL). For example, when a user writes to us for the first time and we have set a default messages TTL of 1 week, this service message (with auto_setting_from=our_userid) will be emitted before our first message.
*/
messageActionSetMessagesTTL#3c134d7b flags:# period:int auto_setting_from:flags.0?long = MessageAction;

/*
A group call was scheduled

@call The group call
@schedule_date When is this group call scheduled to start
*/
messageActionGroupCallScheduled#b3a07661 call:InputGroupCall schedule_date:int = MessageAction;

/*
The chat theme was changed

@emoticon The emoji that identifies a chat theme
*/
messageActionSetChatTheme#aa786345 emoticon:string = MessageAction;

/*
A user was accepted into the group by an admin
*/
messageActionChatJoinedByRequest#ebbca3cb = MessageAction;

/*
Data from an opened [reply keyboard bot mini app](https://core.telegram.org/api/bots/webapps) was relayed to the bot that owns it (bot side service message).

@text Text of the [keyboardButtonSimpleWebView](https://core.telegram.org/constructor/keyboardButtonSimpleWebView) that was pressed to open the web app.
@data Relayed data.
*/
messageActionWebViewDataSentMe#47dd8079 text:string data:string = MessageAction;

/*
Data from an opened [reply keyboard bot mini app](https://core.telegram.org/api/bots/webapps) was relayed to the bot that owns it (user side service message).

@text Text of the [keyboardButtonSimpleWebView](https://core.telegram.org/constructor/keyboardButtonSimpleWebView) that was pressed to open the web app.
*/
messageActionWebViewDataSent#b4c38cb5 text:string = MessageAction;

/*
Info about a gifted Telegram Premium subscription

@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Price of the gift in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@months Duration of the gifted Telegram Premium subscription
@crypto_currency If the gift was bought using a cryptocurrency, the cryptocurrency name.
@crypto_amount If the gift was bought using a cryptocurrency, price of the gift in the smallest units of a cryptocurrency.
@message Message attached with the gift
*/
messageActionGiftPremium#6c6274fa flags:# currency:string amount:long months:int crypto_currency:flags.0?string crypto_amount:flags.0?long message:flags.1?TextWithEntities = MessageAction;

/*
A [forum topic](https://core.telegram.org/api/forum#forum-topics) was created.

@title Topic name.
@icon_color If no custom emoji icon is specified, specifies the color of the fallback topic icon (RGB), one of 0x6FB9F0, 0xFFD67E, 0xCB86DB, 0x8EEE98, 0xFF93B2, or 0xFB6F5F.
@icon_emoji_id ID of the [custom emoji](https://core.telegram.org/api/custom-emoji) used as topic icon.
*/
messageActionTopicCreate#d999256 flags:# title:string icon_color:int icon_emoji_id:flags.0?long = MessageAction;

/*
[Forum topic](https://core.telegram.org/api/forum#forum-topics) information was edited.

@title New topic title.
@icon_emoji_id ID of the new [custom emoji](https://core.telegram.org/api/custom-emoji) used as topic icon, or if it was removed.
@closed Whether the topic was opened or closed.
@hidden Whether the topic was hidden or unhidden (only valid for the "General" topic, id=1).
*/
messageActionTopicEdit#c0944820 flags:# title:flags.0?string icon_emoji_id:flags.1?long closed:flags.2?Bool hidden:flags.3?Bool = MessageAction;

/*
A new profile picture was suggested using [photos.uploadContactProfilePhoto](https://core.telegram.org/method/photos.uploadContactProfilePhoto).

@photo The photo that the user suggested we set as profile picture.
*/
messageActionSuggestProfilePhoto#57de635e photo:Photo = MessageAction;

/*
Contains info about one or more peers that the we (the user) shared with the bot after clicking on a [keyboardButtonRequestPeer](https://core.telegram.org/constructor/keyboardButtonRequestPeer) button (service message sent by the user).

@button_id button_id contained in the [keyboardButtonRequestPeer](https://core.telegram.org/constructor/keyboardButtonRequestPeer)
@peers The shared peers
*/
messageActionRequestedPeer#31518e9b button_id:int peers:Vector<Peer> = MessageAction;

/*
The [wallpaper](https://core.telegram.org/api/wallpapers) of the current chat was changed.

@same If set, indicates the user applied a [wallpaper](https://core.telegram.org/api/wallpapers) previously sent by the other user in a [messageActionSetChatWallPaper](https://core.telegram.org/constructor/messageActionSetChatWallPaper) message.
@for_both If set, indicates the wallpaper was forcefully applied for both sides, without explicit confirmation from the other side. If the message is incoming, and we did not like the new wallpaper the other user has chosen for us, we can re-set our previous wallpaper just on our side, by invoking [messages.setChatWallPaper](https://core.telegram.org/method/messages.setChatWallPaper), providing only the revert flag (and obviously the peer parameter).
@wallpaper New [wallpaper](https://core.telegram.org/api/wallpapers)
*/
messageActionSetChatWallPaper#5060a3f4 flags:# same:flags.0?true for_both:flags.1?true wallpaper:WallPaper = MessageAction;

/*
Contains a [Telegram Premium giftcode link](https://core.telegram.org/api/links#premium-giftcode-links).

@via_giveaway If set, this gift code was received from a [giveaway](https://core.telegram.org/api/giveaways) started by a channel/supergroup we're subscribed to.
@unclaimed If set, the link was not [redeemed](https://core.telegram.org/api/links#premium-giftcode-links) yet.
@boost_peer Identifier of the channel/supergroup that created the gift code [either directly or through a giveaway](https://core.telegram.org/api/giveaways): if we import this giftcode link, we will also automatically [boost](https://core.telegram.org/api/boost) this channel/supergroup.
@months Duration in months of the gifted [Telegram Premium subscription](https://core.telegram.org/api/premium).
@slug Slug of the [Telegram Premium giftcode link](https://core.telegram.org/api/links#premium-giftcode-links)
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@crypto_currency If set, the gift was made using the specified cryptocurrency.
@crypto_amount If crypto_currency is set, contains the paid amount, in the smallest units of the cryptocurrency.
@message Message attached with the gift
*/
messageActionGiftCode#56d03994 flags:# via_giveaway:flags.0?true unclaimed:flags.2?true boost_peer:flags.1?Peer months:int slug:string currency:flags.2?string amount:flags.2?long crypto_currency:flags.3?string crypto_amount:flags.3?long message:flags.4?TextWithEntities = MessageAction;

/*
A [giveaway](https://core.telegram.org/api/giveaways) was started.

@stars For [Telegram Star giveaways](https://core.telegram.org/api/stars#star-giveaways), the total number of Telegram Stars being given away.
*/
messageActionGiveawayLaunch#a80f51e4 flags:# stars:flags.0?long = MessageAction;

/*
A [giveaway](https://core.telegram.org/api/giveaways) has ended.

@stars If set, this is a [Telegram Star giveaway](https://core.telegram.org/api/stars#star-giveaways)
@winners_count Number of winners in the giveaway
@unclaimed_count Number of undistributed prizes
*/
messageActionGiveawayResults#87e2f155 flags:# stars:flags.0?true winners_count:int unclaimed_count:int = MessageAction;

/*
Some [boosts](https://core.telegram.org/api/boost) were applied to the channel or supergroup.

@boosts Number of applied [boosts](https://core.telegram.org/api/boost).
*/
messageActionBoostApply#cc02aa6d boosts:int = MessageAction;

/*
Contains info about one or more peers that the a user shared with the me (the bot) after clicking on a [keyboardButtonRequestPeer](https://core.telegram.org/constructor/keyboardButtonRequestPeer) button (service message received by the bot).

@button_id button_id contained in the [keyboardButtonRequestPeer](https://core.telegram.org/constructor/keyboardButtonRequestPeer)
@peers Info about the shared peers.
*/
messageActionRequestedPeerSentMe#93b31848 button_id:int peers:Vector<RequestedPeer> = MessageAction;

/*
Describes a payment refund (service message received by both users and bots).

@peer Identifier of the peer that returned the funds.
@currency Currency, XTR for Telegram Stars.
@total_amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@payload Bot specified invoice payload (only received by bots).
@charge Provider payment identifier
*/
messageActionPaymentRefunded#41b3e202 flags:# peer:Peer currency:string total_amount:long payload:flags.0?bytes charge:PaymentCharge = MessageAction;

/*
You gifted or were gifted some [Telegram Stars](https://core.telegram.org/api/stars).

@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Price of the gift in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@stars Amount of gifted stars
@crypto_currency If the gift was bought using a cryptocurrency, the cryptocurrency name.
@crypto_amount If the gift was bought using a cryptocurrency, price of the gift in the smallest units of a cryptocurrency.
@transaction_id Identifier of the transaction, only visible to the receiver of the gift.
*/
messageActionGiftStars#45d5b021 flags:# currency:string amount:long stars:long crypto_currency:flags.0?string crypto_amount:flags.0?long transaction_id:flags.1?string = MessageAction;

/*
You won some [Telegram Stars](https://core.telegram.org/api/stars) in a [Telegram Star giveaway](https://core.telegram.org/api/giveaways#star-giveaways).

@unclaimed If set, this indicates the reverse transaction that refunds the remaining stars to the creator of a giveaway if, when the giveaway ends, the number of members in the channel is smaller than the number of winners in the giveaway.
@stars The number of Telegram Stars you won
@transaction_id ID of the telegram star transaction.
@boost_peer Identifier of the peer that was automatically boosted by the winners of the giveaway.
@giveaway_msg_id ID of the message containing the [messageMediaGiveaway](https://core.telegram.org/constructor/messageMediaGiveaway)
*/
messageActionPrizeStars#b00c47a2 flags:# unclaimed:flags.0?true stars:long transaction_id:string boost_peer:Peer giveaway_msg_id:int = MessageAction;

/*
You received a [gift, see here](https://core.telegram.org/api/gifts) for more info.

@name_hidden If set, the name of the sender of the gift will be hidden if the destination user decides to display the gift on their profile
@saved Whether this gift was added to the destination user's profile (may be toggled using [payments.saveStarGift](https://core.telegram.org/method/payments.saveStarGift) and fetched using [payments.getUserStarGifts](https://core.telegram.org/method/payments.getUserStarGifts))
@converted Whether this gift was converted to [Telegram Stars](https://core.telegram.org/api/stars) and cannot be displayed on the profile anymore.
@upgraded  ... 
@refunded  ... 
@can_upgrade  ... 
@gift Info about the gift
@message Additional message from the sender of the gift
@convert_stars The receiver of this gift may convert it to this many Telegram Stars, instead of displaying it on their profile page. convert_stars will be equal to stars only if the gift was bought using recently bought Telegram Stars, otherwise it will be less than stars.
@upgrade_msg_id  ... 
@upgrade_stars  ... 
@from_id  ... 
@peer  ... 
@saved_id  ... 

#DocError
*/
messageActionStarGift#4717e8a4 flags:# name_hidden:flags.0?true saved:flags.2?true converted:flags.3?true upgraded:flags.5?true refunded:flags.9?true can_upgrade:flags.10?true gift:StarGift message:flags.1?TextWithEntities convert_stars:flags.4?long upgrade_msg_id:flags.5?int upgrade_stars:flags.8?long from_id:flags.11?Peer peer:flags.12?Peer saved_id:flags.12?long = MessageAction;

messageActionStarGiftUnique#acdfcb81 flags:# upgrade:flags.0?true transferred:flags.1?true saved:flags.2?true refunded:flags.5?true gift:StarGift can_export_at:flags.3?int transfer_stars:flags.4?long from_id:flags.6?Peer peer:flags.7?Peer saved_id:flags.7?long = MessageAction;
/*
Chat

@pinned Is the dialog pinned
@unread_mark Whether the chat was manually marked as unread
@view_forum_as_messages Users may also choose to display messages from all topics of a [forum](https://core.telegram.org/api/forum) as if they were sent to a normal group, using a "View as messages" setting in the local client.  This setting only affects the current account, and is synced to other logged in sessions using the [channels.toggleViewForumAsMessages](https://core.telegram.org/method/channels.toggleViewForumAsMessages) method; invoking this method will update the value of this flag.
@peer The chat
@top_message The latest message ID
@read_inbox_max_id Position up to which all incoming messages are read.
@read_outbox_max_id Position up to which all outgoing messages are read.
@unread_count Number of unread messages
@unread_mentions_count Number of [unread mentions](https://core.telegram.org/api/mentions)
@unread_reactions_count Number of unread reactions to messages you sent
@notify_settings Notification settings
@pts [PTS](https://core.telegram.org/api/updates)
@draft Message [draft](https://core.telegram.org/api/drafts)
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@ttl_period Time-to-live of all messages sent in this dialog
*/
dialog#d58a08c6 flags:# pinned:flags.2?true unread_mark:flags.3?true view_forum_as_messages:flags.6?true peer:Peer top_message:int read_inbox_max_id:int read_outbox_max_id:int unread_count:int unread_mentions_count:int unread_reactions_count:int notify_settings:PeerNotifySettings pts:flags.0?int draft:flags.1?DraftMessage folder_id:flags.4?int ttl_period:flags.5?int = Dialog;

/*
Dialog in folder

@pinned Is this folder pinned
@folder The folder
@peer Peer in folder
@top_message Latest message ID of dialog
@unread_muted_peers_count Number of unread muted peers in folder
@unread_unmuted_peers_count Number of unread unmuted peers in folder
@unread_muted_messages_count Number of unread messages from muted peers in folder
@unread_unmuted_messages_count Number of unread messages from unmuted peers in folder
*/
dialogFolder#71bd134c flags:# pinned:flags.2?true folder:Folder peer:Peer top_message:int unread_muted_peers_count:int unread_unmuted_peers_count:int unread_muted_messages_count:int unread_unmuted_messages_count:int = Dialog;

/*
Empty constructor, non-existent photo

@id Photo identifier
*/
photoEmpty#2331b22d id:long = Photo;

/*
Photo

@has_stickers Whether the photo has mask stickers attached to it
@id ID
@access_hash Access hash
@file_reference [file reference](https://core.telegram.org/api/file_reference)
@date Date of upload
@sizes Available sizes for download
@video_sizes [For animated profiles](https://core.telegram.org/api/files#animated-profile-pictures), the MPEG4 videos
@dc_id DC ID to use for download
*/
photo#fb197a65 flags:# has_stickers:flags.0?true id:long access_hash:long file_reference:bytes date:int sizes:Vector<PhotoSize> video_sizes:flags.1?Vector<VideoSize> dc_id:int = Photo;

/*
Empty constructor. Image with this thumbnail is unavailable.

@type [Thumbnail type](https://core.telegram.org/api/files#image-thumbnail-types)
*/
photoSizeEmpty#e17e23c type:string = PhotoSize;

/*
Image description.

@type [Thumbnail type](https://core.telegram.org/api/files#image-thumbnail-types)
@w Image width
@h Image height
@size File size
*/
photoSize#75c78e60 type:string w:int h:int size:int = PhotoSize;

/*
Description of an image and its content.

@type Thumbnail type
@w Image width
@h Image height
@bytes Binary data, file content
*/
photoCachedSize#21e1ad6 type:string w:int h:int bytes:bytes = PhotoSize;

/*
A low-resolution compressed JPG payload

@type Thumbnail type
@bytes Thumbnail data, see [here for more info on decompression](https://core.telegram.org/api/files#stripped-thumbnails)
*/
photoStrippedSize#e0b0bc2e type:string bytes:bytes = PhotoSize;

/*
Progressively encoded photosize

@type [Photosize type](https://core.telegram.org/api/files#image-thumbnail-types)
@w Photo width
@h Photo height
@sizes Sizes of progressive JPEG file prefixes, which can be used to preliminarily show the image.
*/
photoSizeProgressive#fa3efb95 type:string w:int h:int sizes:Vector<int> = PhotoSize;

/*
Messages with animated stickers can have a compressed svg (< 300 bytes) to show the outline of the sticker before fetching the actual lottie animation.

@type Always j
@bytes Compressed SVG path payload, [see here for decompression instructions](https://core.telegram.org/api/files#vector-thumbnails)
*/
photoPathSize#d8214d41 type:string bytes:bytes = PhotoSize;

/*
Empty constructor.
*/
geoPointEmpty#1117dd5f = GeoPoint;

/*
GeoPoint.

@long Longitude
@lat Latitude
@access_hash Access hash
@accuracy_radius The estimated horizontal accuracy of the location, in meters; as defined by the sender.
*/
geoPoint#b2a2f663 flags:# long:double lat:double access_hash:long accuracy_radius:flags.0?int = GeoPoint;

/*
Contains info about a sent verification code.

@type Phone code type
@phone_code_hash Phone code hash, to be stored and later re-used with [auth.signIn](https://core.telegram.org/method/auth.signIn)
@next_type Phone code type that will be sent next, if the phone code is not received within timeout seconds: to send it use [auth.resendCode](https://core.telegram.org/method/auth.resendCode)
@timeout Timeout for reception of the phone code
*/
auth.sentCode#5e002502 flags:# type:auth.SentCodeType phone_code_hash:string next_type:flags.1?auth.CodeType timeout:flags.2?int = auth.SentCode;

/*
The user successfully authorized using [future auth tokens](https://core.telegram.org/api/auth#future-auth-tokens)

@authorization Authorization info
*/
auth.sentCodeSuccess#2390fe44 authorization:auth.Authorization = auth.SentCode;

/*
Contains user authorization info.

@setup_password_required Suggests the user to set up a 2-step verification password to be able to log in again
@otherwise_relogin_days Iff setup_password_required is set and the user declines to set a 2-step verification password, they will be able to log into their account via SMS again only after this many days pass.
@tmp_sessions Temporary [passport](https://core.telegram.org/passport) sessions
@future_auth_token A [future auth token](https://core.telegram.org/api/auth#future-auth-tokens)
@user Info on authorized user
*/
auth.authorization#2ea2c0d4 flags:# setup_password_required:flags.1?true otherwise_relogin_days:flags.1?int tmp_sessions:flags.0?int future_auth_token:flags.2?bytes user:User = auth.Authorization;

/*
An account with this phone number doesn't exist on telegram: the user has to [enter basic information and sign up](https://core.telegram.org/api/auth)

@terms_of_service Telegram's terms of service: the user must read and accept the terms of service before signing up to telegram
*/
auth.authorizationSignUpRequired#44747e9a flags:# terms_of_service:flags.0?help.TermsOfService = auth.Authorization;

/*
Data for copying of authorization between data centers.

@id current user identifier
@bytes authorizes key
*/
auth.exportedAuthorization#b434e2b8 id:long bytes:bytes = auth.ExportedAuthorization;

/*
Notifications generated by a certain user or group.

@peer User or group
*/
inputNotifyPeer#b8bc5b0c peer:InputPeer = InputNotifyPeer;

/*
Notifications generated by all users.
*/
inputNotifyUsers#193b4417 = InputNotifyPeer;

/*
Notifications generated by all groups.
*/
inputNotifyChats#4a95e84e = InputNotifyPeer;

/*
All [channels](https://core.telegram.org/api/channel)
*/
inputNotifyBroadcasts#b1db7c7e = InputNotifyPeer;

/*
Notifications generated by a [topic](https://core.telegram.org/api/forum#forum-topics) in a [forum](https://core.telegram.org/api/forum).

@peer Forum ID
@top_msg_id [Topic ID](https://core.telegram.org/api/forum#forum-topics)
*/
inputNotifyForumTopic#5c467992 peer:InputPeer top_msg_id:int = InputNotifyPeer;

/*
Notification settings.

@show_previews If the text of the message shall be displayed in notification
@silent Peer was muted?
@mute_until Date until which all notifications shall be switched off
@sound Identifier of an audio file to play for notifications.
@stories_muted Whether story notifications should be disabled.
@stories_hide_sender Whether the sender name should be displayed in story notifications.
@stories_sound Identifier of an audio file to play for story notifications.
*/
inputPeerNotifySettings#cacb6ae2 flags:# show_previews:flags.0?Bool silent:flags.1?Bool mute_until:flags.2?int sound:flags.3?NotificationSound stories_muted:flags.6?Bool stories_hide_sender:flags.7?Bool stories_sound:flags.8?NotificationSound = InputPeerNotifySettings;

/*
Notification settings.

@show_previews (Ternary value) If set, indicates whether or not to display previews of messages in notifications; otherwise the default behavior should be used.
@silent (Ternary value) If set, indicates whether to mute or unmute the peer; otherwise the default behavior should be used.
@mute_until Mute all notifications until this date
@ios_sound Notification sound for the official iOS application
@android_sound Notification sound for the official android application
@other_sound Notification sound for other applications
@stories_muted Whether story notifications should be disabled.
@stories_hide_sender Whether the sender name should be displayed in story notifications.
@stories_ios_sound Sound for story notifications on the official iOS application
@stories_android_sound Sound for story notifications on the official Android application
@stories_other_sound Sound for story notifications on other applications
*/
peerNotifySettings#99622c0c flags:# show_previews:flags.0?Bool silent:flags.1?Bool mute_until:flags.2?int ios_sound:flags.3?NotificationSound android_sound:flags.4?NotificationSound other_sound:flags.5?NotificationSound stories_muted:flags.6?Bool stories_hide_sender:flags.7?Bool stories_ios_sound:flags.8?NotificationSound stories_android_sound:flags.9?NotificationSound stories_other_sound:flags.10?NotificationSound = PeerNotifySettings;

/*
List of actions that are possible when interacting with this user, to be shown as suggested actions in the [chat action bar](https://core.telegram.org/api/action-bar), see [here](https://core.telegram.org/api/action-bar) for more info.

@report_spam Whether we can still report the user for spam
@add_contact Whether we can add the user as contact
@block_contact Whether we can block the user
@share_contact Whether we can share the user's contact
@need_contacts_exception Whether a special exception for contacts is needed
@report_geo Whether we can report a geogroup as irrelevant for this location
@autoarchived Whether this peer was automatically archived according to [privacy settings](https://core.telegram.org/constructor/globalPrivacySettings) and can be unarchived
@invite_members If set, this is a recently created group chat to which new members can be invited
@request_chat_broadcast This flag is set if request_chat_title and request_chat_date fields are set and the [join request](https://core.telegram.org/api/invites#join-requests) is related to a channel (otherwise if only the request fields are set, the [join request](https://core.telegram.org/api/invites#join-requests) is related to a chat).
@business_bot_paused This flag is set if both business_bot_id and business_bot_manage_url are set and all [connected business bots](https://core.telegram.org/api/business#connected-bots) were paused in this chat using [account.toggleConnectedBotPaused](https://core.telegram.org/method/account.toggleConnectedBotPaused).
@business_bot_can_reply This flag is set if both business_bot_id and business_bot_manage_url are set and [connected business bots](https://core.telegram.org/api/business#connected-bots) can reply to messages in this chat, as specified by the settings during [initial configuration](https://core.telegram.org/api/business#connected-bots).
@geo_distance Distance in meters between us and this peer
@request_chat_title If set, this is a private chat with an administrator of a chat or channel to which the user sent a join request, and this field contains the chat/channel's title.
@request_chat_date If set, this is a private chat with an administrator of a chat or channel to which the user sent a join request, and this field contains the timestamp when the [join request](https://core.telegram.org/api/invites#join-requests) was sent.
@business_bot_id Contains the ID of the [business bot](https://core.telegram.org/api/business#connected-bots) managing this chat, used to display info about the bot in the action bar.
@business_bot_manage_url Contains a [deep link](https://core.telegram.org/api/links), used to open a management menu in the business bot. This flag is set if and only if business_bot_id is set.
*/
peerSettings#acd66c5e flags:# report_spam:flags.0?true add_contact:flags.1?true block_contact:flags.2?true share_contact:flags.3?true need_contacts_exception:flags.4?true report_geo:flags.5?true autoarchived:flags.7?true invite_members:flags.8?true request_chat_broadcast:flags.10?true business_bot_paused:flags.11?true business_bot_can_reply:flags.12?true geo_distance:flags.6?int request_chat_title:flags.9?string request_chat_date:flags.9?int business_bot_id:flags.13?long business_bot_manage_url:flags.13?string = PeerSettings;

/*
Represents a [wallpaper](https://core.telegram.org/api/wallpapers) based on an image.

@id Identifier
@creator Whether we created this wallpaper
@default Whether this is the default wallpaper
@pattern Whether this is a [pattern wallpaper](https://core.telegram.org/api/wallpapers#pattern-wallpapers)
@dark Whether this wallpaper should be used in dark mode.
@access_hash Access hash
@slug Unique wallpaper ID, used when generating [wallpaper links](https://core.telegram.org/api/links#wallpaper-links) or [importing wallpaper links](https://core.telegram.org/api/wallpapers).
@document The actual wallpaper
@settings Info on how to generate the wallpaper, according to [these instructions](https://core.telegram.org/api/wallpapers).
*/
wallPaper#a437c3ed id:long flags:# creator:flags.0?true default:flags.1?true pattern:flags.3?true dark:flags.4?true access_hash:long slug:string document:Document settings:flags.2?WallPaperSettings = WallPaper;

/*
Represents a [wallpaper](https://core.telegram.org/api/wallpapers) only based on colors/gradients.

@id Wallpaper ID
@default Whether this is the default wallpaper
@dark Whether this wallpaper should be used in dark mode.
@settings Info on how to generate the wallpaper.
*/
wallPaperNoFile#e0804116 id:long flags:# default:flags.1?true dark:flags.4?true settings:flags.2?WallPaperSettings = WallPaper;

/*
Report for spam
*/
inputReportReasonSpam#58dbcab8 = ReportReason;

/*
Report for violence
*/
inputReportReasonViolence#1e22c78d = ReportReason;

/*
Report for pornography
*/
inputReportReasonPornography#2e59d922 = ReportReason;

/*
Report for child abuse
*/
inputReportReasonChildAbuse#adf44ee3 = ReportReason;

/*
Other
*/
inputReportReasonOther#c1e4a2b1 = ReportReason;

/*
Report for copyrighted content
*/
inputReportReasonCopyright#9b89f93a = ReportReason;

/*
Report an irrelevant geogroup
*/
inputReportReasonGeoIrrelevant#dbd4feed = ReportReason;

/*
Report for impersonation
*/
inputReportReasonFake#f5ddd6e7 = ReportReason;

/*
Report for illegal drugs
*/
inputReportReasonIllegalDrugs#a8eb2be = ReportReason;

/*
Report for divulgation of personal details
*/
inputReportReasonPersonalDetails#9ec7863d = ReportReason;

/*
Extended user info

@blocked Whether you have blocked this user
@phone_calls_available Whether this user can make VoIP calls
@phone_calls_private Whether this user's privacy settings allow you to call them
@can_pin_message Whether you can pin messages in the chat with this user, you can do this only for a chat with yourself
@has_scheduled Whether [scheduled messages](https://core.telegram.org/api/scheduled-messages) are available
@video_calls_available Whether the user can receive video calls
@voice_messages_forbidden Whether this user doesn't allow sending voice messages in a private chat with them
@translations_disabled Whether the [real-time chat translation popup](https://core.telegram.org/api/translation) should be hidden.
@stories_pinned_available Whether this user has some [pinned stories](https://core.telegram.org/api/stories#pinned-or-archived-stories).
@blocked_my_stories_from Whether we've [blocked this user, preventing them from seeing our stories](https://core.telegram.org/api/block).
@wallpaper_overridden Whether the other user has chosen a custom wallpaper for us using [messages.setChatWallPaper](https://core.telegram.org/method/messages.setChatWallPaper) and the for_both flag, see [here](https://core.telegram.org/api/wallpapers#installing-wallpapers-in-a-specific-chat-or-channel) for more info.
@contact_require_premium If set, we cannot write to this user: subscribe to [Telegram Premium](https://core.telegram.org/api/premium) to get permission to write to this user. To set this flag for ourselves invoke [account.setGlobalPrivacySettings](https://core.telegram.org/method/account.setGlobalPrivacySettings), setting the settings.new_noncontact_peers_require_premium flag, see [here](https://core.telegram.org/api/privacy#require-premium-for-new-non-contact-users) for more info.
@read_dates_private If set, we cannot fetch the exact read date of messages we send to this user using [messages.getOutboxReadDate](https://core.telegram.org/method/messages.getOutboxReadDate).  The exact read date of messages might still be unavailable for other reasons, see [here](https://core.telegram.org/method/messages.getOutboxReadDate) for more info.  To set this flag for ourselves invoke [account.setGlobalPrivacySettings](https://core.telegram.org/method/account.setGlobalPrivacySettings), setting the settings.hide_read_marks flag.
@flags2  ... 
@sponsored_enabled Whether ads were re-enabled for the current account (only accessible to the currently logged-in user), see [here](https://core.telegram.org/api/business#re-enable-ads) for more info.
@can_view_revenue If set, this user can view [ad revenue statistics](https://core.telegram.org/api/revenue#revenue-statistics) for this bot.
@bot_can_manage_emoji_status If set, this is a bot that can [change our emoji status](https://core.telegram.org/api/emoji-status#setting-an-emoji-status-from-a-bot)
@id User ID
@about Bio of the user
@settings Peer settings
@personal_photo Personal profile photo, to be shown instead of profile_photo.
@profile_photo Profile photo
@fallback_photo Fallback profile photo, displayed if no photo is present in profile_photo or personal_photo, due to privacy settings.
@notify_settings Notification settings
@bot_info For bots, info about the bot (bot commands, etc)
@pinned_msg_id Message ID of the last [pinned message](https://core.telegram.org/api/pin)
@common_chats_count Chats in common with this user
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@ttl_period Time To Live of all messages in this chat; once a message is this many seconds old, it must be deleted.
@theme_emoticon Emoji associated with chat theme
@private_forward_name Anonymized text to be shown instead of the user's name on forwarded messages
@bot_group_admin_rights A [suggested set of administrator rights](https://core.telegram.org/api/rights#suggested-bot-rights) for the bot, to be shown when adding the bot as admin to a group, see [here for more info on how to handle them](https://core.telegram.org/api/rights#suggested-bot-rights).
@bot_broadcast_admin_rights A [suggested set of administrator rights](https://core.telegram.org/api/rights#suggested-bot-rights) for the bot, to be shown when adding the bot as admin to a channel, see [here for more info on how to handle them](https://core.telegram.org/api/rights#suggested-bot-rights).
@premium_gifts Telegram Premium subscriptions gift options
@wallpaper [Wallpaper](https://core.telegram.org/api/wallpapers) to use in the private chat with the user.
@stories Active [stories](https://core.telegram.org/api/stories)
@business_work_hours [Telegram Business working hours](https://core.telegram.org/api/business#opening-hours).
@business_location [Telegram Business location](https://core.telegram.org/api/business#location).
@business_greeting_message [Telegram Business greeting message](https://core.telegram.org/api/business#greeting-messages).
@business_away_message [Telegram Business away message](https://core.telegram.org/api/business#away-messages).
@business_intro Specifies a custom [Telegram Business profile introduction](https://core.telegram.org/api/business#business-introduction).
@birthday Contains info about the user's [birthday](https://core.telegram.org/api/profile#birthday).
@personal_channel_id ID of the associated personal [channel](https://core.telegram.org/api/channel), that should be shown in the [profile page](https://core.telegram.org/api/profile#personal-channel).
@personal_channel_message ID of the latest message of the associated personal [channel](https://core.telegram.org/api/channel), that should be previewed in the [profile page](https://core.telegram.org/api/profile#personal-channel).
@stargifts_count Number of [gifts](https://core.telegram.org/api/gifts) the user has chosen to display on their profile
@starref_program This bot has an active [referral program](https://core.telegram.org/api/bots/referrals)
@bot_verification  ... 

#DocError
*/
userFull#4d975bbc flags:# blocked:flags.0?true phone_calls_available:flags.4?true phone_calls_private:flags.5?true can_pin_message:flags.7?true has_scheduled:flags.12?true video_calls_available:flags.13?true voice_messages_forbidden:flags.20?true translations_disabled:flags.23?true stories_pinned_available:flags.26?true blocked_my_stories_from:flags.27?true wallpaper_overridden:flags.28?true contact_require_premium:flags.29?true read_dates_private:flags.30?true flags2:# sponsored_enabled:flags2.7?true can_view_revenue:flags2.9?true bot_can_manage_emoji_status:flags2.10?true id:long about:flags.1?string settings:PeerSettings personal_photo:flags.21?Photo profile_photo:flags.2?Photo fallback_photo:flags.22?Photo notify_settings:PeerNotifySettings bot_info:flags.3?BotInfo pinned_msg_id:flags.6?int common_chats_count:int folder_id:flags.11?int ttl_period:flags.14?int theme_emoticon:flags.15?string private_forward_name:flags.16?string bot_group_admin_rights:flags.17?ChatAdminRights bot_broadcast_admin_rights:flags.18?ChatAdminRights premium_gifts:flags.19?Vector<PremiumGiftOption> wallpaper:flags.24?WallPaper stories:flags.25?PeerStories business_work_hours:flags2.0?BusinessWorkHours business_location:flags2.1?BusinessLocation business_greeting_message:flags2.2?BusinessGreetingMessage business_away_message:flags2.3?BusinessAwayMessage business_intro:flags2.4?BusinessIntro birthday:flags2.5?Birthday personal_channel_id:flags2.6?long personal_channel_message:flags2.6?int stargifts_count:flags2.8?int starref_program:flags2.11?StarRefProgram bot_verification:flags2.12?BotVerification = UserFull;

/*
A contact of the current user that is registered in the system.

@user_id User identifier
@mutual Current user is in the user's contact list
*/
contact#145ade0b user_id:long mutual:Bool = Contact;

/*
Successfully imported contact.

@user_id User identifier
@client_id The contact's client identifier (passed to one of the [InputContact](https://core.telegram.org/type/InputContact) constructors)
*/
importedContact#c13e3c50 user_id:long client_id:long = ImportedContact;

/*
Contact status: online / offline.

@user_id User identifier
@status Online status
*/
contactStatus#16d9703b user_id:long status:UserStatus = ContactStatus;

/*
Contact list on the server is the same as the list on the client.
*/
contacts.contactsNotModified#b74ba9d2 = contacts.Contacts;

/*
The current user's contact list and info on users.

@contacts Contact list
@saved_count Number of contacts that were saved successfully
@users User list
*/
contacts.contacts#eae87e42 contacts:Vector<Contact> saved_count:int users:Vector<User> = contacts.Contacts;

/*
Info on successfully imported contacts.

@imported List of successfully imported contacts
@popular_invites Popular contacts
@retry_contacts List of contact ids that could not be imported due to system limitation and will need to be imported at a later date.
@users List of users
*/
contacts.importedContacts#77d01c3b imported:Vector<ImportedContact> popular_invites:Vector<PopularContact> retry_contacts:Vector<long> users:Vector<User> = contacts.ImportedContacts;

/*
Full list of blocked users.

@blocked List of blocked users
@chats Blocked chats
@users List of users
*/
contacts.blocked#ade1591 blocked:Vector<PeerBlocked> chats:Vector<Chat> users:Vector<User> = contacts.Blocked;

/*
Incomplete list of blocked users.

@count Total number of elements in the list
@blocked List of blocked users
@chats Blocked chats
@users List of users
*/
contacts.blockedSlice#e1664194 count:int blocked:Vector<PeerBlocked> chats:Vector<Chat> users:Vector<User> = contacts.Blocked;

/*
Full list of chats with messages and auxiliary data.

@dialogs List of chats
@messages List of last messages from each chat
@chats List of groups mentioned in the chats
@users List of users mentioned in messages and groups
*/
messages.dialogs#15ba6c40 dialogs:Vector<Dialog> messages:Vector<Message> chats:Vector<Chat> users:Vector<User> = messages.Dialogs;

/*
Incomplete list of dialogs with messages and auxiliary data.

@count Total number of dialogs
@dialogs List of dialogs
@messages List of last messages from dialogs
@chats List of chats mentioned in dialogs
@users List of users mentioned in messages and chats
*/
messages.dialogsSlice#71e094f3 count:int dialogs:Vector<Dialog> messages:Vector<Message> chats:Vector<Chat> users:Vector<User> = messages.Dialogs;

/*
Dialogs haven't changed

@count Number of dialogs found server-side by the query
*/
messages.dialogsNotModified#f0e3e596 count:int = messages.Dialogs;

/*
Full list of messages with auxiliary data.

@messages List of messages
@chats List of chats mentioned in dialogs
@users List of users mentioned in messages and chats
*/
messages.messages#8c718e87 messages:Vector<Message> chats:Vector<Chat> users:Vector<User> = messages.Messages;

/*
Incomplete list of messages and auxiliary data.

@inexact If set, indicates that the results may be inexact
@count Total number of messages in the list
@next_rate Rate to use in the offset_rate parameter in the next call to [messages.searchGlobal](https://core.telegram.org/method/messages.searchGlobal)
@offset_id_offset Indicates the absolute position of messages[0] within the total result set with count count. This is useful, for example, if the result was fetched using offset_id, and we need to display a progress/total counter (like photo 134 of 200, for all media in a chat, we could simply use photo ${offset_id_offset} of ${count}.
@messages List of messages
@chats List of chats mentioned in messages
@users List of users mentioned in messages and chats
*/
messages.messagesSlice#3a54685e flags:# inexact:flags.1?true count:int next_rate:flags.0?int offset_id_offset:flags.2?int messages:Vector<Message> chats:Vector<Chat> users:Vector<User> = messages.Messages;

/*
Channel messages

@inexact If set, returned results may be inexact
@pts [Event count after generation](https://core.telegram.org/api/updates)
@count Total number of results were found server-side (may not be all included here)
@offset_id_offset Indicates the absolute position of messages[0] within the total result set with count count. This is useful, for example, if the result was fetched using offset_id, and we need to display a progress/total counter (like photo 134 of 200, for all media in a chat, we could simply use photo ${offset_id_offset} of ${count}.
@messages Found messages
@topics [Forum topic](https://core.telegram.org/api/forum#forum-topics) information
@chats Chats
@users Users
*/
messages.channelMessages#c776ba4e flags:# inexact:flags.1?true pts:int count:int offset_id_offset:flags.2?int messages:Vector<Message> topics:Vector<ForumTopic> chats:Vector<Chat> users:Vector<User> = messages.Messages;

/*
No new messages matching the query were found

@count Number of results found server-side by the given query
*/
messages.messagesNotModified#74535f21 count:int = messages.Messages;

/*
List of chats with auxiliary data.

@chats List of chats
*/
messages.chats#64ff9fd5 chats:Vector<Chat> = messages.Chats;

/*
Partial list of chats, more would have to be fetched with [pagination](https://core.telegram.org/api/offsets)

@count Total number of results that were found server-side (not all are included in chats)
@chats Chats
*/
messages.chatsSlice#9cd81144 count:int chats:Vector<Chat> = messages.Chats;

/*
Full info about a [channel](https://core.telegram.org/api/channel#channels), [supergroup](https://core.telegram.org/api/channel#supergroups), [gigagroup](https://core.telegram.org/api/channel#gigagroups) or [basic group](https://core.telegram.org/api/channel#basic-groups).

@full_chat Full info
@chats Mentioned chats
@users Mentioned users
*/
messages.chatFull#e5d7d19c full_chat:ChatFull chats:Vector<Chat> users:Vector<User> = messages.ChatFull;

/*
Affected part of communication history with the user or in a chat.

@pts Number of events occurred in a text box
@pts_count Number of affected events
@offset If a parameter contains positive value, it is necessary to repeat the method call using the given value; during the proceeding of all the history the value itself shall gradually decrease
*/
messages.affectedHistory#b45c69d1 pts:int pts_count:int offset:int = messages.AffectedHistory;

/*
Filter is absent.
*/
inputMessagesFilterEmpty#57e2f66c = MessagesFilter;

/*
Filter for messages containing photos.
*/
inputMessagesFilterPhotos#9609a51c = MessagesFilter;

/*
Filter for messages containing videos.
*/
inputMessagesFilterVideo#9fc00e65 = MessagesFilter;

/*
Filter for messages containing photos or videos.
*/
inputMessagesFilterPhotoVideo#56e9f0e4 = MessagesFilter;

/*
Filter for messages containing documents.
*/
inputMessagesFilterDocument#9eddf188 = MessagesFilter;

/*
Return only messages containing URLs
*/
inputMessagesFilterUrl#7ef0dd87 = MessagesFilter;

/*
Return only messages containing gifs
*/
inputMessagesFilterGif#ffc86587 = MessagesFilter;

/*
Return only messages containing voice notes
*/
inputMessagesFilterVoice#50f5c392 = MessagesFilter;

/*
Return only messages containing audio files
*/
inputMessagesFilterMusic#3751b49e = MessagesFilter;

/*
Return only chat photo changes
*/
inputMessagesFilterChatPhotos#3a20ecb8 = MessagesFilter;

/*
Return only phone calls

@missed Return only missed phone calls
*/
inputMessagesFilterPhoneCalls#80c99768 flags:# missed:flags.0?true = MessagesFilter;

/*
Return only round videos and voice notes
*/
inputMessagesFilterRoundVoice#7a7c17a4 = MessagesFilter;

/*
Return only round videos
*/
inputMessagesFilterRoundVideo#b549da53 = MessagesFilter;

/*
Return only messages where the current user was [mentioned](https://core.telegram.org/api/mentions).
*/
inputMessagesFilterMyMentions#c1f8e69a = MessagesFilter;

/*
Return only messages containing geolocations
*/
inputMessagesFilterGeo#e7026d0d = MessagesFilter;

/*
Return only messages containing contacts
*/
inputMessagesFilterContacts#e062db83 = MessagesFilter;

/*
Fetch only pinned messages
*/
inputMessagesFilterPinned#1bb00451 = MessagesFilter;

/*
New message in a private chat or in a [basic group](https://core.telegram.org/api/channel#basic-groups).

@message Message
@pts New quantity of actions in a message box
@pts_count Number of generated events
*/
updateNewMessage#1f2b0afd message:Message pts:int pts_count:int = Update;

/*
Sent message with random_id client identifier was assigned an identifier.

@id id identifier of a respective [Message](https://core.telegram.org/type/Message)
@random_id Previously transferred client random_id identifier
*/
updateMessageID#4e90bfd6 id:int random_id:long = Update;

/*
Messages were deleted.

@messages List of identifiers of deleted messages
@pts New quality of actions in a message box
@pts_count Number of generated [events](https://core.telegram.org/api/updates)
*/
updateDeleteMessages#a20db0e5 messages:Vector<int> pts:int pts_count:int = Update;

/*
The user is preparing a message; typing, recording, uploading, etc. This update is valid for 6 seconds. If no further updates of this kind are received after 6 seconds, it should be considered that the user stopped doing whatever they were doing

@user_id User id
@action Action type
*/
updateUserTyping#c01e857f user_id:long action:SendMessageAction = Update;

/*
The user is preparing a message in a group; typing, recording, uploading, etc. This update is valid for 6 seconds. If no further updates of this kind are received after 6 seconds, it should be considered that the user stopped doing whatever they were doing

@chat_id Group id
@from_id Peer that started typing (can be the chat itself, in case of anonymous admins).
@action Type of action
*/
updateChatUserTyping#83487af0 chat_id:long from_id:Peer action:SendMessageAction = Update;

/*
Composition of chat participants changed.

@participants Updated chat participants
*/
updateChatParticipants#7761198 participants:ChatParticipants = Update;

/*
Contact status update.

@user_id User identifier
@status New status
*/
updateUserStatus#e5bdf8de user_id:long status:UserStatus = Update;

/*
Changes the user's first name, last name and username.

@user_id User identifier
@first_name New first name. Corresponds to the new value of real_first_name field of the [userFull](https://core.telegram.org/constructor/userFull) constructor.
@last_name New last name. Corresponds to the new value of real_last_name field of the [userFull](https://core.telegram.org/constructor/userFull) constructor.
@usernames Usernames.
*/
updateUserName#a7848924 user_id:long first_name:string last_name:string usernames:Vector<Username> = Update;

/*
A new session logged into the current user's account through an unknown device.

@unconfirmed Whether the session is [unconfirmed, see here](https://core.telegram.org/api/auth#confirming-login) for more info.
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@date Authorization date
@device Name of device, for example Android
@location Location, for example USA, NY (IP=1.2.3.4)
*/
updateNewAuthorization#8951abef flags:# unconfirmed:flags.0?true hash:long date:flags.0?int device:flags.0?string location:flags.0?string = Update;

/*
New encrypted message.

@message Message
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateNewEncryptedMessage#12bcbd9a message:EncryptedMessage qts:int = Update;

/*
Interlocutor is typing a message in an encrypted chat. Update period is 6 second. If upon this time there is no repeated update, it shall be considered that the interlocutor stopped typing.

@chat_id Chat ID
*/
updateEncryptedChatTyping#1710f156 chat_id:int = Update;

/*
Change of state in an encrypted chat.

@chat Encrypted chat
@date Date of change
*/
updateEncryption#b4a2e88d chat:EncryptedChat date:int = Update;

/*
Communication history in an encrypted chat was marked as read.

@chat_id Chat ID
@max_date Maximum value of data for read messages
@date Time when messages were read
*/
updateEncryptedMessagesRead#38fe25b7 chat_id:int max_date:int date:int = Update;

/*
New group member.

@chat_id Group ID
@user_id ID of the new member
@inviter_id ID of the user, who added member to the group
@date When was the participant added
@version Chat version number
*/
updateChatParticipantAdd#3dda5451 chat_id:long user_id:long inviter_id:long date:int version:int = Update;

/*
A member has left the group.

@chat_id Group ID
@user_id ID of the user
@version Used in basic groups to reorder updates and make sure that all of them was received.
*/
updateChatParticipantDelete#e32f3d77 chat_id:long user_id:long version:int = Update;

/*
Changes in the data center configuration options.

@dc_options New connection options
*/
updateDcOptions#8e5e9873 dc_options:Vector<DcOption> = Update;

/*
Changes in notification settings.

@peer Notification source
@notify_settings New notification settings
*/
updateNotifySettings#bec268ef peer:NotifyPeer notify_settings:PeerNotifySettings = Update;

/*
A service message for the user.

@popup If set, the message must be displayed in a popup.
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@inbox_date When was the notification received The message must also be stored locally as part of the message history with the user id 777000 (Telegram Notifications).
@type String, identical in format and contents to the [type](https://core.telegram.org/api/errors#error-type) field in API errors. Describes type of service message. It is acceptable to ignore repeated messages of the same type within a short period of time (15 minutes).
@message Message text
@media Media content (optional)
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
*/
updateServiceNotification#ebe46819 flags:# popup:flags.0?true invert_media:flags.2?true inbox_date:flags.1?int type:string message:string media:MessageMedia entities:Vector<MessageEntity> = Update;

/*
Privacy rules were changed

@key Peers to which the privacy rules apply
@rules New privacy rules
*/
updatePrivacy#ee3b272a key:PrivacyKey rules:Vector<PrivacyRule> = Update;

/*
A user's phone number was changed

@user_id User ID
@phone New phone number
*/
updateUserPhone#5492a13 user_id:long phone:string = Update;

/*
Incoming messages were read

@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@peer Peer
@max_id Maximum ID of messages read
@still_unread_count Number of messages that are still unread
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updateReadHistoryInbox#9c974fdf flags:# folder_id:flags.0?int peer:Peer max_id:int still_unread_count:int pts:int pts_count:int = Update;

/*
Outgoing messages were read

@peer Peer
@max_id Maximum ID of read outgoing messages
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updateReadHistoryOutbox#2f2f21bf peer:Peer max_id:int pts:int pts_count:int = Update;

/*
An [instant view](https://instantview.telegram.org) webpage preview was generated

@webpage Webpage preview
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updateWebPage#7f891213 webpage:WebPage pts:int pts_count:int = Update;

/*
Contents of messages in the common [message box](https://core.telegram.org/api/updates) were read

@messages IDs of read messages
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
@date When was the last message in messages marked as read.
*/
updateReadMessagesContents#f8227181 flags:# messages:Vector<int> pts:int pts_count:int date:flags.0?int = Update;

/*
There are new updates in the specified channel, the client must fetch them. 
If the difference is too long or if the channel isn't currently in the states, start fetching from the specified pts.

@channel_id The channel
@pts The [PTS](https://core.telegram.org/api/updates).
*/
updateChannelTooLong#108d941f flags:# channel_id:long pts:flags.0?int = Update;

/*
Channel/supergroup ( [channel](https://core.telegram.org/constructor/channel) and/or [channelFull](https://core.telegram.org/constructor/channelFull)) information was updated.

@channel_id Channel ID
*/
updateChannel#635b4c09 channel_id:long = Update;

/*
A new message was sent in a [channel/supergroup](https://core.telegram.org/api/channel)

@message New message
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updateNewChannelMessage#62ba04d9 message:Message pts:int pts_count:int = Update;

/*
Incoming messages in a [channel/supergroup](https://core.telegram.org/api/channel) were read

@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@channel_id Channel/supergroup ID
@max_id Position up to which all incoming messages are read.
@still_unread_count Count of messages weren't read yet
@pts [Event count after generation](https://core.telegram.org/api/updates)
*/
updateReadChannelInbox#922e6e10 flags:# folder_id:flags.0?int channel_id:long max_id:int still_unread_count:int pts:int = Update;

/*
Some messages in a [supergroup/channel](https://core.telegram.org/api/channel) were deleted

@channel_id Channel ID
@messages IDs of messages that were deleted
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updateDeleteChannelMessages#c32d5b12 channel_id:long messages:Vector<int> pts:int pts_count:int = Update;

/*
The view counter of a message in a channel has changed

@channel_id Channel ID
@id ID of the message
@views New view counter
*/
updateChannelMessageViews#f226ac08 channel_id:long id:int views:int = Update;

/*
Admin permissions of a user in a [basic group](https://core.telegram.org/api/channel#basic-groups) were changed

@chat_id Chat ID
@user_id ID of the (de)admined user
@is_admin Whether the user was rendered admin
@version Used in basic groups to reorder updates and make sure that all of them was received.
*/
updateChatParticipantAdmin#d7ca61a2 chat_id:long user_id:long is_admin:Bool version:int = Update;

/*
A new stickerset was installed

@stickerset The installed stickerset
*/
updateNewStickerSet#688a30aa stickerset:messages.StickerSet = Update;

/*
The order of stickersets was changed

@masks Whether the updated stickers are mask stickers
@emojis Whether the updated stickers are custom emoji stickers
@order New sticker order by sticker ID
*/
updateStickerSetsOrder#bb2d201 flags:# masks:flags.0?true emojis:flags.1?true order:Vector<long> = Update;

/*
Installed stickersets have changed, the client should refetch them as [described in the docs](https://core.telegram.org/api/stickers#installing-stickersets).

@masks Whether mask stickersets have changed
@emojis Whether the list of installed [custom emoji stickersets](https://core.telegram.org/api/custom-emoji) has changed
*/
updateStickerSets#31c24808 flags:# masks:flags.0?true emojis:flags.1?true = Update;

/*
The saved gif list has changed, the client should refetch it using [messages.getSavedGifs](https://core.telegram.org/method/messages.getSavedGifs)
*/
updateSavedGifs#9375341e = Update;

/*
An incoming inline query

@query_id Query ID
@user_id User that sent the query
@query Text of query
@geo Attached geolocation
@peer_type Type of the chat from which the inline query was sent.
@offset Offset to navigate through results
*/
updateBotInlineQuery#496f379c flags:# query_id:long user_id:long query:string geo:flags.0?GeoPoint peer_type:flags.1?InlineQueryPeerType offset:string = Update;

/*
The result of an inline query that was chosen by a user and sent to their chat partner. Please see our documentation on the [feedback collecting](https://core.telegram.org/bots/inline#collecting-feedback) for details on how to enable these updates for your bot.

@user_id The user that chose the result
@query The query that was used to obtain the result
@geo Optional. Sender location, only for bots that require user location
@id The unique identifier for the result that was chosen
@msg_id Identifier of the sent inline message. Available only if there is an inline keyboard attached to the message. Will be also received in callback queries and can be used to edit the message.
*/
updateBotInlineSend#12f12a07 flags:# user_id:long query:string geo:flags.0?GeoPoint id:string msg_id:flags.1?InputBotInlineMessageID = Update;

/*
A message was edited in a [channel/supergroup](https://core.telegram.org/api/channel)

@message The new message
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updateEditChannelMessage#1b3f4df7 message:Message pts:int pts_count:int = Update;

/*
A callback button was pressed, and the button data was sent to the bot that created the button

@query_id Query ID
@user_id ID of the user that pressed the button
@peer Chat where the inline keyboard was sent
@msg_id Message ID
@chat_instance Global identifier, uniquely corresponding to the chat to which the message with the callback button was sent. Useful for high scores in games.
@data Callback data
@game_short_name Short name of a Game to be returned, serves as the unique identifier for the game
*/
updateBotCallbackQuery#b9cfc48d flags:# query_id:long user_id:long peer:Peer msg_id:int chat_instance:long data:flags.0?bytes game_short_name:flags.1?string = Update;

/*
A message was edited

@message The new edited message
@pts [PTS](https://core.telegram.org/api/updates)
@pts_count [PTS count](https://core.telegram.org/api/updates)
*/
updateEditMessage#e40370a3 message:Message pts:int pts_count:int = Update;

/*
This notification is received by bots when a button is pressed

@query_id Query ID
@user_id ID of the user that pressed the button
@msg_id ID of the inline message with the button
@chat_instance Global identifier, uniquely corresponding to the chat to which the message with the callback button was sent. Useful for high scores in games.
@data Data associated with the callback button. Be aware that a bad client can send arbitrary data in this field.
@game_short_name Short name of a Game to be returned, serves as the unique identifier for the game
*/
updateInlineBotCallbackQuery#691e9052 flags:# query_id:long user_id:long msg_id:InputBotInlineMessageID chat_instance:long data:flags.0?bytes game_short_name:flags.1?string = Update;

/*
Outgoing messages in a [channel/supergroup](https://core.telegram.org/api/channel) were read

@channel_id Channel/supergroup ID
@max_id Position up to which all outgoing messages are read.
*/
updateReadChannelOutbox#b75f99a9 channel_id:long max_id:int = Update;

/*
Notifies a change of a message [draft](https://core.telegram.org/api/drafts).

@peer The peer to which the draft is associated
@top_msg_id ID of the [forum topic](https://core.telegram.org/api/forum#forum-topics) to which the draft is associated
@draft The draft
*/
updateDraftMessage#1b49ec6d flags:# peer:Peer top_msg_id:flags.0?int draft:DraftMessage = Update;

/*
Some featured stickers were marked as read
*/
updateReadFeaturedStickers#571d2742 = Update;

/*
The recent sticker list was updated
*/
updateRecentStickers#9a422c20 = Update;

/*
The server-side configuration has changed; the client should re-fetch the config using [help.getConfig](https://core.telegram.org/method/help.getConfig) and [help.getAppConfig](https://core.telegram.org/method/help.getAppConfig).
*/
updateConfig#a229dd06 = Update;

/*
[Common message box sequence PTS](https://core.telegram.org/api/updates) has changed, [state has to be refetched using updates.getState](https://core.telegram.org/api/updates#fetching-state)
*/
updatePtsChanged#3354678f = Update;

/*
A webpage preview of a link in a [channel/supergroup](https://core.telegram.org/api/channel) message was generated

@channel_id [Channel/supergroup](https://core.telegram.org/api/channel) ID
@webpage Generated webpage preview
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updateChannelWebPage#2f2ba99f channel_id:long webpage:WebPage pts:int pts_count:int = Update;

/*
A dialog was pinned/unpinned

@pinned Whether the dialog was pinned
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@peer The dialog
*/
updateDialogPinned#6e6fe51c flags:# pinned:flags.0?true folder_id:flags.1?int peer:DialogPeer = Update;

/*
Pinned dialogs were updated

@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@order New order of pinned dialogs
*/
updatePinnedDialogs#fa0f3ca2 flags:# folder_id:flags.1?int order:flags.0?Vector<DialogPeer> = Update;

/*
A new incoming event **for bots only**

@data The event
*/
updateBotWebhookJSON#8317c0c3 data:DataJSON = Update;

/*
A new incoming query **for bots only**

@query_id Query identifier
@data Query data
@timeout Query timeout
*/
updateBotWebhookJSONQuery#9b9240a6 query_id:long data:DataJSON timeout:int = Update;

/*
This object contains information about an incoming shipping query.

@query_id Unique query identifier
@user_id User who sent the query
@payload Bot specified invoice payload
@shipping_address User specified shipping address
*/
updateBotShippingQuery#b5aefd7d query_id:long user_id:long payload:bytes shipping_address:PostAddress = Update;

/*
This object contains information about an incoming pre-checkout query.

@query_id Unique query identifier
@user_id User who sent the query
@payload Bot specified invoice payload
@info Order info provided by the user
@shipping_option_id Identifier of the shipping option chosen by the user
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code, or XTR for [Telegram Stars](https://core.telegram.org/api/stars).
@total_amount Total amount in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
*/
updateBotPrecheckoutQuery#8caa9a96 flags:# query_id:long user_id:long payload:bytes info:flags.0?PaymentRequestedInfo shipping_option_id:flags.1?string currency:string total_amount:long = Update;

/*
An incoming phone call

@phone_call Phone call
*/
updatePhoneCall#ab0f6b1e phone_call:PhoneCall = Update;

/*
A language pack has changed, the client should manually fetch the changed strings using [langpack.getDifference](https://core.telegram.org/method/langpack.getDifference)

@lang_code Language code
*/
updateLangPackTooLong#46560264 lang_code:string = Update;

/*
Language pack updated

@difference Changed strings
*/
updateLangPack#56022f4d difference:LangPackDifference = Update;

/*
The list of favorited stickers was changed, the client should call [messages.getFavedStickers](https://core.telegram.org/method/messages.getFavedStickers) to refetch the new list
*/
updateFavedStickers#e511996d = Update;

/*
The specified [channel/supergroup](https://core.telegram.org/api/channel) messages were read

@channel_id [Channel/supergroup](https://core.telegram.org/api/channel) ID
@top_msg_id [Forum topic ID](https://core.telegram.org/api/forum#forum-topics).
@messages IDs of messages that were read
*/
updateChannelReadMessagesContents#ea29055d flags:# channel_id:long top_msg_id:flags.0?int messages:Vector<int> = Update;

/*
All contacts were deleted
*/
updateContactsReset#7084a7be = Update;

/*
The history of a [channel/supergroup](https://core.telegram.org/api/channel) was hidden.

@channel_id Channel/supergroup ID
@available_min_id Identifier of a maximum unavailable message in a channel due to hidden history.
*/
updateChannelAvailableMessages#b23fc698 channel_id:long available_min_id:int = Update;

/*
The manual unread mark of a chat was changed

@unread Was the chat marked or unmarked as read
@peer The dialog
*/
updateDialogUnreadMark#e16459c3 flags:# unread:flags.0?true peer:DialogPeer = Update;

/*
The results of a poll have changed

@poll_id Poll ID
@poll If the server knows the client hasn't cached this poll yet, the poll itself
@results New poll results
*/
updateMessagePoll#aca1657b flags:# poll_id:long poll:flags.0?Poll results:PollResults = Update;

/*
Default banned rights in a [normal chat](https://core.telegram.org/api/channel) were updated

@peer The chat
@default_banned_rights New default banned rights
@version Version
*/
updateChatDefaultBannedRights#54c01850 peer:Peer default_banned_rights:ChatBannedRights version:int = Update;

/*
The peer list of a [peer folder](https://core.telegram.org/api/folders#peer-folders) was updated

@folder_peers New peer list
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updateFolderPeers#19360dc0 folder_peers:Vector<FolderPeer> pts:int pts_count:int = Update;

/*
Settings of a certain peer have changed

@peer The peer
@settings Associated peer settings
*/
updatePeerSettings#6a7e7366 peer:Peer settings:PeerSettings = Update;

/*
List of peers near you was updated

@peers Geolocated peer list update
*/
updatePeerLocated#b4afcfb0 peers:Vector<PeerLocated> = Update;

/*
A message was added to the [schedule queue of a chat](https://core.telegram.org/api/scheduled-messages)

@message Message
*/
updateNewScheduledMessage#39a51dfb message:Message = Update;

/*
Some [scheduled messages](https://core.telegram.org/api/scheduled-messages) were deleted (or sent) from the schedule queue of a chat

@peer Peer
@messages Deleted scheduled messages
@sent_messages If set, this update indicates that some scheduled messages were sent (not simply deleted from the schedule queue).  In this case, the messages field will contain the scheduled message IDs for the sent messages (initially returned in [updateNewScheduledMessage](https://core.telegram.org/constructor/updateNewScheduledMessage)), and sent_messages will contain the real message IDs for the sent messages.
*/
updateDeleteScheduledMessages#f2a71983 flags:# peer:Peer messages:Vector<int> sent_messages:flags.0?Vector<int> = Update;

/*
A cloud theme was updated

@theme Theme
*/
updateTheme#8216fba3 theme:Theme = Update;

/*
Live geoposition message was viewed

@peer The user that viewed the live geoposition
@msg_id Message ID of geoposition message
*/
updateGeoLiveViewed#871fb939 peer:Peer msg_id:int = Update;

/*
A login token (for login via QR code) was accepted.
*/
updateLoginToken#564fe691 = Update;

/*
A specific peer has voted in a poll

@poll_id Poll ID
@peer The peer that voted in the poll
@options Chosen option(s)
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateMessagePollVote#24f40e77 poll_id:long peer:Peer options:Vector<bytes> qts:int = Update;

/*
A new [folder](https://core.telegram.org/api/folders) was added

@id [Folder](https://core.telegram.org/api/folders) ID
@filter [Folder](https://core.telegram.org/api/folders) info
*/
updateDialogFilter#26ffde7d flags:# id:int filter:flags.0?DialogFilter = Update;

/*
New [folder](https://core.telegram.org/api/folders) order

@order Ordered [folder IDs](https://core.telegram.org/api/folders)
*/
updateDialogFilterOrder#a5d72105 order:Vector<int> = Update;

/*
Clients should update [folder](https://core.telegram.org/api/folders) info
*/
updateDialogFilters#3504914f = Update;

/*
Incoming phone call signaling payload

@phone_call_id Phone call ID
@data Signaling payload
*/
updatePhoneCallSignalingData#2661bf09 phone_call_id:long data:bytes = Update;

/*
The forward counter of a message in a channel has changed

@channel_id Channel ID
@id ID of the message
@forwards New forward counter
*/
updateChannelMessageForwards#d29a27f4 channel_id:long id:int forwards:int = Update;

/*
Incoming comments in a [discussion thread](https://core.telegram.org/api/threads) were marked as read

@channel_id [Discussion group ID](https://core.telegram.org/api/channel)
@top_msg_id ID of the group message that started the [thread](https://core.telegram.org/api/threads) (message in linked discussion group)
@read_max_id Message ID of latest read incoming message for this [thread](https://core.telegram.org/api/threads)
@broadcast_id If set, contains the ID of the [channel](https://core.telegram.org/api/channel) that contains the post that started the [comment thread](https://core.telegram.org/api/threads) in the discussion group ( channel_id)
@broadcast_post If set, contains the ID of the channel post that started the [comment thread](https://core.telegram.org/api/threads)
*/
updateReadChannelDiscussionInbox#d6b19546 flags:# channel_id:long top_msg_id:int read_max_id:int broadcast_id:flags.0?long broadcast_post:flags.0?int = Update;

/*
Outgoing comments in a [discussion thread](https://core.telegram.org/api/threads) were marked as read

@channel_id [Supergroup ID](https://core.telegram.org/api/channel)
@top_msg_id ID of the group message that started the [thread](https://core.telegram.org/api/threads)
@read_max_id Message ID of latest read outgoing message for this [thread](https://core.telegram.org/api/threads)
*/
updateReadChannelDiscussionOutbox#695c9e7c channel_id:long top_msg_id:int read_max_id:int = Update;

/*
We blocked a peer, see [here](https://core.telegram.org/api/block) for more info on blocklists.

@blocked Whether the peer was blocked or unblocked
@blocked_my_stories_from Whether the peer was added/removed to/from the story blocklist; if not set, this update affects the main blocklist, see [here](https://core.telegram.org/api/block) for more info.
@peer_id The (un)blocked peer
*/
updatePeerBlocked#ebe07752 flags:# blocked:flags.0?true blocked_my_stories_from:flags.1?true peer_id:Peer = Update;

/*
A user is typing in a [supergroup, channel](https://core.telegram.org/api/channel) or [message thread](https://core.telegram.org/api/threads)

@channel_id Channel ID
@top_msg_id [Thread ID](https://core.telegram.org/api/threads)
@from_id The peer that is typing
@action Whether the user is typing, sending a media or doing something else
*/
updateChannelUserTyping#8c88c923 flags:# channel_id:long top_msg_id:flags.0?int from_id:Peer action:SendMessageAction = Update;

/*
Some messages were pinned in a chat

@pinned Whether the messages were pinned or unpinned
@peer Peer
@messages Message IDs
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updatePinnedMessages#ed85eab5 flags:# pinned:flags.0?true peer:Peer messages:Vector<int> pts:int pts_count:int = Update;

/*
Messages were pinned/unpinned in a [channel/supergroup](https://core.telegram.org/api/channel)

@pinned Whether the messages were pinned or unpinned
@channel_id Channel ID
@messages Messages
@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
updatePinnedChannelMessages#5bb98608 flags:# pinned:flags.0?true channel_id:long messages:Vector<int> pts:int pts_count:int = Update;

/*
Chat ( [chat](https://core.telegram.org/constructor/chat) and/or [chatFull](https://core.telegram.org/constructor/chatFull)) information was updated.

@chat_id Chat ID
*/
updateChat#f89a6a4e chat_id:long = Update;

/*
The participant list of a certain group call has changed

@call Group call
@participants New participant list
@version Version
*/
updateGroupCallParticipants#f2ebdb4e call:InputGroupCall participants:Vector<GroupCallParticipant> version:int = Update;

/*
A new groupcall was started

@chat_id The [channel/supergroup](https://core.telegram.org/api/channel) where this group call or livestream takes place
@call Info about the group call or livestream
*/
updateGroupCall#97d64341 flags:# chat_id:flags.0?long call:GroupCall = Update;

/*
The Time-To-Live for messages sent by the current user in a specific chat has changed

@peer The chat
@ttl_period The new Time-To-Live
*/
updatePeerHistoryTTL#bb9bb9a5 flags:# peer:Peer ttl_period:flags.0?int = Update;

/*
A user has joined or left a specific chat

@chat_id [Chat](https://core.telegram.org/api/channel) ID
@date When did this event occur
@actor_id User that triggered the change (inviter, admin that kicked the user, or the even the user_id itself)
@user_id User that was affected by the change
@prev_participant Previous participant info (empty if this participant just joined)
@new_participant New participant info (empty if this participant just left)
@invite The invite that was used to join the group
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateChatParticipant#d087663a flags:# chat_id:long date:int actor_id:long user_id:long prev_participant:flags.0?ChatParticipant new_participant:flags.1?ChatParticipant invite:flags.2?ExportedChatInvite qts:int = Update;

/*
A participant has left, joined, was banned or admined in a [channel or supergroup](https://core.telegram.org/api/channel).

@via_chatlist Whether the participant joined using a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).
@channel_id Channel ID
@date Date of the event
@actor_id User that triggered the change (inviter, admin that kicked the user, or the even the user_id itself)
@user_id User that was affected by the change
@prev_participant Previous participant status
@new_participant New participant status
@invite Chat invite used to join the [channel/supergroup](https://core.telegram.org/api/channel)
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateChannelParticipant#985d3abb flags:# via_chatlist:flags.3?true channel_id:long date:int actor_id:long user_id:long prev_participant:flags.0?ChannelParticipant new_participant:flags.1?ChannelParticipant invite:flags.2?ExportedChatInvite qts:int = Update;

/*
A bot was stopped or re-started.

@user_id The user ID
@date When did this action occur
@stopped Whether the bot was stopped or started
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateBotStopped#c4870a49 user_id:long date:int stopped:Bool qts:int = Update;

/*
New WebRTC parameters

@presentation Are these parameters related to the screen capture session currently in progress?
@params WebRTC parameters
*/
updateGroupCallConnection#b783982 flags:# presentation:flags.0?true params:DataJSON = Update;

/*
The [command set](https://core.telegram.org/api/bots/commands) of a certain bot in a certain chat has changed.

@peer The affected chat
@bot_id ID of the bot that changed its command set
@commands New bot commands
*/
updateBotCommands#4d712f2e peer:Peer bot_id:long commands:Vector<BotCommand> = Update;

/*
Someone has requested to join a chat or channel

@peer Chat or channel
@requests_pending Number of pending [join requests](https://core.telegram.org/api/invites#join-requests) for the chat or channel
@recent_requesters IDs of users that have recently requested to join
*/
updatePendingJoinRequests#7063c3db peer:Peer requests_pending:int recent_requesters:Vector<long> = Update;

/*
Someone has requested to join a chat or channel (bots only, users will receive an [updatePendingJoinRequests](https://core.telegram.org/constructor/updatePendingJoinRequests), instead)

@peer The chat or channel in question
@date When was the [join request](https://core.telegram.org/api/invites#join-requests) made
@user_id The user ID that is asking to join the chat or channel
@about Bio of the user
@invite Chat invite link that was used by the user to send the [join request](https://core.telegram.org/api/invites#join-requests)
@qts [QTS](https://core.telegram.org/api/updates) event sequence identifier
*/
updateBotChatInviteRequester#11dfa986 peer:Peer date:int user_id:long about:string invite:ExportedChatInvite qts:int = Update;

/*
New [message reactions](https://core.telegram.org/api/reactions) are available

@peer Peer
@msg_id Message ID
@top_msg_id [Forum topic ID](https://core.telegram.org/api/forum#forum-topics)
@reactions Reactions
*/
updateMessageReactions#5e1b3cb8 flags:# peer:Peer msg_id:int top_msg_id:flags.0?int reactions:MessageReactions = Update;

/*
The list of installed [attachment menu entries](https://core.telegram.org/api/bots/attach) has changed, use [messages.getAttachMenuBots](https://core.telegram.org/method/messages.getAttachMenuBots) to fetch the updated list.
*/
updateAttachMenuBots#17b7a20b = Update;

/*
Indicates to a bot that a webview was closed and an inline message was sent on behalf of the user using [messages.sendWebViewResultMessage](https://core.telegram.org/method/messages.sendWebViewResultMessage)

@query_id Web app interaction ID
*/
updateWebViewResultSent#1592b79d query_id:long = Update;

/*
The menu button behavior for the specified bot has changed

@bot_id Bot ID
@button New menu button
*/
updateBotMenuButton#14b85813 bot_id:long button:BotMenuButton = Update;

/*
The list of saved notification sounds has changed, use [account.getSavedRingtones](https://core.telegram.org/method/account.getSavedRingtones) to fetch the new list.
*/
updateSavedRingtones#74d8be99 = Update;

/*
A pending [voice message transcription](https://core.telegram.org/api/transcribe) initiated with [messages.transcribeAudio](https://core.telegram.org/method/messages.transcribeAudio) was updated.

@pending Whether this transcription is still pending and further [updateTranscribedAudio](https://core.telegram.org/constructor/updateTranscribedAudio) about it will be sent in the future.
@peer Peer of the transcribed message
@msg_id Transcribed message ID
@transcription_id Transcription ID
@text Transcribed text
*/
updateTranscribedAudio#84cd5a flags:# pending:flags.0?true peer:Peer msg_id:int transcription_id:long text:string = Update;

/*
Some featured [custom emoji stickers](https://core.telegram.org/api/custom-emoji) were marked as read
*/
updateReadFeaturedEmojiStickers#fb4c496c = Update;

/*
The [emoji status](https://core.telegram.org/api/emoji-status) of a certain user has changed

@user_id User ID
@emoji_status New [emoji status](https://core.telegram.org/api/emoji-status)
*/
updateUserEmojiStatus#28373599 user_id:long emoji_status:EmojiStatus = Update;

/*
The list of recent [emoji statuses](https://core.telegram.org/api/emoji-status) has changed
*/
updateRecentEmojiStatuses#30f443db = Update;

/*
The list of recent [message reactions](https://core.telegram.org/api/reactions) has changed
*/
updateRecentReactions#6f7863f4 = Update;

/*
A stickerset was just moved to top, [see here for more info](https://core.telegram.org/api/stickers#recent-stickersets)

@masks This update is referring to a [mask stickerset](https://core.telegram.org/api/stickers#mask-stickers)
@emojis This update is referring to a [custom emoji stickerset](https://core.telegram.org/api/custom-emoji)
@stickerset [Stickerset](https://core.telegram.org/api/stickers) ID
*/
updateMoveStickerSetToTop#86fccf85 flags:# masks:flags.0?true emojis:flags.1?true stickerset:long = Update;

/*
You [bought a paid media](https://core.telegram.org/api/paid-media): this update contains the revealed media.

@peer Peer where the paid media was posted
@msg_id ID of the message containing the paid media
@extended_media Revealed media, contains only [messageExtendedMedia](https://core.telegram.org/constructor/messageExtendedMedia) constructors.
*/
updateMessageExtendedMedia#d5a41724 peer:Peer msg_id:int extended_media:Vector<MessageExtendedMedia> = Update;

/*
A [forum topic](https://core.telegram.org/api/forum#forum-topics) was pinned or unpinned.

@pinned Whether the topic was pinned or unpinned
@channel_id The forum ID
@topic_id The topic ID
*/
updateChannelPinnedTopic#192efbe3 flags:# pinned:flags.0?true channel_id:long topic_id:int = Update;

/*
The [pinned topics](https://core.telegram.org/api/forum#forum-topics) of a forum have changed.

@channel_id Forum ID.
@order Ordered list containing the IDs of all pinned topics.
*/
updateChannelPinnedTopics#fe198602 flags:# channel_id:long order:flags.0?Vector<int> = Update;

/*
User ( [user](https://core.telegram.org/constructor/user) and/or [userFull](https://core.telegram.org/constructor/userFull)) information was updated.

@user_id User ID
*/
updateUser#20529438 user_id:long = Update;

/*
Media autosave settings have changed and must be refetched using [account.getAutoSaveSettings](https://core.telegram.org/method/account.getAutoSaveSettings).
*/
updateAutoSaveSettings#ec05b097 = Update;

/*
A new story was posted.

@peer ID of the poster.
@story The story that was posted.
*/
updateStory#75b3b798 peer:Peer story:StoryItem = Update;

/*
Stories of a specific peer were marked as read.

@peer The peer
@max_id ID of the last story that was marked as read
*/
updateReadStories#f74e932b peer:Peer max_id:int = Update;

/*
A story was successfully uploaded.

@id The id that was attributed to the story.
@random_id The random_id that was passed to [stories.sendStory](https://core.telegram.org/method/stories.sendStory).
*/
updateStoryID#1bf335b9 id:int random_id:long = Update;

/*
Indicates that [stories stealth mode](https://core.telegram.org/api/stories#stealth-mode) was activated.

@stealth_mode Information about the current [stealth mode](https://core.telegram.org/api/stories#stealth-mode) session.
*/
updateStoriesStealthMode#2c084dc1 stealth_mode:StoriesStealthMode = Update;

/*
Indicates we [reacted to a story](https://core.telegram.org/api/stories#reactions).

@peer The peer that sent the story
@story_id ID of the story we reacted to
@reaction The reaction that was sent
*/
updateSentStoryReaction#7d627683 peer:Peer story_id:int reaction:Reaction = Update;

/*
A [channel/supergroup boost](https://core.telegram.org/api/boost) has changed (bots only)

@peer Channel
@boost New boost information
@qts [QTS](https://core.telegram.org/api/updates) event sequence identifier
*/
updateBotChatBoost#904dd49c peer:Peer boost:Boost qts:int = Update;

/*
Users may also choose to display messages from all topics as if they were sent to a normal group, using a "View as messages" setting in the local client. 
This setting only affects the current account, and is synced to other logged in sessions using the [channels.toggleViewForumAsMessages](https://core.telegram.org/method/channels.toggleViewForumAsMessages) method; invoking this method will update the value of the view_forum_as_messages flag of [channelFull](https://core.telegram.org/constructor/channelFull) or [dialog](https://core.telegram.org/constructor/dialog) and emit an [updateChannelViewForumAsMessages](https://core.telegram.org/constructor/updateChannelViewForumAsMessages).

@channel_id The forum ID
@enabled The new value of the toggle.
*/
updateChannelViewForumAsMessages#7b68920 channel_id:long enabled:Bool = Update;

/*
The [wallpaper](https://core.telegram.org/api/wallpapers) of a given peer has changed.

@wallpaper_overridden Whether the other user has chosen a custom wallpaper for us using [messages.setChatWallPaper](https://core.telegram.org/method/messages.setChatWallPaper) and the for_both flag, see [here](https://core.telegram.org/api/wallpapers#installing-wallpapers-in-a-specific-chat-or-channel) for more info.
@peer The peer where the wallpaper has changed.
@wallpaper The new wallpaper, if none the wallpaper was removed and the default wallpaper should be used.
*/
updatePeerWallpaper#ae3f101d flags:# wallpaper_overridden:flags.1?true peer:Peer wallpaper:flags.0?WallPaper = Update;

/*
Bots only: a user has changed their reactions on a message with public reactions.

@peer Peer of the reacted-to message.
@msg_id ID of the reacted-to message.
@date Date of the change.
@actor The user that (un)reacted to the message.
@old_reactions Old reactions
@new_reactions New reactions
@qts [QTS](https://core.telegram.org/api/updates) event sequence identifier
*/
updateBotMessageReaction#ac21d3ce peer:Peer msg_id:int date:int actor:Peer old_reactions:Vector<Reaction> new_reactions:Vector<Reaction> qts:int = Update;

/*
Bots only: the number of reactions on a message with anonymous reactions has changed.

@peer Peer of the reacted-to message.
@msg_id ID of the reacted-to message.
@date Date of the change.
@reactions New reaction counters.
@qts [QTS](https://core.telegram.org/api/updates) event sequence identifier
*/
updateBotMessageReactions#9cb7759 peer:Peer msg_id:int date:int reactions:Vector<ReactionCount> qts:int = Update;

/*
A [saved message dialog](https://core.telegram.org/api/saved-messages) was pinned/unpinned

@pinned Whether the dialog was pinned
@peer The dialog
*/
updateSavedDialogPinned#aeaf9e74 flags:# pinned:flags.0?true peer:DialogPeer = Update;

/*
[Pinned saved dialogs](https://core.telegram.org/api/saved-messages) were updated

@order New order of pinned saved dialogs
*/
updatePinnedSavedDialogs#686c85a6 flags:# order:flags.0?Vector<DialogPeer> = Update;

/*
The list of [reaction tag](https://core.telegram.org/api/saved-messages#tags) names assigned by the user has changed and should be refetched using [messages.getSavedReactionTags](https://core.telegram.org/method/messages.getSavedReactionTags).
*/
updateSavedReactionTags#39c67432 = Update;

/*
A new SMS job was received

@job_id SMS job ID
*/
updateSmsJob#f16269d4 job_id:string = Update;

/*
Info about or the order of [quick reply shortcuts](https://core.telegram.org/api/business#quick-reply-shortcuts) was changed.

@quick_replies New quick reply shortcut order and information.
*/
updateQuickReplies#f9470ab2 quick_replies:Vector<QuickReply> = Update;

/*
A new [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts) was created.

@quick_reply Quick reply shortcut.
*/
updateNewQuickReply#f53da717 quick_reply:QuickReply = Update;

/*
A [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts) was deleted. This will not emit [updateDeleteQuickReplyMessages](https://core.telegram.org/constructor/updateDeleteQuickReplyMessages) updates, even if all the messages in the shortcut are also deleted by this update.

@shortcut_id ID of the quick reply shortcut that was deleted.
*/
updateDeleteQuickReply#53e6f1ec shortcut_id:int = Update;

/*
A new message was added to a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts).

@message The message that was added (the [message](https://core.telegram.org/constructor/message). quick_reply_shortcut_id field will contain the shortcut ID).
*/
updateQuickReplyMessage#3e050d0f message:Message = Update;

/*
One or more messages in a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts) were deleted.

@shortcut_id Quick reply shortcut ID.
@messages IDs of the deleted messages.
*/
updateDeleteQuickReplyMessages#566fe7cd shortcut_id:int messages:Vector<int> = Update;

/*
Connecting or disconnecting a [business bot](https://core.telegram.org/api/business#connected-bots) or changing the connection settings will emit an [updateBotBusinessConnect](https://core.telegram.org/constructor/updateBotBusinessConnect) update to the bot, with the new settings and a connection_id that will be used by the bot to handle updates from and send messages as the user.

@connection Business connection settings
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateBotBusinessConnect#8ae5c97a connection:BotBusinessConnection qts:int = Update;

/*
A message was received via a [connected business chat](https://core.telegram.org/api/business#connected-bots).

@connection_id Connection ID.
@message New message.
@reply_to_message The message that message is replying to.
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateBotNewBusinessMessage#9ddb347c flags:# connection_id:string message:Message reply_to_message:flags.0?Message qts:int = Update;

/*
A message was edited in a [connected business chat](https://core.telegram.org/api/business#connected-bots).

@connection_id Business connection ID
@message New message.
@reply_to_message The message that message is replying to.
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateBotEditBusinessMessage#7df587c flags:# connection_id:string message:Message reply_to_message:flags.0?Message qts:int = Update;

/*
A message was deleted in a [connected business chat](https://core.telegram.org/api/business#connected-bots).

@connection_id Business connection ID.
@peer [Peer](https://core.telegram.org/api/peers) where the messages were deleted.
@messages IDs of the messages that were deleted.
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateBotDeleteBusinessMessage#a02a982e connection_id:string peer:Peer messages:Vector<int> qts:int = Update;

/*
Represents a new [reaction to a story](https://core.telegram.org/api/reactions#notifications-about-reactions).

@story_id [Story ID](https://core.telegram.org/api/stories).
@peer The peer where the story was posted.
@reaction The [reaction](https://core.telegram.org/api/reactions).
*/
updateNewStoryReaction#1824e40b story_id:int peer:Peer reaction:Reaction = Update;

/*
A new [channel ad revenue transaction was made, see here](https://core.telegram.org/api/revenue#revenue-statistics) for more info.

@peer Channel
@balances New ad revenue balance.
*/
updateBroadcastRevenueTransactions#dfd961f5 peer:Peer balances:BroadcastRevenueBalances = Update;

/*
The current account's [Telegram Stars balance](https://core.telegram.org/api/stars) has changed.

@balance New balance.
*/
updateStarsBalance#4e80a379 balance:StarsAmount = Update;

/*
A callback button sent via a [business connection](https://core.telegram.org/api/business#connected-bots) was pressed, and the button data was sent to the bot that created the button.

@query_id Query ID
@user_id ID of the user that pressed the button
@connection_id [Business connection ID](https://core.telegram.org/api/business#connected-bots)
@message Message that contains the keyboard (also contains info about the chat where the message was sent).
@reply_to_message The message that message is replying to.
@chat_instance Global identifier, uniquely corresponding to the chat to which the message with the callback button was sent. Useful for high scores in games.
@data Callback data
*/
updateBusinessBotCallbackQuery#1ea2fda7 flags:# query_id:long user_id:long connection_id:string message:Message reply_to_message:flags.2?Message chat_instance:long data:flags.0?bytes = Update;

/*
The [Telegram Star balance of a channel/bot we own has changed](https://core.telegram.org/api/stars#revenue-statistics).

@peer Channel/bot
@status New Telegram Star balance.
*/
updateStarsRevenueStatus#a584b019 peer:Peer status:StarsRevenueStatus = Update;

/*
Bots only: a user has purchased a [paid media](https://core.telegram.org/api/paid-media).

@user_id The user that bought the media
@payload Payload passed by the bot in [inputMediaPaidMedia](https://core.telegram.org/constructor/inputMediaPaidMedia). payload
@qts New qts value, see [updates](https://core.telegram.org/api/updates) for more info.
*/
updateBotPurchasedPaidMedia#283bd312 user_id:long payload:string qts:int = Update;

/*
Contains the current [default paid reaction privacy, see here](https://core.telegram.org/api/reactions#paid-reactions) for more info.

@private Whether paid reaction privacy is enabled or disabled.
*/
updatePaidReactionPrivacy#8b725fce private:PaidReactionPrivacy = Update;

/*
Updates state.

@pts Number of events occurred in a text box
@qts Position in a sequence of updates in secret chats. For further details refer to article [secret chats](https://core.telegram.org/api/end-to-end)
@date Date of condition
@seq Number of sent updates
@unread_count Number of unread messages
*/
updates.state#a56c2a3e pts:int qts:int date:int seq:int unread_count:int = updates.State;

/*
No events.

@date Current date
@seq Number of sent updates
*/
updates.differenceEmpty#5d75a138 date:int seq:int = updates.Difference;

/*
Full list of occurred events.

@new_messages List of new messages
@new_encrypted_messages List of new encrypted secret chat messages
@other_updates List of updates
@chats List of chats mentioned in events
@users List of users mentioned in events
@state Current state
*/
updates.difference#f49ca0 new_messages:Vector<Message> new_encrypted_messages:Vector<EncryptedMessage> other_updates:Vector<Update> chats:Vector<Chat> users:Vector<User> state:updates.State = updates.Difference;

/*
Incomplete list of occurred events.

@new_messages List of new messages
@new_encrypted_messages New messages from the [encrypted event sequence](https://core.telegram.org/api/updates)
@other_updates List of updates
@chats List of chats mentioned in events
@users List of users mentioned in events
@intermediate_state Intermediary state
*/
updates.differenceSlice#a8fb1981 new_messages:Vector<Message> new_encrypted_messages:Vector<EncryptedMessage> other_updates:Vector<Update> chats:Vector<Chat> users:Vector<User> intermediate_state:updates.State = updates.Difference;

/*
The difference is [too long](https://core.telegram.org/api/updates#recovering-gaps), and the specified state must be used to refetch updates.

@pts The new state to use.
*/
updates.differenceTooLong#4afe8f6d pts:int = updates.Difference;

/*
Too many updates, it is necessary to execute [updates.getDifference](https://core.telegram.org/method/updates.getDifference).
*/
updatesTooLong#e317af7e = Updates;

/*
Info about a message sent to (received from) another user

@out Whether the message is outgoing
@mentioned Whether we were mentioned in the message
@media_unread Whether there are some unread mentions in this message
@silent If true, the message is a silent message, no notifications should be triggered
@id The message ID
@user_id The ID of the sender (if outgoing will be the ID of the destination) of the message
@message The message
@pts [PTS](https://core.telegram.org/api/updates)
@pts_count [PTS count](https://core.telegram.org/api/updates)
@date [date](https://core.telegram.org/api/updates)
@fwd_from Info about a forwarded message
@via_bot_id Info about the inline bot used to generate this message
@reply_to Reply and [thread](https://core.telegram.org/api/threads) information
@entities [Entities](https://core.telegram.org/api/entities) for styled text
@ttl_period Time To Live of the message, once message.date+message.ttl_period === time(), the message will be deleted on the server, and must be deleted locally as well.
*/
updateShortMessage#313bc7f8 flags:# out:flags.1?true mentioned:flags.4?true media_unread:flags.5?true silent:flags.13?true id:int user_id:long message:string pts:int pts_count:int date:int fwd_from:flags.2?MessageFwdHeader via_bot_id:flags.11?long reply_to:flags.3?MessageReplyHeader entities:flags.7?Vector<MessageEntity> ttl_period:flags.25?int = Updates;

/*
Shortened constructor containing info on one new incoming text message from a chat

@out Whether the message is outgoing
@mentioned Whether we were mentioned in this message
@media_unread Whether the message contains some unread mentions
@silent If true, the message is a silent message, no notifications should be triggered
@id ID of the message
@from_id ID of the sender of the message
@chat_id ID of the chat where the message was sent
@message Message
@pts [PTS](https://core.telegram.org/api/updates)
@pts_count [PTS count](https://core.telegram.org/api/updates)
@date [date](https://core.telegram.org/api/updates)
@fwd_from Info about a forwarded message
@via_bot_id Info about the inline bot used to generate this message
@reply_to Reply (thread) information
@entities [Entities](https://core.telegram.org/api/entities) for styled text
@ttl_period Time To Live of the message, once updateShortChatMessage.date+updateShortChatMessage.ttl_period === time(), the message will be deleted on the server, and must be deleted locally as well.
*/
updateShortChatMessage#4d6deea5 flags:# out:flags.1?true mentioned:flags.4?true media_unread:flags.5?true silent:flags.13?true id:int from_id:long chat_id:long message:string pts:int pts_count:int date:int fwd_from:flags.2?MessageFwdHeader via_bot_id:flags.11?long reply_to:flags.3?MessageReplyHeader entities:flags.7?Vector<MessageEntity> ttl_period:flags.25?int = Updates;

/*
Shortened constructor containing info on one update not requiring auxiliary data

@update Update
@date Date of event
*/
updateShort#78d4dec1 update:Update date:int = Updates;

/*
Constructor for a group of updates.

@updates List of updates
@users List of users mentioned in updates
@chats List of chats mentioned in updates
@date Current date
@seq_start Value seq for the earliest update in a group
@seq Value seq for the latest update in a group
*/
updatesCombined#725b04c3 updates:Vector<Update> users:Vector<User> chats:Vector<Chat> date:int seq_start:int seq:int = Updates;

/*
Full constructor of updates

@updates List of updates
@users List of users mentioned in updates
@chats List of chats mentioned in updates
@date Current date
@seq Total number of sent updates
*/
updates#74ae4240 updates:Vector<Update> users:Vector<User> chats:Vector<Chat> date:int seq:int = Updates;

/*
Shortened constructor containing info on one outgoing message to a contact (the destination chat has to be extracted from the method call that returned this object).

@out Whether the message is outgoing
@id ID of the sent message
@pts [PTS](https://core.telegram.org/api/updates)
@pts_count [PTS count](https://core.telegram.org/api/updates)
@date [date](https://core.telegram.org/api/updates)
@media Attached media
@entities [Entities](https://core.telegram.org/api/entities) for styled text
@ttl_period Time To Live of the message, once message.date+message.ttl_period === time(), the message will be deleted on the server, and must be deleted locally as well.
*/
updateShortSentMessage#9015e101 flags:# out:flags.1?true id:int pts:int pts_count:int date:int media:flags.9?MessageMedia entities:flags.7?Vector<MessageEntity> ttl_period:flags.25?int = Updates;

/*
Full list of photos with auxiliary data.

@photos List of photos
@users List of mentioned users
*/
photos.photos#8dca6aa5 photos:Vector<Photo> users:Vector<User> = photos.Photos;

/*
Incomplete list of photos with auxiliary data.

@count Total number of photos
@photos List of photos
@users List of mentioned users
*/
photos.photosSlice#15051f54 count:int photos:Vector<Photo> users:Vector<User> = photos.Photos;

/*
Photo with auxiliary data.

@photo Photo
@users Users
*/
photos.photo#20212ca8 photo:Photo users:Vector<User> = photos.Photo;

/*
File content.

@type File type
@mtime Modification time
@bytes Binary data, file content
*/
upload.file#96a18d5 type:storage.FileType mtime:int bytes:bytes = upload.File;

/*
The file must be downloaded from a [CDN DC](https://core.telegram.org/cdn).

@dc_id [CDN DC](https://core.telegram.org/cdn) ID
@file_token File token (see [CDN files](https://core.telegram.org/cdn))
@encryption_key Encryption key (see [CDN files](https://core.telegram.org/cdn))
@encryption_iv Encryption IV (see [CDN files](https://core.telegram.org/cdn))
@file_hashes File hashes (see [CDN files](https://core.telegram.org/cdn))
*/
upload.fileCdnRedirect#f18cda44 dc_id:int file_token:bytes encryption_key:bytes encryption_iv:bytes file_hashes:Vector<FileHash> = upload.File;

/*
Data center

@ipv6 Whether the specified IP is an IPv6 address
@media_only Whether this DC should only be used to [download or upload files](https://core.telegram.org/api/files)
@tcpo_only Whether this DC only supports connection with [transport obfuscation](https://core.telegram.org/mtproto/mtproto-transports#transport-obfuscation)
@cdn Whether this is a [CDN DC](https://core.telegram.org/cdn).
@static If set, this IP should be used when connecting through a proxy
@this_port_only If set, clients must connect using only the specified port, without trying any other port.
@id DC ID
@ip_address IP address of DC
@port Port
@secret If the tcpo_only flag is set, specifies the secret to use when connecting using [transport obfuscation](https://core.telegram.org/mtproto/mtproto-transports#transport-obfuscation)
*/
dcOption#18b7a10d flags:# ipv6:flags.0?true media_only:flags.1?true tcpo_only:flags.2?true cdn:flags.3?true static:flags.4?true this_port_only:flags.5?true id:int ip_address:string port:int secret:flags.10?bytes = DcOption;

/*
Current configuration

@default_p2p_contacts Whether the client should use P2P by default for phone calls with contacts
@preload_featured_stickers Whether the client should preload featured stickers
@revoke_pm_inbox Whether incoming private messages can be deleted for both participants
@blocked_mode Indicates that telegram is probably censored by governments/ISPs in the current region
@force_try_ipv6 Whether to forcefully connect using IPv6 [dcOptions](https://core.telegram.org/type/DcOption), even if the client knows that IPv4 is available.
@date Current date at the server
@expires Expiration date of this config: when it expires it'll have to be refetched using [help.getConfig](https://core.telegram.org/method/help.getConfig)
@test_mode Whether we're connected to the test DCs
@this_dc ID of the DC that returned the reply
@dc_options DC IP list
@dc_txt_domain_name Domain name for fetching encrypted DC list from DNS TXT record
@chat_size_max Maximum member count for normal [groups](https://core.telegram.org/api/channel)
@megagroup_size_max Maximum member count for [supergroups](https://core.telegram.org/api/channel)
@forwarded_count_max Maximum number of messages that can be forwarded at once using [messages.forwardMessages](https://core.telegram.org/method/messages.forwardMessages).
@online_update_period_ms The client should [update its online status](https://core.telegram.org/method/account.updateStatus) every N milliseconds
@offline_blur_timeout_ms Delay before offline status needs to be sent to the server
@offline_idle_timeout_ms Time without any user activity after which it should be treated offline
@online_cloud_timeout_ms If we are offline, but were online from some other client in last online_cloud_timeout_ms milliseconds after we had gone offline, then delay offline notification for notify_cloud_delay_ms milliseconds.
@notify_cloud_delay_ms If we are offline, but online from some other client then delay sending the offline notification for notify_cloud_delay_ms milliseconds.
@notify_default_delay_ms If some other client is online, then delay notification for notification_default_delay_ms milliseconds
@push_chat_period_ms Not for client use
@push_chat_limit Not for client use
@edit_time_limit Only messages with age smaller than the one specified can be edited
@revoke_time_limit Only channel/supergroup messages with age smaller than the specified can be deleted
@revoke_pm_time_limit Only private messages with age smaller than the specified can be deleted
@rating_e_decay Exponential decay rate for computing [top peer rating](https://core.telegram.org/api/top-rating)
@stickers_recent_limit Maximum number of recent stickers
@channels_read_media_period Indicates that round videos (video notes) and voice messages sent in channels and older than the specified period must be marked as read
@tmp_sessions Temporary [passport](https://core.telegram.org/passport) sessions
@call_receive_timeout_ms Maximum allowed outgoing ring time in VoIP calls: if the user we're calling doesn't reply within the specified time (in milliseconds), we should hang up the call
@call_ring_timeout_ms Maximum allowed incoming ring time in VoIP calls: if the current user doesn't reply within the specified time (in milliseconds), the call will be automatically refused
@call_connect_timeout_ms VoIP connection timeout: if the instance of libtgvoip on the other side of the call doesn't connect to our instance of libtgvoip within the specified time (in milliseconds), the call must be aborted
@call_packet_timeout_ms If during a VoIP call a packet isn't received for the specified period of time, the call must be aborted
@me_url_prefix The domain to use to parse [deep links](https://core.telegram.org/api/links).
@autoupdate_url_prefix URL to use to auto-update the current app
@gif_search_username Username of the bot to use to search for GIFs
@venue_search_username Username of the bot to use to search for venues
@img_search_username Username of the bot to use for image search
@static_maps_provider ID of the map provider to use for venues
@caption_length_max Maximum length of caption (length in utf8 codepoints)
@message_length_max Maximum length of messages (length in utf8 codepoints)
@webfile_dc_id DC ID to use to download [webfiles](https://core.telegram.org/api/files#downloading-webfiles)
@suggested_lang_code Suggested language code
@lang_pack_version Language pack version
@base_lang_pack_version Basic language pack version
@reactions_default Default [message reaction](https://core.telegram.org/api/reactions)
@autologin_token Autologin token, [click here for more info on URL authorization](https://core.telegram.org/api/url-authorization#link-url-authorization).
*/
config#cc1a241e flags:# default_p2p_contacts:flags.3?true preload_featured_stickers:flags.4?true revoke_pm_inbox:flags.6?true blocked_mode:flags.8?true force_try_ipv6:flags.14?true date:int expires:int test_mode:Bool this_dc:int dc_options:Vector<DcOption> dc_txt_domain_name:string chat_size_max:int megagroup_size_max:int forwarded_count_max:int online_update_period_ms:int offline_blur_timeout_ms:int offline_idle_timeout_ms:int online_cloud_timeout_ms:int notify_cloud_delay_ms:int notify_default_delay_ms:int push_chat_period_ms:int push_chat_limit:int edit_time_limit:int revoke_time_limit:int revoke_pm_time_limit:int rating_e_decay:int stickers_recent_limit:int channels_read_media_period:int tmp_sessions:flags.0?int call_receive_timeout_ms:int call_ring_timeout_ms:int call_connect_timeout_ms:int call_packet_timeout_ms:int me_url_prefix:string autoupdate_url_prefix:flags.7?string gif_search_username:flags.9?string venue_search_username:flags.10?string img_search_username:flags.11?string static_maps_provider:flags.12?string caption_length_max:int message_length_max:int webfile_dc_id:int suggested_lang_code:flags.2?string lang_pack_version:flags.2?int base_lang_pack_version:flags.2?int reactions_default:flags.15?Reaction autologin_token:flags.16?string = Config;

/*
Nearest data center, according to geo-ip.

@country Country code determined by geo-ip
@this_dc Number of current data center
@nearest_dc Number of nearest data center
*/
nearestDc#8e1a1775 country:string this_dc:int nearest_dc:int = NearestDc;

/*
An update is available for the application.

@can_not_skip Unskippable, the new info must be shown to the user (with a popup or something else)
@id Update ID
@version New version name
@text Text description of the update
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@document Application binary
@url Application download URL
@sticker Associated sticker
*/
help.appUpdate#ccbbce30 flags:# can_not_skip:flags.0?true id:int version:string text:string entities:Vector<MessageEntity> document:flags.1?Document url:flags.2?string sticker:flags.3?Document = help.AppUpdate;

/*
No updates are available for the application.
*/
help.noAppUpdate#c45a6536 = help.AppUpdate;

/*
Text of a text message with an invitation to install Telegram.

@message Text of the message
*/
help.inviteText#18cb9f78 message:string = help.InviteText;

/*
Empty constructor.

@id Chat ID
*/
encryptedChatEmpty#ab7ec0a0 id:int = EncryptedChat;

/*
Chat waiting for approval of second participant.

@id Chat ID
@access_hash Checking sum depending on user ID
@date Date of chat creation
@admin_id Chat creator ID
@participant_id ID of second chat participant
*/
encryptedChatWaiting#66b25953 id:int access_hash:long date:int admin_id:long participant_id:long = EncryptedChat;

/*
Request to create an encrypted chat.

@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@id Chat ID
@access_hash Check sum depending on user ID
@date Chat creation date
@admin_id Chat creator ID
@participant_id ID of second chat participant
@g_a A = g ^ a mod p, see [Wikipedia](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)
*/
encryptedChatRequested#48f1d94c flags:# folder_id:flags.0?int id:int access_hash:long date:int admin_id:long participant_id:long g_a:bytes = EncryptedChat;

/*
Encrypted chat

@id Chat ID
@access_hash Check sum dependent on the user ID
@date Date chat was created
@admin_id Chat creator ID
@participant_id ID of the second chat participant
@g_a_or_b B = g ^ b mod p, if the currently authorized user is the chat's creator, or A = g ^ a mod p otherwise See [Wikipedia](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange) for more info
@key_fingerprint 64-bit fingerprint of received key
*/
encryptedChat#61f0d4c7 id:int access_hash:long date:int admin_id:long participant_id:long g_a_or_b:bytes key_fingerprint:long = EncryptedChat;

/*
Discarded or deleted chat.

@history_deleted Whether both users of this secret chat should also remove all of its messages
@id Chat ID
*/
encryptedChatDiscarded#1e1c7c45 flags:# history_deleted:flags.0?true id:int = EncryptedChat;

/*
Creates an encrypted chat.

@chat_id Chat ID
@access_hash Checking sum from constructor [encryptedChat](https://core.telegram.org/constructor/encryptedChat), [encryptedChatWaiting](https://core.telegram.org/constructor/encryptedChatWaiting) or [encryptedChatRequested](https://core.telegram.org/constructor/encryptedChatRequested)
*/
inputEncryptedChat#f141b5e1 chat_id:int access_hash:long = InputEncryptedChat;

/*
Empty constructor, non-existing file.
*/
encryptedFileEmpty#c21f497e = EncryptedFile;

/*
Encrypted file.

@id File ID
@access_hash Checking sum depending on user ID
@size File size in bytes
@dc_id Number of data center
@key_fingerprint 32-bit fingerprint of key used for file encryption
*/
encryptedFile#a8008cd8 id:long access_hash:long size:long dc_id:int key_fingerprint:int = EncryptedFile;

/*
Empty constructor.
*/
inputEncryptedFileEmpty#1837c364 = InputEncryptedFile;

/*
Sets new encrypted file saved by parts using upload.saveFilePart method.

@id Random file ID created by client
@parts Number of saved parts
@md5_checksum In case [md5-HASH](https://en.wikipedia.org/wiki/MD5) of the (already encrypted) file was transmitted, file content will be checked prior to use
@key_fingerprint 32-bit fingerprint of the key used to encrypt a file
*/
inputEncryptedFileUploaded#64bd0306 id:long parts:int md5_checksum:string key_fingerprint:int = InputEncryptedFile;

/*
Sets forwarded encrypted file for attachment.

@id File ID, value of id parameter from [encryptedFile](https://core.telegram.org/constructor/encryptedFile)
@access_hash Checking sum, value of access_hash parameter from [encryptedFile](https://core.telegram.org/constructor/encryptedFile)
*/
inputEncryptedFile#5a17b5e5 id:long access_hash:long = InputEncryptedFile;

/*
Assigns a new big encrypted file (over 10 MB in size), saved in parts using the method [upload.saveBigFilePart](https://core.telegram.org/method/upload.saveBigFilePart).

@id Random file id, created by the client
@parts Number of saved parts
@key_fingerprint 32-bit imprint of the key used to encrypt the file
*/
inputEncryptedFileBigUploaded#2dc173c8 id:long parts:int key_fingerprint:int = InputEncryptedFile;

/*
Encrypted message.

@random_id Random message ID, assigned by the author of message
@chat_id ID of encrypted chat
@date Date of sending
@bytes TL-serialization of [DecryptedMessage](https://core.telegram.org/type/DecryptedMessage) type, encrypted with the key created at chat initialization
@file Attached encrypted file
*/
encryptedMessage#ed18c118 random_id:long chat_id:int date:int bytes:bytes file:EncryptedFile = EncryptedMessage;

/*
Encrypted service message

@random_id Random message ID, assigned by the author of message
@chat_id ID of encrypted chat
@date Date of sending
@bytes TL-serialization of the [DecryptedMessage](https://core.telegram.org/type/DecryptedMessage) type, encrypted with the key created at chat initialization
*/
encryptedMessageService#23734b06 random_id:long chat_id:int date:int bytes:bytes = EncryptedMessage;

/*
Configuring parameters did not change.

@random Random sequence of bytes of assigned length
*/
messages.dhConfigNotModified#c0e24635 random:bytes = messages.DhConfig;

/*
New set of configuring parameters.

@g New value prime, see [Wikipedia](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)
@p New value primitive root, see [Wikipedia](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)
@version Version of set of parameters
@random Random sequence of bytes of assigned length
*/
messages.dhConfig#2c221edd g:int p:bytes version:int random:bytes = messages.DhConfig;

/*
Message without file attachments sent to an encrypted file.

@date Date of sending
*/
messages.sentEncryptedMessage#560f8935 date:int = messages.SentEncryptedMessage;

/*
Message with a file enclosure sent to a protected chat

@date Sending date
@file Attached file
*/
messages.sentEncryptedFile#9493ff32 date:int file:EncryptedFile = messages.SentEncryptedMessage;

/*
Empty constructor.
*/
inputDocumentEmpty#72f0eaae = InputDocument;

/*
Defines a document for subsequent interaction.

@id Document ID
@access_hash access_hash parameter from the [document](https://core.telegram.org/constructor/document) constructor
@file_reference [File reference](https://core.telegram.org/api/file_reference)
*/
inputDocument#1abfb575 id:long access_hash:long file_reference:bytes = InputDocument;

/*
Empty constructor, document doesn't exist.

@id Document ID or 0
*/
documentEmpty#36f8c871 id:long = Document;

/*
Document

@id Document ID
@access_hash Check sum, dependent on document ID
@file_reference [File reference](https://core.telegram.org/api/file_reference)
@date Creation date
@mime_type MIME type
@size Size
@thumbs Thumbnails
@video_thumbs Video thumbnails
@dc_id DC ID
@attributes Attributes
*/
document#8fd4c4d8 flags:# id:long access_hash:long file_reference:bytes date:int mime_type:string size:long thumbs:flags.0?Vector<PhotoSize> video_thumbs:flags.1?Vector<VideoSize> dc_id:int attributes:Vector<DocumentAttribute> = Document;

/*
Info on support user.

@phone_number Phone number
@user User
*/
help.support#17c6b5f6 phone_number:string user:User = help.Support;

/*
Notifications generated by a certain user or group.

@peer user or group
*/
notifyPeer#9fd40bd8 peer:Peer = NotifyPeer;

/*
Notifications generated by all users.
*/
notifyUsers#b4c83b4c = NotifyPeer;

/*
Notifications generated by all groups.
*/
notifyChats#c007cec3 = NotifyPeer;

/*
Channel notification settings
*/
notifyBroadcasts#d612e8ef = NotifyPeer;

/*
Notifications generated by a [topic](https://core.telegram.org/api/forum#forum-topics) in a [forum](https://core.telegram.org/api/forum).

@peer Forum ID
@top_msg_id [Topic ID](https://core.telegram.org/api/forum#forum-topics)
*/
notifyForumTopic#226e6308 peer:Peer top_msg_id:int = NotifyPeer;

/*
User is typing.
*/
sendMessageTypingAction#16bf744e = SendMessageAction;

/*
Invalidate all previous action updates. E.g. when user deletes entered text or aborts a video upload.
*/
sendMessageCancelAction#fd5ec8f5 = SendMessageAction;

/*
User is recording a video.
*/
sendMessageRecordVideoAction#a187d66f = SendMessageAction;

/*
User is uploading a video.

@progress Progress percentage
*/
sendMessageUploadVideoAction#e9763aec progress:int = SendMessageAction;

/*
User is recording a voice message.
*/
sendMessageRecordAudioAction#d52f73f7 = SendMessageAction;

/*
User is uploading a voice message.

@progress Progress percentage
*/
sendMessageUploadAudioAction#f351d7ab progress:int = SendMessageAction;

/*
User is uploading a photo.

@progress Progress percentage
*/
sendMessageUploadPhotoAction#d1d34a26 progress:int = SendMessageAction;

/*
User is uploading a file.

@progress Progress percentage
*/
sendMessageUploadDocumentAction#aa0cd9e4 progress:int = SendMessageAction;

/*
User is selecting a location to share.
*/
sendMessageGeoLocationAction#176f8ba1 = SendMessageAction;

/*
User is selecting a contact to share.
*/
sendMessageChooseContactAction#628cbc6f = SendMessageAction;

/*
User is playing a game
*/
sendMessageGamePlayAction#dd6a8f48 = SendMessageAction;

/*
User is recording a round video to share
*/
sendMessageRecordRoundAction#88f27fbc = SendMessageAction;

/*
User is uploading a round video

@progress Progress percentage
*/
sendMessageUploadRoundAction#243e1c66 progress:int = SendMessageAction;

/*
User is currently speaking in the group call
*/
speakingInGroupCallAction#d92c2285 = SendMessageAction;

/*
Chat history is being imported

@progress Progress percentage
*/
sendMessageHistoryImportAction#dbda9246 progress:int = SendMessageAction;

/*
User is choosing a sticker
*/
sendMessageChooseStickerAction#b05ac6b1 = SendMessageAction;

/*
User has clicked on an animated emoji triggering a [reaction, click here for more info](https://core.telegram.org/api/animated-emojis#emoji-reactions).

@emoticon Emoji
@msg_id Message ID of the animated emoji that was clicked
@interaction A JSON object with interaction info, [click here for more info](https://core.telegram.org/api/animated-emojis#emoji-reactions)
*/
sendMessageEmojiInteraction#25972bcb emoticon:string msg_id:int interaction:DataJSON = SendMessageAction;

/*
User is watching an animated emoji reaction triggered by another user, [click here for more info](https://core.telegram.org/api/animated-emojis#emoji-reactions).

@emoticon Emoji
*/
sendMessageEmojiInteractionSeen#b665902e emoticon:string = SendMessageAction;

/*
Users found by name substring and auxiliary data.

@my_results Personalized results
@results List of found user identifiers
@chats Found chats
@users List of users
*/
contacts.found#b3134d9d my_results:Vector<Peer> results:Vector<Peer> chats:Vector<Chat> users:Vector<User> = contacts.Found;

/*
Whether people will be able to see our exact last online timestamp.
*/
inputPrivacyKeyStatusTimestamp#4f96cb18 = InputPrivacyKey;

/*
Whether people will be able to invite you to chats
*/
inputPrivacyKeyChatInvite#bdfb0426 = InputPrivacyKey;

/*
Whether you will accept phone calls
*/
inputPrivacyKeyPhoneCall#fabadc5f = InputPrivacyKey;

/*
Whether to allow P2P communication during VoIP calls
*/
inputPrivacyKeyPhoneP2P#db9e70d2 = InputPrivacyKey;

/*
Whether messages forwarded from you will be [anonymous](https://telegram.org/blog/unsend-privacy-emoji#anonymous-forwarding)
*/
inputPrivacyKeyForwards#a4dd4c08 = InputPrivacyKey;

/*
Whether people will be able to see your profile picture
*/
inputPrivacyKeyProfilePhoto#5719bacc = InputPrivacyKey;

/*
Whether people will be able to see your phone number
*/
inputPrivacyKeyPhoneNumber#352dafa = InputPrivacyKey;

/*
Whether people can add you to their contact list by your phone number
*/
inputPrivacyKeyAddedByPhone#d1219bdd = InputPrivacyKey;

/*
Whether people can send you voice messages or round videos ( [Premium](https://core.telegram.org/api/premium) users only).
*/
inputPrivacyKeyVoiceMessages#aee69d68 = InputPrivacyKey;

/*
Whether people can see your bio
*/
inputPrivacyKeyAbout#3823cc40 = InputPrivacyKey;

/*
Whether the user can see our birthday.
*/
inputPrivacyKeyBirthday#d65a11cc = InputPrivacyKey;

/*
Whether received [gifts](https://core.telegram.org/api/gifts) will be automatically displayed on our profile
*/
inputPrivacyKeyStarGiftsAutoSave#e1732341 = InputPrivacyKey;

/*
Whether we can see the last online timestamp of this user.
*/
privacyKeyStatusTimestamp#bc2eab30 = PrivacyKey;

/*
Whether the user can be invited to chats
*/
privacyKeyChatInvite#500e6dfa = PrivacyKey;

/*
Whether the user accepts phone calls
*/
privacyKeyPhoneCall#3d662b7b = PrivacyKey;

/*
Whether P2P connections in phone calls with this user are allowed
*/
privacyKeyPhoneP2P#39491cc8 = PrivacyKey;

/*
Whether messages forwarded from the user will be [anonymously forwarded](https://telegram.org/blog/unsend-privacy-emoji#anonymous-forwarding)
*/
privacyKeyForwards#69ec56a3 = PrivacyKey;

/*
Whether the profile picture of the user is visible
*/
privacyKeyProfilePhoto#96151fed = PrivacyKey;

/*
Whether the user allows us to see his phone number
*/
privacyKeyPhoneNumber#d19ae46d = PrivacyKey;

/*
Whether this user can be added to our contact list by their phone number
*/
privacyKeyAddedByPhone#42ffd42b = PrivacyKey;

/*
Whether the user accepts voice messages
*/
privacyKeyVoiceMessages#697f414 = PrivacyKey;

/*
Whether people can see your bio
*/
privacyKeyAbout#a486b761 = PrivacyKey;

/*
Whether the user can see our birthday.
*/
privacyKeyBirthday#2000a518 = PrivacyKey;

/*
Whether received [gifts](https://core.telegram.org/api/gifts) will be automatically displayed on our profile
*/
privacyKeyStarGiftsAutoSave#2ca4fdf8 = PrivacyKey;

/*
Allow only contacts
*/
inputPrivacyValueAllowContacts#d09e07b = InputPrivacyRule;

/*
Allow all users
*/
inputPrivacyValueAllowAll#184b35ce = InputPrivacyRule;

/*
Allow only certain users

@users Allowed users
*/
inputPrivacyValueAllowUsers#131cc67f users:Vector<InputUser> = InputPrivacyRule;

/*
Disallow only contacts
*/
inputPrivacyValueDisallowContacts#ba52007 = InputPrivacyRule;

/*
Disallow all
*/
inputPrivacyValueDisallowAll#d66b66c9 = InputPrivacyRule;

/*
Disallow only certain users

@users Users to disallow
*/
inputPrivacyValueDisallowUsers#90110467 users:Vector<InputUser> = InputPrivacyRule;

/*
Allow only participants of certain chats

@chats Allowed chat IDs
*/
inputPrivacyValueAllowChatParticipants#840649cf chats:Vector<long> = InputPrivacyRule;

/*
Disallow only participants of certain chats

@chats Disallowed chat IDs
*/
inputPrivacyValueDisallowChatParticipants#e94f0f86 chats:Vector<long> = InputPrivacyRule;

/*
Allow only [close friends](https://core.telegram.org/api/privacy)
*/
inputPrivacyValueAllowCloseFriends#2f453e49 = InputPrivacyRule;

/*
Allow only users with a [Premium subscription](https://core.telegram.org/api/premium), currently only usable for [inputPrivacyKeyChatInvite](https://core.telegram.org/constructor/inputPrivacyKeyChatInvite).
*/
inputPrivacyValueAllowPremium#77cdc9f1 = InputPrivacyRule;

/*
Allow bots and mini apps
*/
inputPrivacyValueAllowBots#5a4fcce5 = InputPrivacyRule;

/*
Disallow bots and mini apps
*/
inputPrivacyValueDisallowBots#c4e57915 = InputPrivacyRule;

/*
Allow all contacts
*/
privacyValueAllowContacts#fffe1bac = PrivacyRule;

/*
Allow all users
*/
privacyValueAllowAll#65427b82 = PrivacyRule;

/*
Allow only certain users

@users Allowed users
*/
privacyValueAllowUsers#b8905fb2 users:Vector<long> = PrivacyRule;

/*
Disallow only contacts
*/
privacyValueDisallowContacts#f888fa1a = PrivacyRule;

/*
Disallow all users
*/
privacyValueDisallowAll#8b73e763 = PrivacyRule;

/*
Disallow only certain users

@users Disallowed users
*/
privacyValueDisallowUsers#e4621141 users:Vector<long> = PrivacyRule;

/*
Allow all participants of certain chats

@chats Allowed chats
*/
privacyValueAllowChatParticipants#6b134e8e chats:Vector<long> = PrivacyRule;

/*
Disallow only participants of certain chats

@chats Disallowed chats
*/
privacyValueDisallowChatParticipants#41c87565 chats:Vector<long> = PrivacyRule;

/*
Allow only [close friends](https://core.telegram.org/api/privacy)
*/
privacyValueAllowCloseFriends#f7e8d89b = PrivacyRule;

/*
Allow only users with a [Premium subscription](https://core.telegram.org/api/premium), currently only usable for [inputPrivacyKeyChatInvite](https://core.telegram.org/constructor/inputPrivacyKeyChatInvite).
*/
privacyValueAllowPremium#ece9814b = PrivacyRule;

/*
Allow bots and mini apps
*/
privacyValueAllowBots#21461b5d = PrivacyRule;

/*
Disallow bots and mini apps
*/
privacyValueDisallowBots#f6a5f82f = PrivacyRule;

/*
Privacy rules

@rules Privacy rules
@chats Chats to which the rules apply
@users Users to which the rules apply
*/
account.privacyRules#50a04e45 rules:Vector<PrivacyRule> chats:Vector<Chat> users:Vector<User> = account.PrivacyRules;

/*
Time to live in days of the current account

@days This account will self-destruct in the specified number of days
*/
accountDaysTTL#b8d0afdf days:int = AccountDaysTTL;

/*
Defines the width and height of an image uploaded as document

@w Width of image
@h Height of image
*/
documentAttributeImageSize#6c37c15c w:int h:int = DocumentAttribute;

/*
Defines an animated GIF
*/
documentAttributeAnimated#11b58939 = DocumentAttribute;

/*
Defines a sticker

@mask Whether this is a mask sticker
@alt Alternative emoji representation of sticker
@stickerset Associated stickerset
@mask_coords Mask coordinates (if this is a mask sticker, attached to a photo)
*/
documentAttributeSticker#6319d612 flags:# mask:flags.1?true alt:string stickerset:InputStickerSet mask_coords:flags.0?MaskCoords = DocumentAttribute;

/*
Defines a video

@round_message Whether this is a round video
@supports_streaming Whether the video supports streaming
@nosound Whether the specified document is a video file with no audio tracks (a GIF animation (even as MPEG4), for example)
@duration Duration in seconds
@w Video width
@h Video height
@preload_prefix_size Number of bytes to preload when preloading videos (particularly [video stories](https://core.telegram.org/api/stories)).
@video_start_ts Floating point UNIX timestamp in seconds, indicating the frame of the video that should be used as static preview and thumbnail.
@video_codec Codec used for the video, i.e. "h264", "h265", or "av1"
*/
documentAttributeVideo#43c57c48 flags:# round_message:flags.0?true supports_streaming:flags.1?true nosound:flags.3?true duration:double w:int h:int preload_prefix_size:flags.2?int video_start_ts:flags.4?double video_codec:flags.5?string = DocumentAttribute;

/*
Represents an audio file

@voice Whether this is a voice message
@duration Duration in seconds
@title Name of song
@performer Performer
@waveform Waveform: consists in a series of bitpacked 5-bit values. Example implementation: [android](https://github.com/DrKLO/Telegram/blob/96dce2c9aabc33b87db61d830aa087b6b03fe397/TMessagesProj/jni/audio.c#L546).
*/
documentAttributeAudio#9852f9c6 flags:# voice:flags.10?true duration:int title:flags.0?string performer:flags.1?string waveform:flags.2?bytes = DocumentAttribute;

/*
A simple document with a file name

@file_name The file name
*/
documentAttributeFilename#15590068 file_name:string = DocumentAttribute;

/*
Whether the current document has stickers attached
*/
documentAttributeHasStickers#9801d2f7 = DocumentAttribute;

/*
Info about a custom emoji

@free Whether this custom emoji can be sent by non-Premium users
@text_color Whether the color of this TGS custom emoji should be changed to the text color when used in messages, the accent color if used as emoji status, white on chat photos, or another appropriate color based on context.
@alt The actual emoji
@stickerset The emoji stickerset to which this emoji belongs.
*/
documentAttributeCustomEmoji#fd149899 flags:# free:flags.0?true text_color:flags.1?true alt:string stickerset:InputStickerSet = DocumentAttribute;

/*
No new stickers were found for the given query
*/
messages.stickersNotModified#f1749a22 = messages.Stickers;

/*
Found stickers

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@stickers Stickers
*/
messages.stickers#30a6ec7e hash:long stickers:Vector<Document> = messages.Stickers;

/*
A stickerpack is a group of stickers associated to the same emoji. 
It is not a sticker pack the way it is usually intended, you may be looking for a [StickerSet](https://core.telegram.org/type/StickerSet).

@emoticon Emoji
@documents Stickers
*/
stickerPack#12b299d4 emoticon:string documents:Vector<long> = StickerPack;

/*
Info about all installed stickers hasn't changed
*/
messages.allStickersNotModified#e86602c3 = messages.AllStickers;

/*
Info about all installed stickers

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@sets All stickersets
*/
messages.allStickers#cdbbcebb hash:long sets:Vector<StickerSet> = messages.AllStickers;

/*
Events affected by operation

@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
*/
messages.affectedMessages#84d19185 pts:int pts_count:int = messages.AffectedMessages;

/*
No preview is available for the webpage

@id Preview ID
@url URL of the webpage.
*/
webPageEmpty#211a1788 flags:# id:long url:flags.0?string = WebPage;

/*
A preview of the webpage is currently being generated

@id ID of preview
@url URL of the webpage
@date When was the processing started
*/
webPagePending#b0d13e47 flags:# id:long url:flags.0?string date:int = WebPage;

/*
Webpage preview

@has_large_media Whether the size of the media in the preview can be changed.
@video_cover_photo  ... 
@id Preview ID
@url URL of previewed webpage
@display_url Webpage URL to be displayed to the user
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@type Type of the web page. One of the following: - video - gif - photo - document - profile - telegram_background - telegram_theme - telegram_story - telegram_channel - telegram_channel_request - telegram_megagroup - telegram_chat - telegram_megagroup_request - telegram_chat_request - telegram_album - telegram_message - telegram_bot - telegram_voicechat - telegram_livestream - telegram_user - telegram_botapp - telegram_channel_boost - telegram_group_boost - telegram_giftcode - telegram_stickerset
@site_name Short name of the site (e.g., Google Docs, App Store)
@title Title of the content
@description Content description
@photo Image representing the content
@embed_url URL to show in the embedded preview
@embed_type MIME type of the embedded preview, (e.g., text/html or video/mp4)
@embed_width Width of the embedded preview
@embed_height Height of the embedded preview
@duration Duration of the content, in seconds
@author Author of the content
@document Preview of the content as a media file
@cached_page Page contents in [instant view](https://instantview.telegram.org) format
@attributes Webpage attributes

#DocError
*/
webPage#e89c45b2 flags:# has_large_media:flags.13?true video_cover_photo:flags.14?true id:long url:string display_url:string hash:int type:flags.0?string site_name:flags.1?string title:flags.2?string description:flags.3?string photo:flags.4?Photo embed_url:flags.5?string embed_type:flags.5?string embed_width:flags.6?int embed_height:flags.6?int duration:flags.7?int author:flags.8?string document:flags.9?Document cached_page:flags.10?Page attributes:flags.12?Vector<WebPageAttribute> = WebPage;

/*
The preview of the webpage hasn't changed

@cached_page_views Page view count
*/
webPageNotModified#7311ca11 flags:# cached_page_views:flags.0?int = WebPage;

/*
Logged-in session

@current Whether this is the current session
@official_app Whether the session is from an official app
@password_pending Whether the session is still waiting for a 2FA password
@encrypted_requests_disabled Whether this session will accept encrypted chats
@call_requests_disabled Whether this session will accept phone calls
@unconfirmed Whether the session is [unconfirmed, see here](https://core.telegram.org/api/auth#confirming-login) for more info.
@hash Identifier
@device_model Device model
@platform Platform
@system_version System version
@api_id [API ID](https://core.telegram.org/api/obtaining_api_id)
@app_name App name
@app_version App version
@date_created When was the session created
@date_active When was the session last active
@ip Last known IP
@country Country determined from IP
@region Region determined from IP
*/
authorization#ad01d61d flags:# current:flags.0?true official_app:flags.1?true password_pending:flags.2?true encrypted_requests_disabled:flags.3?true call_requests_disabled:flags.4?true unconfirmed:flags.5?true hash:long device_model:string platform:string system_version:string api_id:int app_name:string app_version:string date_created:int date_active:int ip:string country:string region:string = Authorization;

/*
Logged-in sessions

@authorization_ttl_days Time-to-live of session
@authorizations Logged-in sessions
*/
account.authorizations#4bff8ea0 authorization_ttl_days:int authorizations:Vector<Authorization> = account.Authorizations;

/*
Configuration for two-factor authorization

@has_recovery Whether the user has a recovery method configured
@has_secure_values Whether telegram [passport](https://core.telegram.org/passport) is enabled
@has_password Whether the user has a password
@current_algo The [KDF algorithm for SRP two-factor authentication](https://core.telegram.org/api/srp) of the current password
@srp_B Srp B param for [SRP authorization](https://core.telegram.org/api/srp)
@srp_id Srp ID param for [SRP authorization](https://core.telegram.org/api/srp)
@hint Text hint for the password
@email_unconfirmed_pattern A [password recovery email](https://core.telegram.org/api/srp#email-verification) with the specified [pattern](https://core.telegram.org/api/pattern) is still awaiting verification
@new_algo The [KDF algorithm for SRP two-factor authentication](https://core.telegram.org/api/srp) to use when creating new passwords
@new_secure_algo The KDF algorithm for telegram [passport](https://core.telegram.org/passport)
@secure_random Secure random string
@pending_reset_date The 2FA password will be automatically removed at this date, unless the user cancels the operation
@login_email_pattern A verified login email with the specified [pattern](https://core.telegram.org/api/pattern) is configured
*/
account.password#957b50fb flags:# has_recovery:flags.0?true has_secure_values:flags.1?true has_password:flags.2?true current_algo:flags.2?PasswordKdfAlgo srp_B:flags.2?bytes srp_id:flags.2?long hint:flags.3?string email_unconfirmed_pattern:flags.4?string new_algo:PasswordKdfAlgo new_secure_algo:SecurePasswordKdfAlgo secure_random:bytes pending_reset_date:flags.5?int login_email_pattern:flags.6?string = account.Password;

/*
Private info associated to the password info (recovery email, telegram [passport](https://core.telegram.org/passport) info & so on)

@email [2FA Recovery email](https://core.telegram.org/api/srp#email-verification)
@secure_settings Telegram [passport](https://core.telegram.org/passport) settings
*/
account.passwordSettings#9a5c33e5 flags:# email:flags.0?string secure_settings:flags.1?SecureSecretSettings = account.PasswordSettings;

/*
Settings for setting up a new password

@new_algo The [SRP algorithm](https://core.telegram.org/api/srp) to use
@new_password_hash The [computed password hash](https://core.telegram.org/api/srp)
@hint Text hint for the password
@email Password recovery email
@new_secure_settings Telegram [passport](https://core.telegram.org/passport) settings
*/
account.passwordInputSettings#c23727c9 flags:# new_algo:flags.0?PasswordKdfAlgo new_password_hash:flags.0?bytes hint:flags.0?string email:flags.1?string new_secure_settings:flags.2?SecureSecretSettings = account.PasswordInputSettings;

/*
Recovery info of a [2FA password](https://core.telegram.org/api/srp), only for accounts with a [recovery email configured](https://core.telegram.org/api/srp#email-verification).

@email_pattern The email to which the recovery code was sent must match this [pattern](https://core.telegram.org/api/pattern).
*/
auth.passwordRecovery#137948a5 email_pattern:string = auth.PasswordRecovery;

/*
Message ID, for which PUSH-notifications were cancelled.

@id Message ID, for which PUSH-notifications were canceled
*/
receivedNotifyMessage#a384b779 id:int flags:int = ReceivedNotifyMessage;

/*
Exported chat invite

@revoked Whether this chat invite was revoked
@permanent Whether this chat invite has no expiration
@request_needed Whether users importing this invite link will have to be approved to join the channel or group
@link Chat invitation link
@admin_id ID of the admin that created this chat invite
@date When was this chat invite created
@start_date When was this chat invite last modified
@expire_date When does this chat invite expire
@usage_limit Maximum number of users that can join using this link
@usage How many users joined using this link
@requested Number of users that have already used this link to join
@subscription_expired For [Telegram Star subscriptions](https://core.telegram.org/api/stars#star-subscriptions), contains the number of chat members which have already joined the chat using the link, but have already left due to expiration of their subscription.
@title Custom description for the invite link, visible only to admins
@subscription_pricing For [Telegram Star subscriptions](https://core.telegram.org/api/stars#star-subscriptions), contains the pricing of the subscription the user must activate to join the private channel.
*/
chatInviteExported#a22cbd96 flags:# revoked:flags.0?true permanent:flags.5?true request_needed:flags.6?true link:string admin_id:long date:int start_date:flags.4?int expire_date:flags.1?int usage_limit:flags.2?int usage:flags.3?int requested:flags.7?int subscription_expired:flags.10?int title:flags.8?string subscription_pricing:flags.9?StarsSubscriptionPricing = ExportedChatInvite;

/*
Used in updates and in the channel log to indicate when a user is requesting to join or has joined a [discussion group](https://core.telegram.org/api/discussion#requiring-users-to-join-the-group)
*/
chatInvitePublicJoinRequests#ed107ab7 = ExportedChatInvite;

/*
The user has already joined this chat

@chat The chat connected to the invite
*/
chatInviteAlready#5a686d7c chat:Chat = ChatInvite;

/*
Chat invite info

@channel Whether this is a [channel/supergroup](https://core.telegram.org/api/channel) or a [normal group](https://core.telegram.org/api/channel)
@broadcast Whether this is a [channel](https://core.telegram.org/api/channel)
@public Whether this is a public [channel/supergroup](https://core.telegram.org/api/channel)
@megagroup Whether this is a [supergroup](https://core.telegram.org/api/channel)
@request_needed Whether the [join request](https://core.telegram.org/api/invites#join-requests) must be first approved by an administrator
@verified Is this chat or channel verified by Telegram?
@scam This chat is probably a scam
@fake If set, this chat was reported by many users as a fake or scam: be careful when interacting with it.
@can_refulfill_subscription If set, indicates that the user has already paid for the associated [Telegram Star subscriptions](https://core.telegram.org/api/stars#star-subscriptions) and it hasn't expired yet, so they may re-join the channel using [messages.importChatInvite](https://core.telegram.org/method/messages.importChatInvite) without repeating the payment.
@title Chat/supergroup/channel title
@about Description of the group of channel
@photo Chat/supergroup/channel photo
@participants_count Participant count
@participants A few of the participants that are in the group
@color [Profile color palette ID](https://core.telegram.org/api/colors)
@subscription_pricing For [Telegram Star subscriptions](https://core.telegram.org/api/stars#star-subscriptions), contains the pricing of the subscription the user must activate to join the private channel.
@subscription_form_id For [Telegram Star subscriptions](https://core.telegram.org/api/stars#star-subscriptions), the ID of the payment form for the subscription.
@bot_verification  ... 

#DocError
*/
chatInvite#5c9d3702 flags:# channel:flags.0?true broadcast:flags.1?true public:flags.2?true megagroup:flags.3?true request_needed:flags.6?true verified:flags.7?true scam:flags.8?true fake:flags.9?true can_refulfill_subscription:flags.11?true title:string about:flags.5?string photo:Photo participants_count:int participants:flags.4?Vector<User> color:int subscription_pricing:flags.10?StarsSubscriptionPricing subscription_form_id:flags.12?long bot_verification:flags.13?BotVerification = ChatInvite;

/*
A chat invitation that also allows peeking into the group to read messages without joining it.

@chat Chat information
@expires Read-only anonymous access to this group will be revoked at this date
*/
chatInvitePeek#61695cb0 chat:Chat expires:int = ChatInvite;

/*
Empty constructor
*/
inputStickerSetEmpty#ffb62b95 = InputStickerSet;

/*
Stickerset by ID

@id ID
@access_hash Access hash
*/
inputStickerSetID#9de7a269 id:long access_hash:long = InputStickerSet;

/*
Stickerset by short name, from a [stickerset deep link](https://core.telegram.org/api/links#stickerset-links)

@short_name Short name from a [stickerset deep link](https://core.telegram.org/api/links#stickerset-links)
*/
inputStickerSetShortName#861cc8a0 short_name:string = InputStickerSet;

/*
Animated emojis stickerset
*/
inputStickerSetAnimatedEmoji#28703c8 = InputStickerSet;

/*
Used for fetching [animated dice stickers](https://core.telegram.org/api/dice)

@emoticon The emoji, for now ,  and  are supported
*/
inputStickerSetDice#e67f520e emoticon:string = InputStickerSet;

/*
Animated emoji reaction stickerset (contains animations to play when a user clicks on a given animated emoji)
*/
inputStickerSetAnimatedEmojiAnimations#cde3739 = InputStickerSet;

/*
Stickers to show when receiving a gifted Telegram Premium subscription
*/
inputStickerSetPremiumGifts#c88b3b02 = InputStickerSet;

/*
Generic animation stickerset containing animations to play when [reacting to messages using a normal emoji without a custom animation](https://core.telegram.org/api/reactions)
*/
inputStickerSetEmojiGenericAnimations#4c4d4ce = InputStickerSet;

/*
Default [custom emoji status](https://core.telegram.org/api/emoji-status) stickerset
*/
inputStickerSetEmojiDefaultStatuses#29d0f5ee = InputStickerSet;

/*
Default [custom emoji](https://core.telegram.org/api/custom-emoji) stickerset for [forum topic icons](https://core.telegram.org/api/forum#forum-topics)
*/
inputStickerSetEmojiDefaultTopicIcons#44c1f8e9 = InputStickerSet;

/*
Default [custom emoji status](https://core.telegram.org/api/emoji-status) stickerset for channel statuses
*/
inputStickerSetEmojiChannelDefaultStatuses#49748553 = InputStickerSet;

/*
Represents a stickerset (stickerpack)

@archived Whether this stickerset was archived (due to too many saved stickers in the current account)
@official Is this stickerset official
@masks Is this a mask stickerset
@emojis This is a custom emoji stickerset
@text_color Whether the color of this TGS custom emoji stickerset should be changed to the text color when used in messages, the accent color if used as emoji status, white on chat photos, or another appropriate color based on context.
@channel_emoji_status If set, this custom emoji stickerset can be used in [channel/supergroup emoji statuses](https://core.telegram.org/api/emoji-status).
@creator Whether we created this stickerset
@installed_date When was this stickerset installed
@id ID of the stickerset
@access_hash Access hash of stickerset
@title Title of stickerset
@short_name Short name of stickerset, used when sharing stickerset using [stickerset deep links](https://core.telegram.org/api/links#stickerset-links).
@thumbs Stickerset thumbnail
@thumb_dc_id DC ID of thumbnail
@thumb_version Thumbnail version
@thumb_document_id Document ID of custom emoji thumbnail, fetch the document using [messages.getCustomEmojiDocuments](https://core.telegram.org/method/messages.getCustomEmojiDocuments)
@count Number of stickers in pack
@hash Hash
*/
stickerSet#2dd14edc flags:# archived:flags.1?true official:flags.2?true masks:flags.3?true emojis:flags.7?true text_color:flags.9?true channel_emoji_status:flags.10?true creator:flags.11?true installed_date:flags.0?int id:long access_hash:long title:string short_name:string thumbs:flags.4?Vector<PhotoSize> thumb_dc_id:flags.4?int thumb_version:flags.4?int thumb_document_id:flags.8?long count:int hash:int = StickerSet;

/*
Stickerset and stickers inside it

@set The stickerset
@packs Emoji info for stickers
@keywords Keywords for some or every sticker in the stickerset.
@documents Stickers in stickerset
*/
messages.stickerSet#6e153f16 set:StickerSet packs:Vector<StickerPack> keywords:Vector<StickerKeyword> documents:Vector<Document> = messages.StickerSet;

/*
The stickerset hasn't changed
*/
messages.stickerSetNotModified#d3f924eb = messages.StickerSet;

/*
Describes a bot command that can be used in a chat

@command /command name
@description Description of the command
*/
botCommand#c27ac8c7 command:string description:string = BotCommand;

/*
Info about bots (available bot commands, etc)

@has_preview_medias If set, the bot has some [preview medias for the configured Main Mini App, see here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews) for more info on Main Mini App preview medias.
@user_id ID of the bot
@description Description of the bot
@description_photo Description photo
@description_document Description animation in MPEG4 format
@commands Bot commands that can be used in the chat
@menu_button Indicates the action to execute when pressing the in-UI menu button for bots
@privacy_policy_url The HTTP link to the privacy policy of the bot. If not set, then the /privacy command must be used, if supported by the bot (i.e. if it's present in the commands vector). If it isn't supported, then [https://telegram.org/privacy-tpa](https://telegram.org/privacy-tpa) must be opened, instead.
@app_settings [Mini app](https://core.telegram.org/api/bots/webapps) settings
@verifier_settings  ... 

#DocError
*/
botInfo#4d8a0299 flags:# has_preview_medias:flags.6?true user_id:flags.0?long description:flags.1?string description_photo:flags.4?Photo description_document:flags.5?Document commands:flags.2?Vector<BotCommand> menu_button:flags.3?BotMenuButton privacy_policy_url:flags.7?string app_settings:flags.8?BotAppSettings verifier_settings:flags.9?BotVerifierSettings = BotInfo;

/*
Bot keyboard button

@text Button text
*/
keyboardButton#a2fa4880 text:string = KeyboardButton;

/*
URL button

@text Button label
@url URL
*/
keyboardButtonUrl#258aff05 text:string url:string = KeyboardButton;

/*
Callback button

@requires_password Whether the user should verify his identity by entering his [2FA SRP parameters](https://core.telegram.org/api/srp) to the [messages.getBotCallbackAnswer](https://core.telegram.org/method/messages.getBotCallbackAnswer) method. NOTE: telegram and the bot WILL NOT have access to the plaintext password, thanks to [SRP](https://core.telegram.org/api/srp). This button is mainly used by the official [@botfather](https://t.me/botfather) bot, for verifying the user's identity before transferring ownership of a bot to another user.
@text Button text
@data Callback data
*/
keyboardButtonCallback#35bbdb6b flags:# requires_password:flags.0?true text:string data:bytes = KeyboardButton;

/*
Button to request a user's phone number

@text Button text
*/
keyboardButtonRequestPhone#b16a6c29 text:string = KeyboardButton;

/*
Button to request a user's geolocation

@text Button text
*/
keyboardButtonRequestGeoLocation#fc796b3f text:string = KeyboardButton;

/*
Button to force a user to switch to inline mode: pressing the button will prompt the user to select one of their chats, open that chat and insert the bot's username and the specified inline query in the input field.

@same_peer If set, pressing the button will insert the bot's username and the specified inline query in the current chat's input field.
@text Button label
@query The inline query to use
@peer_types Filter to use when selecting chats.
*/
keyboardButtonSwitchInline#93b9fbb5 flags:# same_peer:flags.0?true text:string query:string peer_types:flags.1?Vector<InlineQueryPeerType> = KeyboardButton;

/*
Button to start a game

@text Button text
*/
keyboardButtonGame#50f41ccf text:string = KeyboardButton;

/*
Button to buy a product

@text Button text
*/
keyboardButtonBuy#afd93fbb text:string = KeyboardButton;

/*
Button to request a user to authorize via URL using [Seamless Telegram Login](https://telegram.org/blog/privacy-discussions-web-bots#meet-seamless-web-bots). When the user clicks on such a button, [messages.requestUrlAuth](https://core.telegram.org/method/messages.requestUrlAuth) should be called, providing the button_id and the ID of the container message. The returned [urlAuthResultRequest](https://core.telegram.org/constructor/urlAuthResultRequest) object will contain more details about the authorization request ( request_write_access if the bot would like to send messages to the user along with the username of the bot which will be used for user authorization). Finally, the user can choose to call [messages.acceptUrlAuth](https://core.telegram.org/method/messages.acceptUrlAuth) to get a [urlAuthResultAccepted](https://core.telegram.org/constructor/urlAuthResultAccepted) with the URL to open instead of the url of this constructor, or a [urlAuthResultDefault](https://core.telegram.org/constructor/urlAuthResultDefault), in which case the url of this constructor must be opened, instead. If the user refuses the authorization request but still wants to open the link, the url of this constructor must be used.

@text Button label
@fwd_text New text of the button in forwarded messages.
@url An HTTP URL to be opened with user authorization data added to the query string when the button is pressed. If the user refuses to provide authorization data, the original URL without information about the user will be opened. The data added is the same as described in [Receiving authorization data](https://core.telegram.org/widgets/login#receiving-authorization-data). NOTE: Services must always check the hash of the received data to verify the authentication and the integrity of the data as described in [Checking authorization](https://core.telegram.org/widgets/login#checking-authorization).
@button_id ID of the button to pass to [messages.requestUrlAuth](https://core.telegram.org/method/messages.requestUrlAuth)
*/
keyboardButtonUrlAuth#10b78d29 flags:# text:string fwd_text:flags.0?string url:string button_id:int = KeyboardButton;

/*
Button to request a user to [authorize](https://core.telegram.org/method/messages.acceptUrlAuth) via URL using [Seamless Telegram Login](https://telegram.org/blog/privacy-discussions-web-bots#meet-seamless-web-bots).

@request_write_access Set this flag to request the permission for your bot to send messages to the user.
@text Button text
@fwd_text New text of the button in forwarded messages.
@url An HTTP URL to be opened with user authorization data added to the query string when the button is pressed. If the user refuses to provide authorization data, the original URL without information about the user will be opened. The data added is the same as described in [Receiving authorization data](https://core.telegram.org/widgets/login#receiving-authorization-data). NOTE: You must always check the hash of the received data to verify the authentication and the integrity of the data as described in [Checking authorization](https://core.telegram.org/widgets/login#checking-authorization).
@bot Username of a bot, which will be used for user authorization. See [Setting up a bot](https://core.telegram.org/widgets/login#setting-up-a-bot) for more details. If not specified, the current bot's username will be assumed. The url's domain must be the same as the domain linked with the bot. See [Linking your domain to the bot](https://core.telegram.org/widgets/login#linking-your-domain-to-the-bot) for more details.
*/
inputKeyboardButtonUrlAuth#d02e7fd4 flags:# request_write_access:flags.0?true text:string fwd_text:flags.1?string url:string bot:InputUser = KeyboardButton;

/*
A button that allows the user to create and send a poll when pressed; available only in private

@quiz If set, only quiz polls can be sent
@text Button text
*/
keyboardButtonRequestPoll#bbc7515d flags:# quiz:flags.0?Bool text:string = KeyboardButton;

/*
Button that links directly to a user profile

@text Button text
@user_id User ID
*/
inputKeyboardButtonUserProfile#e988037b text:string user_id:InputUser = KeyboardButton;

/*
Button that links directly to a user profile

@text Button text
@user_id User ID
*/
keyboardButtonUserProfile#308660c1 text:string user_id:long = KeyboardButton;

/*
Button to open a [bot mini app](https://core.telegram.org/api/bots/webapps) using [messages.requestWebView](https://core.telegram.org/method/messages.requestWebView), sending over user information after user confirmation.

@text Button text
@url [Web app url](https://core.telegram.org/api/bots/webapps)
*/
keyboardButtonWebView#13767230 text:string url:string = KeyboardButton;

/*
Button to open a [bot mini app](https://core.telegram.org/api/bots/webapps) using [messages.requestSimpleWebView](https://core.telegram.org/method/messages.requestSimpleWebView), without sending user information to the web app.

@text Button text
@url [Web app URL](https://core.telegram.org/api/bots/webapps)
*/
keyboardButtonSimpleWebView#a0c0505c text:string url:string = KeyboardButton;

/*
Prompts the user to select and share one or more peers with the bot using [messages.sendBotRequestedPeer](https://core.telegram.org/method/messages.sendBotRequestedPeer)

@text Button text
@button_id Button ID, to be passed to [messages.sendBotRequestedPeer](https://core.telegram.org/method/messages.sendBotRequestedPeer).
@peer_type Filtering criteria to use for the peer selection list shown to the user. The list should display all existing peers of the specified type, and should also offer an option for the user to create and immediately use one or more (up to max_quantity) peers of the specified type, if needed.
@max_quantity Maximum number of peers that can be chosen.
*/
keyboardButtonRequestPeer#53d7bfd8 text:string button_id:int peer_type:RequestPeerType max_quantity:int = KeyboardButton;

/*
Prompts the user to select and share one or more peers with the bot using [messages.sendBotRequestedPeer](https://core.telegram.org/method/messages.sendBotRequestedPeer).

@name_requested Set this flag to request the peer's name.
@username_requested Set this flag to request the peer's @username (if any).
@photo_requested Set this flag to request the peer's photo (if any).
@text Button text
@button_id Button ID, to be passed to [messages.sendBotRequestedPeer](https://core.telegram.org/method/messages.sendBotRequestedPeer).
@peer_type Filtering criteria to use for the peer selection list shown to the user. The list should display all existing peers of the specified type, and should also offer an option for the user to create and immediately use one or more (up to max_quantity) peers of the specified type, if needed.
@max_quantity Maximum number of peers that can be chosen.
*/
inputKeyboardButtonRequestPeer#c9662d05 flags:# name_requested:flags.0?true username_requested:flags.1?true photo_requested:flags.2?true text:string button_id:int peer_type:RequestPeerType max_quantity:int = KeyboardButton;

/*
Clipboard button: when clicked, the attached text must be copied to the clipboard.

@text Title of the button
@copy_text The text that will be copied to the clipboard
*/
keyboardButtonCopy#75d2698e text:string copy_text:string = KeyboardButton;

/*
Inline keyboard row

@buttons Bot or inline keyboard buttons
*/
keyboardButtonRow#77608b83 buttons:Vector<KeyboardButton> = KeyboardButtonRow;

/*
Hide sent bot keyboard

@selective Use this flag if you want to remove the keyboard for specific users only. Targets: 1) users that are @mentioned in the text of the Message object; 2) if the bot's message is a reply (has reply_to_message_id), sender of the original message. Example: A user votes in a poll, bot returns confirmation message in reply to the vote and removes the keyboard for that user, while still showing the keyboard with poll options to users who haven't voted yet
*/
replyKeyboardHide#a03e5b85 flags:# selective:flags.2?true = ReplyMarkup;

/*
Force the user to send a reply

@single_use Requests clients to hide the keyboard as soon as it's been used. The keyboard will still be available, but clients will automatically display the usual letter-keyboard in the chat – the user can press a special button in the input field to see the custom keyboard again.
@selective Use this parameter if you want to show the keyboard to specific users only. Targets: 1) users that are @mentioned in the text of the Message object; 2) if the bot's message is a reply (has reply_to_message_id), sender of the original message. Example: A user requests to change the bot's language, bot replies to the request with a keyboard to select the new language. Other users in the group don't see the keyboard.
@placeholder The placeholder to be shown in the input field when the keyboard is active; 1-64 characters.
*/
replyKeyboardForceReply#86b40b08 flags:# single_use:flags.1?true selective:flags.2?true placeholder:flags.3?string = ReplyMarkup;

/*
Bot keyboard

@resize Requests clients to resize the keyboard vertically for optimal fit (e.g., make the keyboard smaller if there are just two rows of buttons). If not set, the custom keyboard is always of the same height as the app's standard keyboard.
@single_use Requests clients to hide the keyboard as soon as it's been used. The keyboard will still be available, but clients will automatically display the usual letter-keyboard in the chat – the user can press a special button in the input field to see the custom keyboard again.
@selective Use this parameter if you want to show the keyboard to specific users only. Targets: 1) users that are @mentioned in the text of the Message object; 2) if the bot's message is a reply (has reply_to_message_id), sender of the original message. Example: A user requests to change the bot's language, bot replies to the request with a keyboard to select the new language. Other users in the group don't see the keyboard.
@persistent Requests clients to always show the keyboard when the regular keyboard is hidden.
@rows Button row
@placeholder The placeholder to be shown in the input field when the keyboard is active; 1-64 characters.
*/
replyKeyboardMarkup#85dd99d1 flags:# resize:flags.0?true single_use:flags.1?true selective:flags.2?true persistent:flags.4?true rows:Vector<KeyboardButtonRow> placeholder:flags.3?string = ReplyMarkup;

/*
Bot or inline keyboard

@rows Bot or inline keyboard rows
*/
replyInlineMarkup#48a30254 rows:Vector<KeyboardButtonRow> = ReplyMarkup;

/*
Unknown message entity

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityUnknown#bb92ba95 offset:int length:int = MessageEntity;

/*
Message entity [mentioning](https://core.telegram.org/api/mentions) a user by @username; [messageEntityMentionName](https://core.telegram.org/constructor/messageEntityMentionName) can also be used to mention users by their ID.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityMention#fa04579d offset:int length:int = MessageEntity;

/*
#hashtag message entity

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityHashtag#6f635b0d offset:int length:int = MessageEntity;

/*
Message entity representing a bot /command

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityBotCommand#6cef8ac7 offset:int length:int = MessageEntity;

/*
Message entity representing an in-text url: [https://google.com](https://google.com); for [text urls](https://google.com), use [messageEntityTextUrl](https://core.telegram.org/constructor/messageEntityTextUrl).

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityUrl#6ed02538 offset:int length:int = MessageEntity;

/*
Message entity representing an [email@example.com](mailto:email@example.com).

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityEmail#64e475c2 offset:int length:int = MessageEntity;

/*
Message entity representing bold text.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityBold#bd610bc9 offset:int length:int = MessageEntity;

/*
Message entity representing italic text.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityItalic#826f8b60 offset:int length:int = MessageEntity;

/*
Message entity representing a codeblock.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityCode#28a20571 offset:int length:int = MessageEntity;

/*
Message entity representing a preformatted codeblock, allowing the user to specify a programming language for the codeblock.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@language Programming language of the code
*/
messageEntityPre#73924be0 offset:int length:int language:string = MessageEntity;

/*
Message entity representing a [text url](https://google.com): for in-text urls like [https://google.com](https://google.com) use [messageEntityUrl](https://core.telegram.org/constructor/messageEntityUrl).

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@url The actual URL
*/
messageEntityTextUrl#76a6d327 offset:int length:int url:string = MessageEntity;

/*
Message entity representing a [user mention](https://core.telegram.org/api/mentions): for creating a mention use [inputMessageEntityMentionName](https://core.telegram.org/constructor/inputMessageEntityMentionName).

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@user_id Identifier of the user that was mentioned
*/
messageEntityMentionName#dc7b1140 offset:int length:int user_id:long = MessageEntity;

/*
Message entity that can be used to create a user [user mention](https://core.telegram.org/api/mentions): received mentions use the [messageEntityMentionName](https://core.telegram.org/constructor/messageEntityMentionName) constructor, instead.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@user_id Identifier of the user that was mentioned
*/
inputMessageEntityMentionName#208e68c9 offset:int length:int user_id:InputUser = MessageEntity;

/*
Message entity representing a phone number.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityPhone#9b69e34b offset:int length:int = MessageEntity;

/*
Message entity representing a $cashtag.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityCashtag#4c4e743f offset:int length:int = MessageEntity;

/*
Message entity representing underlined text.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityUnderline#9c4e7e8b offset:int length:int = MessageEntity;

/*
Message entity representing strikethrough text.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityStrike#bf0693d4 offset:int length:int = MessageEntity;

/*
Indicates a credit card number

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityBankCard#761e6af4 offset:int length:int = MessageEntity;

/*
Message entity representing a spoiler

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntitySpoiler#32ca960f offset:int length:int = MessageEntity;

/*
Represents a custom emoji. 
Note that this entity must wrap exactly one regular emoji (the one contained in [documentAttributeCustomEmoji](https://core.telegram.org/constructor/documentAttributeCustomEmoji). alt) in the related text, otherwise the server will ignore it.

@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@document_id Document ID of the [custom emoji](https://core.telegram.org/api/custom-emoji), use [messages.getCustomEmojiDocuments](https://core.telegram.org/method/messages.getCustomEmojiDocuments) to fetch the emoji animation and the actual emoji it represents.
*/
messageEntityCustomEmoji#c8cf05f8 offset:int length:int document_id:long = MessageEntity;

/*
Message entity representing a block quote.

@collapsed Whether the quote is collapsed by default.
@offset Offset of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
@length Length of message entity within message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length))
*/
messageEntityBlockquote#f1ccaaac flags:# collapsed:flags.0?true offset:int length:int = MessageEntity;

/*
Represents the absence of a channel
*/
inputChannelEmpty#ee8c1e86 = InputChannel;

/*
Represents a channel

@channel_id Channel ID
@access_hash Access hash taken from the [channel](https://core.telegram.org/constructor/channel) constructor
*/
inputChannel#f35aec28 channel_id:long access_hash:long = InputChannel;

/*
Defines a [min](https://core.telegram.org/api/min) channel that was seen in a certain message of a certain chat.

@peer The chat where the channel was seen
@msg_id The message ID in the chat where the channel was seen
@channel_id The channel ID
*/
inputChannelFromMessage#5b934f9d peer:InputPeer msg_id:int channel_id:long = InputChannel;

/*
Resolved peer

@peer The peer
@chats Chats
@users Users
*/
contacts.resolvedPeer#7f077ad9 peer:Peer chats:Vector<Chat> users:Vector<User> = contacts.ResolvedPeer;

/*
Indicates a range of chat messages

@min_id Start of range (message ID)
@max_id End of range (message ID)
*/
messageRange#ae30253 min_id:int max_id:int = MessageRange;

/*
There are no new updates

@final Whether there are more updates that must be fetched (always false)
@pts The latest [PTS](https://core.telegram.org/api/updates)
@timeout Clients are supposed to refetch the channel difference after timeout seconds have elapsed, if the user is [currently viewing the chat, see here](https://core.telegram.org/api/updates#subscribing-to-updates-of-channels-supergroups) for more info.
*/
updates.channelDifferenceEmpty#3e11affb flags:# final:flags.0?true pts:int timeout:flags.1?int = updates.ChannelDifference;

/*
The provided pts + limit < remote pts. Simply, there are too many updates to be fetched (more than limit), the client has to resolve the update gap in one of the following ways (assuming the existence of a persistent database to locally store messages):

@final Whether there are more updates that must be fetched (always false)
@timeout Clients are supposed to refetch the channel difference after timeout seconds have elapsed
@dialog Dialog containing the latest [PTS](https://core.telegram.org/api/updates) that can be used to reset the channel state
@messages The latest messages
@chats Chats from messages
@users Users from messages
*/
updates.channelDifferenceTooLong#a4bcc6fe flags:# final:flags.0?true timeout:flags.1?int dialog:Dialog messages:Vector<Message> chats:Vector<Chat> users:Vector<User> = updates.ChannelDifference;

/*
The new updates

@final Whether there are more updates to be fetched using getDifference, starting from the provided pts
@pts The [PTS](https://core.telegram.org/api/updates) from which to start getting updates the next time
@timeout Clients are supposed to refetch the channel difference after timeout seconds have elapsed, if the user is [currently viewing the chat, see here](https://core.telegram.org/api/updates#subscribing-to-updates-of-channels-supergroups) for more info.
@new_messages New messages
@other_updates Other updates
@chats Chats
@users Users
*/
updates.channelDifference#2064674e flags:# final:flags.0?true pts:int timeout:flags.1?int new_messages:Vector<Message> other_updates:Vector<Update> chats:Vector<Chat> users:Vector<User> = updates.ChannelDifference;

/*
No filter
*/
channelMessagesFilterEmpty#94d42ee7 = ChannelMessagesFilter;

/*
Filter for getting only certain types of channel messages

@exclude_new_messages Whether to exclude new messages from the search
@ranges A range of messages to fetch
*/
channelMessagesFilter#cd77d957 flags:# exclude_new_messages:flags.1?true ranges:Vector<MessageRange> = ChannelMessagesFilter;

/*
Channel/supergroup participant

@user_id Participant user ID
@date Date joined
@subscription_until_date If set, contains the expiration date of the current [Telegram Star subscription period](https://core.telegram.org/api/stars#star-subscriptions) for the specified participant.
*/
channelParticipant#cb397619 flags:# user_id:long date:int subscription_until_date:flags.0?int = ChannelParticipant;

/*
Myself

@via_request Whether I joined upon specific approval of an admin
@user_id User ID
@inviter_id User that invited me to the channel/supergroup
@date When did I join the channel/supergroup
@subscription_until_date If set, contains the expiration date of the current [Telegram Star subscription period](https://core.telegram.org/api/stars#star-subscriptions) for the specified participant.
*/
channelParticipantSelf#4f607bef flags:# via_request:flags.0?true user_id:long inviter_id:long date:int subscription_until_date:flags.1?int = ChannelParticipant;

/*
Channel/supergroup creator

@user_id User ID
@admin_rights Creator admin rights
@rank The role (rank) of the group creator in the group: just an arbitrary string, admin by default
*/
channelParticipantCreator#2fe601d3 flags:# user_id:long admin_rights:ChatAdminRights rank:flags.0?string = ChannelParticipant;

/*
Admin

@can_edit Can this admin promote other admins with the same permissions?
@self Is this the current user
@user_id Admin user ID
@inviter_id User that invited the admin to the channel/group
@promoted_by User that promoted the user to admin
@date When did the user join
@admin_rights Admin [rights](https://core.telegram.org/api/rights)
@rank The role (rank) of the admin in the group: just an arbitrary string, admin by default
*/
channelParticipantAdmin#34c3bb53 flags:# can_edit:flags.0?true self:flags.1?true user_id:long inviter_id:flags.1?long promoted_by:long date:int admin_rights:ChatAdminRights rank:flags.2?string = ChannelParticipant;

/*
Banned/kicked user

@left Whether the user has left the group
@peer The banned peer
@kicked_by User was kicked by the specified admin
@date When did the user join the group
@banned_rights Banned [rights](https://core.telegram.org/api/rights)
*/
channelParticipantBanned#6df8014e flags:# left:flags.0?true peer:Peer kicked_by:long date:int banned_rights:ChatBannedRights = ChannelParticipant;

/*
A participant that left the channel/supergroup

@peer The peer that left
*/
channelParticipantLeft#1b03f006 peer:Peer = ChannelParticipant;

/*
Fetch only recent participants
*/
channelParticipantsRecent#de3f3c79 = ChannelParticipantsFilter;

/*
Fetch only admin participants
*/
channelParticipantsAdmins#b4608969 = ChannelParticipantsFilter;

/*
Fetch only kicked participants

@q Optional filter for searching kicked participants by name (otherwise empty)
*/
channelParticipantsKicked#a3b54985 q:string = ChannelParticipantsFilter;

/*
Fetch only bot participants
*/
channelParticipantsBots#b0d1865b = ChannelParticipantsFilter;

/*
Fetch only banned participants

@q Optional filter for searching banned participants by name (otherwise empty)
*/
channelParticipantsBanned#1427a5e1 q:string = ChannelParticipantsFilter;

/*
Query participants by name

@q Search query
*/
channelParticipantsSearch#656ac4b q:string = ChannelParticipantsFilter;

/*
Fetch only participants that are also contacts

@q Optional search query for searching contact participants by name
*/
channelParticipantsContacts#bb6ae88d q:string = ChannelParticipantsFilter;

/*
This filter is used when looking for supergroup members to mention. 
This filter will automatically remove anonymous admins, and return even non-participant users that replied to a specific [thread](https://core.telegram.org/api/threads) through the [comment section](https://core.telegram.org/api/threads#channel-comments) of a channel.

@q Filter by user name or username
@top_msg_id Look only for users that posted in this [thread](https://core.telegram.org/api/threads)
*/
channelParticipantsMentions#e04b5ceb flags:# q:flags.0?string top_msg_id:flags.1?int = ChannelParticipantsFilter;

/*
Represents multiple channel participants

@count Total number of participants that correspond to the given query
@participants Participants
@chats Mentioned chats
@users Users mentioned in participant info
*/
channels.channelParticipants#9ab0feaf count:int participants:Vector<ChannelParticipant> chats:Vector<Chat> users:Vector<User> = channels.ChannelParticipants;

/*
No new participant info could be found
*/
channels.channelParticipantsNotModified#f0173fe9 = channels.ChannelParticipants;

/*
Represents a channel participant

@participant The channel participant
@chats Mentioned chats
@users Users
*/
channels.channelParticipant#dfb80317 participant:ChannelParticipant chats:Vector<Chat> users:Vector<User> = channels.ChannelParticipant;

/*
Info about the latest telegram Terms Of Service

@popup Whether a prompt must be showed to the user, in order to accept the new terms.
@id ID of the new terms
@text Text of the new terms
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@min_age_confirm Minimum age required to sign up to telegram, the user must confirm that they is older than the minimum age.
*/
help.termsOfService#780a0310 flags:# popup:flags.0?true id:DataJSON text:string entities:Vector<MessageEntity> min_age_confirm:flags.1?int = help.TermsOfService;

/*
No new saved gifs were found
*/
messages.savedGifsNotModified#e8025ca2 = messages.SavedGifs;

/*
Saved gifs

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@gifs List of saved gifs
*/
messages.savedGifs#84a02a0d hash:long gifs:Vector<Document> = messages.SavedGifs;

/*
A media

@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@message Caption
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@reply_markup Inline keyboard
*/
inputBotInlineMessageMediaAuto#3380c786 flags:# invert_media:flags.3?true message:string entities:flags.1?Vector<MessageEntity> reply_markup:flags.2?ReplyMarkup = InputBotInlineMessage;

/*
Simple text message

@no_webpage Disable webpage preview
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@message Message
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@reply_markup Inline keyboard
*/
inputBotInlineMessageText#3dcd7a87 flags:# no_webpage:flags.0?true invert_media:flags.3?true message:string entities:flags.1?Vector<MessageEntity> reply_markup:flags.2?ReplyMarkup = InputBotInlineMessage;

/*
Geolocation

@geo_point Geolocation
@heading For [live locations](https://core.telegram.org/api/live-location), a direction in which the location moves, in degrees; 1-360
@period Validity period
@proximity_notification_radius For [live locations](https://core.telegram.org/api/live-location), a maximum distance to another chat member for proximity alerts, in meters (0-100000)
@reply_markup Reply markup for bot/inline keyboards
*/
inputBotInlineMessageMediaGeo#96929a85 flags:# geo_point:InputGeoPoint heading:flags.0?int period:flags.1?int proximity_notification_radius:flags.3?int reply_markup:flags.2?ReplyMarkup = InputBotInlineMessage;

/*
Venue

@geo_point Geolocation
@title Venue name
@address Address
@provider Venue provider: currently only "foursquare" and "gplaces" (Google Places) need to be supported
@venue_id Venue ID in the provider's database
@venue_type Venue type in the provider's database
@reply_markup Inline keyboard
*/
inputBotInlineMessageMediaVenue#417bbf11 flags:# geo_point:InputGeoPoint title:string address:string provider:string venue_id:string venue_type:string reply_markup:flags.2?ReplyMarkup = InputBotInlineMessage;

/*
A contact

@phone_number Phone number
@first_name First name
@last_name Last name
@vcard VCard info
@reply_markup Inline keyboard
*/
inputBotInlineMessageMediaContact#a6edbffd flags:# phone_number:string first_name:string last_name:string vcard:string reply_markup:flags.2?ReplyMarkup = InputBotInlineMessage;

/*
A game

@reply_markup Inline keyboard
*/
inputBotInlineMessageGame#4b425864 flags:# reply_markup:flags.2?ReplyMarkup = InputBotInlineMessage;

/*
An invoice

@title Product name, 1-32 characters
@description Product description, 1-255 characters
@photo Invoice photo
@invoice The invoice
@payload Bot-defined invoice payload, 1-128 bytes. This will not be displayed to the user, use for your internal processes.
@provider Payments provider token, obtained via [Botfather](https://t.me/botfather)
@provider_data A JSON-serialized object for data about the invoice, which will be shared with the payment provider. A detailed description of the required fields should be provided by the payment provider.
@reply_markup Inline keyboard
*/
inputBotInlineMessageMediaInvoice#d7e78225 flags:# title:string description:string photo:flags.0?InputWebDocument invoice:Invoice payload:bytes provider:string provider_data:DataJSON reply_markup:flags.2?ReplyMarkup = InputBotInlineMessage;

/*
Specifies options that will be used to generate the link preview for the message, or even a standalone link preview without an attached message.

@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@force_large_media If set, specifies that a large media preview should be used.
@force_small_media If set, specifies that a small media preview should be used.
@optional If not set, a WEBPAGE_NOT_FOUND RPC error will be emitted if a webpage preview cannot be generated for the specified url; otherwise, no error will be emitted (unless the provided message is also empty, in which case a MESSAGE_EMPTY will be emitted, instead).
@message The message, can be empty.
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@url The URL to use for the link preview.
@reply_markup Inline keyboard
*/
inputBotInlineMessageMediaWebPage#bddcc510 flags:# invert_media:flags.3?true force_large_media:flags.4?true force_small_media:flags.5?true optional:flags.6?true message:string entities:flags.1?Vector<MessageEntity> url:string reply_markup:flags.2?ReplyMarkup = InputBotInlineMessage;

/*
An inline bot result

@id ID of result
@type Result type (see [bot API docs](https://core.telegram.org/bots/api#inlinequeryresult))
@title Result title
@description Result description
@url URL of result
@thumb Thumbnail for result
@content Result contents
@send_message Message to send when the result is selected
*/
inputBotInlineResult#88bf9319 flags:# id:string type:string title:flags.1?string description:flags.2?string url:flags.3?string thumb:flags.4?InputWebDocument content:flags.5?InputWebDocument send_message:InputBotInlineMessage = InputBotInlineResult;

/*
Photo

@id Result ID
@type Result type (see [bot API docs](https://core.telegram.org/bots/api#inlinequeryresult))
@photo Photo to send
@send_message Message to send when the result is selected
*/
inputBotInlineResultPhoto#a8d864a7 id:string type:string photo:InputPhoto send_message:InputBotInlineMessage = InputBotInlineResult;

/*
Document (media of any type except for photos)

@id Result ID
@type Result type (see [bot API docs](https://core.telegram.org/bots/api#inlinequeryresult))
@title Result title
@description Result description
@document Document to send
@send_message Message to send when the result is selected
*/
inputBotInlineResultDocument#fff8fdc4 flags:# id:string type:string title:flags.1?string description:flags.2?string document:InputDocument send_message:InputBotInlineMessage = InputBotInlineResult;

/*
Game

@id Result ID
@short_name Game short name
@send_message Message to send when the result is selected
*/
inputBotInlineResultGame#4fa417f2 id:string short_name:string send_message:InputBotInlineMessage = InputBotInlineResult;

/*
Send whatever media is attached to the [botInlineMediaResult](https://core.telegram.org/constructor/botInlineMediaResult)

@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@message Caption
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@reply_markup Inline keyboard
*/
botInlineMessageMediaAuto#764cf810 flags:# invert_media:flags.3?true message:string entities:flags.1?Vector<MessageEntity> reply_markup:flags.2?ReplyMarkup = BotInlineMessage;

/*
Send a simple text message

@no_webpage Disable webpage preview
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@message The message
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@reply_markup Inline keyboard
*/
botInlineMessageText#8c7f65e2 flags:# no_webpage:flags.0?true invert_media:flags.3?true message:string entities:flags.1?Vector<MessageEntity> reply_markup:flags.2?ReplyMarkup = BotInlineMessage;

/*
Send a geolocation

@geo Geolocation
@heading For [live locations](https://core.telegram.org/api/live-location), a direction in which the location moves, in degrees; 1-360.
@period Validity period
@proximity_notification_radius For [live locations](https://core.telegram.org/api/live-location), a maximum distance to another chat member for proximity alerts, in meters (0-100000).
@reply_markup Inline keyboard
*/
botInlineMessageMediaGeo#51846fd flags:# geo:GeoPoint heading:flags.0?int period:flags.1?int proximity_notification_radius:flags.3?int reply_markup:flags.2?ReplyMarkup = BotInlineMessage;

/*
Send a venue

@geo Geolocation of venue
@title Venue name
@address Address
@provider Venue provider: currently only "foursquare" and "gplaces" (Google Places) need to be supported
@venue_id Venue ID in the provider's database
@venue_type Venue type in the provider's database
@reply_markup Inline keyboard
*/
botInlineMessageMediaVenue#8a86659c flags:# geo:GeoPoint title:string address:string provider:string venue_id:string venue_type:string reply_markup:flags.2?ReplyMarkup = BotInlineMessage;

/*
Send a contact

@phone_number Phone number
@first_name First name
@last_name Last name
@vcard VCard info
@reply_markup Inline keyboard
*/
botInlineMessageMediaContact#18d1cdc2 flags:# phone_number:string first_name:string last_name:string vcard:string reply_markup:flags.2?ReplyMarkup = BotInlineMessage;

/*
Send an invoice

@shipping_address_requested Set this flag if you require the user's shipping address to complete the order
@test Test invoice
@title Product name, 1-32 characters
@description Product description, 1-255 characters
@photo Product photo
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code, or XTR for [Telegram Stars](https://core.telegram.org/api/stars).
@total_amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@reply_markup Inline keyboard
*/
botInlineMessageMediaInvoice#354a9b09 flags:# shipping_address_requested:flags.1?true test:flags.3?true title:string description:string photo:flags.0?WebDocument currency:string total_amount:long reply_markup:flags.2?ReplyMarkup = BotInlineMessage;

/*
Specifies options that must be used to generate the link preview for the message, or even a standalone link preview without an attached message.

@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@force_large_media If set, specifies that a large media preview should be used.
@force_small_media If set, specifies that a small media preview should be used.
@manual If set, indicates that the URL used for the webpage preview was specified manually using [inputMediaWebPage](https://core.telegram.org/constructor/inputMediaWebPage), and may not be related to any of the URLs specified in the message.
@safe If set, the link can be opened directly without user confirmation.
@message The message, can be empty.
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@url The URL to use for the link preview.
@reply_markup Reply markup for sending bot buttons
*/
botInlineMessageMediaWebPage#809ad9a6 flags:# invert_media:flags.3?true force_large_media:flags.4?true force_small_media:flags.5?true manual:flags.7?true safe:flags.8?true message:string entities:flags.1?Vector<MessageEntity> url:string reply_markup:flags.2?ReplyMarkup = BotInlineMessage;

/*
Generic result

@id Result ID
@type Result type (see [bot API docs](https://core.telegram.org/bots/api#inlinequeryresult))
@title Result title
@description Result description
@url URL of article or webpage
@thumb Thumbnail for the result
@content Content of the result
@send_message Message to send
*/
botInlineResult#11965f3a flags:# id:string type:string title:flags.1?string description:flags.2?string url:flags.3?string thumb:flags.4?WebDocument content:flags.5?WebDocument send_message:BotInlineMessage = BotInlineResult;

/*
Media result

@id Result ID
@type Result type (see [bot API docs](https://core.telegram.org/bots/api#inlinequeryresult))
@photo If type is photo, the photo to send
@document If type is document, the document to send
@title Result title
@description Description
@send_message Depending on the type and on the [constructor](https://core.telegram.org/type/BotInlineMessage), contains the caption of the media or the content of the message to be sent instead of the media
*/
botInlineMediaResult#17db940b flags:# id:string type:string photo:flags.0?Photo document:flags.1?Document title:flags.2?string description:flags.3?string send_message:BotInlineMessage = BotInlineResult;

/*
Result of a query to an inline bot

@gallery Whether the result is a picture gallery
@query_id Query ID
@next_offset The next offset to use when navigating through results
@switch_pm Shown as a button on top of the remaining inline result list; if clicked, redirects the user to a private chat with the bot with the specified start parameter.
@switch_webview Shown as a button on top of the remaining inline result list; if clicked, opens the specified [inline mode mini app](https://core.telegram.org/api/bots/webapps#inline-mode-mini-apps).
@results The results
@cache_time Caching validity of the results
@users Users mentioned in the results
*/
messages.botResults#e021f2f6 flags:# gallery:flags.0?true query_id:long next_offset:flags.1?string switch_pm:flags.2?InlineBotSwitchPM switch_webview:flags.3?InlineBotWebView results:Vector<BotInlineResult> cache_time:int users:Vector<User> = messages.BotResults;

/*
Link to a message in a supergroup/channel

@link URL
@html Embed code
*/
exportedMessageLink#5dab1af4 link:string html:string = ExportedMessageLink;

/*
Info about a forwarded message

@imported Whether this message was [imported from a foreign chat service, click here for more info](https://core.telegram.org/api/import)
@saved_out Only for messages forwarded to [saved messages](https://core.telegram.org/api/saved-messages), set if the original message was outgoing (though the message may have been originally outgoing even if this flag is not set, if from_id points to the current user).
@from_id The ID of the user that originally sent the message
@from_name The name of the user that originally sent the message
@date When was the message originally sent
@channel_post ID of the channel message that was forwarded
@post_author For channels and if signatures are enabled, author of the channel message
@saved_from_peer Only for messages forwarded to [saved messages](https://core.telegram.org/api/saved-messages), contains the dialog where the message was originally sent.
@saved_from_msg_id Only for messages forwarded to [saved messages](https://core.telegram.org/api/saved-messages), contains the original ID of the message in saved_from_peer.
@saved_from_id Only for forwarded messages reforwarded to [saved messages](https://core.telegram.org/api/saved-messages), contains the sender of the original message (i.e. if user A sends a message, then user B forwards it somewhere, then user C saves it to saved messages, this field will contain the ID of user B and from_id will contain the ID of user A).
@saved_from_name Only for forwarded messages from users with forward privacy enabled, sent by users with forward privacy enabled, reforwarded to [saved messages](https://core.telegram.org/api/saved-messages), contains the sender of the original message (i.e. if user A (fwd privacy enabled) sends a message, then user B (fwd privacy enabled) forwards it somewhere, then user C saves it to saved messages, this field will contain the name of user B and from_name will contain the name of user A).
@saved_date Only for forwarded messages reforwarded to [saved messages](https://core.telegram.org/api/saved-messages), indicates when was the original message sent (i.e. if user A sends a message @ unixtime 1, then user B forwards it somewhere @ unixtime 2, then user C saves it to saved messages @ unixtime 3, this field will contain 2, date will contain 1 and the date of the containing [message](https://core.telegram.org/constructor/message) will contain 3).
@psa_type PSA type
*/
messageFwdHeader#4e4df4bb flags:# imported:flags.7?true saved_out:flags.11?true from_id:flags.0?Peer from_name:flags.5?string date:int channel_post:flags.2?int post_author:flags.3?string saved_from_peer:flags.4?Peer saved_from_msg_id:flags.4?int saved_from_id:flags.8?Peer saved_from_name:flags.9?string saved_date:flags.10?int psa_type:flags.6?string = MessageFwdHeader;

/*
The next time, the authentication code will be delivered via an immediately canceled incoming call.
*/
auth.codeTypeSms#72a3158c = auth.CodeType;

/*
The next time, the authentication code is to be delivered via an outgoing phone call.
*/
auth.codeTypeCall#741cd3e3 = auth.CodeType;

/*
The next time, the authentication code will be delivered via an immediately canceled incoming call.
*/
auth.codeTypeFlashCall#226ccefb = auth.CodeType;

/*
The next time, the authentication code will be delivered via an immediately canceled incoming call, handled manually by the user.
*/
auth.codeTypeMissedCall#d61ad6ee = auth.CodeType;

/*
The next time, the authentication code will be delivered via [fragment.com](https://fragment.com)
*/
auth.codeTypeFragmentSms#6ed998c = auth.CodeType;

/*
The code was sent through the telegram app

@length Length of the code in bytes
*/
auth.sentCodeTypeApp#3dbb5986 length:int = auth.SentCodeType;

/*
The code was sent via SMS

@length Length of the code in bytes
*/
auth.sentCodeTypeSms#c000bba2 length:int = auth.SentCodeType;

/*
The code will be sent via a phone call: a synthesized voice will tell the user which verification code to input.

@length Length of the verification code
*/
auth.sentCodeTypeCall#5353e5a7 length:int = auth.SentCodeType;

/*
The code will be sent via a flash phone call, that will be closed immediately. The phone code will then be the phone number itself, just make sure that the phone number matches the specified pattern.

@pattern [pattern](https://core.telegram.org/api/pattern) to match
*/
auth.sentCodeTypeFlashCall#ab03c6d9 pattern:string = auth.SentCodeType;

/*
The code will be sent via a flash phone call, that will be closed immediately. The last digits of the phone number that calls are the code that must be entered manually by the user.

@prefix Prefix of the phone number from which the call will be made
@length Length of the verification code
*/
auth.sentCodeTypeMissedCall#82006484 prefix:string length:int = auth.SentCodeType;

/*
The code was sent via the [previously configured login email](https://core.telegram.org/api/auth#email-verification)

@apple_signin_allowed Whether authorization through Apple ID is allowed
@google_signin_allowed Whether authorization through Google ID is allowed
@email_pattern [Pattern](https://core.telegram.org/api/pattern) of the email
@length Length of the sent verification code
@reset_available_period Clients should wait for the specified amount of seconds before allowing the user to invoke [auth.resetLoginEmail](https://core.telegram.org/method/auth.resetLoginEmail) (will be 0 for [Premium](https://core.telegram.org/api/premium) users).
@reset_pending_date An email reset was already requested, and will occur at the specified date.
*/
auth.sentCodeTypeEmailCode#f450f59b flags:# apple_signin_allowed:flags.0?true google_signin_allowed:flags.1?true email_pattern:string length:int reset_available_period:flags.3?int reset_pending_date:flags.4?int = auth.SentCodeType;

/*
The user should add and verify an email address in order to login as described [here](https://core.telegram.org/api/auth#email-verification).

@apple_signin_allowed Whether authorization through Apple ID is allowed
@google_signin_allowed Whether authorization through Google ID is allowed
*/
auth.sentCodeTypeSetUpEmailRequired#a5491dea flags:# apple_signin_allowed:flags.0?true google_signin_allowed:flags.1?true = auth.SentCodeType;

/*
The code was delivered via [fragment.com](https://fragment.com).

@url Open the specified URL to log into [fragment.com](https://fragment.com) with the wallet that owns the specified phone number and view the code.
@length Length of the delivered code.
*/
auth.sentCodeTypeFragmentSms#d9565c39 url:string length:int = auth.SentCodeType;

/*
An authentication code should be delivered via SMS after Firebase attestation, as described in the [auth documentation](https://core.telegram.org/api/auth).

@nonce On Android, the nonce to be used as described in the [auth documentation](https://core.telegram.org/api/auth)
@play_integrity_project_id Google Play Integrity project ID
@play_integrity_nonce Play Integrity API nonce
@receipt On iOS, must be compared with the receipt extracted from the received push notification.
@push_timeout On iOS: if a push notification with the ios_push_secret isn't received within push_timeout seconds, the next_type authentication method must be used, with [auth.resendCode](https://core.telegram.org/method/auth.resendCode).
@length Length of the code that will be delivered.
*/
auth.sentCodeTypeFirebaseSms#9fd736 flags:# nonce:flags.0?bytes play_integrity_project_id:flags.2?long play_integrity_nonce:flags.2?bytes receipt:flags.1?string push_timeout:flags.1?int length:int = auth.SentCodeType;

/*
The code was sent via SMS as a secret word, starting with the letter specified in beginning

@beginning If set, the secret word in the sent SMS (which may contain multiple words) starts with this letter.
*/
auth.sentCodeTypeSmsWord#a416ac81 flags:# beginning:flags.0?string = auth.SentCodeType;

/*
The code was sent via SMS as a secret phrase starting with the word specified in beginning

@beginning If set, the secret phrase (and the SMS) starts with this word.
*/
auth.sentCodeTypeSmsPhrase#b37794af flags:# beginning:flags.0?string = auth.SentCodeType;

/*
Callback answer sent by the bot in response to a button press

@alert Whether an alert should be shown to the user instead of a toast notification
@has_url Whether an URL is present
@native_ui Whether to show games in WebView or in native UI.
@message Alert to show
@url URL to open
@cache_time For how long should this answer be cached
*/
messages.botCallbackAnswer#36585ea4 flags:# alert:flags.1?true has_url:flags.3?true native_ui:flags.4?true message:flags.0?string url:flags.2?string cache_time:int = messages.BotCallbackAnswer;

/*
Message edit data for media

@caption Media caption, if the specified media's caption can be edited
*/
messages.messageEditData#26b5dde6 flags:# caption:flags.0?true = messages.MessageEditData;

/*
Represents a sent inline message from the perspective of a bot (legacy constructor)

@dc_id DC ID to use when working with this inline message
@id ID of message, contains both the (32-bit, legacy) owner ID and the message ID, used only for Bot API backwards compatibility with 32-bit user ID.
@access_hash Access hash of message
*/
inputBotInlineMessageID#890c3d89 dc_id:int id:long access_hash:long = InputBotInlineMessageID;

/*
Represents a sent inline message from the perspective of a bot

@dc_id DC ID to use when working with this inline message
@owner_id ID of the owner of this message
@id ID of message
@access_hash Access hash of message
*/
inputBotInlineMessageID64#b6d915d7 dc_id:int owner_id:long id:int access_hash:long = InputBotInlineMessageID;

/*
The bot requested the user to message them in private

@text Text for the button that switches the user to a private chat with the bot and sends the bot a start message with the parameter start_parameter (can be empty)
@start_param The parameter for the /start parameter
*/
inlineBotSwitchPM#3c20629f text:string start_param:string = InlineBotSwitchPM;

/*
Dialog info of multiple peers

@dialogs Dialog info
@messages Messages mentioned in dialog info
@chats Chats
@users Users
@state Current [update state of dialog](https://core.telegram.org/api/updates)
*/
messages.peerDialogs#3371c354 dialogs:Vector<Dialog> messages:Vector<Message> chats:Vector<Chat> users:Vector<User> state:updates.State = messages.PeerDialogs;

/*
Top peer

@peer Peer
@rating Rating as computed in [top peer rating](https://core.telegram.org/api/top-rating)
*/
topPeer#edcdc05b peer:Peer rating:double = TopPeer;

/*
Most used bots
*/
topPeerCategoryBotsPM#ab661b5b = TopPeerCategory;

/*
Most used inline bots
*/
topPeerCategoryBotsInline#148677e2 = TopPeerCategory;

/*
Users we've chatted most frequently with
*/
topPeerCategoryCorrespondents#637b7ed = TopPeerCategory;

/*
Often-opened groups and supergroups
*/
topPeerCategoryGroups#bd17a14a = TopPeerCategory;

/*
Most frequently visited channels
*/
topPeerCategoryChannels#161d9628 = TopPeerCategory;

/*
Most frequently called users
*/
topPeerCategoryPhoneCalls#1e76a78c = TopPeerCategory;

/*
Users to which the users often forwards messages to
*/
topPeerCategoryForwardUsers#a8406ca9 = TopPeerCategory;

/*
Chats to which the users often forwards messages to
*/
topPeerCategoryForwardChats#fbeec0f0 = TopPeerCategory;

/*
Most frequently used [Main Mini Bot Apps](https://core.telegram.org/api/bots/webapps#main-mini-apps).
*/
topPeerCategoryBotsApp#fd9e7bec = TopPeerCategory;

/*
Top peer category

@category Top peer category of peers
@count Count of peers
@peers Peers
*/
topPeerCategoryPeers#fb834291 category:TopPeerCategory count:int peers:Vector<TopPeer> = TopPeerCategoryPeers;

/*
Top peer info hasn't changed
*/
contacts.topPeersNotModified#de266ef5 = contacts.TopPeers;

/*
Top peers

@categories Top peers by top peer category
@chats Chats
@users Users
*/
contacts.topPeers#70b772a8 categories:Vector<TopPeerCategoryPeers> chats:Vector<Chat> users:Vector<User> = contacts.TopPeers;

/*
Top peers disabled
*/
contacts.topPeersDisabled#b52c939d = contacts.TopPeers;

/*
Empty draft

@date When was the draft last updated
*/
draftMessageEmpty#1b0c841a flags:# date:flags.0?int = DraftMessage;

/*
Represents a message [draft](https://core.telegram.org/api/drafts).

@no_webpage Whether no webpage preview will be generated
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@reply_to If set, indicates that the message should be sent in reply to the specified message or story.
@message The draft
@entities Message [entities](https://core.telegram.org/api/entities) for styled text.
@media Media.
@date Date of last update of the draft.
@effect A [message effect that should be played as specified here](https://core.telegram.org/api/effects).
*/
draftMessage#2d65321f flags:# no_webpage:flags.1?true invert_media:flags.6?true reply_to:flags.4?InputReplyTo message:string entities:flags.3?Vector<MessageEntity> media:flags.5?InputMedia date:int effect:flags.7?long = DraftMessage;

/*
Featured stickers haven't changed

@count Total number of featured stickers
*/
messages.featuredStickersNotModified#c6dc0c66 count:int = messages.FeaturedStickers;

/*
Featured stickersets

@premium Whether this is a premium stickerset
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@count Total number of featured stickers
@sets Featured stickersets
@unread IDs of new featured stickersets
*/
messages.featuredStickers#be382906 flags:# premium:flags.0?true hash:long count:int sets:Vector<StickerSetCovered> unread:Vector<long> = messages.FeaturedStickers;

/*
No new recent sticker was found
*/
messages.recentStickersNotModified#b17f890 = messages.RecentStickers;

/*
Recently used stickers

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@packs Emojis associated to stickers
@stickers Recent stickers
@dates When was each sticker last used
*/
messages.recentStickers#88d37c56 hash:long packs:Vector<StickerPack> stickers:Vector<Document> dates:Vector<int> = messages.RecentStickers;

/*
Archived stickersets

@count Number of archived stickers
@sets Archived stickersets
*/
messages.archivedStickers#4fcba9c8 count:int sets:Vector<StickerSetCovered> = messages.ArchivedStickers;

/*
The stickerset was installed successfully
*/
messages.stickerSetInstallResultSuccess#38641628 = messages.StickerSetInstallResult;

/*
The stickerset was installed, but since there are too many stickersets some were archived

@sets Archived stickersets
*/
messages.stickerSetInstallResultArchive#35e410a8 sets:Vector<StickerSetCovered> = messages.StickerSetInstallResult;

/*
Stickerset with a single sticker as preview

@set Stickerset
@cover Preview
*/
stickerSetCovered#6410a5d2 set:StickerSet cover:Document = StickerSetCovered;

/*
Stickerset, with multiple stickers as preview

@set Stickerset
@covers Preview stickers
*/
stickerSetMultiCovered#3407e51b set:StickerSet covers:Vector<Document> = StickerSetCovered;

/*
Stickerset preview with all stickers of the stickerset included. 
Currently used only for [custom emoji stickersets](https://core.telegram.org/api/custom-emoji), to avoid a further call to [messages.getStickerSet](https://core.telegram.org/method/messages.getStickerSet).

@set Stickerset
@packs Emoji information about every sticker in the stickerset
@keywords Keywords for some or every sticker in the stickerset.
@documents Stickers
*/
stickerSetFullCovered#40d13c0e set:StickerSet packs:Vector<StickerPack> keywords:Vector<StickerKeyword> documents:Vector<Document> = StickerSetCovered;

/*
Just the stickerset information, with no previews.

@set Stickerset information.
*/
stickerSetNoCovered#77b15d1c set:StickerSet = StickerSetCovered;

/*
Position on a photo where a mask should be placed when [attaching stickers to media](https://core.telegram.org/api/stickers#attached-stickers)

@n Part of the face, relative to which the mask should be placed
@x Shift by X-axis measured in widths of the mask scaled to the face size, from left to right. (For example, -1.0 will place the mask just to the left of the default mask position)
@y Shift by Y-axis measured in widths of the mask scaled to the face size, from left to right. (For example, -1.0 will place the mask just below the default mask position)
@zoom Mask scaling coefficient. (For example, 2.0 means a doubled size)
*/
maskCoords#aed6dbb2 n:int x:double y:double zoom:double = MaskCoords;

/*
A photo with stickers attached

@id The photo
*/
inputStickeredMediaPhoto#4a992157 id:InputPhoto = InputStickeredMedia;

/*
A document with stickers attached

@id The document
*/
inputStickeredMediaDocument#438865b id:InputDocument = InputStickeredMedia;

/*
Indicates an already sent game

@id ID of the game
@access_hash Access hash of the game
@short_name Short name for the game
@title Title of the game
@description Game description
@photo Game preview
@document Optional attached document
*/
game#bdf9653b flags:# id:long access_hash:long short_name:string title:string description:string photo:Photo document:flags.0?Document = Game;

/*
Indicates an already sent game

@id game ID from [Game](https://core.telegram.org/type/Game) constructor
@access_hash access hash from [Game](https://core.telegram.org/type/Game) constructor
*/
inputGameID#32c3e77 id:long access_hash:long = InputGame;

/*
Game by short name

@bot_id The bot that provides the game
@short_name The game's short name, usually obtained from a [game link](https://core.telegram.org/api/links#game-links)
*/
inputGameShortName#c331e80a bot_id:InputUser short_name:string = InputGame;

/*
Game highscore

@pos Position in highscore list
@user_id User ID
@score Score
*/
highScore#73a379eb pos:int user_id:long score:int = HighScore;

/*
Highscores in a game

@scores Highscores
@users Users, associated to the highscores
*/
messages.highScores#9a3bfd99 scores:Vector<HighScore> users:Vector<User> = messages.HighScores;

/*
Empty rich text element
*/
textEmpty#dc3d824f = RichText;

/*
Plain text

@text Text
*/
textPlain#744694e0 text:string = RichText;

/*
Bold text

@text Text
*/
textBold#6724abc4 text:RichText = RichText;

/*
Italic text

@text Text
*/
textItalic#d912a59c text:RichText = RichText;

/*
Underlined text

@text Text
*/
textUnderline#c12622c4 text:RichText = RichText;

/*
Strikethrough text

@text Text
*/
textStrike#9bf8bb95 text:RichText = RichText;

/*
fixed-width rich text

@text Text
*/
textFixed#6c3f19b9 text:RichText = RichText;

/*
Link

@text Text of link
@url Webpage HTTP URL
@webpage_id If a preview was already generated for the page, the page ID
*/
textUrl#3c2884c1 text:RichText url:string webpage_id:long = RichText;

/*
Rich text email link

@text Link text
@email Email address
*/
textEmail#de5a0dd6 text:RichText email:string = RichText;

/*
Concatenation of rich texts

@texts Concatenated rich texts
*/
textConcat#7e6260d7 texts:Vector<RichText> = RichText;

/*
Subscript text

@text Text
*/
textSubscript#ed6a8504 text:RichText = RichText;

/*
Superscript text

@text Text
*/
textSuperscript#c7fb5e01 text:RichText = RichText;

/*
Highlighted text

@text Text
*/
textMarked#34b8621 text:RichText = RichText;

/*
Rich text linked to a phone number

@text Text
@phone Phone number
*/
textPhone#1ccb966a text:RichText phone:string = RichText;

/*
Inline image

@document_id Document ID
@w Width
@h Height
*/
textImage#81ccf4f document_id:long w:int h:int = RichText;

/*
Text linking to another section of the page

@text Text
@name Section name
*/
textAnchor#35553762 text:RichText name:string = RichText;

/*
Unsupported IV element
*/
pageBlockUnsupported#13567e8a = PageBlock;

/*
Title

@text Title
*/
pageBlockTitle#70abc3fd text:RichText = PageBlock;

/*
Subtitle

@text Text
*/
pageBlockSubtitle#8ffa9a1f text:RichText = PageBlock;

/*
Author and date of creation of article

@author Author name
@published_date Date of publication
*/
pageBlockAuthorDate#baafe5e0 author:RichText published_date:int = PageBlock;

/*
Page header

@text Contents
*/
pageBlockHeader#bfd064ec text:RichText = PageBlock;

/*
Subheader

@text Subheader
*/
pageBlockSubheader#f12bb6e1 text:RichText = PageBlock;

/*
A paragraph

@text Text
*/
pageBlockParagraph#467a0766 text:RichText = PageBlock;

/*
Preformatted ( <pre> text)

@text Text
@language Programming language of preformatted text
*/
pageBlockPreformatted#c070d93e text:RichText language:string = PageBlock;

/*
Page footer

@text Contents
*/
pageBlockFooter#48870999 text:RichText = PageBlock;

/*
An empty block separating a page
*/
pageBlockDivider#db20b188 = PageBlock;

/*
Link to section within the page itself (like <a href="#target">anchor</a>)

@name Name of target section
*/
pageBlockAnchor#ce0d37b0 name:string = PageBlock;

/*
Unordered list of IV blocks

@items List of blocks in an IV page
*/
pageBlockList#e4e88011 items:Vector<PageListItem> = PageBlock;

/*
Quote (equivalent to the HTML <blockquote>)

@text Quote contents
@caption Caption
*/
pageBlockBlockquote#263d7c26 text:RichText caption:RichText = PageBlock;

/*
Pullquote

@text Text
@caption Caption
*/
pageBlockPullquote#4f4456d3 text:RichText caption:RichText = PageBlock;

/*
A photo

@photo_id Photo ID
@caption Caption
@url HTTP URL of page the photo leads to when clicked
@webpage_id ID of preview of the page the photo leads to when clicked
*/
pageBlockPhoto#1759c560 flags:# photo_id:long caption:PageCaption url:flags.0?string webpage_id:flags.0?long = PageBlock;

/*
Video

@autoplay Whether the video is set to autoplay
@loop Whether the video is set to loop
@video_id Video ID
@caption Caption
*/
pageBlockVideo#7c8fe7b6 flags:# autoplay:flags.0?true loop:flags.1?true video_id:long caption:PageCaption = PageBlock;

/*
A page cover

@cover Cover
*/
pageBlockCover#39f23300 cover:PageBlock = PageBlock;

/*
An embedded webpage

@full_width Whether the block should be full width
@allow_scrolling Whether scrolling should be allowed
@url Web page URL, if available
@html HTML-markup of the embedded page
@poster_photo_id Poster photo, if available
@w Block width, if known
@h Block height, if known
@caption Caption
*/
pageBlockEmbed#a8718dc5 flags:# full_width:flags.0?true allow_scrolling:flags.3?true url:flags.1?string html:flags.2?string poster_photo_id:flags.4?long w:flags.5?int h:flags.5?int caption:PageCaption = PageBlock;

/*
An embedded post

@url Web page URL
@webpage_id ID of generated webpage preview
@author_photo_id ID of the author's photo
@author Author name
@date Creation date
@blocks Post contents
@caption Caption
*/
pageBlockEmbedPost#f259a80b url:string webpage_id:long author_photo_id:long author:string date:int blocks:Vector<PageBlock> caption:PageCaption = PageBlock;

/*
Collage of media

@items Media elements
@caption Caption
*/
pageBlockCollage#65a0fa4d items:Vector<PageBlock> caption:PageCaption = PageBlock;

/*
Slideshow

@items Slideshow items
@caption Caption
*/
pageBlockSlideshow#31f9590 items:Vector<PageBlock> caption:PageCaption = PageBlock;

/*
Reference to a telegram channel

@channel The channel/supergroup/chat
*/
pageBlockChannel#ef1751b5 channel:Chat = PageBlock;

/*
Audio

@audio_id Audio ID (to be fetched from the container [page](https://core.telegram.org/constructor/page) constructor
@caption Audio caption
*/
pageBlockAudio#804361ea audio_id:long caption:PageCaption = PageBlock;

/*
Kicker

@text Contents
*/
pageBlockKicker#1e148390 text:RichText = PageBlock;

/*
Table

@bordered Does the table have a visible border?
@striped Is the table striped?
@title Title
@rows Table rows
*/
pageBlockTable#bf4dea82 flags:# bordered:flags.0?true striped:flags.1?true title:RichText rows:Vector<PageTableRow> = PageBlock;

/*
Ordered list of IV blocks

@items List items
*/
pageBlockOrderedList#9a8ae1e1 items:Vector<PageListOrderedItem> = PageBlock;

/*
A collapsible details block

@open Whether the block is open by default
@blocks Block contents
@title Always visible heading for the block
*/
pageBlockDetails#76768bed flags:# open:flags.0?true blocks:Vector<PageBlock> title:RichText = PageBlock;

/*
Related articles

@title Title
@articles Related articles
*/
pageBlockRelatedArticles#16115a96 title:RichText articles:Vector<PageRelatedArticle> = PageBlock;

/*
A map

@geo Location of the map center
@zoom Map zoom level; 13-20
@w Map width in pixels before applying scale; 16-102
@h Map height in pixels before applying scale; 16-1024
@caption Caption
*/
pageBlockMap#a44f3ef6 geo:GeoPoint zoom:int w:int h:int caption:PageCaption = PageBlock;

/*
The phone call was missed
*/
phoneCallDiscardReasonMissed#85e42301 = PhoneCallDiscardReason;

/*
The phone call was disconnected
*/
phoneCallDiscardReasonDisconnect#e095c1a0 = PhoneCallDiscardReason;

/*
The phone call was ended normally
*/
phoneCallDiscardReasonHangup#57adc690 = PhoneCallDiscardReason;

/*
The phone call was discarded because the user is busy in another call
*/
phoneCallDiscardReasonBusy#faf7e8c9 = PhoneCallDiscardReason;

phoneCallDiscardReasonAllowGroupCall#afe2b839 encrypted_key:bytes = PhoneCallDiscardReason;
/*
Represents a json-encoded object

@data JSON-encoded object
*/
dataJSON#7d748d04 data:string = DataJSON;

/*
This object represents a portion of the price for goods or services.

@label Portion label
@amount Price of the product in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
*/
labeledPrice#cb296bf8 label:string amount:long = LabeledPrice;

/*
Invoice

@test Test invoice
@name_requested Set this flag if you require the user's full name to complete the order
@phone_requested Set this flag if you require the user's phone number to complete the order
@email_requested Set this flag if you require the user's email address to complete the order
@shipping_address_requested Set this flag if you require the user's shipping address to complete the order
@flexible Set this flag if the final price depends on the shipping method
@phone_to_provider Set this flag if user's phone number should be sent to provider
@email_to_provider Set this flag if user's email address should be sent to provider
@recurring Whether this is a recurring payment
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code, or XTR for [Telegram Stars](https://core.telegram.org/api/stars).
@prices Price breakdown, a list of components (e.g. product price, tax, discount, delivery cost, delivery tax, bonus, etc.)
@max_tip_amount The maximum accepted amount for tips in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@suggested_tip_amounts A vector of suggested amounts of tips in the smallest units of the currency (integer, not float/double). At most 4 suggested tip amounts can be specified. The suggested tip amounts must be positive, passed in a strictly increased order and must not exceed max_tip_amount.
@terms_url Terms of service URL
@subscription_period The number of seconds between consecutive Telegram Star debiting for [bot subscription](https://core.telegram.org/api/subscriptions#bot-subscriptions) invoices
*/
invoice#49ee584 flags:# test:flags.0?true name_requested:flags.1?true phone_requested:flags.2?true email_requested:flags.3?true shipping_address_requested:flags.4?true flexible:flags.5?true phone_to_provider:flags.6?true email_to_provider:flags.7?true recurring:flags.9?true currency:string prices:Vector<LabeledPrice> max_tip_amount:flags.8?long suggested_tip_amounts:flags.8?Vector<long> terms_url:flags.10?string subscription_period:flags.11?int = Invoice;

/*
Payment identifier

@id Telegram payment identifier
@provider_charge_id Provider payment identifier
*/
paymentCharge#ea02c27e id:string provider_charge_id:string = PaymentCharge;

/*
Shipping address

@street_line1 First line for the address
@street_line2 Second line for the address
@city City
@state State, if applicable (empty otherwise)
@country_iso2 ISO 3166-1 alpha-2 country code
@post_code Address post code
*/
postAddress#1e8caaeb street_line1:string street_line2:string city:string state:string country_iso2:string post_code:string = PostAddress;

/*
Order info provided by the user

@name User's full name
@phone User's phone number
@email User's email address
@shipping_address User's shipping address
*/
paymentRequestedInfo#909c3f94 flags:# name:flags.0?string phone:flags.1?string email:flags.2?string shipping_address:flags.3?PostAddress = PaymentRequestedInfo;

/*
Saved credit card

@id Card ID
@title Title
*/
paymentSavedCredentialsCard#cdc27a1f id:string title:string = PaymentSavedCredentials;

/*
Remote document

@url Document URL
@access_hash Access hash
@size File size
@mime_type MIME type
@attributes Attributes for media types
*/
webDocument#1c570ed1 url:string access_hash:long size:int mime_type:string attributes:Vector<DocumentAttribute> = WebDocument;

/*
Remote document that can be downloaded without [proxying through telegram](https://core.telegram.org/api/files)

@url Document URL
@size File size
@mime_type MIME type
@attributes Attributes for media types
*/
webDocumentNoProxy#f9c8bcc6 url:string size:int mime_type:string attributes:Vector<DocumentAttribute> = WebDocument;

/*
The document

@url Remote document URL to be downloaded using the appropriate [method](https://core.telegram.org/api/files)
@size Remote file size
@mime_type Mime type
@attributes Attributes for media types
*/
inputWebDocument#9bed434d url:string size:int mime_type:string attributes:Vector<DocumentAttribute> = InputWebDocument;

/*
Location of a remote HTTP(s) file

@url HTTP URL of file
@access_hash Access hash
*/
inputWebFileLocation#c239d686 url:string access_hash:long = InputWebFileLocation;

/*
Used to download a server-generated image with the map preview from a [geoPoint](https://core.telegram.org/constructor/geoPoint), see the [webfile docs for more info](https://core.telegram.org/api/files#downloading-webfiles).

@geo_point Generated from the lat, long and accuracy_radius parameters of the [geoPoint](https://core.telegram.org/constructor/geoPoint)
@access_hash Access hash of the [geoPoint](https://core.telegram.org/constructor/geoPoint)
@w Map width in pixels before applying scale; 16-1024
@h Map height in pixels before applying scale; 16-1024
@zoom Map zoom level; 13-20
@scale Map scale; 1-3
*/
inputWebFileGeoPointLocation#9f2221c9 geo_point:InputGeoPoint access_hash:long w:int h:int zoom:int scale:int = InputWebFileLocation;

/*
Used to download an album cover for any music file using [upload.getWebFile](https://core.telegram.org/method/upload.getWebFile), see the [webfile docs for more info](https://core.telegram.org/api/files#downloading-webfiles).

@small Used to return a thumbnail with 100x100 resolution (instead of the default 600x600)
@document The audio file in question: must NOT be provided in secret chats, provide the title and performer fields instead.
@title Song title: should only be used in secret chats, in normal chats provide document instead, as it has more lax rate limits.
@performer Song performer: should only be used in secret chats, in normal chats provide document instead, as it has more lax rate limits.
*/
inputWebFileAudioAlbumThumbLocation#f46fe924 flags:# small:flags.2?true document:flags.0?InputDocument title:flags.1?string performer:flags.1?string = InputWebFileLocation;

/*
Represents a chunk of an [HTTP webfile](https://core.telegram.org/api/files) downloaded through telegram's secure MTProto servers

@size File size
@mime_type Mime type
@file_type File type
@mtime Modified time
@bytes Data
*/
upload.webFile#21e753bc size:int mime_type:string file_type:storage.FileType mtime:int bytes:bytes = upload.WebFile;

/*
Payment form

@can_save_credentials Whether the user can choose to save credentials.
@password_missing Indicates that the user can save payment credentials, but only after setting up a [2FA password](https://core.telegram.org/api/srp) (currently the account doesn't have a [2FA password](https://core.telegram.org/api/srp))
@form_id Form ID
@bot_id Bot ID
@title Form title
@description Description
@photo Product photo
@invoice Invoice
@provider_id Payment provider ID.
@url Payment form URL
@native_provider Payment provider name. One of the following: - stripe
@native_params Contains information about the payment provider, if available, to support it natively without the need for opening the URL. A JSON object that can contain the following fields: - apple_pay_merchant_id: Apple Pay merchant ID - google_pay_public_key: Google Pay public key - need_country: True, if the user country must be provided, - need_zip: True, if the user ZIP/postal code must be provided, - need_cardholder_name: True, if the cardholder name must be provided
@additional_methods Additional payment methods
@saved_info Saved server-side order information
@saved_credentials Contains information about saved card credentials
@users Users
*/
payments.paymentForm#a0058751 flags:# can_save_credentials:flags.2?true password_missing:flags.3?true form_id:long bot_id:long title:string description:string photo:flags.5?WebDocument invoice:Invoice provider_id:long url:string native_provider:flags.4?string native_params:flags.4?DataJSON additional_methods:flags.6?Vector<PaymentFormMethod> saved_info:flags.0?PaymentRequestedInfo saved_credentials:flags.1?Vector<PaymentSavedCredentials> users:Vector<User> = payments.PaymentForm;

/*
Represents a payment form, for payments to be using [Telegram Stars, see here](https://core.telegram.org/api/stars) for more info.

@form_id Form ID.
@bot_id Bot ID.
@title Form title
@description Description
@photo Product photo
@invoice Invoice
@users Info about users mentioned in the other fields.
*/
payments.paymentFormStars#7bf6b15c flags:# form_id:long bot_id:long title:string description:string photo:flags.5?WebDocument invoice:Invoice users:Vector<User> = payments.PaymentForm;

/*
Represents a payment form for a [gift, see here](https://core.telegram.org/api/gifts) for more info.

@form_id Form ID.
@invoice Invoice
*/
payments.paymentFormStarGift#b425cfe1 form_id:long invoice:Invoice = payments.PaymentForm;

/*
Validated user-provided info

@id ID
@shipping_options Shipping options
*/
payments.validatedRequestedInfo#d1451883 flags:# id:flags.0?string shipping_options:flags.1?Vector<ShippingOption> = payments.ValidatedRequestedInfo;

/*
Payment result

@updates Info about the payment
*/
payments.paymentResult#4e5f810d updates:Updates = payments.PaymentResult;

/*
Payment was not successful, additional verification is needed

@url URL for additional payment credentials verification
*/
payments.paymentVerificationNeeded#d8411139 url:string = payments.PaymentResult;

/*
Receipt

@date Date of generation
@bot_id Bot ID
@provider_id Provider ID
@title Title
@description Description
@photo Photo
@invoice Invoice
@info Info
@shipping Selected shipping option
@tip_amount Tipped amount
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@total_amount Total amount in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@credentials_title Payment credential name
@users Users
*/
payments.paymentReceipt#70c4fe03 flags:# date:int bot_id:long provider_id:long title:string description:string photo:flags.2?WebDocument invoice:Invoice info:flags.0?PaymentRequestedInfo shipping:flags.1?ShippingOption tip_amount:flags.3?long currency:string total_amount:long credentials_title:string users:Vector<User> = payments.PaymentReceipt;

/*
Receipt for [payment made using Telegram Stars](https://core.telegram.org/api/stars).

@date Date of generation
@bot_id Bot ID
@title Title
@description Description
@photo Product photo
@invoice Invoice
@currency Currency, always XTR.
@total_amount Amount of [Telegram Stars](https://core.telegram.org/api/stars).
@transaction_id Transaction ID
@users Info about users mentioned in the other fields.
*/
payments.paymentReceiptStars#dabbf83a flags:# date:int bot_id:long title:string description:string photo:flags.2?WebDocument invoice:Invoice currency:string total_amount:long transaction_id:string users:Vector<User> = payments.PaymentReceipt;

/*
Saved server-side order information

@has_saved_credentials Whether the user has some saved payment credentials
@saved_info Saved server-side order information
*/
payments.savedInfo#fb8fe43c flags:# has_saved_credentials:flags.1?true saved_info:flags.0?PaymentRequestedInfo = payments.SavedInfo;

/*
Saved payment credentials

@id Credential ID
@tmp_password Temporary password
*/
inputPaymentCredentialsSaved#c10eb2cf id:string tmp_password:bytes = InputPaymentCredentials;

/*
Payment credentials

@save Save payment credential for future use
@data Payment credentials
*/
inputPaymentCredentials#3417d728 flags:# save:flags.0?true data:DataJSON = InputPaymentCredentials;

/*
Apple pay payment credentials

@payment_data Payment data
*/
inputPaymentCredentialsApplePay#aa1c39f payment_data:DataJSON = InputPaymentCredentials;

/*
Google Pay payment credentials

@payment_token Payment token
*/
inputPaymentCredentialsGooglePay#8ac32801 payment_token:DataJSON = InputPaymentCredentials;

/*
Temporary payment password

@tmp_password Temporary password
@valid_until Validity period
*/
account.tmpPassword#db64fd34 tmp_password:bytes valid_until:int = account.TmpPassword;

/*
Shipping option

@id Option ID
@title Title
@prices List of price portions
*/
shippingOption#b6213cdf id:string title:string prices:Vector<LabeledPrice> = ShippingOption;

/*
Sticker in a stickerset

@document The sticker
@emoji Associated emoji
@mask_coords Coordinates for mask sticker
@keywords Set of keywords, separated by commas (can't be provided for mask stickers)
*/
inputStickerSetItem#32da9e9c flags:# document:InputDocument emoji:string mask_coords:flags.0?MaskCoords keywords:flags.1?string = InputStickerSetItem;

/*
Phone call

@id Call ID
@access_hash Access hash
*/
inputPhoneCall#1e36fded id:long access_hash:long = InputPhoneCall;

/*
Empty constructor

@id Call ID
*/
phoneCallEmpty#5366c915 id:long = PhoneCall;

/*
Incoming phone call

@video Is this a video call
@id Call ID
@access_hash Access hash
@date Date
@admin_id Admin ID
@participant_id Participant ID
@protocol Phone call protocol info
@receive_date When was the phone call received
@conference_call  ... 

#DocError
*/
phoneCallWaiting#eed42858 flags:# video:flags.6?true id:long access_hash:long date:int admin_id:long participant_id:long protocol:PhoneCallProtocol receive_date:flags.0?int conference_call:flags.8?InputGroupCall = PhoneCall;

/*
Requested phone call

@video Whether this is a video call
@id Phone call ID
@access_hash Access hash
@date When was the phone call created
@admin_id ID of the creator of the phone call
@participant_id ID of the other participant of the phone call
@g_a_hash [Parameter for key exchange](https://core.telegram.org/api/end-to-end/voice-calls)
@protocol Call protocol info to be passed to libtgvoip
@conference_call  ... 

#DocError
*/
phoneCallRequested#45361c63 flags:# video:flags.6?true id:long access_hash:long date:int admin_id:long participant_id:long g_a_hash:bytes protocol:PhoneCallProtocol conference_call:flags.8?InputGroupCall = PhoneCall;

/*
An accepted phone call

@video Whether this is a video call
@id ID of accepted phone call
@access_hash Access hash of phone call
@date When was the call accepted
@admin_id ID of the call creator
@participant_id ID of the other user in the call
@g_b B parameter for [secure E2E phone call key exchange](https://core.telegram.org/api/end-to-end/voice-calls)
@protocol Protocol to use for phone call
@conference_call  ... 

#DocError
*/
phoneCallAccepted#22fd7181 flags:# video:flags.6?true id:long access_hash:long date:int admin_id:long participant_id:long g_b:bytes protocol:PhoneCallProtocol conference_call:flags.8?InputGroupCall = PhoneCall;

/*
Phone call

@p2p_allowed Whether P2P connection to the other peer is allowed
@video Whether this is a video call
@id Call ID
@access_hash Access hash
@date Date of creation of the call
@admin_id User ID of the creator of the call
@participant_id User ID of the other participant in the call
@g_a_or_b [Parameter for key exchange](https://core.telegram.org/api/end-to-end/voice-calls)
@key_fingerprint [Key fingerprint](https://core.telegram.org/api/end-to-end/voice-calls)
@protocol Call protocol info to be passed to libtgvoip
@connections List of endpoints the user can connect to exchange call data
@start_date When was the call actually started
@custom_parameters Custom JSON-encoded call parameters to be passed to tgcalls.
@conference_call  ... 

#DocError
*/
phoneCall#3ba5940c flags:# p2p_allowed:flags.5?true video:flags.6?true id:long access_hash:long date:int admin_id:long participant_id:long g_a_or_b:bytes key_fingerprint:long protocol:PhoneCallProtocol connections:Vector<PhoneConnection> start_date:int custom_parameters:flags.7?DataJSON conference_call:flags.8?InputGroupCall = PhoneCall;

/*
Indicates a discarded phone call

@need_rating Whether the server required the user to [rate](https://core.telegram.org/method/phone.setCallRating) the call
@need_debug Whether the server required the client to [send](https://core.telegram.org/method/phone.saveCallDebug) the libtgvoip call debug data
@video Whether the call was a video call
@id Call ID
@reason Why was the phone call discarded
@duration Duration of the phone call in seconds
@conference_call  ... 

#DocError
*/
phoneCallDiscarded#f9d25503 flags:# need_rating:flags.2?true need_debug:flags.3?true video:flags.6?true id:long reason:flags.0?PhoneCallDiscardReason duration:flags.1?int conference_call:flags.8?InputGroupCall = PhoneCall;

/*
Identifies an endpoint that can be used to connect to the other user in a phone call

@tcp Whether TCP should be used
@id Endpoint ID
@ip IP address of endpoint
@ipv6 IPv6 address of endpoint
@port Port ID
@peer_tag Our peer tag
*/
phoneConnection#9cc123c7 flags:# tcp:flags.0?true id:long ip:string ipv6:string port:int peer_tag:bytes = PhoneConnection;

/*
WebRTC connection parameters

@turn Whether this is a TURN endpoint
@stun Whether this is a STUN endpoint
@id Endpoint ID
@ip IP address
@ipv6 IPv6 address
@port Port
@username Username
@password Password
*/
phoneConnectionWebrtc#635fe375 flags:# turn:flags.0?true stun:flags.1?true id:long ip:string ipv6:string port:int username:string password:string = PhoneConnection;

/*
Protocol info for libtgvoip

@udp_p2p Whether to allow P2P connection to the other participant
@udp_reflector Whether to allow connection to the other participants through the reflector servers
@min_layer Minimum layer for remote libtgvoip
@max_layer Maximum layer for remote libtgvoip
@library_versions When using [phone.requestCall](https://core.telegram.org/method/phone.requestCall) and [phone.acceptCall](https://core.telegram.org/method/phone.acceptCall), specify all library versions supported by the client. The server will merge and choose the best library version supported by both peers, returning only the best value in the result of the callee's [phone.acceptCall](https://core.telegram.org/method/phone.acceptCall) and in the [phoneCallAccepted](https://core.telegram.org/constructor/phoneCallAccepted) update received by the caller.
*/
phoneCallProtocol#fc878fc8 flags:# udp_p2p:flags.0?true udp_reflector:flags.1?true min_layer:int max_layer:int library_versions:Vector<string> = PhoneCallProtocol;

/*
A VoIP phone call

@phone_call The VoIP phone call
@users VoIP phone call participants
*/
phone.phoneCall#ec82e140 phone_call:PhoneCall users:Vector<User> = phone.PhoneCall;

/*
The file was cleared from the temporary RAM cache of the [CDN](https://core.telegram.org/cdn) and has to be re-uploaded.

@request_token Request token (see [CDN](https://core.telegram.org/cdn))
*/
upload.cdnFileReuploadNeeded#eea8e46e request_token:bytes = upload.CdnFile;

/*
Represent a chunk of a [CDN](https://core.telegram.org/cdn) file.

@bytes The data
*/
upload.cdnFile#a99fca4f bytes:bytes = upload.CdnFile;

/*
Public key to use only during handshakes to [CDN](https://core.telegram.org/cdn) DCs.

@dc_id [CDN DC](https://core.telegram.org/cdn) ID
@public_key RSA public key
*/
cdnPublicKey#c982eaba dc_id:int public_key:string = CdnPublicKey;

/*
Configuration for [CDN](https://core.telegram.org/cdn) file downloads.

@public_keys Vector of public keys to use only during handshakes to [CDN](https://core.telegram.org/cdn) DCs.
*/
cdnConfig#5725e40a public_keys:Vector<CdnPublicKey> = CdnConfig;

/*
Translated localization string

@key Language key
@value Value
*/
langPackString#cad181f6 key:string value:string = LangPackString;

/*
A language pack string which has different forms based on the number of some object it mentions. See [https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html](https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html) for more info

@key Localization key
@zero_value Value for zero objects
@one_value Value for one object
@two_value Value for two objects
@few_value Value for a few objects
@many_value Value for many objects
@other_value Default value
*/
langPackStringPluralized#6c47ac9f flags:# key:string zero_value:flags.0?string one_value:flags.1?string two_value:flags.2?string few_value:flags.3?string many_value:flags.4?string other_value:string = LangPackString;

/*
Deleted localization string

@key Localization key
*/
langPackStringDeleted#2979eeb2 key:string = LangPackString;

/*
Changes to the app's localization pack

@lang_code Language code
@from_version Previous version number
@version New version number
@strings Localized strings
*/
langPackDifference#f385c1f6 lang_code:string from_version:int version:int strings:Vector<LangPackString> = LangPackDifference;

/*
Identifies a localization pack

@official Whether the language pack is official
@rtl Is this a localization pack for an RTL language
@beta Is this a beta localization pack?
@name Language name
@native_name Language name in the language itself
@lang_code Language code (pack identifier)
@base_lang_code Identifier of a base language pack; may be empty. If a string is missed in the language pack, then it should be fetched from base language pack. Unsupported in custom language packs
@plural_code A language code to be used to apply plural forms. See [https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html](https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html) for more info
@strings_count Total number of non-deleted strings from the language pack
@translated_count Total number of translated strings from the language pack
@translations_url Link to language translation interface; empty for custom local language packs
*/
langPackLanguage#eeca5ce3 flags:# official:flags.0?true rtl:flags.2?true beta:flags.3?true name:string native_name:string lang_code:string base_lang_code:flags.1?string plural_code:string strings_count:int translated_count:int translations_url:string = LangPackLanguage;

/*
Channel/supergroup title was changed

@prev_value Previous title
@new_value New title
*/
channelAdminLogEventActionChangeTitle#e6dfb825 prev_value:string new_value:string = ChannelAdminLogEventAction;

/*
The description was changed

@prev_value Previous description
@new_value New description
*/
channelAdminLogEventActionChangeAbout#55188a2e prev_value:string new_value:string = ChannelAdminLogEventAction;

/*
Channel/supergroup username was changed

@prev_value Old username
@new_value New username
*/
channelAdminLogEventActionChangeUsername#6a4afc38 prev_value:string new_value:string = ChannelAdminLogEventAction;

/*
The channel/supergroup's picture was changed

@prev_photo Previous picture
@new_photo New picture
*/
channelAdminLogEventActionChangePhoto#434bd2af prev_photo:Photo new_photo:Photo = ChannelAdminLogEventAction;

/*
Invites were enabled/disabled

@new_value New value
*/
channelAdminLogEventActionToggleInvites#1b7907ae new_value:Bool = ChannelAdminLogEventAction;

/*
Channel signatures were enabled/disabled

@new_value New value
*/
channelAdminLogEventActionToggleSignatures#26ae0971 new_value:Bool = ChannelAdminLogEventAction;

/*
A message was pinned

@message The message that was pinned
*/
channelAdminLogEventActionUpdatePinned#e9e82c18 message:Message = ChannelAdminLogEventAction;

/*
A message was edited

@prev_message Old message
@new_message New message
*/
channelAdminLogEventActionEditMessage#709b2405 prev_message:Message new_message:Message = ChannelAdminLogEventAction;

/*
A message was deleted

@message The message that was deleted
*/
channelAdminLogEventActionDeleteMessage#42e047bb message:Message = ChannelAdminLogEventAction;

/*
A user has joined the group (in the case of big groups, info of the user that has joined isn't shown)
*/
channelAdminLogEventActionParticipantJoin#183040d3 = ChannelAdminLogEventAction;

/*
A user left the channel/supergroup (in the case of big groups, info of the user that has joined isn't shown)
*/
channelAdminLogEventActionParticipantLeave#f89777f2 = ChannelAdminLogEventAction;

/*
A user was invited to the group

@participant The user that was invited
*/
channelAdminLogEventActionParticipantInvite#e31c34d8 participant:ChannelParticipant = ChannelAdminLogEventAction;

/*
The banned [rights](https://core.telegram.org/api/rights) of a user were changed

@prev_participant Old banned rights of user
@new_participant New banned rights of user
*/
channelAdminLogEventActionParticipantToggleBan#e6d83d7e prev_participant:ChannelParticipant new_participant:ChannelParticipant = ChannelAdminLogEventAction;

/*
The admin [rights](https://core.telegram.org/api/rights) of a user were changed

@prev_participant Previous admin rights
@new_participant New admin rights
*/
channelAdminLogEventActionParticipantToggleAdmin#d5676710 prev_participant:ChannelParticipant new_participant:ChannelParticipant = ChannelAdminLogEventAction;

/*
The supergroup's stickerset was changed

@prev_stickerset Previous stickerset
@new_stickerset New stickerset
*/
channelAdminLogEventActionChangeStickerSet#b1c3caa7 prev_stickerset:InputStickerSet new_stickerset:InputStickerSet = ChannelAdminLogEventAction;

/*
The hidden prehistory setting was [changed](https://core.telegram.org/method/channels.togglePreHistoryHidden)

@new_value New value
*/
channelAdminLogEventActionTogglePreHistoryHidden#5f5c95f1 new_value:Bool = ChannelAdminLogEventAction;

/*
The default banned rights were modified

@prev_banned_rights Previous global [banned rights](https://core.telegram.org/api/rights)
@new_banned_rights New global [banned rights](https://core.telegram.org/api/rights).
*/
channelAdminLogEventActionDefaultBannedRights#2df5fc0a prev_banned_rights:ChatBannedRights new_banned_rights:ChatBannedRights = ChannelAdminLogEventAction;

/*
A poll was stopped

@message The poll that was stopped
*/
channelAdminLogEventActionStopPoll#8f079643 message:Message = ChannelAdminLogEventAction;

/*
The linked chat was changed

@prev_value Previous linked chat
@new_value New linked chat
*/
channelAdminLogEventActionChangeLinkedChat#50c7ac8 prev_value:long new_value:long = ChannelAdminLogEventAction;

/*
The geogroup location was changed

@prev_value Previous location
@new_value New location
*/
channelAdminLogEventActionChangeLocation#e6b76ae prev_value:ChannelLocation new_value:ChannelLocation = ChannelAdminLogEventAction;

/*
[Slow mode setting for supergroups was changed](https://core.telegram.org/method/channels.toggleSlowMode)

@prev_value Previous slow mode value
@new_value New slow mode value
*/
channelAdminLogEventActionToggleSlowMode#53909779 prev_value:int new_value:int = ChannelAdminLogEventAction;

/*
A group call was started

@call Group call
*/
channelAdminLogEventActionStartGroupCall#23209745 call:InputGroupCall = ChannelAdminLogEventAction;

/*
A group call was terminated

@call The group call that was terminated
*/
channelAdminLogEventActionDiscardGroupCall#db9f9140 call:InputGroupCall = ChannelAdminLogEventAction;

/*
A group call participant was muted

@participant The participant that was muted
*/
channelAdminLogEventActionParticipantMute#f92424d2 participant:GroupCallParticipant = ChannelAdminLogEventAction;

/*
A group call participant was unmuted

@participant The participant that was unmuted
*/
channelAdminLogEventActionParticipantUnmute#e64429c0 participant:GroupCallParticipant = ChannelAdminLogEventAction;

/*
Group call settings were changed

@join_muted Whether all users are muted by default upon joining
*/
channelAdminLogEventActionToggleGroupCallSetting#56d6a247 join_muted:Bool = ChannelAdminLogEventAction;

/*
A user joined the [supergroup/channel](https://core.telegram.org/api/channel) using a specific invite link

@via_chatlist The participant joined by importing a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).
@invite The invite link used to join the [supergroup/channel](https://core.telegram.org/api/channel)
*/
channelAdminLogEventActionParticipantJoinByInvite#fe9fc158 flags:# via_chatlist:flags.0?true invite:ExportedChatInvite = ChannelAdminLogEventAction;

/*
A chat invite was deleted

@invite The deleted chat invite
*/
channelAdminLogEventActionExportedInviteDelete#5a50fca4 invite:ExportedChatInvite = ChannelAdminLogEventAction;

/*
A specific invite link was revoked

@invite The invite link that was revoked
*/
channelAdminLogEventActionExportedInviteRevoke#410a134e invite:ExportedChatInvite = ChannelAdminLogEventAction;

/*
A chat invite was edited

@prev_invite Previous chat invite information
@new_invite New chat invite information
*/
channelAdminLogEventActionExportedInviteEdit#e90ebb59 prev_invite:ExportedChatInvite new_invite:ExportedChatInvite = ChannelAdminLogEventAction;

/*
channelAdminLogEvent.user_id has set the volume of participant.peer to participant.volume

@participant The participant whose volume was changed
*/
channelAdminLogEventActionParticipantVolume#3e7f6847 participant:GroupCallParticipant = ChannelAdminLogEventAction;

/*
The Time-To-Live of messages in this chat was changed

@prev_value Previous value
@new_value New value
*/
channelAdminLogEventActionChangeHistoryTTL#6e941a38 prev_value:int new_value:int = ChannelAdminLogEventAction;

/*
A new member was accepted to the chat by an admin

@invite The invite link that was used to join the chat
@approved_by ID of the admin that approved the invite
*/
channelAdminLogEventActionParticipantJoinByRequest#afb6144a invite:ExportedChatInvite approved_by:long = ChannelAdminLogEventAction;

/*
Forwards were enabled or disabled

@new_value Old value
*/
channelAdminLogEventActionToggleNoForwards#cb2ac766 new_value:Bool = ChannelAdminLogEventAction;

/*
A message was posted in a channel

@message The message that was sent
*/
channelAdminLogEventActionSendMessage#278f2868 message:Message = ChannelAdminLogEventAction;

/*
The set of allowed [message reactions](https://core.telegram.org/api/reactions) for this channel has changed

@prev_value Previously allowed reaction emojis
@new_value New allowed reaction emojis
*/
channelAdminLogEventActionChangeAvailableReactions#be4e0ef8 prev_value:ChatReactions new_value:ChatReactions = ChannelAdminLogEventAction;

/*
The list of usernames associated with the channel was changed

@prev_value Previous set of usernames
@new_value New set of usernames
*/
channelAdminLogEventActionChangeUsernames#f04fb3a9 prev_value:Vector<string> new_value:Vector<string> = ChannelAdminLogEventAction;

/*
[Forum](https://core.telegram.org/api/forum) functionality was enabled or disabled.

@new_value Whether [forum](https://core.telegram.org/api/forum) functionality was enabled or disabled.
*/
channelAdminLogEventActionToggleForum#2cc6383 new_value:Bool = ChannelAdminLogEventAction;

/*
A [forum topic](https://core.telegram.org/api/forum#forum-topics) was created

@topic The [forum topic](https://core.telegram.org/api/forum#forum-topics) that was created
*/
channelAdminLogEventActionCreateTopic#58707d28 topic:ForumTopic = ChannelAdminLogEventAction;

/*
A [forum topic](https://core.telegram.org/api/forum#forum-topics) was edited

@prev_topic Previous topic information
@new_topic New topic information
*/
channelAdminLogEventActionEditTopic#f06fe208 prev_topic:ForumTopic new_topic:ForumTopic = ChannelAdminLogEventAction;

/*
A [forum topic](https://core.telegram.org/api/forum#forum-topics) was deleted

@topic The [forum topic](https://core.telegram.org/api/forum#forum-topics) that was deleted
*/
channelAdminLogEventActionDeleteTopic#ae168909 topic:ForumTopic = ChannelAdminLogEventAction;

/*
A [forum topic](https://core.telegram.org/api/forum#forum-topics) was pinned or unpinned

@prev_topic Previous topic information
@new_topic New topic information
*/
channelAdminLogEventActionPinTopic#5d8d353b flags:# prev_topic:flags.0?ForumTopic new_topic:flags.1?ForumTopic = ChannelAdminLogEventAction;

/*
[Native antispam](https://core.telegram.org/api/antispam) functionality was enabled or disabled.

@new_value Whether antispam functionality was enabled or disabled.
*/
channelAdminLogEventActionToggleAntiSpam#64f36dfc new_value:Bool = ChannelAdminLogEventAction;

/*
The [message accent color](https://core.telegram.org/api/colors) was changed

@prev_value Previous accent palette
@new_value New accent palette
*/
channelAdminLogEventActionChangePeerColor#5796e780 prev_value:PeerColor new_value:PeerColor = ChannelAdminLogEventAction;

/*
The [profile accent color](https://core.telegram.org/api/colors) was changed

@prev_value Previous accent palette
@new_value New accent palette
*/
channelAdminLogEventActionChangeProfilePeerColor#5e477b25 prev_value:PeerColor new_value:PeerColor = ChannelAdminLogEventAction;

/*
The [wallpaper](https://core.telegram.org/api/wallpapers) was changed

@prev_value Previous wallpaper
@new_value New wallpaper
*/
channelAdminLogEventActionChangeWallpaper#31bb5d52 prev_value:WallPaper new_value:WallPaper = ChannelAdminLogEventAction;

/*
The [emoji status](https://core.telegram.org/api/emoji-status) was changed

@prev_value Previous emoji status
@new_value New emoji status
*/
channelAdminLogEventActionChangeEmojiStatus#3ea9feb1 prev_value:EmojiStatus new_value:EmojiStatus = ChannelAdminLogEventAction;

/*
The supergroup's [custom emoji stickerset](https://core.telegram.org/api/boost#setting-a-custom-emoji-stickerset-for-supergroups) was changed.

@prev_stickerset Old value
@new_stickerset New value
*/
channelAdminLogEventActionChangeEmojiStickerSet#46d840ab prev_stickerset:InputStickerSet new_stickerset:InputStickerSet = ChannelAdminLogEventAction;

/*
Channel signature profiles were enabled/disabled.

@new_value New value
*/
channelAdminLogEventActionToggleSignatureProfiles#60a79c79 new_value:Bool = ChannelAdminLogEventAction;

/*
A paid subscriber has extended their [Telegram Star subscription](https://core.telegram.org/api/stars#star-subscriptions).

@prev_participant Same as new_participant.
@new_participant The subscriber that extended the subscription.
*/
channelAdminLogEventActionParticipantSubExtend#64642db3 prev_participant:ChannelParticipant new_participant:ChannelParticipant = ChannelAdminLogEventAction;

/*
Admin log event

@id Event ID
@date Date
@user_id User ID
@action Action
*/
channelAdminLogEvent#1fad68cd id:long date:int user_id:long action:ChannelAdminLogEventAction = ChannelAdminLogEvent;

/*
Admin log events

@events Admin log events
@chats Chats mentioned in events
@users Users mentioned in events
*/
channels.adminLogResults#ed8af74d events:Vector<ChannelAdminLogEvent> chats:Vector<Chat> users:Vector<User> = channels.AdminLogResults;

/*
Filter only certain admin log events

@join [Join events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantJoin), including [joins using invite links](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantJoinByInvite) and [join requests](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantJoinByRequest).
@leave [Leave events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantLeave)
@invite [Invite events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantInvite)
@ban [Ban events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantToggleBan)
@unban [Unban events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantToggleBan)
@kick [Kick events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantToggleBan)
@unkick [Unkick events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantToggleBan)
@promote [Admin promotion events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantToggleAdmin)
@demote [Admin demotion events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantToggleAdmin)
@info Info change events (when [about](https://core.telegram.org/constructor/channelAdminLogEventActionChangeAbout), [linked chat](https://core.telegram.org/constructor/channelAdminLogEventActionChangeLinkedChat), [location](https://core.telegram.org/constructor/channelAdminLogEventActionChangeLocation), [photo](https://core.telegram.org/constructor/channelAdminLogEventActionChangePhoto), [stickerset](https://core.telegram.org/constructor/channelAdminLogEventActionChangeStickerSet), [title](https://core.telegram.org/constructor/channelAdminLogEventActionChangeTitle) or [username](https://core.telegram.org/constructor/channelAdminLogEventActionChangeUsername), [slowmode](https://core.telegram.org/constructor/channelAdminLogEventActionToggleSlowMode), [history TTL](https://core.telegram.org/constructor/channelAdminLogEventActionChangeHistoryTTL) settings of a channel gets modified)
@settings Settings change events ( [invites](https://core.telegram.org/constructor/channelAdminLogEventActionToggleInvites), [hidden prehistory](https://core.telegram.org/constructor/channelAdminLogEventActionTogglePreHistoryHidden), [signatures](https://core.telegram.org/constructor/channelAdminLogEventActionToggleSignatures), [default banned rights](https://core.telegram.org/constructor/channelAdminLogEventActionDefaultBannedRights), [forum toggle events](https://core.telegram.org/constructor/channelAdminLogEventActionToggleForum))
@pinned [Message pin events](https://core.telegram.org/constructor/channelAdminLogEventActionUpdatePinned)
@edit [Message edit events](https://core.telegram.org/constructor/channelAdminLogEventActionEditMessage)
@delete [Message deletion events](https://core.telegram.org/constructor/channelAdminLogEventActionDeleteMessage)
@group_call Group call events
@invites Invite events
@send A message was posted in a channel
@forums [Forum](https://core.telegram.org/api/forum)-related events
@sub_extend [Telegram Star subscription extension events](https://core.telegram.org/constructor/channelAdminLogEventActionParticipantSubExtend)
*/
channelAdminLogEventsFilter#ea107ae4 flags:# join:flags.0?true leave:flags.1?true invite:flags.2?true ban:flags.3?true unban:flags.4?true kick:flags.5?true unkick:flags.6?true promote:flags.7?true demote:flags.8?true info:flags.9?true settings:flags.10?true pinned:flags.11?true edit:flags.12?true delete:flags.13?true group_call:flags.14?true invites:flags.15?true send:flags.16?true forums:flags.17?true sub_extend:flags.18?true = ChannelAdminLogEventsFilter;

/*
Popular contact

@client_id Contact identifier
@importers How many people imported this contact
*/
popularContact#5ce14175 client_id:long importers:int = PopularContact;

/*
No new favorited stickers were found
*/
messages.favedStickersNotModified#9e8fa6d3 = messages.FavedStickers;

/*
Favorited stickers

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@packs Emojis associated to stickers
@stickers Favorited stickers
*/
messages.favedStickers#2cb51097 hash:long packs:Vector<StickerPack> stickers:Vector<Document> = messages.FavedStickers;

/*
Unknown t.me url

@url URL
*/
recentMeUrlUnknown#46e1d13d url:string = RecentMeUrl;

/*
Recent t.me link to a user

@url URL
@user_id User ID
*/
recentMeUrlUser#b92c09e2 url:string user_id:long = RecentMeUrl;

/*
Recent t.me link to a chat

@url t.me URL
@chat_id Chat ID
*/
recentMeUrlChat#b2da71d2 url:string chat_id:long = RecentMeUrl;

/*
Recent t.me invite link to a chat

@url t.me URL
@chat_invite Chat invitation
*/
recentMeUrlChatInvite#eb49081d url:string chat_invite:ChatInvite = RecentMeUrl;

/*
Recent t.me stickerset installation URL

@url t.me URL
@set Stickerset
*/
recentMeUrlStickerSet#bc0a57dc url:string set:StickerSetCovered = RecentMeUrl;

/*
Recent t.me URLs

@urls URLs
@chats Chats
@users Users
*/
help.recentMeUrls#e0310d7 urls:Vector<RecentMeUrl> chats:Vector<Chat> users:Vector<User> = help.RecentMeUrls;

/*
A single media in an [album or grouped media](https://core.telegram.org/api/files#albums-grouped-media) sent with [messages.sendMultiMedia](https://core.telegram.org/method/messages.sendMultiMedia).

@media The media
@random_id Unique client media ID required to prevent message resending
@message A caption for the media
@entities Message [entities](https://core.telegram.org/api/entities) for styled text
*/
inputSingleMedia#1cc6e91f flags:# media:InputMedia random_id:long message:string entities:flags.0?Vector<MessageEntity> = InputSingleMedia;

/*
Represents a bot logged in using the [Telegram login widget](https://core.telegram.org/widgets/login)

@hash Authorization hash
@bot_id Bot ID
@domain The domain name of the website on which the user has logged in.
@browser Browser user-agent
@platform Platform
@date_created When was the web session created
@date_active When was the web session last active
@ip IP address
@region Region, determined from IP address
*/
webAuthorization#a6f8f452 hash:long bot_id:long domain:string browser:string platform:string date_created:int date_active:int ip:string region:string = WebAuthorization;

/*
Web authorizations

@authorizations Web authorization list
@users Users
*/
account.webAuthorizations#ed56c9fc authorizations:Vector<WebAuthorization> users:Vector<User> = account.WebAuthorizations;

/*
Message by ID

@id Message ID
*/
inputMessageID#a676a322 id:int = InputMessage;

/*
Message to which the specified message replies to

@id ID of the message that replies to the message we need
*/
inputMessageReplyTo#bad88395 id:int = InputMessage;

/*
Pinned message
*/
inputMessagePinned#86872538 = InputMessage;

/*
Used by bots for fetching information about the message that originated a callback query

@id Message ID
@query_id Callback query ID
*/
inputMessageCallbackQuery#acfa1a7e id:int query_id:long = InputMessage;

/*
A peer

@peer Peer
*/
inputDialogPeer#fcaafeb7 peer:InputPeer = InputDialogPeer;

/*
All peers in a [peer folder](https://core.telegram.org/api/folders#peer-folders)

@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
*/
inputDialogPeerFolder#64600527 folder_id:int = InputDialogPeer;

/*
Peer

@peer Peer
*/
dialogPeer#e56dbf05 peer:Peer = DialogPeer;

/*
[Peer folder](https://core.telegram.org/api/folders#peer-folders)

@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
*/
dialogPeerFolder#514519e2 folder_id:int = DialogPeer;

/*
No further results were found
*/
messages.foundStickerSetsNotModified#d54b65d = messages.FoundStickerSets;

/*
Found stickersets

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@sets Found stickersets
*/
messages.foundStickerSets#8af09dd2 hash:long sets:Vector<StickerSetCovered> = messages.FoundStickerSets;

/*
SHA256 Hash of an uploaded file, to be checked for validity after download

@offset Offset from where to start computing SHA-256 hash
@limit Length
@hash SHA-256 Hash of file chunk, to be checked for validity after download
*/
fileHash#f39b035c offset:long limit:int hash:bytes = FileHash;

/*
Info about an [MTProxy](https://core.telegram.org/mtproto/mtproto-transports#transport-obfuscation) used to connect.

@address Proxy address
@port Proxy port
*/
inputClientProxy#75588b3f address:string port:int = InputClientProxy;

/*
No changes were made to telegram's terms of service

@expires New TOS updates will have to be queried using [help.getTermsOfServiceUpdate](https://core.telegram.org/method/help.getTermsOfServiceUpdate) in expires seconds
*/
help.termsOfServiceUpdateEmpty#e3309f7f expires:int = help.TermsOfServiceUpdate;

/*
Info about an update of telegram's terms of service. If the terms of service are declined, then the [account.deleteAccount](https://core.telegram.org/method/account.deleteAccount) method should be called with the reason "Decline ToS update"

@expires New TOS updates will have to be queried using [help.getTermsOfServiceUpdate](https://core.telegram.org/method/help.getTermsOfServiceUpdate) in expires seconds
@terms_of_service New terms of service
*/
help.termsOfServiceUpdate#28ecf961 expires:int terms_of_service:help.TermsOfService = help.TermsOfServiceUpdate;

/*
Uploaded secure file, for more info [see the passport docs](https://core.telegram.org/passport/encryption#inputsecurefile)

@id Secure file ID
@parts Secure file part count
@md5_checksum MD5 hash of encrypted uploaded file, to be checked server-side
@file_hash File hash
@secret Secret
*/
inputSecureFileUploaded#3334b0f0 id:long parts:int md5_checksum:string file_hash:bytes secret:bytes = InputSecureFile;

/*
Pre-uploaded [passport](https://core.telegram.org/passport) file, for more info [see the passport docs](https://core.telegram.org/passport/encryption#inputsecurefile)

@id Secure file ID
@access_hash Secure file access hash
*/
inputSecureFile#5367e5be id:long access_hash:long = InputSecureFile;

/*
Empty constructor
*/
secureFileEmpty#64199744 = SecureFile;

/*
Secure [passport](https://core.telegram.org/passport) file, for more info [see the passport docs](https://core.telegram.org/passport/encryption#inputsecurefile)

@id ID
@access_hash Access hash
@size File size
@dc_id DC ID
@date Date of upload
@file_hash File hash
@secret Secret
*/
secureFile#7d09c27e id:long access_hash:long size:long dc_id:int date:int file_hash:bytes secret:bytes = SecureFile;

/*
Secure [passport](https://core.telegram.org/passport) data, for more info [see the passport docs](https://core.telegram.org/passport/encryption#securedata)

@data Data
@data_hash Data hash
@secret Secret
*/
secureData#8aeabec3 data:bytes data_hash:bytes secret:bytes = SecureData;

/*
Phone number to use in [telegram passport](https://core.telegram.org/passport): [it must be verified, first](https://core.telegram.org/passport/encryption#secureplaindata).

@phone Phone number
*/
securePlainPhone#7d6099dd phone:string = SecurePlainData;

/*
Email address to use in [telegram passport](https://core.telegram.org/passport): [it must be verified, first](https://core.telegram.org/passport/encryption#secureplaindata).

@email Email address
*/
securePlainEmail#21ec5a5f email:string = SecurePlainData;

/*
Personal details
*/
secureValueTypePersonalDetails#9d2a81e3 = SecureValueType;

/*
Passport
*/
secureValueTypePassport#3dac6a00 = SecureValueType;

/*
Driver's license
*/
secureValueTypeDriverLicense#6e425c4 = SecureValueType;

/*
Identity card
*/
secureValueTypeIdentityCard#a0d0744b = SecureValueType;

/*
Internal [passport](https://core.telegram.org/passport)
*/
secureValueTypeInternalPassport#99a48f23 = SecureValueType;

/*
Address
*/
secureValueTypeAddress#cbe31e26 = SecureValueType;

/*
Utility bill
*/
secureValueTypeUtilityBill#fc36954e = SecureValueType;

/*
Bank statement
*/
secureValueTypeBankStatement#89137c0d = SecureValueType;

/*
Rental agreement
*/
secureValueTypeRentalAgreement#8b883488 = SecureValueType;

/*
Internal registration [passport](https://core.telegram.org/passport)
*/
secureValueTypePassportRegistration#99e3806a = SecureValueType;

/*
Temporary registration
*/
secureValueTypeTemporaryRegistration#ea02ec33 = SecureValueType;

/*
Phone
*/
secureValueTypePhone#b320aadb = SecureValueType;

/*
Email
*/
secureValueTypeEmail#8e3ca7ee = SecureValueType;

/*
Secure value

@type Secure [passport](https://core.telegram.org/passport) value type
@data Encrypted [Telegram Passport](https://core.telegram.org/passport) element data
@front_side Encrypted [passport](https://core.telegram.org/passport) file with the front side of the document
@reverse_side Encrypted [passport](https://core.telegram.org/passport) file with the reverse side of the document
@selfie Encrypted [passport](https://core.telegram.org/passport) file with a selfie of the user holding the document
@translation Array of encrypted [passport](https://core.telegram.org/passport) files with translated versions of the provided documents
@files Array of encrypted [passport](https://core.telegram.org/passport) files with photos the of the documents
@plain_data Plaintext verified [passport](https://core.telegram.org/passport) data
@hash Data hash
*/
secureValue#187fa0ca flags:# type:SecureValueType data:flags.0?SecureData front_side:flags.1?SecureFile reverse_side:flags.2?SecureFile selfie:flags.3?SecureFile translation:flags.6?Vector<SecureFile> files:flags.4?Vector<SecureFile> plain_data:flags.5?SecurePlainData hash:bytes = SecureValue;

/*
Secure value, [for more info see the passport docs](https://core.telegram.org/passport/encryption#encryption)

@type Secure [passport](https://core.telegram.org/passport) value type
@data Encrypted [Telegram Passport](https://core.telegram.org/passport) element data
@front_side Encrypted [passport](https://core.telegram.org/passport) file with the front side of the document
@reverse_side Encrypted [passport](https://core.telegram.org/passport) file with the reverse side of the document
@selfie Encrypted [passport](https://core.telegram.org/passport) file with a selfie of the user holding the document
@translation Array of encrypted [passport](https://core.telegram.org/passport) files with translated versions of the provided documents
@files Array of encrypted [passport](https://core.telegram.org/passport) files with photos the of the documents
@plain_data Plaintext verified [passport](https://core.telegram.org/passport) data
*/
inputSecureValue#db21d0a7 flags:# type:SecureValueType data:flags.0?SecureData front_side:flags.1?InputSecureFile reverse_side:flags.2?InputSecureFile selfie:flags.3?InputSecureFile translation:flags.6?Vector<InputSecureFile> files:flags.4?Vector<InputSecureFile> plain_data:flags.5?SecurePlainData = InputSecureValue;

/*
Secure value hash

@type Secure value type
@hash Hash
*/
secureValueHash#ed1ecdb0 type:SecureValueType hash:bytes = SecureValueHash;

/*
Represents an issue in one of the data fields that was provided by the user. The error is considered resolved when the field's value changes.

@type The section of the user's Telegram Passport which has the error, one of [secureValueTypePersonalDetails](https://core.telegram.org/constructor/secureValueTypePersonalDetails), [secureValueTypePassport](https://core.telegram.org/constructor/secureValueTypePassport), [secureValueTypeDriverLicense](https://core.telegram.org/constructor/secureValueTypeDriverLicense), [secureValueTypeIdentityCard](https://core.telegram.org/constructor/secureValueTypeIdentityCard), [secureValueTypeInternalPassport](https://core.telegram.org/constructor/secureValueTypeInternalPassport), [secureValueTypeAddress](https://core.telegram.org/constructor/secureValueTypeAddress)
@data_hash Data hash
@field Name of the data field which has the error
@text Error message
*/
secureValueErrorData#e8a40bd9 type:SecureValueType data_hash:bytes field:string text:string = SecureValueError;

/*
Represents an issue with the front side of a document. The error is considered resolved when the file with the front side of the document changes.

@type One of [secureValueTypePassport](https://core.telegram.org/constructor/secureValueTypePassport), [secureValueTypeDriverLicense](https://core.telegram.org/constructor/secureValueTypeDriverLicense), [secureValueTypeIdentityCard](https://core.telegram.org/constructor/secureValueTypeIdentityCard), [secureValueTypeInternalPassport](https://core.telegram.org/constructor/secureValueTypeInternalPassport)
@file_hash File hash
@text Error message
*/
secureValueErrorFrontSide#be3dfa type:SecureValueType file_hash:bytes text:string = SecureValueError;

/*
Represents an issue with the reverse side of a document. The error is considered resolved when the file with reverse side of the document changes.

@type One of [secureValueTypeDriverLicense](https://core.telegram.org/constructor/secureValueTypeDriverLicense), [secureValueTypeIdentityCard](https://core.telegram.org/constructor/secureValueTypeIdentityCard)
@file_hash File hash
@text Error message
*/
secureValueErrorReverseSide#868a2aa5 type:SecureValueType file_hash:bytes text:string = SecureValueError;

/*
Represents an issue with the selfie with a document. The error is considered resolved when the file with the selfie changes.

@type One of [secureValueTypePassport](https://core.telegram.org/constructor/secureValueTypePassport), [secureValueTypeDriverLicense](https://core.telegram.org/constructor/secureValueTypeDriverLicense), [secureValueTypeIdentityCard](https://core.telegram.org/constructor/secureValueTypeIdentityCard), [secureValueTypeInternalPassport](https://core.telegram.org/constructor/secureValueTypeInternalPassport)
@file_hash File hash
@text Error message
*/
secureValueErrorSelfie#e537ced6 type:SecureValueType file_hash:bytes text:string = SecureValueError;

/*
Represents an issue with a document scan. The error is considered resolved when the file with the document scan changes.

@type One of [secureValueTypeUtilityBill](https://core.telegram.org/constructor/secureValueTypeUtilityBill), [secureValueTypeBankStatement](https://core.telegram.org/constructor/secureValueTypeBankStatement), [secureValueTypeRentalAgreement](https://core.telegram.org/constructor/secureValueTypeRentalAgreement), [secureValueTypePassportRegistration](https://core.telegram.org/constructor/secureValueTypePassportRegistration), [secureValueTypeTemporaryRegistration](https://core.telegram.org/constructor/secureValueTypeTemporaryRegistration)
@file_hash File hash
@text Error message
*/
secureValueErrorFile#7a700873 type:SecureValueType file_hash:bytes text:string = SecureValueError;

/*
Represents an issue with a list of scans. The error is considered resolved when the list of files containing the scans changes.

@type One of [secureValueTypeUtilityBill](https://core.telegram.org/constructor/secureValueTypeUtilityBill), [secureValueTypeBankStatement](https://core.telegram.org/constructor/secureValueTypeBankStatement), [secureValueTypeRentalAgreement](https://core.telegram.org/constructor/secureValueTypeRentalAgreement), [secureValueTypePassportRegistration](https://core.telegram.org/constructor/secureValueTypePassportRegistration), [secureValueTypeTemporaryRegistration](https://core.telegram.org/constructor/secureValueTypeTemporaryRegistration)
@file_hash File hash
@text Error message
*/
secureValueErrorFiles#666220e9 type:SecureValueType file_hash:Vector<bytes> text:string = SecureValueError;

/*
Secure value error

@type Type of element which has the issue
@hash Hash
@text Error message
*/
secureValueError#869d758f type:SecureValueType hash:bytes text:string = SecureValueError;

/*
Represents an issue with one of the files that constitute the translation of a document. The error is considered resolved when the file changes.

@type One of [secureValueTypePersonalDetails](https://core.telegram.org/constructor/secureValueTypePersonalDetails), [secureValueTypePassport](https://core.telegram.org/constructor/secureValueTypePassport), [secureValueTypeDriverLicense](https://core.telegram.org/constructor/secureValueTypeDriverLicense), [secureValueTypeIdentityCard](https://core.telegram.org/constructor/secureValueTypeIdentityCard), [secureValueTypeInternalPassport](https://core.telegram.org/constructor/secureValueTypeInternalPassport), [secureValueTypeUtilityBill](https://core.telegram.org/constructor/secureValueTypeUtilityBill), [secureValueTypeBankStatement](https://core.telegram.org/constructor/secureValueTypeBankStatement), [secureValueTypeRentalAgreement](https://core.telegram.org/constructor/secureValueTypeRentalAgreement), [secureValueTypePassportRegistration](https://core.telegram.org/constructor/secureValueTypePassportRegistration), [secureValueTypeTemporaryRegistration](https://core.telegram.org/constructor/secureValueTypeTemporaryRegistration)
@file_hash File hash
@text Error message
*/
secureValueErrorTranslationFile#a1144770 type:SecureValueType file_hash:bytes text:string = SecureValueError;

/*
Represents an issue with the translated version of a document. The error is considered resolved when a file with the document translation changes.

@type One of [secureValueTypePersonalDetails](https://core.telegram.org/constructor/secureValueTypePersonalDetails), [secureValueTypePassport](https://core.telegram.org/constructor/secureValueTypePassport), [secureValueTypeDriverLicense](https://core.telegram.org/constructor/secureValueTypeDriverLicense), [secureValueTypeIdentityCard](https://core.telegram.org/constructor/secureValueTypeIdentityCard), [secureValueTypeInternalPassport](https://core.telegram.org/constructor/secureValueTypeInternalPassport), [secureValueTypeUtilityBill](https://core.telegram.org/constructor/secureValueTypeUtilityBill), [secureValueTypeBankStatement](https://core.telegram.org/constructor/secureValueTypeBankStatement), [secureValueTypeRentalAgreement](https://core.telegram.org/constructor/secureValueTypeRentalAgreement), [secureValueTypePassportRegistration](https://core.telegram.org/constructor/secureValueTypePassportRegistration), [secureValueTypeTemporaryRegistration](https://core.telegram.org/constructor/secureValueTypeTemporaryRegistration)
@file_hash Hash
@text Error message
*/
secureValueErrorTranslationFiles#34636dd8 type:SecureValueType file_hash:Vector<bytes> text:string = SecureValueError;

/*
Encrypted credentials required to decrypt [telegram passport](https://core.telegram.org/passport) data.

@data Encrypted JSON-serialized data with unique user's payload, data hashes and secrets required for EncryptedPassportElement decryption and authentication, as described in [decrypting data](https://core.telegram.org/passport#decrypting-data)
@hash Data hash for data authentication as described in [decrypting data](https://core.telegram.org/passport#decrypting-data)
@secret Secret, encrypted with the bot's public RSA key, required for data decryption as described in [decrypting data](https://core.telegram.org/passport#decrypting-data)
*/
secureCredentialsEncrypted#33f0ea47 data:bytes hash:bytes secret:bytes = SecureCredentialsEncrypted;

/*
[Telegram Passport](https://core.telegram.org/passport) authorization form

@required_types Required [Telegram Passport](https://core.telegram.org/passport) documents
@values Already submitted [Telegram Passport](https://core.telegram.org/passport) documents
@errors [Telegram Passport](https://core.telegram.org/passport) errors
@users Info about the bot to which the form will be submitted
@privacy_policy_url URL of the service's privacy policy
*/
account.authorizationForm#ad2e1cd8 flags:# required_types:Vector<SecureRequiredType> values:Vector<SecureValue> errors:Vector<SecureValueError> users:Vector<User> privacy_policy_url:flags.0?string = account.AuthorizationForm;

/*
The sent email code

@email_pattern The email (to which the code was sent) must match this [pattern](https://core.telegram.org/api/pattern)
@length The length of the verification code
*/
account.sentEmailCode#811f854f email_pattern:string length:int = account.SentEmailCode;

/*
Deep link info empty
*/
help.deepLinkInfoEmpty#66afa166 = help.DeepLinkInfo;

/*
Deep link info, see [the here for more details](https://core.telegram.org/api/links#unsupported-links)

@update_app An update of the app is required to parse this link
@message Message to show to the user
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
*/
help.deepLinkInfo#6a4ee832 flags:# update_app:flags.0?true message:string entities:flags.1?Vector<MessageEntity> = help.DeepLinkInfo;

/*
Saved contact

@phone Phone number
@first_name First name
@last_name Last name
@date Date added
*/
savedPhoneContact#1142bd56 phone:string first_name:string last_name:string date:int = SavedContact;

/*
Takeout info

@id Takeout ID
*/
account.takeout#4dba4501 id:long = account.Takeout;

/*
Unknown KDF (most likely, the client is outdated and does not support the specified KDF algorithm)
*/
passwordKdfAlgoUnknown#d45ab096 = PasswordKdfAlgo;

/*
This key derivation algorithm defines that [SRP 2FA login](https://core.telegram.org/api/srp) must be used

@salt1 One of two salts used by the derivation function (see [SRP 2FA login](https://core.telegram.org/api/srp))
@salt2 One of two salts used by the derivation function (see [SRP 2FA login](https://core.telegram.org/api/srp))
@g Base (see [SRP 2FA login](https://core.telegram.org/api/srp))
@p 2048-bit modulus (see [SRP 2FA login](https://core.telegram.org/api/srp))
*/
passwordKdfAlgoSHA256SHA256PBKDF2HMACSHA512iter100000SHA256ModPow#3a912d4a salt1:bytes salt2:bytes g:int p:bytes = PasswordKdfAlgo;

/*
Unknown KDF algo (most likely the client has to be updated)
*/
securePasswordKdfAlgoUnknown#4a8537 = SecurePasswordKdfAlgo;

/*
PBKDF2 with SHA512 and 100000 iterations KDF algo

@salt Salt
*/
securePasswordKdfAlgoPBKDF2HMACSHA512iter100000#bbf2dda0 salt:bytes = SecurePasswordKdfAlgo;

/*
SHA512 KDF algo

@salt Salt
*/
securePasswordKdfAlgoSHA512#86471d92 salt:bytes = SecurePasswordKdfAlgo;

/*
Secure settings

@secure_algo Secure KDF algo
@secure_secret Secure secret
@secure_secret_id Secret ID
*/
secureSecretSettings#1527bcac secure_algo:SecurePasswordKdfAlgo secure_secret:bytes secure_secret_id:long = SecureSecretSettings;

/*
There is no password
*/
inputCheckPasswordEmpty#9880f658 = InputCheckPasswordSRP;

/*
Constructor for checking the validity of a 2FA SRP password (see [SRP](https://core.telegram.org/api/srp))

@srp_id [SRP ID](https://core.telegram.org/api/srp)
@A A parameter (see [SRP](https://core.telegram.org/api/srp))
@M1 M1 parameter (see [SRP](https://core.telegram.org/api/srp))
*/
inputCheckPasswordSRP#d27ff082 srp_id:long A:bytes M1:bytes = InputCheckPasswordSRP;

/*
Required type

@native_names Native names
@selfie_required Is a selfie required
@translation_required Is a translation required
@type Secure value type
*/
secureRequiredType#829d99da flags:# native_names:flags.0?true selfie_required:flags.1?true translation_required:flags.2?true type:SecureValueType = SecureRequiredType;

/*
One of

@types Secure required value types
*/
secureRequiredTypeOneOf#27477b4 types:Vector<SecureRequiredType> = SecureRequiredType;

/*
Password configuration not modified
*/
help.passportConfigNotModified#bfb9f457 = help.PassportConfig;

/*
Telegram [passport](https://core.telegram.org/passport) configuration

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@countries_langs Localization
*/
help.passportConfig#a098d6af hash:int countries_langs:DataJSON = help.PassportConfig;

/*
Event that occurred in the application.

@time Client's exact timestamp for the event
@type Type of event
@peer Arbitrary numeric value for more convenient selection of certain event types, or events referring to a certain object
@data Details of the event
*/
inputAppEvent#1d1b1245 time:double type:string peer:long data:JSONValue = InputAppEvent;

/*
JSON key: value pair

@key Key
@value Value
*/
jsonObjectValue#c0de1bd9 key:string value:JSONValue = JSONObjectValue;

/*
null JSON value
*/
jsonNull#3f6d7b68 = JSONValue;

/*
JSON boolean value

@value Value
*/
jsonBool#c7345e6a value:Bool = JSONValue;

/*
JSON numeric value

@value Value
*/
jsonNumber#2be0dfa4 value:double = JSONValue;

/*
JSON string

@value Value
*/
jsonString#b71e767a value:string = JSONValue;

/*
JSON array

@value JSON values
*/
jsonArray#f7444763 value:Vector<JSONValue> = JSONValue;

/*
JSON object value

@value Values
*/
jsonObject#99c1d49d value:Vector<JSONObjectValue> = JSONValue;

/*
Table cell

@header Is this element part of the column header
@align_center Horizontally centered block
@align_right Right-aligned block
@valign_middle Vertically centered block
@valign_bottom Block vertically-aligned to the bottom
@text Content
@colspan For how many columns should this cell extend
@rowspan For how many rows should this cell extend
*/
pageTableCell#34566b6a flags:# header:flags.0?true align_center:flags.3?true align_right:flags.4?true valign_middle:flags.5?true valign_bottom:flags.6?true text:flags.7?RichText colspan:flags.1?int rowspan:flags.2?int = PageTableCell;

/*
Table row

@cells Table cells
*/
pageTableRow#e0c0c5e5 cells:Vector<PageTableCell> = PageTableRow;

/*
Page caption

@text Caption
@credit Credits
*/
pageCaption#6f747657 text:RichText credit:RichText = PageCaption;

/*
List item

@text Text
*/
pageListItemText#b92fb6cd text:RichText = PageListItem;

/*
List item

@blocks Blocks
*/
pageListItemBlocks#25e073fc blocks:Vector<PageBlock> = PageListItem;

/*
Ordered list of text items

@num Number of element within ordered list
@text Text
*/
pageListOrderedItemText#5e068047 num:string text:RichText = PageListOrderedItem;

/*
Ordered list of [IV](https://instantview.telegram.org) blocks

@num Number of element within ordered list
@blocks Item contents
*/
pageListOrderedItemBlocks#98dd8936 num:string blocks:Vector<PageBlock> = PageListOrderedItem;

/*
Related article

@url URL of article
@webpage_id Webpage ID of generated IV preview
@title Title
@description Description
@photo_id ID of preview photo
@author Author name
@published_date Date of publication
*/
pageRelatedArticle#b390dc08 flags:# url:string webpage_id:long title:flags.0?string description:flags.1?string photo_id:flags.2?long author:flags.3?string published_date:flags.4?int = PageRelatedArticle;

/*
[Instant view](https://instantview.telegram.org) page

@part Indicates that not full page preview is available to the client and it will need to fetch full Instant View from the server using [messages.getWebPagePreview](https://core.telegram.org/method/messages.getWebPagePreview).
@rtl Whether the page contains RTL text
@v2 Whether this is an [IV v2](https://instantview.telegram.org/docs#what-39s-new-in-2-0) page
@url Original page HTTP URL
@blocks Page elements (like with HTML elements, only as TL constructors)
@photos Photos in page
@documents Media in page
@views View count
*/
page#98657f0d flags:# part:flags.0?true rtl:flags.1?true v2:flags.2?true url:string blocks:Vector<PageBlock> photos:Vector<Photo> documents:Vector<Document> views:flags.3?int = Page;

/*
Localized name for telegram support

@name Localized name
*/
help.supportName#8c05f1c9 name:string = help.SupportName;

/*
Internal use
*/
help.userInfoEmpty#f3ae2eed = help.UserInfo;

/*
Internal use

@message Info
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@author Author
@date Date
*/
help.userInfo#1eb3758 message:string entities:Vector<MessageEntity> author:string date:int = help.UserInfo;

/*
A possible answer of a poll

@text Textual representation of the answer (only [Premium](https://core.telegram.org/api/premium) users can use [custom emoji entities](https://core.telegram.org/api/custom-emoji) here).
@option The param that has to be passed to [messages.sendVote](https://core.telegram.org/method/messages.sendVote).
*/
pollAnswer#ff16e2ca text:TextWithEntities option:bytes = PollAnswer;

/*
Poll

@id ID of the poll
@closed Whether the poll is closed and doesn't accept any more answers
@public_voters Whether cast votes are publicly visible to all users (non-anonymous poll)
@multiple_choice Whether multiple options can be chosen as answer
@quiz Whether this is a quiz (with wrong and correct answers, results shown in the return type)
@question The question of the poll (only [Premium](https://core.telegram.org/api/premium) users can use [custom emoji entities](https://core.telegram.org/api/custom-emoji) here).
@answers The possible answers, vote using [messages.sendVote](https://core.telegram.org/method/messages.sendVote).
@close_period Amount of time in seconds the poll will be active after creation, 5-600. Can't be used together with close_date.
@close_date Point in time (Unix timestamp) when the poll will be automatically closed. Must be at least 5 and no more than 600 seconds in the future; can't be used together with close_period.
*/
poll#58747131 id:long flags:# closed:flags.0?true public_voters:flags.1?true multiple_choice:flags.2?true quiz:flags.3?true question:TextWithEntities answers:Vector<PollAnswer> close_period:flags.4?int close_date:flags.5?int = Poll;

/*
A poll answer, and how users voted on it

@chosen Whether we have chosen this answer
@correct For quizzes, whether the option we have chosen is correct
@option The param that has to be passed to [messages.sendVote](https://core.telegram.org/method/messages.sendVote).
@voters How many users voted for this option
*/
pollAnswerVoters#3b6ddad2 flags:# chosen:flags.0?true correct:flags.1?true option:bytes voters:int = PollAnswerVoters;

/*
Results of poll

@min Similar to [min](https://core.telegram.org/api/min) objects, used for poll constructors that are the same for all users so they don't have the option chosen by the current user (you can use [messages.getPollResults](https://core.telegram.org/method/messages.getPollResults) to get the full poll results).
@results Poll results
@total_voters Total number of people that voted in the poll
@recent_voters IDs of the last users that recently voted in the poll
@solution Explanation of quiz solution
@solution_entities [Message entities for styled text in quiz solution](https://core.telegram.org/api/entities)
*/
pollResults#7adf2420 flags:# min:flags.0?true results:flags.1?Vector<PollAnswerVoters> total_voters:flags.2?int recent_voters:flags.3?Vector<Peer> solution:flags.4?string solution_entities:flags.4?Vector<MessageEntity> = PollResults;

/*
Number of online users in a chat

@onlines Number of online users
*/
chatOnlines#f041e250 onlines:int = ChatOnlines;

/*
URL with chat statistics

@url Chat statistics
*/
statsURL#47a971e0 url:string = StatsURL;

/*
Represents the rights of an admin in a [channel/supergroup](https://core.telegram.org/api/channel).

@change_info If set, allows the admin to modify the description of the [channel/supergroup](https://core.telegram.org/api/channel)
@post_messages If set, allows the admin to post messages in the [channel](https://core.telegram.org/api/channel)
@edit_messages If set, allows the admin to also edit messages from other admins in the [channel](https://core.telegram.org/api/channel)
@delete_messages If set, allows the admin to also delete messages from other admins in the [channel](https://core.telegram.org/api/channel)
@ban_users If set, allows the admin to ban users from the [channel/supergroup](https://core.telegram.org/api/channel)
@invite_users If set, allows the admin to invite users in the [channel/supergroup](https://core.telegram.org/api/channel)
@pin_messages If set, allows the admin to pin messages in the [channel/supergroup](https://core.telegram.org/api/channel)
@add_admins If set, allows the admin to add other admins with the same (or more limited) permissions in the [channel/supergroup](https://core.telegram.org/api/channel)
@anonymous Whether this admin is anonymous
@manage_call If set, allows the admin to change group call/livestream settings
@other Set this flag if none of the other flags are set, but you still want the user to be an admin: if this or any of the other flags are set, the admin can get the chat [admin log](https://core.telegram.org/api/recent-actions), get [chat statistics](https://core.telegram.org/api/stats), get [message statistics in channels](https://core.telegram.org/api/stats), get channel members, see anonymous administrators in supergroups and ignore slow mode.
@manage_topics If set, allows the admin to create, delete or modify [forum topics](https://core.telegram.org/api/forum#forum-topics).
@post_stories If set, allows the admin to post [stories](https://core.telegram.org/api/stories) as the [channel](https://core.telegram.org/api/channel).
@edit_stories If set, allows the admin to edit [stories](https://core.telegram.org/api/stories) posted by the other admins of the [channel](https://core.telegram.org/api/channel).
@delete_stories If set, allows the admin to delete [stories](https://core.telegram.org/api/stories) posted by the other admins of the [channel](https://core.telegram.org/api/channel).
*/
chatAdminRights#5fb224d5 flags:# change_info:flags.0?true post_messages:flags.1?true edit_messages:flags.2?true delete_messages:flags.3?true ban_users:flags.4?true invite_users:flags.5?true pin_messages:flags.7?true add_admins:flags.9?true anonymous:flags.10?true manage_call:flags.11?true other:flags.12?true manage_topics:flags.13?true post_stories:flags.14?true edit_stories:flags.15?true delete_stories:flags.16?true = ChatAdminRights;

/*
Represents the rights of a normal user in a [supergroup/channel/chat](https://core.telegram.org/api/channel). In this case, the flags are inverted: if set, a flag does not allow a user to do X.

@view_messages If set, does not allow a user to view messages in a [supergroup/channel/chat](https://core.telegram.org/api/channel)
@send_messages If set, does not allow a user to send messages in a [supergroup/chat](https://core.telegram.org/api/channel)
@send_media If set, does not allow a user to send any media in a [supergroup/chat](https://core.telegram.org/api/channel)
@send_stickers If set, does not allow a user to send stickers in a [supergroup/chat](https://core.telegram.org/api/channel)
@send_gifs If set, does not allow a user to send gifs in a [supergroup/chat](https://core.telegram.org/api/channel)
@send_games If set, does not allow a user to send games in a [supergroup/chat](https://core.telegram.org/api/channel)
@send_inline If set, does not allow a user to use inline bots in a [supergroup/chat](https://core.telegram.org/api/channel).
@embed_links If set, does not allow a user to embed links in the messages of a [supergroup/chat](https://core.telegram.org/api/channel)
@send_polls If set, does not allow a user to send polls in a [supergroup/chat](https://core.telegram.org/api/channel)
@change_info If set, does not allow any user to change the description of a [supergroup/chat](https://core.telegram.org/api/channel)
@invite_users If set, does not allow any user to invite users in a [supergroup/chat](https://core.telegram.org/api/channel)
@pin_messages If set, does not allow any user to pin messages in a [supergroup/chat](https://core.telegram.org/api/channel)
@manage_topics If set, does not allow any user to create, delete or modify [forum topics](https://core.telegram.org/api/forum#forum-topics).
@send_photos If set, does not allow a user to send photos in a [supergroup/chat](https://core.telegram.org/api/channel).
@send_videos If set, does not allow a user to send videos in a [supergroup/chat](https://core.telegram.org/api/channel).
@send_roundvideos If set, does not allow a user to send round videos in a [supergroup/chat](https://core.telegram.org/api/channel).
@send_audios If set, does not allow a user to send audio files in a [supergroup/chat](https://core.telegram.org/api/channel).
@send_voices If set, does not allow a user to send voice messages in a [supergroup/chat](https://core.telegram.org/api/channel).
@send_docs If set, does not allow a user to send documents in a [supergroup/chat](https://core.telegram.org/api/channel).
@send_plain If set, does not allow a user to send text messages in a [supergroup/chat](https://core.telegram.org/api/channel).
@until_date Validity of said permissions (it is considered forever any value less then 30 seconds or more then 366 days).
*/
chatBannedRights#9f120418 flags:# view_messages:flags.0?true send_messages:flags.1?true send_media:flags.2?true send_stickers:flags.3?true send_gifs:flags.4?true send_games:flags.5?true send_inline:flags.6?true embed_links:flags.7?true send_polls:flags.8?true change_info:flags.10?true invite_users:flags.15?true pin_messages:flags.17?true manage_topics:flags.18?true send_photos:flags.19?true send_videos:flags.20?true send_roundvideos:flags.21?true send_audios:flags.22?true send_voices:flags.23?true send_docs:flags.24?true send_plain:flags.25?true until_date:int = ChatBannedRights;

/*
[Wallpaper](https://core.telegram.org/api/wallpapers)

@id [Wallpaper](https://core.telegram.org/api/wallpapers) ID
@access_hash Access hash
*/
inputWallPaper#e630b979 id:long access_hash:long = InputWallPaper;

/*
[Wallpaper](https://core.telegram.org/api/wallpapers) by slug (a unique ID, obtained from a [wallpaper link](https://core.telegram.org/api/links#wallpaper-links))

@slug Unique wallpaper ID
*/
inputWallPaperSlug#72091c80 slug:string = InputWallPaper;

/*
[Wallpaper](https://core.telegram.org/api/wallpapers) with no file access hash, used for example when deleting ( unsave=true) wallpapers using [account.saveWallPaper](https://core.telegram.org/method/account.saveWallPaper), specifying just the wallpaper ID.

@id Wallpaper ID
*/
inputWallPaperNoFile#967a462e id:long = InputWallPaper;

/*
No new [wallpapers](https://core.telegram.org/api/wallpapers) were found
*/
account.wallPapersNotModified#1c199183 = account.WallPapers;

/*
Installed [wallpapers](https://core.telegram.org/api/wallpapers)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@wallpapers [Wallpapers](https://core.telegram.org/api/wallpapers)
*/
account.wallPapers#cdc3858c hash:long wallpapers:Vector<WallPaper> = account.WallPapers;

/*
Settings used by telegram servers for sending the confirm code.

@allow_flashcall Whether to allow phone verification via [phone calls](https://core.telegram.org/api/auth).
@current_number Pass true if the phone number is used on the current device. Ignored if allow_flashcall is not set.
@allow_app_hash If a token that will be included in eventually sent SMSs is required: required in newer versions of android, to use the [android SMS receiver APIs](https://developers.google.com/identity/sms-retriever/overview)
@allow_missed_call Whether this device supports receiving the code using the [auth.codeTypeMissedCall](https://core.telegram.org/constructor/auth.codeTypeMissedCall) method
@allow_firebase Whether Firebase auth is supported
@unknown_number Set this flag if there is a SIM card in the current device, but it is not possible to check whether the specified phone number matches the SIM's phone number.
@logout_tokens Previously stored future auth tokens, see [the documentation for more info](https://core.telegram.org/api/auth#future-auth-tokens)
@token Used only by official iOS apps for Firebase auth: device token for apple push.
@app_sandbox Used only by official iOS apps for firebase auth: whether a sandbox-certificate will be used during transmission of the push notification.
*/
codeSettings#ad253d78 flags:# allow_flashcall:flags.0?true current_number:flags.1?true allow_app_hash:flags.4?true allow_missed_call:flags.5?true allow_firebase:flags.7?true unknown_number:flags.9?true logout_tokens:flags.6?Vector<bytes> token:flags.8?string app_sandbox:flags.8?Bool = CodeSettings;

/*
[Wallpaper](https://core.telegram.org/api/wallpapers) rendering information.

@blur For [image wallpapers](https://core.telegram.org/api/wallpapers#image-wallpapers): if set, the JPEG must be downscaled to fit in 450x450 square and then box-blurred with radius 12.
@motion If set, the background needs to be slightly moved when the device is rotated.
@background_color Used for [solid](https://core.telegram.org/api/wallpapers#solid-fill), [gradient](https://core.telegram.org/api/wallpapers#gradient-fill) and [freeform gradient](https://core.telegram.org/api/wallpapers#freeform-gradient-fill) fills.
@second_background_color Used for [gradient](https://core.telegram.org/api/wallpapers#gradient-fill) and [freeform gradient](https://core.telegram.org/api/wallpapers#freeform-gradient-fill) fills.
@third_background_color Used for [freeform gradient](https://core.telegram.org/api/wallpapers#freeform-gradient-fill) fills.
@fourth_background_color Used for [freeform gradient](https://core.telegram.org/api/wallpapers#freeform-gradient-fill) fills.
@intensity Used for [pattern wallpapers](https://core.telegram.org/api/wallpapers#pattern-wallpapers).
@rotation Clockwise rotation angle of the gradient, in degrees; 0-359. Should be always divisible by 45.
@emoticon If set, this wallpaper can be used as a channel wallpaper and is represented by the specified UTF-8 emoji.
*/
wallPaperSettings#372efcd0 flags:# blur:flags.1?true motion:flags.2?true background_color:flags.0?int second_background_color:flags.4?int third_background_color:flags.5?int fourth_background_color:flags.6?int intensity:flags.3?int rotation:flags.4?int emoticon:flags.7?string = WallPaperSettings;

/*
Autodownload settings

@disabled Disable automatic media downloads?
@video_preload_large Whether to preload the first seconds of videos larger than the specified limit
@audio_preload_next Whether to preload the next audio track when you're listening to music
@phonecalls_less_data Whether to enable data saving mode in phone calls
@stories_preload Whether to preload [stories](https://core.telegram.org/api/stories); in particular, the first [documentAttributeVideo](https://core.telegram.org/constructor/documentAttributeVideo). preload_prefix_size bytes of story videos should be preloaded.
@photo_size_max Maximum size of photos to preload
@video_size_max Maximum size of videos to preload
@file_size_max Maximum size of other files to preload
@video_upload_maxbitrate Maximum suggested bitrate for uploading videos
@small_queue_active_operations_max A limit, specifying the maximum number of files that should be downloaded in parallel from the same DC, for files smaller than 20MB.
@large_queue_active_operations_max A limit, specifying the maximum number of files that should be downloaded in parallel from the same DC, for files bigger than 20MB.
*/
autoDownloadSettings#baa57628 flags:# disabled:flags.0?true video_preload_large:flags.1?true audio_preload_next:flags.2?true phonecalls_less_data:flags.3?true stories_preload:flags.4?true photo_size_max:int video_size_max:long file_size_max:long video_upload_maxbitrate:int small_queue_active_operations_max:int large_queue_active_operations_max:int = AutoDownloadSettings;

/*
Media autodownload settings

@low Low data usage preset
@medium Medium data usage preset
@high High data usage preset
*/
account.autoDownloadSettings#63cacf26 low:AutoDownloadSettings medium:AutoDownloadSettings high:AutoDownloadSettings = account.AutoDownloadSettings;

/*
Emoji keyword

@keyword Keyword
@emoticons Emojis associated to keyword
*/
emojiKeyword#d5b3b9f9 keyword:string emoticons:Vector<string> = EmojiKeyword;

/*
Deleted emoji keyword

@keyword Keyword
@emoticons Emojis that were associated to keyword
*/
emojiKeywordDeleted#236df622 keyword:string emoticons:Vector<string> = EmojiKeyword;

/*
Changes to emoji keywords

@lang_code Language code for keywords
@from_version Previous emoji keyword list version
@version Current version of emoji keyword list
@keywords Emojis associated to keywords
*/
emojiKeywordsDifference#5cc761bd lang_code:string from_version:int version:int keywords:Vector<EmojiKeyword> = EmojiKeywordsDifference;

/*
An HTTP URL which can be used to automatically log in into translation platform and suggest new emoji replacements. The URL will be valid for 30 seconds after generation

@url An HTTP URL which can be used to automatically log in into translation platform and suggest new emoji replacements. The URL will be valid for 30 seconds after generation
*/
emojiURL#a575739d url:string = EmojiURL;

/*
Emoji language

@lang_code Language code
*/
emojiLanguage#b3fb5361 lang_code:string = EmojiLanguage;

/*
Folder

@autofill_new_broadcasts Automatically add new channels to this folder
@autofill_public_groups Automatically add joined new public supergroups to this folder
@autofill_new_correspondents Automatically add new private chats to this folder
@id Folder ID
@title Folder title
@photo Folder picture
*/
folder#ff544e65 flags:# autofill_new_broadcasts:flags.0?true autofill_public_groups:flags.1?true autofill_new_correspondents:flags.2?true id:int title:string photo:flags.3?ChatPhoto = Folder;

/*
Peer in a folder

@peer Peer
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
*/
inputFolderPeer#fbd2c296 peer:InputPeer folder_id:int = InputFolderPeer;

/*
Peer in a folder

@peer Folder peer info
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
*/
folderPeer#e9baa668 peer:Peer folder_id:int = FolderPeer;

/*
Indicates how many results would be found by a [messages.search](https://core.telegram.org/method/messages.search) call with the same parameters

@inexact If set, the results may be inexact
@filter Provided message filter
@count Number of results that were found server-side
*/
messages.searchCounter#e844ebff flags:# inexact:flags.1?true filter:MessagesFilter count:int = messages.SearchCounter;

/*
Details about the authorization request, for more info [click here](https://core.telegram.org/api/url-authorization)

@request_write_access Whether the bot would like to send messages to the user
@bot Username of a bot, which will be used for user authorization. If not specified, the current bot's username will be assumed. The url's domain must be the same as the domain linked with the bot. See [Linking your domain to the bot](https://core.telegram.org/widgets/login#linking-your-domain-to-the-bot) for more details.
@domain The domain name of the website on which the user will log in.
*/
urlAuthResultRequest#92d33a0e flags:# request_write_access:flags.0?true bot:User domain:string = UrlAuthResult;

/*
Details about an accepted authorization request, for more info [click here](https://core.telegram.org/api/url-authorization)

@url The URL name of the website on which the user has logged in.
*/
urlAuthResultAccepted#8f8c0e4e url:string = UrlAuthResult;

/*
Details about an accepted authorization request, for more info [click here](https://core.telegram.org/api/url-authorization)
*/
urlAuthResultDefault#a9d6db1f = UrlAuthResult;

/*
No location (normal supergroup)
*/
channelLocationEmpty#bfb5ad8b = ChannelLocation;

/*
Geographical location of supergroup (geogroups)

@geo_point Geographical location of supergroup
@address Textual description of the address
*/
channelLocation#209b82db geo_point:GeoPoint address:string = ChannelLocation;

/*
Peer geolocated nearby

@peer Peer
@expires Validity period of current data
@distance Distance from the peer in meters
*/
peerLocated#ca461b5d peer:Peer expires:int distance:int = PeerLocated;

/*
Current peer

@expires Expiry of geolocation info for current peer
*/
peerSelfLocated#f8ec284b expires:int = PeerLocated;

/*
Restriction reason.

@platform Platform identifier (ios, android, wp, all, etc.), can be concatenated with a dash as separator ( android-ios, ios-wp, etc)
@reason Restriction reason ( porno, terms, etc.). Ignore this restriction reason if it is contained in the [ignore_restriction_reasons](https://core.telegram.org/api/config#ignore-restriction-reasons) client configuration parameter.
@text Error message to be shown to the user
*/
restrictionReason#d072acb4 platform:string reason:string text:string = RestrictionReason;

/*
Theme

@id ID
@access_hash Access hash
*/
inputTheme#3c5693e9 id:long access_hash:long = InputTheme;

/*
Theme by theme ID

@slug Unique theme ID obtained from a [theme deep link](https://core.telegram.org/api/links#theme-links)
*/
inputThemeSlug#f5890df1 slug:string = InputTheme;

/*
Theme

@creator Whether the current user is the creator of this theme
@default Whether this is the default theme
@for_chat Whether this theme is meant to be used as a [chat theme](https://telegram.org/blog/chat-themes-interactive-emoji-read-receipts)
@id Theme ID
@access_hash Theme access hash
@slug Unique theme ID
@title Theme name
@document Theme
@settings Theme settings
@emoticon Theme emoji
@installs_count Installation count
*/
theme#a00e67d6 flags:# creator:flags.0?true default:flags.1?true for_chat:flags.5?true id:long access_hash:long slug:string title:string document:flags.2?Document settings:flags.3?Vector<ThemeSettings> emoticon:flags.6?string installs_count:flags.4?int = Theme;

/*
No new themes were installed
*/
account.themesNotModified#f41eb622 = account.Themes;

/*
Installed themes

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@themes Themes
*/
account.themes#9a3d8c6d hash:long themes:Vector<Theme> = account.Themes;

/*
Login token (for [QR code login](https://core.telegram.org/api/qr-login))

@expires Expiration date of QR code
@token Token to render in QR code
*/
auth.loginToken#629f1980 expires:int token:bytes = auth.LoginToken;

/*
Repeat the query to the specified DC

@dc_id DC ID
@token Token to use for login
*/
auth.loginTokenMigrateTo#68e9916 dc_id:int token:bytes = auth.LoginToken;

/*
Login via token (QR code) succeeded!

@authorization Authorization info
*/
auth.loginTokenSuccess#390d5c5e authorization:auth.Authorization = auth.LoginToken;

/*
Sensitive content settings

@sensitive_enabled Whether viewing of sensitive (NSFW) content is enabled
@sensitive_can_change Whether the current client can change the sensitive content settings to view NSFW content
*/
account.contentSettings#57e28221 flags:# sensitive_enabled:flags.0?true sensitive_can_change:flags.1?true = account.ContentSettings;

/*
Inactive chat list

@dates When was the chat last active
@chats Chat list
@users Users mentioned in the chat list
*/
messages.inactiveChats#a927fec5 dates:Vector<int> chats:Vector<Chat> users:Vector<User> = messages.InactiveChats;

/*
Classic theme
*/
baseThemeClassic#c3a12462 = BaseTheme;

/*
Day theme
*/
baseThemeDay#fbd81688 = BaseTheme;

/*
Night theme
*/
baseThemeNight#b7b31ea8 = BaseTheme;

/*
Tinted theme
*/
baseThemeTinted#6d5f77ee = BaseTheme;

/*
Arctic theme
*/
baseThemeArctic#5b11125a = BaseTheme;

/*
Theme settings

@message_colors_animated If set, the freeform gradient fill needs to be animated on every sent message
@base_theme Default theme on which this theme is based
@accent_color Accent color, ARGB format
@outbox_accent_color Accent color of outgoing messages in ARGB format
@message_colors The fill to be used as a background for outgoing messages, in RGB24 format. If just one or two equal colors are provided, describes a solid fill of a background. If two different colors are provided, describes the top and bottom colors of a 0-degree gradient. If three or four colors are provided, describes a freeform gradient fill of a background.
@wallpaper [inputWallPaper](https://core.telegram.org/constructor/inputWallPaper) or [inputWallPaperSlug](https://core.telegram.org/constructor/inputWallPaper) when passing wallpaper files for [image](https://core.telegram.org/api/wallpapers#image-wallpapers) or [pattern](https://core.telegram.org/api/wallpapers#pattern-wallpapers) wallpapers, [inputWallPaperNoFile](https://core.telegram.org/constructor/inputWallPaperNoFile) with id=0 otherwise.
@wallpaper_settings [Wallpaper](https://core.telegram.org/api/wallpapers) settings.
*/
inputThemeSettings#8fde504f flags:# message_colors_animated:flags.2?true base_theme:BaseTheme accent_color:int outbox_accent_color:flags.3?int message_colors:flags.0?Vector<int> wallpaper:flags.1?InputWallPaper wallpaper_settings:flags.1?WallPaperSettings = InputThemeSettings;

/*
Theme settings

@message_colors_animated If set, the freeform gradient fill needs to be animated on every sent message.
@base_theme Base theme
@accent_color Accent color, ARGB format
@outbox_accent_color Accent color of outgoing messages in ARGB format
@message_colors The fill to be used as a background for outgoing messages, in RGB24 format. If just one or two equal colors are provided, describes a solid fill of a background. If two different colors are provided, describes the top and bottom colors of a 0-degree gradient. If three or four colors are provided, describes a freeform gradient fill of a background.
@wallpaper [Wallpaper](https://core.telegram.org/api/wallpapers)
*/
themeSettings#fa58b6d4 flags:# message_colors_animated:flags.2?true base_theme:BaseTheme accent_color:int outbox_accent_color:flags.3?int message_colors:flags.0?Vector<int> wallpaper:flags.1?WallPaper = ThemeSettings;

/*
Page theme

@documents Theme files
@settings Theme settings
*/
webPageAttributeTheme#54b56617 flags:# documents:flags.0?Vector<Document> settings:flags.1?ThemeSettings = WebPageAttribute;

/*
Webpage preview of a Telegram story

@peer Peer that posted the story
@id [Story ID](https://core.telegram.org/api/stories#watching-stories)
@story May contain the story, if not the story should be fetched when and if needed using [stories.getStoriesByID](https://core.telegram.org/method/stories.getStoriesByID) with the above id and peer.
*/
webPageAttributeStory#2e94c3e7 flags:# peer:Peer id:int story:flags.0?StoryItem = WebPageAttribute;

/*
Contains info about a [stickerset](https://core.telegram.org/api/stickers), for a [webPage](https://core.telegram.org/constructor/webPage) preview of a [stickerset deep link](https://core.telegram.org/api/links#stickerset-links) (the [webPage](https://core.telegram.org/constructor/webPage) will have a type of telegram_stickerset).

@emojis Whether this i s a [custom emoji stickerset](https://core.telegram.org/api/custom-emoji).
@text_color Whether the color of this TGS custom emoji stickerset should be changed to the text color when used in messages, the accent color if used as emoji status, white on chat photos, or another appropriate color based on context.
@stickers A subset of the stickerset in the stickerset.
*/
webPageAttributeStickerSet#50cc03d3 flags:# emojis:flags.0?true text_color:flags.1?true stickers:Vector<Document> = WebPageAttribute;

webPageAttributeUniqueStarGift#cf6f6db8 gift:StarGift = WebPageAttribute;
/*
How users voted in a poll

@count Total number of votes for all options (or only for the chosen option, if provided to [messages.getPollVotes](https://core.telegram.org/method/messages.getPollVotes))
@votes Vote info for each user
@chats Mentioned chats
@users Info about users that voted in the poll
@next_offset Offset to use with the next [messages.getPollVotes](https://core.telegram.org/method/messages.getPollVotes) request, empty string if no more results are available.
*/
messages.votesList#4899484e flags:# count:int votes:Vector<MessagePeerVote> chats:Vector<Chat> users:Vector<User> next_offset:flags.0?string = messages.VotesList;

/*
Credit card info URL provided by the bank

@url Info URL
@name Bank name
*/
bankCardOpenUrl#f568028a url:string name:string = BankCardOpenUrl;

/*
Credit card info, provided by the card's bank(s)

@title Credit card title
@open_urls Info URL(s) provided by the card's bank(s)
*/
payments.bankCardData#3e24e573 title:string open_urls:Vector<BankCardOpenUrl> = payments.BankCardData;

/*
Dialog filter AKA [folder](https://core.telegram.org/api/folders)

@contacts Whether to include all contacts in this [folder](https://core.telegram.org/api/folders)
@non_contacts Whether to include all non-contacts in this [folder](https://core.telegram.org/api/folders)
@groups Whether to include all groups in this [folder](https://core.telegram.org/api/folders)
@broadcasts Whether to include all channels in this [folder](https://core.telegram.org/api/folders)
@bots Whether to include all bots in this [folder](https://core.telegram.org/api/folders)
@exclude_muted Whether to exclude muted chats from this [folder](https://core.telegram.org/api/folders)
@exclude_read Whether to exclude read chats from this [folder](https://core.telegram.org/api/folders)
@exclude_archived Whether to exclude archived chats from this [folder](https://core.telegram.org/api/folders)
@title_noanimate  ... 
@id [Folder](https://core.telegram.org/api/folders) ID
@title [Folder](https://core.telegram.org/api/folders) name (max 12 UTF-8 chars)
@emoticon Emoji to use as icon for the folder.
@color A color ID for the [folder tag associated to this folder, see here](https://core.telegram.org/api/folders#folder-tags) for more info.
@pinned_peers Pinned chats, [folders](https://core.telegram.org/api/folders) can have unlimited pinned chats
@include_peers Include the following chats in this [folder](https://core.telegram.org/api/folders)
@exclude_peers Exclude the following chats from this [folder](https://core.telegram.org/api/folders)

#DocError
*/
dialogFilter#aa472651 flags:# contacts:flags.0?true non_contacts:flags.1?true groups:flags.2?true broadcasts:flags.3?true bots:flags.4?true exclude_muted:flags.11?true exclude_read:flags.12?true exclude_archived:flags.13?true title_noanimate:flags.28?true id:int title:TextWithEntities emoticon:flags.25?string color:flags.27?int pinned_peers:Vector<InputPeer> include_peers:Vector<InputPeer> exclude_peers:Vector<InputPeer> = DialogFilter;

/*
Used only when reordering folders to indicate the default (all chats) folder.
*/
dialogFilterDefault#363293ae = DialogFilter;

/*
A folder imported using a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@has_my_invites Whether the current user has created some [chat folder deep links](https://core.telegram.org/api/links#chat-folder-links) to share the folder as well.
@title_noanimate  ... 
@id ID of the folder
@title Name of the folder (max 12 UTF-8 chars)
@emoticon Emoji to use as icon for the folder.
@color A color ID for the [folder tag associated to this folder, see here](https://core.telegram.org/api/folders#folder-tags) for more info.
@pinned_peers Pinned chats, [folders](https://core.telegram.org/api/folders) can have unlimited pinned chats
@include_peers Chats to include in the folder

#DocError
*/
dialogFilterChatlist#96537bd7 flags:# has_my_invites:flags.26?true title_noanimate:flags.28?true id:int title:TextWithEntities emoticon:flags.25?string color:flags.27?int pinned_peers:Vector<InputPeer> include_peers:Vector<InputPeer> = DialogFilter;

/*
Suggested [folders](https://core.telegram.org/api/folders)

@filter [Folder info](https://core.telegram.org/api/folders)
@description [Folder](https://core.telegram.org/api/folders) description
*/
dialogFilterSuggested#77744d4a filter:DialogFilter description:string = DialogFilterSuggested;

/*
[Channel statistics](https://core.telegram.org/api/stats) date range

@min_date Initial date
@max_date Final date
*/
statsDateRangeDays#b637edaf min_date:int max_date:int = StatsDateRangeDays;

/*
Statistics value couple; initial and final value for period of time currently in consideration

@current Current value
@previous Previous value
*/
statsAbsValueAndPrev#cb43acde current:double previous:double = StatsAbsValueAndPrev;

/*
[Channel statistics percentage](https://core.telegram.org/api/stats). 
Compute the percentage simply by doing part * total / 100

@part Partial value
@total Total value
*/
statsPercentValue#cbce2fe0 part:double total:double = StatsPercentValue;

/*
This [channel statistics graph](https://core.telegram.org/api/stats) must be generated asynchronously using [stats.loadAsyncGraph](https://core.telegram.org/method/stats.loadAsyncGraph) to reduce server load

@token Token to use for fetching the async graph
*/
statsGraphAsync#4a27eb2d token:string = StatsGraph;

/*
An error occurred while generating the [statistics graph](https://core.telegram.org/api/stats)

@error The error
*/
statsGraphError#bedc9822 error:string = StatsGraph;

/*
[Channel statistics graph](https://core.telegram.org/api/stats)

@json Statistics data
@zoom_token Zoom token
*/
statsGraph#8ea464b6 flags:# json:DataJSON zoom_token:flags.0?string = StatsGraph;

/*
[Channel statistics](https://core.telegram.org/api/stats).

@period Period in consideration
@followers Follower count change for period in consideration
@views_per_post total_viewcount/postcount, for posts posted during the period in consideration. Note that in this case, current refers to the period in consideration ( min_date till max_date), and prev refers to the previous period ( (min_date - (max_date - min_date)) till min_date).
@shares_per_post total_sharecount/postcount, for posts posted during the period in consideration. Note that in this case, current refers to the period in consideration ( min_date till max_date), and prev refers to the previous period ( (min_date - (max_date - min_date)) till min_date)
@reactions_per_post total_reactions/postcount, for posts posted during the period in consideration. Note that in this case, current refers to the period in consideration ( min_date till max_date), and prev refers to the previous period ( (min_date - (max_date - min_date)) till min_date)
@views_per_story total_views/storycount, for posts posted during the period in consideration. Note that in this case, current refers to the period in consideration ( min_date till max_date), and prev refers to the previous period ( (min_date - (max_date - min_date)) till min_date)
@shares_per_story total_shares/storycount, for posts posted during the period in consideration. Note that in this case, current refers to the period in consideration ( min_date till max_date), and prev refers to the previous period ( (min_date - (max_date - min_date)) till min_date)
@reactions_per_story total_reactions/storycount, for posts posted during the period in consideration. Note that in this case, current refers to the period in consideration ( min_date till max_date), and prev refers to the previous period ( (min_date - (max_date - min_date)) till min_date)
@enabled_notifications Percentage of subscribers with enabled notifications
@growth_graph Channel growth graph (absolute subscriber count)
@followers_graph Followers growth graph (relative subscriber count)
@mute_graph Muted users graph (relative)
@top_hours_graph Views per hour graph (absolute)
@interactions_graph Interactions graph (absolute)
@iv_interactions_graph IV interactions graph (absolute)
@views_by_source_graph Views by source graph (absolute)
@new_followers_by_source_graph New followers by source graph (absolute)
@languages_graph Subscriber language graph (pie chart)
@reactions_by_emotion_graph A graph containing the number of reactions on posts categorized by emotion
@story_interactions_graph A graph containing the number of story views and shares
@story_reactions_by_emotion_graph A graph containing the number of reactions on stories categorized by emotion
@recent_posts_interactions Detailed statistics about number of views and shares of recently sent messages and stories
*/
stats.broadcastStats#396ca5fc period:StatsDateRangeDays followers:StatsAbsValueAndPrev views_per_post:StatsAbsValueAndPrev shares_per_post:StatsAbsValueAndPrev reactions_per_post:StatsAbsValueAndPrev views_per_story:StatsAbsValueAndPrev shares_per_story:StatsAbsValueAndPrev reactions_per_story:StatsAbsValueAndPrev enabled_notifications:StatsPercentValue growth_graph:StatsGraph followers_graph:StatsGraph mute_graph:StatsGraph top_hours_graph:StatsGraph interactions_graph:StatsGraph iv_interactions_graph:StatsGraph views_by_source_graph:StatsGraph new_followers_by_source_graph:StatsGraph languages_graph:StatsGraph reactions_by_emotion_graph:StatsGraph story_interactions_graph:StatsGraph story_reactions_by_emotion_graph:StatsGraph recent_posts_interactions:Vector<PostInteractionCounters> = stats.BroadcastStats;

/*
No PSA/MTProxy info is available

@expires Re-fetch PSA/MTProxy info after the specified number of seconds
*/
help.promoDataEmpty#98f6ac75 expires:int = help.PromoData;

/*
MTProxy/Public Service Announcement information

@proxy MTProxy-related channel
@expires Expiry of PSA/MTProxy info
@peer MTProxy/PSA peer
@chats Chat info
@users User info
@psa_type PSA type
@psa_message PSA message
*/
help.promoData#8c39793f flags:# proxy:flags.0?true expires:int peer:Peer chats:Vector<Chat> users:Vector<User> psa_type:flags.1?string psa_message:flags.2?string = help.PromoData;

/*
An [animated profile picture](https://core.telegram.org/api/files#animated-profile-pictures) in MPEG4 format

@type u for animated profile pictures, and v for trimmed and downscaled video previews
@w Video width
@h Video height
@size File size
@video_start_ts Timestamp that should be shown as static preview to the user (seconds)
*/
videoSize#de33b094 flags:# type:string w:int h:int size:int video_start_ts:flags.0?double = VideoSize;

/*
An [animated profile picture](https://core.telegram.org/api/files#animated-profile-pictures) based on a [custom emoji sticker](https://core.telegram.org/api/custom-emoji).

@emoji_id [Custom emoji ID](https://core.telegram.org/api/custom-emoji): the custom emoji sticker is shown at the center of the profile picture and occupies at most 67% of it.
@background_colors 1, 2, 3 or 4 RBG-24 colors used to generate a solid (1), gradient (2) or freeform gradient (3, 4) background, similar to how [fill wallpapers](https://core.telegram.org/api/wallpapers#fill-types) are generated. The rotation angle for gradient backgrounds is 0.
*/
videoSizeEmojiMarkup#f85c413c emoji_id:long background_colors:Vector<int> = VideoSize;

/*
An [animated profile picture](https://core.telegram.org/api/files#animated-profile-pictures) based on a [sticker](https://core.telegram.org/api/stickers).

@stickerset Stickerset
@sticker_id Sticker ID
@background_colors 1, 2, 3 or 4 RBG-24 colors used to generate a solid (1), gradient (2) or freeform gradient (3, 4) background, similar to how [fill wallpapers](https://core.telegram.org/api/wallpapers#fill-types) are generated. The rotation angle for gradient backgrounds is 0.
*/
videoSizeStickerMarkup#da082fe stickerset:InputStickerSet sticker_id:long background_colors:Vector<int> = VideoSize;

/*
Information about an active user in a supergroup

@user_id User ID
@messages Number of messages for [statistics](https://core.telegram.org/api/stats) period in consideration
@avg_chars Average number of characters per message
*/
statsGroupTopPoster#9d04af9b user_id:long messages:int avg_chars:int = StatsGroupTopPoster;

/*
Information about an active admin in a supergroup

@user_id User ID
@deleted Number of deleted messages for [statistics](https://core.telegram.org/api/stats) period in consideration
@kicked Number of kicked users for [statistics](https://core.telegram.org/api/stats) period in consideration
@banned Number of banned users for [statistics](https://core.telegram.org/api/stats) period in consideration
*/
statsGroupTopAdmin#d7584c87 user_id:long deleted:int kicked:int banned:int = StatsGroupTopAdmin;

/*
Information about an active supergroup inviter

@user_id User ID
@invitations Number of invitations for [statistics](https://core.telegram.org/api/stats) period in consideration
*/
statsGroupTopInviter#535f779d user_id:long invitations:int = StatsGroupTopInviter;

/*
Supergroup [statistics](https://core.telegram.org/api/stats)

@period Period in consideration
@members Member count change for period in consideration
@messages Message number change for period in consideration
@viewers Number of users that viewed messages, for range in consideration
@posters Number of users that posted messages, for range in consideration
@growth_graph Supergroup growth graph (absolute subscriber count)
@members_graph Members growth (relative subscriber count)
@new_members_by_source_graph New members by source graph
@languages_graph Subscriber language graph (pie chart)
@messages_graph Message activity graph (stacked bar graph, message type)
@actions_graph Group activity graph (deleted, modified messages, blocked users)
@top_hours_graph Activity per hour graph (absolute)
@weekdays_graph Activity per day of week graph (absolute)
@top_posters Info about most active group members
@top_admins Info about most active group admins
@top_inviters Info about most active group inviters
@users Info about users mentioned in statistics
*/
stats.megagroupStats#ef7ff916 period:StatsDateRangeDays members:StatsAbsValueAndPrev messages:StatsAbsValueAndPrev viewers:StatsAbsValueAndPrev posters:StatsAbsValueAndPrev growth_graph:StatsGraph members_graph:StatsGraph new_members_by_source_graph:StatsGraph languages_graph:StatsGraph messages_graph:StatsGraph actions_graph:StatsGraph top_hours_graph:StatsGraph weekdays_graph:StatsGraph top_posters:Vector<StatsGroupTopPoster> top_admins:Vector<StatsGroupTopAdmin> top_inviters:Vector<StatsGroupTopInviter> users:Vector<User> = stats.MegagroupStats;

/*
Global privacy settings

@archive_and_mute_new_noncontact_peers Whether to archive and mute new chats from non-contacts
@keep_archived_unmuted Whether unmuted chats will be kept in the Archive chat list when they get a new message.
@keep_archived_folders Whether unmuted chats that are always included or pinned in a [folder](https://core.telegram.org/api/folders), will be kept in the Archive chat list when they get a new message. Ignored if keep_archived_unmuted is set.
@hide_read_marks If this flag is set, the [inputPrivacyKeyStatusTimestamp](https://core.telegram.org/constructor/inputPrivacyKeyStatusTimestamp) key will also apply to the ability to use [messages.getOutboxReadDate](https://core.telegram.org/method/messages.getOutboxReadDate) on messages sent to us. Meaning, users that cannot see our exact last online date due to the current value of the [inputPrivacyKeyStatusTimestamp](https://core.telegram.org/constructor/inputPrivacyKeyStatusTimestamp) key will receive a 403 USER_PRIVACY_RESTRICTED error when invoking [messages.getOutboxReadDate](https://core.telegram.org/method/messages.getOutboxReadDate) to fetch the exact read date of a message they sent to us. The [userFull](https://core.telegram.org/constructor/userFull). read_dates_private flag will be set for users that have this flag enabled.
@new_noncontact_peers_require_premium If set, only users that have a premium account, are in our contact list, or already have a private chat with us can write to us; a 403 PRIVACY_PREMIUM_REQUIRED error will be emitted otherwise.  The [userFull](https://core.telegram.org/constructor/userFull). contact_require_premium flag will be set for users that have this flag enabled.  To check whether we can write to a user with this flag enabled, if we haven't yet cached all the required information (for example we don't have the [userFull](https://core.telegram.org/constructor/userFull) or history of all users while displaying the chat list in the sharing UI) the [users.getIsPremiumRequiredToContact](https://core.telegram.org/method/users.getIsPremiumRequiredToContact) method may be invoked, passing the list of users currently visible in the UI, returning a list of booleans that directly specify whether we can or cannot write to each user. This option may be enabled by both non- [Premium](https://core.telegram.org/api/premium) and [Premium](https://core.telegram.org/api/premium) users only if the [new_noncontact_peers_require_premium_without_ownpremium client configuration flag](https://core.telegram.org/api/config#new-noncontact-peers-require-premium-without-ownpremium) is equal to true, otherwise it may be enabled only by [Premium](https://core.telegram.org/api/premium) users and non-Premium users will receive a PREMIUM_ACCOUNT_REQUIRED error when trying to enable this flag.
*/
globalPrivacySettings#734c4ccb flags:# archive_and_mute_new_noncontact_peers:flags.0?true keep_archived_unmuted:flags.1?true keep_archived_folders:flags.2?true hide_read_marks:flags.3?true new_noncontact_peers_require_premium:flags.4?true = GlobalPrivacySettings;

/*
Country code and phone number pattern of a specific country

@country_code ISO country code
@prefixes Possible phone prefixes
@patterns Phone patterns: for example, XXX XXX XXX
*/
help.countryCode#4203c5ef flags:# country_code:string prefixes:flags.0?Vector<string> patterns:flags.1?Vector<string> = help.CountryCode;

/*
Name, ISO code, localized name and phone codes/patterns of a specific country

@hidden Whether this country should not be shown in the list
@iso2 ISO code of country
@default_name Name of the country in the country's language
@name Name of the country in the user's language, if different from the original name
@country_codes Phone codes/patterns
*/
help.country#c3878e23 flags:# hidden:flags.0?true iso2:string default_name:string name:flags.1?string country_codes:Vector<help.CountryCode> = help.Country;

/*
The country list has not changed
*/
help.countriesListNotModified#93cc1f32 = help.CountriesList;

/*
Name, ISO code, localized name and phone codes/patterns of all available countries

@countries Name, ISO code, localized name and phone codes/patterns of all available countries
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
*/
help.countriesList#87d0759e countries:Vector<help.Country> hash:int = help.CountriesList;

/*
View, forward counter + info about replies of a specific message

@views View count of message
@forwards Forward count of message
@replies Reply and [thread](https://core.telegram.org/api/threads) information of message
*/
messageViews#455b853d flags:# views:flags.0?int forwards:flags.1?int replies:flags.2?MessageReplies = MessageViews;

/*
View, forward counter + info about replies

@views View, forward counter + info about replies
@chats Chats mentioned in constructor
@users Users mentioned in constructor
*/
messages.messageViews#b6c4f543 views:Vector<MessageViews> chats:Vector<Chat> users:Vector<User> = messages.MessageViews;

/*
Information about a [message thread](https://core.telegram.org/api/threads)

@messages The messages from which the thread starts. The messages are returned in reverse chronological order (i.e., in order of decreasing message ID).
@max_id Message ID of latest reply in this [thread](https://core.telegram.org/api/threads)
@read_inbox_max_id Message ID of latest read incoming message in this [thread](https://core.telegram.org/api/threads)
@read_outbox_max_id Message ID of latest read outgoing message in this [thread](https://core.telegram.org/api/threads)
@unread_count Number of unread messages
@chats Chats mentioned in constructor
@users Users mentioned in constructor
*/
messages.discussionMessage#a6341782 flags:# messages:Vector<Message> max_id:flags.0?int read_inbox_max_id:flags.1?int read_outbox_max_id:flags.2?int unread_count:int chats:Vector<Chat> users:Vector<User> = messages.DiscussionMessage;

/*
Message replies and [thread](https://core.telegram.org/api/threads) information

@reply_to_scheduled This is a reply to a scheduled message.
@forum_topic Whether this message was sent in a [forum topic](https://core.telegram.org/api/forum#forum-topics) (except for the General topic).
@quote Whether this message is quoting a part of another message.
@reply_to_msg_id ID of message to which this message is replying
@reply_to_peer_id For replies sent in [channel discussion threads](https://core.telegram.org/api/threads) of which the current user is not a member, the discussion group ID
@reply_from When replying to a message sent by a certain peer to another chat, contains info about the peer that originally sent the message to that other chat.
@reply_media When replying to a media sent by a certain peer to another chat, contains the media of the replied-to message.
@reply_to_top_id ID of the message that started this [message thread](https://core.telegram.org/api/threads)
@quote_text Used to quote-reply to only a certain section (specified here) of the original message.
@quote_entities [Message entities for styled text](https://core.telegram.org/api/entities) from the quote_text field.
@quote_offset Offset of the message quote_text within the original message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length)).
*/
messageReplyHeader#afbc09db flags:# reply_to_scheduled:flags.2?true forum_topic:flags.3?true quote:flags.9?true reply_to_msg_id:flags.4?int reply_to_peer_id:flags.0?Peer reply_from:flags.5?MessageFwdHeader reply_media:flags.8?MessageMedia reply_to_top_id:flags.1?int quote_text:flags.6?string quote_entities:flags.7?Vector<MessageEntity> quote_offset:flags.10?int = MessageReplyHeader;

/*
Represents a reply to a [story](https://core.telegram.org/api/stories)

@peer Sender of the story.
@story_id Story ID
*/
messageReplyStoryHeader#e5af939 peer:Peer story_id:int = MessageReplyHeader;

/*
Info about [the comment section of a channel post, or a simple message thread](https://core.telegram.org/api/threads)

@comments Whether this constructor contains information about the [comment section of a channel post, or a simple message thread](https://core.telegram.org/api/threads)
@replies Contains the total number of replies in this thread or comment section.
@replies_pts [PTS](https://core.telegram.org/api/updates) of the message that started this thread.
@recent_repliers For channel post comments, contains information about the last few comment posters for a specific thread, to show a small list of commenter profile pictures in client previews.
@channel_id For channel post comments, contains the ID of the associated [discussion supergroup](https://core.telegram.org/api/discussion)
@max_id ID of the latest message in this thread or comment section.
@read_max_id Contains the ID of the latest read message in this thread or comment section.
*/
messageReplies#83d60fc2 flags:# comments:flags.0?true replies:int replies_pts:int recent_repliers:flags.1?Vector<Peer> channel_id:flags.0?long max_id:flags.2?int read_max_id:flags.3?int = MessageReplies;

/*
Information about a blocked peer

@peer_id Peer ID
@date When was the peer blocked
*/
peerBlocked#e8fd8014 peer_id:Peer date:int = PeerBlocked;

/*
Message statistics

@views_graph Message view graph
@reactions_by_emotion_graph A graph containing the number of reactions on stories categorized by emotion
*/
stats.messageStats#7fe91c14 views_graph:StatsGraph reactions_by_emotion_graph:StatsGraph = stats.MessageStats;

/*
An ended group call

@id Group call ID
@access_hash Group call access hash
@duration Group call duration
*/
groupCallDiscarded#7780bcb4 id:long access_hash:long duration:int = GroupCall;

/*
Info about a group call or livestream

@join_muted Whether the user should be muted upon joining the call
@can_change_join_muted Whether the current user can change the value of the join_muted flag using [phone.toggleGroupCallSettings](https://core.telegram.org/method/phone.toggleGroupCallSettings)
@join_date_asc Specifies the ordering to use when locally sorting by date and displaying in the UI group call participants.
@schedule_start_subscribed Whether we subscribed to the scheduled call
@can_start_video Whether you can start streaming video into the call
@record_video_active Whether the group call is currently being recorded
@rtmp_stream Whether RTMP streams are allowed
@listeners_hidden Whether the listeners list is hidden and cannot be fetched using [phone.getGroupParticipants](https://core.telegram.org/method/phone.getGroupParticipants). The phone.groupParticipants.count and groupCall.participants_count counters will still include listeners.
@id Group call ID
@access_hash Group call access hash
@participants_count Participant count
@title Group call title
@stream_dc_id DC ID to be used for livestream chunks
@record_start_date When was the recording started
@schedule_date When is the call scheduled to start
@unmuted_video_count Number of people currently streaming video into the call
@unmuted_video_limit Maximum number of people allowed to stream video into the call
@version Version
@conference_from_call  ... 

#DocError
*/
groupCall#cdf8d3e3 flags:# join_muted:flags.1?true can_change_join_muted:flags.2?true join_date_asc:flags.6?true schedule_start_subscribed:flags.8?true can_start_video:flags.9?true record_video_active:flags.11?true rtmp_stream:flags.12?true listeners_hidden:flags.13?true id:long access_hash:long participants_count:int title:flags.3?string stream_dc_id:flags.4?int record_start_date:flags.5?int schedule_date:flags.7?int unmuted_video_count:flags.10?int unmuted_video_limit:int version:int conference_from_call:flags.14?long = GroupCall;

/*
Points to a specific group call

@id Group call ID
@access_hash Group call access hash
*/
inputGroupCall#d8aa840f id:long access_hash:long = InputGroupCall;

/*
Info about a group call participant

@muted Whether the participant is muted
@left Whether the participant has left
@can_self_unmute Whether the participant can unmute themselves
@just_joined Whether the participant has just joined
@versioned If set, and [updateGroupCallParticipants](https://core.telegram.org/constructor/updateGroupCallParticipants).version < locally stored call.version, info about this participant should be ignored. If (...), and [updateGroupCallParticipants](https://core.telegram.org/constructor/updateGroupCallParticipants).version > call.version+1, the participant list should be refetched using [phone.getGroupParticipants](https://core.telegram.org/method/phone.getGroupParticipants).
@min If not set, the volume and muted_by_you fields can be safely used to overwrite locally cached information; otherwise, volume will contain valid information only if volume_by_admin is set both in the cache and in the received constructor.
@muted_by_you Whether this participant was muted by the current user
@volume_by_admin Whether our volume can only changed by an admin
@self Whether this participant is the current user
@video_joined Whether this participant is currently broadcasting video
@peer Peer information
@date When did this participant join the group call
@active_date When was this participant last active in the group call
@source Source ID
@volume Volume, if not set the volume is set to 100%.
@about Info about this participant
@raise_hand_rating Specifies the UI visualization order of peers with raised hands: peers with a higher rating should be showed first in the list.
@video Info about the video stream the participant is currently broadcasting
@presentation Info about the screen sharing stream the participant is currently broadcasting
*/
groupCallParticipant#eba636fe flags:# muted:flags.0?true left:flags.1?true can_self_unmute:flags.2?true just_joined:flags.4?true versioned:flags.5?true min:flags.8?true muted_by_you:flags.9?true volume_by_admin:flags.10?true self:flags.12?true video_joined:flags.15?true peer:Peer date:int active_date:flags.3?int source:int volume:flags.7?int about:flags.11?string raise_hand_rating:flags.13?long video:flags.6?GroupCallParticipantVideo presentation:flags.14?GroupCallParticipantVideo = GroupCallParticipant;

/*
Contains info about a group call, and partial info about its participants.

@call Info about the group call
@participants A partial list of participants.
@participants_next_offset Next offset to use when fetching the remaining participants using [phone.getGroupParticipants](https://core.telegram.org/method/phone.getGroupParticipants)
@chats Chats mentioned in the participants vector
@users Users mentioned in the participants vector
*/
phone.groupCall#9e727aad call:GroupCall participants:Vector<GroupCallParticipant> participants_next_offset:string chats:Vector<Chat> users:Vector<User> = phone.GroupCall;

/*
Info about the participants of a group call or livestream

@count Number of participants
@participants List of participants
@next_offset If not empty, the specified list of participants is partial, and more participants can be fetched specifying this parameter as offset in [phone.getGroupParticipants](https://core.telegram.org/method/phone.getGroupParticipants).
@chats Mentioned chats
@users Mentioned users
@version Version info
*/
phone.groupParticipants#f47751b6 count:int participants:Vector<GroupCallParticipant> next_offset:string chats:Vector<Chat> users:Vector<User> version:int = phone.GroupParticipants;

/*
Peer type: private chat with the bot itself
*/
inlineQueryPeerTypeSameBotPM#3081ed9d = InlineQueryPeerType;

/*
Peer type: private chat
*/
inlineQueryPeerTypePM#833c0fac = InlineQueryPeerType;

/*
Peer type: [chat](https://core.telegram.org/api/channel)
*/
inlineQueryPeerTypeChat#d766c50a = InlineQueryPeerType;

/*
Peer type: [supergroup](https://core.telegram.org/api/channel)
*/
inlineQueryPeerTypeMegagroup#5ec4be43 = InlineQueryPeerType;

/*
Peer type: [channel](https://core.telegram.org/api/channel)
*/
inlineQueryPeerTypeBroadcast#6334ee9a = InlineQueryPeerType;

/*
Peer type: private chat with a bot.
*/
inlineQueryPeerTypeBotPM#e3b2d0c = InlineQueryPeerType;

/*
ID of a specific [chat import session, click here for more info](https://core.telegram.org/api/import).

@id [History import ID](https://core.telegram.org/api/import)
*/
messages.historyImport#1662af0b id:long = messages.HistoryImport;

/*
Contains information about a chat export file [generated by a foreign chat app, click here for more info](https://core.telegram.org/api/import). 
If neither the pm or group flags are set, the specified chat export was generated from a chat of unknown type.

@pm The chat export file was generated from a private chat.
@group The chat export file was generated from a group chat.
@title Title of the chat.
*/
messages.historyImportParsed#5e0fb7b9 flags:# pm:flags.0?true group:flags.1?true title:flags.2?string = messages.HistoryImportParsed;

/*
Messages found and affected by changes

@pts [Event count after generation](https://core.telegram.org/api/updates)
@pts_count [Number of events that were generated](https://core.telegram.org/api/updates)
@offset If bigger than zero, the request must be repeated to remove more messages
@messages Affected message IDs
*/
messages.affectedFoundMessages#ef8d3e6c pts:int pts_count:int offset:int messages:Vector<int> = messages.AffectedFoundMessages;

/*
When and which user joined the chat using a chat invite

@requested Whether this user currently has a pending [join request](https://core.telegram.org/api/invites#join-requests)
@via_chatlist The participant joined by importing a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).
@user_id The user
@date When did the user join
@about For users with pending requests, contains bio of the user that requested to join
@approved_by The administrator that approved the [join request](https://core.telegram.org/api/invites#join-requests) of the user
*/
chatInviteImporter#8c5adfd9 flags:# requested:flags.0?true via_chatlist:flags.3?true user_id:long date:int about:flags.2?string approved_by:flags.1?long = ChatInviteImporter;

/*
Info about chat invites exported by a certain admin.

@count Number of invites exported by the admin
@invites Exported invites
@users Info about the admin
*/
messages.exportedChatInvites#bdc62dcc count:int invites:Vector<ExportedChatInvite> users:Vector<User> = messages.ExportedChatInvites;

/*
Info about a chat invite

@invite Info about the chat invite
@users Mentioned users
*/
messages.exportedChatInvite#1871be50 invite:ExportedChatInvite users:Vector<User> = messages.ExportedChatInvite;

/*
The specified chat invite was replaced with another one

@invite The replaced chat invite
@new_invite The invite that replaces the previous invite
@users Mentioned users
*/
messages.exportedChatInviteReplaced#222600ef invite:ExportedChatInvite new_invite:ExportedChatInvite users:Vector<User> = messages.ExportedChatInvite;

/*
Info about the users that joined the chat using a specific chat invite

@count Number of users that joined
@importers The users that joined
@users The users that joined
*/
messages.chatInviteImporters#81b6b00a count:int importers:Vector<ChatInviteImporter> users:Vector<User> = messages.ChatInviteImporters;

/*
Info about chat invites generated by admins.

@admin_id The admin
@invites_count Number of invites generated by the admin
@revoked_invites_count Number of revoked invites
*/
chatAdminWithInvites#f2ecef23 admin_id:long invites_count:int revoked_invites_count:int = ChatAdminWithInvites;

/*
Info about chat invites generated by admins.

@admins Info about chat invites generated by admins.
@users Mentioned users
*/
messages.chatAdminsWithInvites#b69b72d7 admins:Vector<ChatAdminWithInvites> users:Vector<User> = messages.ChatAdminsWithInvites;

/*
Contains a confirmation text to be shown to the user, upon [importing chat history, click here for more info](https://core.telegram.org/api/import).

@confirm_text A confirmation text to be shown to the user, upon [importing chat history](https://core.telegram.org/api/import).
*/
messages.checkedHistoryImportPeer#a24de717 confirm_text:string = messages.CheckedHistoryImportPeer;

/*
A list of peers that can be used to join a group call, presenting yourself as a specific user/channel.

@peers Peers
@chats Chats mentioned in the peers vector
@users Users mentioned in the peers vector
*/
phone.joinAsPeers#afe5623f peers:Vector<Peer> chats:Vector<Chat> users:Vector<User> = phone.JoinAsPeers;

/*
An invite to a group call or livestream

@link Invite link
*/
phone.exportedGroupCallInvite#204bd158 link:string = phone.ExportedGroupCallInvite;

/*
Describes a group of video synchronization source identifiers

@semantics SDP semantics
@sources Source IDs
*/
groupCallParticipantVideoSourceGroup#dcb118b7 semantics:string sources:Vector<int> = GroupCallParticipantVideoSourceGroup;

/*
Info about a video stream

@paused Whether the stream is currently paused
@endpoint Endpoint
@source_groups Source groups
@audio_source Audio source ID
*/
groupCallParticipantVideo#67753ac8 flags:# paused:flags.0?true endpoint:string source_groups:Vector<GroupCallParticipantVideoSourceGroup> audio_source:flags.1?int = GroupCallParticipantVideo;

/*
A suggested short name for a stickerpack

@short_name Suggested short name
*/
stickers.suggestedShortName#85fea03f short_name:string = stickers.SuggestedShortName;

/*
The commands will be valid in all dialogs
*/
botCommandScopeDefault#2f6cb2ab = BotCommandScope;

/*
The specified bot commands will only be valid in all private chats with users.
*/
botCommandScopeUsers#3c4f04d8 = BotCommandScope;

/*
The specified bot commands will be valid in all [groups and supergroups](https://core.telegram.org/api/channel).
*/
botCommandScopeChats#6fe1a881 = BotCommandScope;

/*
The specified bot commands will be valid only for chat administrators, in all [groups and supergroups](https://core.telegram.org/api/channel).
*/
botCommandScopeChatAdmins#b9aa606a = BotCommandScope;

/*
The specified bot commands will be valid only in a specific dialog.

@peer The dialog
*/
botCommandScopePeer#db9d897d peer:InputPeer = BotCommandScope;

/*
The specified bot commands will be valid for all admins of the specified [group or supergroup](https://core.telegram.org/api/channel).

@peer The chat
*/
botCommandScopePeerAdmins#3fd863d1 peer:InputPeer = BotCommandScope;

/*
The specified bot commands will be valid only for a specific user in the specified [group or supergroup](https://core.telegram.org/api/channel).

@peer The chat
@user_id The user
*/
botCommandScopePeerUser#a1321f3 peer:InputPeer user_id:InputUser = BotCommandScope;

/*
You recently requested a password reset that was canceled, please wait until the specified date before requesting another reset.

@retry_date Wait until this date before requesting another reset.
*/
account.resetPasswordFailedWait#e3779861 retry_date:int = account.ResetPasswordResult;

/*
You successfully requested a password reset, please wait until the specified date before finalizing the reset.

@until_date Wait until this date before finalizing the reset.
*/
account.resetPasswordRequestedWait#e9effc7d until_date:int = account.ResetPasswordResult;

/*
The 2FA password was reset successfully.
*/
account.resetPasswordOk#e926d63e = account.ResetPasswordResult;

/*
A [sponsored message](https://core.telegram.org/api/sponsored-messages).

@recommended Whether the message needs to be labeled as "recommended" instead of "sponsored"
@can_report Whether this message can be [reported as specified here](https://core.telegram.org/api/sponsored-messages#reporting-sponsored-messages).
@random_id Message ID
@url Contains the URL to open when the user clicks on the sponsored message.
@title Contains the title of the sponsored message.
@message Sponsored message
@entities [Message entities for styled text](https://core.telegram.org/api/entities) in message.
@photo If set, contains a custom profile photo bubble that should be displayed for the sponsored message, like for messages sent in groups.
@media If set, contains some media.
@color If set, the sponsored message should use the [message accent color](https://core.telegram.org/api/colors) specified in color.
@button_text Label of the sponsored message button.
@sponsor_info If set, contains additional information about the sponsor to be shown along with the message.
@additional_info If set, contains additional information about the sponsored message to be shown along with the message.
*/
sponsoredMessage#4d93a990 flags:# recommended:flags.5?true can_report:flags.12?true random_id:bytes url:string title:string message:string entities:flags.1?Vector<MessageEntity> photo:flags.6?Photo media:flags.14?MessageMedia color:flags.13?PeerColor button_text:string sponsor_info:flags.7?string additional_info:flags.8?string = SponsoredMessage;

/*
A set of sponsored messages associated to a channel

@posts_between If set, specifies the minimum number of messages between shown sponsored messages; otherwise, only one sponsored message must be shown after all ordinary messages.
@messages Sponsored messages
@chats Chats mentioned in the sponsored messages
@users Users mentioned in the sponsored messages
*/
messages.sponsoredMessages#c9ee1d87 flags:# posts_between:flags.0?int messages:Vector<SponsoredMessage> chats:Vector<Chat> users:Vector<User> = messages.SponsoredMessages;

/*
No sponsored messages are available.
*/
messages.sponsoredMessagesEmpty#1839490f = messages.SponsoredMessages;

/*
Information about found messages sent on a specific day, used to split the messages in [messages.searchResultsCalendar](https://core.telegram.org/constructor/messages.searchResultsCalendar) constructors by days.

@date The day this object is referring to.
@min_msg_id First message ID that was sent on this day.
@max_msg_id Last message ID that was sent on this day.
@count All messages that were sent on this day.
*/
searchResultsCalendarPeriod#c9b0539f date:int min_msg_id:int max_msg_id:int count:int = SearchResultsCalendarPeriod;

/*
Information about found messages sent on a specific day

@inexact If set, indicates that the results may be inexact
@count Total number of results matching query
@min_date Starting timestamp of attached messages
@min_msg_id Ending timestamp of attached messages
@offset_id_offset Indicates the absolute position of messages[0] within the total result set with count count. This is useful, for example, if we need to display a progress/total counter (like photo 134 of 200, for all media in a chat, we could simply use photo ${offset_id_offset} of ${count}.
@periods Used to split the messages by days: multiple [SearchResultsCalendarPeriod](https://core.telegram.org/type/SearchResultsCalendarPeriod) constructors are returned, each containing information about the first, last and total number of messages matching the filter that were sent on a specific day.  This information can be easily used to split the returned messages by day.
@messages Messages
@chats Mentioned chats
@users Mentioned users
*/
messages.searchResultsCalendar#147ee23c flags:# inexact:flags.0?true count:int min_date:int min_msg_id:int offset_id_offset:flags.1?int periods:Vector<SearchResultsCalendarPeriod> messages:Vector<Message> chats:Vector<Chat> users:Vector<User> = messages.SearchResultsCalendar;

/*
Information about a message in a specific position

@msg_id Message ID
@date When was the message sent
@offset 0-based message position in the full list of suitable messages
*/
searchResultPosition#7f648b67 msg_id:int date:int offset:int = SearchResultsPosition;

/*
Information about sparse positions of messages

@count Total number of found messages
@positions List of message positions
*/
messages.searchResultsPositions#53b22baf count:int positions:Vector<SearchResultsPosition> = messages.SearchResultsPositions;

/*
A list of peers that can be used to send messages in a specific group

@peers Peers that can be used to send messages to the group
@chats Mentioned chats
@users Mentioned users
*/
channels.sendAsPeers#f496b0c6 peers:Vector<SendAsPeer> chats:Vector<Chat> users:Vector<User> = channels.SendAsPeers;

/*
Full user information

@full_user Full user information
@chats Mentioned chats
@users Mentioned users
*/
users.userFull#3b6d152e full_user:UserFull chats:Vector<Chat> users:Vector<User> = users.UserFull;

/*
Peer settings

@settings Peer settings
@chats Mentioned chats
@users Mentioned users
*/
messages.peerSettings#6880b94d settings:PeerSettings chats:Vector<Chat> users:Vector<User> = messages.PeerSettings;

/*
[Future auth token](https://core.telegram.org/api/auth#future-auth-tokens) to be used on subsequent authorizations

@future_auth_token [Future auth token](https://core.telegram.org/api/auth#future-auth-tokens) to be used on subsequent authorizations
*/
auth.loggedOut#c3a2835f flags:# future_auth_token:flags.0?bytes = auth.LoggedOut;

/*
Reactions

@chosen_order If set, indicates that the current user also sent this reaction. The integer value indicates when was the reaction added: the bigger the value, the newer the reaction.
@reaction The reaction.
@count Number of users that reacted with this emoji.
*/
reactionCount#a3d1cb80 flags:# chosen_order:flags.0?int reaction:Reaction count:int = ReactionCount;

/*
[Message reactions](https://core.telegram.org/api/reactions)

@min Similar to [min](https://core.telegram.org/api/min) objects, used for [message reaction](https://core.telegram.org/api/reactions) constructors that are the same for all users so they don't have the reactions sent by the current user (you can use [messages.getMessagesReactions](https://core.telegram.org/method/messages.getMessagesReactions) to get the full reaction info).
@can_see_list Whether [messages.getMessageReactionsList](https://core.telegram.org/method/messages.getMessageReactionsList) can be used to see how each specific peer reacted to the message
@reactions_as_tags If set or if there are no reactions, all present and future reactions should be treated as [message tags, see here  for more info](https://core.telegram.org/api/saved-messages#tags).
@results Reactions
@recent_reactions List of recent peers and their reactions
@top_reactors [Paid Telegram Star reactions leaderboard](https://core.telegram.org/api/reactions#paid-reactions) for this message.
*/
messageReactions#a339f0b flags:# min:flags.0?true can_see_list:flags.2?true reactions_as_tags:flags.3?true results:Vector<ReactionCount> recent_reactions:flags.1?Vector<MessagePeerReaction> top_reactors:flags.4?Vector<MessageReactor> = MessageReactions;

/*
List of peers that reacted to a specific message

@count Total number of reactions matching query
@reactions List of peers that reacted to a specific message
@chats Mentioned chats
@users Mentioned users
@next_offset If set, indicates the next offset to use to load more results by invoking [messages.getMessageReactionsList](https://core.telegram.org/method/messages.getMessageReactionsList).
*/
messages.messageReactionsList#31bd492d flags:# count:int reactions:Vector<MessagePeerReaction> chats:Vector<Chat> users:Vector<User> next_offset:flags.0?string = messages.MessageReactionsList;

/*
Animations associated with a message reaction

@inactive If not set, the reaction can be added to new messages and enabled in chats.
@premium Whether this reaction can only be used by Telegram Premium users
@reaction Reaction emoji
@title Reaction description
@static_icon Static icon for the reaction
@appear_animation The animated sticker to show when the user opens the reaction dropdown
@select_animation The animated sticker to show when the user hovers over the reaction
@activate_animation The animated sticker to show when the reaction is chosen and activated
@effect_animation The background effect (still an animated sticker) to play under the activate_animation, when the reaction is chosen and activated
@around_animation The animation that plays around the button when you press an existing reaction (played together with center_icon).
@center_icon The animation of the emoji inside the button when you press an existing reaction (played together with around_animation).
*/
availableReaction#c077ec01 flags:# inactive:flags.0?true premium:flags.2?true reaction:string title:string static_icon:Document appear_animation:Document select_animation:Document activate_animation:Document effect_animation:Document around_animation:flags.1?Document center_icon:flags.1?Document = AvailableReaction;

/*
No new reactions are available
*/
messages.availableReactionsNotModified#9f071957 = messages.AvailableReactions;

/*
Animations and metadata associated with [message reactions](https://core.telegram.org/api/reactions)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@reactions Animations and metadata associated with [message reactions](https://core.telegram.org/api/reactions)
*/
messages.availableReactions#768e3aad hash:int reactions:Vector<AvailableReaction> = messages.AvailableReactions;

/*
How a certain peer reacted to the message

@big Whether the specified [message reaction](https://core.telegram.org/api/reactions) should elicit a bigger and longer reaction
@unread Whether the reaction wasn't yet marked as read by the current user
@my Starting from layer 159, [messages.sendReaction](https://core.telegram.org/method/messages.sendReaction) will send reactions from the peer (user or channel) specified using [messages.saveDefaultSendAs](https://core.telegram.org/method/messages.saveDefaultSendAs). If set, this flag indicates that this reaction was sent by us, even if the peer doesn't point to the current account.
@peer_id Peer that reacted to the message
@date When was this reaction added
@reaction Reaction emoji
*/
messagePeerReaction#8c79b63c flags:# big:flags.0?true unread:flags.1?true my:flags.2?true peer_id:Peer date:int reaction:Reaction = MessagePeerReaction;

/*
Info about an RTMP stream in a group call or livestream

@channel Channel ID
@scale Specifies the duration of the video segment to fetch in milliseconds, by bitshifting 1000 to the right scale times: duration_ms := 1000 >> scale.
@last_timestamp_ms Last seen timestamp to easily start fetching livestream chunks using [inputGroupCallStream](https://core.telegram.org/constructor/inputGroupCallStream)
*/
groupCallStreamChannel#80eb48af channel:int scale:int last_timestamp_ms:long = GroupCallStreamChannel;

/*
Info about RTMP streams in a group call or livestream

@channels RTMP streams
*/
phone.groupCallStreamChannels#d0e482b2 channels:Vector<GroupCallStreamChannel> = phone.GroupCallStreamChannels;

/*
RTMP URL and stream key to be used in streaming software

@url RTMP URL
@key Stream key
*/
phone.groupCallStreamRtmpUrl#2dbf3432 url:string key:string = phone.GroupCallStreamRtmpUrl;

/*
Represents an attachment menu icon color for [bot mini apps](https://core.telegram.org/api/bots/attach)

@name One of the following values: light_icon - Color of the attachment menu icon (light mode) light_text - Color of the attachment menu label, once selected (light mode) dark_icon - Color of the attachment menu icon (dark mode) dark_text - Color of the attachment menu label, once selected (dark mode)
@color Color in RGB24 format
*/
attachMenuBotIconColor#4576f3f0 name:string color:int = AttachMenuBotIconColor;

/*
Represents an attachment menu icon for [bot mini apps](https://core.telegram.org/api/bots/attach)

@name One of the following values: note that animated icons must be played when the user clicks on the button, activating the bot mini app. default_static - Default attachment menu icon in SVG format placeholder_static - Default placeholder for opened Web Apps in SVG format ios_static - Attachment menu icon in SVG format for the official iOS app ios_animated - Animated attachment menu icon in TGS format for the official iOS app android_animated - Animated attachment menu icon in TGS format for the official Android app macos_animated - Animated attachment menu icon in TGS format for the official native Mac OS app ios_side_menu_static - Side menu icon in PNG format for the official iOS app android_side_menu_static - Side menu icon in SVG format for the official android app macos_side_menu_static - Side menu icon in PNG format for the official native Mac OS app
@icon The actual icon file.
@colors Attachment menu icon colors.
*/
attachMenuBotIcon#b2a7386b flags:# name:string icon:Document colors:flags.0?Vector<AttachMenuBotIconColor> = AttachMenuBotIcon;

/*
Represents a [bot mini app that can be launched from the attachment/side menu](https://core.telegram.org/api/bots/attach)

@inactive If set, before launching the mini app the client should ask the user to add the mini app to the attachment/side menu, and only if the user accepts, after invoking [messages.toggleBotInAttachMenu](https://core.telegram.org/method/messages.toggleBotInAttachMenu) the app should be opened.
@has_settings Deprecated flag, can be ignored.
@request_write_access Whether the bot would like to send messages to the user.
@show_in_attach_menu Whether, when installed, an attachment menu entry should be shown for the Mini App.
@show_in_side_menu Whether, when installed, an entry in the main view side menu should be shown for the Mini App.
@side_menu_disclaimer_needed If inactive if set and the user hasn't previously accepted the third-party mini apps [Terms of Service](https://telegram.org/tos/mini-apps) for this bot, when showing the mini app installation prompt, an additional mandatory checkbox to accept the [mini apps TOS](https://telegram.org/tos/mini-apps) and a disclaimer indicating that this Mini App is not affiliated to Telegram should be shown.
@bot_id Bot ID
@short_name Attachment menu item name
@peer_types List of dialog types where this attachment menu entry should be shown
@icons List of platform-specific static icons and animations to use for the attachment menu button
*/
attachMenuBot#d90d8dfe flags:# inactive:flags.0?true has_settings:flags.1?true request_write_access:flags.2?true show_in_attach_menu:flags.3?true show_in_side_menu:flags.4?true side_menu_disclaimer_needed:flags.5?true bot_id:long short_name:string peer_types:flags.3?Vector<AttachMenuPeerType> icons:Vector<AttachMenuBotIcon> = AttachMenuBot;

/*
The list of bot mini apps hasn't changed
*/
attachMenuBotsNotModified#f1d88a5c = AttachMenuBots;

/*
Represents a list of [bot mini apps that can be launched from the attachment menu](https://core.telegram.org/api/bots/attach)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@bots List of [bot mini apps that can be launched from the attachment menu](https://core.telegram.org/api/bots/attach)
@users Info about related users/bots
*/
attachMenuBots#3c4301c0 hash:long bots:Vector<AttachMenuBot> users:Vector<User> = AttachMenuBots;

/*
Represents a [bot mini app that can be launched from the attachment menu](https://core.telegram.org/api/bots/attach)

@bot Represents a [bot mini app that can be launched from the attachment menu](https://core.telegram.org/api/bots/attach)
@users Info about related users and bots
*/
attachMenuBotsBot#93bf667f bot:AttachMenuBot users:Vector<User> = AttachMenuBotsBot;

/*
Contains the webview URL with appropriate theme and user info parameters added

@fullsize If set, the app must be opened in fullsize mode instead of compact mode.
@fullscreen If set, the app must be opened in fullscreen
@query_id Webview session ID (only returned by [inline button mini apps](https://core.telegram.org/api/bots/webapps#inline-button-mini-apps), [menu button mini apps](https://core.telegram.org/api/bots/webapps#menu-button-mini-apps), [attachment menu mini apps](https://core.telegram.org/api/bots/webapps#attachment-menu-mini-apps)).
@url Webview URL to open
*/
webViewResultUrl#4d22ff98 flags:# fullsize:flags.1?true fullscreen:flags.2?true query_id:flags.0?long url:string = WebViewResult;

/*
Info about a sent inline webview message

@msg_id Message ID
*/
webViewMessageSent#c94511c flags:# msg_id:flags.0?InputBotInlineMessageID = WebViewMessageSent;

/*
Placeholder [bot menu button](https://core.telegram.org/api/bots/menu) never returned to users: see [the docs for more info](https://core.telegram.org/api/bots/menu).
*/
botMenuButtonDefault#7533a588 = BotMenuButton;

/*
[Bot menu button](https://core.telegram.org/api/bots/menu) that opens the bot command list when clicked.
*/
botMenuButtonCommands#4258c205 = BotMenuButton;

/*
[Bot menu button](https://core.telegram.org/api/bots/menu) that opens a [web app](https://core.telegram.org/api/bots/webapps) when clicked.

@text Title to be displayed on the menu button instead of 'Menu'
@url URL of a [web app](https://core.telegram.org/api/bots/webapps) to open when the user clicks on the button
*/
botMenuButton#c7b57ce6 text:string url:string = BotMenuButton;

/*
The notification sound list hasn't changed.
*/
account.savedRingtonesNotModified#fbf6e8b1 = account.SavedRingtones;

/*
A list of saved notification sounds

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@ringtones Saved notification sounds
*/
account.savedRingtones#c1e92cc5 hash:long ringtones:Vector<Document> = account.SavedRingtones;

/*
Indicates the default notification sound should be used
*/
notificationSoundDefault#97e8bebe = NotificationSound;

/*
No notification sound should be used
*/
notificationSoundNone#6f0c34df = NotificationSound;

/*
Indicates a specific local notification sound should be used

@title Notification sound title
@data Notification sound identifier (arbitrary data used by the client to identify a specific local notification sound)
*/
notificationSoundLocal#830b9ae4 title:string data:string = NotificationSound;

/*
A specific previously uploaded notification sound should be used

@id Document ID of notification sound uploaded using [account.uploadRingtone](https://core.telegram.org/method/account.uploadRingtone)
*/
notificationSoundRingtone#ff6c8049 id:long = NotificationSound;

/*
The notification sound was already in MP3 format and was saved without any modification
*/
account.savedRingtone#b7263f6d = account.SavedRingtone;

/*
The notification sound was not in MP3 format and was successfully converted and saved, use the returned [Document](https://core.telegram.org/type/Document) to refer to the notification sound from now on

@document The converted notification sound
*/
account.savedRingtoneConverted#1f307eb7 document:Document = account.SavedRingtone;

/*
The bot attachment menu entry is available in the chat with the bot that offers it
*/
attachMenuPeerTypeSameBotPM#7d6be90e = AttachMenuPeerType;

/*
The bot attachment menu entry is available in private chats with other bots (excluding the bot that offers the current attachment menu)
*/
attachMenuPeerTypeBotPM#c32bfa1a = AttachMenuPeerType;

/*
The bot attachment menu entry is available in private chats with other users (not bots)
*/
attachMenuPeerTypePM#f146d31f = AttachMenuPeerType;

/*
The bot attachment menu entry is available in [groups and supergroups](https://core.telegram.org/api/channel)
*/
attachMenuPeerTypeChat#509113f = AttachMenuPeerType;

/*
The bot attachment menu entry is available in channels
*/
attachMenuPeerTypeBroadcast#7bfbdefc = AttachMenuPeerType;

/*
An invoice contained in a [messageMediaInvoice](https://core.telegram.org/constructor/messageMediaInvoice) message or [paid media](https://core.telegram.org/api/paid-media).

@peer Chat where the invoice/paid media was sent
@msg_id Message ID
*/
inputInvoiceMessage#c5b56859 peer:InputPeer msg_id:int = InputInvoice;

/*
An invoice slug taken from an [invoice deep link](https://core.telegram.org/api/links#invoice-links) or from the [premium_invoice_slug app config parameter](https://core.telegram.org/api/config#premium-invoice-slug)

@slug The invoice slug
*/
inputInvoiceSlug#c326caef slug:string = InputInvoice;

/*
Used if the user wishes to start a channel/supergroup [giveaway](https://core.telegram.org/api/giveaways) or send some [giftcodes](https://core.telegram.org/api/giveaways) to members of a channel/supergroup, in exchange for [boosts](https://core.telegram.org/api/boost).

@purpose Should be populated with [inputStorePaymentPremiumGiveaway](https://core.telegram.org/constructor/inputStorePaymentPremiumGiveaway) for [giveaways](https://core.telegram.org/api/giveaways) and [inputStorePaymentPremiumGiftCode](https://core.telegram.org/constructor/inputStorePaymentPremiumGiftCode) for [gifts](https://core.telegram.org/api/giveaways).
@option Should be populated with one of the giveaway options returned by [payments.getPremiumGiftCodeOptions](https://core.telegram.org/method/payments.getPremiumGiftCodeOptions), see the [giveaways](https://core.telegram.org/api/giveaways) documentation for more info.
*/
inputInvoicePremiumGiftCode#98986c0d purpose:InputStorePaymentPurpose option:PremiumGiftCodeOption = InputInvoice;

/*
Used to top up the [Telegram Stars](https://core.telegram.org/api/stars) balance of the current account or someone else's account, or to start a [Telegram Star giveaway](https://core.telegram.org/api/giveaways#star-giveaways).

@purpose An [inputStorePaymentStarsGiveaway](https://core.telegram.org/constructor/inputStorePaymentStarsGiveaway), [inputStorePaymentStarsTopup](https://core.telegram.org/constructor/inputStorePaymentStarsTopup) or [inputStorePaymentStarsGift](https://core.telegram.org/constructor/inputStorePaymentStarsGift).
*/
inputInvoiceStars#65f00ce3 purpose:InputStorePaymentPurpose = InputInvoice;

/*
Used to pay for a [Telegram Star subscription](https://core.telegram.org/api/stars#star-subscriptions).

@hash The [invitation link of the Telegram Star subscription](https://core.telegram.org/api/stars#star-subscriptions)
*/
inputInvoiceChatInviteSubscription#34e793f1 hash:string = InputInvoice;

/*
Used to buy a [Telegram Star Gift, see here](https://core.telegram.org/api/gifts) for more info.

@hide_name If set, your name will be hidden if the destination user decides to display the gift on their profile (they will still see that you sent the gift)
@include_upgrade  ... 
@peer  ... 
@gift_id Identifier of the gift, from [starGift](https://core.telegram.org/constructor/starGift). id
@message Optional message, attached with the gift. The maximum length for this field is specified in the [stargifts_message_length_max client configuration value](https://core.telegram.org/api/config#stargifts-message-length-max).

#DocError
*/
inputInvoiceStarGift#e8625e92 flags:# hide_name:flags.0?true include_upgrade:flags.2?true peer:InputPeer gift_id:long message:flags.1?TextWithEntities = InputInvoice;

inputInvoiceStarGiftUpgrade#4d818d5d flags:# keep_original_details:flags.0?true stargift:InputSavedStarGift = InputInvoice;
inputInvoiceStarGiftTransfer#4a5f5bd9 stargift:InputSavedStarGift to_id:InputPeer = InputInvoice;
/*
Exported [invoice deep link](https://core.telegram.org/api/links#invoice-links)

@url Exported [invoice deep link](https://core.telegram.org/api/links#invoice-links)
*/
payments.exportedInvoice#aed0cbd9 url:string = payments.ExportedInvoice;

/*
[Transcribed text from a voice message](https://core.telegram.org/api/transcribe)

@pending Whether the transcription is partial because audio transcription is still in progress, if set the user may receive further [updateTranscribedAudio](https://core.telegram.org/constructor/updateTranscribedAudio) updates with the updated transcription.
@transcription_id Transcription ID
@text Transcripted text
@trial_remains_num For non- [Premium](https://core.telegram.org/api/premium) users, this flag will be set, indicating the remaining transcriptions in the free trial period.
@trial_remains_until_date For non- [Premium](https://core.telegram.org/api/premium) users, this flag will be set, indicating the date when the trial_remains_num counter will be reset to the maximum value of [transcribe_audio_trial_weekly_number](https://core.telegram.org/api/config#transcribe-audio-trial-weekly-number).
*/
messages.transcribedAudio#cfb9d957 flags:# pending:flags.0?true transcription_id:long text:string trial_remains_num:flags.1?int trial_remains_until_date:flags.1?int = messages.TranscribedAudio;

/*
Telegram Premium promotion information

@status_text Description of the current state of the user's Telegram Premium subscription
@status_entities [Message entities for styled text](https://core.telegram.org/api/entities)
@video_sections A list of [premium feature identifiers](https://core.telegram.org/api/premium), associated to each video
@videos A list of videos
@period_options Telegram Premium subscription options
@users Related user information
*/
help.premiumPromo#5334759c status_text:string status_entities:Vector<MessageEntity> video_sections:Vector<string> videos:Vector<Document> period_options:Vector<PremiumSubscriptionOption> users:Vector<User> = help.PremiumPromo;

/*
Info about a Telegram Premium purchase

@restore Pass true if this is a restore of a Telegram Premium purchase; only for the App Store
@upgrade Pass true if this is an upgrade from a monthly subscription to a yearly subscription; only for App Store
*/
inputStorePaymentPremiumSubscription#a6751e66 flags:# restore:flags.0?true upgrade:flags.1?true = InputStorePaymentPurpose;

/*
Info about a gifted Telegram Premium purchase

@user_id The user to which the Telegram Premium subscription was gifted
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Price of the product in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
*/
inputStorePaymentGiftPremium#616f7fe8 user_id:InputUser currency:string amount:long = InputStorePaymentPurpose;

/*
Used to gift [Telegram Premium](https://core.telegram.org/api/premium) subscriptions only to some specific subscribers of a channel/supergroup or to some of our contacts, see [here](https://core.telegram.org/api/giveaways) for more info on giveaways and gifts.

@users The users that will receive the [Telegram Premium](https://core.telegram.org/api/premium) subscriptions.
@boost_peer If set, the gifts will be sent on behalf of a channel/supergroup we are an admin of, which will also assign some [boosts](https://core.telegram.org/api/boost) to it. Otherwise, the gift will be sent directly from the currently logged in user, and we will gain some extra [boost slots](https://core.telegram.org/api/boost). See [here](https://core.telegram.org/api/giveaways) for more info on giveaways and gifts.
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@message Message attached with the gift
*/
inputStorePaymentPremiumGiftCode#fb790393 flags:# users:Vector<InputUser> boost_peer:flags.0?InputPeer currency:string amount:long message:flags.1?TextWithEntities = InputStorePaymentPurpose;

/*
Used to pay for a [giveaway, see here](https://core.telegram.org/api/giveaways) for more info.

@only_new_subscribers If set, only new subscribers starting from the giveaway creation date will be able to participate to the giveaway.
@winners_are_visible If set, giveaway winners are public and will be listed in a [messageMediaGiveawayResults](https://core.telegram.org/constructor/messageMediaGiveawayResults) message that will be automatically sent to the channel once the giveaway ends.
@boost_peer The channel/supergroup starting the giveaway, that the user must join to participate, that will receive the giveaway [boosts](https://core.telegram.org/api/boost); see [here](https://core.telegram.org/api/giveaways) for more info on giveaways.
@additional_peers Additional channels that the user must join to participate to the giveaway can be specified here.
@countries_iso2 The set of users that can participate to the giveaway can be restricted by passing here an explicit whitelist of up to [giveaway_countries_max](https://core.telegram.org/api/config#giveaway-countries-max) countries, specified as two-letter ISO 3166-1 alpha-2 country codes.
@prize_description Can contain a textual description of additional giveaway prizes.
@random_id Random ID to avoid resending the giveaway
@until_date The end date of the giveaway, must be at most [giveaway_period_max](https://core.telegram.org/api/config#giveaway-period-max) seconds in the future; see [here](https://core.telegram.org/api/giveaways) for more info on giveaways.
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
*/
inputStorePaymentPremiumGiveaway#160544ca flags:# only_new_subscribers:flags.0?true winners_are_visible:flags.3?true boost_peer:InputPeer additional_peers:flags.1?Vector<InputPeer> countries_iso2:flags.2?Vector<string> prize_description:flags.4?string random_id:long until_date:int currency:string amount:long = InputStorePaymentPurpose;

/*
Used to top up the [Telegram Stars balance](https://core.telegram.org/api/stars) of the current account.

@stars Amount of stars to topup
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
*/
inputStorePaymentStarsTopup#dddd0f56 stars:long currency:string amount:long = InputStorePaymentPurpose;

/*
Used to gift [Telegram Stars](https://core.telegram.org/api/stars) to a friend.

@user_id The user to which the stars should be gifted.
@stars Amount of stars to gift
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
*/
inputStorePaymentStarsGift#1d741ef7 user_id:InputUser stars:long currency:string amount:long = InputStorePaymentPurpose;

/*
Used to pay for a [star giveaway, see here](https://core.telegram.org/api/giveaways#star-giveaways) for more info.

@only_new_subscribers If set, only new subscribers starting from the giveaway creation date will be able to participate to the giveaway.
@winners_are_visible If set, giveaway winners are public and will be listed in a [messageMediaGiveawayResults](https://core.telegram.org/constructor/messageMediaGiveawayResults) message that will be automatically sent to the channel once the giveaway ends.
@stars Total number of Telegram Stars being given away (each user will receive stars/users stars).
@boost_peer The channel/supergroup starting the giveaway, that the user must join to participate, that will receive the giveaway [boosts](https://core.telegram.org/api/boost); see [here](https://core.telegram.org/api/giveaways) for more info on giveaways.
@additional_peers Additional channels that the user must join to participate to the giveaway can be specified here.
@countries_iso2 The set of users that can participate to the giveaway can be restricted by passing here an explicit whitelist of up to [giveaway_countries_max](https://core.telegram.org/api/config#giveaway-countries-max) countries, specified as two-letter ISO 3166-1 alpha-2 country codes.
@prize_description Can contain a textual description of additional giveaway prizes.
@random_id Random ID to avoid resending the giveaway
@until_date The end date of the giveaway, must be at most [giveaway_period_max](https://core.telegram.org/api/config#giveaway-period-max) seconds in the future; see [here](https://core.telegram.org/api/giveaways) for more info on giveaways.
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@users Number of winners.
*/
inputStorePaymentStarsGiveaway#751f08fa flags:# only_new_subscribers:flags.0?true winners_are_visible:flags.3?true stars:long boost_peer:InputPeer additional_peers:flags.1?Vector<InputPeer> countries_iso2:flags.2?Vector<string> prize_description:flags.4?string random_id:long until_date:int currency:string amount:long users:int = InputStorePaymentPurpose;

/*
Telegram Premium gift option

@months Duration of gifted Telegram Premium subscription
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Price of the product in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@bot_url An [invoice deep link](https://core.telegram.org/api/links#invoice-links) to an invoice for in-app payment, using the official Premium bot; may be empty if direct payment isn't available.
@store_product An identifier for the App Store/Play Store product associated with the Premium gift.
*/
premiumGiftOption#74c34319 flags:# months:int currency:string amount:long bot_url:string store_product:flags.0?string = PremiumGiftOption;

/*
Represents an additional payment method

@url URL to open in a webview to process the payment
@title Payment method description
*/
paymentFormMethod#88f8f21b url:string title:string = PaymentFormMethod;

/*
No emoji status is set
*/
emojiStatusEmpty#2de11aae = EmojiStatus;

/*
An [emoji status](https://core.telegram.org/api/emoji-status)

@document_id [Custom emoji document ID](https://core.telegram.org/api/custom-emoji)
@until  ... 

#DocError
*/
emojiStatus#e7ff068a flags:# document_id:long until:flags.0?int = EmojiStatus;

emojiStatusCollectible#7184603b flags:# collectible_id:long document_id:long title:string slug:string pattern_document_id:long center_color:int edge_color:int pattern_color:int text_color:int until:flags.0?int = EmojiStatus;
inputEmojiStatusCollectible#7141dbf flags:# collectible_id:long until:flags.0?int = EmojiStatus;
/*
The server-side list of [emoji statuses](https://core.telegram.org/api/emoji-status) hasn't changed
*/
account.emojiStatusesNotModified#d08ce645 = account.EmojiStatuses;

/*
A list of [emoji statuses](https://core.telegram.org/api/emoji-status)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@statuses [Emoji statuses](https://core.telegram.org/api/emoji-status)
*/
account.emojiStatuses#90c467d1 hash:long statuses:Vector<EmojiStatus> = account.EmojiStatuses;

/*
No reaction
*/
reactionEmpty#79f5d419 = Reaction;

/*
Normal emoji message reaction

@emoticon Emoji
*/
reactionEmoji#1b2286b8 emoticon:string = Reaction;

/*
[Custom emoji](https://core.telegram.org/api/custom-emoji) message reaction

@document_id [Custom emoji document ID](https://core.telegram.org/api/custom-emoji)
*/
reactionCustomEmoji#8935fc73 document_id:long = Reaction;

/*
Represents a [paid Telegram Star reaction](https://core.telegram.org/api/reactions#paid-reactions).
*/
reactionPaid#523da4eb = Reaction;

/*
No reactions are allowed
*/
chatReactionsNone#eafc32bc = ChatReactions;

/*
All reactions or all non-custom reactions are allowed

@allow_custom Whether to allow custom reactions
*/
chatReactionsAll#52928bca flags:# allow_custom:flags.0?true = ChatReactions;

/*
Some reactions are allowed

@reactions Allowed set of reactions: the [reactions_in_chat_max](https://core.telegram.org/api/config#reactions-in-chat-max) configuration field indicates the maximum number of reactions that can be specified in this field.
*/
chatReactionsSome#661d4037 reactions:Vector<Reaction> = ChatReactions;

/*
The server-side list of [message reactions](https://core.telegram.org/api/reactions) hasn't changed
*/
messages.reactionsNotModified#b06fdbdf = messages.Reactions;

/*
List of [message reactions](https://core.telegram.org/api/reactions)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@reactions Reactions
*/
messages.reactions#eafdf716 hash:long reactions:Vector<Reaction> = messages.Reactions;

/*
Email verification purpose: setup login email

@phone_number Phone number
@phone_code_hash Phone code hash as specified by the [documentation](https://core.telegram.org/api/auth#email-verification)
*/
emailVerifyPurposeLoginSetup#4345be73 phone_number:string phone_code_hash:string = EmailVerifyPurpose;

/*
Email verification purpose: change login email
*/
emailVerifyPurposeLoginChange#527d22eb = EmailVerifyPurpose;

/*
Verify an email for use in [telegram passport](https://core.telegram.org/api/passport)
*/
emailVerifyPurposePassport#bbf51685 = EmailVerifyPurpose;

/*
Email verification code

@code Received verification code
*/
emailVerificationCode#922e55a9 code:string = EmailVerification;

/*
Google ID email verification token

@token Token
*/
emailVerificationGoogle#db909ec2 token:string = EmailVerification;

/*
Apple ID email verification token

@token Token
*/
emailVerificationApple#96d074fd token:string = EmailVerification;

/*
The email was verified correctly.

@email The verified email address.
*/
account.emailVerified#2b96cd1b email:string = account.EmailVerified;

/*
The email was verified correctly, and a login code was just sent to it.

@email The verified email address.
@sent_code Info about the sent [login code](https://core.telegram.org/api/auth)
*/
account.emailVerifiedLogin#e1bb0d61 email:string sent_code:auth.SentCode = account.EmailVerified;

/*
Describes a Telegram Premium subscription option

@current Whether this subscription option is currently in use.
@can_purchase_upgrade Whether this subscription option can be used to upgrade the existing Telegram Premium subscription. When upgrading Telegram Premium subscriptions bought through stores, make sure that the store transaction ID is equal to transaction, to avoid upgrading someone else's account, if the client is currently logged into multiple accounts.
@transaction Identifier of the last in-store transaction for the currently used subscription on the current account.
@months Duration of subscription in months
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@bot_url [Deep link](https://core.telegram.org/api/links) used to initiate payment
@store_product Store product ID, only for official apps
*/
premiumSubscriptionOption#5f2d1df2 flags:# current:flags.1?true can_purchase_upgrade:flags.2?true transaction:flags.3?string months:int currency:string amount:long bot_url:string store_product:flags.0?string = PremiumSubscriptionOption;

/*
Indicates a peer that can be used to send messages

@premium_required Whether a Telegram Premium account is required to send messages as this peer
@peer Peer
*/
sendAsPeer#b81c7034 flags:# premium_required:flags.0?true peer:Peer = SendAsPeer;

/*
Paid media preview for not yet purchased paid media, [see here](https://core.telegram.org/api/paid-media) for more info.

@w Width
@h Height
@thumb [Extremely low resolution thumbnail](https://core.telegram.org/api/files#stripped-thumbnails).
@video_duration Video duration for videos.
*/
messageExtendedMediaPreview#ad628cc8 flags:# w:flags.0?int h:flags.0?int thumb:flags.1?PhotoSize video_duration:flags.2?int = MessageExtendedMedia;

/*
Already purchased paid media, [see here](https://core.telegram.org/api/paid-media) for more info.

@media The media we purchased.
*/
messageExtendedMedia#ee479c64 media:MessageMedia = MessageExtendedMedia;

/*
Keywords for a certain sticker

@document_id Sticker ID
@keyword Keywords
*/
stickerKeyword#fcfeb29c document_id:long keyword:Vector<string> = StickerKeyword;

/*
Contains information about a username.

@editable Whether the username is editable, meaning it wasn't bought on [fragment](https://fragment.com).
@active Whether the username is active.
@username The username.
*/
username#b4073647 flags:# editable:flags.0?true active:flags.1?true username:string = Username;

/*
Represents a deleted forum topic.

@id The ID of the deleted forum topic.
*/
forumTopicDeleted#23f109b id:int = ForumTopic;

/*
Represents a [forum topic](https://core.telegram.org/api/forum#forum-topics).

@my Whether the topic was created by the current user
@closed Whether the topic is closed (no messages can be sent to it)
@pinned Whether the topic is pinned
@short Whether this constructor is a reduced version of the full topic information. If set, only the my, closed, id, date, title, icon_color, icon_emoji_id and from_id parameters will contain valid information. Reduced info is usually only returned in topic-related [admin log events](https://core.telegram.org/api/recent-actions) and in the [messages.channelMessages](https://core.telegram.org/constructor/messages.channelMessages) constructor: if needed, full information can be fetched using [channels.getForumTopicsByID](https://core.telegram.org/method/channels.getForumTopicsByID).
@hidden Whether the topic is hidden (only valid for the "General" topic, id=1)
@id [Topic ID](https://core.telegram.org/api/forum#forum-topics)
@date Topic creation date
@title Topic title
@icon_color If no custom emoji icon is specified, specifies the color of the fallback topic icon (RGB), one of 0x6FB9F0, 0xFFD67E, 0xCB86DB, 0x8EEE98, 0xFF93B2, or 0xFB6F5F.
@icon_emoji_id ID of the [custom emoji](https://core.telegram.org/api/custom-emoji) used as topic icon.
@top_message ID of the last message that was sent to this topic
@read_inbox_max_id Position up to which all incoming messages are read.
@read_outbox_max_id Position up to which all outgoing messages are read.
@unread_count Number of unread messages
@unread_mentions_count Number of [unread mentions](https://core.telegram.org/api/mentions)
@unread_reactions_count Number of unread reactions to messages you sent
@from_id ID of the peer that created the topic
@notify_settings Notification settings
@draft Message [draft](https://core.telegram.org/api/drafts)
*/
forumTopic#71701da9 flags:# my:flags.1?true closed:flags.2?true pinned:flags.3?true short:flags.5?true hidden:flags.6?true id:int date:int title:string icon_color:int icon_emoji_id:flags.0?long top_message:int read_inbox_max_id:int read_outbox_max_id:int unread_count:int unread_mentions_count:int unread_reactions_count:int from_id:Peer notify_settings:PeerNotifySettings draft:flags.4?DraftMessage = ForumTopic;

/*
Contains information about multiple [forum topics](https://core.telegram.org/api/forum#forum-topics)

@order_by_create_date Whether the returned topics are ordered by creation date; if set, pagination by offset_date should use [forumTopic](https://core.telegram.org/constructor/forumTopic). date; otherwise topics are ordered by the last message date, so paginate by the date of the [message](https://core.telegram.org/type/Message) referenced by [forumTopic](https://core.telegram.org/constructor/forumTopic). top_message.
@count Total number of topics matching query; may be more than the topics contained in topics, in which case [pagination](https://core.telegram.org/api/offsets) is required.
@topics Forum topics
@messages Related messages (contains the messages mentioned by [forumTopic](https://core.telegram.org/constructor/forumTopic). top_message).
@chats Related chats
@users Related users
@pts [Event count after generation](https://core.telegram.org/api/updates)
*/
messages.forumTopics#367617d3 flags:# order_by_create_date:flags.0?true count:int topics:Vector<ForumTopic> messages:Vector<Message> chats:Vector<Chat> users:Vector<User> pts:int = messages.ForumTopics;

/*
Contains info about the default value of the Time-To-Live setting, applied to all new chats.

@period Time-To-Live setting applied to all new chats.
*/
defaultHistoryTTL#43b46b20 period:int = DefaultHistoryTTL;

/*
Describes a [temporary profile link](https://core.telegram.org/api/links#temporary-profile-links).

@url The [temporary profile link](https://core.telegram.org/api/links#temporary-profile-links).
@expires Its expiration date
*/
exportedContactToken#41bf109b url:string expires:int = ExportedContactToken;

/*
Choose a user.

@bot Whether to allow choosing only bots.
@premium Whether to allow choosing only [Premium](https://core.telegram.org/api/premium) users.
*/
requestPeerTypeUser#5f3b8a00 flags:# bot:flags.0?Bool premium:flags.1?Bool = RequestPeerType;

/*
Choose a chat or supergroup

@creator Whether to allow only choosing chats or supergroups that were created by the current user.
@bot_participant Whether to allow only choosing chats or supergroups where the bot is a participant.
@has_username If specified, allows only choosing channels with or without a username, according to the value of [Bool](https://core.telegram.org/type/Bool).
@forum If specified, allows only choosing chats or supergroups that are or aren't [forums](https://core.telegram.org/api/forum), according to the value of [Bool](https://core.telegram.org/type/Bool).
@user_admin_rights If specified, allows only choosing chats or supergroups where the current user is an admin with at least the specified admin rights.
@bot_admin_rights If specified, allows only choosing chats or supergroups where the bot is an admin with at least the specified admin rights.
*/
requestPeerTypeChat#c9f06e1b flags:# creator:flags.0?true bot_participant:flags.5?true has_username:flags.3?Bool forum:flags.4?Bool user_admin_rights:flags.1?ChatAdminRights bot_admin_rights:flags.2?ChatAdminRights = RequestPeerType;

/*
Choose a channel

@creator Whether to allow only choosing channels that were created by the current user.
@has_username If specified, allows only choosing channels with or without a username, according to the value of [Bool](https://core.telegram.org/type/Bool).
@user_admin_rights If specified, allows only choosing channels where the current user is an admin with at least the specified admin rights.
@bot_admin_rights If specified, allows only choosing channels where the bot is an admin with at least the specified admin rights.
*/
requestPeerTypeBroadcast#339bef6c flags:# creator:flags.0?true has_username:flags.3?Bool user_admin_rights:flags.1?ChatAdminRights bot_admin_rights:flags.2?ChatAdminRights = RequestPeerType;

/*
The list of [custom emojis](https://core.telegram.org/api/custom-emoji) hasn't changed.
*/
emojiListNotModified#481eadfa = EmojiList;

/*
Represents a list of [custom emojis](https://core.telegram.org/api/custom-emoji).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@document_id Custom emoji IDs
*/
emojiList#7a1e11d1 hash:long document_id:Vector<long> = EmojiList;

/*
Represents an [emoji category](https://core.telegram.org/api/emoji-categories).

@title Category name, i.e. "Animals", "Flags", "Faces" and so on...
@icon_emoji_id A single custom emoji used as preview for the category.
@emoticons A list of UTF-8 emojis, matching the category.
*/
emojiGroup#7a9abda9 title:string icon_emoji_id:long emoticons:Vector<string> = EmojiGroup;

/*
Represents an [emoji category](https://core.telegram.org/api/emoji-categories), that should be moved to the top of the list when choosing a sticker for a [business introduction](https://core.telegram.org/api/business#business-introduction)

@title Category name, i.e. "Animals", "Flags", "Faces" and so on...
@icon_emoji_id A single custom emoji used as preview for the category.
@emoticons A list of UTF-8 emojis, matching the category.
*/
emojiGroupGreeting#80d26cc7 title:string icon_emoji_id:long emoticons:Vector<string> = EmojiGroup;

/*
An [emoji category](https://core.telegram.org/api/emoji-categories), used to select all [Premium](https://core.telegram.org/api/premium)-only stickers (i.e. those with a [Premium effect](https://core.telegram.org/api/stickers#premium-animated-sticker-effects))/ [Premium](https://core.telegram.org/api/premium)-only [custom emojis](https://core.telegram.org/api/custom-emoji) (i.e. those where the [documentAttributeCustomEmoji](https://core.telegram.org/constructor/documentAttributeCustomEmoji). free flag is not set)

@title Category name, i.e. "Animals", "Flags", "Faces" and so on...
@icon_emoji_id A single custom emoji used as preview for the category.
*/
emojiGroupPremium#93bcf34 title:string icon_emoji_id:long = EmojiGroup;

/*
The list of [emoji categories](https://core.telegram.org/api/emoji-categories) hasn't changed.
*/
messages.emojiGroupsNotModified#6fb4ad87 = messages.EmojiGroups;

/*
Represents a list of [emoji categories](https://core.telegram.org/api/emoji-categories).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@groups A list of [emoji categories](https://core.telegram.org/api/emoji-categories).
*/
messages.emojiGroups#881fb94b hash:int groups:Vector<EmojiGroup> = messages.EmojiGroups;

/*
Styled text with [message entities](https://core.telegram.org/api/entities)

@text Text
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
*/
textWithEntities#751f3146 text:string entities:Vector<MessageEntity> = TextWithEntities;

/*
Translated text with [entities](https://core.telegram.org/api/entities)

@result Text+ [entities](https://core.telegram.org/api/entities), for each input message.
*/
messages.translateResult#33db32f8 result:Vector<TextWithEntities> = messages.TranslatedText;

/*
Media autosave settings

@photos Whether photos should be autosaved to the gallery.
@videos Whether videos should be autosaved to the gallery.
@video_max_size If set, specifies a size limit for autosavable videos
*/
autoSaveSettings#c84834ce flags:# photos:flags.0?true videos:flags.1?true video_max_size:flags.2?long = AutoSaveSettings;

/*
Peer-specific media autosave settings

@peer The peer
@settings Media autosave settings
*/
autoSaveException#81602d47 peer:Peer settings:AutoSaveSettings = AutoSaveException;

/*
Contains media autosave settings

@users_settings Default media autosave settings for private chats
@chats_settings Default media autosave settings for [groups and supergroups](https://core.telegram.org/api/channel)
@broadcasts_settings Default media autosave settings for [channels](https://core.telegram.org/api/channel)
@exceptions Peer-specific granular autosave settings
@chats Chats mentioned in the peer-specific granular autosave settings
@users Users mentioned in the peer-specific granular autosave settings
*/
account.autoSaveSettings#4c3e069d users_settings:AutoSaveSettings chats_settings:AutoSaveSettings broadcasts_settings:AutoSaveSettings exceptions:Vector<AutoSaveException> chats:Vector<Chat> users:Vector<User> = account.AutoSaveSettings;

/*
The client configuration parameters haven't changed
*/
help.appConfigNotModified#7cde641d = help.AppConfig;

/*
Contains various [client configuration parameters](https://core.telegram.org/api/config#client-configuration)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@config [Client configuration parameters](https://core.telegram.org/api/config#client-configuration)
*/
help.appConfig#dd18782e hash:int config:JSONValue = help.AppConfig;

/*
Used to fetch information about a [direct link Mini App](https://core.telegram.org/api/bots/webapps#direct-link-mini-apps) by its ID

@id [direct link Mini App](https://core.telegram.org/api/bots/webapps#direct-link-mini-apps) ID.
@access_hash Access hash, obtained from the [botApp](https://core.telegram.org/constructor/botApp) constructor.
*/
inputBotAppID#a920bd7a id:long access_hash:long = InputBotApp;

/*
Used to fetch information about a [direct link Mini App](https://core.telegram.org/api/bots/webapps#direct-link-mini-apps) by its short name

@bot_id ID of the bot that owns the bot mini app
@short_name Short name, obtained from a [Direct Mini App deep link](https://core.telegram.org/api/links#direct-mini-app-links)
*/
inputBotAppShortName#908c0407 bot_id:InputUser short_name:string = InputBotApp;

/*
Bot app info hasn't changed.
*/
botAppNotModified#5da674b7 = BotApp;

/*
Contains information about a [direct link Mini App](https://core.telegram.org/api/bots/webapps#direct-link-mini-apps).

@id bot mini app ID
@access_hash bot mini app access hash
@short_name bot mini app short name, used to generate [Direct Mini App deep links](https://core.telegram.org/api/links#direct-mini-app-links).
@title bot mini app title.
@description bot mini app description.
@photo bot mini app photo.
@document bot mini app animation.
@hash Hash to pass to [messages.getBotApp](https://core.telegram.org/method/messages.getBotApp), to avoid refetching bot app info if it hasn't changed.
*/
botApp#95fcd1d6 flags:# id:long access_hash:long short_name:string title:string description:string photo:Photo document:flags.0?Document hash:long = BotApp;

/*
Contains information about a [direct link Mini App](https://core.telegram.org/api/bots/webapps#direct-link-mini-apps)

@inactive Whether the web app was never used by the user, and confirmation must be asked from the user before opening it.
@request_write_access The bot is asking permission to send messages to the user: if the user agrees, set the write_allowed flag when invoking [messages.requestAppWebView](https://core.telegram.org/method/messages.requestAppWebView).
@has_settings Deprecated flag, can be ignored.
@app Bot app information
*/
messages.botApp#eb50adf5 flags:# inactive:flags.0?true request_write_access:flags.1?true has_settings:flags.2?true app:BotApp = messages.BotApp;

/*
Specifies an [inline mode mini app](https://core.telegram.org/api/bots/webapps#inline-mode-mini-apps) button, shown on top of the inline query results list.

@text Text of the button
@url Webapp URL
*/
inlineBotWebView#b57295d5 text:string url:string = InlineBotWebView;

/*
Contains info about when a certain participant has read a message

@user_id User ID
@date When the user read the message
*/
readParticipantDate#4a4ff172 user_id:long date:int = ReadParticipantDate;

/*
Folder ID

@filter_id [Folder](https://core.telegram.org/api/folders) ID
*/
inputChatlistDialogFilter#f3e0da33 filter_id:int = InputChatlist;

/*
Exported [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@title Name of the link
@url The [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).
@peers Peers to import
*/
exportedChatlistInvite#c5181ac flags:# title:string url:string peers:Vector<Peer> = ExportedChatlistInvite;

/*
Info about an exported [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@filter Folder ID
@invite The exported [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).
*/
chatlists.exportedChatlistInvite#10e6e3a6 filter:DialogFilter invite:ExportedChatlistInvite = chatlists.ExportedChatlistInvite;

/*
Info about multiple [chat folder deep links](https://core.telegram.org/api/links#chat-folder-links).

@invites The [chat folder deep links](https://core.telegram.org/api/links#chat-folder-links).
@chats Related chat information
@users Related user information
*/
chatlists.exportedInvites#10ab6dc7 invites:Vector<ExportedChatlistInvite> chats:Vector<Chat> users:Vector<User> = chatlists.ExportedInvites;

/*
Updated info about a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links) we already imported.

@filter_id ID of the imported folder
@missing_peers New peers to be imported
@already_peers Peers that were already imported
@chats Related chat information
@users Related user information
*/
chatlists.chatlistInviteAlready#fa87f659 filter_id:int missing_peers:Vector<Peer> already_peers:Vector<Peer> chats:Vector<Chat> users:Vector<User> = chatlists.ChatlistInvite;

/*
Info about a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@title_noanimate  ... 
@title Name of the link
@emoticon Emoji to use as icon for the folder.
@peers Supergroups and channels to join
@chats Related chat information
@users Related user information

#DocError
*/
chatlists.chatlistInvite#f10ece2f flags:# title_noanimate:flags.1?true title:TextWithEntities emoticon:flags.0?string peers:Vector<Peer> chats:Vector<Chat> users:Vector<User> = chatlists.ChatlistInvite;

/*
Updated information about a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@missing_peers New peers to join
@chats Related chat information
@users Related user information
*/
chatlists.chatlistUpdates#93bd878d missing_peers:Vector<Peer> chats:Vector<Chat> users:Vector<User> = chatlists.ChatlistUpdates;

/*
Localized information about a bot.

@name Bot name
@about Bot about text
@description Bot description
*/
bots.botInfo#e8a775b0 name:string about:string description:string = bots.BotInfo;

/*
How a peer voted in a poll

@peer Peer ID
@option The option chosen by the peer
@date When did the peer cast the vote
*/
messagePeerVote#b6cc2d5c peer:Peer option:bytes date:int = MessagePeerVote;

/*
How a peer voted in a poll (reduced constructor, returned if an option was provided to [messages.getPollVotes](https://core.telegram.org/method/messages.getPollVotes))

@peer The peer that voted for the queried option
@date When did the peer cast the vote
*/
messagePeerVoteInputOption#74cda504 peer:Peer date:int = MessagePeerVote;

/*
How a peer voted in a multiple-choice poll

@peer Peer ID
@options Options chosen by the peer
@date When did the peer cast their votes
*/
messagePeerVoteMultiple#4628f6e6 peer:Peer options:Vector<bytes> date:int = MessagePeerVote;

/*
Aggregated view and reaction information of a [story](https://core.telegram.org/api/stories).

@has_viewers If set, indicates that the viewers list is currently viewable, and was not yet deleted because the story has expired while the user didn't have a [Premium](https://core.telegram.org/api/premium) account.
@views_count View counter of the story
@forwards_count Forward counter of the story
@reactions All reactions sent to this story
@reactions_count Number of reactions added to the story
@recent_viewers User IDs of some recent viewers of the story
*/
storyViews#8d595cd6 flags:# has_viewers:flags.1?true views_count:int forwards_count:flags.2?int reactions:flags.3?Vector<ReactionCount> reactions_count:flags.4?int recent_viewers:flags.0?Vector<long> = StoryViews;

/*
Represents a previously active story, that was deleted

@id Story ID
*/
storyItemDeleted#51e6ee4f id:int = StoryItem;

/*
Represents an active story, whose full information was omitted for space and performance reasons; use [stories.getStoriesByID](https://core.telegram.org/method/stories.getStoriesByID) to fetch full info about the skipped story when and if needed.

@close_friends Whether this story can only be viewed by [our close friends, see here](https://core.telegram.org/api/privacy) for more info
@id Story ID
@date When was the story posted.
@expire_date When does the story expire.
*/
storyItemSkipped#ffadc913 flags:# close_friends:flags.8?true id:int date:int expire_date:int = StoryItem;

/*
Represents a [story](https://core.telegram.org/api/stories).

@pinned Whether this story is pinned on the user's profile
@public Whether this story is public and can be viewed by everyone
@close_friends Whether this story can only be viewed by [our close friends, see here](https://core.telegram.org/api/privacy) for more info
@min Full information about this story was omitted for space and performance reasons; use [stories.getStoriesByID](https://core.telegram.org/method/stories.getStoriesByID) to fetch full info about this story when and if needed.
@noforwards Whether this story is [protected](https://telegram.org/blog/protected-content-delete-by-date-and-more) and thus cannot be forwarded; clients should also prevent users from saving attached media (i.e. videos should only be streamed, photos should be kept in RAM, et cetera).
@edited Indicates whether the story was edited.
@contacts Whether this story can only be viewed by our contacts
@selected_contacts Whether this story can only be viewed by a select list of our contacts
@out indicates whether we sent this story.
@id ID of the story.
@date When was the story posted.
@from_id Sender of the story.
@fwd_from For [reposted stories](https://core.telegram.org/api/stories#reposting-stories), contains info about the original story.
@expire_date When does the story expire.
@caption Story caption.
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@media Story media.
@media_areas List of media areas, see [here](https://core.telegram.org/api/stories#media-areas) for more info on media areas.
@privacy [Privacy rules](https://core.telegram.org/api/privacy) indicating who can and can't view this story
@views View date and reaction information
@sent_reaction The reaction we sent.
*/
storyItem#79b26a24 flags:# pinned:flags.5?true public:flags.7?true close_friends:flags.8?true min:flags.9?true noforwards:flags.10?true edited:flags.11?true contacts:flags.12?true selected_contacts:flags.13?true out:flags.16?true id:int date:int from_id:flags.18?Peer fwd_from:flags.17?StoryFwdHeader expire_date:int caption:flags.0?string entities:flags.1?Vector<MessageEntity> media:MessageMedia media_areas:flags.14?Vector<MediaArea> privacy:flags.2?Vector<PrivacyRule> views:flags.3?StoryViews sent_reaction:flags.15?Reaction = StoryItem;

/*
The list of active (or active and hidden) [stories](https://core.telegram.org/api/stories#watching-stories) has not changed.

@state State to use to ask for updates
@stealth_mode Current [stealth mode](https://core.telegram.org/api/stories#stealth-mode) information
*/
stories.allStoriesNotModified#1158fe3e flags:# state:string stealth_mode:StoriesStealthMode = stories.AllStories;

/*
Full list of active (or active and hidden) [stories](https://core.telegram.org/api/stories#watching-stories).

@has_more Whether more results can be fetched as [described here](https://core.telegram.org/api/stories#watching-stories).
@count Total number of active (or active and hidden) stories
@state State to use for pagination
@peer_stories Stories
@chats Mentioned chats
@users Mentioned users
@stealth_mode Current [stealth mode](https://core.telegram.org/api/stories#stealth-mode) information
*/
stories.allStories#6efc5e81 flags:# has_more:flags.0?true count:int state:string peer_stories:Vector<PeerStories> chats:Vector<Chat> users:Vector<User> stealth_mode:StoriesStealthMode = stories.AllStories;

/*
List of [stories](https://core.telegram.org/api/stories#pinned-or-archived-stories)

@count Total number of stories that can be fetched
@stories Stories
@pinned_to_top IDs of pinned stories.
@chats Mentioned chats
@users Mentioned users
*/
stories.stories#63c3dd0a flags:# count:int stories:Vector<StoryItem> pinned_to_top:flags.0?Vector<int> chats:Vector<Chat> users:Vector<User> = stories.Stories;

/*
[Story](https://core.telegram.org/api/stories) view date and reaction information

@blocked Whether we have [completely blocked](https://core.telegram.org/api/block) this user, including from viewing more of our stories.
@blocked_my_stories_from Whether we have [blocked](https://core.telegram.org/api/block) this user from viewing more of our stories.
@user_id The user that viewed the story
@date When did the user view the story
@reaction If present, contains the reaction that the user left on the story
*/
storyView#b0bdeac5 flags:# blocked:flags.0?true blocked_my_stories_from:flags.1?true user_id:long date:int reaction:flags.2?Reaction = StoryView;

/*
A certain peer has forwarded the story as a message to a public chat or channel.

@blocked Whether we have [completely blocked](https://core.telegram.org/api/block) this user, including from viewing more of our stories.
@blocked_my_stories_from Whether we have [blocked](https://core.telegram.org/api/block) this user from viewing more of our stories.
@message The message with the forwarded story.
*/
storyViewPublicForward#9083670b flags:# blocked:flags.0?true blocked_my_stories_from:flags.1?true message:Message = StoryView;

/*
A certain peer has reposted the story.

@blocked Whether we have [completely blocked](https://core.telegram.org/api/block) this user, including from viewing more of our stories.
@blocked_my_stories_from Whether we have [blocked](https://core.telegram.org/api/block) this user from viewing more of our stories.
@peer_id The peer that reposted the story.
@story The reposted story.
*/
storyViewPublicRepost#bd74cf49 flags:# blocked:flags.0?true blocked_my_stories_from:flags.1?true peer_id:Peer story:StoryItem = StoryView;

/*
Reaction and view counters for a [story](https://core.telegram.org/api/stories)

@count Total number of results that can be fetched
@views_count Total number of story views
@forwards_count Total number of story forwards/reposts
@reactions_count Number of reactions that were added to the story
@views Story view date and reaction information
@chats Mentioned chats
@users Mentioned users
@next_offset Offset for pagination
*/
stories.storyViewsList#59d78fc5 flags:# count:int views_count:int forwards_count:int reactions_count:int views:Vector<StoryView> chats:Vector<Chat> users:Vector<User> next_offset:flags.0?string = stories.StoryViewsList;

/*
Reaction and view counters for a list of [stories](https://core.telegram.org/api/stories)

@views View date and reaction information of multiple stories
@users Mentioned users
*/
stories.storyViews#de9eed1d views:Vector<StoryViews> users:Vector<User> = stories.StoryViews;

/*
Reply to a message.

@reply_to_msg_id The message ID to reply to.
@top_msg_id This field must contain the topic ID only when replying to messages in forum topics different from the "General" topic (i.e. reply_to_msg_id is set and reply_to_msg_id != topicID and topicID != 1).  If the replied-to message is deleted before the method finishes execution, the value in this field will be used to send the message to the correct topic, instead of the "General" topic.
@reply_to_peer_id Used to reply to messages sent to another chat (specified here), can only be used for non- protected chats and messages.
@quote_text Used to quote-reply to only a certain section (specified here) of the original message. The maximum UTF-8 length for quotes is specified in the [quote_length_max](https://core.telegram.org/api/config#quote-length-max) config key.
@quote_entities [Message entities for styled text](https://core.telegram.org/api/entities) from the quote_text field.
@quote_offset Offset of the message quote_text within the original message (in [UTF-16 code units](https://core.telegram.org/api/entities#entity-length)).
*/
inputReplyToMessage#22c0f6d5 flags:# reply_to_msg_id:int top_msg_id:flags.0?int reply_to_peer_id:flags.1?InputPeer quote_text:flags.2?string quote_entities:flags.3?Vector<MessageEntity> quote_offset:flags.4?int = InputReplyTo;

/*
Reply to a story.

@peer Sender of the story
@story_id ID of the story to reply to.
*/
inputReplyToStory#5881323a peer:InputPeer story_id:int = InputReplyTo;

/*
Represents a [story deep link](https://core.telegram.org/api/stories#story-links).

@link The [story deep link](https://core.telegram.org/api/stories#story-links).
*/
exportedStoryLink#3fc9053b link:string = ExportedStoryLink;

/*
Information about the current [stealth mode](https://core.telegram.org/api/stories#stealth-mode) session.

@active_until_date The date up to which stealth mode will be active.
@cooldown_until_date The date starting from which the user will be allowed to re-enable stealth mode again.
*/
storiesStealthMode#712e27fd flags:# active_until_date:flags.0?int cooldown_until_date:flags.1?int = StoriesStealthMode;

/*
Coordinates and size of a clicable rectangular area on top of a story.

@x The abscissa of the rectangle's center, as a percentage of the media width (0-100).
@y The ordinate of the rectangle's center, as a percentage of the media height (0-100).
@w The width of the rectangle, as a percentage of the media width (0-100).
@h The height of the rectangle, as a percentage of the media height (0-100).
@rotation Clockwise rotation angle of the rectangle, in degrees (0-360).
@radius The radius of the rectangle corner rounding, as a percentage of the media width.
*/
mediaAreaCoordinates#cfc9e002 flags:# x:double y:double w:double h:double rotation:double radius:flags.0?double = MediaAreaCoordinates;

/*
Represents a location tag attached to a [story](https://core.telegram.org/api/stories), with additional venue information.

@coordinates The size and location of the media area corresponding to the location sticker on top of the story media.
@geo Coordinates of the venue
@title Venue name
@address Address
@provider Venue provider: currently only "foursquare" needs to be supported.
@venue_id Venue ID in the provider's database
@venue_type Venue type in the provider's database
*/
mediaAreaVenue#be82db9c coordinates:MediaAreaCoordinates geo:GeoPoint title:string address:string provider:string venue_id:string venue_type:string = MediaArea;

/*
Represents a [location tag](https://core.telegram.org/api/stories#media-areas) attached to a [story](https://core.telegram.org/api/stories), with additional venue information.

@coordinates The size and location of the media area corresponding to the location sticker on top of the story media.
@query_id The query_id from [messages.botResults](https://core.telegram.org/constructor/messages.botResults), see [here](https://core.telegram.org/api/stories#media-areas) for more info.
@result_id The id of the chosen result, see [here](https://core.telegram.org/api/stories#media-areas) for more info.
*/
inputMediaAreaVenue#b282217f coordinates:MediaAreaCoordinates query_id:long result_id:string = MediaArea;

/*
Represents a geolocation tag attached to a [story](https://core.telegram.org/api/stories).

@coordinates The size and position of the media area corresponding to the location sticker on top of the story media.
@geo Coordinates of the geolocation tag.
@address Optional textual representation of the address.
*/
mediaAreaGeoPoint#cad5452d flags:# coordinates:MediaAreaCoordinates geo:GeoPoint address:flags.0?GeoPointAddress = MediaArea;

/*
Represents a reaction bubble.

@dark Whether the reaction bubble has a dark background.
@flipped Whether the reaction bubble is mirrored (see [here](https://core.telegram.org/api/stories#reactions) for more info).
@coordinates The coordinates of the media area corresponding to the reaction button.
@reaction The reaction that should be sent when this area is clicked.
*/
mediaAreaSuggestedReaction#14455871 flags:# dark:flags.0?true flipped:flags.1?true coordinates:MediaAreaCoordinates reaction:Reaction = MediaArea;

/*
Represents a channel post.

@coordinates The size and location of the media area corresponding to the location sticker on top of the story media.
@channel_id The channel that posted the message
@msg_id ID of the channel message
*/
mediaAreaChannelPost#770416af coordinates:MediaAreaCoordinates channel_id:long msg_id:int = MediaArea;

/*
Represents a channel post

@coordinates The size and location of the media area corresponding to the location sticker on top of the story media.
@channel The channel that posted the message
@msg_id ID of the channel message
*/
inputMediaAreaChannelPost#2271f2bf coordinates:MediaAreaCoordinates channel:InputChannel msg_id:int = MediaArea;

/*
Represents a [URL media area](https://core.telegram.org/api/stories#urls).

@coordinates The size and location of the media area corresponding to the URL button on top of the story media.
@url URL to open when clicked.
*/
mediaAreaUrl#37381085 coordinates:MediaAreaCoordinates url:string = MediaArea;

/*
Represents a [weather widget](https://core.telegram.org/api/stories#weather).

@coordinates The size and location of the media area corresponding to the widget on top of the story media.
@emoji Weather emoji, should be rendered as an [animated emoji](https://core.telegram.org/api/animated-emojis).
@temperature_c Temperature in degrees Celsius.
@color ARGB background color.
*/
mediaAreaWeather#49a6549c coordinates:MediaAreaCoordinates emoji:string temperature_c:double color:int = MediaArea;

mediaAreaStarGift#5787686d coordinates:MediaAreaCoordinates slug:string = MediaArea;
/*
[Stories](https://core.telegram.org/api/stories) associated to a peer

@peer The peer
@max_read_id If set, contains the ID of the maximum read story
@stories Stories
*/
peerStories#9a35e999 flags:# peer:Peer max_read_id:flags.0?int stories:Vector<StoryItem> = PeerStories;

/*
[Active story list](https://core.telegram.org/api/stories#watching-stories) of a specific peer.

@stories Stories
@chats Mentioned chats
@users Mentioned users
*/
stories.peerStories#cae68768 stories:PeerStories chats:Vector<Chat> users:Vector<User> = stories.PeerStories;

/*
Represents an Instant View webpage.

@webpage The instant view webpage.
@chats Chats mentioned in the webpage.
@users Users mentioned in the webpage.
*/
messages.webPage#fd5e12bd webpage:WebPage chats:Vector<Chat> users:Vector<User> = messages.WebPage;

/*
Contains info about a [giveaway/gift](https://core.telegram.org/api/giveaways) option.

@users Number of users which will be able to activate the gift codes.
@months Duration in months of each gifted [Telegram Premium](https://core.telegram.org/api/premium) subscription.
@store_product Identifier of the store product associated with the option, official apps only.
@store_quantity Number of times the store product must be paid
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
*/
premiumGiftCodeOption#257e962b flags:# users:int months:int store_product:flags.0?string store_quantity:flags.1?int currency:string amount:long = PremiumGiftCodeOption;

/*
Contains info about a [Telegram Premium giftcode link](https://core.telegram.org/api/links#premium-giftcode-links).

@via_giveaway Whether this giftcode was created by a [giveaway](https://core.telegram.org/api/giveaways).
@from_id The peer that created the gift code.
@giveaway_msg_id Message ID of the giveaway in the channel specified in from_id.
@to_id The destination user of the gift.
@date Creation date of the gift code.
@months Duration in months of the gifted [Telegram Premium](https://core.telegram.org/api/premium) subscription.
@used_date When was the giftcode imported, if it was imported.
@chats Mentioned chats
@users Mentioned users
*/
payments.checkedGiftCode#284a1096 flags:# via_giveaway:flags.2?true from_id:flags.4?Peer giveaway_msg_id:flags.3?int to_id:flags.0?long date:int months:int used_date:flags.1?int chats:Vector<Chat> users:Vector<User> = payments.CheckedGiftCode;

/*
Contains info about an ongoing [giveaway](https://core.telegram.org/api/giveaways).

@participating The current user is participating in the giveaway.
@preparing_results If set, the giveaway has ended and the results are being prepared.
@start_date When was the giveaway started
@joined_too_early_date The current user can't participate in the giveaway, because they were already a member of the channel when the giveaway started, and the only_new_subscribers was set when starting the giveaway.
@admin_disallowed_chat_id If set, the current user can't participate in the giveaway, because they are an administrator in one of the channels (ID specified in this flag) that created the giveaway.
@disallowed_country If set, the current user can't participate in this giveaway, because their phone number is from the specified disallowed country (specified as a two-letter ISO 3166-1 alpha-2 country code).
*/
payments.giveawayInfo#4367daa0 flags:# participating:flags.0?true preparing_results:flags.3?true start_date:int joined_too_early_date:flags.1?int admin_disallowed_chat_id:flags.2?long disallowed_country:flags.4?string = payments.GiveawayInfo;

/*
A [giveaway](https://core.telegram.org/api/giveaways) has ended.

@winner Whether we're one of the winners of this giveaway.
@refunded Whether the giveaway was canceled and was fully refunded.
@start_date Start date of the giveaway
@gift_code_slug If we're one of the winners of this giveaway, contains the [Premium gift code](https://core.telegram.org/api/links#premium-giftcode-links), see [here](https://core.telegram.org/api/giveaways) for more info on the full giveaway flow.
@stars_prize If we're one of the winners of this [Telegram Star giveaway](https://core.telegram.org/api/giveaways#star-giveaways), the number [Telegram Stars](https://core.telegram.org/api/stars) we won.
@finish_date End date of the giveaway. May be bigger than the end date specified in parameters of the giveaway.
@winners_count Number of winners in the giveaway
@activated_count Number of winners, which activated their [gift codes](https://core.telegram.org/api/links#premium-giftcode-links).
*/
payments.giveawayInfoResults#e175e66f flags:# winner:flags.0?true refunded:flags.1?true start_date:int gift_code_slug:flags.3?string stars_prize:flags.4?long finish_date:int winners_count:int activated_count:flags.2?int = payments.GiveawayInfo;

/*
Contains info about a [prepaid giveaway](https://core.telegram.org/api/giveaways).

@id Prepaid giveaway ID.
@months Duration in months of each gifted [Telegram Premium](https://core.telegram.org/api/premium) subscription.
@quantity Number of given away [Telegram Premium](https://core.telegram.org/api/premium) subscriptions.
@date Payment date.
*/
prepaidGiveaway#b2539d54 id:long months:int quantity:int date:int = PrepaidGiveaway;

/*
Contains info about a [prepaid Telegram Star giveaway](https://core.telegram.org/api/giveaways#star-giveaways).

@id Prepaid giveaway ID.
@stars Number of given away [Telegram Stars](https://core.telegram.org/api/stars)
@quantity Number of giveaway winners
@boosts Number of boosts the channel will gain by launching the giveaway.
@date When was the giveaway paid for
*/
prepaidStarsGiveaway#9a9d77e0 id:long stars:long quantity:int boosts:int date:int = PrepaidGiveaway;

/*
Info about one or more [boosts](https://core.telegram.org/api/boost) applied by a specific user.

@gift Whether this boost was applied because the channel/supergroup [directly gifted a subscription to the user](https://core.telegram.org/api/giveaways).
@giveaway Whether this boost was applied because the user was chosen in a [giveaway started by the channel/supergroup](https://core.telegram.org/api/giveaways).
@unclaimed If set, the user hasn't yet invoked [payments.applyGiftCode](https://core.telegram.org/method/payments.applyGiftCode) to claim a subscription gifted [directly or in a giveaway by the channel](https://core.telegram.org/api/giveaways).
@id Unique ID for this set of boosts.
@user_id ID of the user that applied the boost.
@giveaway_msg_id The message ID of the [giveaway](https://core.telegram.org/api/giveaways)
@date When was the boost applied
@expires When does the boost expire
@used_gift_slug The created Telegram Premium gift code, only set if either gift or giveaway are set AND it is either a gift code for the currently logged in user or if it was already claimed.
@multiplier If set, this boost counts as multiplier boosts, otherwise it counts as a single boost.
@stars Number of Telegram Stars distributed among the winners of the giveaway.
*/
boost#4b3e14d6 flags:# gift:flags.1?true giveaway:flags.2?true unclaimed:flags.3?true id:string user_id:flags.0?long giveaway_msg_id:flags.2?int date:int expires:int used_gift_slug:flags.4?string multiplier:flags.5?int stars:flags.6?long = Boost;

/*
List of [boosts](https://core.telegram.org/api/boost) that were applied to a peer by multiple users.

@count Total number of results
@boosts [Boosts](https://core.telegram.org/api/boost)
@next_offset Offset that can be used for [pagination](https://core.telegram.org/api/offsets).
@users Mentioned users
*/
premium.boostsList#86f8613c flags:# count:int boosts:Vector<Boost> next_offset:flags.0?string users:Vector<User> = premium.BoostsList;

/*
Contains information about a single [boost slot](https://core.telegram.org/api/boost).

@slot [Boost slot ID](https://core.telegram.org/api/boost)
@peer If set, indicates this slot is currently occupied, i.e. we are [boosting](https://core.telegram.org/api/boost) this peer.  Note that we can assign multiple boost slots to the same peer.
@date When (unixtime) we started boosting the peer, 0 otherwise.
@expires Indicates the (unixtime) expiration date of the boost in peer ( 0 if peer is not set).
@cooldown_until_date If peer is set, indicates the (unixtime) date after which this boost can be reassigned to another channel.
*/
myBoost#c448415c flags:# slot:int peer:flags.0?Peer date:int expires:int cooldown_until_date:flags.1?int = MyBoost;

/*
A list of peers we are currently [boosting](https://core.telegram.org/api/boost), and how many [boost slots](https://core.telegram.org/api/boost) we have left.

@my_boosts Info about boosted peers and remaining boost slots.
@chats Referenced chats
@users Referenced users
*/
premium.myBoosts#9ae228e2 my_boosts:Vector<MyBoost> chats:Vector<Chat> users:Vector<User> = premium.MyBoosts;

/*
Contains info about the current [boost status](https://core.telegram.org/api/boost) of a peer.

@my_boost Whether we're currently boosting this channel/supergroup, my_boost_slots will also be set.
@level The current boost level of the channel/supergroup.
@current_level_boosts The number of boosts acquired so far in the current level.
@boosts Total number of boosts acquired so far.
@gift_boosts The number of boosts acquired from created Telegram Premium [gift codes](https://core.telegram.org/api/giveaways) and [giveaways](https://core.telegram.org/api/giveaways); only returned to channel/supergroup admins.
@next_level_boosts Total number of boosts needed to reach the next level; if absent, the next level isn't available.
@premium_audience Only returned to channel/supergroup admins: contains the approximated number of Premium users subscribed to the channel/supergroup, related to the total number of subscribers.
@boost_url [Boost deep link](https://core.telegram.org/api/links#boost-links) that can be used to boost the chat.
@prepaid_giveaways A list of prepaid [giveaways](https://core.telegram.org/api/giveaways) available for the chat; only returned to channel/supergroup admins.
@my_boost_slots Indicates which of our [boost slots](https://core.telegram.org/api/boost) we've assigned to this peer (populated if my_boost is set).
*/
premium.boostsStatus#4959427a flags:# my_boost:flags.2?true level:int current_level_boosts:int boosts:int gift_boosts:flags.4?int next_level_boosts:flags.0?int premium_audience:flags.1?StatsPercentValue boost_url:string prepaid_giveaways:flags.3?Vector<PrepaidGiveaway> my_boost_slots:flags.2?Vector<int> = premium.BoostsStatus;

/*
Contains info about the original poster of a reposted story.

@modified Whether the story media was modified before reposting it (for example by overlaying a round video with a reaction).
@from Peer that originally posted the story; will be empty for stories forwarded from a user with forwards privacy enabled, in which case from_name will be set, instead.
@from_name Will be set for stories forwarded from a user with forwards privacy enabled, in which case from will also be empty.
@story_id , contains the story ID
*/
storyFwdHeader#b826e150 flags:# modified:flags.3?true from:flags.0?Peer from_name:flags.1?string story_id:flags.2?int = StoryFwdHeader;

/*
Interaction counters for a message.

@msg_id Message ID
@views Number of views
@forwards Number of forwards to public channels
@reactions Number of reactions
*/
postInteractionCountersMessage#e7058e7f msg_id:int views:int forwards:int reactions:int = PostInteractionCounters;

/*
Interaction counters for a story.

@story_id Story ID
@views Number of views
@forwards Number of forwards and reposts to public chats and channels
@reactions Number of reactions
*/
postInteractionCountersStory#8a480e27 story_id:int views:int forwards:int reactions:int = PostInteractionCounters;

/*
Contains [statistics](https://core.telegram.org/api/stats) about a [story](https://core.telegram.org/api/stories).

@views_graph A graph containing the number of story views and shares
@reactions_by_emotion_graph A bar graph containing the number of story reactions categorized by "emotion" (i.e. Positive, Negative, Other, etc...)
*/
stats.storyStats#50cd067c views_graph:StatsGraph reactions_by_emotion_graph:StatsGraph = stats.StoryStats;

/*
Contains info about a forward of a [story](https://core.telegram.org/api/stories) as a message.

@message Info about the message with the reposted story.
*/
publicForwardMessage#1f2bf4a message:Message = PublicForward;

/*
Contains info about a forward of a [story](https://core.telegram.org/api/stories) as a repost by a public channel.

@peer The channel that reposted the story.
@story The reposted story (may be different from the original story).
*/
publicForwardStory#edf3add0 peer:Peer story:StoryItem = PublicForward;

/*
Contains info about the forwards of a [story](https://core.telegram.org/api/stories) as a message to public chats and reposts by public channels.

@count Total number of results
@forwards Info about the forwards of a story.
@next_offset Offset used for [pagination](https://core.telegram.org/api/offsets).
@chats Mentioned chats
@users Mentioned users
*/
stats.publicForwards#93037e20 flags:# count:int forwards:Vector<PublicForward> next_offset:flags.0?string chats:Vector<Chat> users:Vector<User> = stats.PublicForwards;

/*
Represents a [color palette](https://core.telegram.org/api/colors).

@color [Color palette ID, see here](https://core.telegram.org/api/colors) for more info; if not set, the default palette should be used.
@background_emoji_id Optional [custom emoji ID](https://core.telegram.org/api/custom-emoji) used to generate the pattern.
*/
peerColor#b54b5acf flags:# color:flags.0?int background_emoji_id:flags.1?long = PeerColor;

/*
Represents a [color palette that can be used in message accents](https://core.telegram.org/api/colors).

@colors A list of 1-3 colors in RGB format, describing the accent color.
*/
help.peerColorSet#26219a58 colors:Vector<int> = help.PeerColorSet;

/*
Represents a [color palette that can be used in profile pages](https://core.telegram.org/api/colors).

@palette_colors A list of 1-2 colors in RGB format, shown in the color palette settings to describe the current palette.
@bg_colors A list of 1-2 colors in RGB format describing the colors used to generate the actual background used in the profile page.
@story_colors A list of 2 colors in RGB format describing the colors of the gradient used for the unread active story indicator around the profile photo.
*/
help.peerColorProfileSet#767d61eb palette_colors:Vector<int> bg_colors:Vector<int> story_colors:Vector<int> = help.PeerColorSet;

/*
Contains info about a [color palette](https://core.telegram.org/api/colors).

@hidden Whether this palette should not be displayed as an option to the user when choosing a palette to apply to profile pages or message accents.
@color_id Palette ID.
@colors Light mode palette. Will be empty for IDs 0 to 6 inclusive, in which case a palette containing a single color from the following colors should be used: red, orange, violet, green, cyan, blue, pink for indexes 0 to 6 (i.e. the same colors used for randomized fallback [message accent colors](https://core.telegram.org/api/colors)).
@dark_colors Dark mode palette. Optional, defaults to the palette in colors (or the autogenerated palette for IDs 0 to 6) if absent.
@channel_min_level Channels can use this palette only after reaching at least the [boost level](https://core.telegram.org/api/boost) specified in this field.
@group_min_level Supergroups can use this palette only after reaching at least the [boost level](https://core.telegram.org/api/boost) specified in this field.
*/
help.peerColorOption#adec6ebe flags:# hidden:flags.0?true color_id:int colors:flags.1?help.PeerColorSet dark_colors:flags.2?help.PeerColorSet channel_min_level:flags.3?int group_min_level:flags.4?int = help.PeerColorOption;

/*
The list of color palettes has not changed.
*/
help.peerColorsNotModified#2ba1f5ce = help.PeerColors;

/*
Contains info about multiple [color palettes](https://core.telegram.org/api/colors).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@colors Usable [color palettes](https://core.telegram.org/api/colors).
*/
help.peerColors#f8ed08 hash:int colors:Vector<help.PeerColorOption> = help.PeerColors;

/*
How a certain peer reacted to a story

@peer_id The peer
@date Reaction date
@reaction The reaction
*/
storyReaction#6090d6d5 peer_id:Peer date:int reaction:Reaction = StoryReaction;

/*
A certain peer has forwarded the story as a message to a public chat or channel.

@message The message with the forwarded story.
*/
storyReactionPublicForward#bbab2643 message:Message = StoryReaction;

/*
A certain peer has reposted the story.

@peer_id The peer that reposted the story.
@story The reposted story.
*/
storyReactionPublicRepost#cfcd0f13 peer_id:Peer story:StoryItem = StoryReaction;

/*
List of peers that reacted to or intercated with a specific [story](https://core.telegram.org/api/stories)

@count Total number of reactions matching query
@reactions List of peers that reacted to or interacted with a specific story
@chats Mentioned chats
@users Mentioned users
@next_offset If set, indicates the next offset to use to load more results by invoking [stories.getStoryReactionsList](https://core.telegram.org/method/stories.getStoryReactionsList).
*/
stories.storyReactionsList#aa5f789c flags:# count:int reactions:Vector<StoryReaction> chats:Vector<Chat> users:Vector<User> next_offset:flags.0?string = stories.StoryReactionsList;

/*
Represents a [saved dialog](https://core.telegram.org/api/saved-messages).

@pinned Is the dialog pinned
@peer The dialog
@top_message The latest message ID
*/
savedDialog#bd87cb6c flags:# pinned:flags.2?true peer:Peer top_message:int = SavedDialog;

/*
Represents some [saved message dialogs](https://core.telegram.org/api/saved-messages).

@dialogs [Saved message dialogs](https://core.telegram.org/api/saved-messages).
@messages List of last messages from each saved dialog
@chats Mentioned chats
@users Mentioned users
*/
messages.savedDialogs#f83ae221 dialogs:Vector<SavedDialog> messages:Vector<Message> chats:Vector<Chat> users:Vector<User> = messages.SavedDialogs;

/*
Incomplete list of [saved message dialogs](https://core.telegram.org/api/saved-messages) with messages and auxiliary data.

@count Total number of saved message dialogs
@dialogs List of saved message dialogs
@messages List of last messages from dialogs
@chats Mentioned chats
@users Mentioned users
*/
messages.savedDialogsSlice#44ba9dd9 count:int dialogs:Vector<SavedDialog> messages:Vector<Message> chats:Vector<Chat> users:Vector<User> = messages.SavedDialogs;

/*
The saved dialogs haven't changed

@count Number of [saved dialogs](https://core.telegram.org/api/saved-messages) found server-side by the query
*/
messages.savedDialogsNotModified#c01f6fe8 count:int = messages.SavedDialogs;

/*
Info about a [saved message reaction tag](https://core.telegram.org/api/saved-messages#tags).

@reaction [Reaction](https://core.telegram.org/api/reactions) associated to the tag.
@title Custom tag name assigned by the user (max 12 UTF-8 chars).
@count Number of messages tagged with this tag.
*/
savedReactionTag#cb6ff828 flags:# reaction:Reaction title:flags.0?string count:int = SavedReactionTag;

/*
The list of [reaction tag](https://core.telegram.org/api/saved-messages#tags) names assigned by the user hasn't changed.
*/
messages.savedReactionTagsNotModified#889b59ef = messages.SavedReactionTags;

/*
List of [reaction tag](https://core.telegram.org/api/saved-messages#tags) names assigned by the user.

@tags Saved reaction tags.
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
*/
messages.savedReactionTags#3259950a tags:Vector<SavedReactionTag> hash:long = messages.SavedReactionTags;

/*
Exact read date of a private message we sent to another user.

@date UNIX timestamp with the read date.
*/
outboxReadDate#3bb842ac date:int = OutboxReadDate;

/*
SMS jobs eligibility

@terms_url Terms of service URL
@monthly_sent_sms Monthly sent SMSes
*/
smsjobs.eligibleToJoin#dc8b44cf terms_url:string monthly_sent_sms:int = smsjobs.EligibilityToJoin;

/*
Status

@allow_international Allow international numbers
@recent_sent Recently sent
@recent_since Since
@recent_remains Remaining
@total_sent Total sent
@total_since Total since
@last_gift_slug Last gift deep link
@terms_url Terms of service URL
*/
smsjobs.status#2aee9191 flags:# allow_international:flags.0?true recent_sent:int recent_since:int recent_remains:int total_sent:int total_since:int last_gift_slug:flags.1?string terms_url:string = smsjobs.Status;

/*
Info about an SMS job.

@job_id Job ID
@phone_number Destination phone number
@text Text
*/
smsJob#e6a1eeb8 job_id:string phone_number:string text:string = SmsJob;

/*
A time interval, indicating the opening hours of a business.

@start_minute Start minute in minutes of the week, 0 to 7*24*60 inclusively.
@end_minute End minute in minutes of the week, 1 to 8*24*60 inclusively ( 8 and not 7 because this allows to specify intervals that, for example, start on Sunday 21:00 and end on Monday 04:00 ( 6*24*60+21*60 to 7*24*60+4*60) without passing an invalid end_minute < start_minute). See [here](https://core.telegram.org/api/business#opening-hours) for more info.
*/
businessWeeklyOpen#120b1ab9 start_minute:int end_minute:int = BusinessWeeklyOpen;

/*
Specifies a set of [Telegram Business opening hours](https://core.telegram.org/api/business#opening-hours).

@open_now Ignored if set while invoking [account.updateBusinessWorkHours](https://core.telegram.org/method/account.updateBusinessWorkHours), only returned by the server in [userFull](https://core.telegram.org/constructor/userFull). business_work_hours, indicating whether the business is currently open according to the current time and the values in weekly_open and timezone.
@timezone_id An ID of one of the timezones returned by [help.getTimezonesList](https://core.telegram.org/method/help.getTimezonesList).    The timezone ID is contained [timezone](https://core.telegram.org/constructor/timezone). id, a human-readable, localized name of the timezone is available in [timezone](https://core.telegram.org/constructor/timezone). name and the [timezone](https://core.telegram.org/constructor/timezone). utc_offset field contains the UTC offset in seconds, which may be displayed in hh:mm format by the client together with the human-readable name (i.e. $name UTC -01:00).
@weekly_open A list of time intervals (max 28) represented by [businessWeeklyOpen](https://core.telegram.org/constructor/businessWeeklyOpen), indicating the opening hours of their business.
*/
businessWorkHours#8c92b098 flags:# open_now:flags.0?true timezone_id:string weekly_open:Vector<BusinessWeeklyOpen> = BusinessWorkHours;

/*
Represents the location of a [Telegram Business](https://core.telegram.org/api/business#location).

@geo_point Geographical coordinates (optional).
@address Textual description of the address (mandatory).
*/
businessLocation#ac5c1af7 flags:# geo_point:flags.0?GeoPoint address:string = BusinessLocation;

/*
Specifies the chats that can receive Telegram Business [away](https://core.telegram.org/api/business#away-messages) and [greeting](https://core.telegram.org/api/business#greeting-messages) messages.

@existing_chats All existing private chats.
@new_chats All new private chats.
@contacts All private chats with contacts.
@non_contacts All private chats with non-contacts.
@exclude_selected If set, inverts the selection.
@users Only private chats with the specified users.
*/
inputBusinessRecipients#6f8b32aa flags:# existing_chats:flags.0?true new_chats:flags.1?true contacts:flags.2?true non_contacts:flags.3?true exclude_selected:flags.5?true users:flags.4?Vector<InputUser> = InputBusinessRecipients;

/*
Specifies the chats that can receive Telegram Business [away](https://core.telegram.org/api/business#away-messages) and [greeting](https://core.telegram.org/api/business#greeting-messages) messages.

@existing_chats All existing private chats.
@new_chats All new private chats.
@contacts All private chats with contacts.
@non_contacts All private chats with non-contacts.
@exclude_selected If set, inverts the selection.
@users Only private chats with the specified users.
*/
businessRecipients#21108ff7 flags:# existing_chats:flags.0?true new_chats:flags.1?true contacts:flags.2?true non_contacts:flags.3?true exclude_selected:flags.5?true users:flags.4?Vector<long> = BusinessRecipients;

/*
Always send [Telegram Business away messages](https://core.telegram.org/api/business#away-messages) to users writing to us in private.
*/
businessAwayMessageScheduleAlways#c9b9e2b9 = BusinessAwayMessageSchedule;

/*
Send [Telegram Business away messages](https://core.telegram.org/api/business#away-messages) to users writing to us in private outside of the configured [Telegram Business working hours](https://core.telegram.org/api/business#opening-hours).
*/
businessAwayMessageScheduleOutsideWorkHours#c3f2f501 = BusinessAwayMessageSchedule;

/*
Send [Telegram Business away messages](https://core.telegram.org/api/business#away-messages) to users writing to us in private in the specified time span.

@start_date Start date (UNIX timestamp).
@end_date End date (UNIX timestamp).
*/
businessAwayMessageScheduleCustom#cc4d9ecc start_date:int end_date:int = BusinessAwayMessageSchedule;

/*
Describes a [Telegram Business greeting](https://core.telegram.org/api/business#greeting-messages), automatically sent to new users writing to us in private for the first time, or after a certain inactivity period.

@shortcut_id ID of a [quick reply shorcut, containing the greeting messages to send, see here  for more info](https://core.telegram.org/api/business#quick-reply-shortcuts).
@recipients Allowed recipients for the greeting messages.
@no_activity_days The number of days after which a private chat will be considered as inactive; currently, must be one of 7, 14, 21, or 28.
*/
inputBusinessGreetingMessage#194cb3b shortcut_id:int recipients:InputBusinessRecipients no_activity_days:int = InputBusinessGreetingMessage;

/*
Describes a [Telegram Business greeting](https://core.telegram.org/api/business#greeting-messages), automatically sent to new users writing to us in private for the first time, or after a certain inactivity period.

@shortcut_id ID of a [quick reply shorcut, containing the greeting messages to send, see here  for more info](https://core.telegram.org/api/business#quick-reply-shortcuts).
@recipients Allowed recipients for the greeting messages.
@no_activity_days The number of days after which a private chat will be considered as inactive; currently, must be one of 7, 14, 21, or 28.
*/
businessGreetingMessage#e519abab shortcut_id:int recipients:BusinessRecipients no_activity_days:int = BusinessGreetingMessage;

/*
Describes a [Telegram Business away message](https://core.telegram.org/api/business#away-messages), automatically sent to users writing to us when we're offline, during closing hours, while we're on vacation, or in some other custom time period when we cannot immediately answer to the user.

@offline_only If set, the messages will not be sent if the account was online in the last 10 minutes.
@shortcut_id ID of a [quick reply shorcut, containing the away messages to send, see here  for more info](https://core.telegram.org/api/business#quick-reply-shortcuts).
@schedule Specifies when should the away messages be sent.
@recipients Allowed recipients for the away messages.
*/
inputBusinessAwayMessage#832175e0 flags:# offline_only:flags.0?true shortcut_id:int schedule:BusinessAwayMessageSchedule recipients:InputBusinessRecipients = InputBusinessAwayMessage;

/*
Describes a [Telegram Business away message](https://core.telegram.org/api/business#away-messages), automatically sent to users writing to us when we're offline, during closing hours, while we're on vacation, or in some other custom time period when we cannot immediately answer to the user.

@offline_only If set, the messages will not be sent if the account was online in the last 10 minutes.
@shortcut_id ID of a [quick reply shorcut, containing the away messages to send, see here  for more info](https://core.telegram.org/api/business#quick-reply-shortcuts).
@schedule Specifies when should the away messages be sent.
@recipients Allowed recipients for the away messages.
*/
businessAwayMessage#ef156a5c flags:# offline_only:flags.0?true shortcut_id:int schedule:BusinessAwayMessageSchedule recipients:BusinessRecipients = BusinessAwayMessage;

/*
Timezone information.

@id Unique timezone ID.
@name Human-readable and localized timezone name.
@utc_offset UTC offset in seconds, which may be displayed in hh:mm format by the client together with the human-readable name (i.e. $name UTC -01:00).
*/
timezone#ff9289f5 id:string name:string utc_offset:int = Timezone;

/*
The timezone list has not changed.
*/
help.timezonesListNotModified#970708cc = help.TimezonesList;

/*
Timezone information that may be used elsewhere in the API, such as to set [Telegram Business opening hours](https://core.telegram.org/api/business#opening-hours).

@timezones Timezones
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
*/
help.timezonesList#7b74ed71 timezones:Vector<Timezone> hash:int = help.TimezonesList;

/*
A [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts).

@shortcut_id Unique shortcut ID.
@shortcut Shortcut name.
@top_message ID of the last message in the shortcut.
@count Total number of messages in the shortcut.
*/
quickReply#697102b shortcut_id:int shortcut:string top_message:int count:int = QuickReply;

/*
Selects a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts) by name.

@shortcut Shortcut name.
*/
inputQuickReplyShortcut#24596d41 shortcut:string = InputQuickReplyShortcut;

/*
Selects a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts) by its numeric ID.

@shortcut_id Shortcut ID.
*/
inputQuickReplyShortcutId#1190cf1 shortcut_id:int = InputQuickReplyShortcut;

/*
Info about [quick reply shortcuts](https://core.telegram.org/api/business#quick-reply-shortcuts).

@quick_replies Quick reply shortcuts.
@messages Messages mentioned in quick_replies.
@chats Mentioned chats
@users Mentioned users
*/
messages.quickReplies#c68d6695 quick_replies:Vector<QuickReply> messages:Vector<Message> chats:Vector<Chat> users:Vector<User> = messages.QuickReplies;

/*
Info about [quick reply shortcuts](https://core.telegram.org/api/business#quick-reply-shortcuts) hasn't changed.
*/
messages.quickRepliesNotModified#5f91eb5b = messages.QuickReplies;

/*
Contains info about a [connected business bot](https://core.telegram.org/api/business#connected-bots).

@can_reply Whether the the bot can reply to messages it receives through the connection
@bot_id ID of the connected bot
@recipients Specifies the private chats that a [connected business bot](https://core.telegram.org/api/business#connected-bots) may receive messages and interact with.
*/
connectedBot#bd068601 flags:# can_reply:flags.0?true bot_id:long recipients:BusinessBotRecipients = ConnectedBot;

/*
Info about currently connected [business bots](https://core.telegram.org/api/business#connected-bots).

@connected_bots Info about the connected bots
@users Bot information
*/
account.connectedBots#17d7f87b connected_bots:Vector<ConnectedBot> users:Vector<User> = account.ConnectedBots;

/*
[Folder and folder tags](https://core.telegram.org/api/folders) information

@tags_enabled Whether [folder tags](https://core.telegram.org/api/folders#folder-tags) are enabled.
@filters Folders.
*/
messages.dialogFilters#2ad93719 flags:# tags_enabled:flags.0?true filters:Vector<DialogFilter> = messages.DialogFilters;

/*
[Birthday](https://core.telegram.org/api/profile#birthday) information for a user.

@day Birth day
@month Birth month
@year (Optional) birth year.
*/
birthday#6c8e1e06 flags:# day:int month:int year:flags.0?int = Birthday;

/*
Contains info about a [bot business connection](https://core.telegram.org/api/business#connected-bots).

@can_reply Whether the bot can reply on behalf of the user to messages it receives through the business connection
@disabled Whether this business connection is currently disabled
@connection_id Business connection ID, used to identify messages coming from the connection and to reply to them as specified [here](https://core.telegram.org/api/business#connected-bots).
@user_id ID of the user that the bot is connected to via this connection.
@dc_id ID of the datacenter where to send queries wrapped in a [invokeWithBusinessConnection](https://core.telegram.org/method/invokeWithBusinessConnection) as specified [here](https://core.telegram.org/api/business#connected-bots).
@date When was the connection created.
*/
botBusinessConnection#896433b4 flags:# can_reply:flags.0?true disabled:flags.1?true connection_id:string user_id:long dc_id:int date:int = BotBusinessConnection;

/*
[Telegram Business introduction](https://core.telegram.org/api/business#business-introduction).

@title Title of the introduction message
@description Profile introduction
@sticker Optional introduction [sticker](https://core.telegram.org/api/stickers).
*/
inputBusinessIntro#9c469cd flags:# title:string description:string sticker:flags.0?InputDocument = InputBusinessIntro;

/*
[Telegram Business introduction](https://core.telegram.org/api/business#business-introduction).

@title Title of the introduction message (max [intro_title_length_limit](https://core.telegram.org/api/config#intro-title-length-limit) UTF-8 characters).
@description Profile introduction (max [intro_description_length_limit](https://core.telegram.org/api/config#intro-description-length-limit) UTF-8 characters).
@sticker Optional introduction [sticker](https://core.telegram.org/api/stickers).
*/
businessIntro#5a0a066d flags:# title:string description:string sticker:flags.0?Document = BusinessIntro;

/*
The list of [stickersets owned by the current account](https://core.telegram.org/api/stickers).

@count Total number of owned stickersets.
@sets Stickersets
*/
messages.myStickers#faff629d count:int sets:Vector<StickerSetCovered> = messages.MyStickers;

/*
Represents a [username fragment collectible](https://core.telegram.org/api/fragment)

@username Username
*/
inputCollectibleUsername#e39460a9 username:string = InputCollectible;

/*
Represents a [phone number fragment collectible](https://core.telegram.org/api/fragment)

@phone Phone number
*/
inputCollectiblePhone#a2e214a4 phone:string = InputCollectible;

/*
Info about a [fragment collectible](https://core.telegram.org/api/fragment).

@purchase_date Purchase date (unixtime)
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code for amount
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@crypto_currency Cryptocurrency name.
@crypto_amount Price, in the smallest units of the cryptocurrency.
@url [Fragment](https://fragment.com) URL with more info about the collectible
*/
fragment.collectibleInfo#6ebdff91 purchase_date:int currency:string amount:long crypto_currency:string crypto_amount:long url:string = fragment.CollectibleInfo;

/*
Specifies the private chats that a [connected business bot](https://core.telegram.org/api/business#connected-bots) may interact with.

@existing_chats Selects all existing private chats.
@new_chats Selects all new private chats.
@contacts Selects all private chats with contacts.
@non_contacts Selects all private chats with non-contacts.
@exclude_selected If set, then all private chats except the ones selected by existing_chats, new_chats, contacts, non_contacts and users are chosen. Note that if this flag is set, any values passed in exclude_users will be merged and moved into users by the server.
@users Explicitly selected private chats.
@exclude_users Identifiers of private chats that are always excluded.
*/
inputBusinessBotRecipients#c4e5921e flags:# existing_chats:flags.0?true new_chats:flags.1?true contacts:flags.2?true non_contacts:flags.3?true exclude_selected:flags.5?true users:flags.4?Vector<InputUser> exclude_users:flags.6?Vector<InputUser> = InputBusinessBotRecipients;

/*
Specifies the private chats that a [connected business bot](https://core.telegram.org/api/business#connected-bots) may receive messages and interact with.

@existing_chats Selects all existing private chats.
@new_chats Selects all new private chats.
@contacts Selects all private chats with contacts.
@non_contacts Selects all private chats with non-contacts.
@exclude_selected If set, then all private chats except the ones selected by existing_chats, new_chats, contacts, non_contacts and users are chosen. Note that if this flag is set, any values passed in exclude_users will be merged and moved into users by the server, thus exclude_users will always be empty.
@users Explicitly selected private chats.
@exclude_users Identifiers of private chats that are always excluded.
*/
businessBotRecipients#b88cf373 flags:# existing_chats:flags.0?true new_chats:flags.1?true contacts:flags.2?true non_contacts:flags.3?true exclude_selected:flags.5?true users:flags.4?Vector<long> exclude_users:flags.6?Vector<long> = BusinessBotRecipients;

/*
Birthday information of a contact.

@contact_id User ID.
@birthday Birthday information.
*/
contactBirthday#1d998733 contact_id:long birthday:Birthday = ContactBirthday;

/*
Birthday information of our contacts.

@contacts Birthday info
@users User information
*/
contacts.contactBirthdays#114ff30d contacts:Vector<ContactBirthday> users:Vector<User> = contacts.ContactBirthdays;

/*
Info about why a specific user could not be [invited](https://core.telegram.org/api/invites#direct-invites).

@premium_would_allow_invite If set, we could not add the user only because the current account needs to purchase a [Telegram Premium](https://core.telegram.org/api/premium) subscription to complete the operation.
@premium_required_for_pm If set, we could not add the user because of their privacy settings, and additionally, the current account needs to purchase a [Telegram Premium](https://core.telegram.org/api/premium) subscription to directly share an invite link with the user via a private message.
@user_id ID of the user. If neither of the flags below are set, we could not add the user because of their privacy settings, and we can create and directly share an [invite link](https://core.telegram.org/api/invites#invite-links) with them using a normal message, instead.
*/
missingInvitee#628c9224 flags:# premium_would_allow_invite:flags.0?true premium_required_for_pm:flags.1?true user_id:long = MissingInvitee;

/*
Contains info about successfully or unsuccessfully [invited](https://core.telegram.org/api/invites#direct-invites) users.

@updates List of updates about successfully invited users (and eventually info about the created group)
@missing_invitees A list of users that could not be invited, along with the reason why they couldn't be invited.
*/
messages.invitedUsers#7f5defa6 updates:Updates missing_invitees:Vector<MissingInvitee> = messages.InvitedUsers;

/*
Contains info about a [business chat deep link](https://core.telegram.org/api/business#business-chat-links) to be created by the current account.

@message Message to pre-fill in the message input field.
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@title Human-readable name of the link, to simplify management in the UI (only visible to the creator of the link).
*/
inputBusinessChatLink#11679fa7 flags:# message:string entities:flags.0?Vector<MessageEntity> title:flags.1?string = InputBusinessChatLink;

/*
Contains info about a [business chat deep link](https://core.telegram.org/api/business#business-chat-links) created by the current account.

@link [Business chat deep link](https://core.telegram.org/api/links#business-chat-links).
@message Message to pre-fill in the message input field.
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@title Human-readable name of the link, to simplify management in the UI (only visible to the creator of the link).
@views Number of times the link was resolved (clicked/scanned/etc...).
*/
businessChatLink#b4ae666f flags:# link:string message:string entities:flags.0?Vector<MessageEntity> title:flags.1?string views:int = BusinessChatLink;

/*
Contains info about [business chat deep links](https://core.telegram.org/api/business#business-chat-links) created by the current account.

@links Links
@chats Mentioned chats
@users Mentioned users
*/
account.businessChatLinks#ec43a2d1 links:Vector<BusinessChatLink> chats:Vector<Chat> users:Vector<User> = account.BusinessChatLinks;

/*
Contains info about a single resolved [business chat deep link](https://core.telegram.org/api/business#business-chat-links).

@peer Destination peer
@message Message to pre-fill in the message input field.
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@chats Mentioned chats
@users Mentioned users
*/
account.resolvedBusinessChatLinks#9a23af21 flags:# peer:Peer message:string entities:flags.0?Vector<MessageEntity> chats:Vector<Chat> users:Vector<User> = account.ResolvedBusinessChatLinks;

/*
Info about a user, shared by a user with the currently logged in bot using [messages.sendBotRequestedPeer](https://core.telegram.org/method/messages.sendBotRequestedPeer).

@user_id User ID.
@first_name First name.
@last_name Last name.
@username Username.
@photo Profile photo.
*/
requestedPeerUser#d62ff46a flags:# user_id:long first_name:flags.0?string last_name:flags.0?string username:flags.1?string photo:flags.2?Photo = RequestedPeer;

/*
Info about a [chat](https://core.telegram.org/api/channel), shared by a user with the currently logged in bot using [messages.sendBotRequestedPeer](https://core.telegram.org/method/messages.sendBotRequestedPeer).

@chat_id Chat ID.
@title Chat title.
@photo Chat photo.
*/
requestedPeerChat#7307544f flags:# chat_id:long title:flags.0?string photo:flags.2?Photo = RequestedPeer;

/*
Info about a [channel/supergroup](https://core.telegram.org/api/channel), shared by a user with the currently logged in bot using [messages.sendBotRequestedPeer](https://core.telegram.org/method/messages.sendBotRequestedPeer).

@channel_id Channel/supergroup ID.
@title Channel/supergroup title.
@username Channel/supergroup username.
@photo Channel/supergroup photo.
*/
requestedPeerChannel#8ba403e4 flags:# channel_id:long title:flags.0?string username:flags.1?string photo:flags.2?Photo = RequestedPeer;

/*
A [report option for a sponsored message](https://core.telegram.org/api/sponsored-messages#reporting-sponsored-messages).

@text Localized description of the option.
@option Option identifier to pass to [channels.reportSponsoredMessage](https://core.telegram.org/method/channels.reportSponsoredMessage).
*/
sponsoredMessageReportOption#430d3150 text:string option:bytes = SponsoredMessageReportOption;

/*
The user must choose a report option from the localized options available in options, and after selection, [channels.reportSponsoredMessage](https://core.telegram.org/method/channels.reportSponsoredMessage) must be invoked again, passing the option's option field to the option param of the method.

@title Title of the option selection popup.
@options Localized list of options.
*/
channels.sponsoredMessageReportResultChooseOption#846f9e42 title:string options:Vector<SponsoredMessageReportOption> = channels.SponsoredMessageReportResult;

/*
Sponsored messages were hidden for the user in all chats.
*/
channels.sponsoredMessageReportResultAdsHidden#3e3bcf2f = channels.SponsoredMessageReportResult;

/*
The sponsored message was reported successfully.
*/
channels.sponsoredMessageReportResultReported#ad798849 = channels.SponsoredMessageReportResult;

/*
[Channel revenue ad statistics, see here](https://core.telegram.org/api/revenue) for more info.

@top_hours_graph Ad impressions graph
@revenue_graph Ad revenue graph (in the smallest unit of the cryptocurrency in which revenue is calculated)
@balances Current balance, current withdrawable balance and overall revenue
@usd_rate Current conversion rate of the cryptocurrency ( not in the smallest unit) in which revenue is calculated to USD
*/
stats.broadcastRevenueStats#5407e297 top_hours_graph:StatsGraph revenue_graph:StatsGraph balances:BroadcastRevenueBalances usd_rate:double = stats.BroadcastRevenueStats;

/*
Contains the URL to use to [withdraw channel ad revenue](https://core.telegram.org/api/revenue#withdrawing-revenue).

@url A unique URL to a Fragment page where the user will be able to specify and submit the address of the TON wallet where the funds will be sent.
*/
stats.broadcastRevenueWithdrawalUrl#ec659737 url:string = stats.BroadcastRevenueWithdrawalUrl;

/*
Describes earnings from sponsored messages in a channel in some time frame, see [here](https://core.telegram.org/api/revenue) for more info.

@amount Amount in the smallest unit of the cryptocurrency.
@from_date Start unixtime for the timeframe.
@to_date End unixtime for the timeframe.
*/
broadcastRevenueTransactionProceeds#557e2cc4 amount:long from_date:int to_date:int = BroadcastRevenueTransaction;

/*
Describes a [withdrawal of ad earnings](https://core.telegram.org/api/revenue#withdrawing-revenue)

@pending Whether the withdrawal is currently pending
@failed Whether the withdrawal has failed
@amount Amount withdrawn
@date Withdrawal date
@provider Payment provider name
@transaction_date If neither pending nor failed are set, the transaction was completed successfully, and this field will contain the point in time (Unix timestamp) when the withdrawal was completed successfully.
@transaction_url If neither pending nor failed are set, the transaction was completed successfully, and this field will contain a URL where the withdrawal transaction can be viewed.
*/
broadcastRevenueTransactionWithdrawal#5a590978 flags:# pending:flags.0?true failed:flags.2?true amount:long date:int provider:string transaction_date:flags.1?int transaction_url:flags.1?string = BroadcastRevenueTransaction;

/*
Describes a [refund for failed withdrawal of ad earnings](https://core.telegram.org/api/revenue#withdrawing-revenue)

@amount Amount refunded.
@date Date of refund.
@provider Payment provider name.
*/
broadcastRevenueTransactionRefund#42d30d2e amount:long date:int provider:string = BroadcastRevenueTransaction;

/*
[Channel ad revenue transactions](https://core.telegram.org/api/revenue).

@count Total number of transactions.
@transactions Transactions
*/
stats.broadcastRevenueTransactions#87158466 count:int transactions:Vector<BroadcastRevenueTransaction> = stats.BroadcastRevenueTransactions;

/*
Receive notifications about reactions made only by our contacts.
*/
reactionNotificationsFromContacts#bac3a61a = ReactionNotificationsFrom;

/*
Receive notifications about reactions made by any user.
*/
reactionNotificationsFromAll#4b9e22a0 = ReactionNotificationsFrom;

/*
Reaction notification settings, see [here](https://core.telegram.org/api/reactions#notifications-about-reactions) for more info.

@messages_notify_from Message reaction notification settings, if not set completely disables notifications/updates about message reactions.
@stories_notify_from Story reaction notification settings, if not set completely disables notifications/updates about reactions to stories.
@sound [Notification sound for reactions](https://core.telegram.org/api/ringtones)
@show_previews If false, [push notifications](https://core.telegram.org/api/push-updates) about message/story reactions will only be of type REACT_HIDDEN/ REACT_STORY_HIDDEN, without any information about the reacted-to story or the reaction itself.
*/
reactionsNotifySettings#56e34970 flags:# messages_notify_from:flags.0?ReactionNotificationsFrom stories_notify_from:flags.1?ReactionNotificationsFrom sound:NotificationSound show_previews:Bool = ReactionsNotifySettings;

/*
Describes [channel ad revenue balances](https://core.telegram.org/api/revenue).

@withdrawal_enabled If set, the available balance can be [withdrawn](https://core.telegram.org/api/revenue#withdrawing-revenue).
@current_balance Amount of not-yet-withdrawn cryptocurrency.
@available_balance Amount of withdrawable cryptocurrency, out of the currently available balance ( available_balance <= current_balance).
@overall_revenue Total amount of earned cryptocurrency.
*/
broadcastRevenueBalances#c3ff71e7 flags:# withdrawal_enabled:flags.0?true current_balance:long available_balance:long overall_revenue:long = BroadcastRevenueBalances;

/*
Represents a [message effect](https://core.telegram.org/api/effects).

@premium_required Whether a [Premium](https://core.telegram.org/api/premium) subscription is required to use this effect.
@id Unique effect ID.
@emoticon Emoji corresponding to the effect, to be used as icon for the effect if static_icon_id is not set.
@static_icon_id ID of the document containing the static icon (WEBP) of the effect.
@effect_sticker_id Contains the preview [animation (TGS format )](https://core.telegram.org/api/stickers#animated-stickers), used for the effect selection menu.
@effect_animation_id If set, contains the actual animated effect [(TGS format )](https://core.telegram.org/api/stickers#animated-stickers). If not set, the animated effect must be set equal to the [premium animated sticker effect](https://core.telegram.org/api/stickers#premium-animated-sticker-effects) associated to the animated sticker specified in effect_sticker_id (always different from the preview animation, fetched thanks to the [videoSize](https://core.telegram.org/constructor/videoSize) of type f as specified [here](https://core.telegram.org/api/stickers#premium-animated-sticker-effects)).
*/
availableEffect#93c3e27e flags:# premium_required:flags.2?true id:long emoticon:string static_icon_id:flags.0?long effect_sticker_id:long effect_animation_id:flags.1?long = AvailableEffect;

/*
The full list of usable [animated message effects](https://core.telegram.org/api/effects) hasn't changed.
*/
messages.availableEffectsNotModified#d1ed9a5b = messages.AvailableEffects;

/*
The full list of usable [animated message effects](https://core.telegram.org/api/effects).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@effects Message effects
@documents Documents specified in the effects constructors.
*/
messages.availableEffects#bddb616e hash:int effects:Vector<AvailableEffect> documents:Vector<Document> = messages.AvailableEffects;

/*
Represents a [fact-check](https://core.telegram.org/api/factcheck) created by an independent fact-checker.

@need_check If set, the country/ text fields will not be set, and the fact check must be fetched manually by the client (if it isn't already cached with the key specified in hash) using bundled [messages.getFactCheck](https://core.telegram.org/method/messages.getFactCheck) requests, when the message with the factcheck scrolls into view.
@country A two-letter ISO 3166-1 alpha-2 country code of the country for which the fact-check should be shown.
@text The fact-check.
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
*/
factCheck#b89bfccf flags:# need_check:flags.0?true country:flags.1?string text:flags.1?TextWithEntities hash:long = FactCheck;

/*
Describes a [Telegram Star](https://core.telegram.org/api/stars) transaction that cannot be described using the current layer.
*/
starsTransactionPeerUnsupported#95f2bfe4 = StarsTransactionPeer;

/*
Describes a [Telegram Star](https://core.telegram.org/api/stars) transaction with the App Store, used when purchasing Telegram Stars through the App Store.
*/
starsTransactionPeerAppStore#b457b375 = StarsTransactionPeer;

/*
Describes a [Telegram Star](https://core.telegram.org/api/stars) transaction with the Play Store, used when purchasing Telegram Stars through the Play Store.
*/
starsTransactionPeerPlayMarket#7b560a0b = StarsTransactionPeer;

/*
Describes a [Telegram Star](https://core.telegram.org/api/stars) transaction made using [@PremiumBot](https://t.me/premiumbot) (i.e. using the [inputInvoiceStars](https://core.telegram.org/constructor/inputInvoiceStars) flow described [here](https://core.telegram.org/api/stars#buying-or-gifting-stars)).
*/
starsTransactionPeerPremiumBot#250dbaf8 = StarsTransactionPeer;

/*
Describes a [Telegram Star](https://core.telegram.org/api/stars) transaction with [Fragment](https://fragment.com), used when purchasing Telegram Stars through [Fragment](https://fragment.com).
*/
starsTransactionPeerFragment#e92fd902 = StarsTransactionPeer;

/*
Describes a [Telegram Star](https://core.telegram.org/api/stars) transaction with another peer.

@peer The peer.
*/
starsTransactionPeer#d80da15d peer:Peer = StarsTransactionPeer;

/*
Describes a [Telegram Star](https://core.telegram.org/api/stars) transaction used to pay for [Telegram ads as specified here](https://core.telegram.org/api/stars#paying-for-ads).
*/
starsTransactionPeerAds#60682812 = StarsTransactionPeer;

/*
Describes a [Telegram Star](https://core.telegram.org/api/stars) transaction used to pay for paid API usage, such as [paid bot broadcasts](https://core.telegram.org/bots/faq#how-can-i-message-all-of-my-bot-39s-subscribers-at-once).
*/
starsTransactionPeerAPI#f9677aad = StarsTransactionPeer;

/*
[Telegram Stars topup option](https://core.telegram.org/api/stars).

@extended If set, the option must only be shown in the full list of topup options.
@stars Amount of Telegram stars.
@store_product Identifier of the store product associated with the option, official apps only.
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Price of the product in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
*/
starsTopupOption#bd915c0 flags:# extended:flags.1?true stars:long store_product:flags.0?string currency:string amount:long = StarsTopupOption;

/*
Represents a [Telegram Stars transaction](https://core.telegram.org/api/stars).

@refund Whether this transaction is a refund.
@pending The transaction is currently pending.
@failed This transaction has failed.
@gift This transaction was a gift from the user in peer.peer.
@reaction This transaction is a [paid reaction](https://core.telegram.org/api/reactions#paid-reactions).
@stargift_upgrade  ... 
@id Transaction ID.
@stars Amount of Stars (negative for outgoing transactions).
@date Date of the transaction (unixtime).
@peer Source of the incoming transaction, or its recipient for outgoing transactions.
@title For transactions with bots, title of the bought product.
@description For transactions with bots, description of the bought product.
@photo For transactions with bots, photo of the bought product.
@transaction_date If neither pending nor failed are set, the transaction was completed successfully, and this field will contain the point in time (Unix timestamp) when the withdrawal was completed successfully.
@transaction_url If neither pending nor failed are set, the transaction was completed successfully, and this field will contain a URL where the withdrawal transaction can be viewed.
@bot_payload Bot specified invoice payload (i.e. the payload passed to [inputMediaInvoice](https://core.telegram.org/constructor/inputMediaInvoice) when [creating the invoice](https://core.telegram.org/api/payments)).
@msg_id For [paid media transactions](https://core.telegram.org/api/paid-media), message ID of the paid media posted to peer.peer (can point to a deleted message; either way, extended_media will always contain the bought media).
@extended_media The purchased [paid media](https://core.telegram.org/api/paid-media).
@subscription_period The number of seconds between consecutive Telegram Star debiting for [Telegram Star subscriptions](https://core.telegram.org/api/stars#star-subscriptions).
@giveaway_post_id ID of the message containing the [messageMediaGiveaway](https://core.telegram.org/constructor/messageMediaGiveaway), for incoming [star giveaway prizes](https://core.telegram.org/api/giveaways#star-giveaways).
@stargift This transaction indicates a purchase or a sale (conversion back to Stars) of a [gift](https://core.telegram.org/api/stars).
@floodskip_number This transaction is payment for [paid bot broadcasts](https://core.telegram.org/bots/faq#how-can-i-message-all-of-my-bot-39s-subscribers-at-once).  Paid broadcasts are only allowed if the allow_paid_floodskip parameter of [messages.sendMessage](https://core.telegram.org/method/messages.sendMessage) and other message sending methods is set while trying to broadcast more than 30 messages per second to bot users. The integer value returned by this flag indicates the number of billed API calls.
@starref_commission_permille This transaction is the receival (or refund) of an [affiliate commission](https://core.telegram.org/api/bots/referrals) (i.e. this is the transaction received by the peer that created the [referral link](https://core.telegram.org/api/links#referral-links), flag 17 is for transactions made by users that imported the referral link).
@starref_peer For transactions made by [referred users](https://core.telegram.org/api/bots/referrals), the peer that received the affiliate commission.
@starref_amount For transactions made by [referred users](https://core.telegram.org/api/bots/referrals), the amount of Telegram Stars received by the affiliate, can be negative for refunds.

#DocError
*/
starsTransaction#64dfc926 flags:# refund:flags.3?true pending:flags.4?true failed:flags.6?true gift:flags.10?true reaction:flags.11?true stargift_upgrade:flags.18?true id:string stars:StarsAmount date:int peer:StarsTransactionPeer title:flags.0?string description:flags.1?string photo:flags.2?WebDocument transaction_date:flags.5?int transaction_url:flags.5?string bot_payload:flags.7?bytes msg_id:flags.8?int extended_media:flags.9?Vector<MessageMedia> subscription_period:flags.12?int giveaway_post_id:flags.13?int stargift:flags.14?StarGift floodskip_number:flags.15?int starref_commission_permille:flags.16?int starref_peer:flags.17?Peer starref_amount:flags.17?StarsAmount = StarsTransaction;

/*
Info about the current [Telegram Star subscriptions, balance and transaction history](https://core.telegram.org/api/stars#balance-and-transaction-history).

@balance Current Telegram Star balance.
@subscriptions Info about current Telegram Star subscriptions, only returned when invoking [payments.getStarsTransactions](https://core.telegram.org/method/payments.getStarsTransactions) and [payments.getStarsSubscriptions](https://core.telegram.org/method/payments.getStarsSubscriptions).
@subscriptions_next_offset Offset for pagination of subscriptions: only usable and returned when invoking [payments.getStarsSubscriptions](https://core.telegram.org/method/payments.getStarsSubscriptions).
@subscriptions_missing_balance The number of Telegram Stars the user should buy to be able to extend expired subscriptions soon (i.e. the current balance is not enough to extend all expired subscriptions).
@history List of Telegram Star transactions (partial if next_offset is set).
@next_offset Offset to use to fetch more transactions from the transaction history using [payments.getStarsTransactions](https://core.telegram.org/method/payments.getStarsTransactions).
@chats Chats mentioned in history.
@users Users mentioned in history.
*/
payments.starsStatus#6c9ce8ed flags:# balance:StarsAmount subscriptions:flags.1?Vector<StarsSubscription> subscriptions_next_offset:flags.2?string subscriptions_missing_balance:flags.4?long history:flags.3?Vector<StarsTransaction> next_offset:flags.0?string chats:Vector<Chat> users:Vector<User> = payments.StarsStatus;

/*
A story found using [global story search](https://core.telegram.org/api/stories#searching-stories).

@peer The peer that posted the story.
@story The story.
*/
foundStory#e87acbc0 peer:Peer story:StoryItem = FoundStory;

/*
Stories found using [global story search](https://core.telegram.org/api/stories#searching-stories).

@count Total number of results found for the query.
@stories Matching stories.
@next_offset Offset used to fetch the next page, if not set this is the final page.
@chats Mentioned chats
@users Mentioned users
*/
stories.foundStories#e2de7737 flags:# count:int stories:Vector<FoundStory> next_offset:flags.0?string chats:Vector<Chat> users:Vector<User> = stories.FoundStories;

/*
Address optionally associated to a [geoPoint](https://core.telegram.org/constructor/geoPoint).

@country_iso2 Two-letter ISO 3166-1 alpha-2 country code
@state State
@city City
@street Street
*/
geoPointAddress#de4c5d93 flags:# country_iso2:string state:flags.0?string city:flags.1?string street:flags.2?string = GeoPointAddress;

/*
Describes [Telegram Star revenue balances](https://core.telegram.org/api/stars).

@withdrawal_enabled If set, the user may [withdraw](https://core.telegram.org/api/stars#withdrawing-stars) up to available_balance stars.
@current_balance Amount of not-yet-withdrawn Telegram Stars.
@available_balance Amount of withdrawable Telegram Stars.
@overall_revenue Total amount of earned Telegram Stars.
@next_withdrawal_at Unixtime indicating when will withdrawal be available to the user. If not set, withdrawal can be started now.
*/
starsRevenueStatus#febe5491 flags:# withdrawal_enabled:flags.0?true current_balance:StarsAmount available_balance:StarsAmount overall_revenue:StarsAmount next_withdrawal_at:flags.1?int = StarsRevenueStatus;

/*
[Star revenue statistics, see here](https://core.telegram.org/api/stars) for more info.

@revenue_graph Star revenue graph (number of earned stars)
@status Current balance, current withdrawable balance and overall earned Telegram Stars
@usd_rate Current conversion rate of Telegram Stars to USD
*/
payments.starsRevenueStats#c92bb73b revenue_graph:StatsGraph status:StarsRevenueStatus usd_rate:double = payments.StarsRevenueStats;

/*
Contains the URL to use to [withdraw Telegram Star revenue](https://core.telegram.org/api/stars#withdrawing-stars).

@url Contains the URL to use to [withdraw Telegram Star revenue](https://core.telegram.org/api/stars#withdrawing-stars).
*/
payments.starsRevenueWithdrawalUrl#1dab80b7 url:string = payments.StarsRevenueWithdrawalUrl;

/*
Contains a URL leading to a page where the user will be able to place ads for the channel/bot, paying using [Telegram Stars](https://core.telegram.org/api/stars#paying-for-ads).

@url URL to open.
*/
payments.starsRevenueAdsAccountUrl#394e7f21 url:string = payments.StarsRevenueAdsAccountUrl;

/*
Used to fetch info about a [Telegram Star transaction](https://core.telegram.org/api/stars#balance-and-transaction-history).

@refund If set, fetches info about the refund transaction for this transaction.
@id Transaction ID.
*/
inputStarsTransaction#206ae6d1 flags:# refund:flags.0?true id:string = InputStarsTransaction;

/*
[Telegram Stars gift option](https://core.telegram.org/api/stars#buying-or-gifting-stars).

@extended If set, the option must only be shown in the full list of topup options.
@stars Amount of Telegram stars.
@store_product Identifier of the store product associated with the option, official apps only.
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Price of the product in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
*/
starsGiftOption#5e0589f1 flags:# extended:flags.1?true stars:long store_product:flags.0?string currency:string amount:long = StarsGiftOption;

/*
Popular [Main Mini Apps](https://core.telegram.org/api/bots/webapps#main-mini-apps), to be used in the [apps tab of global search](https://core.telegram.org/api/search#apps-tab).

@next_offset Offset for [pagination](https://core.telegram.org/api/offsets).
@users The bots associated to each [Main Mini App, see here](https://core.telegram.org/api/bots/webapps#main-mini-apps) for more info.
*/
bots.popularAppBots#1991b13b flags:# next_offset:flags.0?string users:Vector<User> = bots.PopularAppBots;

/*
Represents a [Main Mini App preview media, see here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews) for more info.

@date When was this media last updated.
@media The actual photo/video.
*/
botPreviewMedia#23e91ba3 date:int media:MessageMedia = BotPreviewMedia;

/*
Contains info about [Main Mini App previews, see here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews) for more info.

@media All preview medias for the language code passed to [bots.getPreviewInfo](https://core.telegram.org/method/bots.getPreviewInfo).
@lang_codes All available language codes for which preview medias were uploaded (regardless of the language code passed to [bots.getPreviewInfo](https://core.telegram.org/method/bots.getPreviewInfo)).
*/
bots.previewInfo#ca71d64 media:Vector<BotPreviewMedia> lang_codes:Vector<string> = bots.PreviewInfo;

/*
Pricing of a [Telegram Star subscription](https://core.telegram.org/api/invites#paid-invite-links).

@period The user should pay amount stars every period seconds to gain and maintain access to the channel. Currently the only allowed subscription period is 30*24*60*60, i.e. the user will be debited amount stars every month.
@amount Price of the subscription in Telegram Stars.
*/
starsSubscriptionPricing#5416d58 period:int amount:long = StarsSubscriptionPricing;

/*
Represents a [Telegram Star subscription](https://core.telegram.org/api/invites#paid-invite-links).

@canceled Whether this subscription was cancelled.
@can_refulfill Whether we left the associated private channel, but we can still rejoin it using [payments.fulfillStarsSubscription](https://core.telegram.org/method/payments.fulfillStarsSubscription) because the current subscription period hasn't expired yet.
@missing_balance Whether this subscription has expired because there are not enough stars on the user's balance to extend it.
@bot_canceled Set if this [bot subscription](https://core.telegram.org/api/subscriptions#bot-subscriptions) was cancelled by the bot
@id Subscription ID.
@peer Identifier of the associated private chat.
@until_date Expiration date of the current subscription period.
@pricing Pricing of the subscription in Telegram Stars.
@chat_invite_hash Invitation link, used to renew the subscription after cancellation or expiration.
@title For bot subscriptions, the title of the subscription invoice
@photo For bot subscriptions, the photo from the subscription invoice
@invoice_slug For bot subscriptions, the [identifier](https://core.telegram.org/api/links#invoice-links) of the subscription invoice
*/
starsSubscription#2e6eab1a flags:# canceled:flags.0?true can_refulfill:flags.1?true missing_balance:flags.2?true bot_canceled:flags.7?true id:string peer:Peer until_date:int pricing:StarsSubscriptionPricing chat_invite_hash:flags.3?string title:flags.4?string photo:flags.5?WebDocument invoice_slug:flags.6?string = StarsSubscription;

/*
Info about a user in the [paid Star reactions leaderboard](https://core.telegram.org/api/reactions#paid-reactions) for a message.

@top If set, the reactor is one of the most active reactors; may be unset if the reactor is the current user.
@my If set, this reactor is the current user.
@anonymous If set, the reactor is anonymous.
@peer_id Identifier of the peer that reacted: may be unset for anonymous reactors different from the current user (i.e. if the current user sent an anonymous reaction anonymous will be set but this field will also be set).
@count The number of sent Telegram Stars.
*/
messageReactor#4ba3a95a flags:# top:flags.0?true my:flags.1?true anonymous:flags.2?true peer_id:flags.3?Peer count:int = MessageReactor;

/*
Contains info about a [Telegram Star giveaway](https://core.telegram.org/api/giveaways#star-giveaways) option.

@extended If set, this option must only be shown in the full list of giveaway options (i.e. they must be added to the list only when the user clicks on the expand button).
@default If set, this option must be pre-selected by default in the option list.
@stars The number of Telegram Stars that will be distributed among winners
@yearly_boosts Number of times the chat will be boosted for one year if the [inputStorePaymentStarsGiveaway](https://core.telegram.org/constructor/inputStorePaymentStarsGiveaway). boost_peer flag is populated
@store_product Identifier of the store product associated with the option, official apps only.
@currency Three-letter ISO 4217 [currency](https://core.telegram.org/bots/payments#supported-currencies) code
@amount Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
@winners Allowed options for the number of giveaway winners.
*/
starsGiveawayOption#94ce852a flags:# extended:flags.0?true default:flags.1?true stars:long yearly_boosts:int store_product:flags.2?string currency:string amount:long winners:Vector<StarsGiveawayWinnersOption> = StarsGiveawayOption;

/*
Allowed options for the number of giveaway winners.

@default If set, this option must be pre-selected by default in the option list.
@users The number of users that will be randomly chosen as winners.
@per_user_stars The number of [Telegram Stars](https://core.telegram.org/api/stars) each winner will receive.
*/
starsGiveawayWinnersOption#54236209 flags:# default:flags.0?true users:int per_user_stars:long = StarsGiveawayWinnersOption;

/*
Represents a [star gift, see here](https://core.telegram.org/api/gifts) for more info.

@limited Whether this is a limited-supply gift.
@sold_out Whether this gift sold out and cannot be bought anymore.
@birthday Whether this is a birthday-themed gift
@id Identifier of the gift
@sticker [Sticker](https://core.telegram.org/api/stickers) that represents the gift.
@stars Price of the gift in [Telegram Stars](https://core.telegram.org/api/stars).
@availability_remains For limited-supply gifts: the remaining number of gifts that may be bought.
@availability_total For limited-supply gifts: the total number of gifts that was available in the initial supply.
@convert_stars The receiver of this gift may convert it to this many Telegram Stars, instead of displaying it on their profile page. convert_stars will be equal to stars only if the gift was bought using recently bought Telegram Stars, otherwise it will be less than stars.
@first_sale_date For sold out gifts only: when was the gift first bought.
@last_sale_date For sold out gifts only: when was the gift last bought.
@upgrade_stars  ... 

#DocError
*/
starGift#2cc73c8 flags:# limited:flags.0?true sold_out:flags.1?true birthday:flags.2?true id:long sticker:Document stars:long availability_remains:flags.0?int availability_total:flags.0?int convert_stars:long first_sale_date:flags.1?int last_sale_date:flags.1?int upgrade_stars:flags.3?long = StarGift;

starGiftUnique#5c62d151 flags:# id:long title:string slug:string num:int owner_id:flags.0?Peer owner_name:flags.1?string owner_address:flags.2?string attributes:Vector<StarGiftAttribute> availability_issued:int availability_total:int gift_address:flags.3?string = StarGift;
/*
The list of available [gifts](https://core.telegram.org/api/gifts) hasn't changed.
*/
payments.starGiftsNotModified#a388a368 = payments.StarGifts;

/*
Available [gifts](https://core.telegram.org/api/gifts).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@gifts List of available gifts.
*/
payments.starGifts#901689ea hash:int gifts:Vector<StarGift> = payments.StarGifts;

/*
Report menu option

@text Option title
@option Option identifier: if the user selects this option, re-invoke [messages.report](https://core.telegram.org/method/messages.report), passing this option to option
*/
messageReportOption#7903e3d9 text:string option:bytes = MessageReportOption;

/*
The user must choose one of the following options, and then [messages.report](https://core.telegram.org/method/messages.report) must be re-invoked, passing the option's option identifier to [messages.report](https://core.telegram.org/method/messages.report). option.

@title Title of the option popup
@options Available options, rendered as menu entries.
*/
reportResultChooseOption#f0e4e0b6 title:string options:Vector<MessageReportOption> = ReportResult;

/*
The user should enter an additional comment for the moderators, and then [messages.report](https://core.telegram.org/method/messages.report) must be re-invoked, passing the comment to [messages.report](https://core.telegram.org/method/messages.report). message.

@optional Whether this step can be skipped by the user, passing an empty message to [messages.report](https://core.telegram.org/method/messages.report), or if a non-empty message is mandatory.
@option The [messages.report](https://core.telegram.org/method/messages.report) method must be re-invoked, passing this option to option
*/
reportResultAddComment#6f09ac31 flags:# optional:flags.0?true option:bytes = ReportResult;

/*
The report was sent successfully, no further actions are required.
*/
reportResultReported#8db33c4b = ReportResult;

/*
Represents a [prepared inline message saved by a bot, to be sent to the user via a web app](https://core.telegram.org/api/bots/inline#21-using-a-prepared-inline-message)

@id The ID of the saved message, to be passed to the id field of the [web_app_send_prepared_message event](https://core.telegram.org/api/web-events#web-app-send-prepared-message)
@expire_date Expiration date of the message
*/
messages.botPreparedInlineMessage#8ecf0511 id:string expire_date:int = messages.BotPreparedInlineMessage;

/*
Represents a [prepared inline message received via a bot's mini app, that can be sent to some chats](https://core.telegram.org/api/bots/inline#21-using-a-prepared-inline-message)

@query_id The query_id to pass to [messages.sendInlineBotResult](https://core.telegram.org/method/messages.sendInlineBotResult)
@result The contents of the message, to be shown in a preview
@peer_types Types of chats where this message can be sent
@cache_time Caching validity of the results
@users Users mentioned in the results
*/
messages.preparedInlineMessage#ff57708d query_id:long result:BotInlineResult peer_types:Vector<InlineQueryPeerType> cache_time:int users:Vector<User> = messages.PreparedInlineMessage;

/*
[Mini app](https://core.telegram.org/api/bots/webapps) settings

@placeholder_path SVG placeholder logo, compressed using the same format used for [vector thumbnails](https://core.telegram.org/api/files#vector-thumbnails).
@background_color Default light mode background color
@background_dark_color Default dark mode background color
@header_color Default light mode header color
@header_dark_color Default dark mode header color
*/
botAppSettings#c99b1950 flags:# placeholder_path:flags.0?bytes background_color:flags.1?int background_dark_color:flags.2?int header_color:flags.3?int header_dark_color:flags.4?int = BotAppSettings;

/*
Indo about an [affiliate program offered by a bot](https://core.telegram.org/api/bots/referrals)

@bot_id ID of the bot that offers the program
@commission_permille An affiliate gets a commission of [starRefProgram](https://core.telegram.org/constructor/starRefProgram). commission_permille‰ [Telegram Stars](https://core.telegram.org/api/stars) for every mini app transaction made by users they refer
@duration_months An affiliate gets a commission for every mini app transaction made by users they refer, for duration_months months after a referral link is imported, starting the bot for the first time
@end_date Point in time (Unix timestamp) when the affiliate program will be closed (optional, if not set the affiliate program isn't scheduled to be closed)
@daily_revenue_per_user The amount of daily revenue per user in Telegram Stars of the bot that created the affiliate program. To obtain the approximated revenue per referred user, multiply this value by commission_permille and divide by 1000.
*/
starRefProgram#dd0c66f2 flags:# bot_id:long commission_permille:int duration_months:flags.0?int end_date:flags.1?int daily_revenue_per_user:flags.2?StarsAmount = StarRefProgram;

/*
Info about an [active affiliate program we have with a Mini App](https://core.telegram.org/api/bots/referrals#becoming-an-affiliate)

@revoked If set, this affiliation was revoked by the affiliate using [payments.editConnectedStarRefBot](https://core.telegram.org/method/payments.editConnectedStarRefBot), or by the affiliation program owner using [bots.updateStarRefProgram](https://core.telegram.org/method/bots.updateStarRefProgram)
@url [Referral link](https://core.telegram.org/api/links#referral-links) to be shared
@date When did we affiliate with bot_id
@bot_id ID of the mini app that created the affiliate program
@commission_permille The number of Telegram Stars received by the affiliate for each 1000 Telegram Stars received by bot_id
@duration_months Number of months the program will be active; if not set, there is no expiration date.
@participants The number of users that used the affiliate program
@revenue The number of Telegram Stars that were earned by the affiliate program
*/
connectedBotStarRef#19a13f71 flags:# revoked:flags.1?true url:string date:int bot_id:long commission_permille:int duration_months:flags.0?int participants:long revenue:long = ConnectedBotStarRef;

/*
Active [affiliations](https://core.telegram.org/api/bots/referrals#becoming-an-affiliate)

@count Total number of active affiliations
@connected_bots The affiliations
@users Peers mentioned in connected_bots
*/
payments.connectedStarRefBots#98d5ea1d count:int connected_bots:Vector<ConnectedBotStarRef> users:Vector<User> = payments.ConnectedStarRefBots;

/*
A list of suggested [mini apps](https://core.telegram.org/api/bots/webapps) with available [affiliate programs](https://core.telegram.org/api/bots/referrals)

@count Total number of results (for pagination)
@suggested_bots Suggested affiliate programs (full or partial list to be fetched using pagination)
@users Peers mentioned in suggested_bots
@next_offset Next offset for [pagination](https://core.telegram.org/api/offsets)
*/
payments.suggestedStarRefBots#b4d5d859 flags:# count:int suggested_bots:Vector<StarRefProgram> users:Vector<User> next_offset:flags.0?string = payments.SuggestedStarRefBots;

/*
Describes a real (i.e. possibly decimal) amount of [Telegram Stars](https://core.telegram.org/api/stars).

@amount The integer amount of Telegram Stars.
@nanos The decimal amount of Telegram Stars, expressed as nanostars (i.e. 1 nanostar is equal to 1/1'000'000'000th of a Telegram Star). This field may also be negative (the allowed range is -999999999 to 999999999).
*/
starsAmount#bbb6b4a3 amount:long nanos:int = StarsAmount;

/*
No new stickers were found for the specified query

@next_offset Offset for [pagination](https://core.telegram.org/api/offsets)
*/
messages.foundStickersNotModified#6010c534 flags:# next_offset:flags.0?int = messages.FoundStickers;

/*
Found stickers

@next_offset Offset for [pagination](https://core.telegram.org/api/offsets)
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
@stickers Found stickers
*/
messages.foundStickers#82c9e290 flags:# next_offset:flags.0?int hash:long stickers:Vector<Document> = messages.FoundStickers;

botVerifierSettings#b0cd6617 flags:# can_modify_custom_description:flags.1?true icon:long company:string custom_description:flags.0?string = BotVerifierSettings;
botVerification#f93cd45c bot_id:long icon:long description:string = BotVerification;

starGiftAttributeModel#39d99013 name:string document:Document rarity_permille:int = StarGiftAttribute;
starGiftAttributePattern#13acff19 name:string document:Document rarity_permille:int = StarGiftAttribute;
starGiftAttributeBackdrop#94271762 name:string center_color:int edge_color:int pattern_color:int text_color:int rarity_permille:int = StarGiftAttribute;
starGiftAttributeOriginalDetails#e0bff26c flags:# sender_id:flags.0?Peer recipient_id:Peer date:int message:flags.1?TextWithEntities = StarGiftAttribute;
payments.starGiftUpgradePreview#167bd90b sample_attributes:Vector<StarGiftAttribute> = payments.StarGiftUpgradePreview;
users.users#62d706b8 users:Vector<User> = users.Users;
users.usersSlice#315a4974 count:int users:Vector<User> = users.Users;
payments.uniqueStarGift#caa2f60b gift:StarGift users:Vector<User> = payments.UniqueStarGift;
messages.webPagePreview#b53e8b21 media:MessageMedia users:Vector<User> = messages.WebPagePreview;
savedStarGift#6056dba5 flags:# name_hidden:flags.0?true unsaved:flags.5?true refunded:flags.9?true can_upgrade:flags.10?true from_id:flags.1?Peer date:int gift:StarGift message:flags.2?TextWithEntities msg_id:flags.3?int saved_id:flags.11?long convert_stars:flags.4?long upgrade_stars:flags.6?long can_export_at:flags.7?int transfer_stars:flags.8?long = SavedStarGift;
payments.savedStarGifts#95f389b1 flags:# count:int chat_notifications_enabled:flags.1?Bool gifts:Vector<SavedStarGift> next_offset:flags.0?string chats:Vector<Chat> users:Vector<User> = payments.SavedStarGifts;
inputSavedStarGiftUser#69279795 msg_id:int = InputSavedStarGift;
inputSavedStarGiftChat#f101aa7f peer:InputPeer saved_id:long = InputSavedStarGift;
payments.starGiftWithdrawalUrl#84aa3a9c url:string = payments.StarGiftWithdrawalUrl;
paidReactionPrivacyDefault#206ad49e = PaidReactionPrivacy;
paidReactionPrivacyAnonymous#1f0c1ad9 = PaidReactionPrivacy;
paidReactionPrivacyPeer#dc6cfcf0 peer:InputPeer = PaidReactionPrivacy;
---functions---
/*
Invokes a query after successful completion of one of the previous queries.

**Bots can use this method**

@msg_id Message identifier on which a current query depends
@query The query itself
*/
invokeAfterMsg#cb9f372d {X:Type} msg_id:long query:!X = X;

/*
Invokes a query after a successful completion of previous queries

**Bots can use this method**

@msg_ids List of messages on which a current query depends
@query The query itself
*/
invokeAfterMsgs#3dc4b4f0 {X:Type} msg_ids:Vector<long> query:!X = X;

/*
Initialize connection

**Bots can use this method**

@api_id Application identifier (see. [App configuration](https://core.telegram.org/myapp))
@device_model Device model
@system_version Operation system version
@app_version Application version
@system_lang_code Code for the language used on the device's OS, ISO 639-1 standard
@lang_pack Platform identifier (i.e. android, tdesktop, etc).
@lang_code Either an ISO 639-1 language code or a language pack name obtained from a [language pack link](https://core.telegram.org/api/links#language-pack-links).
@proxy Info about an MTProto proxy
@params Additional initConnection parameters. For now, only the tz_offset field is supported, for specifying the timezone offset in seconds.
@query The query itself

$400, ConnectionLayerInvalidError
*/
initConnection#c1cd5ea9 {X:Type} flags:# api_id:int device_model:string system_version:string app_version:string system_lang_code:string lang_pack:string lang_code:string proxy:flags.0?InputClientProxy params:flags.1?JSONValue query:!X = X;

/*
Invoke the specified query using the specified API [layer](https://core.telegram.org/api/invoking#layers)

**Bots can use this method**

@layer The layer to use
@query The query

$400, AuthBytesInvalidError
$400, CdnMethodInvalidError
$403, ChatWriteForbiddenError
$400, ConnectionApiIdInvalidError
$406, InviteHashExpiredError
*/
invokeWithLayer#da9b0d0d {X:Type} layer:int query:!X = X;

/*
Invoke a request without subscribing the used connection for [updates](https://core.telegram.org/api/updates) (this is enabled by default for [file queries](https://core.telegram.org/api/files)).

**Bots can use this method**

@query The query
*/
invokeWithoutUpdates#bf9459b7 {X:Type} query:!X = X;

/*
Invoke with the given message range

**Bots can use this method**

@range Message range
@query Query
*/
invokeWithMessagesRange#365275f2 {X:Type} range:MessageRange query:!X = X;

/*
Invoke a method within a [takeout session, see here  for more info](https://core.telegram.org/api/takeout).

**Bots can use this method**

@takeout_id [Takeout session ID](https://core.telegram.org/api/takeout)
@query Query
*/
invokeWithTakeout#aca9fd2e {X:Type} takeout_id:long query:!X = X;

/*
Invoke a method using a [Telegram Business Bot connection, see here  for more info, including a list of the methods that can be wrapped in this constructor](https://core.telegram.org/api/business#connected-bots).

**Bots can use this method**

@connection_id Business connection ID.
@query The actual query.
*/
invokeWithBusinessConnection#dd289f8e {X:Type} connection_id:string query:!X = X;

/*
Official clients only, invoke with Google Play Integrity token.

**Bots can use this method**

@nonce Nonce.
@token Token.
@query Query.
*/
invokeWithGooglePlayIntegrity#1df92984 {X:Type} nonce:string token:string query:!X = X;

/*
Official clients only, invoke with Apple push verification.

**Bots can use this method**

@nonce Nonce.
@secret Secret.
@query Query.
*/
invokeWithApnsSecret#0dae54f8 {X:Type} nonce:string secret:string query:!X = X;

invokeWithReCaptcha#adbb0f94 {X:Type} token:string query:!X = X;
/*
Send the verification code for login

@phone_number Phone number in international format
@api_id Application identifier (see [App configuration](https://core.telegram.org/myapp))
@api_hash Application secret hash (see [App configuration](https://core.telegram.org/myapp))
@settings Settings for the code type to send

$400, ApiIdInvalidError
$400, ApiIdPublishedFloodError
$500, AuthRestartError
$500, AuthRestartError
$400, PhoneNumberAppSignupForbiddenError
$400, PhoneNumberBannedError
$400, PhoneNumberFloodError
$406, PhoneNumberInvalidError
$406, PhonePasswordFloodError
$400, PhonePasswordProtectedError
$400, SmsCodeCreateFailedError
$406, UpdateAppToLoginError
*/
auth.sendCode#a677244f phone_number:string api_id:int api_hash:string settings:CodeSettings = auth.SentCode;

/*
Registers a validated phone number in the system.

@no_joined_notifications If set, users on Telegram that have already added phone_number to their contacts will not receive signup notifications about this user.
@phone_number Phone number in the international format
@phone_code_hash SMS-message ID
@first_name New user first name
@last_name New user last name

$400, FirstnameInvalidError
$400, LastnameInvalidError
$400, PhoneCodeEmptyError
$400, PhoneCodeExpiredError
$400, PhoneCodeInvalidError
$400, PhoneNumberFloodError
$406, PhoneNumberInvalidError
$400, PhoneNumberOccupiedError
*/
auth.signUp#aac7b717 flags:# no_joined_notifications:flags.0?true phone_number:string phone_code_hash:string first_name:string last_name:string = auth.Authorization;

/*
Signs in a user with a validated phone number.

@phone_number Phone number in the international format
@phone_code_hash SMS-message ID, obtained from [auth.sendCode](https://core.telegram.org/method/auth.sendCode)
@phone_code Valid numerical code from the SMS-message
@email_verification Email verification code or token

$500, AuthRestartError
$400, PhoneCodeEmptyError
$400, PhoneCodeExpiredError
$400, PhoneCodeInvalidError
$406, PhoneNumberInvalidError
$400, PhoneNumberUnoccupiedError
$500, SignInFailedError
$406, UpdateAppToLoginError
*/
auth.signIn#8d52a951 flags:# phone_number:string phone_code_hash:string phone_code:flags.0?string email_verification:flags.1?EmailVerification = auth.Authorization;

/*
Logs out the user.

**Bots can use this method**
*/
auth.logOut#3e72ba19 = auth.LoggedOut;

/*
Terminates all user's authorized sessions except for the current one.
*/
auth.resetAuthorizations#9fab0d1a = Bool;

/*
Returns data for copying authorization to another data-center.

**Bots can use this method**

@dc_id Number of a target data-center

$400, DcIdInvalidError
*/
auth.exportAuthorization#e5bfffcd dc_id:int = auth.ExportedAuthorization;

/*
Logs in a user using a key transmitted from his native data-center.

**Bots can use this method**

@id User ID
@bytes Authorization key

$400, AuthBytesInvalidError
$400, UserIdInvalidError
*/
auth.importAuthorization#a57a7dad id:long bytes:bytes = auth.Authorization;

/*
Binds a temporary authorization key temp_auth_key_id to the permanent authorization key perm_auth_key_id. Each permanent key may only be bound to one temporary key at a time, binding a new temporary key overwrites the previous one.

**Bots can use this method**

@perm_auth_key_id Permanent auth_key_id to bind to
@nonce Random long from [Binding message contents](https://core.telegram.org#binding-message-contents)
@expires_at Unix timestamp to invalidate temporary key, see [Binding message contents](https://core.telegram.org#binding-message-contents)
@encrypted_message See [Generating encrypted_message](https://core.telegram.org#generating-encrypted-message)

$400, EncryptedMessageInvalidError
$400, TempAuthKeyAlreadyBoundError
$400, TempAuthKeyEmptyError
*/
auth.bindTempAuthKey#cdd42a05 perm_auth_key_id:long nonce:long expires_at:int encrypted_message:bytes = Bool;

/*
Login as a bot

**Bots can use this method**

@api_id Application identifier (see. [App configuration](https://core.telegram.org/myapp))
@api_hash Application identifier hash (see. [App configuration](https://core.telegram.org/myapp))
@bot_auth_token Bot token (see [bots](https://core.telegram.org/bots))

$400, AccessTokenExpiredError
$400, AccessTokenInvalidError
$400, ApiIdInvalidError
$400, ApiIdPublishedFloodError
*/
auth.importBotAuthorization#67a3ff2c flags:int api_id:int api_hash:string bot_auth_token:string = auth.Authorization;

/*
Try logging to an account protected by a [2FA password](https://core.telegram.org/api/srp).

@password The account's password (see [SRP](https://core.telegram.org/api/srp))

$500, AuthKeyUnsynchronizedError
$400, PasswordHashInvalidError
$400, SrpIdInvalidError
$400, SrpPasswordChangedError
*/
auth.checkPassword#d18b4d16 password:InputCheckPasswordSRP = auth.Authorization;

/*
Request recovery code of a [2FA password](https://core.telegram.org/api/srp), only for accounts with a [recovery email configured](https://core.telegram.org/api/srp#email-verification).
*/
auth.requestPasswordRecovery#d897bc66 = auth.PasswordRecovery;

/*
Reset the [2FA password](https://core.telegram.org/api/srp) using the recovery code sent using [auth.requestPasswordRecovery](https://core.telegram.org/method/auth.requestPasswordRecovery).

@code Code received via email
@new_settings New password

$400, CodeEmptyError
$400, NewSettingsInvalidError
*/
auth.recoverPassword#37096c70 flags:# code:string new_settings:flags.0?account.PasswordInputSettings = auth.Authorization;

/*
Resend the login code via another medium, the phone code type is determined by the return value of the previous auth.sendCode/auth.resendCode: see [login](https://core.telegram.org/api/auth) for more info.

@phone_number The phone number
@phone_code_hash The phone code hash obtained from [auth.sendCode](https://core.telegram.org/method/auth.sendCode)
@reason Official clients only, used if the device integrity verification failed, and no secret could be obtained to invoke [auth.requestFirebaseSms](https://core.telegram.org/method/auth.requestFirebaseSms): in this case, the device integrity verification failure reason must be passed here.

$400, PhoneCodeEmptyError
$400, PhoneCodeExpiredError
$400, PhoneCodeHashEmptyError
$406, PhoneNumberInvalidError
$406, SendCodeUnavailableError
*/
auth.resendCode#cae47523 flags:# phone_number:string phone_code_hash:string reason:flags.0?string = auth.SentCode;

/*
Cancel the login verification code

@phone_number Phone number
@phone_code_hash Phone code hash from [auth.sendCode](https://core.telegram.org/method/auth.sendCode)

$400, PhoneCodeExpiredError
$406, PhoneNumberInvalidError
*/
auth.cancelCode#1f040578 phone_number:string phone_code_hash:string = Bool;

/*
Delete all temporary authorization keys except for the ones specified

**Bots can use this method**

@except_auth_keys The auth keys that shouldn't be dropped.
*/
auth.dropTempAuthKeys#8e48a188 except_auth_keys:Vector<long> = Bool;

/*
Generate a login token, for [login via QR code](https://core.telegram.org/api/qr-login). 
The generated login token should be encoded using base64url, then shown as a tg://login?token=base64encodedtoken [deep link](https://core.telegram.org/api/links#qr-code-login-links) in the QR code.

@api_id Application identifier (see. [App configuration](https://core.telegram.org/myapp))
@api_hash Application identifier hash (see. [App configuration](https://core.telegram.org/myapp))
@except_ids List of already logged-in user IDs, to prevent logging in twice with the same user

$400, ApiIdInvalidError
$400, ApiIdPublishedFloodError
*/
auth.exportLoginToken#b7e085fe api_id:int api_hash:string except_ids:Vector<long> = auth.LoginToken;

/*
Login using a redirected login token, generated in case of DC mismatch during [QR code login](https://core.telegram.org/api/qr-login).

@token Login token

$400, AuthTokenAlreadyAcceptedError
$400, AuthTokenExpiredError
$400, AuthTokenInvalidError
$400, AuthTokenInvalidxError
*/
auth.importLoginToken#95ac5ce4 token:bytes = auth.LoginToken;

/*
Accept QR code login token, logging in the app that generated it.

@token Login token embedded in QR code, for more info, see [login via QR code](https://core.telegram.org/api/qr-login).

$400, AuthTokenAlreadyAcceptedError
$400, AuthTokenExceptionError
$400, AuthTokenExpiredError
$400, AuthTokenInvalidxError
*/
auth.acceptLoginToken#e894ad4d token:bytes = Authorization;

/*
Check if the [2FA recovery code](https://core.telegram.org/api/srp) sent using [auth.requestPasswordRecovery](https://core.telegram.org/method/auth.requestPasswordRecovery) is valid, before passing it to [auth.recoverPassword](https://core.telegram.org/method/auth.recoverPassword).

@code Code received via email

$400, CodeEmptyError
$400, PasswordRecoveryExpiredError
*/
auth.checkRecoveryPassword#d36bf79 code:string = Bool;

/*
Login by importing an authorization token

@api_id [API ID](https://core.telegram.org/api/obtaining_api_id)
@api_hash [API hash](https://core.telegram.org/api/obtaining_api_id)
@web_auth_token The authorization token

$400, ApiIdInvalidError
*/
auth.importWebTokenAuthorization#2db873a9 api_id:int api_hash:string web_auth_token:string = auth.Authorization;

/*
Request an SMS code via Firebase.

@phone_number Phone number
@phone_code_hash Phone code hash returned by [auth.sendCode](https://core.telegram.org/method/auth.sendCode)
@safety_net_token On Android, a JWS object obtained as described in the [auth documentation](https://core.telegram.org/api/auth)
@play_integrity_token On Android, an object obtained as described in the [auth documentation](https://core.telegram.org/api/auth)
@ios_push_secret Secret token received via an apple push notification

$400, PhoneCodeEmptyError
$400, PhoneNumberInvalidError
*/
auth.requestFirebaseSms#8e39261e flags:# phone_number:string phone_code_hash:string safety_net_token:flags.0?string play_integrity_token:flags.2?string ios_push_secret:flags.1?string = Bool;

/*
Reset the [login email](https://core.telegram.org/api/auth#email-verification).

@phone_number Phone number of the account
@phone_code_hash Phone code hash, obtained as described in the [documentation](https://core.telegram.org/api/auth)

$400, PhoneNumberInvalidError
$400, TaskAlreadyExistsError
*/
auth.resetLoginEmail#7e960193 phone_number:string phone_code_hash:string = auth.SentCode;

/*
Official apps only, reports that the SMS authentication code wasn't delivered.

@phone_number Phone number where we were supposed to receive the code
@phone_code_hash The phone code hash obtained from [auth.sendCode](https://core.telegram.org/method/auth.sendCode)
@mnc [MNC](https://en.wikipedia.org/wiki/Mobile_country_code) of the current network operator.

$400, PhoneNumberInvalidError
*/
auth.reportMissingCode#cb9deff6 phone_number:string phone_code_hash:string mnc:string = Bool;

/*
Register device to receive [PUSH notifications](https://core.telegram.org/api/push-updates)

@no_muted Avoid receiving (silent and invisible background) notifications. Useful to save battery.
@token_type Device token type, see [PUSH updates](https://core.telegram.org/api/push-updates#subscribing-to-notifications) for the possible values.
@token Device token, see [PUSH updates](https://core.telegram.org/api/push-updates#subscribing-to-notifications) for the possible values.
@app_sandbox If [(boolTrue)](https://core.telegram.org/constructor/boolTrue) is transmitted, a sandbox-certificate will be used during transmission.
@secret For FCM and APNS VoIP, optional encryption key used to encrypt push notifications
@other_uids List of user identifiers of other users currently using the client

$400, TokenEmptyError
$400, TokenInvalidError
$400, TokenTypeInvalidError
$400, WebpushAuthInvalidError
$400, WebpushKeyInvalidError
$400, WebpushTokenInvalidError
*/
account.registerDevice#ec86017a flags:# no_muted:flags.0?true token_type:int token:string app_sandbox:Bool secret:bytes other_uids:Vector<long> = Bool;

/*
Deletes a device by its token, stops sending PUSH-notifications to it.

@token_type Device token type, see [PUSH updates](https://core.telegram.org/api/push-updates#subscribing-to-notifications) for the possible values.
@token Device token, see [PUSH updates](https://core.telegram.org/api/push-updates#subscribing-to-notifications) for the possible values.
@other_uids List of user identifiers of other users currently using the client

$400, TokenInvalidError
*/
account.unregisterDevice#6a0d3206 token_type:int token:string other_uids:Vector<long> = Bool;

/*
Edits notification settings from a given user/group, from all users/all groups.

@peer Notification source
@settings Notification settings

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, SettingsInvalidError
*/
account.updateNotifySettings#84be5b93 peer:InputNotifyPeer settings:InputPeerNotifySettings = Bool;

/*
Gets current notification settings for a given user/group, from all users/all groups.

@peer Notification source

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, PeerIdInvalidError
*/
account.getNotifySettings#12b3ad31 peer:InputNotifyPeer = PeerNotifySettings;

/*
Resets all notification settings from users and groups.
*/
account.resetNotifySettings#db7e1747 = Bool;

/*
Updates user profile.

@first_name New user first name
@last_name New user last name
@about New bio

$400, AboutTooLongError
$400, FirstnameInvalidError
*/
account.updateProfile#78515775 flags:# first_name:flags.0?string last_name:flags.1?string about:flags.2?string = User;

/*
Updates online user status.

@offline If [(boolTrue)](https://core.telegram.org/constructor/boolTrue) is transmitted, user status will change to [(userStatusOffline)](https://core.telegram.org/constructor/userStatusOffline).
*/
account.updateStatus#6628562c offline:Bool = Bool;

/*
Returns a list of available [wallpapers](https://core.telegram.org/api/wallpapers).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getWallPapers#7967d36 hash:long = account.WallPapers;

/*
Report a peer for violation of telegram's Terms of Service

@peer The peer to report
@reason The reason why this peer is being reported
@message Comment for report moderation

$400, ChannelPrivateError
$400, PeerIdInvalidError
*/
account.reportPeer#c5ba3d86 peer:InputPeer reason:ReportReason message:string = Bool;

/*
Validates a username and checks availability.

@username username Accepted characters: A-z (case-insensitive), 0-9 and underscores. Length: 5-32 characters.

$400, UsernameInvalidError
$400, UsernameOccupiedError
$400, UsernamePurchaseAvailableError
*/
account.checkUsername#2714d86c username:string = Bool;

/*
Changes username for the current user.

@username username or empty string if username is to be removed Accepted characters: a-z (case-insensitive), 0-9 and underscores. Length: 5-32 characters.

$400, UsernameInvalidError
$400, UsernameNotModifiedError
$400, UsernameOccupiedError
$400, UsernamePurchaseAvailableError
*/
account.updateUsername#3e0bdd7c username:string = User;

/*
Get privacy settings of current account

@key Peer category whose privacy settings should be fetched

$400, PrivacyKeyInvalidError
*/
account.getPrivacy#dadbc950 key:InputPrivacyKey = account.PrivacyRules;

/*
Change privacy settings of current account

@key New privacy rule
@rules Peers to which the privacy rule will apply.

$400, PrivacyKeyInvalidError
$400, PrivacyTooLongError
$400, PrivacyValueInvalidError
*/
account.setPrivacy#c9f81ce8 key:InputPrivacyKey rules:Vector<InputPrivacyRule> = account.PrivacyRules;

/*
Delete the user's account from the telegram servers.

@reason Why is the account being deleted, can be empty
@password [2FA password](https://core.telegram.org/api/srp): this field can be omitted even for accounts with 2FA enabled: in this case account account deletion will be delayed by 7 days [as specified in the docs](https://core.telegram.org/api/account-deletion)

$420, TwoFaConfirmWaitError
$400, PasswordHashInvalidError
*/
account.deleteAccount#a2c0cf74 flags:# reason:string password:flags.0?InputCheckPasswordSRP = Bool;

/*
Get days to live of account
*/
account.getAccountTTL#8fc711d = AccountDaysTTL;

/*
Set account self-destruction period

@ttl Time to live in days

$400, TtlDaysInvalidError
*/
account.setAccountTTL#2442485e ttl:AccountDaysTTL = Bool;

/*
Verify a new phone number to associate to the current account

@phone_number New phone number
@settings Phone code settings

$406, FreshChangePhoneForbiddenError
$400, PhoneNumberBannedError
$406, PhoneNumberInvalidError
$400, PhoneNumberOccupiedError
*/
account.sendChangePhoneCode#82574ae5 phone_number:string settings:CodeSettings = auth.SentCode;

/*
Change the phone number of the current account

@phone_number New phone number
@phone_code_hash Phone code hash received when calling [account.sendChangePhoneCode](https://core.telegram.org/method/account.sendChangePhoneCode)
@phone_code Phone code received when calling [account.sendChangePhoneCode](https://core.telegram.org/method/account.sendChangePhoneCode)

$400, PhoneCodeEmptyError
$400, PhoneCodeExpiredError
$406, PhoneNumberInvalidError
$400, PhoneNumberOccupiedError
*/
account.changePhone#70c32edb phone_number:string phone_code_hash:string phone_code:string = User;

/*
When client-side passcode lock feature is enabled, will not show message texts in incoming [PUSH notifications](https://core.telegram.org/api/push-updates).

@period Inactivity period after which to start hiding message texts in [PUSH notifications](https://core.telegram.org/api/push-updates).
*/
account.updateDeviceLocked#38df3532 period:int = Bool;

/*
Get logged-in sessions
*/
account.getAuthorizations#e320c158 = account.Authorizations;

/*
Log out an active [authorized session](https://core.telegram.org/api/auth) by its hash

@hash Session hash

$406, FreshResetAuthorisationForbiddenError
$400, HashInvalidError
*/
account.resetAuthorization#df77f3bc hash:long = Bool;

/*
Obtain configuration for two-factor authorization with password
*/
account.getPassword#548a30f5 = account.Password;

/*
Get private info associated to the password info (recovery email, telegram [passport](https://core.telegram.org/passport) info & so on)

@password The password (see [SRP](https://core.telegram.org/api/srp))

$400, PasswordHashInvalidError
*/
account.getPasswordSettings#9cd4eaf9 password:InputCheckPasswordSRP = account.PasswordSettings;

/*
Set a new 2FA password

@password The old password (see [SRP](https://core.telegram.org/api/srp))
@new_settings The new password (see [SRP](https://core.telegram.org/api/srp))

$400, EmailInvalidError
$400, EmailUnconfirmedError
$400, EmailUnconfirmedError
$400, NewSaltInvalidError
$400, NewSettingsEmptyError
$400, NewSettingsInvalidError
$400, PasswordHashInvalidError
$400, SrpIdInvalidError
$400, SrpPasswordChangedError
*/
account.updatePasswordSettings#a59b102f password:InputCheckPasswordSRP new_settings:account.PasswordInputSettings = Bool;

/*
Send confirmation code to cancel account deletion, for more info [click here](https://core.telegram.org/api/account-deletion)

@hash The hash from the service notification, for more info [click here](https://core.telegram.org/api/account-deletion)
@settings Phone code settings

$400, HashInvalidError
*/
account.sendConfirmPhoneCode#1b3faa88 hash:string settings:CodeSettings = auth.SentCode;

/*
Confirm a phone number to cancel account deletion, for more info [click here](https://core.telegram.org/api/account-deletion)

@phone_code_hash Phone code hash, for more info [click here](https://core.telegram.org/api/account-deletion)
@phone_code SMS code, for more info [click here](https://core.telegram.org/api/account-deletion)

$400, CodeHashInvalidError
$400, PhoneCodeEmptyError
*/
account.confirmPhone#5f2178c3 phone_code_hash:string phone_code:string = Bool;

/*
Get temporary payment password

@password SRP password parameters
@period Time during which the temporary password will be valid, in seconds; should be between 60 and 86400

$400, PasswordHashInvalidError
$400, SrpAInvalidError
$400, TmpPasswordDisabledError
*/
account.getTmpPassword#449e0b51 password:InputCheckPasswordSRP period:int = account.TmpPassword;

/*
Get web [login widget](https://core.telegram.org/widgets/login) authorizations
*/
account.getWebAuthorizations#182e6d6f = account.WebAuthorizations;

/*
Log out an active web [telegram login](https://core.telegram.org/widgets/login) session

@hash [Session](https://core.telegram.org/constructor/webAuthorization) hash

$400, HashInvalidError
*/
account.resetWebAuthorization#2d01b9ef hash:long = Bool;

/*
Reset all active web [telegram login](https://core.telegram.org/widgets/login) sessions
*/
account.resetWebAuthorizations#682d2594 = Bool;

/*
Get all saved [Telegram Passport](https://core.telegram.org/passport) documents, [for more info see the passport docs](https://core.telegram.org/passport/encryption#encryption)
*/
account.getAllSecureValues#b288bc7d = Vector<SecureValue>;

/*
Get saved [Telegram Passport](https://core.telegram.org/passport) document, [for more info see the passport docs](https://core.telegram.org/passport/encryption#encryption)

@types Requested value types
*/
account.getSecureValue#73665bc2 types:Vector<SecureValueType> = Vector<SecureValue>;

/*
Securely save [Telegram Passport](https://core.telegram.org/passport) document, [for more info see the passport docs](https://core.telegram.org/passport/encryption#encryption)

@value Secure value, [for more info see the passport docs](https://core.telegram.org/passport/encryption#encryption)
@secure_secret_id Passport secret hash, [for more info see the passport docs](https://core.telegram.org/passport/encryption#encryption)

$400, PasswordRequiredError
$400, SecureSecretRequiredError
*/
account.saveSecureValue#899fe31d value:InputSecureValue secure_secret_id:long = SecureValue;

/*
Delete stored [Telegram Passport](https://core.telegram.org/passport) documents, [for more info see the passport docs](https://core.telegram.org/passport/encryption#encryption)

@types Document types to delete
*/
account.deleteSecureValue#b880bc4b types:Vector<SecureValueType> = Bool;

/*
Returns a Telegram Passport authorization form for sharing data with a service

@bot_id User identifier of the service's bot
@scope Telegram Passport element types requested by the service
@public_key Service's public key

$400, BotInvalidError
$400, PublicKeyRequiredError
*/
account.getAuthorizationForm#a929597a bot_id:long scope:string public_key:string = account.AuthorizationForm;

/*
Sends a Telegram Passport authorization form, effectively sharing data with the service

@bot_id Bot ID
@scope Telegram Passport element types requested by the service
@public_key Service's public key
@value_hashes Types of values sent and their hashes
@credentials Encrypted values

$400, BotInvalidError
$400, PublicKeyRequiredError
*/
account.acceptAuthorization#f3ed4c73 bot_id:long scope:string public_key:string value_hashes:Vector<SecureValueHash> credentials:SecureCredentialsEncrypted = Bool;

/*
Send the verification phone code for telegram [passport](https://core.telegram.org/passport).

@phone_number The phone number to verify
@settings Phone code settings

$400, PhoneNumberInvalidError
*/
account.sendVerifyPhoneCode#a5a356f9 phone_number:string settings:CodeSettings = auth.SentCode;

/*
Verify a phone number for telegram [passport](https://core.telegram.org/passport).

@phone_number Phone number
@phone_code_hash Phone code hash received from the call to [account.sendVerifyPhoneCode](https://core.telegram.org/method/account.sendVerifyPhoneCode)
@phone_code Code received after the call to [account.sendVerifyPhoneCode](https://core.telegram.org/method/account.sendVerifyPhoneCode)

$400, PhoneCodeEmptyError
$400, PhoneCodeExpiredError
$400, PhoneNumberInvalidError
*/
account.verifyPhone#4dd3a7f6 phone_number:string phone_code_hash:string phone_code:string = Bool;

/*
Send an email verification code.

@purpose Verification purpose.
@email The email where to send the code.

$400, EmailInvalidError
$400, EmailNotAllowedError
$400, EmailNotSetupError
$400, PhoneHashExpiredError
$400, PhoneNumberInvalidError
*/
account.sendVerifyEmailCode#98e037bb purpose:EmailVerifyPurpose email:string = account.SentEmailCode;

/*
Verify an email address.

@purpose Verification purpose
@verification Email verification code or token

$400, EmailInvalidError
$400, EmailNotAllowedError
$400, EmailVerifyExpiredError
$400, PhoneNumberInvalidError
*/
account.verifyEmail#32da4cf purpose:EmailVerifyPurpose verification:EmailVerification = account.EmailVerified;

/*
Initialize a [takeout session, see here  for more info](https://core.telegram.org/api/takeout).

@contacts Whether to export contacts
@message_users Whether to export messages in private chats
@message_chats Whether to export messages in [basic groups](https://core.telegram.org/api/channel#basic-groups)
@message_megagroups Whether to export messages in [supergroups](https://core.telegram.org/api/channel#supergroups)
@message_channels Whether to export messages in [channels](https://core.telegram.org/api/channel#channels)
@files Whether to export files
@file_max_size Maximum size of files to export

$420, TakeoutInitDelayError
*/
account.initTakeoutSession#8ef3eab0 flags:# contacts:flags.0?true message_users:flags.1?true message_chats:flags.2?true message_megagroups:flags.3?true message_channels:flags.4?true files:flags.5?true file_max_size:flags.5?long = account.Takeout;

/*
Terminate a [takeout session, see here  for more info](https://core.telegram.org/api/takeout).

@success Data exported successfully

$403, TakeoutRequiredError
*/
account.finishTakeoutSession#1d2652ee flags:# success:flags.0?true = Bool;

/*
Verify an email to use as [2FA recovery method](https://core.telegram.org/api/srp).

@code The phone code that was received after [setting a recovery email](https://core.telegram.org/api/srp#email-verification)

$400, CodeInvalidError
$400, EmailHashExpiredError
*/
account.confirmPasswordEmail#8fdf1920 code:string = Bool;

/*
Resend the code to verify an email to use as [2FA recovery method](https://core.telegram.org/api/srp).
*/
account.resendPasswordEmail#7a7f2a15 = Bool;

/*
Cancel the code that was sent to verify an email to use as [2FA recovery method](https://core.telegram.org/api/srp).
*/
account.cancelPasswordEmail#c1cbd5b6 = Bool;

/*
Whether the user will receive notifications when contacts sign up
*/
account.getContactSignUpNotification#9f07c728 = Bool;

/*
Toggle contact sign up notifications

@silent Whether to disable contact sign up notifications
*/
account.setContactSignUpNotification#cff43f61 silent:Bool = Bool;

/*
Returns list of chats with non-default notification settings

@compare_sound If set, chats with non-default sound will be returned
@compare_stories If set, chats with non-default notification settings for stories will be returned
@peer If specified, only chats of the specified category will be returned
*/
account.getNotifyExceptions#53577479 flags:# compare_sound:flags.1?true compare_stories:flags.2?true peer:flags.0?InputNotifyPeer = Updates;

/*
Get info about a certain [wallpaper](https://core.telegram.org/api/wallpapers)

@wallpaper The [wallpaper](https://core.telegram.org/api/wallpapers) to get info about

$400, WallpaperInvalidError
*/
account.getWallPaper#fc8ddbea wallpaper:InputWallPaper = WallPaper;

/*
Create and upload a new [wallpaper](https://core.telegram.org/api/wallpapers)

@for_chat Set this flag when uploading wallpapers to be passed to [messages.setChatWallPaper](https://core.telegram.org/method/messages.setChatWallPaper).
@file The JPG/PNG wallpaper
@mime_type MIME type of uploaded wallpaper
@settings Wallpaper settings

$400, WallpaperFileInvalidError
$400, WallpaperMimeInvalidError
*/
account.uploadWallPaper#e39a8f03 flags:# for_chat:flags.0?true file:InputFile mime_type:string settings:WallPaperSettings = WallPaper;

/*
Install/uninstall [wallpaper](https://core.telegram.org/api/wallpapers)

@wallpaper [Wallpaper](https://core.telegram.org/api/wallpapers) to install or uninstall
@unsave Uninstall wallpaper?
@settings Wallpaper settings

$400, WallpaperInvalidError
*/
account.saveWallPaper#6c5a5b37 wallpaper:InputWallPaper unsave:Bool settings:WallPaperSettings = Bool;

/*
Install [wallpaper](https://core.telegram.org/api/wallpapers)

@wallpaper [Wallpaper](https://core.telegram.org/api/wallpapers) to install
@settings [Wallpaper](https://core.telegram.org/api/wallpapers) settings

$400, WallpaperInvalidError
*/
account.installWallPaper#feed5769 wallpaper:InputWallPaper settings:WallPaperSettings = Bool;

/*
Delete all installed [wallpapers](https://core.telegram.org/api/wallpapers), reverting to the default wallpaper set.
*/
account.resetWallPapers#bb3b9804 = Bool;

/*
Get media autodownload settings
*/
account.getAutoDownloadSettings#56da0b3f = account.AutoDownloadSettings;

/*
Change media autodownload settings

@low Whether to save media in the low data usage preset
@high Whether to save media in the high data usage preset
@settings Media autodownload settings
*/
account.saveAutoDownloadSettings#76f36233 flags:# low:flags.0?true high:flags.1?true settings:AutoDownloadSettings = Bool;

/*
Upload theme

@file [Previously uploaded](https://core.telegram.org/api/themes#uploading-theme-files) theme file with platform-specific colors for UI components, can be left unset when creating themes that only modify the wallpaper or accent colors.
@thumb Thumbnail
@file_name File name
@mime_type MIME type, must be application/x-tgtheme-{format}, where format depends on the client

$400, ThemeFileInvalidError
$400, ThemeMimeInvalidError
*/
account.uploadTheme#1c3db333 flags:# file:InputFile thumb:flags.0?InputFile file_name:string mime_type:string = Document;

/*
Create a theme

@slug Unique theme ID used to generate [theme deep links](https://core.telegram.org/api/links#theme-links), can be empty to autogenerate a random ID.
@title Theme name
@document Theme file
@settings Theme settings, multiple values can be provided for the different base themes (day/night mode, etc).

$400, ThemeMimeInvalidError
$400, ThemeTitleInvalidError
*/
account.createTheme#652e4400 flags:# slug:string title:string document:flags.2?InputDocument settings:flags.3?Vector<InputThemeSettings> = Theme;

/*
Update theme

@format Theme format, a string that identifies the theming engines supported by the client
@theme Theme to update
@slug Unique theme ID
@title Theme name
@document Theme file
@settings Theme settings

$400, ThemeInvalidError
*/
account.updateTheme#2bf40ccc flags:# format:string theme:InputTheme slug:flags.0?string title:flags.1?string document:flags.2?InputDocument settings:flags.3?Vector<InputThemeSettings> = Theme;

/*
Save a theme

@theme Theme to save
@unsave Unsave

$400, ThemeInvalidError
*/
account.saveTheme#f257106c theme:InputTheme unsave:Bool = Bool;

/*
Install a theme

@dark Whether to install the dark version
@theme Theme to install
@format Theme format, a string that identifies the theming engines supported by the client
@base_theme Indicates a basic theme provided by all clients
*/
account.installTheme#c727bb3b flags:# dark:flags.0?true theme:flags.1?InputTheme format:flags.2?string base_theme:flags.3?BaseTheme = Bool;

/*
Get theme information

@format Theme format, a string that identifies the theming engines supported by the client
@theme Theme

$400, ThemeFormatInvalidError
$400, ThemeInvalidError
*/
account.getTheme#3a5869ec format:string theme:InputTheme = Theme;

/*
Get installed themes

@format Theme format, a string that identifies the theming engines supported by the client
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getThemes#7206e458 format:string hash:long = account.Themes;

/*
Set sensitive content settings (for viewing or hiding NSFW content)

@sensitive_enabled Enable NSFW content

$403, SensitiveChangeForbiddenError
*/
account.setContentSettings#b574b16b flags:# sensitive_enabled:flags.0?true = Bool;

/*
Get sensitive content settings
*/
account.getContentSettings#8b9b4dae = account.ContentSettings;

/*
Get info about multiple [wallpapers](https://core.telegram.org/api/wallpapers)

@wallpapers [Wallpapers](https://core.telegram.org/api/wallpapers) to fetch info about

$400, WallpaperInvalidError
*/
account.getMultiWallPapers#65ad71dc wallpapers:Vector<InputWallPaper> = Vector<WallPaper>;

/*
Get global privacy settings
*/
account.getGlobalPrivacySettings#eb2b4cf6 = GlobalPrivacySettings;

/*
Set global privacy settings

@settings Global privacy settings

$400, AutoarchiveNotAvailableError
$403, PremiumAccountRequiredError
*/
account.setGlobalPrivacySettings#1edaaac2 settings:GlobalPrivacySettings = GlobalPrivacySettings;

/*
Report a profile photo of a dialog

@peer The dialog
@photo_id Dialog photo ID
@reason Report reason
@message Comment for report moderation

$400, PeerIdInvalidError
*/
account.reportProfilePhoto#fa8cc6f5 peer:InputPeer photo_id:InputPhoto reason:ReportReason message:string = Bool;

/*
Initiate a 2FA password reset: can only be used if the user is already logged-in, [see here for more info](https://core.telegram.org/api/srp#password-reset)
*/
account.resetPassword#9308ce1b = account.ResetPasswordResult;

/*
Abort a pending 2FA password reset, [see here for more info](https://core.telegram.org/api/srp#password-reset)
*/
account.declinePasswordReset#4c9409f6 = Bool;

/*
Get all available chat [themes](https://core.telegram.org/api/themes).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getChatThemes#d638de89 hash:long = account.Themes;

/*
Set time-to-live of current session

@authorization_ttl_days Time-to-live of current session in days

$406, FreshResetAuthorisationForbiddenError
$400, TtlDaysInvalidError
*/
account.setAuthorizationTTL#bf899aa0 authorization_ttl_days:int = Bool;

/*
Change settings related to a session.

@confirmed If set, [confirms a newly logged in session](https://core.telegram.org/api/auth#confirming-login).
@hash Session ID from the [authorization](https://core.telegram.org/constructor/authorization) constructor, fetchable using [account.getAuthorizations](https://core.telegram.org/method/account.getAuthorizations)
@encrypted_requests_disabled Whether to enable or disable receiving encrypted chats: if the flag is not set, the previous setting is not changed
@call_requests_disabled Whether to enable or disable receiving calls: if the flag is not set, the previous setting is not changed

$400, HashInvalidError
*/
account.changeAuthorizationSettings#40f48462 flags:# confirmed:flags.3?true hash:long encrypted_requests_disabled:flags.0?Bool call_requests_disabled:flags.1?Bool = Bool;

/*
Fetch saved notification sounds

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getSavedRingtones#e1902288 hash:long = account.SavedRingtones;

/*
Save or remove saved notification sound.

@id Notification sound uploaded using [account.uploadRingtone](https://core.telegram.org/method/account.uploadRingtone)
@unsave Whether to add or delete the notification sound

$400, RingtoneInvalidError
*/
account.saveRingtone#3dea5b03 id:InputDocument unsave:Bool = account.SavedRingtone;

/*
Upload notification sound, use [account.saveRingtone](https://core.telegram.org/method/account.saveRingtone) to convert it and add it to the list of saved notification sounds.

@file Notification sound
@file_name File name
@mime_type MIME type of file

$400, RingtoneMimeInvalidError
*/
account.uploadRingtone#831a83a2 file:InputFile file_name:string mime_type:string = Document;

/*
Set an [emoji status](https://core.telegram.org/api/emoji-status)

@emoji_status [Emoji status](https://core.telegram.org/api/emoji-status) to set

$400, DocumentInvalidError
*/
account.updateEmojiStatus#fbd3de6b emoji_status:EmojiStatus = Bool;

/*
Get a list of default suggested [emoji statuses](https://core.telegram.org/api/emoji-status)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getDefaultEmojiStatuses#d6753386 hash:long = account.EmojiStatuses;

/*
Get recently used [emoji statuses](https://core.telegram.org/api/emoji-status)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getRecentEmojiStatuses#f578105 hash:long = account.EmojiStatuses;

/*
Clears list of recently used [emoji statuses](https://core.telegram.org/api/emoji-status)
*/
account.clearRecentEmojiStatuses#18201aae = Bool;

/*
Reorder usernames associated with the currently logged-in user.

@order The new order for active usernames. All active usernames must be specified.

$400, OrderInvalidError
$400, UsernameNotModifiedError
*/
account.reorderUsernames#ef500eab order:Vector<string> = Bool;

/*
Activate or deactivate a purchased [fragment.com](https://fragment.com) username associated to the currently logged-in user.

@username Username
@active Whether to activate or deactivate it

$400, UsernamesActiveTooMuchError
$400, UsernameInvalidError
$400, UsernameNotModifiedError
*/
account.toggleUsername#58d6b376 username:string active:Bool = Bool;

/*
Get a set of suggested [custom emoji stickers](https://core.telegram.org/api/custom-emoji) that can be [used as profile picture](https://core.telegram.org/api/files#sticker-profile-pictures)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getDefaultProfilePhotoEmojis#e2750328 hash:long = EmojiList;

/*
Get a set of suggested [custom emoji stickers](https://core.telegram.org/api/custom-emoji) that can be [used as group picture](https://core.telegram.org/api/files#sticker-profile-pictures)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getDefaultGroupPhotoEmojis#915860ae hash:long = EmojiList;

/*
Get autosave settings
*/
account.getAutoSaveSettings#adcbbcda = account.AutoSaveSettings;

/*
Modify autosave settings

@users Whether the new settings should affect all private chats
@chats Whether the new settings should affect all groups
@broadcasts Whether the new settings should affect all [channels](https://core.telegram.org/api/channel)
@peer Whether the new settings should affect a specific peer
@settings The new autosave settings

$400, PeerIdInvalidError
*/
account.saveAutoSaveSettings#d69b8361 flags:# users:flags.0?true chats:flags.1?true broadcasts:flags.2?true peer:flags.3?InputPeer settings:AutoSaveSettings = Bool;

/*
Clear all peer-specific autosave settings.
*/
account.deleteAutoSaveExceptions#53bc0020 = Bool;

/*
Invalidate the specified login codes, see [here](https://core.telegram.org/api/auth#invalidating-login-codes) for more info.

@codes The login codes to invalidate.
*/
account.invalidateSignInCodes#ca8ae8ba codes:Vector<string> = Bool;

/*
Update the [accent color and background custom emoji](https://core.telegram.org/api/colors) of the current account.

@for_profile Whether to change the accent color emoji pattern of the profile page; otherwise, the accent color and emoji pattern of messages will be changed.
@color [ID of the accent color palette](https://core.telegram.org/api/colors) to use (not RGB24, see [here](https://core.telegram.org/api/colors) for more info).
@background_emoji_id Custom emoji ID used in the accent color pattern.

$400, ColorInvalidError
$403, PremiumAccountRequiredError
*/
account.updateColor#7cefa15d flags:# for_profile:flags.1?true color:flags.2?int background_emoji_id:flags.0?long = Bool;

/*
Get a set of suggested [custom emoji stickers](https://core.telegram.org/api/custom-emoji) that can be used in an [accent color pattern](https://core.telegram.org/api/colors).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getDefaultBackgroundEmojis#a60ab9ce hash:long = EmojiList;

/*
Get a list of default suggested [channel emoji statuses](https://core.telegram.org/api/emoji-status).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getChannelDefaultEmojiStatuses#7727a7d5 hash:long = account.EmojiStatuses;

/*
Returns fetch the full list of [custom emoji IDs](https://core.telegram.org/api/custom-emoji) that cannot be used in [channel emoji statuses](https://core.telegram.org/api/emoji-status).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
account.getChannelRestrictedStatusEmojis#35a9e0d5 hash:long = EmojiList;

/*
Specify a set of [Telegram Business opening hours](https://core.telegram.org/api/business#opening-hours). 
This info will be contained in [userFull](https://core.telegram.org/constructor/userFull). business_work_hours.

@business_work_hours Opening hours (optional, if not set removes all opening hours).

$400, BusinessWorkHoursEmptyError
$400, BusinessWorkHoursPeriodInvalidError
$400, TimezoneInvalidError
*/
account.updateBusinessWorkHours#4b00e066 flags:# business_work_hours:flags.0?BusinessWorkHours = Bool;

/*
[Businesses](https://core.telegram.org/api/business#location) may advertise their location using this method, see [here](https://core.telegram.org/api/business#location) for more info.

@geo_point Optional, contains a set of geographical coordinates.
@address Mandatory when setting/updating the location, contains a textual description of the address (max 96 UTF-8 chars).
*/
account.updateBusinessLocation#9e6b131a flags:# geo_point:flags.1?InputGeoPoint address:flags.0?string = Bool;

/*
Set a list of [Telegram Business greeting messages](https://core.telegram.org/api/business#greeting-messages).

@message Greeting message configuration and contents.
*/
account.updateBusinessGreetingMessage#66cdafc4 flags:# message:flags.0?InputBusinessGreetingMessage = Bool;

/*
Set a list of [Telegram Business away messages](https://core.telegram.org/api/business#away-messages).

@message Away message configuration and contents.
*/
account.updateBusinessAwayMessage#a26a7fa5 flags:# message:flags.0?InputBusinessAwayMessage = Bool;

/*
Connect a [business bot](https://core.telegram.org/api/business#connected-bots) to the current account, or to change the current connection settings.

@can_reply Whether the bot can reply to messages it receives from us, on behalf of us using the [business connection](https://core.telegram.org/api/business#connected-bots).
@deleted Whether to fully disconnect the bot from the current account.
@bot The bot to connect or disconnect
@recipients Configuration for the business connection

$400, BotBusinessMissingError
$400, BusinessRecipientsEmptyError
$403, PremiumAccountRequiredError
*/
account.updateConnectedBot#43d8521d flags:# can_reply:flags.0?true deleted:flags.1?true bot:InputUser recipients:InputBusinessBotRecipients = Updates;

/*
List all currently connected [business bots](https://core.telegram.org/api/business#connected-bots)
*/
account.getConnectedBots#4ea4c80f = account.ConnectedBots;

/*
Bots may invoke this method to re-fetch the [updateBotBusinessConnect](https://core.telegram.org/constructor/updateBotBusinessConnect) constructor associated with a specific [business connection_id, see here](https://core.telegram.org/api/business#connected-bots) for more info on connected business bots. 
This is needed for example for freshly logged in bots that are receiving some [updateBotNewBusinessMessage](https://core.telegram.org/constructor/updateBotNewBusinessMessage), etc. updates because some users have already connected to the bot before it could login. 
In this case, the bot is receiving messages from the business connection, but it hasn't cached the associated [updateBotBusinessConnect](https://core.telegram.org/constructor/updateBotBusinessConnect) with info about the connection (can it reply to messages? etc.) yet, and cannot receive the old ones because they were sent when the bot wasn't logged into the session yet. 
This method can be used to fetch info about a not-yet-cached business connection, and should not be invoked if the info is already cached or to fetch changes, as eventual changes will automatically be sent as new [updateBotBusinessConnect](https://core.telegram.org/constructor/updateBotBusinessConnect) updates to the bot using the usual [update delivery methods](https://core.telegram.org/api/updates).

**Bots can use this method**

@connection_id [Business connection ID](https://core.telegram.org/api/business#connected-bots).

$400, ConnectionIdInvalidError
*/
account.getBotBusinessConnection#76a86270 connection_id:string = Updates;

/*
Set or remove the [Telegram Business introduction](https://core.telegram.org/api/business#business-introduction).

@intro Telegram Business introduction, to remove it call the method without setting this flag.
*/
account.updateBusinessIntro#a614d034 flags:# intro:flags.0?InputBusinessIntro = Bool;

/*
Pause or unpause a specific chat, temporarily disconnecting it from all [business bots](https://core.telegram.org/api/business#connected-bots).

@peer The chat to pause
@paused Whether to pause or unpause the chat

$400, PeerIdInvalidError
*/
account.toggleConnectedBotPaused#646e1097 peer:InputPeer paused:Bool = Bool;

/*
Permanently disconnect a specific chat from all [business bots](https://core.telegram.org/api/business#connected-bots) (equivalent to specifying it in recipients.exclude_users during initial configuration with [account.updateConnectedBot](https://core.telegram.org/method/account.updateConnectedBot)); to reconnect of a chat disconnected using this method the user must reconnect the entire bot by invoking [account.updateConnectedBot](https://core.telegram.org/method/account.updateConnectedBot).

@peer The chat to disconnect

$400, BotAlreadyDisabledError
$400, BotNotConnectedYetError
$400, PeerIdInvalidError
*/
account.disablePeerConnectedBot#5e437ed9 peer:InputPeer = Bool;

/*
Update our [birthday, see here](https://core.telegram.org/api/profile#birthday) for more info.

@birthday Birthday.

$400, BirthdayInvalidError
*/
account.updateBirthday#cc6e0c11 flags:# birthday:flags.0?Birthday = Bool;

/*
Create a [business chat deep link](https://core.telegram.org/api/business#business-chat-links).

@link Info about the link to create.

$400, ChatlinksTooMuchError
$403, PremiumAccountRequiredError
*/
account.createBusinessChatLink#8851e68e link:InputBusinessChatLink = BusinessChatLink;

/*
Edit a created [business chat deep link](https://core.telegram.org/api/business#business-chat-links).

@slug Slug of the link, obtained as specified [here](https://core.telegram.org/api/links#business-chat-links).
@link New link information.

$400, ChatlinkSlugEmptyError
$403, PremiumAccountRequiredError
*/
account.editBusinessChatLink#8c3410af slug:string link:InputBusinessChatLink = BusinessChatLink;

/*
Delete a [business chat deep link](https://core.telegram.org/api/business#business-chat-links).

@slug Slug of the link, obtained as specified [here](https://core.telegram.org/api/links#business-chat-links).

$400, ChatlinkSlugEmptyError
$400, ChatlinkSlugExpiredError
*/
account.deleteBusinessChatLink#60073674 slug:string = Bool;

/*
List all created [business chat deep links](https://core.telegram.org/api/business#business-chat-links).
*/
account.getBusinessChatLinks#6f70dde1 = account.BusinessChatLinks;

/*
Resolve a [business chat deep link](https://core.telegram.org/api/business#business-chat-links).

@slug Slug of the link, obtained as specified [here](https://core.telegram.org/api/links#business-chat-links).

$400, ChatlinkSlugEmptyError
$400, ChatlinkSlugExpiredError
*/
account.resolveBusinessChatLink#5492e5ee slug:string = account.ResolvedBusinessChatLinks;

/*
Associate (or remove) a personal [channel](https://core.telegram.org/api/channel), that will be listed on our personal [profile page](https://core.telegram.org/api/profile#personal-channel).

@channel The channel, pass [inputChannelEmpty](https://core.telegram.org/constructor/inputChannelEmpty) to remove it.
*/
account.updatePersonalChannel#d94305e0 channel:InputChannel = Bool;

/*
Disable or re-enable Telegram ads for the current [Premium](https://core.telegram.org/api/premium) account.

@enabled Enable or disable ads.
*/
account.toggleSponsoredMessages#b9d9a38d enabled:Bool = Bool;

/*
Get the current [reaction notification settings](https://core.telegram.org/api/reactions#notifications-about-reactions).
*/
account.getReactionsNotifySettings#6dd654c = ReactionsNotifySettings;

/*
Change the [reaction notification settings](https://core.telegram.org/api/reactions#notifications-about-reactions).

@settings New reaction notification settings.
*/
account.setReactionsNotifySettings#316ce548 settings:ReactionsNotifySettings = ReactionsNotifySettings;

account.getCollectibleEmojiStatuses#2e7b4543 hash:long = account.EmojiStatuses;
/*
Returns basic user info according to their identifiers.

**Bots can use this method**

@id List of user identifiers

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, FromMessageBotDisabledError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, UserBannedInChannelError
*/
users.getUsers#d91a548 id:Vector<InputUser> = Vector<User>;

/*
Returns extended user info by ID.

**Bots can use this method**

@id User ID

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MsgIdInvalidError
$400, UsernameOccupiedError
$400, UserIdInvalidError
*/
users.getFullUser#b60f5918 id:InputUser = users.UserFull;

/*
Notify the user that the sent [passport](https://core.telegram.org/passport) data contains some errors The user will not be able to re-submit their Passport data to you until the errors are fixed (the contents of the field for which you returned the error must change).

**Bots can use this method**

@id The user
@errors Errors

$403, UserBotInvalidError
$400, UserBotRequiredError
$400, UserIdInvalidError
*/
users.setSecureValueErrors#90c894b5 id:InputUser errors:Vector<SecureValueError> = Bool;

/*
Check whether we can write to the specified user (this method can only be called by non- [Premium](https://core.telegram.org/api/premium) users), see [here](https://core.telegram.org/api/privacy#require-premium-for-new-non-contact-users) for more info on the full flow.

@id Users to fetch info about.
*/
users.getIsPremiumRequiredToContact#a622aa10 id:Vector<InputUser> = Vector<Bool>;

/*
Get the telegram IDs of all contacts. 
Returns an array of Telegram user IDs for all contacts (0 if a contact does not have an associated Telegram account or have hidden their account using privacy settings).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
*/
contacts.getContactIDs#7adc669d hash:long = Vector<int>;

/*
Use this method to obtain the online statuses of all contacts with an accessible Telegram account.
*/
contacts.getStatuses#c4a353ee = Vector<ContactStatus>;

/*
Returns the current user's contact list.

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation). Note that the hash is computed [using the usual algorithm](https://core.telegram.org/api/offsets#hash-generation), passing to the algorithm first the previously returned [contacts.contacts](https://core.telegram.org/constructor/contacts.contacts). saved_count field, then max 100000 sorted user IDs from the contact list, including the ID of the currently logged in user if it is saved as a contact. Example: [tdlib implementation](https://github.com/tdlib/td/blob/63c7d0301825b78c30dc7307f1f1466be049eb79/td/telegram/UserManager.cpp#L5754).
*/
contacts.getContacts#5dd69e12 hash:long = contacts.Contacts;

/*
Imports contacts: saves a full list on the server, adds already registered contacts to the contact list, returns added contacts and their info.

@contacts List of contacts to import
*/
contacts.importContacts#2c800be5 contacts:Vector<InputContact> = contacts.ImportedContacts;

/*
Deletes several contacts from the list.

@id User ID list

$400, MsgIdInvalidError
*/
contacts.deleteContacts#96a0e00 id:Vector<InputUser> = Updates;

/*
Delete contacts by phone number

@phones Phone numbers
*/
contacts.deleteByPhones#1013fd9e phones:Vector<string> = Bool;

/*
Adds a peer to a blocklist, see [here](https://core.telegram.org/api/block) for more info.

@my_stories_from Whether the peer should be added to the story blocklist; if not set, the peer will be added to the main blocklist, see [here](https://core.telegram.org/api/block) for more info.
@id Peer

$400, ChannelPrivateError
$400, ContactIdInvalidError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
contacts.block#2e2e8734 flags:# my_stories_from:flags.0?true id:InputPeer = Bool;

/*
Deletes a peer from a blocklist, see [here](https://core.telegram.org/api/block) for more info.

@my_stories_from Whether the peer should be removed from the story blocklist; if not set, the peer will be removed from the main blocklist, see [here](https://core.telegram.org/api/block) for more info.
@id Peer

$400, ChannelPrivateError
$400, ContactIdInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
contacts.unblock#b550d328 flags:# my_stories_from:flags.0?true id:InputPeer = Bool;

/*
Returns the list of blocked users.

@my_stories_from Whether to fetch the story blocklist; if not set, will fetch the main blocklist. See [here](https://core.telegram.org/api/block) for differences between the two.
@offset The number of list elements to be skipped
@limit The number of list elements to be returned
*/
contacts.getBlocked#9a868f80 flags:# my_stories_from:flags.0?true offset:int limit:int = contacts.Blocked;

/*
Returns users found by username substring.

@q Target substring
@limit Maximum number of users to be returned

$400, QueryTooShortError
$400, SearchQueryEmptyError
*/
contacts.search#11f812d8 q:string limit:int = contacts.Found;

/*
Resolve a @username to get peer info

**Bots can use this method**

@username @username to resolve
@referer [Referrer ID from referral links](https://core.telegram.org/api/links#referral-links).

$400, ConnectionLayerInvalidError
$400, UsernameInvalidError
$400, UsernameNotOccupiedError
*/
contacts.resolveUsername#725afbbc flags:# username:string referer:flags.0?string = contacts.ResolvedPeer;

/*
Get most used peers

@correspondents Users we've chatted most frequently with
@bots_pm Most used bots
@bots_inline Most used inline bots
@phone_calls Most frequently called users
@forward_users Users to which the users often forwards messages to
@forward_chats Chats to which the users often forwards messages to
@groups Often-opened groups and supergroups
@channels Most frequently visited channels
@bots_app Most frequently used [Main Mini Bot Apps](https://core.telegram.org/api/bots/webapps#main-mini-apps).
@offset Offset for [pagination](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)

$400, TypesEmptyError
*/
contacts.getTopPeers#973478b6 flags:# correspondents:flags.0?true bots_pm:flags.1?true bots_inline:flags.2?true phone_calls:flags.3?true forward_users:flags.4?true forward_chats:flags.5?true groups:flags.10?true channels:flags.15?true bots_app:flags.16?true offset:int limit:int hash:long = contacts.TopPeers;

/*
Reset [rating](https://core.telegram.org/api/top-rating) of top peer

@category Top peer category
@peer Peer whose rating should be reset

$400, PeerIdInvalidError
*/
contacts.resetTopPeerRating#1ae373ac category:TopPeerCategory peer:InputPeer = Bool;

/*
Removes all contacts without an associated Telegram account.
*/
contacts.resetSaved#879537f1 = Bool;

/*
Get all contacts, requires a [takeout session, see here  for more info](https://core.telegram.org/api/takeout).
*/
contacts.getSaved#82f1e39f = Vector<SavedContact>;

/*
Enable/disable [top peers](https://core.telegram.org/api/top-rating)

@enabled Enable/disable
*/
contacts.toggleTopPeers#8514bdda enabled:Bool = Bool;

/*
Add an existing telegram user as contact.

@add_phone_privacy_exception Allow the other user to see our phone number?
@id Telegram ID of the other user
@first_name First name
@last_name Last name
@phone User's phone number, may be omitted to simply add the user to the contact list, without a phone number.

$400, ChannelPrivateError
$400, ContactIdInvalidError
$400, ContactNameEmptyError
$400, MsgIdInvalidError
*/
contacts.addContact#e8f463d0 flags:# add_phone_privacy_exception:flags.0?true id:InputUser first_name:string last_name:string phone:string = Updates;

/*
If the [add contact action bar is active](https://core.telegram.org/api/action-bar#add-contact), add that user as contact

@id The user to add as contact

$400, ContactAddMissingError
$400, ContactIdInvalidError
$400, ContactReqMissingError
$400, MsgIdInvalidError
*/
contacts.acceptContact#f831a20f id:InputUser = Updates;

/*
Get users and geochats near you, see [here](https://core.telegram.org/api/nearby) for more info.

@background While the geolocation of the current user is public, clients should update it in the background every half-an-hour or so, while setting this flag. Do this only if the new location is more than 1 KM away from the previous one, or if the previous location is unknown.
@geo_point Geolocation
@self_expires If set, the geolocation of the current user will be public for the specified number of seconds; pass 0x7fffffff to disable expiry, 0 to make the current geolocation private; if the flag isn't set, no changes will be applied.

$406, BusinessAddressActiveError
$400, GeoPointInvalidError
$406, UserpicPrivacyRequiredError
$406, UserpicUploadRequiredError
*/
contacts.getLocated#d348bc44 flags:# background:flags.1?true geo_point:InputGeoPoint self_expires:flags.0?int = Updates;

/*
Stop getting notifications about [discussion replies](https://core.telegram.org/api/discussion) of a certain user in @replies

@delete_message Whether to delete the specified message as well
@delete_history Whether to delete all @replies messages from this user as well
@report_spam Whether to also report this user for spam
@msg_id ID of the message in the [@replies](https://core.telegram.org/api/discussion#replies) chat

$400, MsgIdInvalidError
*/
contacts.blockFromReplies#29a8962c flags:# delete_message:flags.0?true delete_history:flags.1?true report_spam:flags.2?true msg_id:int = Updates;

/*
Resolve a phone number to get user info, if their privacy settings allow it.

@phone Phone number in international format, possibly obtained from a [phone number deep link](https://core.telegram.org/api/links#phone-number-links).

$400, PhoneNotOccupiedError
*/
contacts.resolvePhone#8af94344 phone:string = contacts.ResolvedPeer;

/*
Generates a [temporary profile link](https://core.telegram.org/api/links#temporary-profile-links) for the currently logged-in user.
*/
contacts.exportContactToken#f8654027 = ExportedContactToken;

/*
Obtain user info from a [temporary profile link](https://core.telegram.org/api/links#temporary-profile-links).

@token The token extracted from the [temporary profile link](https://core.telegram.org/api/links#temporary-profile-links).

$400, ImportTokenInvalidError
*/
contacts.importContactToken#13005788 token:string = User;

/*
Edit the [close friends list, see here](https://core.telegram.org/api/privacy) for more info.

@id Full list of user IDs of close friends, see [here](https://core.telegram.org/api/privacy) for more info.
*/
contacts.editCloseFriends#ba6705f0 id:Vector<long> = Bool;

/*
Replace the contents of an entire [blocklist, see here for more info](https://core.telegram.org/api/block).

@my_stories_from Whether to edit the story blocklist; if not set, will edit the main blocklist. See [here](https://core.telegram.org/api/block) for differences between the two.
@id Full content of the blocklist.
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
*/
contacts.setBlocked#94c65c76 flags:# my_stories_from:flags.0?true id:Vector<InputPeer> limit:int = Bool;

/*
Fetch all users with birthdays that fall within +1/-1 days, relative to the current day: this method should be invoked by clients every 6-8 hours, and if the result is non-empty, it should be used to appropriately update locally cached birthday information in [user](https://core.telegram.org/constructor/user). birthday.
*/
contacts.getBirthdays#daeda864 = contacts.ContactBirthdays;

/*
Returns the list of messages by their IDs.

**Bots can use this method**

@id Message ID list
*/
messages.getMessages#63c66506 id:Vector<InputMessage> = messages.Messages;

/*
Returns the current user dialog list.

@exclude_pinned Exclude pinned dialogs
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@offset_date [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets) ( top_message ID used for pagination)
@offset_peer [Offset peer for pagination](https://core.telegram.org/api/offsets)
@limit Number of list elements to be returned
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)

$403, ChatWriteForbiddenError
$400, FolderIdInvalidError
$400, OffsetPeerIdInvalidError
$400, TakeoutInvalidError
*/
messages.getDialogs#a0f4cb4f flags:# exclude_pinned:flags.0?true folder_id:flags.1?int offset_date:int offset_id:int offset_peer:InputPeer limit:int hash:long = messages.Dialogs;

/*
Returns the conversation history with one interlocutor / within a chat

@peer Target peer
@offset_id Only return messages starting from the specified message ID
@offset_date Only return messages sent before the specified date
@add_offset Number of list elements to be skipped, negative values are also accepted.
@limit Number of results to return
@max_id If a positive value was transferred, the method will return only messages with IDs less than max_id
@min_id If a positive value was transferred, the method will return only messages with IDs more than min_id
@hash [Result hash](https://core.telegram.org/api/offsets)

$400, ChannelInvalidError
$406, ChannelPrivateError
$400, ChatIdInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, TakeoutInvalidError
*/
messages.getHistory#4423e6c5 peer:InputPeer offset_id:int offset_date:int add_offset:int limit:int max_id:int min_id:int hash:long = messages.Messages;

/*
Search for messages.

@peer User or chat, histories with which are searched, or [(inputPeerEmpty)](https://core.telegram.org/constructor/inputPeerEmpty) constructor to search in all private chats and [normal groups (not channels)](https://core.telegram.org/api/channel). Use [messages.searchGlobal](https://core.telegram.org/method/messages.searchGlobal) to search globally in all chats, groups, supergroups and channels.
@q Text search request
@from_id Only return messages sent by the specified user ID
@saved_peer_id Search within the [saved message dialog](https://core.telegram.org/api/saved-messages) with this ID.
@saved_reaction You may search for [saved messages tagged](https://core.telegram.org/api/saved-messages#tags) with one or more reactions using this flag.
@top_msg_id [Thread ID](https://core.telegram.org/api/threads)
@filter Filter to return only specified message types
@min_date If a positive value was transferred, only messages with a sending date bigger than the transferred one will be returned
@max_date If a positive value was transferred, only messages with a sending date smaller than the transferred one will be returned
@offset_id Only return messages starting from the specified message ID
@add_offset [Additional offset](https://core.telegram.org/api/offsets)
@limit [Number of results to return](https://core.telegram.org/api/offsets), can be 0 to only return the message counter.
@max_id [Maximum message ID to return](https://core.telegram.org/api/offsets)
@min_id [Minimum message ID to return](https://core.telegram.org/api/offsets)
@hash [Hash](https://core.telegram.org/api/offsets)

$400, ChannelInvalidError
$400, ChannelPrivateError
$403, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, FromPeerInvalidError
$400, InputFilterInvalidError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, PeerIdNotSupportedError
$400, SearchQueryEmptyError
$400, UserIdInvalidError
*/
messages.search#29ee847a flags:# peer:InputPeer q:string from_id:flags.0?InputPeer saved_peer_id:flags.2?InputPeer saved_reaction:flags.3?Vector<Reaction> top_msg_id:flags.1?int filter:MessagesFilter min_date:int max_date:int offset_id:int add_offset:int limit:int max_id:int min_id:int hash:long = messages.Messages;

/*
Marks message history as read.

@peer Target user or group
@max_id If a positive value is passed, only messages with identifiers less or equal than the given one will be read

$400, ChannelPrivateError
$400, ChatIdInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.readHistory#e306d3a peer:InputPeer max_id:int = messages.AffectedMessages;

/*
Deletes communication history.

@just_clear Just clear history for the current user, without actually removing messages for every chat user
@revoke Whether to delete the message history for all chat participants
@peer User or chat, communication history of which will be deleted
@max_id Maximum ID of message to delete
@min_date Delete all messages newer than this UNIX timestamp
@max_date Delete all messages older than this UNIX timestamp

$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatRevokeDateUnsupportedError
$400, MaxDateInvalidError
$400, MessageIdInvalidError
$400, MinDateInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.deleteHistory#b08f922a flags:# just_clear:flags.0?true revoke:flags.1?true peer:InputPeer max_id:int min_date:flags.2?int max_date:flags.3?int = messages.AffectedHistory;

/*
Deletes messages by their identifiers.

**Bots can use this method**

@revoke Whether to delete messages for all participants of the chat
@id Message ID list

$403, MessageDeleteForbiddenError
$400, MessageIdInvalidError
*/
messages.deleteMessages#e58e95d2 flags:# revoke:flags.0?true id:Vector<int> = messages.AffectedMessages;

/*
Confirms receipt of messages by a client, cancels PUSH-notification sending.

@max_id Maximum message ID available in a client.
*/
messages.receivedMessages#5a954c0 max_id:int = Vector<ReceivedNotifyMessage>;

/*
Sends a current user typing event (see [SendMessageAction](https://core.telegram.org/type/SendMessageAction) for all event types) to a conversation partner or group.

**Bots can use this method**

@peer Target user or group
@top_msg_id [Topic ID](https://core.telegram.org/api/threads)
@action Type of action

$400, BusinessPeerInvalidError
$400, BusinessPeerUsageMissingError
$400, ChannelInvalidError
$406, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$403, ChatWriteForbiddenError
$403, GroupcallForbiddenError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, UserBannedInChannelError
$403, UserIsBlockedError
$400, UserIsBotError
*/
messages.setTyping#58943ee2 flags:# peer:InputPeer top_msg_id:flags.0?int action:SendMessageAction = Bool;

/*
Sends a message to a chat

**Bots can use this method**

@no_webpage Set this flag to disable generation of the webpage preview
@silent Send this message silently (no notifications for the receivers)
@background Send this message as background message
@clear_draft Clear the draft field
@noforwards Only for bots, disallows forwarding and saving of the messages, even if the destination chat doesn't have [content protection](https://telegram.org/blog/protected-content-delete-by-date-and-more) enabled
@update_stickersets_order Whether to move used stickersets to top, [see here for more info on this flag](https://core.telegram.org/api/stickers#recent-stickersets)
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@allow_paid_floodskip Bots only: if set, allows sending up to 1000 messages per second, ignoring [broadcasting limits](https://core.telegram.org/bots/faq#how-can-i-message-all-of-my-bot-39s-subscribers-at-once) for a fee of 0.1 Telegram Stars per message. The relevant Stars will be withdrawn from the bot's balance.
@peer The destination where the message will be sent
@reply_to If set, indicates that the message should be sent in reply to the specified message or story. Also used to quote other messages.
@message The message
@random_id Unique client message ID required to prevent message resending
@reply_markup Reply markup for sending bot buttons
@entities Message [entities](https://core.telegram.org/api/entities) for sending styled text
@schedule_date Scheduled message date for [scheduled messages](https://core.telegram.org/api/scheduled-messages)
@send_as Send this message as the specified peer
@quick_reply_shortcut Add the message to the specified [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts), instead.
@effect Specifies a [message effect](https://core.telegram.org/api/effects) to use for the message.

$400, AdminRightsEmptyError
$400, BotDomainInvalidError
$400, BotInvalidError
$400, BusinessPeerInvalidError
$400, BusinessPeerUsageMissingError
$400, ButtonCopyTextInvalidError
$400, ButtonDataInvalidError
$400, ButtonIdInvalidError
$400, ButtonTypeInvalidError
$400, ButtonUrlInvalidError
$400, ButtonUserInvalidError
$400, ButtonUserPrivacyRestrictedError
$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChatAdminRequiredError
$403, ChatGuestSendForbiddenError
$400, ChatIdInvalidError
$400, ChatRestrictedError
$403, ChatSendPlainForbiddenError
$403, ChatWriteForbiddenError
$400, DocumentInvalidError
$400, EncryptionDeclinedError
$400, EntitiesTooLongError
$400, EntityBoundsInvalidError
$400, EntityMentionUserInvalidError
$400, FromMessageBotDisabledError
$400, InputUserDeactivatedError
$400, MessageEmptyError
$400, MessageTooLongError
$400, MsgIdInvalidError
$500, MsgWaitFailedError
$406, PaymentUnsupportedError
$404, PeerIdInvalidError
$400, PinnedDialogsTooMuchError
$400, PollOptionInvalidError
$403, PremiumAccountRequiredError
$406, PrivacyPremiumRequiredError
$400, QuickRepliesTooMuchError
$400, QuoteTextInvalidError
$500, RandomIdDuplicateError
$400, ReplyMarkupInvalidError
$400, ReplyMarkupTooLongError
$400, ReplyMessagesTooMuchError
$400, ReplyMessageIdInvalidError
$400, ReplyToInvalidError
$400, ReplyToUserInvalidError
$400, ScheduleBotNotAllowedError
$400, ScheduleDateTooLateError
$400, ScheduleStatusPrivateError
$400, ScheduleTooMuchError
$400, SendAsPeerInvalidError
$420, SlowmodeWaitError
$400, StoryIdInvalidError
$406, TopicClosedError
$406, TopicDeletedError
$400, UserBannedInChannelError
$403, UserIsBlockedError
$400, UserIsBotError
$400, WcConvertUrlInvalidError
$400, YouBlockedUserError
*/
messages.sendMessage#983f9745 flags:# no_webpage:flags.1?true silent:flags.5?true background:flags.6?true clear_draft:flags.7?true noforwards:flags.14?true update_stickersets_order:flags.15?true invert_media:flags.16?true allow_paid_floodskip:flags.19?true peer:InputPeer reply_to:flags.0?InputReplyTo message:string random_id:long reply_markup:flags.2?ReplyMarkup entities:flags.3?Vector<MessageEntity> schedule_date:flags.10?int send_as:flags.13?InputPeer quick_reply_shortcut:flags.17?InputQuickReplyShortcut effect:flags.18?long = Updates;

/*
Send a media

**Bots can use this method**

@silent Send message silently (no notification should be triggered)
@background Send message in background
@clear_draft Clear the draft
@noforwards Only for bots, disallows forwarding and saving of the messages, even if the destination chat doesn't have [content protection](https://telegram.org/blog/protected-content-delete-by-date-and-more) enabled
@update_stickersets_order Whether to move used stickersets to top, [see here for more info on this flag](https://core.telegram.org/api/stickers#recent-stickersets)
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@allow_paid_floodskip Bots only: if set, allows sending up to 1000 messages per second, ignoring [broadcasting limits](https://core.telegram.org/bots/faq#how-can-i-message-all-of-my-bot-39s-subscribers-at-once) for a fee of 0.1 Telegram Stars per message. The relevant Stars will be withdrawn from the bot's balance.
@peer Destination
@reply_to If set, indicates that the message should be sent in reply to the specified message or story.
@media Attached media
@message Caption
@random_id Random ID to avoid resending the same message
@reply_markup Reply markup for bot keyboards
@entities Message [entities](https://core.telegram.org/api/entities) for styled text
@schedule_date Scheduled message date for [scheduled messages](https://core.telegram.org/api/scheduled-messages)
@send_as Send this message as the specified peer
@quick_reply_shortcut Add the message to the specified [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts), instead.
@effect Specifies a [message effect](https://core.telegram.org/api/effects) to use for the message.

$400, BotGamesDisabledError
$400, BotPaymentsDisabledError
$400, BroadcastPublicVotersForbiddenError
$400, BusinessPeerInvalidError
$400, ButtonCopyTextInvalidError
$400, ButtonDataInvalidError
$400, ButtonPosInvalidError
$400, ButtonTypeInvalidError
$400, ButtonUrlInvalidError
$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChatAdminRequiredError
$400, ChatForwardsRestrictedError
$403, ChatGuestSendForbiddenError
$400, ChatRestrictedError
$403, ChatSendAudiosForbiddenError
$403, ChatSendDocsForbiddenError
$403, ChatSendGifsForbiddenError
$403, ChatSendMediaForbiddenError
$403, ChatSendPhotosForbiddenError
$403, ChatSendPlainForbiddenError
$403, ChatSendPollForbiddenError
$403, ChatSendRoundvideosForbiddenError
$403, ChatSendStickersForbiddenError
$403, ChatSendVideosForbiddenError
$403, ChatSendVoicesForbiddenError
$403, ChatWriteForbiddenError
$400, CurrencyTotalAmountInvalidError
$400, DocumentInvalidError
$400, EmoticonInvalidError
$400, EntityBoundsInvalidError
$400, ExtendedMediaAmountInvalidError
$400, ExternalUrlInvalidError
$400, FilePartsInvalidError
$400, FilePartLengthInvalidError
$400, FileReferenceEmptyError
$400, FileReferenceExpiredError
$400, GameBotInvalidError
$400, ImageProcessFailedError
$400, InputFileInvalidError
$400, InputUserDeactivatedError
$400, InvoicePayloadInvalidError
$400, Md5ChecksumInvalidError
$400, MediaCaptionTooLongError
$400, MediaEmptyError
$400, MediaInvalidError
$400, MessageEmptyError
$400, MsgIdInvalidError
$400, PaymentProviderInvalidError
$400, PeerIdInvalidError
$400, PhotoExtInvalidError
$400, PhotoInvalidDimensionsError
$400, PhotoSaveFileInvalidError
$400, PollAnswersInvalidError
$400, PollAnswerInvalidError
$400, PollOptionDuplicateError
$400, PollOptionInvalidError
$400, PollQuestionInvalidError
$403, PremiumAccountRequiredError
$403, PrivacyPremiumRequiredError
$400, QuickRepliesTooMuchError
$400, QuizCorrectAnswersEmptyError
$400, QuizCorrectAnswersTooMuchError
$400, QuizCorrectAnswerInvalidError
$400, QuizMultipleInvalidError
$500, RandomIdDuplicateError
$400, ReplyMarkupBuyEmptyError
$400, ReplyMarkupGameEmptyError
$400, ReplyMarkupInvalidError
$400, ReplyMarkupTooLongError
$400, ReplyMessagesTooMuchError
$400, ScheduleBotNotAllowedError
$400, ScheduleDateTooLateError
$400, ScheduleTooMuchError
$400, SendAsPeerInvalidError
$420, SlowmodeWaitError
$400, StarsInvoiceInvalidError
$400, StoryIdInvalidError
$400, SubscriptionExportMissingError
$400, TermsUrlInvalidError
$406, TopicClosedError
$406, TopicDeletedError
$400, TtlMediaInvalidError
$400, UserBannedInChannelError
$403, UserIsBlockedError
$400, UserIsBotError
$400, VideoContentTypeInvalidError
$400, VoiceMessagesForbiddenError
$400, WebdocumentMimeInvalidError
$400, WebpageCurlFailedError
$400, WebpageMediaEmptyError
$400, WebpageNotFoundError
$400, WebpageUrlInvalidError
$400, YouBlockedUserError
*/
messages.sendMedia#7852834e flags:# silent:flags.5?true background:flags.6?true clear_draft:flags.7?true noforwards:flags.14?true update_stickersets_order:flags.15?true invert_media:flags.16?true allow_paid_floodskip:flags.19?true peer:InputPeer reply_to:flags.0?InputReplyTo media:InputMedia message:string random_id:long reply_markup:flags.2?ReplyMarkup entities:flags.3?Vector<MessageEntity> schedule_date:flags.10?int send_as:flags.13?InputPeer quick_reply_shortcut:flags.17?InputQuickReplyShortcut effect:flags.18?long = Updates;

/*
Forwards messages by their IDs.

**Bots can use this method**

@silent Whether to send messages silently (no notification will be triggered on the destination clients)
@background Whether to send the message in background
@with_my_score When forwarding games, whether to include your score in the game
@drop_author Whether to forward messages without quoting the original author
@drop_media_captions Whether to strip captions from media
@noforwards Only for bots, disallows further re-forwarding and saving of the messages, even if the destination chat doesn't have [content protection](https://telegram.org/blog/protected-content-delete-by-date-and-more) enabled
@allow_paid_floodskip Bots only: if set, allows sending up to 1000 messages per second, ignoring [broadcasting limits](https://core.telegram.org/bots/faq#how-can-i-message-all-of-my-bot-39s-subscribers-at-once) for a fee of 0.1 Telegram Stars per message. The relevant Stars will be withdrawn from the bot's balance.
@from_peer Source of messages
@id IDs of messages
@random_id Random ID to prevent resending of messages
@to_peer Destination peer
@top_msg_id Destination [forum topic](https://core.telegram.org/api/forum#forum-topics)
@schedule_date Scheduled message date for scheduled messages
@send_as Forward the messages as the specified peer
@quick_reply_shortcut Add the messages to the specified [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts), instead.
@video_timestamp  ... 

$400, BroadcastPublicVotersForbiddenError
$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChatAdminRequiredError
$406, ChatForwardsRestrictedError
$403, ChatGuestSendForbiddenError
$400, ChatIdInvalidError
$400, ChatRestrictedError
$403, ChatSendAudiosForbiddenError
$403, ChatSendDocsForbiddenError
$403, ChatSendGameForbiddenError
$403, ChatSendGifsForbiddenError
$403, ChatSendMediaForbiddenError
$403, ChatSendPhotosForbiddenError
$403, ChatSendPlainForbiddenError
$403, ChatSendPollForbiddenError
$403, ChatSendStickersForbiddenError
$403, ChatSendVideosForbiddenError
$403, ChatSendVoicesForbiddenError
$403, ChatWriteForbiddenError
$400, GroupedMediaInvalidError
$400, InputUserDeactivatedError
$400, MediaEmptyError
$400, MessageIdsEmptyError
$400, MessageIdInvalidError
$400, MsgIdInvalidError
$406, PaymentUnsupportedError
$400, PeerIdInvalidError
$403, PremiumAccountRequiredError
$406, PrivacyPremiumRequiredError
$400, QuickRepliesTooMuchError
$400, QuizAnswerMissingError
$500, RandomIdDuplicateError
$400, RandomIdInvalidError
$400, ReplyMessagesTooMuchError
$400, ScheduleBotNotAllowedError
$400, ScheduleDateTooLateError
$400, ScheduleTooMuchError
$400, SendAsPeerInvalidError
$400, SlowmodeMultiMsgsDisabledError
$420, SlowmodeWaitError
$406, TopicClosedError
$406, TopicDeletedError
$400, UserBannedInChannelError
$403, UserIsBlockedError
$400, UserIsBotError
$403, VoiceMessagesForbiddenError
$400, YouBlockedUserError

#DocError
*/
messages.forwardMessages#6d74da08 flags:# silent:flags.5?true background:flags.6?true with_my_score:flags.8?true drop_author:flags.11?true drop_media_captions:flags.12?true noforwards:flags.14?true allow_paid_floodskip:flags.19?true from_peer:InputPeer id:Vector<int> random_id:Vector<long> to_peer:InputPeer top_msg_id:flags.9?int schedule_date:flags.10?int send_as:flags.13?InputPeer quick_reply_shortcut:flags.17?InputQuickReplyShortcut video_timestamp:flags.20?int = Updates;

/*
Report a new incoming chat for spam, if the [peer settings](https://core.telegram.org/constructor/peerSettings) of the chat allow us to do that

@peer Peer to report

$400, ChannelPrivateError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.reportSpam#cf1592db peer:InputPeer = Bool;

/*
Get peer settings

@peer The peer

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.getPeerSettings#efd9a6a2 peer:InputPeer = messages.PeerSettings;

/*
Report a message in a chat for violation of telegram's Terms of Service

@peer Peer
@id IDs of messages to report
@option Menu option, intially empty
@message Comment for report moderation

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, PeerIdInvalidError
*/
messages.report#fc78af9b peer:InputPeer id:Vector<int> option:bytes message:string = ReportResult;

/*
Returns chat basic info on their IDs.

**Bots can use this method**

@id List of chat IDs

$400, ChatIdInvalidError
$400, PeerIdInvalidError
*/
messages.getChats#49e9528f id:Vector<long> = messages.Chats;

/*
Get full info about a [basic group](https://core.telegram.org/api/channel#basic-groups).

**Bots can use this method**

@chat_id [Basic group](https://core.telegram.org/api/channel#basic-groups) ID.

$400, ChatIdInvalidError
$400, PeerIdInvalidError
*/
messages.getFullChat#aeb00b34 chat_id:long = messages.ChatFull;

/*
Changes chat name and sends a service message on it.

**Bots can use this method**

@chat_id Chat ID
@title New chat name, different from the old one

$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatNotModifiedError
$400, ChatTitleEmptyError
$400, PeerIdInvalidError
*/
messages.editChatTitle#73783ffd chat_id:long title:string = Updates;

/*
Changes chat photo and sends a service message on it

**Bots can use this method**

@chat_id Chat ID
@photo Photo to be set

$400, ChatIdInvalidError
$400, ChatNotModifiedError
$400, ImageProcessFailedError
$400, PeerIdInvalidError
$400, PhotoCropSizeSmallError
$400, PhotoExtInvalidError
$400, PhotoInvalidError
*/
messages.editChatPhoto#35ddd674 chat_id:long photo:InputChatPhoto = Updates;

/*
Adds a user to a chat and sends a service message on it.

@chat_id Chat ID
@user_id User ID to be added
@fwd_limit Number of last messages to be forwarded

$400, BotGroupsBlockedError
$403, ChatAdminRequiredError
$400, ChatIdInvalidError
$403, ChatWriteForbiddenError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, UsersTooMuchError
$400, UserAlreadyParticipantError
$400, UserIdInvalidError
$400, UserIsBlockedError
$403, UserNotMutualContactError
$403, UserPrivacyRestrictedError
$400, YouBlockedUserError
*/
messages.addChatUser#cbc6d107 chat_id:long user_id:InputUser fwd_limit:int = messages.InvitedUsers;

/*
Deletes a user from a chat and sends a service message on it.

**Bots can use this method**

@revoke_history Remove the entire chat history of the specified user in this chat.
@chat_id Chat ID
@user_id User ID to be deleted

$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, InputUserDeactivatedError
$400, PeerIdInvalidError
$400, UserIdInvalidError
$400, UserNotParticipantError
*/
messages.deleteChatUser#a2185cab flags:# revoke_history:flags.0?true chat_id:long user_id:InputUser = Updates;

/*
Creates a new chat.

@users List of user IDs to be invited
@title Chat name
@ttl_period Time-to-live of all messages that will be sent in the chat: once message.date+message.ttl_period === time(), the message will be deleted on the server, and must be deleted locally as well. You can use [messages.setDefaultHistoryTTL](https://core.telegram.org/method/messages.setDefaultHistoryTTL) to edit this value later.

$500, ChatIdGenerateFailedError
$400, ChatInvalidError
$400, ChatTitleEmptyError
$400, InputUserDeactivatedError
$400, TtlPeriodInvalidError
$400, UsersTooFewError
$406, UserRestrictedError
*/
messages.createChat#92ceddd4 flags:# users:Vector<InputUser> title:string ttl_period:flags.0?int = messages.InvitedUsers;

/*
Returns configuration parameters for Diffie-Hellman key generation. Can also return a random sequence of bytes of required length.

@version Value of the version parameter from [messages.dhConfig](https://core.telegram.org/constructor/messages.dhConfig), available at the client
@random_length Length of the required random sequence

$400, RandomLengthInvalidError
*/
messages.getDhConfig#26cf8950 version:int random_length:int = messages.DhConfig;

/*
Sends a request to start a secret chat to the user.

@user_id User ID
@random_id Unique client request ID required to prevent resending. This also doubles as the chat ID.
@g_a A = g ^ a mod p, see [Wikipedia](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)

$400, DhGAInvalidError
$400, InputUserDeactivatedError
$400, UserIdInvalidError
*/
messages.requestEncryption#f64daf43 user_id:InputUser random_id:int g_a:bytes = EncryptedChat;

/*
Confirms creation of a secret chat

@peer Secret chat ID
@g_b B = g ^ b mod p, see [Wikipedia](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange)
@key_fingerprint 64-bit fingerprint of the received key

$400, ChatIdInvalidError
$400, EncryptionAlreadyAcceptedError
$400, EncryptionAlreadyDeclinedError
*/
messages.acceptEncryption#3dbc0415 peer:InputEncryptedChat g_b:bytes key_fingerprint:long = EncryptedChat;

/*
Cancels a request for creation and/or delete info on secret chat.

@delete_history Whether to delete the entire chat history for the other user as well
@chat_id Secret chat ID

$400, ChatIdEmptyError
$400, EncryptionAlreadyAcceptedError
$400, EncryptionAlreadyDeclinedError
$400, EncryptionIdInvalidError
*/
messages.discardEncryption#f393aea0 flags:# delete_history:flags.0?true chat_id:int = Bool;

/*
Send typing event by the current user to a secret chat.

@peer Secret chat ID
@typing Typing. Possible values: [(boolTrue)](https://core.telegram.org/constructor/boolTrue), if the user started typing and more than 5 seconds have passed since the last request [(boolFalse)](https://core.telegram.org/constructor/boolFalse), if the user stopped typing

$400, ChatIdInvalidError
*/
messages.setEncryptedTyping#791451ed peer:InputEncryptedChat typing:Bool = Bool;

/*
Marks message history within a secret chat as read.

@peer Secret chat ID
@max_date Maximum date value for received messages in history

$400, ChatIdInvalidError
$400, MaxDateInvalidError
$400, MsgWaitFailedError
*/
messages.readEncryptedHistory#7f4b690a peer:InputEncryptedChat max_date:int = Bool;

/*
Sends a text message to a secret chat.

@silent Send encrypted message without a notification
@peer Secret chat ID
@random_id Unique client message ID, necessary to avoid message resending
@data TL-serialization of [DecryptedMessage](https://core.telegram.org/type/DecryptedMessage) type, encrypted with a key that was created during chat initialization

$400, ChatIdInvalidError
$400, DataInvalidError
$400, DataTooLongError
$400, EncryptionDeclinedError
$500, MsgWaitFailedError
$403, UserIsBlockedError
*/
messages.sendEncrypted#44fa7a15 flags:# silent:flags.0?true peer:InputEncryptedChat random_id:long data:bytes = messages.SentEncryptedMessage;

/*
Sends a message with a file attachment to a secret chat

@silent Whether to send the file without triggering a notification
@peer Secret chat ID
@random_id Unique client message ID necessary to prevent message resending
@data TL-serialization of [DecryptedMessage](https://core.telegram.org/type/DecryptedMessage) type, encrypted with a key generated during chat initialization
@file File attachment for the secret chat

$400, ChatIdInvalidError
$400, DataTooLongError
$400, EncryptionDeclinedError
$400, FileEmtpyError
$400, Md5ChecksumInvalidError
$400, MsgWaitFailedError
*/
messages.sendEncryptedFile#5559481d flags:# silent:flags.0?true peer:InputEncryptedChat random_id:long data:bytes file:InputEncryptedFile = messages.SentEncryptedMessage;

/*
Sends a service message to a secret chat.

@peer Secret chat ID
@random_id Unique client message ID required to prevent message resending
@data TL-serialization of  [DecryptedMessage](https://core.telegram.org/type/DecryptedMessage) type, encrypted with a key generated during chat initialization

$400, ChatIdInvalidError
$400, DataInvalidError
$400, EncryptionDeclinedError
$400, EncryptionIdInvalidError
$500, MsgWaitFailedError
$403, UserDeletedError
$403, UserIsBlockedError
*/
messages.sendEncryptedService#32d439a4 peer:InputEncryptedChat random_id:long data:bytes = messages.SentEncryptedMessage;

/*
Confirms receipt of messages in a secret chat by client, cancels push notifications. 
The method returns a list of random_ids of messages for which push notifications were cancelled.

@max_qts Maximum qts value available at the client

$400, MaxQtsInvalidError
$500, MsgWaitFailedError
*/
messages.receivedQueue#55a5bb66 max_qts:int = Vector<long>;

/*
Report a secret chat for spam

@peer The secret chat to report

$400, ChatIdInvalidError
*/
messages.reportEncryptedSpam#4b0c8c0f peer:InputEncryptedChat = Bool;

/*
Notifies the sender about the recipient having listened a voice message or watched a video.

@id Message ID list
*/
messages.readMessageContents#36a73f77 id:Vector<int> = messages.AffectedMessages;

/*
Get stickers by emoji

@emoticon The emoji
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).

$400, EmoticonEmptyError
*/
messages.getStickers#d5a5d3a1 emoticon:string hash:long = messages.Stickers;

/*
Get all installed stickers

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getAllStickers#b8a0a1a8 hash:long = messages.AllStickers;

/*
Get preview of webpage

@message Message from which to extract the preview
@entities [Message entities for styled text](https://core.telegram.org/api/entities)

$400, EntityBoundsInvalidError
$400, MessageEmptyError
*/
messages.getWebPagePreview#570d6f6f flags:# message:string entities:flags.3?Vector<MessageEntity> = messages.WebPagePreview;

/*
Export an invite link for a chat

**Bots can use this method**

@legacy_revoke_permanent Legacy flag, reproducing legacy behavior of this method: if set, revokes all previous links before creating a new one. Kept for bot API BC, should not be used by modern clients.
@request_needed Whether admin confirmation is required before admitting each separate user into the chat
@peer Chat
@expire_date Expiration date
@usage_limit Maximum number of users that can join using this link
@title Description of the invite link, visible only to administrators
@subscription_pricing For [Telegram Star subscriptions](https://core.telegram.org/api/stars#star-subscriptions), contains the pricing of the subscription the user must activate to join the private channel.

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$403, ChatWriteForbiddenError
$400, ExpireDateInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, PricingChatInvalidError
$400, SubscriptionPeriodInvalidError
$400, UsageLimitInvalidError
*/
messages.exportChatInvite#a455de90 flags:# legacy_revoke_permanent:flags.2?true request_needed:flags.3?true peer:InputPeer expire_date:flags.0?int usage_limit:flags.1?int title:flags.4?string subscription_pricing:flags.5?StarsSubscriptionPricing = ExportedChatInvite;

/*
Check the validity of a chat invite link and get basic info about it

@hash Invite hash from [chat invite deep link](https://core.telegram.org/api/links#chat-invite-links).

$406, ChannelPrivateError
$400, InviteHashEmptyError
$406, InviteHashExpiredError
$400, InviteHashInvalidError
*/
messages.checkChatInvite#3eadb1bb hash:string = ChatInvite;

/*
Import a chat invite and join a private chat/supergroup/channel

@hash hash from a [chat invite deep link](https://core.telegram.org/api/links#chat-invite-links)

$400, ChannelsTooMuchError
$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatInvalidError
$400, InviteHashEmptyError
$406, InviteHashExpiredError
$400, InviteHashInvalidError
$400, InviteRequestSentError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, StarsPaymentRequiredError
$400, UsersTooMuchError
$400, UserAlreadyParticipantError
$400, UserChannelsTooMuchError
*/
messages.importChatInvite#6c50051c hash:string = Updates;

/*
Get info about a stickerset

**Bots can use this method**

@stickerset Stickerset
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)

$400, EmoticonStickerpackMissingError
$406, StickersetInvalidError
*/
messages.getStickerSet#c8a0ec74 stickerset:InputStickerSet hash:int = messages.StickerSet;

/*
Install a stickerset

@stickerset Stickerset to install
@archived Whether to archive stickerset

$406, StickersetInvalidError
*/
messages.installStickerSet#c78fe460 stickerset:InputStickerSet archived:Bool = messages.StickerSetInstallResult;

/*
Uninstall a stickerset

@stickerset The stickerset to uninstall

$406, StickersetInvalidError
*/
messages.uninstallStickerSet#f96e55de stickerset:InputStickerSet = Bool;

/*
Start a conversation with a bot using a [deep linking parameter](https://core.telegram.org/api/links#bot-links)

@bot The bot
@peer The chat where to start the bot, can be the bot's private chat or a group
@random_id Random ID to avoid resending the same message
@start_param [Deep linking parameter](https://core.telegram.org/api/links#bot-links)

$400, BotInvalidError
$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$500, RandomIdDuplicateError
$400, StartParamEmptyError
$400, StartParamInvalidError
$400, StartParamTooLongError
*/
messages.startBot#e6df7378 bot:InputUser peer:InputPeer random_id:long start_param:string = Updates;

/*
Get and increase the view counter of a message sent or forwarded from a [channel](https://core.telegram.org/api/channel)

@peer Peer where the message was found
@id ID of message
@increment Whether to mark the message as viewed and increment the view counter

$400, ChannelInvalidError
$406, ChannelPrivateError
$400, ChatIdInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.getMessagesViews#5784d3e1 peer:InputPeer id:Vector<int> increment:Bool = messages.MessageViews;

/*
Make a user admin in a [basic group](https://core.telegram.org/api/channel#basic-groups).

@chat_id The ID of the group
@user_id The user to make admin
@is_admin Whether to make them admin

$400, ChatIdInvalidError
$400, PeerIdInvalidError
$400, UserIdInvalidError
$400, UserNotParticipantError
*/
messages.editChatAdmin#a85bd1c2 chat_id:long user_id:InputUser is_admin:Bool = Bool;

/*
Turn a [basic group into a supergroup](https://core.telegram.org/api/channel#migration)

@chat_id [Basic group](https://core.telegram.org/api/channel#basic-groups) to migrate

$400, ChannelsTooMuchError
$403, ChatAdminRequiredError
$400, ChatIdInvalidError
$500, ChatInvalidError
$400, PeerIdInvalidError
*/
messages.migrateChat#a2875319 chat_id:long = Updates;

/*
Search for messages and peers globally

@broadcasts_only If set, only returns results from channels (used in the [global channel search tab](https://core.telegram.org/api/search#global-search)).
@groups_only Whether to search only in groups
@users_only Whether to search only in private chats
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@q Query
@filter Global search filter
@min_date If a positive value was specified, the method will return only messages with date bigger than min_date
@max_date If a positive value was transferred, the method will return only messages with date smaller than max_date
@offset_rate Initially 0, then set to the [next_rate parameter of messages.messagesSlice](https://core.telegram.org/constructor/messages.messagesSlice)
@offset_peer [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)

$400, FolderIdInvalidError
$400, InputFilterInvalidError
$400, SearchQueryEmptyError
*/
messages.searchGlobal#4bc6589a flags:# broadcasts_only:flags.1?true groups_only:flags.2?true users_only:flags.3?true folder_id:flags.0?int q:string filter:MessagesFilter min_date:int max_date:int offset_rate:int offset_peer:InputPeer offset_id:int limit:int = messages.Messages;

/*
Reorder installed stickersets

@masks Reorder mask stickersets
@emojis Reorder [custom emoji stickersets](https://core.telegram.org/api/custom-emoji)
@order New stickerset order by stickerset IDs
*/
messages.reorderStickerSets#78337739 flags:# masks:flags.0?true emojis:flags.1?true order:Vector<long> = Bool;

/*
Get a document by its SHA256 hash, mainly used for gifs

**Bots can use this method**

@sha256 SHA256 of file
@size Size of the file in bytes
@mime_type Mime type

$400, Sha256HashInvalidError
*/
messages.getDocumentByHash#b1f2061f sha256:bytes size:long mime_type:string = Document;

/*
Get saved GIFs.

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getSavedGifs#5cf09635 hash:long = messages.SavedGifs;

/*
Add GIF to saved gifs list

@id GIF to save
@unsave Whether to remove GIF from saved gifs list

$400, GifIdInvalidError
*/
messages.saveGif#327a30cb id:InputDocument unsave:Bool = Bool;

/*
Query an inline bot

@bot The bot to query
@peer The currently opened chat
@geo_point The geolocation, if requested
@query The query
@offset The offset within the results, will be passed directly as-is to the bot.

$400, BotInlineDisabledError
$400, BotInvalidError
$400, BotResponseTimeoutError
$400, ChannelInvalidError
$406, ChannelPrivateError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$-503, TimeoutError
*/
messages.getInlineBotResults#514e999d flags:# bot:InputUser peer:InputPeer geo_point:flags.0?InputGeoPoint query:string offset:string = messages.BotResults;

/*
Answer an inline query, for bots only

**Bots can use this method**

@gallery Set this flag if the results are composed of media files
@private Set this flag if results may be cached on the server side only for the user that sent the query. By default, results may be returned to any user who sends the same query
@query_id Unique identifier for the answered query
@results Vector of results for the inline query
@cache_time The maximum amount of time in seconds that the result of the inline query may be cached on the server. Defaults to 300.
@next_offset Pass the offset that a client should send in the next query with the same text to receive more results. Pass an empty string if there are no more results or if you don't support pagination. Offset length can't exceed 64 bytes.
@switch_pm If passed, clients will display a button on top of the remaining inline result list with the specified text, that switches the user to a private chat with the bot and sends the bot a start message with a certain parameter.
@switch_webview If passed, clients will display a button on top of the remaining inline result list with the specified text, that switches the user to the specified [inline mode mini app](https://core.telegram.org/api/bots/webapps#inline-mode-mini-apps).

$400, ArticleTitleEmptyError
$400, AudioContentUrlEmptyError
$400, AudioTitleEmptyError
$400, ButtonDataInvalidError
$400, ButtonTypeInvalidError
$400, ButtonUrlInvalidError
$400, DocumentInvalidError
$400, FileContentTypeInvalidError
$400, FileTitleEmptyError
$400, GifContentTypeInvalidError
$400, MessageEmptyError
$400, MessageTooLongError
$400, NextOffsetInvalidError
$400, PeerTypesInvalidError
$400, PhotoContentTypeInvalidError
$400, PhotoContentUrlEmptyError
$400, PhotoInvalidError
$400, PhotoThumbUrlEmptyError
$400, QueryIdInvalidError
$400, ReplyMarkupInvalidError
$400, ResultsTooMuchError
$400, ResultIdDuplicateError
$400, ResultIdInvalidError
$400, ResultTypeInvalidError
$400, SendMessageMediaInvalidError
$400, SendMessageTypeInvalidError
$400, StartParamEmptyError
$400, StartParamInvalidError
$400, StickerDocumentInvalidError
$400, SwitchPmTextEmptyError
$400, SwitchWebviewUrlInvalidError
$400, UrlInvalidError
$403, UserBotInvalidError
$400, UserBotRequiredError
$400, VideoContentTypeInvalidError
$400, VideoTitleEmptyError
$400, WebdocumentInvalidError
$400, WebdocumentMimeInvalidError
$400, WebdocumentSizeTooBigError
$400, WebdocumentUrlInvalidError
*/
messages.setInlineBotResults#bb12a419 flags:# gallery:flags.0?true private:flags.1?true query_id:long results:Vector<InputBotInlineResult> cache_time:int next_offset:flags.2?string switch_pm:flags.3?InlineBotSwitchPM switch_webview:flags.4?InlineBotWebView = Bool;

/*
Send a result obtained using [messages.getInlineBotResults](https://core.telegram.org/method/messages.getInlineBotResults).

@silent Whether to send the message silently (no notification will be triggered on the other client)
@background Whether to send the message in background
@clear_draft Whether to clear the [draft](https://core.telegram.org/api/drafts)
@hide_via Whether to hide the via @botname in the resulting message (only for bot usernames encountered in the [config](https://core.telegram.org/constructor/config))
@peer Destination
@reply_to If set, indicates that the message should be sent in reply to the specified message or story.
@random_id Random ID to avoid resending the same query
@query_id Query ID from [messages.getInlineBotResults](https://core.telegram.org/method/messages.getInlineBotResults)
@id Result ID from [messages.getInlineBotResults](https://core.telegram.org/method/messages.getInlineBotResults)
@schedule_date Scheduled message date for scheduled messages
@send_as Send this message as the specified peer
@quick_reply_shortcut Add the message to the specified [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts), instead.

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$403, ChatGuestSendForbiddenError
$400, ChatRestrictedError
$403, ChatSendAudiosForbiddenError
$403, ChatSendGameForbiddenError
$403, ChatSendGifsForbiddenError
$403, ChatSendInlineForbiddenError
$403, ChatSendMediaForbiddenError
$403, ChatSendPhotosForbiddenError
$403, ChatSendPlainForbiddenError
$403, ChatSendStickersForbiddenError
$403, ChatSendVoicesForbiddenError
$403, ChatWriteForbiddenError
$400, EntityBoundsInvalidError
$400, InlineResultExpiredError
$400, InputUserDeactivatedError
$400, MediaEmptyError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, QueryIdEmptyError
$400, QuickRepliesTooMuchError
$500, RandomIdDuplicateError
$400, ReplyMessagesTooMuchError
$400, ResultIdEmptyError
$400, ResultIdInvalidError
$400, ScheduleDateTooLateError
$400, ScheduleTooMuchError
$500, SendMediaInvalidError
$420, SlowmodeWaitError
$400, TopicDeletedError
$400, UserBannedInChannelError
$400, VoiceMessagesForbiddenError
$400, WebpageCurlFailedError
$400, WebpageMediaEmptyError
$400, YouBlockedUserError
*/
messages.sendInlineBotResult#3ebee86a flags:# silent:flags.5?true background:flags.6?true clear_draft:flags.7?true hide_via:flags.11?true peer:InputPeer reply_to:flags.0?InputReplyTo random_id:long query_id:long id:string schedule_date:flags.10?int send_as:flags.13?InputPeer quick_reply_shortcut:flags.17?InputQuickReplyShortcut = Updates;

/*
Find out if a media message's caption can be edited

@peer Peer where the media was sent
@id ID of message

$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$403, MessageAuthorRequiredError
$400, MessageIdInvalidError
$400, PeerIdInvalidError
*/
messages.getMessageEditData#fda68d36 peer:InputPeer id:int = messages.MessageEditData;

/*
Edit message

**Bots can use this method**

@no_webpage Disable webpage preview
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@peer Where was the message sent
@id ID of the message to edit
@message New message
@media New attached media
@reply_markup Reply markup for inline keyboards
@entities [Message entities for styled text](https://core.telegram.org/api/entities)
@schedule_date Scheduled message date for [scheduled messages](https://core.telegram.org/api/scheduled-messages)
@quick_reply_shortcut_id If specified, edits a [quick reply shortcut message, instead](https://core.telegram.org/api/business#quick-reply-shortcuts).

$400, BotDomainInvalidError
$400, BotInvalidError
$400, ButtonCopyTextInvalidError
$400, ButtonDataInvalidError
$400, ButtonTypeInvalidError
$400, ButtonUrlInvalidError
$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChatAdminRequiredError
$400, ChatForwardsRestrictedError
$403, ChatSendGifsForbiddenError
$403, ChatWriteForbiddenError
$400, DocumentInvalidError
$400, EntitiesTooLongError
$400, EntityBoundsInvalidError
$400, FilePartsInvalidError
$400, ImageProcessFailedError
$403, InlineBotRequiredError
$400, InputUserDeactivatedError
$400, MediaCaptionTooLongError
$400, MediaEmptyError
$400, MediaGroupedInvalidError
$400, MediaInvalidError
$400, MediaNewInvalidError
$400, MediaPrevInvalidError
$400, MediaTtlInvalidError
$403, MessageAuthorRequiredError
$400, MessageEditTimeExpiredError
$400, MessageEmptyError
$400, MessageIdInvalidError
$400, MessageNotModifiedError
$400, MessageTooLongError
$400, MsgIdInvalidError
$500, MsgWaitFailedError
$400, PeerIdInvalidError
$400, PeerTypesInvalidError
$400, ReplyMarkupInvalidError
$400, ReplyMarkupTooLongError
$400, ScheduleDateInvalidError
$400, UserBannedInChannelError
$400, WebpageNotFoundError
*/
messages.editMessage#dfd14005 flags:# no_webpage:flags.1?true invert_media:flags.16?true peer:InputPeer id:int message:flags.11?string media:flags.14?InputMedia reply_markup:flags.2?ReplyMarkup entities:flags.3?Vector<MessageEntity> schedule_date:flags.15?int quick_reply_shortcut_id:flags.17?int = Updates;

/*
Edit an inline bot message

**Bots can use this method**

@no_webpage Disable webpage preview
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@id Sent inline message ID
@message Message
@media Media
@reply_markup Reply markup for inline keyboards
@entities [Message entities for styled text](https://core.telegram.org/api/entities)

$400, ButtonDataInvalidError
$400, EntityBoundsInvalidError
$400, MessageIdInvalidError
$400, MessageNotModifiedError
*/
messages.editInlineBotMessage#83557dba flags:# no_webpage:flags.1?true invert_media:flags.16?true id:InputBotInlineMessageID message:flags.11?string media:flags.14?InputMedia reply_markup:flags.2?ReplyMarkup entities:flags.3?Vector<MessageEntity> = Bool;

/*
Press an inline callback button and get a callback answer from the bot

@game Whether this is a "play game" button
@peer Where was the inline keyboard sent
@msg_id ID of the Message with the inline keyboard
@data Callback data
@password For buttons [requiring you to verify your identity with your 2FA password](https://core.telegram.org/constructor/keyboardButtonCallback), the SRP payload generated using [SRP](https://core.telegram.org/api/srp).

$400, BotResponseTimeoutError
$400, ChannelInvalidError
$400, ChannelPrivateError
$400, DataInvalidError
$400, MessageIdInvalidError
$400, PasswordMissingError
$400, PeerIdInvalidError
$-503, TimeoutError
*/
messages.getBotCallbackAnswer#9342ca07 flags:# game:flags.1?true peer:InputPeer msg_id:int data:flags.0?bytes password:flags.2?InputCheckPasswordSRP = messages.BotCallbackAnswer;

/*
Set the callback answer to a user button press (bots only)

**Bots can use this method**

@alert Whether to show the message as a popup instead of a toast notification
@query_id Query ID
@message Popup to show
@url URL to open
@cache_time Cache validity

$400, MessageTooLongError
$400, QueryIdInvalidError
$400, UrlInvalidError
$400, UserBotRequiredError
*/
messages.setBotCallbackAnswer#d58f130a flags:# alert:flags.1?true query_id:long message:flags.0?string url:flags.2?string cache_time:int = Bool;

/*
Get dialog info of specified peers

@peers Peers

$400, ChannelInvalidError
$406, ChannelPrivateError
$400, InputPeersEmptyError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.getPeerDialogs#e470bcfd peers:Vector<InputDialogPeer> = messages.PeerDialogs;

/*
Save a message [draft](https://core.telegram.org/api/drafts) associated to a chat.

@no_webpage Disable generation of the webpage preview
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@reply_to If set, indicates that the message should be sent in reply to the specified message or story.
@peer Destination of the message that should be sent
@message The draft
@entities Message [entities](https://core.telegram.org/api/entities) for styled text
@media Attached media
@effect Specifies a [message effect](https://core.telegram.org/api/effects) to use for the message.

$400, EntityBoundsInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.saveDraft#d372c5ce flags:# no_webpage:flags.1?true invert_media:flags.6?true reply_to:flags.4?InputReplyTo peer:InputPeer message:string entities:flags.3?Vector<MessageEntity> media:flags.5?InputMedia effect:flags.7?long = Bool;

/*
Return all message [drafts](https://core.telegram.org/api/drafts). 
Returns all the latest [updateDraftMessage](https://core.telegram.org/constructor/updateDraftMessage) updates related to all chats with drafts.
*/
messages.getAllDrafts#6a3f8d65 = Updates;

/*
Get featured stickers

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getFeaturedStickers#64780b14 hash:long = messages.FeaturedStickers;

/*
Mark new featured stickers as read

@id IDs of stickersets to mark as read
*/
messages.readFeaturedStickers#5b118126 id:Vector<long> = Bool;

/*
Get recent stickers

@attached Get stickers recently attached to photo or video files
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getRecentStickers#9da9403b flags:# attached:flags.0?true hash:long = messages.RecentStickers;

/*
Add/remove sticker from recent stickers list

@attached Whether to add/remove stickers recently attached to photo or video files
@id Sticker
@unsave Whether to save or unsave the sticker

$400, StickerIdInvalidError
*/
messages.saveRecentSticker#392718f8 flags:# attached:flags.0?true id:InputDocument unsave:Bool = Bool;

/*
Clear recent stickers

@attached Set this flag to clear the list of stickers recently attached to photo or video files
*/
messages.clearRecentStickers#8999602d flags:# attached:flags.0?true = Bool;

/*
Get all archived stickers

@masks Get [mask stickers](https://core.telegram.org/api/stickers#mask-stickers)
@emojis Get [custom emoji stickers](https://core.telegram.org/api/custom-emoji)
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
*/
messages.getArchivedStickers#57f17692 flags:# masks:flags.0?true emojis:flags.1?true offset_id:long limit:int = messages.ArchivedStickers;

/*
Get installed mask stickers

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getMaskStickers#640f82b8 hash:long = messages.AllStickers;

/*
Get stickers attached to a photo or video

@media Stickered media

$400, MediaEmptyError
*/
messages.getAttachedStickers#cc5b67cc media:InputStickeredMedia = Vector<StickerSetCovered>;

/*
Use this method to set the score of the specified user in a game sent as a normal message (bots only).

**Bots can use this method**

@edit_message Set this flag if the game message should be automatically edited to include the current scoreboard
@force Set this flag if the high score is allowed to decrease. This can be useful when fixing mistakes or banning cheaters
@peer Unique identifier of target chat
@id Identifier of the sent message
@user_id User identifier
@score New score

$400, BotScoreNotModifiedError
$400, MessageIdInvalidError
$400, PeerIdInvalidError
$400, ScoreInvalidError
$400, UserBotRequiredError
*/
messages.setGameScore#8ef8ecc0 flags:# edit_message:flags.0?true force:flags.1?true peer:InputPeer id:int user_id:InputUser score:int = Updates;

/*
Use this method to set the score of the specified user in a game sent as an inline message (bots only).

**Bots can use this method**

@edit_message Set this flag if the game message should be automatically edited to include the current scoreboard
@force Set this flag if the high score is allowed to decrease. This can be useful when fixing mistakes or banning cheaters
@id ID of the inline message
@user_id User identifier
@score New score

$400, MessageIdInvalidError
$400, UserBotRequiredError
*/
messages.setInlineGameScore#15ad9f64 flags:# edit_message:flags.0?true force:flags.1?true id:InputBotInlineMessageID user_id:InputUser score:int = Bool;

/*
Get highscores of a game

**Bots can use this method**

@peer Where was the game sent
@id ID of message with game media attachment
@user_id Get high scores made by a certain user

$400, MessageIdInvalidError
$400, PeerIdInvalidError
$400, UserBotRequiredError
*/
messages.getGameHighScores#e822649d peer:InputPeer id:int user_id:InputUser = messages.HighScores;

/*
Get highscores of a game sent using an inline bot

**Bots can use this method**

@id ID of inline message
@user_id Get high scores of a certain user

$400, MessageIdInvalidError
$400, UserBotRequiredError
*/
messages.getInlineGameHighScores#f635e1b id:InputBotInlineMessageID user_id:InputUser = messages.HighScores;

/*
Get chats in common with a user

@user_id User ID
@max_id Maximum ID of chat to return (see [pagination](https://core.telegram.org/api/offsets))
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, MsgIdInvalidError
$400, UserIdInvalidError
*/
messages.getCommonChats#e40ca104 user_id:InputUser max_id:long limit:int = messages.Chats;

/*
Get [instant view](https://instantview.telegram.org) page

@url URL of IV page to fetch
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation). Note: the usual hash generation algorithm cannot be used in this case, please re-use the [webPage](https://core.telegram.org/constructor/webPage). hash field returned by a previous call to the method, or pass 0 if this is the first call or if the previous call did not return a [webPage](https://core.telegram.org/constructor/webPage).

$400, WcConvertUrlInvalidError
*/
messages.getWebPage#8d9692a3 url:string hash:int = messages.WebPage;

/*
Pin/unpin a dialog

@pinned Whether to pin or unpin the dialog
@peer The dialog to pin

$400, ChannelPrivateError
$400, PeerHistoryEmptyError
$400, PeerIdInvalidError
$400, PinnedDialogsTooMuchError
*/
messages.toggleDialogPin#a731e257 flags:# pinned:flags.0?true peer:InputDialogPeer = Bool;

/*
Reorder pinned dialogs

@force If set, dialogs pinned server-side but not present in the order field will be unpinned.
@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)
@order New dialog order

$400, PeerIdInvalidError
*/
messages.reorderPinnedDialogs#3b1adf37 flags:# force:flags.0?true folder_id:int order:Vector<InputDialogPeer> = Bool;

/*
Get pinned dialogs

@folder_id [Peer folder ID, for more info click here](https://core.telegram.org/api/folders#peer-folders)

$400, FolderIdInvalidError
*/
messages.getPinnedDialogs#d6b94df2 folder_id:int = messages.PeerDialogs;

/*
If you sent an invoice requesting a shipping address and the parameter is_flexible was specified, the bot will receive an [updateBotShippingQuery](https://core.telegram.org/constructor/updateBotShippingQuery) update. Use this method to reply to shipping queries.

**Bots can use this method**

@query_id Unique identifier for the query to be answered
@error Error message in human readable form that explains why it is impossible to complete the order (e.g. "Sorry, delivery to your desired address is unavailable"). Telegram will display this message to the user.
@shipping_options A vector of available shipping options.

$400, QueryIdInvalidError
$400, UserBotRequiredError
*/
messages.setBotShippingResults#e5f672fa flags:# query_id:long error:flags.0?string shipping_options:flags.1?Vector<ShippingOption> = Bool;

/*
Once the user has confirmed their payment and shipping details, the bot receives an [updateBotPrecheckoutQuery](https://core.telegram.org/constructor/updateBotPrecheckoutQuery) update. 
Use this method to respond to such pre-checkout queries. 
 Note: Telegram must receive an answer within 10 seconds after the pre-checkout query was sent.

**Bots can use this method**

@success Set this flag if everything is alright (goods are available, etc.) and the bot is ready to proceed with the order, otherwise do not set it, and set the error field, instead
@query_id Unique identifier for the query to be answered
@error Required if the success isn't set. Error message in human readable form that explains the reason for failure to proceed with the checkout (e.g. "Sorry, somebody just bought the last of our amazing black T-shirts while you were busy filling out your payment details. Please choose a different color or garment!"). Telegram will display this message to the user.

$400, ErrorTextEmptyError
$400, UserBotRequiredError
*/
messages.setBotPrecheckoutResults#9c2dd95 flags:# success:flags.1?true query_id:long error:flags.0?string = Bool;

/*
Upload a file and associate it to a chat (without actually sending it to the chat)

**Bots can use this method**

@business_connection_id Whether the media will be used only in the specified [business connection](https://core.telegram.org/api/business#connected-bots), and not directly by the bot.
@peer The chat, can be [inputPeerEmpty](https://core.telegram.org/constructor/inputPeerEmpty) for bots and [inputPeerSelf](https://core.telegram.org/constructor/inputPeerSelf) for users.
@media File uploaded in chunks as described in [files](https://core.telegram.org/api/files)

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatRestrictedError
$403, ChatWriteForbiddenError
$400, FilePartsInvalidError
$400, FilePartLengthInvalidError
$400, ImageProcessFailedError
$400, InputUserDeactivatedError
$400, MediaInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, PhotoExtInvalidError
$400, PhotoInvalidDimensionsError
$400, PhotoSaveFileInvalidError
$400, UserBannedInChannelError
$400, VoiceMessagesForbiddenError
$400, WebpageCurlFailedError
*/
messages.uploadMedia#14967978 flags:# business_connection_id:flags.0?string peer:InputPeer media:InputMedia = MessageMedia;

/*
Notify the other user in a private chat that a screenshot of the chat was taken

@peer Other user
@reply_to Indicates the message that was screenshotted (the specified message ID can also be 0 to avoid indicating any specific message).
@random_id Random ID to avoid message resending

$400, InputUserDeactivatedError
$400, PeerIdInvalidError
$400, ReplyMessageIdInvalidError
$400, StoryIdInvalidError
$400, YouBlockedUserError
*/
messages.sendScreenshotNotification#a1405817 peer:InputPeer reply_to:InputReplyTo random_id:long = Updates;

/*
Get faved stickers

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getFavedStickers#4f1aaa9 hash:long = messages.FavedStickers;

/*
Mark or unmark a sticker as favorite

@id Sticker in question
@unfave Whether to add or remove a sticker from favorites

$400, StickerIdInvalidError
*/
messages.faveSticker#b9ffc55b id:InputDocument unfave:Bool = Bool;

/*
Get unread messages where we were mentioned

@peer Peer where to look for mentions
@top_msg_id If set, considers only messages within the specified [forum topic](https://core.telegram.org/api/forum#forum-topics)
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@add_offset [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
@max_id Maximum message ID to return, [see pagination](https://core.telegram.org/api/offsets)
@min_id Minimum message ID to return, [see pagination](https://core.telegram.org/api/offsets)

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.getUnreadMentions#f107e790 flags:# peer:InputPeer top_msg_id:flags.0?int offset_id:int add_offset:int limit:int max_id:int min_id:int = messages.Messages;

/*
Mark mentions as read

@peer Dialog
@top_msg_id Mark as read only mentions within the specified [forum topic](https://core.telegram.org/api/forum#forum-topics)

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.readMentions#36e5bf4d flags:# peer:InputPeer top_msg_id:flags.0?int = messages.AffectedHistory;

/*
Get live location history of a certain user

@peer User
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
*/
messages.getRecentLocations#702a40e0 peer:InputPeer limit:int hash:long = messages.Messages;

/*
Send an [album or grouped media](https://core.telegram.org/api/files#albums-grouped-media)

**Bots can use this method**

@silent Whether to send the album silently (no notification triggered)
@background Send in background?
@clear_draft Whether to clear [drafts](https://core.telegram.org/api/drafts)
@noforwards Only for bots, disallows forwarding and saving of the messages, even if the destination chat doesn't have [content protection](https://telegram.org/blog/protected-content-delete-by-date-and-more) enabled
@update_stickersets_order Whether to move used stickersets to top, [see here for more info on this flag](https://core.telegram.org/api/stickers#recent-stickersets)
@invert_media If set, any eventual webpage preview will be shown on top of the message instead of at the bottom.
@allow_paid_floodskip Bots only: if set, allows sending up to 1000 messages per second, ignoring [broadcasting limits](https://core.telegram.org/bots/faq#how-can-i-message-all-of-my-bot-39s-subscribers-at-once) for a fee of 0.1 Telegram Stars per message. The relevant Stars will be withdrawn from the bot's balance.
@peer The destination chat
@reply_to If set, indicates that the message should be sent in reply to the specified message or story.
@multi_media The medias to send: note that they must be separately uploaded using [messages.uploadMedia](https://core.telegram.org/method/messages.uploadMedia) first, using raw inputMediaUploaded* constructors is not supported.
@schedule_date Scheduled message date for scheduled messages
@send_as Send this message as the specified peer
@quick_reply_shortcut Add the message to the specified [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts), instead.
@effect Specifies a [message effect](https://core.telegram.org/api/effects) to use for the message.

$400, BusinessPeerInvalidError
$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatForwardsRestrictedError
$403, ChatSendMediaForbiddenError
$403, ChatSendPhotosForbiddenError
$403, ChatSendVideosForbiddenError
$403, ChatWriteForbiddenError
$400, EntityBoundsInvalidError
$400, FileReferenceExpiredError
$400, FileReferenceInvalidError
$400, MediaCaptionTooLongError
$400, MediaEmptyError
$400, MediaInvalidError
$400, MsgIdInvalidError
$400, MultiMediaTooLongError
$400, PeerIdInvalidError
$400, QuickRepliesTooMuchError
$500, RandomIdDuplicateError
$400, RandomIdEmptyError
$400, ReplyMessagesTooMuchError
$400, ReplyToInvalidError
$400, ScheduleDateTooLateError
$400, ScheduleTooMuchError
$400, SendAsPeerInvalidError
$420, SlowmodeWaitError
$400, TopicClosedError
$400, TopicDeletedError
$400, UserBannedInChannelError
*/
messages.sendMultiMedia#37b74355 flags:# silent:flags.5?true background:flags.6?true clear_draft:flags.7?true noforwards:flags.14?true update_stickersets_order:flags.15?true invert_media:flags.16?true allow_paid_floodskip:flags.19?true peer:InputPeer reply_to:flags.0?InputReplyTo multi_media:Vector<InputSingleMedia> schedule_date:flags.10?int send_as:flags.13?InputPeer quick_reply_shortcut:flags.17?InputQuickReplyShortcut effect:flags.18?long = Updates;

/*
Upload encrypted file and associate it to a secret chat

@peer The secret chat to associate the file to
@file The file

$400, ChatIdInvalidError
*/
messages.uploadEncryptedFile#5057c497 peer:InputEncryptedChat file:InputEncryptedFile = EncryptedFile;

/*
Search for stickersets

@exclude_featured Exclude featured stickersets from results
@q Query string
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.searchStickerSets#35705b8a flags:# exclude_featured:flags.0?true q:string hash:long = messages.FoundStickerSets;

/*
Get message ranges for saving the user's chat history
*/
messages.getSplitRanges#1cff7e08 = Vector<MessageRange>;

/*
Manually mark dialog as unread

@unread Mark as unread/read
@peer Dialog

$400, PeerIdInvalidError
*/
messages.markDialogUnread#c286d98f flags:# unread:flags.0?true peer:InputDialogPeer = Bool;

/*
Get dialogs manually marked as unread
*/
messages.getDialogUnreadMarks#22e24e22 = Vector<DialogPeer>;

/*
Clear all [drafts](https://core.telegram.org/api/drafts).
*/
messages.clearAllDrafts#7e58ee9c = Bool;

/*
Pin a message

**Bots can use this method**

@silent Pin the message silently, without triggering a notification
@unpin Whether the message should unpinned or pinned
@pm_oneside Whether the message should only be pinned on the local side of a one-to-one chat
@peer The peer where to pin the message
@id The message to pin or unpin

$400, BotOnesideNotAvailError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatNotModifiedError
$403, ChatWriteForbiddenError
$400, MessageIdInvalidError
$400, PeerIdInvalidError
$400, PinRestrictedError
$400, UserBannedInChannelError
*/
messages.updatePinnedMessage#d2aaf7ec flags:# silent:flags.0?true unpin:flags.1?true pm_oneside:flags.2?true peer:InputPeer id:int = Updates;

/*
Vote in a [poll](https://core.telegram.org/constructor/poll)

@peer The chat where the poll was sent
@msg_id The message ID of the poll
@options The options that were chosen

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MessageIdInvalidError
$400, MessagePollClosedError
$400, MsgIdInvalidError
$400, OptionsTooMuchError
$400, OptionInvalidError
$400, PeerIdInvalidError
$400, RevoteNotAllowedError
*/
messages.sendVote#10ea6184 peer:InputPeer msg_id:int options:Vector<bytes> = Updates;

/*
Get poll results

@peer Peer where the poll was found
@msg_id Message ID of poll message

$400, MessageIdInvalidError
$400, PeerIdInvalidError
*/
messages.getPollResults#73bb643b peer:InputPeer msg_id:int = Updates;

/*
Get count of online users in a chat

@peer The chat

$400, ChannelPrivateError
$400, ChatIdInvalidError
$400, PeerIdInvalidError
*/
messages.getOnlines#6e2be050 peer:InputPeer = ChatOnlines;

/*
Edit the description of a [group/supergroup/channel](https://core.telegram.org/api/channel).

**Bots can use this method**

@peer The [group/supergroup/channel](https://core.telegram.org/api/channel).
@about The new description

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAboutNotModifiedError
$400, ChatAboutTooLongError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatNotModifiedError
$403, ChatWriteForbiddenError
$400, PeerIdInvalidError
*/
messages.editChatAbout#def60797 peer:InputPeer about:string = Bool;

/*
Edit the default banned rights of a [channel/supergroup/group](https://core.telegram.org/api/channel).

**Bots can use this method**

@peer The peer
@banned_rights The new global rights

$400, BannedRightsInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatNotModifiedError
$403, ChatWriteForbiddenError
$400, PeerIdInvalidError
$400, UntilDateInvalidError
*/
messages.editChatDefaultBannedRights#a5866b41 peer:InputPeer banned_rights:ChatBannedRights = Updates;

/*
Get localized [emoji keywords](https://core.telegram.org/api/custom-emoji#emoji-keywords).

@lang_code Language code
*/
messages.getEmojiKeywords#35a0e062 lang_code:string = EmojiKeywordsDifference;

/*
Get changed [emoji keywords](https://core.telegram.org/api/custom-emoji#emoji-keywords).

@lang_code Language code
@from_version Previous stored emoji keyword list version
*/
messages.getEmojiKeywordsDifference#1508b6af lang_code:string from_version:int = EmojiKeywordsDifference;

/*
Obtain a list of related languages that must be used when fetching [emoji keyword lists](https://core.telegram.org/api/custom-emoji#emoji-keywords).

@lang_codes The user's language codes
*/
messages.getEmojiKeywordsLanguages#4e9963b2 lang_codes:Vector<string> = Vector<EmojiLanguage>;

/*
Returns an HTTP URL which can be used to automatically log in into translation platform and suggest new [emoji keywords](https://core.telegram.org/api/custom-emoji#emoji-keywords). The URL will be valid for 30 seconds after generation.

@lang_code Language code for which the emoji keywords will be suggested
*/
messages.getEmojiURL#d5b10c26 lang_code:string = EmojiURL;

/*
Get the number of results that would be found by a [messages.search](https://core.telegram.org/method/messages.search) call with the same parameters

@peer Peer where to search
@saved_peer_id Search within the [saved message dialog](https://core.telegram.org/api/saved-messages) with this ID.
@top_msg_id If set, consider only messages within the specified [forum topic](https://core.telegram.org/api/forum#forum-topics)
@filters Search filters

$400, PeerIdInvalidError
*/
messages.getSearchCounters#1bbcf300 flags:# peer:InputPeer saved_peer_id:flags.2?InputPeer top_msg_id:flags.0?int filters:Vector<MessagesFilter> = Vector<messages.SearchCounter>;

/*
Get more info about a Seamless Telegram Login authorization request, for more info [click here](https://core.telegram.org/api/url-authorization)

@peer Peer where the message is located
@msg_id The message
@button_id The ID of the button with the authorization request
@url URL used for [link URL authorization, click here for more info](https://core.telegram.org/api/url-authorization#link-url-authorization)
*/
messages.requestUrlAuth#198fb446 flags:# peer:flags.1?InputPeer msg_id:flags.1?int button_id:flags.1?int url:flags.2?string = UrlAuthResult;

/*
Use this to accept a Seamless Telegram Login authorization request, for more info [click here](https://core.telegram.org/api/url-authorization)

@write_allowed Set this flag to allow the bot to send messages to you (if requested)
@peer The location of the message
@msg_id Message ID of the message with the login button
@button_id ID of the login button
@url URL used for [link URL authorization, click here for more info](https://core.telegram.org/api/url-authorization#link-url-authorization)
*/
messages.acceptUrlAuth#b12c7125 flags:# write_allowed:flags.0?true peer:flags.1?InputPeer msg_id:flags.1?int button_id:flags.1?int url:flags.2?string = UrlAuthResult;

/*
Should be called after the user hides the [report spam/add as contact bar](https://core.telegram.org/api/action-bar) of a new chat, effectively prevents the user from executing the actions specified in the [action bar](https://core.telegram.org/api/action-bar).

@peer Peer

$400, PeerIdInvalidError
*/
messages.hidePeerSettingsBar#4facb138 peer:InputPeer = Bool;

/*
Get scheduled messages

@peer Peer
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation). To generate the hash, populate the ids array with the id, date and edit_date (in this order) of the previously returned messages (in order, i.e. ids = [id1, date1, edit_date1, id2, date2, edit_date2, ...]).

$400, ChatAdminRequiredError
$400, PeerIdInvalidError
*/
messages.getScheduledHistory#f516760b peer:InputPeer hash:long = messages.Messages;

/*
Get scheduled messages

@peer Peer
@id IDs of scheduled messages

$400, ChatAdminRequiredError
$400, PeerIdInvalidError
*/
messages.getScheduledMessages#bdbb0464 peer:InputPeer id:Vector<int> = messages.Messages;

/*
Send scheduled messages right away

@peer Peer
@id Scheduled message IDs

$400, MessageIdInvalidError
$400, PeerIdInvalidError
$500, RandomIdDuplicateError
*/
messages.sendScheduledMessages#bd38850a peer:InputPeer id:Vector<int> = Updates;

/*
Delete scheduled messages

@peer Peer
@id Scheduled message IDs

$403, MessageDeleteForbiddenError
$400, PeerIdInvalidError
*/
messages.deleteScheduledMessages#59ae2b16 peer:InputPeer id:Vector<int> = Updates;

/*
Get poll results for non-anonymous polls

@peer Chat where the poll was sent
@id Message ID
@option Get only results for the specified poll option
@offset Offset for results, taken from the next_offset field of [messages.votesList](https://core.telegram.org/constructor/messages.votesList), initially an empty string. Note: if no more results are available, the method call will return an empty next_offset; thus, avoid providing the next_offset returned in [messages.votesList](https://core.telegram.org/constructor/messages.votesList) if it is empty, to avoid an infinite loop.
@limit Number of results to return

$403, BroadcastForbiddenError
$400, MsgIdInvalidError
$403, PollVoteRequiredError
*/
messages.getPollVotes#b86e380e flags:# peer:InputPeer id:int option:flags.0?bytes offset:flags.1?string limit:int = messages.VotesList;

/*
Apply changes to multiple stickersets

@uninstall Uninstall the specified stickersets
@archive Archive the specified stickersets
@unarchive Unarchive the specified stickersets
@stickersets Stickersets to act upon
*/
messages.toggleStickerSets#b5052fea flags:# uninstall:flags.0?true archive:flags.1?true unarchive:flags.2?true stickersets:Vector<InputStickerSet> = Bool;

/*
Get [folders](https://core.telegram.org/api/folders)
*/
messages.getDialogFilters#efd48c89 = messages.DialogFilters;

/*
Get [suggested folders](https://core.telegram.org/api/folders)
*/
messages.getSuggestedDialogFilters#a29cd42c = Vector<DialogFilterSuggested>;

/*
Update [folder](https://core.telegram.org/api/folders)

@id [Folder](https://core.telegram.org/api/folders) ID
@filter [Folder](https://core.telegram.org/api/folders) info

$400, ChatlistExcludeInvalidError
$400, ChatIdInvalidError
$400, FilterIdInvalidError
$400, FilterIncludeEmptyError
$400, FilterTitleEmptyError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.updateDialogFilter#1ad4a04a flags:# id:int filter:flags.0?DialogFilter = Bool;

/*
Reorder [folders](https://core.telegram.org/api/folders)

@order New [folder](https://core.telegram.org/api/folders) order
*/
messages.updateDialogFiltersOrder#c563c1e4 order:Vector<int> = Bool;

/*
Method for fetching previously featured stickers

@offset Offset
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getOldFeaturedStickers#7ed094a1 offset:int limit:int hash:long = messages.FeaturedStickers;

/*
Get messages in a reply thread

@peer Peer
@msg_id Message ID
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@offset_date [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@add_offset [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
@max_id If a positive value was transferred, the method will return only messages with ID smaller than max_id
@min_id If a positive value was transferred, the method will return only messages with ID bigger than min_id
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, TopicIdInvalidError
*/
messages.getReplies#22ddd30c peer:InputPeer msg_id:int offset_id:int offset_date:int add_offset:int limit:int max_id:int min_id:int hash:long = messages.Messages;

/*
Get [discussion message](https://core.telegram.org/api/threads) from the [associated discussion group](https://core.telegram.org/api/discussion) of a channel to show it on top of the comment section, without actually joining the group

@peer [Channel ID](https://core.telegram.org/api/channel)
@msg_id Message ID

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, TopicIdInvalidError
*/
messages.getDiscussionMessage#446972fd peer:InputPeer msg_id:int = messages.DiscussionMessage;

/*
Mark a [thread](https://core.telegram.org/api/threads) as read

@peer Group ID
@msg_id ID of message that started the thread
@read_max_id ID up to which thread messages were read

$400, ChatIdInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
messages.readDiscussion#f731a9f4 peer:InputPeer msg_id:int read_max_id:int = Bool;

/*
[Unpin](https://core.telegram.org/api/pin) all pinned messages

**Bots can use this method**

@peer Chat where to unpin
@top_msg_id [Forum topic](https://core.telegram.org/api/forum#forum-topics) where to unpin

$400, ChatAdminRequiredError
$400, ChatNotModifiedError
$400, PeerIdInvalidError
*/
messages.unpinAllMessages#ee22b9a8 flags:# peer:InputPeer top_msg_id:flags.0?int = messages.AffectedHistory;

/*
Delete a [chat](https://core.telegram.org/api/channel)

@chat_id Chat ID

$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, PeerIdInvalidError
*/
messages.deleteChat#5bd0ee50 chat_id:long = Bool;

/*
Delete the entire phone call history.

@revoke Whether to remove phone call history for participants as well
*/
messages.deletePhoneCallHistory#f9cbe409 flags:# revoke:flags.0?true = messages.AffectedFoundMessages;

/*
Obtains information about a chat export file, generated by a foreign chat app, [click here for more info about imported chats](https://core.telegram.org/api/import).

@import_head Beginning of the message file; up to 100 lines.

$400, ImportFormatUnrecognizedError
*/
messages.checkHistoryImport#43fe19f3 import_head:string = messages.HistoryImportParsed;

/*
Import chat history from a foreign chat app into a specific Telegram chat, [click here for more info about imported chats](https://core.telegram.org/api/import).

@peer The Telegram chat where the [history should be imported](https://core.telegram.org/api/import).
@file File with messages to import.
@media_count Number of media files associated with the chat that will be uploaded using [messages.uploadImportedMedia](https://core.telegram.org/method/messages.uploadImportedMedia).

$400, ChatAdminRequiredError
$400, ImportFileInvalidError
$400, ImportFormatDateInvalidError
$400, ImportFormatUnrecognizedError
$400, PeerIdInvalidError
$406, PreviousChatImportActiveWaitMinError
*/
messages.initHistoryImport#34090c3b peer:InputPeer file:InputFile media_count:int = messages.HistoryImport;

/*
Upload a media file associated with an [imported chat, click here for more info](https://core.telegram.org/api/import).

@peer The Telegram chat where the media will be imported
@import_id Identifier of a [history import session](https://core.telegram.org/api/import), returned by [messages.initHistoryImport](https://core.telegram.org/method/messages.initHistoryImport)
@file_name File name
@media Media metadata

$400, ChatAdminRequiredError
$400, ImportIdInvalidError
$400, MediaInvalidError
*/
messages.uploadImportedMedia#2a862092 peer:InputPeer import_id:long file_name:string media:InputMedia = MessageMedia;

/*
Complete the [history import process](https://core.telegram.org/api/import), importing all messages into the chat. 
To be called only after initializing the import with [messages.initHistoryImport](https://core.telegram.org/method/messages.initHistoryImport) and uploading all files using [messages.uploadImportedMedia](https://core.telegram.org/method/messages.uploadImportedMedia).

@peer The Telegram chat where the messages should be [imported, click here for more info](https://core.telegram.org/api/import)
@import_id Identifier of a history import session, returned by [messages.initHistoryImport](https://core.telegram.org/method/messages.initHistoryImport).

$400, ImportIdInvalidError
*/
messages.startHistoryImport#b43df344 peer:InputPeer import_id:long = Bool;

/*
Get info about the chat invites of a specific chat

@revoked Whether to fetch revoked chat invites
@peer Chat
@admin_id Whether to only fetch chat invites from this admin
@offset_date [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@offset_link [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, AdminIdInvalidError
$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, PeerIdInvalidError
*/
messages.getExportedChatInvites#a2b5a3f6 flags:# revoked:flags.3?true peer:InputPeer admin_id:InputUser offset_date:flags.2?int offset_link:flags.2?string limit:int = messages.ExportedChatInvites;

/*
Get info about a chat invite

@peer Chat
@link Invite link

$400, ChannelPrivateError
$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, InviteHashExpiredError
$400, PeerIdInvalidError
*/
messages.getExportedChatInvite#73746f5c peer:InputPeer link:string = messages.ExportedChatInvite;

/*
Edit an exported chat invite

**Bots can use this method**

@revoked Whether to revoke the chat invite
@peer Chat
@link Invite link
@expire_date New expiration date
@usage_limit Maximum number of users that can join using this link
@request_needed Whether admin confirmation is required before admitting each separate user into the chat
@title Description of the invite link, visible only to administrators

$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatInvitePermanentError
$403, ChatWriteForbiddenError
$403, EditBotInviteForbiddenError
$400, InviteHashExpiredError
$400, PeerIdInvalidError
$400, UsageLimitInvalidError
*/
messages.editExportedChatInvite#bdca2f75 flags:# revoked:flags.2?true peer:InputPeer link:string expire_date:flags.0?int usage_limit:flags.1?int request_needed:flags.3?Bool title:flags.4?string = messages.ExportedChatInvite;

/*
Delete all revoked chat invites

@peer Chat
@admin_id ID of the admin that originally generated the revoked chat invites

$400, AdminIdInvalidError
$400, PeerIdInvalidError
*/
messages.deleteRevokedExportedChatInvites#56987bd5 peer:InputPeer admin_id:InputUser = Bool;

/*
Delete a chat invite

@peer Peer
@link Invite link

$400, InviteHashExpiredError
$400, InviteRevokedMissingError
$400, PeerIdInvalidError
*/
messages.deleteExportedChatInvite#d464a42b peer:InputPeer link:string = Bool;

/*
Get info about chat invites generated by admins.

@peer Chat

$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, PeerIdInvalidError
*/
messages.getAdminsWithInvites#3920e6ef peer:InputPeer = messages.ChatAdminsWithInvites;

/*
Get info about the users that joined the chat using a specific chat invite

@requested If set, only returns info about users with pending [join requests](https://core.telegram.org/api/invites#join-requests)
@subscription_expired Set this flag if the link is a [Telegram Star subscription link](https://core.telegram.org/api/stars#star-subscriptions) and only members with already expired subscription must be returned.
@peer Chat
@link Invite link
@q Search for a user in the pending [join requests](https://core.telegram.org/api/invites#join-requests) list: only available when the requested flag is set, cannot be used together with a specific link.
@offset_date [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@offset_user User ID for [pagination](https://core.telegram.org/api/offsets): if set, offset_date must also be set.
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, InviteHashExpiredError
$400, PeerIdInvalidError
$400, SearchWithLinkNotSupportedError
*/
messages.getChatInviteImporters#df04dd4e flags:# requested:flags.0?true subscription_expired:flags.3?true peer:InputPeer link:flags.1?string q:flags.2?string offset_date:int offset_user:InputUser limit:int = messages.ChatInviteImporters;

/*
Set maximum Time-To-Live of all messages in the specified chat

@peer The dialog
@period Automatically delete all messages sent in the chat after this many seconds

$400, ChatNotModifiedError
$400, PeerIdInvalidError
$400, TtlPeriodInvalidError
*/
messages.setHistoryTTL#b80e5fe4 peer:InputPeer period:int = Updates;

/*
Check whether chat history exported from another chat app can be [imported into a specific Telegram chat, click here for more info](https://core.telegram.org/api/import).

@peer The chat where we want to [import history](https://core.telegram.org/api/import).

$400, ChatAdminRequiredError
$400, PeerIdInvalidError
$400, UserNotMutualContactError
*/
messages.checkHistoryImportPeer#5dc60f03 peer:InputPeer = messages.CheckedHistoryImportPeer;

/*
Change the chat theme of a certain chat

@peer Private chat where to change theme
@emoticon Emoji, identifying a specific chat theme; a list of chat themes can be fetched using [account.getChatThemes](https://core.telegram.org/method/account.getChatThemes)

$400, EmojiInvalidError
$400, EmojiNotModifiedError
$400, PeerIdInvalidError
*/
messages.setChatTheme#e63be13f peer:InputPeer emoticon:string = Updates;

/*
Get which users read a specific message: only available for groups and supergroups with less than [chat_read_mark_size_threshold members](https://core.telegram.org/api/config#chat-read-mark-size-threshold), read receipts will be stored for [chat_read_mark_expire_period seconds after the message was sent](https://core.telegram.org/api/config#chat-read-mark-expire-period), see [client configuration for more info](https://core.telegram.org/api/config#client-configuration).

@peer Dialog
@msg_id Message ID

$400, ChatTooBigError
$400, MsgIdInvalidError
$400, MsgTooOldError
$400, PeerIdInvalidError
*/
messages.getMessageReadParticipants#31c1c44f peer:InputPeer msg_id:int = Vector<ReadParticipantDate>;

/*
Returns information about the next messages of the specified type in the chat split by days.

@peer Peer where to search
@saved_peer_id Search within the [saved message dialog](https://core.telegram.org/api/saved-messages) with this ID.
@filter Message filter, [inputMessagesFilterEmpty](https://core.telegram.org/constructor/inputMessagesFilterEmpty), [inputMessagesFilterMyMentions](https://core.telegram.org/constructor/inputMessagesFilterMyMentions) filters are not supported by this method.
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@offset_date [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)

$400, FilterNotSupportedError
$400, PeerIdInvalidError
*/
messages.getSearchResultsCalendar#6aa3f6bd flags:# peer:InputPeer saved_peer_id:flags.2?InputPeer filter:MessagesFilter offset_id:int offset_date:int = messages.SearchResultsCalendar;

/*
Returns sparse positions of messages of the specified type in the chat to be used for shared media scroll implementation.

@peer Peer where to search
@saved_peer_id Search within the [saved message dialog](https://core.telegram.org/api/saved-messages) with this ID.
@filter Message filter, [inputMessagesFilterEmpty](https://core.telegram.org/constructor/inputMessagesFilterEmpty), [inputMessagesFilterMyMentions](https://core.telegram.org/constructor/inputMessagesFilterMyMentions) filters are not supported by this method.
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, PeerIdInvalidError
*/
messages.getSearchResultsPositions#9c7f2f10 flags:# peer:InputPeer saved_peer_id:flags.2?InputPeer filter:MessagesFilter offset_id:int limit:int = messages.SearchResultsPositions;

/*
Dismiss or approve a chat [join request](https://core.telegram.org/api/invites#join-requests) related to a specific chat or channel.

**Bots can use this method**

@approved Whether to dismiss or approve the chat [join request](https://core.telegram.org/api/invites#join-requests)
@peer The chat or channel
@user_id The user whose [join request](https://core.telegram.org/api/invites#join-requests) should be dismissed or approved

$400, ChannelsTooMuchError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, HideRequesterMissingError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, UserAlreadyParticipantError
$403, UserChannelsTooMuchError
$400, UserIdInvalidError
*/
messages.hideChatJoinRequest#7fe7e815 flags:# approved:flags.0?true peer:InputPeer user_id:InputUser = Updates;

/*
Dismiss or approve all [join requests](https://core.telegram.org/api/invites#join-requests) related to a specific chat or channel.

@approved Whether to dismiss or approve all chat [join requests](https://core.telegram.org/api/invites#join-requests)
@peer The chat or channel
@link Only dismiss or approve [join requests](https://core.telegram.org/api/invites#join-requests) initiated using this invite link

$400, ChannelsTooMuchError
$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, HideRequesterMissingError
$400, InviteHashExpiredError
$400, PeerIdInvalidError
$400, UserChannelsTooMuchError
*/
messages.hideAllChatJoinRequests#e085f4ea flags:# approved:flags.0?true peer:InputPeer link:flags.1?string = Updates;

/*
Enable or disable [content protection](https://telegram.org/blog/protected-content-delete-by-date-and-more) on a channel or chat

@peer The chat or channel
@enabled Enable or disable content protection

$400, ChatAdminRequiredError
$400, ChatNotModifiedError
$400, PeerIdInvalidError
*/
messages.toggleNoForwards#b11eafa2 peer:InputPeer enabled:Bool = Updates;

/*
Change the default peer that should be used when sending messages, reactions, poll votes to a specific group

@peer Group
@send_as The default peer that should be used when sending messages to the group

$400, PeerIdInvalidError
$400, SendAsPeerInvalidError
*/
messages.saveDefaultSendAs#ccfddf96 peer:InputPeer send_as:InputPeer = Bool;

/*
React to message.

@big Whether a bigger and longer reaction should be shown
@add_to_recent Whether to add this reaction to the [recent reactions list](https://core.telegram.org/api/reactions#recent-reactions).
@peer Peer
@msg_id Message ID to react to
@reaction A list of reactions

$403, AnonymousReactionsDisabledError
$400, ChannelInvalidError
$400, ChannelPrivateError
$403, ChatWriteForbiddenError
$400, CustomReactionsTooManyError
$400, DocumentInvalidError
$400, MessageIdInvalidError
$400, MessageNotModifiedError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$403, PremiumAccountRequiredError
$400, ReactionsTooManyError
$400, ReactionEmptyError
$400, ReactionInvalidError
$400, UserBannedInChannelError
*/
messages.sendReaction#d30d78d4 flags:# big:flags.1?true add_to_recent:flags.2?true peer:InputPeer msg_id:int reaction:flags.0?Vector<Reaction> = Updates;

/*
Get [message reactions](https://core.telegram.org/api/reactions)

@peer Peer
@id Message IDs

$400, ChannelInvalidError
$400, ChannelPrivateError
*/
messages.getMessagesReactions#8bba90e6 peer:InputPeer id:Vector<int> = Updates;

/*
Get [message reaction](https://core.telegram.org/api/reactions) list, along with the sender of each reaction.

@peer Peer
@id Message ID
@reaction Get only reactions of this type
@offset Offset for pagination (taken from the next_offset field of the returned [messages.MessageReactionsList](https://core.telegram.org/type/messages.MessageReactionsList)); empty in the first request.
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$403, BroadcastForbiddenError
$400, MsgIdInvalidError
*/
messages.getMessageReactionsList#461b3f48 flags:# peer:InputPeer id:int reaction:flags.0?Reaction offset:flags.1?string limit:int = messages.MessageReactionsList;

/*
Change the set of [message reactions](https://core.telegram.org/api/reactions) that can be used in a certain group, supergroup or channel

@peer Group where to apply changes
@available_reactions Allowed reaction emojis
@reactions_limit This flag may be used to impose a custom limit of unique reactions (i.e. a customizable version of [appConfig.reactions_uniq_max](https://core.telegram.org/api/config#reactions-uniq-max)); this field and the other info set by the method will then be available to users in [channelFull](https://core.telegram.org/constructor/channelFull) and [chatFull](https://core.telegram.org/constructor/chatFull). If this flag is not set, the previously configured reactions_limit will not be altered.
@paid_enabled If this flag is set and a [Bool](https://core.telegram.org/type/Bool) is passed, the method will enable or disable [paid message reactions](https://core.telegram.org/api/reactions#paid-reactions). If this flag is not set, the previously stored setting will not be changed.

$400, ChatAdminRequiredError
$400, ChatNotModifiedError
$400, PeerIdInvalidError
*/
messages.setChatAvailableReactions#864b2581 flags:# peer:InputPeer available_reactions:ChatReactions reactions_limit:flags.0?int paid_enabled:flags.1?Bool = Updates;

/*
Obtain available [message reactions](https://core.telegram.org/api/reactions)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getAvailableReactions#18dea0ac hash:int = messages.AvailableReactions;

/*
Change default emoji reaction to use in the quick reaction menu: the value is synced across devices and can be fetched using [help.getConfig, reactions_default field](https://core.telegram.org/method/help.getConfig).

@reaction New emoji reaction

$400, ReactionInvalidError
*/
messages.setDefaultReaction#4f47a016 reaction:Reaction = Bool;

/*
Translate a given text.

@peer If the text is a chat message, the peer ID
@id A list of message IDs to translate
@text A list of styled messages to translate
@to_lang Two-letter ISO 639-1 language code of the language to which the message is translated

$400, InputTextEmptyError
$400, InputTextTooLongError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, ToLangInvalidError
$500, TranslateReqFailedError
$400, TranslateReqQuotaExceededError
*/
messages.translateText#63183030 flags:# peer:flags.0?InputPeer id:flags.0?Vector<int> text:flags.1?Vector<TextWithEntities> to_lang:string = messages.TranslatedText;

/*
Get unread reactions to messages you sent

@peer Peer
@top_msg_id If set, considers only reactions to messages within the specified [forum topic](https://core.telegram.org/api/forum#forum-topics)
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@add_offset [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
@max_id Only return reactions for messages up until this message ID
@min_id Only return reactions for messages starting from this message ID

$400, PeerIdInvalidError
*/
messages.getUnreadReactions#3223495b flags:# peer:InputPeer top_msg_id:flags.0?int offset_id:int add_offset:int limit:int max_id:int min_id:int = messages.Messages;

/*
Mark [message reactions](https://core.telegram.org/api/reactions) as read

@peer Peer
@top_msg_id Mark as read only reactions to messages within the specified [forum topic](https://core.telegram.org/api/forum#forum-topics)

$400, PeerIdInvalidError
*/
messages.readReactions#54aa7f8e flags:# peer:InputPeer top_msg_id:flags.0?int = messages.AffectedHistory;

/*
View and search recently sent media. 
This method does not support pagination.

@q Optional search query
@filter Message filter
@limit Maximum number of results to return (max 100).

$400, FilterNotSupportedError
*/
messages.searchSentMedia#107e31a0 q:string filter:MessagesFilter limit:int = messages.Messages;

/*
Returns installed attachment menu [bot mini apps](https://core.telegram.org/api/bots/attach)

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getAttachMenuBots#16fcc2cb hash:long = AttachMenuBots;

/*
Returns attachment menu entry for a [bot mini app that can be launched from the attachment menu](https://core.telegram.org/api/bots/attach)

@bot Bot ID

$400, BotInvalidError
*/
messages.getAttachMenuBot#77216192 bot:InputUser = AttachMenuBotsBot;

/*
Enable or disable [web bot attachment menu](https://core.telegram.org/api/bots/attach)

@write_allowed Whether the user authorizes the bot to write messages to them, if requested by [attachMenuBot](https://core.telegram.org/constructor/attachMenuBot). request_write_access
@bot Bot ID
@enabled Toggle

$400, BotInvalidError
*/
messages.toggleBotInAttachMenu#69f59d69 flags:# write_allowed:flags.0?true bot:InputUser enabled:Bool = Bool;

/*
Open a [bot mini app](https://core.telegram.org/bots/webapps), sending over user information after user confirmation.

@from_bot_menu Whether the webview was opened by clicking on the bot's [menu button](https://core.telegram.org/api/bots/menu).
@silent Whether the inline message that will be sent by the bot on behalf of the user once the web app interaction is [terminated](https://core.telegram.org/method/messages.sendWebViewResultMessage) should be sent silently (no notifications for the receivers).
@compact If set, requests to open the mini app in compact mode (as opposed to normal or fullscreen mode). Must be set if the mode parameter of the [attachment menu deep link](https://core.telegram.org/api/links#bot-attachment-or-side-menu-links) is equal to compact.
@fullscreen If set, requests to open the mini app in fullscreen mode (as opposed to normal or compact mode). Must be set if the mode parameter of the [attachment menu deep link](https://core.telegram.org/api/links#bot-attachment-or-side-menu-links) is equal to fullscreen.
@peer Dialog where the web app is being opened, and where the resulting message will be sent (see the [docs for more info](https://core.telegram.org/api/bots/webapps)).
@bot Bot that owns the [web app](https://core.telegram.org/api/bots/webapps)
@url [Web app URL](https://core.telegram.org/api/bots/webapps)
@start_param If the web app was opened from the attachment menu using a [attachment menu deep link](https://core.telegram.org/api/links#bot-attachment-or-side-menu-links), start_param should contain the data from the startattach parameter.
@theme_params [Theme parameters](https://core.telegram.org/api/bots/webapps#theme-parameters)
@platform Short name of the application; 0-64 English letters, digits, and underscores
@reply_to If set, indicates that the inline message that will be sent by the bot on behalf of the user once the web app interaction is [terminated](https://core.telegram.org/method/messages.sendWebViewResultMessage) should be sent in reply to the specified message or story.
@send_as Open the web app as the specified peer, sending the resulting the message as the specified peer.

$400, BotInvalidError
$400, BotWebviewDisabledError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$403, PrivacyPremiumRequiredError
$400, SendAsPeerInvalidError
$400, ThemeParamsInvalidError
$400, UrlInvalidError
$400, YouBlockedUserError
*/
messages.requestWebView#269dc2c1 flags:# from_bot_menu:flags.4?true silent:flags.5?true compact:flags.7?true fullscreen:flags.8?true peer:InputPeer bot:InputUser url:flags.1?string start_param:flags.3?string theme_params:flags.2?DataJSON platform:string reply_to:flags.0?InputReplyTo send_as:flags.13?InputPeer = WebViewResult;

/*
Indicate to the server (from the user side) that the user is still using a web app.

@silent Whether the inline message that will be sent by the bot on behalf of the user once the web app interaction is [terminated](https://core.telegram.org/method/messages.sendWebViewResultMessage) should be sent silently (no notifications for the receivers).
@peer Dialog where the web app was opened.
@bot Bot that owns the [web app](https://core.telegram.org/api/bots/webapps)
@query_id Web app interaction ID obtained from [messages.requestWebView](https://core.telegram.org/method/messages.requestWebView)
@reply_to If set, indicates that the inline message that will be sent by the bot on behalf of the user once the web app interaction is [terminated](https://core.telegram.org/method/messages.sendWebViewResultMessage) should be sent in reply to the specified message or story.
@send_as Open the web app as the specified peer

$400, BotInvalidError
*/
messages.prolongWebView#b0d81a83 flags:# silent:flags.5?true peer:InputPeer bot:InputUser query_id:long reply_to:flags.0?InputReplyTo send_as:flags.13?InputPeer = Bool;

/*
Open a [bot mini app](https://core.telegram.org/api/bots/webapps).

@from_switch_webview Whether the webapp was opened by clicking on the switch_webview button shown on top of the inline results list returned by [messages.getInlineBotResults](https://core.telegram.org/method/messages.getInlineBotResults).
@from_side_menu Set this flag if opening the Mini App from the installed [side menu entry](https://core.telegram.org/api/bots/attach).
@compact Deprecated.
@fullscreen Requests to open the app in fullscreen mode.
@bot Bot that owns the mini app
@url Web app URL, if opening from a keyboard button or inline result
@start_param Deprecated.
@theme_params [Theme parameters](https://core.telegram.org/api/bots/webapps#theme-parameters)
@platform Short name of the application; 0-64 English letters, digits, and underscores

$400, BotInvalidError
$400, UrlInvalidError
*/
messages.requestSimpleWebView#413a3e73 flags:# from_switch_webview:flags.1?true from_side_menu:flags.2?true compact:flags.7?true fullscreen:flags.8?true bot:InputUser url:flags.3?string start_param:flags.4?string theme_params:flags.0?DataJSON platform:string = WebViewResult;

/*
Terminate webview interaction started with [messages.requestWebView](https://core.telegram.org/method/messages.requestWebView), sending the specified message to the chat on behalf of the user.

**Bots can use this method**

@bot_query_id Webview interaction ID obtained from [messages.requestWebView](https://core.telegram.org/method/messages.requestWebView)
@result Message to send

$400, QueryIdInvalidError
$400, UserBotRequiredError
*/
messages.sendWebViewResultMessage#a4314f5 bot_query_id:string result:InputBotInlineResult = WebViewMessageSent;

/*
Used by the user to relay data from an opened [reply keyboard bot mini app](https://core.telegram.org/api/bots/webapps) to the bot that owns it.

@bot Bot that owns the web app
@random_id Unique client message ID to prevent duplicate sending of the same event
@button_text Text of the [keyboardButtonSimpleWebView](https://core.telegram.org/constructor/keyboardButtonSimpleWebView) that was pressed to open the web app.
@data Data to relay to the bot, obtained from a [web_app_data_send JS event](https://core.telegram.org/api/web-events#web-app-data-send).

$400, BotInvalidError
*/
messages.sendWebViewData#dc0242c8 bot:InputUser random_id:long button_text:string data:string = Updates;

/*
[Transcribe voice message](https://core.telegram.org/api/transcribe)

@peer Peer ID where the voice message was sent
@msg_id Voice message ID

$400, PeerIdInvalidError
$403, PremiumAccountRequiredError
$400, TranscriptionFailedError
*/
messages.transcribeAudio#269e9a49 peer:InputPeer msg_id:int = messages.TranscribedAudio;

/*
Rate [transcribed voice message](https://core.telegram.org/api/transcribe)

@peer Peer where the voice message was sent
@msg_id Message ID
@transcription_id Transcription ID
@good Whether the transcription was correct
*/
messages.rateTranscribedAudio#7f1d072f peer:InputPeer msg_id:int transcription_id:long good:Bool = Bool;

/*
Fetch [custom emoji stickers](https://core.telegram.org/api/custom-emoji).

**Bots can use this method**

@document_id [Custom emoji](https://core.telegram.org/api/custom-emoji) IDs from a [messageEntityCustomEmoji](https://core.telegram.org/constructor/messageEntityCustomEmoji).
*/
messages.getCustomEmojiDocuments#d9ab0f54 document_id:Vector<long> = Vector<Document>;

/*
Gets the list of currently installed [custom emoji stickersets](https://core.telegram.org/api/custom-emoji).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getEmojiStickers#fbfca18f hash:long = messages.AllStickers;

/*
Gets featured custom emoji stickersets.

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getFeaturedEmojiStickers#ecf6736 hash:long = messages.FeaturedStickers;

/*
Report a [message reaction](https://core.telegram.org/api/reactions)

@peer Peer where the message was sent
@id Message ID
@reaction_peer Peer that sent the reaction

$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, UserIdInvalidError
*/
messages.reportReaction#3f64c076 peer:InputPeer id:int reaction_peer:InputPeer = Bool;

/*
Got popular [message reactions](https://core.telegram.org/api/reactions)

@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getTopReactions#bb8125ba limit:int hash:long = messages.Reactions;

/*
Get recently used [message reactions](https://core.telegram.org/api/reactions)

@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getRecentReactions#39461db2 limit:int hash:long = messages.Reactions;

/*
Clear recently used [message reactions](https://core.telegram.org/api/reactions)
*/
messages.clearRecentReactions#9dfeefb4 = Bool;

/*
Fetch updated information about [paid media, see here](https://core.telegram.org/api/paid-media) for the full flow.

@peer Peer with visible paid media messages.
@id IDs of currently visible messages containing paid media.
*/
messages.getExtendedMedia#84f80814 peer:InputPeer id:Vector<int> = Updates;

/*
Changes the default value of the Time-To-Live setting, applied to all new chats.

@period The new default Time-To-Live of all messages sent in new chats, in seconds.

$400, TtlPeriodInvalidError
*/
messages.setDefaultHistoryTTL#9eb51445 period:int = Bool;

/*
Gets the default value of the Time-To-Live setting, applied to all new chats.
*/
messages.getDefaultHistoryTTL#658b7188 = DefaultHistoryTTL;

/*
Send one or more chosen peers, as requested by a [keyboardButtonRequestPeer](https://core.telegram.org/constructor/keyboardButtonRequestPeer) button.

@peer The bot that sent the [keyboardButtonRequestPeer](https://core.telegram.org/constructor/keyboardButtonRequestPeer) button.
@msg_id ID of the message that contained the reply keyboard with the [keyboardButtonRequestPeer](https://core.telegram.org/constructor/keyboardButtonRequestPeer) button.
@button_id The button_id field from the [keyboardButtonRequestPeer](https://core.telegram.org/constructor/keyboardButtonRequestPeer) constructor.
@requested_peers The chosen peers.

$400, MessageIdInvalidError
$400, PeerIdInvalidError
*/
messages.sendBotRequestedPeer#91b2d060 peer:InputPeer msg_id:int button_id:int requested_peers:Vector<InputPeer> = Updates;

/*
Represents a list of [emoji categories](https://core.telegram.org/api/emoji-categories).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getEmojiGroups#7488ce5b hash:int = messages.EmojiGroups;

/*
Represents a list of [emoji categories](https://core.telegram.org/api/emoji-categories), to be used when selecting custom emojis to set as [custom emoji status](https://core.telegram.org/api).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getEmojiStatusGroups#2ecd56cd hash:int = messages.EmojiGroups;

/*
Represents a list of [emoji categories](https://core.telegram.org/api/emoji-categories), to be used when selecting custom emojis to set as [profile picture](https://core.telegram.org/api/files#sticker-profile-pictures).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getEmojiProfilePhotoGroups#21a548f3 hash:int = messages.EmojiGroups;

/*
Look for [custom emojis](https://core.telegram.org/api/custom-emoji) associated to a UTF8 emoji

@emoticon The emoji
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).

$400, EmoticonEmptyError
*/
messages.searchCustomEmoji#2c11c0d7 emoticon:string hash:long = EmojiList;

/*
Show or hide the [real-time chat translation popup](https://core.telegram.org/api/translation) for a certain chat

@disabled Whether to disable or enable the real-time chat translation popup
@peer The peer

$400, PeerIdInvalidError
*/
messages.togglePeerTranslations#e47cb579 flags:# disabled:flags.0?true peer:InputPeer = Bool;

/*
Obtain information about a [direct link Mini App](https://core.telegram.org/api/bots/webapps#direct-link-mini-apps)

@app Bot app information obtained from a [Direct Mini App deep link](https://core.telegram.org/api/links#direct-mini-app-links).
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)

$400, BotAppBotInvalidError
$400, BotAppInvalidError
$400, BotAppShortnameInvalidError
*/
messages.getBotApp#34fdc5c3 app:InputBotApp hash:long = messages.BotApp;

/*
Open a [bot mini app](https://core.telegram.org/bots/webapps) from a [direct Mini App deep link](https://core.telegram.org/api/links#direct-mini-app-links), sending over user information after user confirmation.

@write_allowed Set this flag if the bot is asking permission to send messages to the user as specified in the [direct Mini App deep link](https://core.telegram.org/api/links#direct-mini-app-links) docs, and the user agreed.
@compact If set, requests to open the mini app in compact mode (as opposed to normal or fullscreen mode). Must be set if the mode parameter of the [direct Mini App deep link](https://core.telegram.org/api/links#direct-mini-app-links) is equal to compact.
@fullscreen If set, requests to open the mini app in fullscreen mode (as opposed to compact or normal mode). Must be set if the mode parameter of the [direct Mini App deep link](https://core.telegram.org/api/links#direct-mini-app-links) is equal to fullscreen.
@peer If the client has clicked on the link in a Telegram chat, pass the chat's peer information; otherwise pass the bot's peer information, instead.
@app The app obtained by invoking [messages.getBotApp](https://core.telegram.org/method/messages.getBotApp) as specified in the [direct Mini App deep link](https://core.telegram.org/api/links#direct-mini-app-links) docs.
@start_param If the startapp query string parameter is present in the [direct Mini App deep link](https://core.telegram.org/api/links#direct-mini-app-links), pass it to start_param.
@theme_params [Theme parameters](https://core.telegram.org/api/bots/webapps#theme-parameters)
@platform Short name of the application; 0-64 English letters, digits, and underscores

$400, BotAppBotInvalidError
$400, BotAppInvalidError
$400, BotAppShortnameInvalidError
*/
messages.requestAppWebView#53618bce flags:# write_allowed:flags.0?true compact:flags.7?true fullscreen:flags.8?true peer:InputPeer app:InputBotApp start_param:flags.1?string theme_params:flags.2?DataJSON platform:string = WebViewResult;

/*
Set a custom [wallpaper](https://core.telegram.org/api/wallpapers) in a specific private chat with another user.

@for_both Only for [Premium](https://core.telegram.org/api/premium) users, sets the specified wallpaper for both users of the chat, without requiring confirmation from the other user.
@revert If we don't like the new wallpaper the other user of the chat has chosen for us using the for_both flag, we can re-set our previous wallpaper just on our side using this flag.
@peer The private chat where the wallpaper will be set
@wallpaper The [wallpaper](https://core.telegram.org/api/wallpapers), obtained as described in the [wallpaper documentation](https://core.telegram.org/api/wallpapers#uploading-wallpapers); must not be provided when installing a wallpaper obtained from a [messageActionSetChatWallPaper](https://core.telegram.org/constructor/messageActionSetChatWallPaper) service message ( id must be provided, instead).
@settings Wallpaper settings, obtained as described in the [wallpaper documentation](https://core.telegram.org/api/wallpapers#uploading-wallpapers) or from [messageActionSetChatWallPaper](https://core.telegram.org/constructor/messageActionSetChatWallPaper). wallpaper. settings.
@id If the wallpaper was obtained from a [messageActionSetChatWallPaper](https://core.telegram.org/constructor/messageActionSetChatWallPaper) service message, must contain the ID of that message.

$400, PeerIdInvalidError
$400, WallpaperInvalidError
$400, WallpaperNotFoundError
*/
messages.setChatWallPaper#8ffacae1 flags:# for_both:flags.3?true revert:flags.4?true peer:InputPeer wallpaper:flags.0?InputWallPaper settings:flags.2?WallPaperSettings id:flags.1?int = Updates;

/*
Search for [custom emoji stickersets](https://core.telegram.org/api/custom-emoji)

@exclude_featured Exclude featured stickersets from results
@q Query string
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.searchEmojiStickerSets#92b4494c flags:# exclude_featured:flags.0?true q:string hash:long = messages.FoundStickerSets;

/*
Returns the current saved dialog list, see [here](https://core.telegram.org/api/saved-messages) for more info.

@exclude_pinned Exclude pinned dialogs
@offset_date [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets) ( top_message ID used for pagination)
@offset_peer [Offset peer for pagination](https://core.telegram.org/api/offsets)
@limit Number of list elements to be returned
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)
*/
messages.getSavedDialogs#5381d21a flags:# exclude_pinned:flags.0?true offset_date:int offset_id:int offset_peer:InputPeer limit:int hash:long = messages.SavedDialogs;

/*
Returns [saved messages](https://core.telegram.org/api/saved-messages) forwarded from a specific peer

@peer Target peer
@offset_id Only return messages starting from the specified message ID
@offset_date Only return messages sent before the specified date
@add_offset Number of list elements to be skipped, negative values are also accepted.
@limit Number of results to return
@max_id If a positive value was transferred, the method will return only messages with IDs less than max_id
@min_id If a positive value was transferred, the method will return only messages with IDs more than min_id
@hash [Result hash](https://core.telegram.org/api/offsets)

$400, PeerIdInvalidError
*/
messages.getSavedHistory#3d9a414d peer:InputPeer offset_id:int offset_date:int add_offset:int limit:int max_id:int min_id:int hash:long = messages.Messages;

/*
Deletes messages forwarded from a specific peer to [saved messages](https://core.telegram.org/api/saved-messages).

@peer Peer, whose messages will be deleted from [saved messages](https://core.telegram.org/api/saved-messages)
@max_id Maximum ID of message to delete
@min_date Delete all messages newer than this UNIX timestamp
@max_date Delete all messages older than this UNIX timestamp

$400, PeerIdInvalidError
*/
messages.deleteSavedHistory#6e98102b flags:# peer:InputPeer max_id:int min_date:flags.2?int max_date:flags.3?int = messages.AffectedHistory;

/*
Get pinned [saved dialogs, see here](https://core.telegram.org/api/saved-messages) for more info.
*/
messages.getPinnedSavedDialogs#d63d94e0 = messages.SavedDialogs;

/*
Pin or unpin a [saved message dialog](https://core.telegram.org/api/saved-messages).

@pinned Whether to pin or unpin the dialog
@peer The dialog to pin

$400, PeerIdInvalidError
*/
messages.toggleSavedDialogPin#ac81bbde flags:# pinned:flags.0?true peer:InputDialogPeer = Bool;

/*
Reorder pinned [saved message dialogs](https://core.telegram.org/api/saved-messages).

@force If set, dialogs pinned server-side but not present in the order field will be unpinned.
@order New dialog order
*/
messages.reorderPinnedSavedDialogs#8b716587 flags:# force:flags.0?true order:Vector<InputDialogPeer> = Bool;

/*
Fetch the full list of [saved message tags](https://core.telegram.org/api/saved-messages#tags) created by the user.

@peer If set, returns tags only used in the specified [saved message dialog](https://core.telegram.org/api/saved-messages#saved-message-dialogs).
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getSavedReactionTags#3637e05b flags:# peer:flags.0?InputPeer hash:long = messages.SavedReactionTags;

/*
Update the [description of a saved message tag](https://core.telegram.org/api/saved-messages#tags).

@reaction [Reaction](https://core.telegram.org/api/reactions) associated to the tag
@title Tag description, max 12 UTF-8 characters; to remove the description call the method without setting this flag.

$403, PremiumAccountRequiredError
$400, ReactionInvalidError
*/
messages.updateSavedReactionTag#60297dec flags:# reaction:Reaction title:flags.0?string = Bool;

/*
Fetch a default recommended list of [saved message tag reactions](https://core.telegram.org/api/saved-messages#tags).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getDefaultTagReactions#bdf93428 hash:long = messages.Reactions;

/*
Get the exact read date of one of our messages, sent to a private chat with another user.

@peer The user to whom we sent the message.
@msg_id The message ID.

$400, MessageIdInvalidError
$400, MessageNotReadYetError
$400, MessageTooOldError
$400, PeerIdInvalidError
$403, UserPrivacyRestrictedError
$403, YourPrivacyRestrictedError
*/
messages.getOutboxReadDate#8c4bfe5d peer:InputPeer msg_id:int = OutboxReadDate;

/*
Fetch basic info about all existing [quick reply shortcuts](https://core.telegram.org/api/business#quick-reply-shortcuts).

@hash Hash for pagination, generated as specified [here](https://core.telegram.org/api/business#quick-reply-shortcuts) (not the usual algorithm used for hash generation.)
*/
messages.getQuickReplies#d483f2a8 hash:long = messages.QuickReplies;

/*
Reorder [quick reply shortcuts](https://core.telegram.org/api/business#quick-reply-shortcuts).

@order IDs of all created [quick reply shortcuts](https://core.telegram.org/api/business#quick-reply-shortcuts), in the desired order.

$403, PremiumAccountRequiredError
*/
messages.reorderQuickReplies#60331907 order:Vector<int> = Bool;

/*
Before offering the user the choice to add a message to a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts), to make sure that none of the limits specified [here](https://core.telegram.org/api/business#quick-reply-shortcuts) were reached.

@shortcut Shorcut name (not ID!).

$403, PremiumAccountRequiredError
*/
messages.checkQuickReplyShortcut#f1d0fbd3 shortcut:string = Bool;

/*
Rename a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts). 
This will emit an [updateQuickReplies](https://core.telegram.org/constructor/updateQuickReplies) update to other logged-in sessions.

@shortcut_id [Shortcut ID](https://core.telegram.org/api/business#quick-reply-shortcuts).
@shortcut New shortcut name.

$403, PremiumAccountRequiredError
$400, ShortcutInvalidError
*/
messages.editQuickReplyShortcut#5c003cef shortcut_id:int shortcut:string = Bool;

/*
Completely delete a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts). 
This will also emit an [updateDeleteQuickReply](https://core.telegram.org/constructor/updateDeleteQuickReply) update to other logged-in sessions (and no [updateDeleteQuickReplyMessages](https://core.telegram.org/constructor/updateDeleteQuickReplyMessages) updates, even if all the messages in the shortcuts are also deleted by this method).

@shortcut_id [Shortcut ID](https://core.telegram.org/api/business#quick-reply-shortcuts)

$400, ShortcutInvalidError
*/
messages.deleteQuickReplyShortcut#3cc04740 shortcut_id:int = Bool;

/*
Fetch (a subset or all) messages in a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts).

@shortcut_id Quick reply shortcut ID.
@id IDs of the messages to fetch, if empty fetches all of them.
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation)

$400, ShortcutInvalidError
*/
messages.getQuickReplyMessages#94a495c3 flags:# shortcut_id:int id:flags.0?Vector<int> hash:long = messages.Messages;

/*
Send a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts).

@peer The peer where to send the shortcut (users only, for now).
@shortcut_id The ID of the quick reply shortcut to send.
@id Specify a subset of messages from the shortcut to send; if empty, defaults to all of them.
@random_id Unique client IDs required to prevent message resending, one for each message we're sending, may be empty (but not recommended).

$400, PeerIdInvalidError
$403, PremiumAccountRequiredError
*/
messages.sendQuickReplyMessages#6c750de1 peer:InputPeer shortcut_id:int id:Vector<int> random_id:Vector<long> = Updates;

/*
Delete one or more messages from a [quick reply shortcut](https://core.telegram.org/api/business#quick-reply-shortcuts). This will also emit an [updateDeleteQuickReplyMessages](https://core.telegram.org/constructor/updateDeleteQuickReplyMessages) update.

@shortcut_id [Shortcut ID](https://core.telegram.org/api/business#quick-reply-shortcuts).
@id IDs of shortcut messages to delete.

$400, ShortcutInvalidError
*/
messages.deleteQuickReplyMessages#e105e910 shortcut_id:int id:Vector<int> = Updates;

/*
Enable or disable [folder tags](https://core.telegram.org/api/folders#folder-tags).

@enabled Enable or disable folder tags.

$403, PremiumAccountRequiredError
*/
messages.toggleDialogFilterTags#fd2dda49 enabled:Bool = Bool;

/*
Fetch all [stickersets](https://core.telegram.org/api/stickers) owned by the current user.

@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
*/
messages.getMyStickers#d0b5e1fc offset_id:long limit:int = messages.MyStickers;

/*
Represents a list of [emoji categories](https://core.telegram.org/api/emoji-categories), to be used when choosing a sticker.

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getEmojiStickerGroups#1dd840f5 hash:int = messages.EmojiGroups;

/*
Fetch the full list of usable [animated message effects](https://core.telegram.org/api/effects).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
messages.getAvailableEffects#dea20a39 hash:int = messages.AvailableEffects;

/*
Edit/create a [fact-check](https://core.telegram.org/api/factcheck) on a message.

@peer Peer where the message was sent
@msg_id Message ID
@text Fact-check (maximum UTF-8 length specified in [appConfig.factcheck_length_limit](https://core.telegram.org/api/config#factcheck-length-limit)).

$403, ChatActionForbiddenError
$400, PeerIdInvalidError
*/
messages.editFactCheck#589ee75 peer:InputPeer msg_id:int text:TextWithEntities = Updates;

/*
Delete a [fact-check](https://core.telegram.org/api/factcheck) from a message.

@peer Peer where the message was sent.
@msg_id Message ID

$403, ChatActionForbiddenError
$400, PeerIdInvalidError
*/
messages.deleteFactCheck#d1da940c peer:InputPeer msg_id:int = Updates;

/*
Fetch one or more [factchecks, see here](https://core.telegram.org/api/factcheck) for the full flow.

@peer Peer where the messages were sent.
@msg_id Messages that have associated [factCheck](https://core.telegram.org/constructor/factCheck) constructors with the need_check flag set.

$400, PeerIdInvalidError
*/
messages.getFactCheck#b9cdc5ee peer:InputPeer msg_id:Vector<int> = Vector<FactCheck>;

/*
Open a [Main Mini App](https://core.telegram.org/api/bots/webapps#main-mini-apps).

@compact If set, requests to open the mini app in compact mode (as opposed to normal or fullscreen mode). Must be set if the mode parameter of the [Main Mini App link](https://core.telegram.org/api/links#main-mini-app-links) is equal to compact.
@fullscreen If set, requests to open the mini app in fullscreen mode (as opposed to compact or normal mode). Must be set if the mode parameter of the [Main Mini App link](https://core.telegram.org/api/links#main-mini-app-links) is equal to fullscreen.
@peer Currently open chat, may be [inputPeerEmpty](https://core.telegram.org/constructor/inputPeerEmpty) if no chat is currently open.
@bot Bot that owns the main mini app.
@start_param Start parameter, if opening from a [Main Mini App link](https://core.telegram.org/api/links#main-mini-app-links).
@theme_params [Theme parameters](https://core.telegram.org/api/bots/webapps#theme-parameters)
@platform Short name of the application; 0-64 English letters, digits, and underscores

$400, BotInvalidError
*/
messages.requestMainWebView#c9e01e7b flags:# compact:flags.7?true fullscreen:flags.8?true peer:InputPeer bot:InputUser start_param:flags.1?string theme_params:flags.0?DataJSON platform:string = WebViewResult;

/*
Sends one or more [paid Telegram Star reactions](https://core.telegram.org/api/reactions#paid-reactions), transferring [Telegram Stars](https://core.telegram.org/api/stars) to a channel's balance.

@peer The channel
@msg_id The message to react to
@count The number of [stars](https://core.telegram.org/api/stars) to send (each will increment the reaction counter by one).
@random_id Unique client message ID required to prevent message resending
@private Each post with star reactions has a leaderboard with the top senders, but users can opt out of appearing there if they prefer more privacy.  If the user explicitly chose to make their paid reaction(s) private, pass [boolTrue](https://core.telegram.org/constructor/boolTrue) to [messages.sendPaidReaction](https://core.telegram.org/method/messages.sendPaidReaction). private.  If the user explicitly chose to make their paid reaction(s) private, pass [boolFalse](https://core.telegram.org/constructor/boolTrue) to [messages.sendPaidReaction](https://core.telegram.org/method/messages.sendPaidReaction). private.  If the user did not make any explicit choice about the privacy of their paid reaction(s) (i.e. when reacting by clicking on an existing star reaction on a message), do not populate the [messages.sendPaidReaction](https://core.telegram.org/method/messages.sendPaidReaction). private flag.

$400, MessageIdInvalidError
*/
messages.sendPaidReaction#58bbcb50 flags:# peer:InputPeer msg_id:int count:int random_id:long private:flags.0?PaidReactionPrivacy = Updates;

/*
Changes the privacy of already sent [paid reactions](https://core.telegram.org/api/reactions#paid-reactions) on a specific message.

@peer The channel
@msg_id The ID of the message to which we sent the paid reactions
@private If true, makes the current anonymous in the top sender leaderboard for this message; otherwise, does the opposite.

$400, PeerIdInvalidError
*/
messages.togglePaidReactionPrivacy#435885b5 peer:InputPeer msg_id:int private:PaidReactionPrivacy = Bool;

/*
Fetches an [updatePaidReactionPrivacy](https://core.telegram.org/constructor/updatePaidReactionPrivacy) update with the current [default paid reaction privacy, see here](https://core.telegram.org/api/reactions#paid-reactions) for more info.
*/
messages.getPaidReactionPrivacy#472455aa = Updates;

/*
Mark a specific [sponsored message](https://core.telegram.org/api/sponsored-messages) as read

@peer The channel/bot where the ad is located
@random_id The ad's unique ID.
*/
messages.viewSponsoredMessage#673ad8f1 peer:InputPeer random_id:bytes = Bool;

/*
Informs the server that the user has interacted with a sponsored message in [one of the ways listed here](https://core.telegram.org/api/sponsored-messages#clicking-on-sponsored-messages).

@media The user clicked on the media
@fullscreen The user expanded the video to full screen, and then clicked on it.
@peer The channel/bot where the ad is located
@random_id The ad's unique ID.
*/
messages.clickSponsoredMessage#f093465 flags:# media:flags.0?true fullscreen:flags.1?true peer:InputPeer random_id:bytes = Bool;

/*
Report a [sponsored message](https://core.telegram.org/api/sponsored-messages), see [here](https://core.telegram.org/api/sponsored-messages#reporting-sponsored-messages) for more info on the full flow.

@peer The channel/bot where the ad is located
@random_id The ad's unique ID.
@option Chosen report option, initially an empty string, see [here](https://core.telegram.org/api/sponsored-messages#reporting-sponsored-messages) for more info on the full flow.
*/
messages.reportSponsoredMessage#1af3dbb8 peer:InputPeer random_id:bytes option:bytes = channels.SponsoredMessageReportResult;

/*
Get a list of [sponsored messages for a peer, see here](https://core.telegram.org/api/sponsored-messages) for more info.

@peer The currently open channel/bot.
*/
messages.getSponsoredMessages#9bd2f439 peer:InputPeer = messages.SponsoredMessages;

/*
Save a [prepared inline message](https://core.telegram.org/api/bots/inline#21-using-a-prepared-inline-message), to be shared by the user of the mini app using a [web_app_send_prepared_message event](https://core.telegram.org/api/web-events#web-app-send-prepared-message)

**Bots can use this method**

@result The message
@user_id The user to whom the [web_app_send_prepared_message event](https://core.telegram.org/api/web-events#web-app-send-prepared-message) event will be sent
@peer_types Types of chats where this message can be sent

$400, ResultIdInvalidError
$400, UserBotRequiredError
$400, UserIdInvalidError
*/
messages.savePreparedInlineMessage#f21f7f2f flags:# result:InputBotInlineResult user_id:InputUser peer_types:flags.0?Vector<InlineQueryPeerType> = messages.BotPreparedInlineMessage;

/*
Obtain a [prepared inline message](https://core.telegram.org/api/bots/inline#21-using-a-prepared-inline-message) generated by a [mini app](https://core.telegram.org/api/bots/webapps): invoked when handling [web_app_send_prepared_message events](https://core.telegram.org/api/web-events#web-app-send-prepared-message)

@bot The bot that owns the mini app that emitted the [web_app_send_prepared_message event](https://core.telegram.org/api/web-events#web-app-send-prepared-message)
@id The id from the [web_app_send_prepared_message event](https://core.telegram.org/api/web-events#web-app-send-prepared-message)

$400, IdExpiredError
$400, IdInvalidError
*/
messages.getPreparedInlineMessage#857ebdb8 bot:InputUser id:string = messages.PreparedInlineMessage;

/*
Search for stickers using AI-powered keyword search

@emojis If set, returns [custom emoji stickers](https://core.telegram.org/api/custom-emoji)
@q The search term
@emoticon Space-separated list of emojis to search for
@lang_code List of possible IETF language tags of the user's input language; may be empty if unknown
@offset [Offset for pagination](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation). The hash may be generated locally by using the ids of the returned or stored sticker [document](https://core.telegram.org/constructor/document)s.
*/
messages.searchStickers#29b1c66a flags:# emojis:flags.0?true q:string emoticon:string lang_code:Vector<string> offset:int limit:int hash:long = messages.FoundStickers;

messages.reportMessagesDelivery#5a6d7395 flags:# push:flags.0?true peer:InputPeer id:Vector<int> = Bool;
/*
Returns a current state of updates.

**Bots can use this method**
*/
updates.getState#edd4882a = updates.State;

/*
Get new [updates](https://core.telegram.org/api/updates).

**Bots can use this method**

@pts PTS, see [updates](https://core.telegram.org/api/updates).
@pts_limit PTS limit
@pts_total_limit For fast updating: if provided and pts + pts_total_limit < remote pts, [updates.differenceTooLong](https://core.telegram.org/constructor/updates.differenceTooLong) will be returned. Simply tells the server to not return the difference if it is bigger than pts_total_limit If the remote pts is too big (> ~4000000), this field will default to 1000000
@date date, see [updates](https://core.telegram.org/api/updates).
@qts QTS, see [updates](https://core.telegram.org/api/updates).
@qts_limit QTS limit

$400, CdnMethodInvalidError
$400, ChannelInvalidError
$400, ChannelPrivateError
$403, ChatWriteForbiddenError
$400, DateEmptyError
$400, MsgIdInvalidError
$400, PersistentTimestampEmptyError
$400, PersistentTimestampInvalidError
$500, RandomIdDuplicateError
$400, UsernameInvalidError
$400, UserNotParticipantError
*/
updates.getDifference#19c2f763 flags:# pts:int pts_limit:flags.1?int pts_total_limit:flags.0?int date:int qts:int qts_limit:flags.2?int = updates.Difference;

/*
Returns the difference between the current state of updates of a certain channel and transmitted.

**Bots can use this method**

@force Set to true to skip some possibly unneeded updates and reduce server-side load
@channel The channel
@filter Messsage filter
@pts Persistent timestamp (see [updates](https://core.telegram.org/api/updates))
@limit How many updates to fetch, max 100000 Ordinary (non-bot) users are supposed to pass 10-100

$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChannelPublicGroupNaError
$403, ChatWriteForbiddenError
$400, FromMessageBotDisabledError
$400, MsgIdInvalidError
$400, PersistentTimestampEmptyError
$400, PersistentTimestampInvalidError
$500, PersistentTimestampOutdatedError
$400, PinnedDialogsTooMuchError
$400, RangesInvalidError
$400, UserBannedInChannelError
*/
updates.getChannelDifference#3173d78 flags:# force:flags.0?true channel:InputChannel filter:ChannelMessagesFilter pts:int limit:int = updates.ChannelDifference;

/*
Installs a previously uploaded photo as a profile photo.

**Bots can use this method**

@fallback If set, the chosen profile photo will be shown to users that can't display your main profile photo due to your privacy settings.
@bot Can contain info of a bot we own, to change the profile photo of that bot, instead of the current user.
@id Input photo

$400, AlbumPhotosTooManyError
$400, FilePartsInvalidError
$400, ImageProcessFailedError
$400, LocationInvalidError
$400, PhotoCropSizeSmallError
$400, PhotoExtInvalidError
$400, PhotoIdInvalidError
*/
photos.updateProfilePhoto#9e82039 flags:# fallback:flags.0?true bot:flags.1?InputUser id:InputPhoto = photos.Photo;

/*
Updates current user profile photo.

**Bots can use this method**

@fallback If set, the chosen profile photo will be shown to users that can't display your main profile photo due to your privacy settings.
@bot Can contain info of a bot we own, to change the profile photo of that bot, instead of the current user.
@file Profile photo
@video [Animated profile picture](https://core.telegram.org/api/files#animated-profile-pictures) video
@video_start_ts Floating point UNIX timestamp in seconds, indicating the frame of the video/sticker that should be used as static preview; can only be used if video or video_emoji_markup is set.
@video_emoji_markup Animated sticker profile picture, must contain either a [videoSizeEmojiMarkup](https://core.telegram.org/constructor/videoSizeEmojiMarkup) or a [videoSizeStickerMarkup](https://core.telegram.org/constructor/videoSizeStickerMarkup) constructor.

$400, AlbumPhotosTooManyError
$400, BotInvalidError
$400, EmojiMarkupInvalidError
$400, FilePartsInvalidError
$400, ImageProcessFailedError
$400, PhotoCropFileMissingError
$400, PhotoCropSizeSmallError
$400, PhotoExtInvalidError
$400, PhotoFileMissingError
$400, PhotoInvalidError
$400, StickerMimeInvalidError
$400, VideoFileInvalidError
*/
photos.uploadProfilePhoto#388a3b5 flags:# fallback:flags.3?true bot:flags.5?InputUser file:flags.0?InputFile video:flags.1?InputFile video_start_ts:flags.2?double video_emoji_markup:flags.4?VideoSize = photos.Photo;

/*
Deletes profile photos. The method returns a list of successfully deleted photo IDs.

@id Input photos to delete
*/
photos.deletePhotos#87cf7f2f id:Vector<InputPhoto> = Vector<long>;

/*
Returns the list of user photos.

**Bots can use this method**

@user_id User ID
@offset Number of list elements to be skipped
@max_id If a positive value was transferred, the method will return only photos with IDs less than the set one. This parameter is often useful when [refetching file references](https://core.telegram.org/api/file_reference), as in conjuction with limit=1 and offset=-1 the [photo](https://core.telegram.org/constructor/photo) object with the id specified in max_id can be fetched.
@limit Number of list elements to be returned

$400, MaxIdInvalidError
$400, MsgIdInvalidError
$400, UserIdInvalidError
*/
photos.getUserPhotos#91cd32a8 user_id:InputUser offset:int max_id:long limit:int = photos.Photos;

/*
Upload a custom profile picture for a contact, or suggest a new profile picture to a contact.

@suggest If set, will send a [messageActionSuggestProfilePhoto](https://core.telegram.org/constructor/messageActionSuggestProfilePhoto) service message to user_id, suggesting them to use the specified profile picture; otherwise, will set a personal profile picture for the user (only visible to the current user).
@save If set, removes a previously set personal profile picture (does not affect suggested profile pictures, to remove them simply deleted the [messageActionSuggestProfilePhoto](https://core.telegram.org/constructor/messageActionSuggestProfilePhoto) service message with [messages.deleteMessages](https://core.telegram.org/method/messages.deleteMessages)).
@user_id The contact
@file Profile photo
@video [Animated profile picture](https://core.telegram.org/api/files#animated-profile-pictures) video
@video_start_ts Floating point UNIX timestamp in seconds, indicating the frame of the video/sticker that should be used as static preview; can only be used if video or video_emoji_markup is set.
@video_emoji_markup Animated sticker profile picture, must contain either a [videoSizeEmojiMarkup](https://core.telegram.org/constructor/videoSizeEmojiMarkup) or a [videoSizeStickerMarkup](https://core.telegram.org/constructor/videoSizeStickerMarkup) constructor.

$400, ContactMissingError
$400, UserIdInvalidError
*/
photos.uploadContactProfilePhoto#e14c4a71 flags:# suggest:flags.3?true save:flags.4?true user_id:InputUser file:flags.0?InputFile video:flags.1?InputFile video_start_ts:flags.2?double video_emoji_markup:flags.5?VideoSize = photos.Photo;

/*
Saves a part of file for further sending to one of the methods.

**Bots can use this method**

@file_id Random file identifier created by the client
@file_part Numerical order of a part
@bytes Binary data, content of a part

$400, FilePartEmptyError
$400, FilePartInvalidError
$400, MsgIdInvalidError
*/
upload.saveFilePart#b304a621 file_id:long file_part:int bytes:bytes = Bool;

/*
Returns content of a whole file or its part.

**Bots can use this method**

@precise Disable some checks on limit and offset values, useful for example to stream videos by keyframes
@cdn_supported Whether the current client supports [CDN downloads](https://core.telegram.org/cdn)
@location File location
@offset Number of bytes to be skipped
@limit Number of bytes to be returned

$400, CdnMethodInvalidError
$400, ChannelInvalidError
$400, ChannelPrivateError
$406, FilerefUpgradeNeededError
$400, FileIdInvalidError
$400, FileReferenceEmptyError
$400, FileReferenceExpiredError
$420, FloodPremiumWaitError
$400, LimitInvalidError
$400, LocationInvalidError
$400, MsgIdInvalidError
$400, OffsetInvalidError
$400, PeerIdInvalidError
*/
upload.getFile#be5335be flags:# precise:flags.0?true cdn_supported:flags.1?true location:InputFileLocation offset:long limit:int = upload.File;

/*
Saves a part of a large file (over 10 MB in size) to be later passed to one of the methods.

**Bots can use this method**

@file_id Random file id, created by the client
@file_part Part sequence number
@file_total_parts Total number of parts
@bytes Binary data, part contents

$400, FilePartsInvalidError
$400, FilePartEmptyError
$400, FilePartInvalidError
$400, FilePartSizeChangedError
$400, FilePartSizeInvalidError
$400, FilePartTooBigError
$400, FilePartTooSmallError
*/
upload.saveBigFilePart#de7b673d file_id:long file_part:int file_total_parts:int bytes:bytes = Bool;

/*
Returns content of a web file, by proxying the request through telegram, see the [webfile docs for more info](https://core.telegram.org/api/files#downloading-webfiles).

@location The file to download
@offset Number of bytes to be skipped
@limit Number of bytes to be returned

$400, DocumentInvalidError
$400, LocationInvalidError
*/
upload.getWebFile#24e6818d location:InputWebFileLocation offset:int limit:int = upload.WebFile;

/*
Download a [CDN](https://core.telegram.org/cdn) file.

@file_token File token
@offset Offset of chunk to download
@limit Length of chunk to download

$400, FileTokenInvalidError
*/
upload.getCdnFile#395f69da file_token:bytes offset:long limit:int = upload.CdnFile;

/*
Request a reupload of a certain file to a [CDN DC](https://core.telegram.org/cdn).

**Bots can use this method**

@file_token File token
@request_token Request token

$400, CdnMethodInvalidError
$500, CdnUploadTimeoutError
$400, FileTokenInvalidError
$400, LocationInvalidError
$400, RequestTokenInvalidError
$400, RsaDecryptFailedError
*/
upload.reuploadCdnFile#9b2754a8 file_token:bytes request_token:bytes = Vector<FileHash>;

/*
Get SHA256 hashes for verifying downloaded [CDN](https://core.telegram.org/cdn) files

**Bots can use this method**

@file_token File
@offset Offset from which to start getting hashes

$400, CdnMethodInvalidError
$400, FileTokenInvalidError
$400, RsaDecryptFailedError
*/
upload.getCdnFileHashes#91dc3f31 file_token:bytes offset:long = Vector<FileHash>;

/*
Get SHA256 hashes for verifying downloaded files

**Bots can use this method**

@location File
@offset Offset from which to get file hashes

$400, LocationInvalidError
*/
upload.getFileHashes#9156982a location:InputFileLocation offset:long = Vector<FileHash>;

/*
Returns current configuration, including data center configuration.

**Bots can use this method**
*/
help.getConfig#c4f9186b = Config;

/*
Returns info on data center nearest to the user.
*/
help.getNearestDc#1fb33026 = NearestDc;

/*
Returns information on update availability for the current application.

@source Source
*/
help.getAppUpdate#522d5a7d source:string = help.AppUpdate;

/*
Returns localized text of a text message with an invitation.
*/
help.getInviteText#4d392343 = help.InviteText;

/*
Returns the support user for the "ask a question" feature.
*/
help.getSupport#9cdf08cd = help.Support;

/*
Informs the server about the number of pending bot updates if they haven't been processed for a long time **for bots only**

@pending_updates_count Number of pending updates
@message Error message, if present

$400, UserBotRequiredError
*/
help.setBotUpdatesStatus#ec22cfcd pending_updates_count:int message:string = Bool;

/*
Get configuration for [CDN](https://core.telegram.org/cdn) file downloads.

**Bots can use this method**
*/
help.getCdnConfig#52029342 = CdnConfig;

/*
Get recently used t.me links.

@referer Referrer
*/
help.getRecentMeUrls#3dc0f114 referer:string = help.RecentMeUrls;

/*
Look for updates of telegram's terms of service
*/
help.getTermsOfServiceUpdate#2ca51fd1 = help.TermsOfServiceUpdate;

/*
Accept the new terms of service

@id ID of terms of service

$400, DataJsonInvalidError
*/
help.acceptTermsOfService#ee72f79a id:DataJSON = Bool;

/*
Get info about an unsupported deep link, see [here for more info](https://core.telegram.org/api/links#unsupported-links).

@path Path component of a tg: link
*/
help.getDeepLinkInfo#3fedc75f path:string = help.DeepLinkInfo;

/*
Get app-specific configuration, see [client configuration](https://core.telegram.org/api/config#client-configuration) for more info on the result.

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
help.getAppConfig#61e3f854 hash:int = help.AppConfig;

/*
Saves logs of application on the server.

@events List of input events
*/
help.saveAppLog#6f02f748 events:Vector<InputAppEvent> = Bool;

/*
Get [passport](https://core.telegram.org/passport) configuration

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
help.getPassportConfig#c661ad08 hash:int = help.PassportConfig;

/*
Get localized name of the telegram support user
*/
help.getSupportName#d360e72c = help.SupportName;

/*
Can only be used by TSF members to obtain internal information.

@user_id User ID

$403, UserInvalidError
*/
help.getUserInfo#38a08d3 user_id:InputUser = help.UserInfo;

/*
Internal use

@user_id User
@message Message
@entities [Message entities for styled text](https://core.telegram.org/api/entities)

$400, EntityBoundsInvalidError
$403, UserInvalidError
*/
help.editUserInfo#66b91b70 user_id:InputUser message:string entities:Vector<MessageEntity> = help.UserInfo;

/*
Get MTProxy/Public Service Announcement information
*/
help.getPromoData#c0977421 = help.PromoData;

/*
Hide MTProxy/Public Service Announcement information

@peer Peer to hide
*/
help.hidePromoData#1e251c95 peer:InputPeer = Bool;

/*
Dismiss a [suggestion, see here for more info](https://core.telegram.org/api/config#suggestions).

@peer In the case of pending suggestions in [channels](https://core.telegram.org/constructor/channelFull), the channel ID.
@suggestion [Suggestion, see here for more info](https://core.telegram.org/api/config#suggestions).
*/
help.dismissSuggestion#f50dbaa1 peer:InputPeer suggestion:string = Bool;

/*
Get name, ISO code, localized name and phone codes/patterns of all available countries

@lang_code Language code of the current user
@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
help.getCountriesList#735787a8 lang_code:string hash:int = help.CountriesList;

/*
Get Telegram Premium promotion information
*/
help.getPremiumPromo#b81b93d4 = help.PremiumPromo;

/*
Get the set of [accent color palettes](https://core.telegram.org/api/colors) that can be used for message accents.

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
help.getPeerColors#da80f42f hash:int = help.PeerColors;

/*
Get the set of [accent color palettes](https://core.telegram.org/api/colors) that can be used in profile page backgrounds.

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
help.getPeerProfileColors#abcfa9fd hash:int = help.PeerColors;

/*
Returns timezone information that may be used elsewhere in the API, such as to set [Telegram Business opening hours](https://core.telegram.org/api/business#opening-hours).

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation).
*/
help.getTimezonesList#49b30240 hash:int = help.TimezonesList;

/*
Mark [channel/supergroup](https://core.telegram.org/api/channel) history as read

@channel [Channel/supergroup](https://core.telegram.org/api/channel)
@max_id ID of message up to which messages should be marked as read

$400, ChannelInvalidError
$406, ChannelPrivateError
$400, MsgIdInvalidError
*/
channels.readHistory#cc104937 channel:InputChannel max_id:int = Bool;

/*
Delete messages in a [channel/supergroup](https://core.telegram.org/api/channel)

**Bots can use this method**

@channel [Channel/supergroup](https://core.telegram.org/api/channel)
@id IDs of messages to delete

$400, ChannelInvalidError
$406, ChannelPrivateError
$403, MessageDeleteForbiddenError
$400, MsgIdInvalidError
*/
channels.deleteMessages#84c1fd4e channel:InputChannel id:Vector<int> = messages.AffectedMessages;

/*
Reports some messages from a user in a supergroup as spam; requires administrator rights in the supergroup

@channel Supergroup
@participant Participant whose messages should be reported
@id IDs of spam messages

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, UserIdInvalidError
*/
channels.reportSpam#f44a8315 channel:InputChannel participant:InputPeer id:Vector<int> = Bool;

/*
Get [channel/supergroup](https://core.telegram.org/api/channel) messages

**Bots can use this method**

@channel Channel/supergroup
@id IDs of messages to get

$400, ChannelInvalidError
$406, ChannelPrivateError
$400, MessageIdsEmptyError
$400, MsgIdInvalidError
$400, UserBannedInChannelError
*/
channels.getMessages#ad8c9a23 channel:InputChannel id:Vector<InputMessage> = messages.Messages;

/*
Get the participants of a [supergroup/channel](https://core.telegram.org/api/channel)

**Bots can use this method**

@channel Channel
@filter Which participant types to fetch
@offset [Offset](https://core.telegram.org/api/offsets)
@limit [Limit](https://core.telegram.org/api/offsets)
@hash [Hash](https://core.telegram.org/api/offsets)

$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChatAdminRequiredError
$400, MsgIdInvalidError
*/
channels.getParticipants#77ced9d0 channel:InputChannel filter:ChannelParticipantsFilter offset:int limit:int hash:long = channels.ChannelParticipants;

/*
Get info about a [channel/supergroup](https://core.telegram.org/api/channel) participant

**Bots can use this method**

@channel Channel/supergroup
@participant Participant to get info about

$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChatAdminRequiredError
$400, MsgIdInvalidError
$400, ParticipantIdInvalidError
$400, UserIdInvalidError
$400, UserNotParticipantError
*/
channels.getParticipant#a0ab6cc6 channel:InputChannel participant:InputPeer = channels.ChannelParticipant;

/*
Get info about [channels/supergroups](https://core.telegram.org/api/channel)

**Bots can use this method**

@id IDs of channels/supergroups to get info about

$400, ChannelInvalidError
$406, ChannelPrivateError
$400, MsgIdInvalidError
$400, UserBannedInChannelError
*/
channels.getChannels#a7f6bbb id:Vector<InputChannel> = messages.Chats;

/*
Get full info about a [supergroup](https://core.telegram.org/api/channel#supergroups), [gigagroup](https://core.telegram.org/api/channel#gigagroups) or [channel](https://core.telegram.org/api/channel#channels)

**Bots can use this method**

@channel The [channel](https://core.telegram.org/api/channel#channels), [supergroup](https://core.telegram.org/api/channel#supergroups) or [gigagroup](https://core.telegram.org/api/channel#gigagroups) to get info about

$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChannelPublicGroupNaError
$400, ChatNotModifiedError
$400, MsgIdInvalidError
*/
channels.getFullChannel#8736a09 channel:InputChannel = messages.ChatFull;

/*
Create a [supergroup/channel](https://core.telegram.org/api/channel).

@broadcast Whether to create a [channel](https://core.telegram.org/api/channel)
@megagroup Whether to create a [supergroup](https://core.telegram.org/api/channel)
@for_import Whether the supergroup is being created to import messages from a foreign chat service using [messages.initHistoryImport](https://core.telegram.org/method/messages.initHistoryImport)
@forum Whether to create a [forum](https://core.telegram.org/api/forum)
@title Channel title
@about Channel description
@geo_point Geogroup location, see [here](https://core.telegram.org/api/nearby) for more info on geogroups.
@address Geogroup address, see [here](https://core.telegram.org/api/nearby) for more info on geogroups.
@ttl_period Time-to-live of all messages that will be sent in the supergroup: once message.date+message.ttl_period === time(), the message will be deleted on the server, and must be deleted locally as well. You can use [messages.setDefaultHistoryTTL](https://core.telegram.org/method/messages.setDefaultHistoryTTL) to edit this value later.

$400, AddressInvalidError
$400, ChannelsAdminLocatedTooMuchError
$400, ChannelsTooMuchError
$400, ChatAboutTooLongError
$500, ChatInvalidError
$400, ChatTitleEmptyError
$400, TtlPeriodInvalidError
$406, UserRestrictedError
*/
channels.createChannel#91006707 flags:# broadcast:flags.0?true megagroup:flags.1?true for_import:flags.3?true forum:flags.5?true title:string about:string geo_point:flags.2?InputGeoPoint address:flags.2?string ttl_period:flags.4?int = Updates;

/*
Modify the admin rights of a user in a [supergroup/channel](https://core.telegram.org/api/channel).

**Bots can use this method**

@channel The [supergroup/channel](https://core.telegram.org/api/channel).
@user_id The ID of the user whose admin rights should be modified
@admin_rights The admin rights
@rank Indicates the role (rank) of the admin in the group: just an arbitrary string

$400, AdminsTooMuchError
$400, AdminRankEmojiNotAllowedError
$400, AdminRankInvalidError
$400, BotsTooMuchError
$400, BotChannelsNaError
$400, BotGroupsBlockedError
$400, ChannelInvalidError
$400, ChannelPrivateError
$403, ChatAdminInviteRequiredError
$403, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$406, FreshChangeAdminsForbiddenError
$400, InputUserDeactivatedError
$400, PeerIdInvalidError
$403, RightForbiddenError
$400, UsersTooMuchError
$400, UserBlockedError
$403, UserChannelsTooMuchError
$400, UserCreatorError
$400, UserIdInvalidError
$403, UserNotMutualContactError
$403, UserPrivacyRestrictedError
$403, UserRestrictedError
*/
channels.editAdmin#d33c8902 channel:InputChannel user_id:InputUser admin_rights:ChatAdminRights rank:string = Updates;

/*
Edit the name of a [channel/supergroup](https://core.telegram.org/api/channel)

**Bots can use this method**

@channel Channel/supergroup
@title New name

$400, ChannelInvalidError
$400, ChannelPrivateError
$403, ChatAdminRequiredError
$400, ChatNotModifiedError
$400, ChatTitleEmptyError
$403, ChatWriteForbiddenError
*/
channels.editTitle#566decd0 channel:InputChannel title:string = Updates;

/*
Change the photo of a [channel/supergroup](https://core.telegram.org/api/channel)

**Bots can use this method**

@channel Channel/supergroup whose photo should be edited
@photo New photo

$400, ChannelInvalidError
$400, ChannelPrivateError
$403, ChatAdminRequiredError
$400, ChatNotModifiedError
$403, ChatWriteForbiddenError
$400, FilePartsInvalidError
$400, FileReferenceInvalidError
$400, ImageProcessFailedError
$400, PhotoCropSizeSmallError
$400, PhotoExtInvalidError
$400, PhotoFileMissingError
$400, PhotoInvalidError
$400, StickerMimeInvalidError
*/
channels.editPhoto#f12e57c9 channel:InputChannel photo:InputChatPhoto = Updates;

/*
Check if a username is free and can be assigned to a channel/supergroup

@channel The [channel/supergroup](https://core.telegram.org/api/channel) that will assigned the specified username
@username The username to check

$400, ChannelsAdminPublicTooMuchError
$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatIdInvalidError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, UsernameInvalidError
$400, UsernameOccupiedError
$400, UsernamePurchaseAvailableError
*/
channels.checkUsername#10e6bd2c channel:InputChannel username:string = Bool;

/*
Change or remove the username of a supergroup/channel

@channel Channel
@username New username, pass an empty string to remove the username

$400, ChannelsAdminPublicTooMuchError
$400, ChannelInvalidError
$400, ChannelPrivateError
$403, ChatAdminRequiredError
$400, ChatNotModifiedError
$403, ChatWriteForbiddenError
$400, UsernameInvalidError
$400, UsernameNotModifiedError
$400, UsernameOccupiedError
$400, UsernamePurchaseAvailableError
*/
channels.updateUsername#3514b3de channel:InputChannel username:string = Bool;

/*
Join a channel/supergroup

@channel Channel/supergroup to join

$400, ChannelsTooMuchError
$400, ChannelInvalidError
$406, ChannelPrivateError
$400, ChatInvalidError
$400, InviteHashEmptyError
$406, InviteHashExpiredError
$400, InviteHashInvalidError
$400, InviteRequestSentError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
$400, UsersTooMuchError
$400, UserAlreadyParticipantError
$400, UserChannelsTooMuchError
*/
channels.joinChannel#24b524c5 channel:InputChannel = Updates;

/*
Leave a [channel/supergroup](https://core.telegram.org/api/channel)

**Bots can use this method**

@channel [Channel/supergroup](https://core.telegram.org/api/channel) to leave

$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChannelPublicGroupNaError
$400, ChatInvalidError
$400, MsgIdInvalidError
$400, UserBannedInChannelError
$400, UserCreatorError
$400, UserNotParticipantError
*/
channels.leaveChannel#f836aa95 channel:InputChannel = Updates;

/*
Invite users to a channel/supergroup

@channel Channel/supergroup
@users Users to invite

$400, BotsTooMuchError
$400, BotGroupsBlockedError
$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChatAdminRequiredError
$400, ChatInvalidError
$400, ChatMemberAddFailedError
$403, ChatWriteForbiddenError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, UsersTooMuchError
$400, UserBannedInChannelError
$400, UserBlockedError
$400, UserBotError
$403, UserChannelsTooMuchError
$400, UserIdInvalidError
$400, UserKickedError
$403, UserNotMutualContactError
$403, UserPrivacyRestrictedError
*/
channels.inviteToChannel#c9e33d54 channel:InputChannel users:Vector<InputUser> = messages.InvitedUsers;

/*
Delete a [channel/supergroup](https://core.telegram.org/api/channel)

@channel [Channel/supergroup](https://core.telegram.org/api/channel) to delete

$400, ChannelInvalidError
$406, ChannelPrivateError
$406, ChannelTooLargeError
$400, ChatAdminRequiredError
$400, ChatNotModifiedError
$403, ChatWriteForbiddenError
*/
channels.deleteChannel#c0111fe3 channel:InputChannel = Updates;

/*
Get link and embed info of a message in a [channel/supergroup](https://core.telegram.org/api/channel)

@grouped Whether to include other grouped media (for albums)
@thread Whether to also include a thread ID, if available, inside of the link
@channel Channel
@id Message ID

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MessageIdInvalidError
$400, MsgIdInvalidError
*/
channels.exportMessageLink#e63fadeb flags:# grouped:flags.0?true thread:flags.1?true channel:InputChannel id:int = ExportedMessageLink;

/*
Enable/disable message signatures in channels

@signatures_enabled If set, enables message signatures.
@profiles_enabled If set, messages from channel admins will link to their profiles, just like for group messages: can only be set if the signatures_enabled flag is set.
@channel Channel

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatNotModifiedError
*/
channels.toggleSignatures#418d549c flags:# signatures_enabled:flags.0?true profiles_enabled:flags.1?true channel:InputChannel = Updates;

/*
Get [channels/supergroups/geogroups](https://core.telegram.org/api/channel) we're admin in. Usually called when the user exceeds the [limit](https://core.telegram.org/constructor/config) for owned public [channels/supergroups/geogroups](https://core.telegram.org/api/channel), and the user is given the choice to remove one of his channels/supergroups/geogroups.

@by_location Get geogroups
@check_limit If set and the user has reached the limit of owned public [channels/supergroups/geogroups](https://core.telegram.org/api/channel), instead of returning the channel list one of the specified [errors](https://core.telegram.org#possible-errors) will be returned. Useful to check if a new public channel can indeed be created, even before asking the user to enter a channel username to use in [channels.checkUsername](https://core.telegram.org/method/channels.checkUsername)/ [channels.updateUsername](https://core.telegram.org/method/channels.updateUsername).
@for_personal Set this flag to only fetch the full list of channels that may be passed to [account.updatePersonalChannel](https://core.telegram.org/method/account.updatePersonalChannel) to [display them on our profile page](https://core.telegram.org/api/profile#personal-channel).

$400, ChannelsAdminLocatedTooMuchError
$400, ChannelsAdminPublicTooMuchError
*/
channels.getAdminedPublicChannels#f8b036af flags:# by_location:flags.0?true check_limit:flags.1?true for_personal:flags.2?true = messages.Chats;

/*
Ban/unban/kick a user in a [supergroup/channel](https://core.telegram.org/api/channel).

**Bots can use this method**

@channel The [supergroup/channel](https://core.telegram.org/api/channel).
@participant Participant to ban
@banned_rights The banned rights

$406, BannedRightsInvalidError
$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, InputUserDeactivatedError
$400, MsgIdInvalidError
$400, ParticipantIdInvalidError
$400, PeerIdInvalidError
$400, UserAdminInvalidError
$400, UserIdInvalidError
*/
channels.editBanned#96e6cd81 channel:InputChannel participant:InputPeer banned_rights:ChatBannedRights = Updates;

/*
Get the admin log of a [channel/supergroup](https://core.telegram.org/api/channel)

@channel Channel
@q Search query, can be empty
@events_filter Event filter
@admins Only show events from these admins
@max_id Maximum ID of message to return (see [pagination](https://core.telegram.org/api/offsets))
@min_id Minimum ID of message to return (see [pagination](https://core.telegram.org/api/offsets))
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, ChannelInvalidError
$406, ChannelPrivateError
$403, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, MsgIdInvalidError
*/
channels.getAdminLog#33ddf480 flags:# channel:InputChannel q:string events_filter:flags.0?ChannelAdminLogEventsFilter admins:flags.1?Vector<InputUser> max_id:long min_id:long limit:int = channels.AdminLogResults;

/*
Associate a stickerset to the supergroup

**Bots can use this method**

@channel Supergroup
@stickerset The stickerset to associate

$400, ChannelInvalidError
$400, ChatIdInvalidError
$400, ParticipantsTooFewError
$406, StickersetOwnerAnonymousError
*/
channels.setStickers#ea8ca4f9 channel:InputChannel stickerset:InputStickerSet = Bool;

/*
Mark [channel/supergroup](https://core.telegram.org/api/channel) message contents as read

@channel [Channel/supergroup](https://core.telegram.org/api/channel)
@id IDs of messages whose contents should be marked as read

$400, ChannelInvalidError
$406, ChannelPrivateError
$400, MsgIdInvalidError
*/
channels.readMessageContents#eab5dc38 channel:InputChannel id:Vector<int> = Bool;

/*
Delete the history of a [supergroup](https://core.telegram.org/api/channel)

@for_everyone Whether the history should be deleted for everyone
@channel [Supergroup](https://core.telegram.org/api/channel) whose history must be deleted
@max_id ID of message up to which the history must be deleted

$400, ChannelInvalidError
$400, ChannelParicipantMissingError
$400, ChannelPrivateError
$400, ChannelTooBigError
$400, ChatAdminRequiredError
*/
channels.deleteHistory#9baa9647 flags:# for_everyone:flags.0?true channel:InputChannel max_id:int = Updates;

/*
Hide/unhide message history for new channel/supergroup users

@channel Channel/supergroup
@enabled Hide/unhide

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatLinkExistsError
$400, ChatNotModifiedError
$400, ForumEnabledError
*/
channels.togglePreHistoryHidden#eabbb94c channel:InputChannel enabled:Bool = Updates;

/*
Get a list of [channels/supergroups](https://core.telegram.org/api/channel) we left, requires a [takeout session, see here  for more info](https://core.telegram.org/api/takeout).

@offset Offset for [pagination](https://core.telegram.org/api/offsets)

$403, TakeoutRequiredError
*/
channels.getLeftChannels#8341ecc0 offset:int = messages.Chats;

/*
Get all groups that can be used as [discussion groups](https://core.telegram.org/api/discussion).
*/
channels.getGroupsForDiscussion#f5dad378 = messages.Chats;

/*
Associate a group to a channel as [discussion group](https://core.telegram.org/api/discussion) for that channel

@broadcast Channel
@group [Discussion group](https://core.telegram.org/api/discussion) to associate to the channel

$400, BroadcastIdInvalidError
$400, ChannelInvalidError
$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, LinkNotModifiedError
$400, MegagroupIdInvalidError
$400, MegagroupPrehistoryHiddenError
*/
channels.setDiscussionGroup#40582bb2 broadcast:InputChannel group:InputChannel = Bool;

/*
Transfer channel ownership

@channel Channel
@user_id New channel owner
@password [2FA password](https://core.telegram.org/api/srp) of account

$400, ChannelsAdminPublicTooMuchError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatNotModifiedError
$403, ChatWriteForbiddenError
$400, PasswordHashInvalidError
$400, PasswordMissingError
$400, PasswordTooFreshError
$400, SessionTooFreshError
$400, SrpIdInvalidError
$400, UserIdInvalidError
*/
channels.editCreator#8f38cd1f channel:InputChannel user_id:InputUser password:InputCheckPasswordSRP = Updates;

/*
Edit location of geogroup, see [here](https://core.telegram.org/api/nearby) for more info on geogroups.

@channel [Geogroup](https://core.telegram.org/api/channel)
@geo_point New geolocation
@address Address string

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, ChatNotModifiedError
$400, MegagroupGeoRequiredError
$400, MegagroupRequiredError
*/
channels.editLocation#58e63f6d channel:InputChannel geo_point:InputGeoPoint address:string = Bool;

/*
Toggle supergroup slow mode: if enabled, users will only be able to send one message every seconds seconds

@channel The [supergroup](https://core.telegram.org/api/channel)
@seconds Users will only be able to send one message every seconds seconds, 0 to disable the limitation

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatNotModifiedError
$400, SecondsInvalidError
*/
channels.toggleSlowMode#edd49ef0 channel:InputChannel seconds:int = Updates;

/*
Get inactive channels and supergroups
*/
channels.getInactiveChannels#11e831ee = messages.InactiveChats;

/*
Convert a [supergroup](https://core.telegram.org/api/channel) to a [gigagroup](https://core.telegram.org/api/channel), when requested by [channel suggestions](https://core.telegram.org/api/config#channel-suggestions).

@channel The [supergroup](https://core.telegram.org/api/channel) to convert

$400, ChannelIdInvalidError
$400, ChannelInvalidError
$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, ForumEnabledError
$400, ParticipantsTooFewError
*/
channels.convertToGigagroup#b290c69 channel:InputChannel = Updates;

/*
Obtains a list of peers that can be used to send messages in a specific group

@for_paid_reactions  ... 
@peer The group where we intend to send messages

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatIdInvalidError
$400, PeerIdInvalidError

#DocError
*/
channels.getSendAs#e785a43f flags:# for_paid_reactions:flags.0?true peer:InputPeer = channels.SendAsPeers;

/*
Delete all messages sent by a specific participant of a given supergroup

@channel Supergroup
@participant The participant whose messages should be deleted

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$403, ChatWriteForbiddenError
$400, MsgIdInvalidError
$400, ParticipantIdInvalidError
*/
channels.deleteParticipantHistory#367544db channel:InputChannel participant:InputPeer = messages.AffectedHistory;

/*
Set whether all users [should join a discussion group in order to comment on a post](https://core.telegram.org/api/discussion#requiring-users-to-join-the-group)

@channel Discussion group
@enabled Toggle

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatNotModifiedError
*/
channels.toggleJoinToSend#e4cb9580 channel:InputChannel enabled:Bool = Updates;

/*
Set whether all users should [request admin approval to join the group](https://core.telegram.org/api/invites#join-requests).

@channel Group
@enabled Toggle

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatNotModifiedError
$400, ChatPublicRequiredError
*/
channels.toggleJoinRequest#4c2985b6 channel:InputChannel enabled:Bool = Updates;

/*
Reorder active usernames

@channel The supergroup or channel
@order The new order for active usernames. All active usernames must be specified.

$400, ChannelInvalidError
$400, ChatNotModifiedError
*/
channels.reorderUsernames#b45ced1d channel:InputChannel order:Vector<string> = Bool;

/*
Activate or deactivate a purchased [fragment.com](https://fragment.com) username associated to a [supergroup or channel](https://core.telegram.org/api/channel) we own.

@channel [Supergroup or channel](https://core.telegram.org/api/channel)
@username Username
@active Whether to activate or deactivate the username

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, ChatNotModifiedError
$400, UsernamesActiveTooMuchError
$400, UsernameInvalidError
$400, UsernameNotModifiedError
*/
channels.toggleUsername#50f24105 channel:InputChannel username:string active:Bool = Bool;

/*
Disable all purchased usernames of a supergroup or channel

@channel Supergroup or channel

$400, ChannelInvalidError
*/
channels.deactivateAllUsernames#a245dd3 channel:InputChannel = Bool;

/*
Enable or disable [forum functionality](https://core.telegram.org/api/forum) in a supergroup.

@channel Supergroup ID
@enabled Enable or disable forum functionality

$400, ChannelInvalidError
$400, ChatDiscussionUnallowedError
$400, ChatNotModifiedError
*/
channels.toggleForum#a4298b29 channel:InputChannel enabled:Bool = Updates;

/*
Create a [forum topic](https://core.telegram.org/api/forum); requires [manage_topics rights](https://core.telegram.org/api/rights).

**Bots can use this method**

@channel [The forum](https://core.telegram.org/api/forum)
@title Topic title (maximum UTF-8 length: 128)
@icon_color If no custom emoji icon is specified, specifies the color of the fallback topic icon (RGB), one of 0x6FB9F0, 0xFFD67E, 0xCB86DB, 0x8EEE98, 0xFF93B2, or 0xFB6F5F.
@icon_emoji_id ID of the [custom emoji](https://core.telegram.org/api/custom-emoji) used as topic icon. [Telegram Premium](https://core.telegram.org/api/premium) users can use any custom emoji, other users can only use the custom emojis contained in the [inputStickerSetEmojiDefaultTopicIcons](https://core.telegram.org/constructor/inputStickerSetEmojiDefaultTopicIcons) emoji pack.
@random_id Unique client message ID to prevent duplicate sending of the same event
@send_as Create the topic as the specified peer

$400, ChannelForumMissingError
$400, ChannelInvalidError
$403, ChatWriteForbiddenError
$403, PremiumAccountRequiredError
$400, TopicTitleEmptyError
*/
channels.createForumTopic#f40c0224 flags:# channel:InputChannel title:string icon_color:flags.0?int icon_emoji_id:flags.3?long random_id:long send_as:flags.2?InputPeer = Updates;

/*
Get [topics of a forum](https://core.telegram.org/api/forum)

@channel Supergroup
@q Search query
@offset_date [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets), date of the last message of the last found topic. Use 0 or any date in the future to get results from the last topic.
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets), ID of the last message of the last found topic (or initially 0).
@offset_topic [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets), ID of the last found topic (or initially 0).
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets). For optimal performance, the number of returned topics is chosen by the server and can be smaller than the specified limit.

$400, ChannelForumMissingError
$400, ChannelInvalidError
$400, ChannelPrivateError
*/
channels.getForumTopics#de560d1 flags:# channel:InputChannel q:flags.0?string offset_date:int offset_id:int offset_topic:int limit:int = messages.ForumTopics;

/*
Get forum topics by their ID

@channel Forum
@topics Topic IDs

$400, ChannelForumMissingError
$400, ChannelInvalidError
$400, TopicsEmptyError
*/
channels.getForumTopicsByID#b0831eb9 channel:InputChannel topics:Vector<int> = messages.ForumTopics;

/*
Edit [forum topic](https://core.telegram.org/api/forum); requires [manage_topics rights](https://core.telegram.org/api/rights).

**Bots can use this method**

@channel Supergroup
@topic_id Topic ID
@title If present, will update the topic title (maximum UTF-8 length: 128).
@icon_emoji_id If present, updates the [custom emoji](https://core.telegram.org/api/custom-emoji) used as topic icon. [Telegram Premium](https://core.telegram.org/api/premium) users can use any custom emoji, other users can only use the custom emojis contained in the [inputStickerSetEmojiDefaultTopicIcons](https://core.telegram.org/constructor/inputStickerSetEmojiDefaultTopicIcons) emoji pack. Pass 0 to switch to the fallback topic icon.
@closed If present, will update the open/closed status of the topic.
@hidden If present, will hide/unhide the topic (only valid for the "General" topic, id=1).

$400, ChannelForumMissingError
$400, ChannelInvalidError
$403, ChatAdminRequiredError
$400, DocumentInvalidError
$400, GeneralModifyIconForbiddenError
$400, TopicCloseSeparatelyError
$400, TopicHideSeparatelyError
$400, TopicIdInvalidError
$400, TopicNotModifiedError
*/
channels.editForumTopic#f4dfa185 flags:# channel:InputChannel topic_id:int title:flags.0?string icon_emoji_id:flags.1?long closed:flags.2?Bool hidden:flags.3?Bool = Updates;

/*
Pin or unpin [forum topics](https://core.telegram.org/api/forum)

@channel Supergroup ID
@topic_id [Forum topic ID](https://core.telegram.org/api/forum)
@pinned Whether to pin or unpin the topic

$400, ChannelInvalidError
$400, TopicIdInvalidError
*/
channels.updatePinnedForumTopic#6c2d9026 channel:InputChannel topic_id:int pinned:Bool = Updates;

/*
Delete message history of a [forum topic](https://core.telegram.org/api/forum)

**Bots can use this method**

@channel Forum
@top_msg_id Topic ID

$400, ChannelForumMissingError
$400, ChannelInvalidError
$400, TopicIdInvalidError
*/
channels.deleteTopicHistory#34435f2d channel:InputChannel top_msg_id:int = messages.AffectedHistory;

/*
Reorder pinned forum topics

@force If not set, the order of only the topics present both server-side and in order will be changed (i.e. mentioning topics not pinned server-side in order will not pin them, and not mentioning topics pinned server-side will not unpin them).  If set, the entire server-side pinned topic list will be replaced with order (i.e. mentioning topics not pinned server-side in order will pin them, and not mentioning topics pinned server-side will unpin them)
@channel Supergroup ID
@order [Topic IDs](https://core.telegram.org/api/forum)

$400, ChannelInvalidError
*/
channels.reorderPinnedForumTopics#2950a18f flags:# force:flags.0?true channel:InputChannel order:Vector<int> = Updates;

/*
Enable or disable the [native antispam system](https://core.telegram.org/api/antispam).

@channel Supergroup ID. The specified supergroup must have at least telegram_antispam_group_size_min members to enable antispam functionality, as specified by the [client configuration parameters](https://core.telegram.org/api/config#client-configuration).
@enabled Enable or disable the native antispam system.

$400, ChannelInvalidError
$400, ChatNotModifiedError
*/
channels.toggleAntiSpam#68f3e4eb channel:InputChannel enabled:Bool = Updates;

/*
Report a [native antispam](https://core.telegram.org/api/antispam) false positive

@channel Supergroup ID
@msg_id Message ID that was mistakenly deleted by the [native antispam](https://core.telegram.org/api/antispam) system, taken from the [admin log](https://core.telegram.org/api/recent-actions)

$400, ChannelInvalidError
*/
channels.reportAntiSpamFalsePositive#a850a693 channel:InputChannel msg_id:int = Bool;

/*
Hide or display the participants list in a [supergroup](https://core.telegram.org/api/channel).

@channel Supergroup ID
@enabled If true, will hide the participants list; otherwise will unhide it.

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, ChatIdInvalidError
$400, ChatNotModifiedError
$400, ParticipantsTooFewError
*/
channels.toggleParticipantsHidden#6a6e7854 channel:InputChannel enabled:Bool = Updates;

/*
Update the [accent color and background custom emoji](https://core.telegram.org/api/colors) of a channel.

@for_profile Whether to change the accent color emoji pattern of the profile page; otherwise, the accent color and emoji pattern of messages will be changed. Channels can change both message and profile palettes; supergroups can only change the profile palette, of course after reaching the [appropriate boost level](https://core.telegram.org/api/colors).
@channel Channel whose accent color should be changed.
@color [ID of the accent color palette](https://core.telegram.org/api/colors) to use (not RGB24, see [here](https://core.telegram.org/api/colors) for more info); if not set, the default palette is used.
@background_emoji_id Custom emoji ID used in the accent color pattern.

$400, BoostsRequiredError
$400, ChannelInvalidError
*/
channels.updateColor#d8aa3671 flags:# for_profile:flags.1?true channel:InputChannel color:flags.2?int background_emoji_id:flags.0?long = Updates;

/*
Users may also choose to display messages from all topics of a [forum](https://core.telegram.org/api/forum) as if they were sent to a normal group, using a "View as messages" setting in the local client: this setting only affects the current account, and is synced to other logged in sessions using this method.

@channel The forum
@enabled The new value of the view_forum_as_messages flag.

$400, ChannelInvalidError
*/
channels.toggleViewForumAsMessages#9738bb15 channel:InputChannel enabled:Bool = Updates;

/*
Obtain a list of similarly themed public channels, selected based on similarities in their subscriber bases.

@channel The method will return channels related to the passed channel. If not set, the method will returns channels related to channels the user has joined.

$400, ChannelInvalidError
$400, ChannelPrivateError
*/
channels.getChannelRecommendations#25a71742 flags:# channel:flags.0?InputChannel = messages.Chats;

/*
Set an [emoji status](https://core.telegram.org/api/emoji-status) for a channel or supergroup.

@channel The channel/supergroup, must have at least [channel_emoji_status_level_min](https://core.telegram.org/api/config#channel-emoji-status-level-min)/ [group_emoji_status_level_min](https://core.telegram.org/api/config#group-emoji-status-level-min) boosts.
@emoji_status [Emoji status](https://core.telegram.org/api/emoji-status) to set

$400, ChannelInvalidError
*/
channels.updateEmojiStatus#f0d3e6a8 channel:InputChannel emoji_status:EmojiStatus = Updates;

/*
Admins with [ban_users admin rights](https://core.telegram.org/constructor/chatAdminRights) may allow users that apply a certain number of [booosts](https://core.telegram.org/api/boost) to the group to bypass [slow mode](https://core.telegram.org/method/channels.toggleSlowMode) and [other](https://core.telegram.org/api/rights#default-rights) supergroup restrictions, see [here](https://core.telegram.org/api/boost#bypass-slowmode-and-chat-restrictions) for more info.

@channel The supergroup.
@boosts The number of required boosts (1-8, 0 to disable).

$400, ChannelInvalidError
*/
channels.setBoostsToUnblockRestrictions#ad399cee channel:InputChannel boosts:int = Updates;

/*
Set a [custom emoji stickerset](https://core.telegram.org/api/custom-emoji) for supergroups. Only usable after reaching at least the [boost level](https://core.telegram.org/api/boost) specified in the [group_emoji_stickers_level_min](https://core.telegram.org/api/config#group-emoji-stickers-level-min) config parameter.

@channel The supergroup
@stickerset The custom emoji stickerset to associate to the supergroup

$400, ChannelInvalidError
*/
channels.setEmojiStickers#3cd930b7 channel:InputChannel stickerset:InputStickerSet = Bool;

/*
Disable ads on the specified channel, for all users.

@channel The channel.
@restricted Whether to disable or re-enable ads.

$400, ChannelInvalidError
*/
channels.restrictSponsoredMessages#9ae91519 channel:InputChannel restricted:Bool = Updates;

/*
Globally search for posts from public [channels](https://core.telegram.org/api/channel) ( including those we aren't a member of) containing a specific hashtag.

@hashtag The hashtag to search, without the # character.
@offset_rate Initially 0, then set to the [next_rate parameter of messages.messagesSlice](https://core.telegram.org/constructor/messages.messagesSlice)
@offset_peer [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
*/
channels.searchPosts#d19f987b hashtag:string offset_rate:int offset_peer:InputPeer offset_id:int limit:int = messages.Messages;

/*
Sends a custom request **for bots only**

@custom_method The method name
@params JSON-serialized method parameters

$400, DataJsonInvalidError
$400, MethodInvalidError
$403, UserBotInvalidError
$400, UserBotRequiredError
*/
bots.sendCustomRequest#aa2769ed custom_method:string params:DataJSON = DataJSON;

/*
Answers a custom query **for bots only**

@query_id Identifier of a custom query
@data JSON-serialized answer to the query

$400, DataJsonInvalidError
$400, QueryIdInvalidError
$403, UserBotInvalidError
$400, UserBotRequiredError
*/
bots.answerWebhookJSONQuery#e6213f4d query_id:long data:DataJSON = Bool;

/*
Set bot command list

**Bots can use this method**

@scope Command scope
@lang_code Language code
@commands Bot commands

$400, BotCommandDescriptionInvalidError
$400, BotCommandInvalidError
$400, LangCodeInvalidError
$400, PeerIdInvalidError
$400, UserBotRequiredError
$400, UserIdInvalidError
*/
bots.setBotCommands#517165a scope:BotCommandScope lang_code:string commands:Vector<BotCommand> = Bool;

/*
Clear bot commands for the specified bot scope and language code

**Bots can use this method**

@scope Command scope
@lang_code Language code

$400, LangCodeInvalidError
$400, UserBotRequiredError
*/
bots.resetBotCommands#3d8de0f9 scope:BotCommandScope lang_code:string = Bool;

/*
Obtain a list of bot commands for the specified bot scope and language code

**Bots can use this method**

@scope Command scope
@lang_code Language code

$400, UserBotInvalidError
$400, UserBotRequiredError
*/
bots.getBotCommands#e34c0dd6 scope:BotCommandScope lang_code:string = Vector<BotCommand>;

/*
Sets the [menu button action](https://core.telegram.org/api/bots/menu) for a given user or for all users

**Bots can use this method**

@user_id User ID
@button Bot menu button action

$400, ButtonTextInvalidError
$400, ButtonUrlInvalidError
$400, UserBotRequiredError
*/
bots.setBotMenuButton#4504d54f user_id:InputUser button:BotMenuButton = Bool;

/*
Gets the menu button action for a given user or for all users, previously set using [bots.setBotMenuButton](https://core.telegram.org/method/bots.setBotMenuButton); users can see this information in the [botInfo](https://core.telegram.org/constructor/botInfo) constructor.

**Bots can use this method**

@user_id User ID or empty for the default menu button.

$400, UserBotRequiredError
*/
bots.getBotMenuButton#9c60eb28 user_id:InputUser = BotMenuButton;

/*
Set the default [suggested admin rights](https://core.telegram.org/api/rights#suggested-bot-rights) for bots being added as admins to channels, see [here for more info on how to handle them](https://core.telegram.org/api/rights#suggested-bot-rights).

**Bots can use this method**

@admin_rights Admin rights

$400, RightsNotModifiedError
$400, UserBotRequiredError
*/
bots.setBotBroadcastDefaultAdminRights#788464e1 admin_rights:ChatAdminRights = Bool;

/*
Set the default [suggested admin rights](https://core.telegram.org/api/rights#suggested-bot-rights) for bots being added as admins to groups, see [here for more info on how to handle them](https://core.telegram.org/api/rights#suggested-bot-rights).

**Bots can use this method**

@admin_rights Admin rights

$400, RightsNotModifiedError
$400, UserBotRequiredError
*/
bots.setBotGroupDefaultAdminRights#925ec9ea admin_rights:ChatAdminRights = Bool;

/*
Set localized name, about text and description of a bot (or of the current account, if called by a bot).

**Bots can use this method**

@bot If called by a user, must contain the peer of a bot we own.
@lang_code Language code, if left empty update the fallback about text and description
@name New bot name
@about New about text
@description New description

$400, BotInvalidError
$400, UserBotInvalidError
*/
bots.setBotInfo#10cf3123 flags:# bot:flags.2?InputUser lang_code:string name:flags.3?string about:flags.0?string description:flags.1?string = Bool;

/*
Get localized name, about text and description of a bot (or of the current account, if called by a bot).

**Bots can use this method**

@bot If called by a user, must contain the peer of a bot we own.
@lang_code Language code, if left empty this method will return the fallback about text and description.

$400, BotInvalidError
$400, LangCodeInvalidError
$400, UserBotInvalidError
*/
bots.getBotInfo#dcd914fd flags:# bot:flags.0?InputUser lang_code:string = bots.BotInfo;

/*
Reorder usernames associated to a bot we own.

@bot The bot
@order The new order for active usernames. All active usernames must be specified.

$400, BotInvalidError
$400, UsernameNotModifiedError
*/
bots.reorderUsernames#9709b1c2 bot:InputUser order:Vector<string> = Bool;

/*
Activate or deactivate a purchased [fragment.com](https://fragment.com) username associated to a bot we own.

@bot The bot
@username Username
@active Whether to activate or deactivate it

$400, BotInvalidError
$400, UsernameNotModifiedError
*/
bots.toggleUsername#53ca973 bot:InputUser username:string active:Bool = Bool;

/*
Check whether the specified bot can send us messages

@bot The bot

$400, BotInvalidError
*/
bots.canSendMessage#1359f4e6 bot:InputUser = Bool;

/*
Allow the specified bot to send us messages

@bot The bot

$400, BotInvalidError
*/
bots.allowSendMessage#f132e3ef bot:InputUser = Updates;

/*
Send a custom request from a [mini bot app](https://core.telegram.org/api/bots/webapps), triggered by a [web_app_invoke_custom_method event](https://core.telegram.org/api/web-events#web-app-invoke-custom-method).

@bot Identifier of the bot associated to the [mini bot app](https://core.telegram.org/api/bots/webapps)
@custom_method Identifier of the custom method to invoke
@params Method parameters

$400, BotInvalidError
$400, DataJsonInvalidError
*/
bots.invokeWebViewCustomMethod#87fc5e7 bot:InputUser custom_method:string params:DataJSON = DataJSON;

/*
Fetch popular [Main Mini Apps](https://core.telegram.org/api/bots/webapps#main-mini-apps), to be used in the [apps tab of global search](https://core.telegram.org/api/search#apps-tab).

@offset Offset for [pagination](https://core.telegram.org/api/offsets), initially an empty string, then re-use the next_offset returned by the previous query.
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
*/
bots.getPopularAppBots#c2510192 offset:string limit:int = bots.PopularAppBots;

/*
Add a [main mini app preview, see here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews) for more info.

@bot The bot that owns the Main Mini App.
@lang_code ISO 639-1 language code, indicating the localization of the preview to add.
@media The photo/video preview, uploaded using [messages.uploadMedia](https://core.telegram.org/method/messages.uploadMedia).

$400, BotInvalidError
*/
bots.addPreviewMedia#17aeb75a bot:InputUser lang_code:string media:InputMedia = BotPreviewMedia;

/*
Edit a [main mini app preview, see here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews) for more info.

@bot The bot that owns the Main Mini App.
@lang_code ISO 639-1 language code, indicating the localization of the preview to edit.
@media The photo/video preview to replace, previously fetched as specified [here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews).
@new_media The new photo/video preview, uploaded using [messages.uploadMedia](https://core.telegram.org/method/messages.uploadMedia).

$400, BotInvalidError
*/
bots.editPreviewMedia#8525606f bot:InputUser lang_code:string media:InputMedia new_media:InputMedia = BotPreviewMedia;

/*
Delete a [main mini app preview, see here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews) for more info.

@bot The bot that owns the Main Mini App.
@lang_code ISO 639-1 language code, indicating the localization of the preview to delete.
@media The photo/video preview to delete, previously fetched as specified [here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews).

$400, BotInvalidError
*/
bots.deletePreviewMedia#2d0135b3 bot:InputUser lang_code:string media:Vector<InputMedia> = Bool;

/*
Reorder a [main mini app previews, see here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews) for more info.

@bot The bot that owns the Main Mini App.
@lang_code ISO 639-1 language code, indicating the localization of the previews to reorder.
@order New order of the previews.

$400, BotInvalidError
*/
bots.reorderPreviewMedias#b627f3aa bot:InputUser lang_code:string order:Vector<InputMedia> = Bool;

/*
Bot owners only, fetch [main mini app preview information, see here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews) for more info.

@bot The bot that owns the Main Mini App.
@lang_code Fetch previews for the specified ISO 639-1 language code.

$400, BotInvalidError
*/
bots.getPreviewInfo#423ab3ad bot:InputUser lang_code:string = bots.PreviewInfo;

/*
Fetch [main mini app previews, see here](https://core.telegram.org/api/bots/webapps#main-mini-app-previews) for more info.

@bot The bot that owns the Main Mini App.

$400, BotInvalidError
*/
bots.getPreviewMedias#a2a5594d bot:InputUser = Vector<BotPreviewMedia>;

/*
Change the emoji status of a user (invoked by bots, see [here](https://core.telegram.org/api/emoji-status#setting-an-emoji-status-from-a-bot) for more info on the full flow)

**Bots can use this method**

@user_id The user whose emoji status should be changed
@emoji_status The emoji status

$400, UserBotRequiredError
$400, UserIdInvalidError
*/
bots.updateUserEmojiStatus#ed9f30c5 user_id:InputUser emoji_status:EmojiStatus = Bool;

/*
Allow or prevent a bot from [changing our emoji status](https://core.telegram.org/api/emoji-status#setting-an-emoji-status-from-a-bot)

@bot The bot
@enabled Whether to allow or prevent the bot from changing our emoji status

$400, BotInvalidError
*/
bots.toggleUserEmojiStatusPermission#6de6392 bot:InputUser enabled:Bool = Bool;

/*
Check if a [mini app](https://core.telegram.org/api/bots/webapps) can request the download of a specific file: called when handling [web_app_request_file_download events](https://core.telegram.org/api/web-events#web-app-request-file-download)

@bot The bot that owns the [mini app](https://core.telegram.org/api/bots/webapps) that requested the download
@file_name The filename from the [web_app_request_file_download event](https://core.telegram.org/api/web-events#web-app-request-file-download)
@url The url from the [web_app_request_file_download event](https://core.telegram.org/api/web-events#web-app-request-file-download)

$400, BotInvalidError
*/
bots.checkDownloadFileParams#50077589 bot:InputUser file_name:string url:string = Bool;

/*
Get a list of bots owned by the current user
*/
bots.getAdminedBots#b0711d83 = Vector<User>;

/*
Create, edit or delete the [affiliate program](https://core.telegram.org/api/bots/referrals) of a bot we own

@bot The bot
@commission_permille The permille commission rate: it indicates the share of Telegram Stars received by affiliates for every transaction made by users they referred inside of the bot.    The minimum and maximum values for this parameter are contained in the [starref_min_commission_permille](https://core.telegram.org/api/config#starref-min-commission-permille) and [starref_max_commission_permille](https://core.telegram.org/api/config#starref-max-commission-permille) client configuration parameters.   Can be 0 to terminate the affiliate program.   Both the duration and the commission may only be raised after creation of the program: to lower them, the program must first be terminated and a new one created.
@duration_months Indicates the duration of the affiliate program; if not set, there is no expiration date.

$400, BotInvalidError
$400, StarrefAwaitingEndError
$400, StarrefPermilleInvalidError
$400, StarrefPermilleTooLowError
*/
bots.updateStarRefProgram#778b5ab3 flags:# bot:InputUser commission_permille:int duration_months:flags.0?int = StarRefProgram;

bots.setCustomVerification#8b89dfbd flags:# enabled:flags.1?true bot:flags.0?InputUser peer:InputPeer custom_description:flags.2?string = Bool;
bots.getBotRecommendations#a1b70815 bot:InputUser = users.Users;
/*
Get a payment form

@invoice Invoice
@theme_params [Theme parameters](https://core.telegram.org/api/bots/webapps#theme-parameters)

$400, BoostPeerInvalidError
$400, BotInvoiceInvalidError
$400, MessageIdInvalidError
$400, PeerIdInvalidError
$400, SlugInvalidError
$400, StargiftInvalidError
$400, UntilDateInvalidError
*/
payments.getPaymentForm#37148dbb flags:# invoice:InputInvoice theme_params:flags.0?DataJSON = payments.PaymentForm;

/*
Get payment receipt

@peer The peer where the payment receipt was sent
@msg_id Message ID of receipt

$400, MessageIdInvalidError
*/
payments.getPaymentReceipt#2478d1cc peer:InputPeer msg_id:int = payments.PaymentReceipt;

/*
Submit requested order information for validation

@save Save order information to re-use it for future orders
@invoice Invoice
@info Requested order information

$400, MessageIdInvalidError
$400, PeerIdInvalidError
*/
payments.validateRequestedInfo#b6c8f12b flags:# save:flags.0?true invoice:InputInvoice info:PaymentRequestedInfo = payments.ValidatedRequestedInfo;

/*
Send compiled payment form

@form_id Form ID
@invoice Invoice
@requested_info_id ID of saved and validated [order info](https://core.telegram.org/constructor/payments.validatedRequestedInfo)
@shipping_option_id Chosen shipping option ID
@credentials Payment credentials
@tip_amount Tip, in the smallest units of the currency (integer, not float/double). For example, for a price of US$1.45 pass amount = 145. See the exp parameter in [currencies.json](https://core.telegram.org/bots/payments/currencies.json), it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).

$400, MessageIdInvalidError
$400, PeerIdInvalidError
$400, TmpPasswordInvalidError
*/
payments.sendPaymentForm#2d03522f flags:# form_id:long invoice:InputInvoice requested_info_id:flags.0?string shipping_option_id:flags.1?string credentials:InputPaymentCredentials tip_amount:flags.2?long = payments.PaymentResult;

/*
Get saved payment information
*/
payments.getSavedInfo#227d824b = payments.SavedInfo;

/*
Clear saved payment information

@credentials Remove saved payment credentials
@info Clear the last order settings saved by the user
*/
payments.clearSavedInfo#d83d70c1 flags:# credentials:flags.0?true info:flags.1?true = Bool;

/*
Get info about a credit card

@number Credit card number

$400, BankCardNumberInvalidError
*/
payments.getBankCardData#2e79d779 number:string = payments.BankCardData;

/*
Generate an [invoice deep link](https://core.telegram.org/api/links#invoice-links)

**Bots can use this method**

@invoice_media Invoice

$400, CurrencyTotalAmountInvalidError
$400, InvoicePayloadInvalidError
$400, MediaInvalidError
$400, PaymentProviderInvalidError
$400, StarsInvoiceInvalidError
$400, WebdocumentMimeInvalidError
$400, WebdocumentUrlEmptyError
*/
payments.exportInvoice#f91b065 invoice_media:InputMedia = payments.ExportedInvoice;

/*
Informs server about a purchase made through the App Store: for official applications only.

@receipt Receipt
@purpose Payment purpose

$400, ReceiptEmptyError
*/
payments.assignAppStoreTransaction#80ed747d receipt:bytes purpose:InputStorePaymentPurpose = Updates;

/*
Informs server about a purchase made through the Play Store: for official applications only.

@receipt Receipt
@purpose Payment purpose

$400, DataJsonInvalidError
*/
payments.assignPlayMarketTransaction#dffd50d3 receipt:DataJSON purpose:InputStorePaymentPurpose = Updates;

/*
Checks whether Telegram Premium purchase is possible. Must be called before in-store Premium purchase, official apps only.

@purpose Payment purpose

$406, PremiumCurrentlyUnavailableError
*/
payments.canPurchasePremium#9fc19eb6 purpose:InputStorePaymentPurpose = Bool;

/*
Obtain a list of Telegram Premium [giveaway/gift code](https://core.telegram.org/api/giveaways) options.

@boost_peer The channel that will start the giveaway
*/
payments.getPremiumGiftCodeOptions#2757ba54 flags:# boost_peer:flags.0?InputPeer = Vector<PremiumGiftCodeOption>;

/*
Obtain information about a [Telegram Premium giftcode](https://core.telegram.org/api/giveaways)

@slug The giftcode to check

$400, GiftSlugExpiredError
$400, GiftSlugInvalidError
*/
payments.checkGiftCode#8e51b4c1 slug:string = payments.CheckedGiftCode;

/*
Apply a [Telegram Premium giftcode](https://core.telegram.org/api/giveaways)

@slug The code to apply

$400, GiftSlugExpiredError
$400, GiftSlugInvalidError
$420, PremiumSubActiveUntilError
*/
payments.applyGiftCode#f6e26854 slug:string = Updates;

/*
Obtain information about a [Telegram Premium giveaway](https://core.telegram.org/api/giveaways).

@peer The peer where the giveaway was posted.
@msg_id Message ID of the [messageActionGiveawayLaunch](https://core.telegram.org/constructor/messageActionGiveawayLaunch) service message

$400, PeerIdInvalidError
*/
payments.getGiveawayInfo#f4239425 peer:InputPeer msg_id:int = payments.GiveawayInfo;

/*
Launch a [prepaid giveaway](https://core.telegram.org/api/giveaways).

@peer The peer where to launch the giveaway.
@giveaway_id The prepaid giveaway ID.
@purpose Giveway parameters

$400, PeerIdInvalidError
*/
payments.launchPrepaidGiveaway#5ff58f20 peer:InputPeer giveaway_id:long purpose:InputStorePaymentPurpose = Updates;

/*
Obtain a list of [Telegram Stars topup options](https://core.telegram.org/api/stars#buying-or-gifting-stars) as [starsTopupOption](https://core.telegram.org/constructor/starsTopupOption) constructors.
*/
payments.getStarsTopupOptions#c00ec7d3 = Vector<StarsTopupOption>;

/*
Get the current [Telegram Stars balance](https://core.telegram.org/api/stars) of the current account (with peer= [inputPeerSelf](https://core.telegram.org/constructor/inputPeerSelf)), or the stars balance of the bot specified in peer.

@peer Peer of which to get the balance.

$400, PeerIdInvalidError
*/
payments.getStarsStatus#104fcfa7 peer:InputPeer = payments.StarsStatus;

/*
Fetch [Telegram Stars transactions](https://core.telegram.org/api/stars#balance-and-transaction-history).

**Bots can use this method**

@inbound If set, fetches only incoming transactions.
@outbound If set, fetches only outgoing transactions.
@ascending Return transactions in ascending order by date (instead of descending order by date).
@subscription_id If set, fetches only transactions for the specified [Telegram Star subscription](https://core.telegram.org/api/stars#star-subscriptions).
@peer Fetch the transaction history of the peer ( [inputPeerSelf](https://core.telegram.org/constructor/inputPeerSelf) or a bot we own).
@offset [Offset for pagination, obtained from the returned next_offset, initially an empty string](https://core.telegram.org/api/offsets).
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, ChatAdminRequiredError
$400, PeerIdInvalidError
*/
payments.getStarsTransactions#69da4557 flags:# inbound:flags.0?true outbound:flags.1?true ascending:flags.2?true subscription_id:flags.3?string peer:InputPeer offset:string limit:int = payments.StarsStatus;

/*
Make a payment using [Telegram Stars, see here](https://core.telegram.org/api/stars#using-stars) for more info.

@form_id Payment form ID
@invoice Invoice

$400, BalanceTooLowError
$400, BotInvoiceInvalidError
$400, FormExpiredError
$400, FormIdEmptyError
$400, FormUnsupportedError
$400, PeerIdInvalidError
$400, StargiftUsageLimitedError
*/
payments.sendStarsForm#7998c914 form_id:long invoice:InputInvoice = payments.PaymentResult;

/*
Refund a [Telegram Stars](https://core.telegram.org/api/stars) transaction, see [here](https://core.telegram.org/api/payments#6-refunds) for more info.

**Bots can use this method**

@user_id User to refund.
@charge_id Transaction ID.

$400, ChargeAlreadyRefundedError
$400, UserBotRequiredError
$400, UserIdInvalidError
*/
payments.refundStarsCharge#25ae8f4a user_id:InputUser charge_id:string = Updates;

/*
Get [Telegram Star revenue statistics](https://core.telegram.org/api/stars).

@dark Whether to enable dark theme for graph colors
@peer Get statistics for the specified bot, channel or ourselves ( [inputPeerSelf](https://core.telegram.org/constructor/inputPeerSelf)).

$400, PeerIdInvalidError
*/
payments.getStarsRevenueStats#d91ffad6 flags:# dark:flags.0?true peer:InputPeer = payments.StarsRevenueStats;

/*
Withdraw funds from a channel or bot's [star balance](https://core.telegram.org/api/stars#withdrawing-stars).

@peer Channel or bot from which to withdraw funds.
@stars Amount of stars to withdraw.
@password 2FA password, see [here](https://core.telegram.org/api/srp#using-the-2fa-password) for more info.

$400, PasswordHashInvalidError
$400, PasswordMissingError
$400, PasswordTooFreshError
$400, SessionTooFreshError
*/
payments.getStarsRevenueWithdrawalUrl#13bbe8b3 peer:InputPeer stars:long password:InputCheckPasswordSRP = payments.StarsRevenueWithdrawalUrl;

/*
Returns a URL for a Telegram Ad platform account that can be used to set up advertisements for channel/bot in peer, paid using the Telegram Stars owned by the specified peer, see [here](https://core.telegram.org/api/stars#paying-for-ads) for more info.

@peer Channel or bot that owns the stars.

$403, ChatWriteForbiddenError
$400, PeerIdInvalidError
*/
payments.getStarsRevenueAdsAccountUrl#d1d7efc5 peer:InputPeer = payments.StarsRevenueAdsAccountUrl;

/*
Obtain info about [Telegram Star transactions](https://core.telegram.org/api/stars#balance-and-transaction-history) using specific transaction IDs.

@peer Channel or bot.
@id Transaction IDs.

$400, PeerIdInvalidError
$400, TransactionIdInvalidError
*/
payments.getStarsTransactionsByID#27842d2e peer:InputPeer id:Vector<InputStarsTransaction> = payments.StarsStatus;

/*
Obtain a list of [Telegram Stars gift options](https://core.telegram.org/api/stars#buying-or-gifting-stars) as [starsGiftOption](https://core.telegram.org/constructor/starsGiftOption) constructors.

@user_id Receiver of the gift (optional).

$400, UserGiftUnavailableError
$400, UserIdInvalidError
*/
payments.getStarsGiftOptions#d3c96bc8 flags:# user_id:flags.0?InputUser = Vector<StarsGiftOption>;

/*
Obtain a list of active, expired or cancelled [Telegram Star subscriptions](https://core.telegram.org/api/invites#paid-invite-links).

@missing_balance Whether to return only subscriptions expired due to an excessively low Telegram Star balance.
@peer Always pass [inputPeerSelf](https://core.telegram.org/constructor/inputPeerSelf).
@offset Offset for pagination, taken from [payments.starsStatus](https://core.telegram.org/constructor/payments.starsStatus). subscriptions_next_offset.

$400, PeerIdInvalidError
*/
payments.getStarsSubscriptions#32512c5 flags:# missing_balance:flags.0?true peer:InputPeer offset:string = payments.StarsStatus;

/*
Activate or deactivate a [Telegram Star subscription](https://core.telegram.org/api/invites#paid-invite-links).

@peer Always pass [inputPeerSelf](https://core.telegram.org/constructor/inputPeerSelf).
@subscription_id ID of the subscription.
@canceled Whether to cancel or reactivate the subscription.

$400, PeerIdInvalidError
*/
payments.changeStarsSubscription#c7770878 flags:# peer:InputPeer subscription_id:string canceled:flags.0?Bool = Bool;

/*
Re-join a private channel associated to an active [Telegram Star subscription](https://core.telegram.org/api/invites#paid-invite-links).

@peer Always pass [inputPeerSelf](https://core.telegram.org/constructor/inputPeerSelf).
@subscription_id ID of the subscription.

$400, PeerIdInvalidError
*/
payments.fulfillStarsSubscription#cc5bebb3 peer:InputPeer subscription_id:string = Bool;

/*
Fetch a list of [star giveaway options](https://core.telegram.org/api/giveaways#star-giveaways).
*/
payments.getStarsGiveawayOptions#bd1efd3e = Vector<StarsGiveawayOption>;

/*
Get a list of available [gifts, see here](https://core.telegram.org/api/gifts) for more info.

@hash [Hash used for caching, for more info click here](https://core.telegram.org/api/offsets#hash-generation). The hash may be generated locally by using the ids of the returned or stored sticker [starGift](https://core.telegram.org/constructor/starGift)s.
*/
payments.getStarGifts#c4563590 hash:int = payments.StarGifts;

/*
Display or remove a [received gift](https://core.telegram.org/api/gifts) from our profile.

@unsave If set, hides the gift from our profile.
@stargift  ... 

$400, UserIdInvalidError

#DocError
*/
payments.saveStarGift#2a2a697c flags:# unsave:flags.0?true stargift:InputSavedStarGift = Bool;

/*
Convert a [received gift](https://core.telegram.org/api/gifts) into Telegram Stars: this will permanently destroy the gift, converting it into [starGift](https://core.telegram.org/constructor/starGift). convert_stars [Telegram Stars](https://core.telegram.org/api/stars), added to the user's balance.

@stargift  ... 

$400, UserIdInvalidError

#DocError
*/
payments.convertStarGift#74bf076b stargift:InputSavedStarGift = Bool;

/*
Cancel a [bot subscription](https://core.telegram.org/api/subscriptions#bot-subscriptions)

@restore If not set, disables autorenewal of the subscriptions, and prevents the user from reactivating the subscription once the current period expires: a subscription cancelled by the bot will have the [starsSubscription](https://core.telegram.org/constructor/starsSubscription). bot_canceled flag set.  The bot can can partially undo this operation by setting this flag: this will allow the user to reactivate the subscription.
@user_id The ID of the user whose subscription should be (un)cancelled
@charge_id The provider_charge_id from the [messageActionPaymentSentMe](https://core.telegram.org/constructor/messageActionPaymentSentMe) service message sent to the bot for the first subscription payment.

$400, UserIdInvalidError
*/
payments.botCancelStarsSubscription#6dfa0622 flags:# restore:flags.0?true user_id:InputUser charge_id:string = Bool;

/*
Fetch all affiliations we have created for a certain peer

@peer The affiliated peer
@offset_date If set, returns only results older than the specified unixtime
@offset_link Offset for [pagination](https://core.telegram.org/api/offsets), taken from the last returned [connectedBotStarRef](https://core.telegram.org/constructor/connectedBotStarRef). url (initially empty)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)
*/
payments.getConnectedStarRefBots#5869a553 flags:# peer:InputPeer offset_date:flags.2?int offset_link:flags.2?string limit:int = payments.ConnectedStarRefBots;

/*
Fetch info about a specific [bot affiliation](https://core.telegram.org/api/bots/referrals)

@peer The affiliated peer
@bot The bot that offers the affiliate program

$400, PeerIdInvalidError
*/
payments.getConnectedStarRefBot#b7d998f0 peer:InputPeer bot:InputUser = payments.ConnectedStarRefBots;

/*
Obtain a list of suggested [mini apps](https://core.telegram.org/api/bots/webapps) with available [affiliate programs](https://core.telegram.org/api/bots/referrals)

@order_by_revenue If set, orders results by the expected revenue
@order_by_date If set, orders results by the creation date of the affiliate program
@peer The peer that will become the affiliate: star commissions will be transferred to this peer's star balance.
@offset Offset for pagination, taken from [payments.suggestedStarRefBots](https://core.telegram.org/constructor/payments.suggestedStarRefBots). next_offset, initially empty.
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$403, PeerIdInvalidError
*/
payments.getSuggestedStarRefBots#d6b48f7 flags:# order_by_revenue:flags.0?true order_by_date:flags.1?true peer:InputPeer offset:string limit:int = payments.SuggestedStarRefBots;

/*
Join a bot's [affiliate program, becoming an affiliate](https://core.telegram.org/api/bots/referrals#becoming-an-affiliate)

@peer The peer that will become the affiliate: star commissions will be transferred to this peer's star balance.
@bot The bot that offers the affiliate program
*/
payments.connectStarRefBot#7ed5348a peer:InputPeer bot:InputUser = payments.ConnectedStarRefBots;

/*
Leave a bot's [affiliate program](https://core.telegram.org/api/bots/referrals#becoming-an-affiliate)

@revoked If set, leaves the bot's affiliate program
@peer The peer that was affiliated
@link The affiliate link to revoke

$400, StarrefHashRevokedError
*/
payments.editConnectedStarRefBot#e4fca4a3 flags:# revoked:flags.0?true peer:InputPeer link:string = payments.ConnectedStarRefBots;

payments.getStarGiftUpgradePreview#9c9abcb1 gift_id:long = payments.StarGiftUpgradePreview;
payments.upgradeStarGift#aed6e4f5 flags:# keep_original_details:flags.0?true stargift:InputSavedStarGift = Updates;
payments.transferStarGift#7f18176a stargift:InputSavedStarGift to_id:InputPeer = Updates;
payments.getUniqueStarGift#a1974d72 slug:string = payments.UniqueStarGift;
payments.getSavedStarGifts#23830de9 flags:# exclude_unsaved:flags.0?true exclude_saved:flags.1?true exclude_unlimited:flags.2?true exclude_limited:flags.3?true exclude_unique:flags.4?true sort_by_value:flags.5?true peer:InputPeer offset:string limit:int = payments.SavedStarGifts;
payments.getSavedStarGift#b455a106 stargift:Vector<InputSavedStarGift> = payments.SavedStarGifts;
payments.getStarGiftWithdrawalUrl#d06e93a8 stargift:InputSavedStarGift password:InputCheckPasswordSRP = payments.StarGiftWithdrawalUrl;
payments.toggleChatStarGiftNotifications#60eaefa1 flags:# enabled:flags.0?true peer:InputPeer = Bool;
/*
Create a stickerset.

**Bots can use this method**

@masks Whether this is a mask stickerset
@emojis Whether this is a [custom emoji](https://core.telegram.org/api/custom-emoji) stickerset.
@text_color Whether the color of TGS custom emojis contained in this set should be changed to the text color when used in messages, the accent color if used as emoji status, white on chat photos, or another appropriate color based on context. For custom emoji stickersets only.
@user_id Stickerset owner
@title Stickerset name, 1-64 chars
@short_name Short name of sticker set, to be used in [sticker deep links](https://core.telegram.org/api/links#stickerset-links). Can contain only english letters, digits and underscores. Must begin with a letter, can't contain consecutive underscores and, if called by a bot, must end in "_by_<bot_username>". <bot_username> is case insensitive. 1-64 characters.
@thumb Thumbnail
@stickers Stickers
@software Used when [importing stickers using the sticker import SDKs](https://core.telegram.org/import-stickers), specifies the name of the software that created the stickers

$400, PackShortNameInvalidError
$400, PackShortNameOccupiedError
$400, PackTitleInvalidError
$400, PeerIdInvalidError
$400, StickersEmptyError
$400, StickerEmojiInvalidError
$400, StickerFileInvalidError
$400, StickerGifDimensionsError
$400, StickerPngDimensionsError
$400, StickerPngNopngError
$400, StickerTgsNodocError
$400, StickerTgsNotgsError
$400, StickerThumbPngNopngError
$400, StickerThumbTgsNotgsError
$400, StickerVideoBigError
$400, StickerVideoNodocError
$400, StickerVideoNowebmError
$400, UserIdInvalidError
*/
stickers.createStickerSet#9021ab67 flags:# masks:flags.0?true emojis:flags.5?true text_color:flags.6?true user_id:InputUser title:string short_name:string thumb:flags.2?InputDocument stickers:Vector<InputStickerSetItem> software:flags.3?string = messages.StickerSet;

/*
Remove a sticker from the set where it belongs. The sticker set must have been created by the current user/bot.

**Bots can use this method**

@sticker The sticker to remove

$400, StickerInvalidError
*/
stickers.removeStickerFromSet#f7760f51 sticker:InputDocument = messages.StickerSet;

/*
Changes the absolute position of a sticker in the set to which it belongs. The sticker set must have been created by the current user/bot.

**Bots can use this method**

@sticker The sticker
@position The new position of the sticker, zero-based

$400, StickerInvalidError
*/
stickers.changeStickerPosition#ffb6d4ca sticker:InputDocument position:int = messages.StickerSet;

/*
Add a sticker to a stickerset. The sticker set must have been created by the current user/bot.

**Bots can use this method**

@stickerset The stickerset
@sticker The sticker

$400, StickerpackStickersTooMuchError
$406, StickersetInvalidError
$400, StickersTooMuchError
$400, StickerPngNopngError
$400, StickerTgsNotgsError
*/
stickers.addStickerToSet#8653febe stickerset:InputStickerSet sticker:InputStickerSetItem = messages.StickerSet;

/*
Set stickerset thumbnail

**Bots can use this method**

@stickerset Stickerset
@thumb Thumbnail (only for normal stickersets, not custom emoji stickersets).
@thumb_document_id Only for [custom emoji stickersets](https://core.telegram.org/api/custom-emoji), ID of a custom emoji present in the set to use as thumbnail; pass 0 to fallback to the first custom emoji of the set.

$400, StickersetInvalidError
$400, StickerThumbPngNopngError
$400, StickerThumbTgsNotgsError
*/
stickers.setStickerSetThumb#a76a5392 flags:# stickerset:InputStickerSet thumb:flags.0?InputDocument thumb_document_id:flags.1?long = messages.StickerSet;

/*
Check whether the given short name is available

@short_name Short name

$400, ShortNameInvalidError
$400, ShortNameOccupiedError
*/
stickers.checkShortName#284b3639 short_name:string = Bool;

/*
Suggests a short name for a given stickerpack name

@title Sticker pack name

$400, TitleInvalidError
*/
stickers.suggestShortName#4dafc503 title:string = stickers.SuggestedShortName;

/*
Update the keywords, emojis or [mask coordinates](https://core.telegram.org/api/stickers#mask-stickers) of a sticker.

**Bots can use this method**

@sticker The sticker
@emoji If set, updates the emoji list associated to the sticker
@mask_coords If set, updates the [mask coordinates](https://core.telegram.org/api/stickers#mask-stickers)
@keywords If set, updates the sticker keywords (separated by commas). Can't be provided for mask stickers.

$400, StickerInvalidError
*/
stickers.changeSticker#f5537ebc flags:# sticker:InputDocument emoji:flags.0?string mask_coords:flags.1?MaskCoords keywords:flags.2?string = messages.StickerSet;

/*
Renames a stickerset.

**Bots can use this method**

@stickerset Stickerset to rename
@title New stickerset title

$400, StickersetInvalidError
*/
stickers.renameStickerSet#124b1c00 stickerset:InputStickerSet title:string = messages.StickerSet;

/*
Deletes a stickerset we created.

**Bots can use this method**

@stickerset Stickerset to delete

$400, StickersetInvalidError
*/
stickers.deleteStickerSet#87704394 stickerset:InputStickerSet = Bool;

/*
Replace a sticker in a [stickerset](https://core.telegram.org/api/stickers).

**Bots can use this method**

@sticker Old sticker document.
@new_sticker New sticker.

$400, StickerInvalidError
*/
stickers.replaceSticker#4696459a sticker:InputDocument new_sticker:InputStickerSetItem = messages.StickerSet;

/*
Get phone call configuration to be passed to libtgvoip's shared config
*/
phone.getCallConfig#55451fa9 = DataJSON;

/*
Start a telegram phone call

@video Whether to start a video call
@user_id Destination of the phone call
@conference_call  ... 
@random_id Random ID to avoid resending the same object
@g_a_hash [Parameter for E2E encryption key exchange](https://core.telegram.org/api/end-to-end/voice-calls)
@protocol Phone call settings

$400, CallProtocolFlagsInvalidError
$400, InputUserDeactivatedError
$400, ParticipantVersionOutdatedError
$400, UserIdInvalidError
$403, UserIsBlockedError
$403, UserPrivacyRestrictedError

#DocError
*/
phone.requestCall#a6c4600c flags:# video:flags.0?true user_id:InputUser conference_call:flags.1?InputGroupCall random_id:int g_a_hash:bytes protocol:PhoneCallProtocol = phone.PhoneCall;

/*
Accept incoming call

@peer The call to accept
@g_b [Parameter for E2E encryption key exchange](https://core.telegram.org/api/end-to-end/voice-calls)
@protocol Phone call settings

$400, CallAlreadyAcceptedError
$400, CallAlreadyDeclinedError
$500, CallOccupyFailedError
$400, CallPeerInvalidError
$406, CallProtocolCompatLayerInvalidError
$400, CallProtocolFlagsInvalidError
*/
phone.acceptCall#3bd2b4a0 peer:InputPhoneCall g_b:bytes protocol:PhoneCallProtocol = phone.PhoneCall;

/*
[Complete phone call E2E encryption key exchange](https://core.telegram.org/api/end-to-end/voice-calls)

@peer The phone call
@g_a [Parameter for E2E encryption key exchange](https://core.telegram.org/api/end-to-end/voice-calls)
@key_fingerprint Key fingerprint
@protocol Phone call settings

$400, CallAlreadyDeclinedError
$400, CallPeerInvalidError
*/
phone.confirmCall#2efe1722 peer:InputPhoneCall g_a:bytes key_fingerprint:long protocol:PhoneCallProtocol = phone.PhoneCall;

/*
Optional: notify the server that the user is currently busy in a call: this will automatically refuse all incoming phone calls until the current phone call is ended.

@peer The phone call we're currently in

$400, CallAlreadyDeclinedError
$400, CallPeerInvalidError
*/
phone.receivedCall#17d54f61 peer:InputPhoneCall = Bool;

/*
Refuse or end running call

@video Whether this is a video call
@peer The phone call
@duration Call duration
@reason Why was the call discarded
@connection_id Preferred libtgvoip relay ID

$400, CallAlreadyAcceptedError
$500, CallOccupyFailedError
$400, CallPeerInvalidError
*/
phone.discardCall#b2cbc1c0 flags:# video:flags.0?true peer:InputPhoneCall duration:int reason:PhoneCallDiscardReason connection_id:long = Updates;

/*
Rate a call, returns info about the rating message sent to the official VoIP bot.

@user_initiative Whether the user decided on their own initiative to rate the call
@peer The call to rate
@rating Rating in 1-5 stars
@comment An additional comment

$400, CallPeerInvalidError
*/
phone.setCallRating#59ead627 flags:# user_initiative:flags.0?true peer:InputPhoneCall rating:int comment:string = Updates;

/*
Send phone call debug data to server

@peer Phone call
@debug Debug statistics obtained from libtgvoip

$400, CallPeerInvalidError
$400, DataJsonInvalidError
*/
phone.saveCallDebug#277add7e peer:InputPhoneCall debug:DataJSON = Bool;

/*
Send VoIP signaling data

@peer Phone call
@data Signaling payload

$400, CallPeerInvalidError
*/
phone.sendSignalingData#ff7a9383 peer:InputPhoneCall data:bytes = Bool;

/*
Create a group call or livestream

@rtmp_stream Whether RTMP stream support should be enabled: only the [group/supergroup/channel](https://core.telegram.org/api/channel) owner can use this flag.
@peer Associate the group call or livestream to the provided [group/supergroup/channel](https://core.telegram.org/api/channel)
@random_id Unique client message ID required to prevent creation of duplicate group calls
@title Call title
@schedule_date For scheduled group call or livestreams, the absolute date when the group call will start

$400, ChannelPrivateError
$400, ChatAdminRequiredError
$400, CreateCallFailedError
$400, GroupcallAlreadyDiscardedError
$400, PeerIdInvalidError
$400, ScheduleDateInvalidError
*/
phone.createGroupCall#48cdc6d8 flags:# rtmp_stream:flags.2?true peer:InputPeer random_id:int title:flags.0?string schedule_date:flags.1?int = Updates;

/*
Join a group call

@muted If set, the user will be muted by default upon joining.
@video_stopped If set, the user's video will be disabled by default upon joining.
@call The group call
@join_as Join the group call, presenting yourself as the specified user/channel
@invite_hash The invitation hash from the [invite link](https://core.telegram.org/api/links#video-chat-livestream-links), if provided allows speaking in a livestream or muted group chat.
@key_fingerprint  ... 
@params WebRTC parameters

$400, DataJsonInvalidError
$403, GroupcallForbiddenError
$400, GroupcallInvalidError
$400, GroupcallSsrcDuplicateMuchError
$400, JoinAsPeerInvalidError

#DocError
*/
phone.joinGroupCall#d61e1df3 flags:# muted:flags.0?true video_stopped:flags.2?true call:InputGroupCall join_as:InputPeer invite_hash:flags.1?string key_fingerprint:flags.3?long params:DataJSON = Updates;

/*
Leave a group call

@call The group call
@source Your source ID

$400, GroupcallInvalidError
*/
phone.leaveGroupCall#500377f9 call:InputGroupCall source:int = Updates;

/*
Invite a set of users to a group call.

@call The group call
@users The users to invite.

$403, ChatTypeInvalidError
$403, GroupcallForbiddenError
$400, GroupcallInvalidError
$400, InviteForbiddenWithJoinasError
$400, UserAlreadyInvitedError
$403, UserNotParticipantError
*/
phone.inviteToGroupCall#7b393160 call:InputGroupCall users:Vector<InputUser> = Updates;

/*
Terminate a group call

@call The group call to terminate

$400, GroupcallAlreadyDiscardedError
$403, GroupcallForbiddenError
$400, GroupcallInvalidError
*/
phone.discardGroupCall#7a777135 call:InputGroupCall = Updates;

/*
Change group call settings

@reset_invite_hash Invalidate existing invite links
@call Group call
@join_muted Whether all users will that join this group call are muted by default upon joining the group call

$400, GroupcallInvalidError
$400, GroupcallNotModifiedError
*/
phone.toggleGroupCallSettings#74bbb43d flags:# reset_invite_hash:flags.1?true call:InputGroupCall join_muted:flags.0?Bool = Updates;

/*
Get info about a group call

@call The group call
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$403, GroupcallForbiddenError
$400, GroupcallInvalidError
*/
phone.getGroupCall#41845db call:InputGroupCall limit:int = phone.GroupCall;

/*
Get group call participants

@call Group call
@ids If specified, will fetch group participant info about the specified peers
@sources If specified, will fetch group participant info about the specified WebRTC source IDs
@offset Offset for results, taken from the next_offset field of [phone.groupParticipants](https://core.telegram.org/constructor/phone.groupParticipants), initially an empty string. Note: if no more results are available, the method call will return an empty next_offset; thus, avoid providing the next_offset returned in [phone.groupParticipants](https://core.telegram.org/constructor/phone.groupParticipants) if it is empty, to avoid an infinite loop.
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, GroupcallInvalidError
*/
phone.getGroupParticipants#c558d8ab call:InputGroupCall ids:Vector<InputPeer> sources:Vector<int> offset:string limit:int = phone.GroupParticipants;

/*
Check whether the group call Server Forwarding Unit is currently receiving the streams with the specified WebRTC source IDs. 
Returns an intersection of the source IDs specified in sources, and the source IDs currently being forwarded by the SFU.

@call Group call
@sources Source IDs

$400, GroupcallInvalidError
$400, GroupcallJoinMissingError
*/
phone.checkGroupCall#b59cf977 call:InputGroupCall sources:Vector<int> = Vector<int>;

/*
Start or stop recording a group call: the recorded audio and video streams will be automatically sent to Saved messages (the chat with ourselves).

@start Whether to start or stop recording
@video Whether to also record video streams
@call The group call or livestream
@title Recording title
@video_portrait If video stream recording is enabled, whether to record in portrait or landscape mode

$403, GroupcallForbiddenError
$400, GroupcallInvalidError
$400, GroupcallNotModifiedError
*/
phone.toggleGroupCallRecord#f128c708 flags:# start:flags.0?true video:flags.2?true call:InputGroupCall title:flags.1?string video_portrait:flags.2?Bool = Updates;

/*
Edit information about a given group call participant

@call The group call
@participant The group call participant (can also be the user itself)
@muted Whether to mute or unmute the specified participant
@volume New volume
@raise_hand Raise or lower hand
@video_stopped Start or stop the video stream
@video_paused Pause or resume the video stream
@presentation_paused Pause or resume the screen sharing stream

$403, GroupcallForbiddenError
$400, GroupcallInvalidError
$400, ParticipantJoinMissingError
$400, RaiseHandForbiddenError
$400, UserVolumeInvalidError
$400, VideoPauseForbiddenError
$400, VideoStopForbiddenError
*/
phone.editGroupCallParticipant#a5273abf flags:# call:InputGroupCall participant:InputPeer muted:flags.0?Bool volume:flags.1?int raise_hand:flags.2?Bool video_stopped:flags.3?Bool video_paused:flags.4?Bool presentation_paused:flags.5?Bool = Updates;

/*
Edit the title of a group call or livestream

@call Group call
@title New title

$403, GroupcallForbiddenError
$400, GroupcallInvalidError
*/
phone.editGroupCallTitle#1ca6ac0a call:InputGroupCall title:string = Updates;

/*
Get a list of peers that can be used to join a group call, presenting yourself as a specific user/channel.

@peer The dialog whose group call or livestream we're trying to join

$400, PeerIdInvalidError
*/
phone.getGroupCallJoinAs#ef7c213a peer:InputPeer = phone.JoinAsPeers;

/*
Get an [invite link](https://core.telegram.org/api/links#video-chat-livestream-links) for a group call or livestream

@can_self_unmute For livestreams or muted group chats, if set, users that join using this link will be able to speak without explicitly requesting permission by (for example by raising their hand).
@call The group call

$400, GroupcallInvalidError
$403, PublicChannelMissingError
*/
phone.exportGroupCallInvite#e6aa647f flags:# can_self_unmute:flags.0?true call:InputGroupCall = phone.ExportedGroupCallInvite;

/*
Subscribe or unsubscribe to a scheduled group call

@call Scheduled group call
@subscribed Enable or disable subscription

$403, GroupcallAlreadyStartedError
$400, GroupcallInvalidError
*/
phone.toggleGroupCallStartSubscription#219c34e6 call:InputGroupCall subscribed:Bool = Updates;

/*
Start a scheduled group call.

@call The scheduled group call

$403, GroupcallAlreadyStartedError
$400, GroupcallInvalidError
*/
phone.startScheduledGroupCall#5680e342 call:InputGroupCall = Updates;

/*
Set the default peer that will be used to join a group call in a specific dialog.

@peer The dialog
@join_as The default peer that will be used to join group calls in this dialog, presenting yourself as a specific user/channel.

$400, JoinAsPeerInvalidError
$400, PeerIdInvalidError
*/
phone.saveDefaultGroupCallJoinAs#575e1f8c peer:InputPeer join_as:InputPeer = Bool;

/*
Start screen sharing in a call

@call The group call
@params WebRTC parameters

$400, GroupcallInvalidError
$403, ParticipantJoinMissingError
*/
phone.joinGroupCallPresentation#cbea6bc4 call:InputGroupCall params:DataJSON = Updates;

/*
Stop screen sharing in a group call

@call The group call

$400, GroupcallInvalidError
*/
phone.leaveGroupCallPresentation#1c50d144 call:InputGroupCall = Updates;

/*
Get info about RTMP streams in a group call or livestream. 
This method should be invoked to the same group/channel-related DC used for [downloading livestream chunks](https://core.telegram.org/api/files#downloading-files). 
As usual, the media DC is preferred, if available.

@call Group call or livestream

$400, GroupcallInvalidError
$400, GroupcallJoinMissingError
*/
phone.getGroupCallStreamChannels#1ab21940 call:InputGroupCall = phone.GroupCallStreamChannels;

/*
Get RTMP URL and stream key for RTMP livestreams. Can be used even before creating the actual RTMP livestream with [phone.createGroupCall](https://core.telegram.org/method/phone.createGroupCall) (the rtmp_stream flag must be set).

@peer Peer to livestream into
@revoke Whether to revoke the previous stream key or simply return the existing one

$400, ChatAdminRequiredError
$400, PeerIdInvalidError
*/
phone.getGroupCallStreamRtmpUrl#deb3abbf peer:InputPeer revoke:Bool = phone.GroupCallStreamRtmpUrl;

/*
Save phone call debug information

@peer Phone call
@file Logs

$400, CallPeerInvalidError
*/
phone.saveCallLog#41248786 peer:InputPhoneCall file:InputFile = Bool;

phone.createConferenceCall#dfc909ab peer:InputPhoneCall key_fingerprint:long = phone.PhoneCall;
/*
Get localization pack strings

@lang_pack Platform identifier (i.e. android, tdesktop, etc).
@lang_code Either an ISO 639-1 language code or a language pack name obtained from a [language pack link](https://core.telegram.org/api/links#language-pack-links).

$400, LanguageInvalidError
$400, LangCodeNotSupportedError
$400, LangPackInvalidError
*/
langpack.getLangPack#f2f2330a lang_pack:string lang_code:string = LangPackDifference;

/*
Get strings from a language pack

@lang_pack Platform identifier (i.e. android, tdesktop, etc).
@lang_code Either an ISO 639-1 language code or a language pack name obtained from a [language pack link](https://core.telegram.org/api/links#language-pack-links).
@keys Strings to get

$400, LangCodeNotSupportedError
$400, LangPackInvalidError
*/
langpack.getStrings#efea3803 lang_pack:string lang_code:string keys:Vector<string> = Vector<LangPackString>;

/*
Get new strings in language pack

@lang_pack Platform identifier (i.e. android, tdesktop, etc).
@lang_code Either an ISO 639-1 language code or a language pack name obtained from a [language pack link](https://core.telegram.org/api/links#language-pack-links).
@from_version Previous localization pack version

$400, LangPackInvalidError
*/
langpack.getDifference#cd984aa5 lang_pack:string lang_code:string from_version:int = LangPackDifference;

/*
Get information about all languages in a localization pack

@lang_pack Platform identifier (i.e. android, tdesktop, etc).

$400, LangPackInvalidError
*/
langpack.getLanguages#42c6978f lang_pack:string = Vector<LangPackLanguage>;

/*
Get information about a language in a localization pack

@lang_pack Platform identifier (i.e. android, tdesktop, etc).
@lang_code Either an ISO 639-1 language code or a language pack name obtained from a [language pack link](https://core.telegram.org/api/links#language-pack-links).

$400, LangCodeNotSupportedError
$400, LangPackInvalidError
*/
langpack.getLanguage#6a596502 lang_pack:string lang_code:string = LangPackLanguage;

/*
Edit peers in [peer folder](https://core.telegram.org/api/folders#peer-folders)

@folder_peers New peer list

$400, ChannelPrivateError
$400, ChatIdInvalidError
$400, FolderIdInvalidError
*/
folders.editPeerFolders#6847d0ab folder_peers:Vector<InputFolderPeer> = Updates;

/*
Get [channel statistics](https://core.telegram.org/api/stats)

@dark Whether to enable dark theme for graph colors
@channel The channel

$400, BroadcastRequiredError
$400, ChannelInvalidError
$400, ChannelPrivateError
$403, ChatAdminRequiredError
*/
stats.getBroadcastStats#ab42441a flags:# dark:flags.0?true channel:InputChannel = stats.BroadcastStats;

/*
Load [channel statistics graph](https://core.telegram.org/api/stats) asynchronously

@token Graph token from [statsGraphAsync](https://core.telegram.org/constructor/statsGraphAsync) constructor
@x Zoom value, if required

$400, GraphExpiredReloadError
$400, GraphInvalidReloadError
$400, GraphOutdatedReloadError
*/
stats.loadAsyncGraph#621d5fa0 flags:# token:string x:flags.0?long = StatsGraph;

/*
Get [supergroup statistics](https://core.telegram.org/api/stats)

@dark Whether to enable dark theme for graph colors
@channel [Supergroup ID](https://core.telegram.org/api/channel)

$400, ChannelInvalidError
$403, ChatAdminRequiredError
$400, MegagroupRequiredError
*/
stats.getMegagroupStats#dcdf8607 flags:# dark:flags.0?true channel:InputChannel = stats.MegagroupStats;

/*
Obtains a list of messages, indicating to which other public channels was a channel message forwarded. 
Will return a list of [messages](https://core.telegram.org/constructor/message) with peer_id equal to the public channel to which this message was forwarded.

@channel Source channel
@msg_id Source message ID
@offset Offset for [pagination](https://core.telegram.org/api/offsets), empty string on first call, then use the next_offset field of the returned constructor (if present, otherwise no more results are available).
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, MessageIdInvalidError
$400, PeerIdInvalidError
*/
stats.getMessagePublicForwards#5f150144 channel:InputChannel msg_id:int offset:string limit:int = stats.PublicForwards;

/*
Get [message statistics](https://core.telegram.org/api/stats)

@dark Whether to enable dark theme for graph colors
@channel Channel ID
@msg_id Message ID

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, MessageIdInvalidError
$400, PeerIdInvalidError
*/
stats.getMessageStats#b6e0a3f5 flags:# dark:flags.0?true channel:InputChannel msg_id:int = stats.MessageStats;

/*
Get [statistics](https://core.telegram.org/api/stats) for a certain [story](https://core.telegram.org/api/stories).

@dark Whether to enable the dark theme for graph colors
@peer The peer that posted the story
@id Story ID

$400, PeerIdInvalidError
$400, StoriesNeverCreatedError
*/
stats.getStoryStats#374fef40 flags:# dark:flags.0?true peer:InputPeer id:int = stats.StoryStats;

/*
Obtain forwards of a [story](https://core.telegram.org/api/stories) as a message to public chats and reposts by public channels.

@peer Peer where the story was originally posted
@id [Story](https://core.telegram.org/api/stories) ID
@offset Offset for pagination, from [stats.PublicForwards](https://core.telegram.org/constructor/stats.publicForwards). next_offset.
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, PeerIdInvalidError
*/
stats.getStoryPublicForwards#a6437ef6 peer:InputPeer id:int offset:string limit:int = stats.PublicForwards;

/*
Get [channel ad revenue statistics](https://core.telegram.org/api/revenue).

@dark Whether to enable dark theme for graph colors
@peer Get ad revenue stats for the specified channel or bot

$400, ChannelInvalidError
$400, ChatAdminRequiredError
$400, PeerIdInvalidError
*/
stats.getBroadcastRevenueStats#f788ee19 flags:# dark:flags.0?true peer:InputPeer = stats.BroadcastRevenueStats;

/*
Withdraw funds from a channel's [ad revenue balance](https://core.telegram.org/api/revenue).

@peer Get ad revenue withdrawal URL for the specified channel or bot
@password 2FA password, see [here](https://core.telegram.org/api/srp#using-the-2fa-password) for more info.

$400, PasswordHashInvalidError
$400, PasswordMissingError
$400, PasswordTooFreshError
$400, SessionTooFreshError
*/
stats.getBroadcastRevenueWithdrawalUrl#9df4faad peer:InputPeer password:InputCheckPasswordSRP = stats.BroadcastRevenueWithdrawalUrl;

/*
Fetch [channel ad revenue transaction history](https://core.telegram.org/api/revenue).

@peer Get ad revenue transactions for the specified channel or bot
@offset [Offset for pagination](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, ChannelInvalidError
$400, PeerIdInvalidError
*/
stats.getBroadcastRevenueTransactions#70990b6d peer:InputPeer offset:int limit:int = stats.BroadcastRevenueTransactions;

/*
Export a [folder](https://core.telegram.org/api/folders), creating a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@chatlist The folder to export
@title An optional name for the link
@peers The list of channels, group and supergroups to share with the link. Basic groups will automatically be [converted to supergroups](https://core.telegram.org/api/channel#migration) when invoking the method.

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, ChatlistsTooMuchError
$400, ChatAdminRequiredError
$400, FilterIdInvalidError
$400, FilterNotSupportedError
$400, InvitesTooMuchError
$400, PeersListEmptyError
*/
chatlists.exportChatlistInvite#8472478e chatlist:InputChatlist title:string peers:Vector<InputPeer> = chatlists.ExportedChatlistInvite;

/*
Delete a previously created [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@chatlist The related folder
@slug slug obtained from the [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

$400, FilterIdInvalidError
$400, FilterNotSupportedError
$400, InviteSlugExpiredError
$400, InviteSlugInvalidError
*/
chatlists.deleteExportedInvite#719c5c5e chatlist:InputChatlist slug:string = Bool;

/*
Edit a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@chatlist Folder ID
@slug slug obtained from the [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).
@title If set, sets a new name for the link
@peers If set, changes the list of peers shared with the link

$400, ChannelInvalidError
$400, FilterIdInvalidError
$400, FilterNotSupportedError
$400, InviteSlugEmptyError
$400, InviteSlugExpiredError
$400, PeersListEmptyError
*/
chatlists.editExportedInvite#653db63d flags:# chatlist:InputChatlist slug:string title:flags.1?string peers:flags.2?Vector<InputPeer> = ExportedChatlistInvite;

/*
List all [chat folder deep links](https://core.telegram.org/api/links#chat-folder-links) associated to a folder

@chatlist The folder

$400, FilterIdInvalidError
*/
chatlists.getExportedInvites#ce03da83 chatlist:InputChatlist = chatlists.ExportedInvites;

/*
Obtain information about a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@slug slug obtained from the [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links)

$400, InviteSlugEmptyError
$400, InviteSlugExpiredError
*/
chatlists.checkChatlistInvite#41c10fff slug:string = chatlists.ChatlistInvite;

/*
Import a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links), joining some or all the chats in the folder.

@slug slug obtained from a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).
@peers List of new chats to join, fetched using [chatlists.checkChatlistInvite](https://core.telegram.org/method/chatlists.checkChatlistInvite) and filtered as specified in the [documentation](https://core.telegram.org/api/folders#shared-folders).

$400, FilterIncludeEmptyError
$400, InviteSlugEmptyError
$400, InviteSlugExpiredError
*/
chatlists.joinChatlistInvite#a6b1e39a slug:string peers:Vector<InputPeer> = Updates;

/*
Fetch new chats associated with an imported [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links). Must be invoked at most every chatlist_update_period seconds (as per the related [client configuration parameter](https://core.telegram.org/api/config#chatlist-update-period)).

@chatlist The folder

$400, FilterIdInvalidError
$400, FilterNotSupportedError
$400, InputChatlistInvalidError
*/
chatlists.getChatlistUpdates#89419521 chatlist:InputChatlist = chatlists.ChatlistUpdates;

/*
Join channels and supergroups recently added to a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@chatlist The folder
@peers List of new chats to join, fetched using [chatlists.getChatlistUpdates](https://core.telegram.org/method/chatlists.getChatlistUpdates) and filtered as specified in the [documentation](https://core.telegram.org/api/folders#shared-folders).

$400, FilterIdInvalidError
$400, FilterIncludeEmptyError
*/
chatlists.joinChatlistUpdates#e089f8f5 chatlist:InputChatlist peers:Vector<InputPeer> = Updates;

/*
Dismiss new pending peers recently added to a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links).

@chatlist The folder

$400, FilterIdInvalidError
$400, FilterNotSupportedError
*/
chatlists.hideChatlistUpdates#66e486fb chatlist:InputChatlist = Bool;

/*
Returns identifiers of pinned or always included chats from a chat folder imported using a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links), which are suggested to be left when the chat folder is deleted.

@chatlist Folder ID

$400, FilterIdInvalidError
$400, FilterNotSupportedError
*/
chatlists.getLeaveChatlistSuggestions#fdbcd714 chatlist:InputChatlist = Vector<Peer>;

/*
Delete a folder imported using a [chat folder deep link](https://core.telegram.org/api/links#chat-folder-links)

@chatlist Folder ID
@peers Also leave the specified channels and groups

$400, FilterIdInvalidError
*/
chatlists.leaveChatlist#74fae13a chatlist:InputChatlist peers:Vector<InputPeer> = Updates;

/*
Check whether we can post stories as the specified peer.

@peer The peer from which we wish to post stories.

$400, BoostsRequiredError
$400, ChatAdminRequiredError
$400, PeerIdInvalidError
$400, PremiumAccountRequiredError
$400, StoriesTooMuchError
$400, StorySendFloodMonthlyError
$400, StorySendFloodWeeklyError
*/
stories.canSendStory#c7dfdfdd peer:InputPeer = Bool;

/*
Uploads a [Telegram Story](https://core.telegram.org/api/stories).

@pinned Whether to add the story to the profile automatically upon expiration. If not set, the story will only be added to the archive, see [here](https://core.telegram.org/api/stories) for more info.
@noforwards If set, disables forwards, screenshots, and downloads.
@fwd_modified Set this flag when reposting stories with fwd_from_id+ fwd_from_id, if the media was modified before reposting.
@peer The peer to send the story as.
@media The story media.
@media_areas [Media areas](https://core.telegram.org/api/stories#media-areas) associated to the story, see [here](https://core.telegram.org/api/stories#media-areas) for more info.
@caption Story caption.
@entities [Message entities for styled text](https://core.telegram.org/api/entities), if allowed by the [stories_entities client configuration parameter](https://core.telegram.org/api/config#stories-entities).
@privacy_rules [Privacy rules](https://core.telegram.org/api/privacy) for the story, indicating who can or can't view the story.
@random_id Unique client message ID required to prevent message resending.
@period Period after which the story is moved to archive (and to the profile if pinned is set), in seconds; must be one of 6 * 3600, 12 * 3600, 86400, or 2 * 86400 for Telegram Premium users, and 86400 otherwise.
@fwd_from_id If set, indicates that this story is a repost of story with ID fwd_from_story posted by the peer in fwd_from_id.
@fwd_from_story If set, indicates that this story is a repost of story with ID fwd_from_story posted by the peer in fwd_from_id.

$400, BoostsRequiredError
$400, ImageProcessFailedError
$400, MediaEmptyError
$400, MediaFileInvalidError
$400, MediaTypeInvalidError
$400, MediaVideoStoryMissingError
$400, PeerIdInvalidError
$400, PremiumAccountRequiredError
$400, StoriesTooMuchError
$400, StoryPeriodInvalidError
$400, VenueIdInvalidError
*/
stories.sendStory#e4e6694b flags:# pinned:flags.2?true noforwards:flags.4?true fwd_modified:flags.7?true peer:InputPeer media:InputMedia media_areas:flags.5?Vector<MediaArea> caption:flags.0?string entities:flags.1?Vector<MessageEntity> privacy_rules:Vector<InputPrivacyRule> random_id:long period:flags.3?int fwd_from_id:flags.6?InputPeer fwd_from_story:flags.6?int = Updates;

/*
Edit an uploaded [story](https://core.telegram.org/api/stories)

@peer Peer where the story was posted.
@id ID of story to edit.
@media If specified, replaces the story media.
@media_areas [Media areas](https://core.telegram.org/api/stories#media-areas) associated to the story, see [here](https://core.telegram.org/api/stories#media-areas) for more info.
@caption If specified, replaces the story caption.
@entities [Message entities for styled text in the caption](https://core.telegram.org/api/entities), if allowed by the [stories_entities client configuration parameter](https://core.telegram.org/api/config#stories-entities).
@privacy_rules If specified, alters the [privacy settings](https://core.telegram.org/api/privacy) of the story, changing who can or can't view the story.

$400, PeerIdInvalidError
$400, StoryNotModifiedError
*/
stories.editStory#b583ba46 flags:# peer:InputPeer id:int media:flags.0?InputMedia media_areas:flags.3?Vector<MediaArea> caption:flags.1?string entities:flags.1?Vector<MessageEntity> privacy_rules:flags.2?Vector<InputPrivacyRule> = Updates;

/*
Deletes some posted [stories](https://core.telegram.org/api/stories).

@peer Channel/user from where to delete stories.
@id IDs of stories to delete.

$400, PeerIdInvalidError
$400, StoryIdEmptyError
*/
stories.deleteStories#ae59db5f peer:InputPeer id:Vector<int> = Vector<int>;

/*
Pin or unpin one or more stories

@peer Peer where to pin or unpin stories
@id IDs of stories to pin or unpin
@pinned Whether to pin or unpin the stories

$400, PeerIdInvalidError
*/
stories.togglePinned#9a75a1ef peer:InputPeer id:Vector<int> pinned:Bool = Vector<int>;

/*
Fetch the List of active (or active and hidden) stories, see [here](https://core.telegram.org/api/stories#watching-stories) for more info on watching stories.

@next If next and state are both set, uses the passed state to paginate to the next results; if neither state nor next are set, fetches the initial page; if state is set and next is not set, check for changes in the active/hidden peerset, see [here](https://core.telegram.org/api/stories#watching-stories) for more info on the full flow.
@hidden If set, fetches the hidden active story list, otherwise fetches the active story list, see [here](https://core.telegram.org/api/stories#watching-stories) for more info on the full flow.
@state If next and state are both set, uses the passed state to paginate to the next results; if neither state nor next are set, fetches the initial page; if state is set and next is not set, check for changes in the active/hidden peerset, see [here](https://core.telegram.org/api/stories#watching-stories) for more info on the full flow.
*/
stories.getAllStories#eeb0d625 flags:# next:flags.1?true hidden:flags.2?true state:flags.0?string = stories.AllStories;

/*
Fetch the [stories](https://core.telegram.org/api/stories#pinned-or-archived-stories) pinned on a peer's profile.

@peer Peer whose pinned stories should be fetched
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, PeerIdInvalidError
$400, UserIdInvalidError
*/
stories.getPinnedStories#5821a5dc peer:InputPeer offset_id:int limit:int = stories.Stories;

/*
Fetch the [story archive](https://core.telegram.org/api/stories#pinned-or-archived-stories) of a peer we control.

@peer Peer whose archived stories should be fetched
@offset_id [Offsets for pagination, for more info click here](https://core.telegram.org/api/offsets)
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, ChatAdminRequiredError
$400, PeerIdInvalidError
*/
stories.getStoriesArchive#b4352016 peer:InputPeer offset_id:int limit:int = stories.Stories;

/*
Obtain full info about a set of [stories](https://core.telegram.org/api/stories) by their IDs.

@peer Peer where the stories were posted
@id Story IDs

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, PeerIdInvalidError
$400, StoriesNeverCreatedError
$400, StoryIdEmptyError
*/
stories.getStoriesByID#5774ca74 peer:InputPeer id:Vector<int> = stories.Stories;

/*
Hide the active stories of a specific peer, preventing them from being displayed on the action bar on the homescreen.

@hidden Whether to hide or unhide all active stories of the peer
*/
stories.toggleAllStoriesHidden#7c2557c4 hidden:Bool = Bool;

/*
Mark all stories up to a certain ID as read, for a given peer; will emit an [updateReadStories](https://core.telegram.org/constructor/updateReadStories) update to all logged-in sessions.

@peer The peer whose stories should be marked as read.
@max_id Mark all stories up to and including this ID as read

$400, MaxIdInvalidError
$400, PeerIdInvalidError
$400, StoriesNeverCreatedError
*/
stories.readStories#a556dac8 peer:InputPeer max_id:int = Vector<int>;

/*
Increment the view counter of one or more stories.

@peer Peer where the stories were posted.
@id IDs of the stories (maximum 200 at a time).

$400, PeerIdInvalidError
$400, StoryIdEmptyError
*/
stories.incrementStoryViews#b2028afb peer:InputPeer id:Vector<int> = Bool;

/*
Obtain the list of users that have viewed a specific [story we posted](https://core.telegram.org/api/stories)

@just_contacts Whether to only fetch view reaction/views made by our [contacts](https://core.telegram.org/api/contacts)
@reactions_first Whether to return [storyView](https://core.telegram.org/constructor/storyView) info about users that reacted to the story (i.e. if set, the server will first sort results by view date as usual, and then also additionally sort the list by putting [storyView](https://core.telegram.org/constructor/storyView)s with an associated reaction first in the list). Ignored if forwards_first is set.
@forwards_first If set, returns forwards and reposts first, then reactions, then other views; otherwise returns interactions sorted just by interaction date.
@peer Peer where the story was posted
@q Search for specific peers
@id Story ID
@offset Offset for pagination, obtained from [stories.storyViewsList](https://core.telegram.org/constructor/stories.storyViewsList). next_offset
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, PeerIdInvalidError
$400, StoryIdInvalidError
*/
stories.getStoryViewsList#7ed23c57 flags:# just_contacts:flags.0?true reactions_first:flags.2?true forwards_first:flags.3?true peer:InputPeer q:flags.1?string id:int offset:string limit:int = stories.StoryViewsList;

/*
Obtain info about the view count, forward count, reactions and recent viewers of one or more [stories](https://core.telegram.org/api/stories).

@peer Peer whose stories should be fetched
@id Story IDs

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, PeerIdInvalidError
$400, StoryIdEmptyError
*/
stories.getStoriesViews#28e16cc8 peer:InputPeer id:Vector<int> = stories.StoryViews;

/*
Generate a [story deep link](https://core.telegram.org/api/links#story-links) for a specific story

@peer Peer where the story was posted
@id Story ID

$400, PeerIdInvalidError
$400, StoryIdEmptyError
$400, UserPublicMissingError
*/
stories.exportStoryLink#7b8def20 peer:InputPeer id:int = ExportedStoryLink;

/*
Report a story.

@peer The peer that uploaded the story.
@id IDs of the stories to report.
@option Menu option, intially empty
@message Comment for report moderation

$400, PeerIdInvalidError
*/
stories.report#19d8eb45 peer:InputPeer id:Vector<int> option:bytes message:string = ReportResult;

/*
Activates [stories stealth mode](https://core.telegram.org/api/stories#stealth-mode), see [here](https://core.telegram.org/api/stories#stealth-mode) for more info.

@past Whether to erase views from any stories opened in the past [stories_stealth_past_period seconds](https://core.telegram.org/api/config#stories-stealth-past-period), as specified by the [client configuration](https://core.telegram.org/api/config#client-configuration).
@future Whether to hide future story views for the next [stories_stealth_future_period seconds](https://core.telegram.org/api/config#stories-stealth-future-period), as specified by the [client configuration](https://core.telegram.org/api/config#client-configuration).

$400, PremiumAccountRequiredError
*/
stories.activateStealthMode#57bbd166 flags:# past:flags.0?true future:flags.1?true = Updates;

/*
React to a story.

@add_to_recent Whether to add this reaction to the [recent reactions list](https://core.telegram.org/api/reactions#recent-reactions).
@peer The peer that sent the story
@story_id ID of the story to react to
@reaction Reaction

$400, PeerIdInvalidError
$400, ReactionInvalidError
$400, StoryIdEmptyError
$400, StoryIdInvalidError
*/
stories.sendReaction#7fd736b2 flags:# add_to_recent:flags.0?true peer:InputPeer story_id:int reaction:Reaction = Updates;

/*
Fetch the full active [story list](https://core.telegram.org/api/stories#watching-stories) of a specific peer.

@peer Peer whose stories should be fetched

$400, ChannelInvalidError
$400, ChannelPrivateError
$400, MsgIdInvalidError
$400, PeerIdInvalidError
*/
stories.getPeerStories#2c4ada50 peer:InputPeer = stories.PeerStories;

/*
Obtain the latest read story ID for all peers when first logging in, returned as a list of [updateReadStories](https://core.telegram.org/constructor/updateReadStories) updates, see [here](https://core.telegram.org/api/stories#watching-stories) for more info.
*/
stories.getAllReadPeerStories#9b5ae7f9 = Updates;

/*
Get the IDs of the maximum read stories for a set of peers.

@id Peers
*/
stories.getPeerMaxIDs#535983c3 id:Vector<InputPeer> = Vector<int>;

/*
Obtain a list of channels where the user can post [stories](https://core.telegram.org/api/stories)
*/
stories.getChatsToSend#a56a8b60 = messages.Chats;

/*
Hide the active stories of a user, preventing them from being displayed on the action bar on the homescreen, see [here](https://core.telegram.org/api/stories#hiding-stories-of-other-users) for more info.

@peer Peer whose stories should be (un)hidden.
@hidden Whether to hide or unhide stories.

$400, PeerIdInvalidError
*/
stories.togglePeerStoriesHidden#bd0415c4 peer:InputPeer hidden:Bool = Bool;

/*
Get the [reaction](https://core.telegram.org/api/reactions) and interaction list of a [story](https://core.telegram.org/api/stories) posted to a channel, along with the sender of each reaction.

@forwards_first If set, returns forwards and reposts first, then reactions, then other views; otherwise returns interactions sorted just by interaction date.
@peer Channel
@id [Story](https://core.telegram.org/api/stories) ID
@reaction Get only reactions of this type
@offset Offset for pagination (taken from the next_offset field of the returned [stories.StoryReactionsList](https://core.telegram.org/type/stories.StoryReactionsList)); empty in the first request.
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, PeerIdInvalidError
*/
stories.getStoryReactionsList#b9b2881f flags:# forwards_first:flags.2?true peer:InputPeer id:int reaction:flags.0?Reaction offset:flags.1?string limit:int = stories.StoryReactionsList;

/*
Pin some stories to the top of the profile, see [here](https://core.telegram.org/api/stories#pinned-or-archived-stories) for more info.

@peer Peer where to pin stories.
@id IDs of the stories to pin (max [stories_pinned_to_top_count_max](https://core.telegram.org/api/config#stories-pinned-to-top-count-max)).

$400, PeerIdInvalidError
$400, StoryIdInvalidError
*/
stories.togglePinnedToTop#b297e9b peer:InputPeer id:Vector<int> = Bool;

/*
Globally search for [stories](https://core.telegram.org/api/stories) using a hashtag or a [location media area](https://core.telegram.org/api/stories#location-tags), see [here](https://core.telegram.org/api/stories#searching-stories) for more info on the full flow.

@hashtag Hashtag (without the #)
@area A [mediaAreaGeoPoint](https://core.telegram.org/constructor/mediaAreaGeoPoint) or a [mediaAreaVenue](https://core.telegram.org/constructor/mediaAreaVenue).  Note [mediaAreaGeoPoint](https://core.telegram.org/constructor/mediaAreaGeoPoint) areas may be searched only if they have an associated address.
@peer If set, returns only stories posted by this peer.
@offset Offset for [pagination](https://core.telegram.org/api/offsets): initially an empty string, then the next_offset from the previously returned [stories.foundStories](https://core.telegram.org/constructor/stories.foundStories).
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, HashtagInvalidError
*/
stories.searchPosts#d1810907 flags:# hashtag:flags.0?string area:flags.1?MediaArea peer:flags.2?InputPeer offset:string limit:int = stories.FoundStories;

/*
Obtains info about the boosts that were applied to a certain channel or supergroup (admins only)

@gifts Whether to return only info about boosts received from [gift codes and giveaways created by the channel/supergroup](https://core.telegram.org/api/giveaways)
@peer The channel/supergroup
@offset Offset for pagination, obtained from [premium.boostsList](https://core.telegram.org/constructor/premium.boostsList). next_offset
@limit Maximum number of results to return, [see pagination](https://core.telegram.org/api/offsets)

$400, ChatAdminRequiredError
$400, PeerIdInvalidError
*/
premium.getBoostsList#60f67660 flags:# gifts:flags.0?true peer:InputPeer offset:string limit:int = premium.BoostsList;

/*
Obtain which peers are we currently [boosting](https://core.telegram.org/api/boost), and how many [boost slots](https://core.telegram.org/api/boost) we have left.
*/
premium.getMyBoosts#be77b4a = premium.MyBoosts;

/*
Apply one or more [boosts](https://core.telegram.org/api/boost) to a peer.

@slots Which [boost slots](https://core.telegram.org/api/boost) to assign to this peer.
@peer The peer to boost.

$400, BoostsEmptyError
$400, PeerIdInvalidError
$400, SlotsEmptyError
*/
premium.applyBoost#6b7da746 flags:# slots:flags.0?Vector<int> peer:InputPeer = premium.MyBoosts;

/*
Gets the current [number of boosts](https://core.telegram.org/api/boost) of a channel/supergroup.

@peer The peer.

$400, ChannelInvalidError
$400, PeerIdInvalidError
*/
premium.getBoostsStatus#42f1f61 peer:InputPeer = premium.BoostsStatus;

/*
Returns the lists of boost that were applied to a channel/supergroup by a specific user (admins only)

**Bots can use this method**

@peer The channel/supergroup
@user_id The user

$400, PeerIdInvalidError
*/
premium.getUserBoosts#39854d1f peer:InputPeer user_id:InputUser = premium.BoostsList;

/*
Check if we can process SMS jobs (official clients only).
*/
smsjobs.isEligibleToJoin#edc39d0 = smsjobs.EligibilityToJoin;

/*
Enable SMS jobs (official clients only).
*/
smsjobs.join#a74ece2d = Bool;

/*
Disable SMS jobs (official clients only).
*/
smsjobs.leave#9898ad73 = Bool;

/*
Update SMS job settings (official clients only).

@allow_international Allow international numbers?

$400, NotJoinedError
*/
smsjobs.updateSettings#93fa0bf flags:# allow_international:flags.0?true = Bool;

/*
Get SMS jobs status (official clients only).
*/
smsjobs.getStatus#10a698e8 = smsjobs.Status;

/*
Get info about an SMS job (official clients only).

@job_id Job ID

$400, SmsjobIdInvalidError
*/
smsjobs.getSmsJob#778d902f job_id:string = SmsJob;

/*
Finish an SMS job (official clients only).

@job_id Job ID.
@error If failed, the error.

$400, SmsjobIdInvalidError
*/
smsjobs.finishJob#4f1ebf24 flags:# job_id:string error:flags.0?string = Bool;

/*
Fetch information about a [fragment collectible, see here](https://core.telegram.org/api/fragment#fetching-info-about-fragment-collectibles) for more info on the full flow.

@collectible Collectible to fetch info about.

$400, CollectibleInvalidError
$400, CollectibleNotFoundError
*/
fragment.getCollectibleInfo#be1e85ba collectible:InputCollectible = fragment.CollectibleInfo;

// @layer 199