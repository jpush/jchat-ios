#import <Foundation/Foundation.h>

/*!
 * @abstract 会话相关变更通知
 */
@protocol JMSGConversationDelegate <NSObject>

/*!
 * @abstract 会话信息变更通知
 * @discussion 当前有二个属性: 会话标题(title), 会话图标
 *
 * 收到此通知后, 建议处理: 如果 App 当前在会话列表页，刷新整个列表；如果在聊天界面，刷新聊天标题。
 */
@optional
- (void)onConversationChanged:(JMSGConversation *)conversation;

/*!
 * @abstract 当前剩余的全局未读数
 */
@optional
- (void)onUnreadChanged:(NSUInteger)newCount;

@end

