#import <Foundation/Foundation.h>
#import <JMessage/JMSGConstants.h>
#import <JMessage/JMSGConversation.h>

@class JMSGMessage;
@class JMSGConversation;

@interface JMSGConversationManager : NSObject

/**
 *  获取已知的会话
 *
 *  @param targetUsername   会话名称(单聊为对方username，群聊为群名称)
 *  @param handler          用户获取会话回调接口(resultObject为JMSGConversation类型)
 *
 *  @return 会话实体
 */
+ (void)getConversation:(NSString *)targetUserName
      completionHandler:(JMSGCompletionHandler)handler;

/**
 *  创建新会话
 *
 *  @param targetUsername   会话对方(单聊为对方username，群聊为群名称)
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
 *  @param targetUsername   会话对方(单聊为对方username，群聊为群名称)
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
