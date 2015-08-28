#import <Foundation/Foundation.h>
#import <JMessage/JMSGMessageDelegate.h>
#import <JMessage/JMSGConversationDelegate.h>
#import <JMessage/JMSGGroupDelegate.h>

@protocol JMessageDelegate <JMSGMessageDelegate,JMSGConversationDelegate,JMSGGroupDelegate>

@end