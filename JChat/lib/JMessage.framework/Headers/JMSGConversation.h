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

/**
* 会话变更通知(用来当SDK后台更新会话信息时刷新界面使用)
*/
extern NSString *const JMSGNotification_ConversationInfoChanged;
extern NSString *const JMSGNotification_ConversationInfoChangedKey;


/**
*  会话类型
*/
typedef NS_ENUM(NSInteger, JMSGConversationType) {
  kJMSGSingle = 0,//单聊
  kJMSGGroup,     //群聊
};

/**
*  消息的所有种类
*/
typedef NS_ENUM(NSInteger, JMSGMessageContentType) {
  kJMSGTextMessage = 0, // 文本消息
  kJMSGImageMessage,    // 图片消息
  kJMSGVoiceMessage,    // 语音消息
  kJMSGCustomMessage,   // 自定义消息
  kJMSGEventMessage,    // 事件通知消息。服务器端下发的事件通知，本地展示为这个类型的消息展示出来
  kJMSGTimeMessage,     // 会话时间。UI 层可用于展示会话时间。SDK 暂未做处理。
};

/**
*  消息状态
*/
typedef NS_ENUM(NSInteger, JMSGMessageStatusType) {
  kJMSGStatusNone = 0,
  kJMSGStatusSendSucceed,
  kJMSGStatusSendFail,
  kJMSGStatusSending,
  kJMSGStatusUploadSucceed,
  kJMSGStatusSendDraft,
  kJMSGStatusReceiving,
  kJMSGStatusReceiveSucceed,
  kJMSGStatusReceiveFailed,
  kJMSGStatusReceiveDownloadFailed,
};

@interface JMSGConversation : NSObject

///----------------------------------------------------
/// @name Conversation Basic Properties 会话基本属性
///----------------------------------------------------

/**
* 聊天会话ID
*/
@property(atomic, strong) NSString *Id;

/**
* 会话类型：单聊、群聊
*/
@property(assign, nonatomic) JMSGConversationType chatType;

/**
* 会话对象ID。单聊时是 username，群聊时是 groupId
*/
@property(nonatomic, strong) NSString *targetId;

/**
* 会话对象昵称。单聊时是用户的displayName，群聊时是groupName。
*/
@property(atomic, strong) NSString *targetName;

/**
* 会话头像。单聊来自于聊天对象用户头像；群聊来自于群组头像。
*/
@property(nonatomic, strong, getter=avatarThumb) NSString *avatarThumb;


///----------------------------------------------------
/// @name Last message about 最后一条消息
///----------------------------------------------------

/**
* 最后消息的类型："text"、"voice"、"image"、"event"
*/
@property(nonatomic, strong) NSString *latestType;

/**
* 最后消息的文本描述:文本消息内容、"语音"、"图片"、Event事件内容
*/
@property(nonatomic, strong) NSString *latestText;

/**
* 最后消息的时间(时间戳格式)
*/
@property(nonatomic, strong) NSString *latestDate;

/**
* 最后消息发送者
*/
@property(nonatomic, strong) NSString *latestDisplayName;


///----------------------------------------------------
/// @name Conversation State 会话状态
///----------------------------------------------------

/**
* 未读数
*/
@property(atomic, strong) NSNumber *unreadCount;

/**
* 最后一条消息发送状态
*/
@property(atomic, assign) JMSGMessageStatusType latestMessageStatus;

///----------------------------------------------------
/// @name Message Operations 消息相关操作
///----------------------------------------------------

/**
*  获取指定消息id的消息
*
*  @param messageId  消息唯一识别Id
*  @param handler    结果回调。resultObject对象类型为JMSGMessage
*
*/
- (void)getMessage:(NSString *)messageId
 completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取会话所有消息

*  @param handler    结果回调。resultObject对象类型为NSArray,使用时需要将NSArray的成员转换为JMSGMessage类型,再通过contentType属性判断消息的种类分别转换为JMSGImageMessage、JMSGVoiceMessage、JMSGContentMessage、JMSGEventMessage)
*/
- (void)getAllMessageWithCompletionHandler:(JMSGCompletionHandler)handler;


/**
*  删除会话所有消息
*
*  @param handler    结果回调。resultObject值不需要关心,始终为nil
*
*/
- (void)deleteAllMessageWithCompletionHandler:(JMSGCompletionHandler)handler;


///----------------------------------------------------
/// @name Conversation State Maintenance 会话状态维护
///----------------------------------------------------


/**
*  将会话中的未读消息数清零
*
*  @param handler    结果回调。resultObject值不需要关心,始终为nil
*
*/
- (void)resetUnreadMessageCountWithCompletionHandler:(JMSGCompletionHandler)handle;


///----------------------------------------------------
/// @name Conversation Operations 会话相关操作
///----------------------------------------------------

/**
*  获取所有会话列表
*
*  @param handler          结果回调。resultObject对象类型为NSArray(数组成员为JMSGConversation类型)
*
*/
+ (void)getConversationListWithCompletionHandler:(JMSGCompletionHandler)handler;

/**
*  获取已知的会话
*
*  @param targetId         会话对象Id(会话targetId属性)
*  @param conversationType 会话类型(单聊还是群聊)
*  @param handler          结果回调。resultObject对象类型为JMSGConversation
*
*/
+ (void)getConversation:(NSString *)targetId
               withType:(JMSGConversationType)conversationType
      completionHandler:(JMSGCompletionHandler)handler;

/**
*  创建新会话
*
*  @param targetId         会话对象Id(会话targetId属性)
*  @param conversationType 会话类型(单聊还是群聊)
*  @param handler          结果回调。resultObject对象类型为JMSGConversation
*
*/
+ (void)createConversation:(NSString *)targetId
                  withType:(JMSGConversationType)conversationType
         completionHandler:(JMSGCompletionHandler)handler;

/**
*  删除会话
*
*  @param targetId         会话对象Id(会话targetId属性)
*  @param conversationType 会话类型(单聊还是群聊)
*  @param handler          结果回调。resultObject对象类型为JMSGConversation
*
*/
+ (void)deleteConversation:(NSString *)targetId
                  withType:(JMSGConversationType)conversationType
         completionHandler:(JMSGCompletionHandler)handler;


@end
