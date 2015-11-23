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
* 发送消息返回通知(用来监听消息发送的结果)
*/
extern NSString *const JMSGNotification_SendMessageResult;

/**
* 收取收到消息通知(用来接收所有收到的消息)
*/
extern NSString *const JMSGNotification_ReceiveMessage;
extern NSString *const JMSGNotification_MessageKey;

/**
*  收取事件消息通知(用来接收所有收到的Event事件)
*/
extern NSString *const JMSGNotification_EventMessage;
extern NSString *const JMSGNotification_EventKey;

#ifndef JMSGSendMessageObject
#define JMSGSendMessageObject  @"message"
#endif
#ifndef JMSGSendMessageError
#define JMSGSendMessageError   @"error"
#endif

typedef NS_ENUM(NSUInteger, JMSGEventType) {
  kJMSGCreateGroupEvent = 8,        //创建群组
  kJMSGExitGroupEvent = 9,          //退出群组(自己主动退出)
  kJMSGAddGroupMemberEvent = 10,    //群组加入成员
  kJMSGDeleteGroupMemberEvent = 11, //删除群组成员
};


///-------------------------------------------------------
/// JMSGMessage 消息的抽象类,Message对象需要使用具体类来实例化
///-------------------------------------------------------

@interface JMSGMessage : NSObject <NSCopying>

/*
 * 消息唯一Id(自动生成)
 */
@property(atomic, strong, readonly) NSString *messageId;

/*
 * @param targetId   消息的接收方userName,用于辨别发送方是谁(发送消息时需要必须填写,接收消息时不需要填写)
 * @param targetName 消息的接收方展示名(不需要填写)
 */
@property(atomic, strong) NSString *targetId;
@property(atomic, strong) NSString *targetName;

/*
 * @param fromId      消息的接收方userName(不需要填写)
 * @param fromName    消息的接收方展示名(不需要填写)
 */
@property(atomic, strong,readonly) NSString *fromId;
@property(atomic, strong,readonly) NSString *fromName;

/**
 * 消息的displayName(单聊为对方的displayName,群聊为发送该消息的用户的displayName)
 */
@property(nonatomic, strong, readonly) NSString *displayName;

/*
 * 消息的附加字段(用于需要特殊处理的字段但不展示出来的内容)
 */
@property(atomic, strong) NSDictionary *extras;

/*
 * 消息是群聊还是单聊(发送时必须填写)
 */
@property(atomic, assign) JMSGConversationType conversationType;

/*
 * 消息类型,消息的子类已经自动填写(不需要填写)
 */
@property(assign, readonly) JMSGMessageContentType contentType;

/*
 * 消息时间戳,发送时自动生成(不需要填写)
 */
@property(atomic, strong, readonly) NSNumber *timestamp;

/*
 * 消息状态(不需要填写)
 */
@property(strong, readonly) NSNumber *status;     //消息的状态


/**
 * 初始化方法
 */
- (instancetype)init;


/**
*  发送消息接口
*
*  @param message       待发送的消息。使用时只能使用JMSGMessage的子类(JMSGContentMessage、JMSGVoiceMessage、JMSGImageMessage、JMSGCustomMessage、JMSGEventMessage)
*                                   发送结果需要监听JMSGNotification_SendMessageResult通知
*/
+ (void)sendMessage:(JMSGMessage *)message;

/**
*   发送纯文本消息,为sendMessage的包装方法
*
*   @param               消息纯文本内容
*   @param               消息发送对象username
*
*/
+ (void)sendSingleTextMessage:(NSString *)content
                   toUsername:(NSString *)targetId;

/**
*   发送单聊图片消息,为sendMessage的包装方法
*
*   @param               消息图片内容
*   @param               消息发送对象username
*
*/
+ (void)sendSingleImageMessage:(NSData *)imageData
                    toUsername:(NSString *)username;

/**
*   发送单聊声音消息,为sendMessage的包装方法
*
*   @param               消息声音内容
*   @param               消息发送对象username
*
*/
+ (void)sendSingleVoiceMessage:(NSData *)voiceData
                    toUsername:(NSString *)username;

/**
*  获取消息大图接口
*
*  @param JMSGImageMessage 图片消息
*  @param progress         下载进度
*  @param handler          结果回调。正常返回时resultObject对象类型为NSURL,内容为图片文件路径
*/
+ (void)downloadOriginImage:(JMSGImageMessage *)message
               withProgress:(NSProgress *)progress
          completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取缩略图接口
*  默认收到图片消息时 SDK会自动下载缩略图。
*  如果自动下载失败，则使用该接口可以发起再次下载
*
*  @param JMSGImageMessage 图片消息
*  @param progress         下载进度
*  @param handler          结果回调。正常返回时resultObject对象类型为NSURL,内容为图片文件路径
*/
+ (void)downloadThumbImage:(JMSGImageMessage *)message
              withProgress:(NSProgress *)progress
         completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取语音接口
*  默认收到语音消息时 SDK会自动下载语音文件。
*  如果自动下载失败，则使用该接口可以发起再次下载
*
*  @param message       语音消息内容对象
*  @param progress      下载进度对象
*  @param handler       结果回调。正常返回时resultObject对象类型为NSURL,内容为语音文件路径
*/
+ (void)downloadVoice:(JMSGVoiceMessage *)message
         withProgress:(NSProgress *)progress
    completionHandler:(JMSGCompletionHandler)handler;

@end

///----------------------------------------------------
/// @name Message Children class 消息子类（根据消息类型的不同）
///----------------------------------------------------

///-----------------------------------------------------------------
/// JMSGMediaMessage 多媒体消息的抽象类,Message对象需要使用具体类来实例化
///-----------------------------------------------------------------
@interface JMSGMediaMessage : JMSGMessage <NSCopying>

/**
*  上传进度对象,发送时,用于获取当前多媒体资源的上传进度
*/
@property(atomic, strong) JMSGMediaUploadProgressHandler progressCallback;

/**
*  收到消息时,媒体资源的路径,语音为语音文件,图片为原始大图文件(不会自动下载,需要手动调用downloadOriginImage成功后再获取)
*/
@property(atomic, strong) NSString *resourcePath;

/**
*  媒体资源文件二进制流,发送时使用，用与传入需要发送的媒体资源.
*/
@property(atomic, strong) NSData *mediaData;

/**
*  媒体资源文件的大小,发送时使用,传入发送的媒体资源的大小.
*/
@property(atomic, assign) CGSize imgSize;

@end

///-----------------------------------------------------------------
/// JMSGContentMessage 纯文本消息.发送时必须填写:contentText、targetId、contentType
///                    接收时通过contentText获取消息内容
///-----------------------------------------------------------------
@interface JMSGContentMessage : JMSGMessage <NSCopying>

/**
*  文本消息的内容
*/
@property(atomic, strong) NSString *contentText;

@end


///-----------------------------------------------------------------
/// JMSGEventMessage Event消息具体类，通过JMSGNotification_EventMessage来接收
///                  使用contentText来获取具体的event需要展示的内容,不需要根据具体信息来自己拼接展示内容
///-----------------------------------------------------------------
@interface JMSGEventMessage : JMSGContentMessage <NSCopying>

/**
* event消息的类型,参照JMSGEventType Enum
*/
@property(atomic, assign) JMSGEventType type;

/**
*  Event消息对应的群组
*/
@property(atomic, assign) SInt64 gid;

/**
* event的事件的发起者,获取成功时为username.
*/
@property(atomic, strong) NSString *eventOperator;

/**
* event的事件的作用对象,获取成功时为username组成的NSArray,否则为uid原始的NSArray(视为异常不作处理)
*/
@property(atomic, strong) NSArray *targetList;

/**
*  event事件的对象人群是否包含我自己
*/
@property(atomic, assign) BOOL isContainsMe;

@end

///-----------------------------------------------------------------
/// JMSGCustomMessage 自定义消息.发送时必须填写:custom、targetId、contentType
///                   发送自定义消息时需要传的对象
///                   用户可以发送接收自定义格式的内容(custom字段)
///-----------------------------------------------------------------
@interface JMSGCustomMessage : JMSGMessage <NSCopying>

/**
*  自定义消息的内容(由于"extras"已经被extras属性占用,建议不要使用"extras"作为key或者不使用extras属性,否则结果可能会不符合预期)
*/
@property(atomic, strong) NSDictionary *custom;

@end

///-----------------------------------------------------------------
/// JMSGImageMessage 图片消息,发送时必须填写:mediaData、targetId、contentType、imgSize
///                  发送图片消息时需要传的对象
///                  接收时通过thumbPath展示缩略图,图片不存在时需要调用downloadThumbImage重新获取
//                   完整大图需要调用downloadOriginImage接口获取
///-----------------------------------------------------------------
@interface JMSGImageMessage : JMSGMediaMessage <NSCopying>

/**
*  缩略图路径,接收时获取缩略图的图片路径,图片不存在时需要调用downloadThumbImage重新获取
*/
@property(atomic, strong) NSString *thumbPath;

@end

///-----------------------------------------------------------------
/// JMSGVoiceMessage 语音消息,发送时必须填写:duration、mediaData 、targetId、contentType、imgSize
///                  发送语音消息时需要传的对象
///                  接收时通过resourcePath获取语音消息,图片不存在时需要调用downloadVoice重新获取
///-----------------------------------------------------------------
@interface JMSGVoiceMessage : JMSGMediaMessage <NSCopying>

/**
*  发送时需要主动填写语音的时长,接收时用来获取该语音消息的时间长度
*/
@property(atomic, strong) NSString *duration;

@end


