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
#import "JMSGConversation.h"
#import "JMSGConstants.h"

@class JMSGMessage;

/**
* 会话变更通知
*/
extern NSString *const JMSGNotification_ConversationInfoChanged;
extern NSString *const JMSGNotification_ConversationInfoChangedKey;


/**
*  会话类型
*/
typedef NS_ENUM(NSInteger, JMSGConversationType) {
  kJMSGSingle = 0,
  kJMSGGroup,
};

/**
*  消息内容
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

/**
*  消息方向
*/
typedef NS_ENUM(NSInteger, JMSGMessageMetaType) {
  kJMSGMetaSendType,
  kJMSGMetaReceiveType,
  kJMSGMetaAvatarType,
};


/**
* 上传文件类型
*/
typedef NS_ENUM(NSInteger, JMSGFileType) {
  kJMSGTextFileType,
  kJMSGImageFileType,
  kJMSGVoiceFileType
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
* 会话对象昵称。单聊时是用户的 nickName，群聊时是 groupName。
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
* 最后消息的类型：文本、语音、图片
*/
@property(nonatomic, strong) NSString *latestType;

/**
* 最后消息的文本描述
*/
@property(nonatomic, strong) NSString *latestText;

/**
* 最后消息的时间
*/
@property(nonatomic, strong) NSString *latestDate;

/**
* 最后消息发言人
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
* FIXME - 这个最好不必暴露。但是 JMSGConversation.m 里有用到。
*/
@property(atomic, assign) JMSGMessageStatusType latestMessageStatus;


/**
* 该会话的表名。
*/
@property(nonatomic, strong) NSString *messageTableName;


///----------------------------------------------------
/// @name Message Operations 消息相关操作
///----------------------------------------------------

/**
*  获取指定消息id的消息
*
*  @param messageId  消息ID
*  @param handler    用户获取消息回调接口(resultObject为JMSGMessage类型)
*
*/
- (void)getMessage:(NSString *)messageId
 completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取会话所有消息
*
*  @param handler    用户获取所有消息回调接口(resultObject为JMSGMessage类型的数组)
*/
- (void)getAllMessageWithCompletionHandler:(JMSGCompletionHandler)handler;


/**
*  删除会话所有消息
*
*  @param handler    删除所有消息回调接口
*
*/
- (void)deleteAllMessageWithCompletionHandler:(JMSGCompletionHandler)handler;


///----------------------------------------------------
/// @name Conversation State Maintenance 会话状态维护
///----------------------------------------------------


/**
*  将会话中的未读消息数清零
*
*  @param handler    清空未读消息回调接口
*
*/
- (void)resetUnreadMessageCountWithCompletionHandler:(JMSGCompletionHandler)handle;


///----------------------------------------------------
/// @name Conversation Operations 会话相关操作
///----------------------------------------------------

/**
*  获取所有会话列表
*
*  @param handler          用户获取所有会话回调接口 (resultObject为JMSGConversation类型数组)
*
*/
+ (void)getConversationListWithCompletionHandler:(JMSGCompletionHandler)handler;

/**
*  获取已知的会话
*  FIXME 获取会话，需要传 conversationType 参数
*
*  @param targetUsername   会话名称(单聊为对方username，群聊为群gid)
*  @param handler          用户获取会话回调接口(resultObject为JMSGConversation类型)
*
*  @return 会话实体
*/
+ (void)getConversation:(NSString *)targetId
               withType:(JMSGConversationType)conversationType
      completionHandler:(JMSGCompletionHandler)handler;

/**
*  创建新会话
*
*  @param targetUsername   会话对方(单聊为对方username，群聊为群gid)
*  @param handler          用户创建会话回调接口(resultObject为JMSGConversation类型)
*  @param conversationType 会话类型
*
*/
+ (void)createConversation:(NSString *)targetId
                  withType:(JMSGConversationType)conversationType
         completionHandler:(JMSGCompletionHandler)handler;

/**
*  删除会话
*
*  @param targetUsername   会话对方(单聊为对方username，群聊为群gid)
*  @param handler          用户删除会话回调接口
*
*  @return 删除结果
*/
+ (void)deleteConversation:(NSString *)targetId
                  withType:(JMSGConversationType)conversationType
         completionHandler:(JMSGCompletionHandler)handler;


@end
