/*
 *	| |    | |  \ \  / /  | |    | |   / _______|
 *	| |____| |   \ \/ /   | |____| |  / /
 *	| |____| |    \  /    | |____| |  | |   _____
 * 	| |    | |    /  \    | |    | |  | |  |____ |
 *  | |    | |   / /\ \   | |    | |  \ \______| |
 *  | |    | |  /_/  \_\  | |    | |   \_________|
 *
 * Copyright (c) 2011 ~ 2015 Shenzhen HXHG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <JMessage/JMSGConstants.h>

@class JMSGMessage;
@class JMSGAbstractContent;
@class JMSGImageContent;

/*!
 @typedef
 @abstract 会话类型 - 单聊、群聊
 */
typedef NS_ENUM(NSInteger, JMSGConversationType) {
  kJMSGConversationTypeSingle = 1,
  kJMSGConversationTypeGroup = 2,
};

/*!
 @typedef
 @abstract 消息内容类型 - 文本、语音、图片等
 */
typedef NS_ENUM(NSInteger, JMSGContentType) {
  kJMSGContentTypeUnknown = 0,  // 文本消息（不知道类型的消息）
  kJMSGContentTypeText,         // 文本消息
  kJMSGContentTypeImage,        // 图片消息
  kJMSGContentTypeVoice,        // 语音消息
  kJMSGContentTypeCustom,       // 自定义消息
  kJMSGContentTypeEventNotification, // 事件通知消息。服务器端下发的事件通知，本地展示为这个类型的消息展示出来
  kJMSGContentTypeTime,         // 会话时间。UI 层可用于展示会话时间。SDK 暂未做处理。
};

/*!
 @typedef
 @abstract 消息状态
 */
typedef NS_ENUM(NSInteger, JMSGMessageStatus) {
  /// Send Message
  kJMSGMessageStatusSendDraft = 0,
  kJMSGMessageStatusSending = 1,
  kJMSGMessageStatusSendUploadSucceed = 2,
  kJMSGMessageStatusSendUploadFailed = 3,
  kJMSGMessageStatusSendFailed = 4,
  kJMSGMessageStatusSendSucceed = 5,
  /// Received Message
  kJMSGMessageStatusReceiving = 6,
  kJMSGMessageStatusReceiveDownloadFailed = 7,
  kJMSGMessageStatusReceiveSucceed = 8,
};

/// FIXME:这个应该要删除掉
typedef NS_ENUM(NSInteger, JMSGMessageMetaType) {
  kJMSGMetaSendType,
  kJMSGMetaReceiveType,
  kJMSGMetaAvatarType,
};

/*!
 @typedef
 @abstract 上传文件的类型
 */
typedef NS_ENUM(NSInteger, JMSGFileType) {
  kJMSGFileTypeUnknown,
  kJMSGFileTypeImage,
  kJMSGFileTypeVoice,
};


@interface JMSGConversation : NSObject

///----------------------------------------------------
/// @name Conversation Operations 会话相关操作（类方法）
///----------------------------------------------------


/*!
 @abstract 获取单聊会话

 @param username 单聊对象 username

 @discussion 如果会话还不存在，则返回 nil
 */
+ (JMSGConversation *)singleConversationWithUsername:(NSString *)username;

/*!
 @abstract 获取群聊会话

 @param groupId 群聊群组ID。此 ID 由创建群组时返回的。

 @discussion 如果会话还不存在，则返回 nil
 */
+ (JMSGConversation *)groupConversationWithGroupId:(NSString *)groupId;

/*!
 @abstract 创建单聊会话（异步）

 @param username 单聊对象 username
 @param handler 结果回调。正常返回时 resultObject 类型为 JMSGConversation。

 @discussion 如果会话已经存在，则直接返回。如果不存在则创建。
 创建会话时如果发现该 username 的信息本地还没有，则需要从服务器上拉取。
 服务器端如果找不到该 username，或者某种原因查找失败，则创建会话失败。
 */
+ (void)createSingleConversationWithUsername:(NSString *)username
                           completionHandler:(JMSGCompletionHandler)handler;

/*!
 @abstract 创建群聊会话（异步）

 @param groupId 群聊群组ID。由创建群组时返回。
 @param handler 结果回调。正常返回时 resultObject 类型为 JMSGConversation。

 @discussion 如果会话已经存在，则直接返回。如果不存在则创建。
 创建会话时如果发现该 groupId 的信息本地还没有，则需要从服务器端上拉取。
 如果从服务器上获取 groupId 的信息不存在或者失败，则创建会话失败。
 */
+ (void)createGroupConversationWithGroupId:(NSString *)groupId
                         completionHandler:(JMSGCompletionHandler)handler;

/*!
 @abstract 删除单聊会话

 @param username 单聊用户名

 @discussion 除了删除会话本身，还会删除该会话下所有的聊天消息。
 */
+ (BOOL)deleteSingleConversationWithUsername:(NSString *)username;

/*!
 @abstract 删除群聊会话

 @param groupId 群聊群组ID

 @discussion 除了删除会话本身，还会删除该会话下所有的聊天消息。
 */
+ (BOOL)deleteGroupConversationWithGroupId:(NSString *)groupId;

/*!
 @abstract 返回 conversation 列表（异步）

 @param handler 结果回调。正常返回时 resultObject 的类型为 NSArray，数组里成员的类型为 JMSGConversation

 @discussion 当前是返回所有的 conversation 列表。
 我们设计上充分考虑到性能问题，数据库无关联表查询，性能应该不会差。
 但考虑到潜在的性能问题可能，此接口还是异步返回
 */
+ (void)allConversations:(JMSGCompletionHandler)handler;



///----------------------------------------------------------
/// @name Conversation Basic Properties 会话基本属性：用于会话列表
///----------------------------------------------------------

/*!
 @abstract 会话标题
 @discussion 会话头像应通过 avatarData: 方法异步去获取。
 */
@property(nonatomic, strong, readonly) NSString *title;

/*!
 @abstract 最后一条消息
 */
@property(nonatomic, strong, readonly) JMSGMessage *latestMessage;

/**
* 未读数
*/
@property(nonatomic, strong, readonly) NSNumber *unreadCount;

///--------------------------------------------------------
/// @name Conversation Extend Properties 会话扩展属性：用于聊天
///--------------------------------------------------------

/*!
 @abstract 会话类型 - 单聊，群聊
 @discussion 详细定义见 JMSGConversationType
 */
@property(nonatomic, assign, readonly) JMSGConversationType conversationType;

/*!
 @abstract 聊天对象
 @discussion 需要根据会话类型转型。单聊时转型为 JMSGUser，群聊时转型为 JMSGGroup
 */
@property(nonatomic, strong, readonly) id target;



///----------------------------------------------------
/// @name Message Operations 消息相关操作（实例方法）
///----------------------------------------------------

/*!
 @abstract 获取某条消息

 @param messageId 消息ID

 @discussion 这个接口在正常场景下不需要单独使用到。
 */
- (JMSGMessage *)messageWithMessageId:(NSString *)messageId;

/*!
 @abstract 同步分页获取最新的消息

 @offset 开始的位置。nil 表示从最初开始。
 @limit 获取的数量。nil 表示不限。

 @return 返回消息列表（数组）。数组成员的类型是 JMSGMessage*

 @discussion 排序规则是：最新
 参数举例：
 - offset = nil, limit = nil，表示获取全部。相当于 allMessages。
 - offset = nil, limit = 100，表示从最新开始取 100 条记录。
 - offset = 100, limit = nil，表示从最新第 100 条开始，获取余下所有记录。
 */
- (NSArray *)messageArrayFromNewestWithOffset:(NSNumber *)offset
                                        limit:(NSNumber *)limit;

/*!
 @abstract 异步获取所有消息记录

 @param handler 结果回调。正常返回时 resultObject 类型为 NSArray，数据成员类型为 JMSGConversation 。

 @discussion 排序规则：最新
 */
- (void)allMessages:(JMSGCompletionHandler)handler;

/*!
 @abstract 删除全部消息

 @discussion 清空当前会话的所有消息。
 */
- (BOOL)deleteAllMessages;

/*!
 @abstract 创建消息对象

 @param content 消息的内容对象。当前直接的内容对象有:
  JMSGTextContent, JMSGImageContent, JMSGVoiceContent, JMSGCustomContent

 @return JMSGMessage对象。该对象里包含了 content。

 @discussion 这是推荐的创建新的消息拿到 JMSGMessage 对象接口。

 此接口只是内存里创建对象，不会导致消息存储、文件落地保存的行为。发送消息时才会进行消息保存、文件落地。

 调用此接口前需要创建消息内容，以作为 content 参数传入。举例：

 NSData *imageData = … (可能来自拍照或者相册）
 JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:imageData];

 另外更快捷的作法是，不通过此接口创建 JMSGMessage 而是直接调用具体的发送接口，如 sendSingleTextMessage.

 通过此接口先创建 JMSGMessage 的好处是，可以对 JMSGMessage 做更多的定制控制，比如加附加字段。举例：

 [imageContent addExtraValue:@"extra_value" forKey:@"extra_key"]

 注意：如果创建消息的内容是图片，并且图片可能比较大，则建议不要使用这个同步接口，改用 #createMessageForImageAysnc。
 */
- (JMSGMessage *)createMessageWithContent:(JMSGAbstractContent *)content;

/*!
 @abstract 创建消息对象（图片，异步）

 @param content 准备好的图片内容

 @return JMSGMessage对象。该对象包含了 content。

 @discussion 对于图片消息，因为 SDK 要做缩图有一定的性能损耗，图片文件很大时存储落地也会较慢。所以创建图片消息，建议使用这个异步接口。
 */
- (void)createMessageAyncWithImageContent:(JMSGImageContent *)content
                        completionHandler:(JMSGCompletionHandler)handler;

/*!
 @abstract 发送消息（已经创建好对象的）

 @param message 通过消息创建类接口，创建好的消息对象

 @discussion 发送消息的多个接口，都未在方法上直接提供回调。你应通过 xxx 方法来注册消息发送结果。
 */
- (void)sendMessage:(JMSGMessage *)message;

/*!
 @abstract 发送文本消息
 @param text 文本消息内容
 @discussion 快捷发消息接口。如果发送文本消息不需要附加 extra，则使用此接口更方便。
 */
- (void)sendTextMessage:(NSString *)text;

/*!
 @abstract 发送图片消息
 @param imageData 图片消息数据
 @discussion 快捷发送消息接口。如果发送图片消息不需要附加 extra，则使用此接口更方便。
 */
- (void)sendImageMessage:(NSData *)imageData;

/*!
 @abstract 发送语音消息
 @param voiceData 语音消息数据
 @param duration 语音消息时长（秒）
 @discussion 快捷发送消息接口。如果发送语音消息不需要附加 extra，则使用此接口更方便。
 */
- (void)sendVoiceMessage:(NSData *)voiceData
                duration:(NSNumber *)duration;



///----------------------------------------------------
/// @name Conversation State Maintenance 会话状态维护（实例方法）
///----------------------------------------------------

/*!
 @abstract 清除会话未读数

 @discussion 把未读数设置为 0
 */
- (void)clearUnreadCount;

/*!
 @abstract 判断消息是否属于这个 Conversation

 @discussion 当前在聊天界面时，接收到消息通知，需要通过这个接口判断该消息是否属于当前这个会话，从而做不同的动作

 如果注册消息接收事件时，只注册接收当前会话的消息，则一般这个接口使用不上。
 */
- (BOOL)isMessageForThisConversation:(JMSGMessage *)message;

/*!
 @abstract 从服务器端刷新会话信息

 @discussion 会话信息的 title/avatarPath 对于单聊来自于 UserInfo，对于群聊来自于 GroupInfo。
 建议在进入聊天界面时，调用此接口，来更新会话界面。 如果有更新，SDK 会发出 JMSGConversationInfoChangedNotification

 此接口供暂时使用。JMessage 整体的 Sync 机制生效后，将不需要客户端主动去刷新信息。
 */
- (void)refreshFromServer;

/*!
 @abstract 异步获取会话头像

 @param handler 结果回调。正常返回时 resultObject 的类型是 NSData，即头像的数据。

 @discussion SDK会自动做一些策略，比如缓存。
 */
- (void)avatarData:(JMSGCompletionHandler)handler;



///----------------------------------------------------
/// @name Class Normal 类基本方法
///----------------------------------------------------

- (BOOL)isEqualToConversation:(JMSGConversation *)conversation;

@end
