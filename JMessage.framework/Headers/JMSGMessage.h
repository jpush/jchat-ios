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
#import <UIKit/UIKit.h>
#import <JMessage/JMSGConstants.h>
#import <JMessage/JMSGConversation.h>

@class JMSGAbstractContent;
@class JMSGUser;
@protocol JMSGTargetProtocol;

/*!
 * @abstract 消息
 *
 * @discussion 本类 JMSGMessage 是 JMessage SDK 里的消息实体。
 * 收到的消息、发送的消息、获取历史消息，其中的消息类，都是这个 JMSGMessage。
 *
 * 以下分别描述消息相关主要使用场景。
 *
 * ### 获取历史消息
 *
 * 先基于聊天对象ID与会话类型，拿到会话对象，然后调用会话对象里的 allMessages: 获取到某会话的全部历史消息列表。
 *
 * ### 展示一条消息
 *
 * 发送者、接收者等基本属性都有相应的属性。消息内容则在一个 content 对象里，访问时先通过 contentType 拿到内容类型，
 * 然后把 content 转型为相应的具体内容类型，再进一步可拿到具体的信息。

 *    JMSGTextContent *textContent = (JMSGTextContent *)message.content;
 *    NSString *msgText = textContent.text;
 *
 * ### 接收消息
 *
 *
 * ### 发送消息
 *
 */
@interface JMSGMessage : NSObject <NSCopying, NSCoding>

JMSG_ASSUME_NONNULL_BEGIN

///----------------------------------------------------
/// @name Class APIs 类方法 - 创建与发送消息
///----------------------------------------------------

/*!
 * @abstract 创建单聊消息（快捷接口）
 *
 * @param content 消息内容对象
 * @param username 单聊用户 username
 *
 * @discussion 不关心会话时的直接创建聊天消息的接口。一般建议使用 JMSGConversation -> createMessageWithContent:
 */
+ (JMSGMessage *)createSingleMessageWithContent:(JMSGAbstractContent *)content
                                       username:(NSString *)username;

/*!
 * @abstract 创建群聊消息
 *
 * @param content 消息内容对象
 * @param groupId 群聊ID
 *
 * @discussion 不关心会话时的直接创建聊天消息的接口。一般建议使用 JMSGConversation -> createMessageWithContent:
 */
+ (JMSGMessage *)createGroupMessageWithContent:(JMSGAbstractContent *)content
                                       groupId:(NSString *)groupId;

/*!
 * @abstract 发送消息（已经创建好的）
 *
 * @message 消息对象。
 *
 * @discussion 此接口与 createMessage:: 相关接口配合使用，创建好后使用此接口发送。
 */
+ (void)sendMessage:(JMSGMessage *)message;

/*!
 * @abstract 发送单聊文本消息
 *
 * @param text 文本内容
 * @param username 单聊对象 username
 *
 * @discussion 快捷方法，不需要先创建消息而直接发送。
 */
+ (void)sendSingleTextMessage:(NSString *)text
                     username:(NSString *)username;

/*!
 * @abstract 发送单聊图片消息
 *
 * @param imageData 图片数据
 * @param username 单聊对象 username
 *
 * @discussion 快捷方法，不需要先创建消息而直接发送。
 */
+ (void)sendSingleImageMessage:(NSData *)imageData
                      username:(NSString *)username;

/*!
 * @abstract 发送单聊语音消息
 *
 * @param voiceData 语音数据
 * @param duration 语音时长
 * @param username 单聊对象 username
 *
 * @discussion 快捷方法，不需要先创建消息而直接发送。
 */
+ (void)sendSingleVoiceMessage:(NSData *)voiceData
                 voiceDuration:(NSNumber *)duration
                      username:(NSString *)username;

/*!
 * @abstract 发送群聊文本消息
 *
 * @param text 文本内容
 * @param username 单聊对象 username
 *
 * @discussion 快捷方法，不需要先创建消息而直接发送。
 */
+ (void)sendGroupTextMessage:(NSString *)text
                     groupId:(NSString *)groupId;

/*!
 * @abstract 发送群聊图片消息
 *
 * @param imageData 图片数据
 * @param username 单聊对象 username
 *
 * @discussion 快捷方法，不需要先创建消息而直接发送。
 */
+ (void)sendGroupImageMessage:(NSData *)imageData
                      groupId:(NSString *)groupId;

/*!
 * @abstract 发送群聊语音消息
 *
 * @param voiceData 语音数据
 * @param duration 语音时长
 * @param username 单聊对象 username
 *
 * @discussion 快捷方法，不需要先创建消息而直接发送。
 */
+ (void)sendGroupVoiceMessage:(NSData *)voiceData
                voiceDuration:(NSNumber *)duration
                      groupId:(NSString *)groupId;




///----------------------------------------------------
/// @name Message basic fields 消息基本属性
///----------------------------------------------------


/*!
 * 消息ID：这个ID是本地存数据库生成的ID，不是服务器端下发时的ID。
 */
@property(nonatomic, strong, readonly) NSString *msgId;

/*!
 * @abstract 服务器端下发的消息ID
 */
@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE serverMessageId;

/*!
 * @abstract 消息发送对象
 * @discussion 收到的消息，target 就是我自己。
 * 发送的消息，target 是我的聊天对象。单聊是对方用户，群聊是当前的群。
 */
@property(nonatomic, strong, readonly) id<JMSGTargetProtocol> target;

/*!
 *
 */
@property(nonatomic, strong, readonly) JMSGUser *fromUser;

/*!
 * @abstract 消息来源
 * @discussion 默认的用户之间互发消息，其值是 "user"。如果是 App 管理员下发的消息，是 "admin"
 */
@property(nonatomic, strong, readonly) NSString *fromType;

/*!
 * @abstract 消息的内容类型
 */
@property(nonatomic, assign, readonly) JMSGContentType contentType;

/*!
 * @abstract 消息内容对象
 * @discussion 使用时应通过 contentType 先获取到具体的消息类型，然后转型到相应的具体类。
 */
@property(nonatomic, copy, readonly) JMSGAbstractContent * JMSG_NULLABLE content;

/*!
 * @abstract 消息发出的时间戳
 * @discussion 这是服务器端下发消息时的真实时间戳
 */
@property(nonatomic, strong, readonly) NSNumber *timestamp;


///----------------------------------------------------
/// @name Message addOn fields 消息附加属性
///----------------------------------------------------

/*!
 * @abstract 聊天类型。当前支持的类型：单聊，群聊
 */
@property(nonatomic, assign, readonly) JMSGConversationType targetType;

/*!
 * @abstract 消息状态
 * @discussion 一条发出的消息，或者收到的消息，有多个状态会下。具体定义参考 JMSGMessageStatus 的定义。
 */
@property(nonatomic, assign, readonly) JMSGMessageStatus status;

/*!
 * @abstract 当前的消息是不是收到的。
 *
 * @discussion 是收到的，则是别人发给我的。UI 上一般展示在左侧。
 * 如果不是收到侧的，则是发送侧的，是我对外发送的。
 *
 * 主要是在聊天界面展示消息列表时，需要使用此方法，来确认展示消息的方式与位置。
 * 展示时需要发送方消息，不管是收到侧还是发送侧，都可以使用 fromUser 对象。
 */
@property(nonatomic, assign, readonly) BOOL isReceived;

/*!
 * @abstract 消息标志
 *
 * @discussion 这是一个用于表示消息状态的标识字段, App 可自由使用, SDK 不做变更.
 * 默认值为 0, App 有需要时可更新此状态.
 *
 * 使用场景:
 *
 * 1. 语音消息有一个未听标志. 默认 0 表示未读, 已读时 App 更新为 1 或者其他.
 * 2. 某些 App 需要对一条消息做送达, 已读标志, 可借用这个字段.
 */
@property(nonatomic, strong, readonly) NSNumber *flag;

/*!
 * @abstract 上传资源文件progress绑定(用来监听上传progress回调)
 */
@property(nonatomic, copy)JMSGMediaUploadProgressHandler JMSG_NULLABLE uploadHandler;


///----------------------------------------------------
/// @name Instance APIs 实例方法
///----------------------------------------------------

/*!
 * @abstract 默认的 init 方法不可用
 *
 * @discussion 如果已经得到 JMSGConversation 实例, 则可用以下方法来创建对象:
 *
 * - conversation -> createMessageWithContent:
 * - conversation -> createMessageAsyncWithImageContent::
 *
 * 或者不创建 JMSGMessage 实例也可以直接发送消息. 请参考 JMSGConversation 里相关方法.
 *
 * 如果你的 App 不依赖 JMSGConversation 实例, 也可以直接调用 JMSGMessage 里的类方法
 * 来创建 JMSGMessage 实例:
 *
 * - JMSGMessage -> createSingleMessageWithContent:
 * - JMSGMessage -> createGroupMessageWithContent:
 *
 * 或者直接也可以调用 JMSGMessage 类方法发消息而不必创建 JMSGMessage 对象.
 */
- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 设置该消息的 fromName
 *
 * @discussion 该信息填充在发出的消息里. 对方收到 Notification 时的提示的消息发送人, 也用此字段.
 *
 * JMessage SDK 内部默认从 Profile -> nickname 去获取到 fromName 信息, 不存在时使用 username.
 * 如果集成此 SDK 没有设置用户信息的 nickname, 则对方收到通知时显示的消息发送人就显示的是 username.
 * 这时可以创建 JMSGMessage 对象后, 调用此方法来设置 fromName.
 *
 * 本设置会覆盖默认的 Profile -> nickname 规则.
 */
- (void)setFromName:(NSString * JMSG_NULLABLE)displayName;

/*!
 * @abstract 更新消息标志
 *
 * @param 为 nil 时表示设置为 0.
 *
 * @discussion 参考 flag property 的说明.
 */
- (void)updateFlag:(NSNumber * JMSG_NULLABLE)flag;

/*!
 * @abstract 消息对象转换为 JSON 字符串的表示。
 *
 * @discussion 遵循 Message JSON 协议的定义。
 */
- (NSString *)toJsonString;

/*!
 * @abstract 对象比较
 */
- (BOOL)isEqualToMessage:(JMSGMessage * JMSG_NULLABLE)message;

JMSG_ASSUME_NONNULL_END

@end



