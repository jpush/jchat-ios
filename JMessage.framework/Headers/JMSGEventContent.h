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
#import <JMessage/JMSGAbstractContent.h>

typedef NS_ENUM(NSInteger, JMSGEventNotificationType) {
  kJMSGEventNotificationLoginKicked = 1,
  kJMSGEventNotificationCreateGroup = 8,
  kJMSGEventNotificationExitGroup = 9,
  kJMSGEventNotificationAddGroupMembers = 10,
  kJMSGEventNotificationRemoveGroupMembers = 11,
};


@interface JMSGEventContent : JMSGAbstractContent <NSCopying>

@property(nonatomic, assign, readonly) JMSGEventNotificationType eventType;


- (nullable instancetype)init NS_UNAVAILABLE;

/*!
 @abstract 展示此事件的文本描述

 @discussion SDK 根据事件类型，拼接成完整的事件描述信息。
 */
- (NSString * JMSG_NONNULL)showEventNotification;

@end
