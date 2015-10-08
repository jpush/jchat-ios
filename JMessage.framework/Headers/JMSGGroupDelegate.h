#import <Foundation/Foundation.h>

@class JMSGGroup;


@protocol JMSGGroupDelegate <NSObject>

/*!
 * @abstract 群组信息 (GroupInfo) 信息有变更时回调.
 *
 * @discussion 如果想要获取通知, 需要先注册回调. 具体请参考 JMessageDelegate 里的说明.
 */
@optional
- (void)onGroupInfoChanged:(JMSGGroup *)group;

@end
