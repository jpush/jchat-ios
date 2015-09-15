#import <Foundation/Foundation.h>


@protocol JMSGConversationDelegate <NSObject>

@optional
/*!
 @abstract conversation changed 一般需要刷新conversation的相关信息(title,thumb)
 @discussion conversation为变更的conversation对象,通过isEqual来判断是否是当前会话

 如果在会话列表页，刷新整个列表； 如果在聊天界面，刷新聊天标题。
 */
- (void)onConversationChanged:(JMSGConversation *)conversation;

@optional
/*!
  当前剩余的全局未读数
 */
- (void)onUnreadChanged:(NSUInteger)newCount;

@end
