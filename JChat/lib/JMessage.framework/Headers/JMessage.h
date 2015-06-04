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

// Version
#define JMESSAGE_VERSION @"1.0.1"

extern NSInteger const JMESSAGE_API_VERSION;

/**
*  初始化IM服务
*
*  @param launchOptions    AppDelegate启动函数的参数launchingOption(用于推送服务)
*  @param appKey           appKey(应用Key值,通过JPush官网可以获取)
*  @param channel          应用的渠道名称
*  @param isProduction     是否为生产模式
*  @param category         iOS8新增通知快捷按钮参数
*/
+ (void)setupJMessage:(NSDictionary *)launchOptions
               appKey:(NSString *)appKey
              channel:(NSString *)channel
     apsForProduction:(BOOL)isProduction
             category:(NSSet *)category;

/**
*  纠正当前设备时间,根据服务器时间来纠正当前设备的时间保持一致.
*
*  @param clientTime  客户端时间指针
*
*  @return 纠正时间结果
*/
+ (NSTimeInterval)currentServerTime;



@end

