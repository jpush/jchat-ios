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
extern NSString * const JMSGNotification_SendMessageResult;

/**
* 收取收到消息通知
*/
extern NSString * const JMSGNotification_ReceiveMessage;
extern NSString * const JMSGNotification_MessageKey;



#ifndef JMSGSendMessageObject
#define JMSGSendMessageObject  @"message"
#endif
#ifndef JMSGSendMessageError
#define JMSGSendMessageError   @"error"
#endif

@interface JMSGMessage : NSObject <NSCopying>

@property(atomic, strong, readonly) NSString *messageId;   //聊天ID
@property(atomic, strong) NSString *target_id;
@property(atomic, strong, getter=display_name) NSString *target_name;

@property(atomic, strong) NSDictionary *extra;
@property(atomic, strong) NSDictionary *custom;
@property(atomic, assign) JMSGConversationType sendMessageType;
//发送消息是群聊还是单聊
@property(assign, readonly) JMSGMessageContentType messageType;
@property(atomic, strong) JMSGConversation *conversation;
@property(atomic, strong) NSNumber *timestamp;  //消息时间戳
@property(strong, readonly) NSNumber *status;     //消息的状态


 - (instancetype)init;


/**
*  发送消息接口
*
*  @param message       消息内容对象
*  @param handler       用户发送消息回调接口
*
*/
 + (void)sendMessage:(JMSGMessage *)message;

/**
*  获取消息大图接口
*
*  @param message       消息内容对象
*  @param progress      下载进度对象
*  @param handler       用户获取图片回调接口(ResultObject为NSURL类型图片路径)
*/
 + (void)getMetaImageFromMessage:(JMSGImageMessage *)message
                    withProgress:(NSProgress *)progress
               completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取缩略图接口
*
*  @param message       消息内容对象
*  @param progress      下载进度对象
*  @param handler       用户获取图片回调接口(ResultObject为NSURL类型图片路径)
*/
 + (void)getThumbImageFromMessage:(JMSGImageMessage *)message
                     withProgress:(NSProgress *)progress
                completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取语音接口
*
*  @param message       语音消息内容对象
*  @param progress      下载进度对象
*  @param handler       用户获取语音回调接口(ResultObject为NSURL类型语音路径)
*/
 + (void)getVoiceFromMessage:(JMSGVoiceMessage *)message
                withProgress:(NSProgress *)progress
           completionHandler:(JMSGCompletionHandler)handler;

@end

@interface JMSGMediaMessage : JMSGMessage <NSCopying>

@property (atomic, strong)JMSGonProgressUpdate   progressCallback;
@property (atomic, strong)NSString              *resourcePath;
@property (atomic, strong)NSData                *mediaData;
@property (atomic, assign)CGSize                 imgSize;

@end

@interface JMSGContentMessage : JMSGMessage <NSCopying>

@property(atomic, strong)NSString                *contentText;

@end

@interface JMSGImageMessage : JMSGMediaMessage <NSCopying>

@property(atomic, strong)NSString                *thumbPath;

@end

@interface JMSGVoiceMessage : JMSGMediaMessage <NSCopying>

@property(atomic, strong)NSString                *duration;

@end



