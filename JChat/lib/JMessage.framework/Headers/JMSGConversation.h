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

/***************************************声明枚举类型*********************************************/
/**
*  会话类型
*/
 typedef NS_ENUM(NSInteger, ConversationType) {
   kJMSGSingle = 0,
   kJMSGGroup,
 };

/**
*  消息内容类型
*/
 typedef NS_ENUM(NSInteger, MessageContentType) {
   kTextMessage = 0,
   kImageMessage,
   kVoiceMessage,
   kCustomMessage,
   kLocationMessage,
   kCmdMessage,
   kTimeMessage,
 };

/**
*  消息状态类型
*/
 typedef NS_ENUM(NSInteger, MessageStatusType) {
   kNone = 0,
   kSendSucceed,
   kSendFail,
   kSending,
   kUploadSucceed,
   kSendDraft,
   kReceiving,
   kReceiveSucceed,
   kReceiveFailed,
   kReceiveDownloadFailed,
 };

/**
*  消息类型
*/
 typedef NS_ENUM(NSInteger, MessageMetaType) {
   kSendType,
   kReceiveType,
 };

/**
*  消息类型
*/

/**
*  上传文件类型
*/
 typedef NS_ENUM(NSInteger, FileType) {
   kTextFileType,
   kImageFileType,
   kVoiceFileType,
   kCustomFileType,
 };
/*******************************************************************************************/

extern NSString *kJMSGConversationInfoChanged;

@interface JMSGConversation : NSObject
// @property(readonly, strong, atomic) JMSGConversationModel *conversationModel;
@property (atomic, strong) NSString *Id;//聊天会话ID
@property (nonatomic, strong) NSString *type;//聊天会话类型
@property (nonatomic, strong) NSString *target_id;//聊天会话目标id
@property (nonatomic, strong) NSString *target_name;//聊天对象的昵称

@property (nonatomic, strong) NSString *latest_type;//最后消息的内容类型
@property (nonatomic, strong) NSString *latest_text;//最后消息内容
@property (nonatomic, strong) NSString *latest_date;//最后消息日期
@property (nonatomic, strong) NSString *latest_displayName;
@property (atomic, assign) MessageStatusType latest_text_state;

@property (atomic, strong) NSNumber *unread_cnt;//未读消息数量
@property (atomic, assign) MessageStatusType latest_messageStatus;//最后消息状态
@property (nonatomic, strong) NSString *msg_table_name;//该会话所对应的Message表的表名

// @property(readonly, strong, nonatomic) NSString *targetName;
@property(nonatomic,strong,getter=avatarThumb) NSString *avatarThumb;
@property(readonly, assign, nonatomic) ConversationType chatType;


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
*
*/
 - (void)getAllMessageWithCompletionHandler:(JMSGCompletionHandler)handler;


/**
*  删除会话所有消息
*
*  @param handler    删除所有消息回调接口
*
*/
 - (void)deleteAllMessageWithCompletionHandler:(JMSGCompletionHandler)handler;

/**
*  将会话中的未读消息数清零
*
*  @param handler    清空未读消息回调接口
*
*/
 - (void)resetUnreadMessageCountWithCompletionHandler:(JMSGCompletionHandler)handle;

#pragma mark -
/**
 *  获取已知的会话
 *
 *  @param targetUsername   会话名称(单聊为对方username，群聊为群gid)
 *  @param handler          用户获取会话回调接口(resultObject为JMSGConversation类型)
 *
 *  @return 会话实体
 */
+ (void)getConversation:(NSString *)targetUserName
      completionHandler:(JMSGCompletionHandler)handler;

/**
 *  创建新会话
 *
 *  @param targetUsername   会话对方(单聊为对方username，群聊为群gid)
 *  @param handler          用户创建会话回调接口(resultObject为JMSGConversation类型)
 *  @param conversationType 会话类型
 *
 */
+ (void)createConversation:(NSString *)targetUserName
                  withType:(ConversationType)conversationType
         completionHandler:(JMSGCompletionHandler)handler;

/**
 *  删除会话
 *
 *  @param targetUsername   会话对方(单聊为对方username，群聊为群gid)
 *  @param handler          用户删除会话回调接口
 *
 *  @return 删除结果
 */
+ (void)deleteConversation:(NSString *)targetUserName
         completionHandler:(JMSGCompletionHandler)handler;

/**
 *  获取所有会话列表
 *  @param handler          用户获取所有会话回调接口(resultObject为JMSGConversation类型数组)
 *
 */
+ (void)getConversationListWithCompletionHandler:(JMSGCompletionHandler)handler;

@end
