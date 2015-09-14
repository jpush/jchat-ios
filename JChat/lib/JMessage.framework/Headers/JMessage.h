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
#import <JMessage/JMSGConversation.h>
#import <JMessage/JMSGMessage.h>
#import <JMessage/JPUSHService.h>
#import <JMessage/JMSGUser.h>
#import <JMessage/JMSGGroup.h>


@interface JMessage : NSObject

// 当前JMessage版本号
#define JMESSAGE_VERSION @"1.0.6"
#define JMESSAGE_BUILD @"283"

extern NSInteger const JMESSAGE_API_VERSION;

/**
*  初始化IM服务
*
*  @param launchOptions    launchOptions 启动参数。可直接传 AppDelegate 的启动参数
*  @param appKey           appKey 必填。极光 AppKey，用于唯一地标识应用。
*  @param channel          发行渠道。可不填。
*  @param isProduction     当前App的发布状态。如果是上线 Apple Store，应该为 YES。
*  @param category         iOS8新增通知快捷按钮参数
*/
+ (void)setupJMessage:(NSDictionary *)launchOptions
               appKey:(NSString *)appKey
              channel:(NSString *)channel
     apsForProduction:(BOOL)isProduction
             category:(NSSet *)category;

/**
*  获取当前时间(和服务器时间同步)
*
*  @return 当前时间
*/
+ (NSTimeInterval)currentServerTime;



@end

