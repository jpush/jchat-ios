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
#import <UIKit/UIKit.h>
#import <JMessage/JMSGConstants.h>
#import <JMessage/JMSGConversation.h>

@class JMSGImageMessage;
@class JMSGVoiceMessage;

/**
* 发送消息返回通知
*/
extern NSString *const JMSGNotification_SendMessageResult;

/**
* 收取收到消息通知
*/
extern NSString *const JMSGNotification_ReceiveMessage;
extern NSString *const JMSGNotification_MessageKey;

/**
*  收取事件消息通知
*/
extern NSString *const JMSGNotification_EventMessage;
extern NSString *const JMSGNotification_EventKey;

#ifndef JMSGSendMessageObject
#define JMSGSendMessageObject  @"message"
#endif
#ifndef JMSGSendMessageError
#define JMSGSendMessageError   @"error"
#endif

@interface JMSGMessage : NSObject <NSCopying>

@property(atomic, strong, readonly) NSString *messageId;                //聊天ID
@property(atomic, strong) NSString *target_id;
@property(nonatomic, strong, readonly) NSString *display_name;
@property(atomic, strong) NSString *target_name;
@property(atomic, strong) NSString *from_id;
@property(atomic, strong, getter=display_name) NSString *from_name;

@property(atomic, strong) NSDictionary *extra;
@property(atomic, assign) JMSGConversationType sendMessageType; //发送消息是群聊还是单聊
@property(assign, readonly) JMSGMessageContentType messageType;
@property(atomic, strong) NSNumber *timestamp;  //消息时间戳
@property(strong, readonly) NSNumber *status;     //消息的状态


- (instancetype)init;


/**
*  发送消息接口
*
*  @param message       消息内容对象
*
*/
+ (void)sendMessage:(JMSGMessage *)message;

/**
*   发送纯文本消息
*
*   @param               消息纯文本内容
*   @param               消息发送对象
*
*/
+ (void)sendSingleTextMessage:(NSString *)content
                   toUsername:(NSString *)targetId;

/**
*  获取消息大图接口
*
*  @param message       消息内容对象
*  @param progress      下载进度对象
*  @param handler       用户获取图片回调接口(ResultObject为NSURL类型图片路径)
*/
+ (void)downloadOriginImage:(JMSGImageMessage *)message
               withProgress:(NSProgress *)progress
          completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取缩略图接口
*
*  @param message       消息内容对象
*  @param progress      下载进度对象
*  @param handler       用户获取图片回调接口(ResultObject为NSURL类型图片路径)
*/
+ (void)downloadThumbImage:(JMSGImageMessage *)message
              withProgress:(NSProgress *)progress
         completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取语音接口
*
*  @param message       语音消息内容对象
*  @param progress      下载进度对象
*  @param handler       用户获取语音回调接口(ResultObject为NSURL类型语音路径)
*/
+ (void)downloadVoice:(JMSGVoiceMessage *)message
         withProgress:(NSProgress *)progress
    completionHandler:(JMSGCompletionHandler)handler;

@end

@interface JMSGMediaMessage : JMSGMessage <NSCopying> {
  NSString *_resourcePath;
}

@property(atomic, strong) JMSGMediaDownloadProgressHandler progressCallback;
@property(atomic, strong) NSString *resourcePath;
@property(atomic, strong) NSData *mediaData;
@property(atomic, assign) CGSize imgSize;

@end

@interface JMSGContentMessage : JMSGMessage <NSCopying>

@property(atomic, strong) NSString *contentText;

@end

typedef NS_ENUM(NSUInteger, JMSGEventType) {
  kJMSGCreateGroupEvent = 8,
  kJMSGExitGroupEvent = 9,
  kJMSGAddGroupMemberEvent = 10,
  kJMSGDeleteGroupMemberEvent = 11,
};

@interface JMSGEventMessage : JMSGContentMessage <NSCopying>

@property(atomic, assign) JMSGEventType type;
@property(atomic, assign) SInt64 gid;
@property(atomic, strong) NSString *operator;
@property(atomic, strong) NSArray *targetList;
@property(atomic, assign) BOOL isContainsMe;

@end

@interface JMSGImageMessage : JMSGMediaMessage <NSCopying>

@property(atomic, strong) NSString *thumbPath;

@end

@interface JMSGVoiceMessage : JMSGMediaMessage <NSCopying>

@property(atomic, strong) NSString *duration;

@end



