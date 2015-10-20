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
#import <JMessage/JPUSHService.h>
#import <JMessage/JMSGUser.h>
#import <JMessage/JMSGGroup.h>
#import <JMessage/JMSGMessage.h>
#import <JMessage/JMSGConversation.h>
#import <JMessage/JMSGAbstractContent.h>
#import <JMessage/JMSGMediaAbstractContent.h>
#import <JMessage/JMSGCustomContent.h>
#import <JMessage/JMSGEventContent.h>
#import <JMessage/JMSGImageContent.h>
#import <JMessage/JMSGTextContent.h>
#import <JMessage/JMSGVoiceContent.h>
#import <JMessage/JMessageDelegate.h>

@protocol JMSGMessageDelegate;
@protocol JMessageDelegate;
@class JMSGConversation;


/*!
 * JMessage核心头文件
 *
 * 这是唯一需要导入到你的项目里的头文件，它引用了内部需要用到的头文件。
 */
@interface JMessage : NSObject

/*! JMessage SDK 版本号。用于展示 SDK 的版本信息 */
#define JMESSAGE_VERSION @"1.1.0"
#define JMESSAGE_BUILD   @"499"

/*! API Version - Int for program logic */
extern NSInteger const JMESSAGE_API_VERSION;


/*!
 * @abstract 初始化 JMessage SDK
 *
 * @param launchOptions    AppDelegate启动函数的参数launchingOption(用于推送服务)
 * @param appKey           appKey(应用Key值,通过JPush官网可以获取)
 * @param channel          应用的渠道名称
 * @param isProduction     是否为生产模式
 * @param category         iOS8新增通知快捷按钮参数
 *
 * @discussion 此方法必须被调用, 以初始化 JMessage SDK
 *
 * 如果未调用此方法, 本 SDK 的所有功能将不可用.
 */
+ (void)setupJMessage:(NSDictionary *)launchOptions
               appKey:(NSString *)appKey
              channel:(NSString *)channel
     apsForProduction:(BOOL)isProduction
             category:(NSSet *)category;

/*!
 * @abstract 设置所有回调 delegate
 *
 * @param delegate 需要接受回调的对象
 * @param conversation 允许为nil.
 *
 * - 如果不为 nil，表示只接收指定的 conversation 相关的通知.
 * - 为 nil, 表示接收所有的通知.
 *
 * @discussion 默认设置全局 JMessageDelegate 即可.
 */
+ (void)addDelegate:(id <JMessageDelegate>)delegate
   withConversation:(JMSGConversation *)conversation;

+ (void)removeDelegate:(id <JMessageDelegate>)delegate;

+ (void)removeAllDelegates;

/*!
 * @abstract 控制Log的输出等级,目前对外只有Debug模式,Info模式和关闭Log可选
 *
 * @discussion 默认的Log模式为Info Mode,只展示必要Log信息,当需要调试时才需要开启Debug模式
 *             如果上线或者不关心JMessage的业务时,选择Log off不打印任何JMessage的Log(除了出错信息和警告)
 */
+ (void)setDebugMode;

+ (void)setInfoMode;

+ (void)setLogOFF;


/*!
 * @abstract 获取当前服务器端时间
 *
 * @discussion 可用于纠正本地时间。
 */
+ (int)currentServerTime;

@end

