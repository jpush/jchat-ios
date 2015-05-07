#import <JMessage/JMSGMessage.h>
#import <JMessage/JMSGConstants.h>
@class JMSGMessage;
@class JMSGConversationModel;


/***************************************声明枚举类型*********************************************/
/**
 *  会话类型
 */
typedef NS_ENUM(NSInteger, ConversationType) {
    kSingle = 0,
    kGroup,
};
/*******************************************************************************************/

extern NSString *kJMSGConversationInfoChanged;

@interface JMSGConversation : NSObject
// @property(readonly, strong, atomic) JMSGConversationModel *conversationModel;
 @property (atomic, strong) NSString *Id;//聊天会话ID
 @property (atomic, strong) NSString *type;//聊天会话类型
 @property (atomic, strong) NSString *target_id;//聊天会话目标id
 @property (atomic, strong) NSString *target_displayName;//聊天对象的昵称

 @property (atomic, strong) NSString *latest_type;//最后消息的内容类型
 @property (atomic, strong) NSString *latest_text;//最后消息内容
 @property (atomic, strong) NSString *latest_date;//最后消息日期
 @property (atomic, strong) NSString *latest_displayName;
 @property (atomic, assign) MessageStatusType latest_text_state;

 @property (atomic, strong) NSNumber *unread_cnt;//未读消息数量
 @property (atomic, assign) MessageStatusType latest_messageStatus;//最后消息状态
 @property (atomic, strong) NSString *latest_target_displayName;//最后消息展示名
 @property (atomic, strong) NSString *msg_table_name;//该会话所对应的Message表的表名

 @property(readonly, strong, nonatomic) NSString *targetName;
 @property(readonly, strong, nonatomic) NSString *avatarThumb;
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

///**
//*  获取Conversation信息
//*
//*  @param handler    用户获取Conversation信息回调接口(resultObject为JMSGConversationModel类型)
//*
//*/
//- (void)getConversationInfoWithCompletionHandler:(JMSGCompletionHandler)handler;

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

@end
