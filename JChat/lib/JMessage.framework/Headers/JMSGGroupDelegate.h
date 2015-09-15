#import <Foundation/Foundation.h>

@class JMSGGroup;


@protocol JMSGGroupDelegate <NSObject>


@optional
/*!
   群组信息变化,通过此回调
 */
- (void)onGroupInfoChanged:(JMSGGroup *)group;

@end
