#import <Foundation/Foundation.h>
#import <JMessage/JMSGConstants.h>
@class JMSGMessage;
@class JMSGImageMessage;
@class JMSGVoiceMessage;

@interface JMSGMessageManager : NSObject

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
