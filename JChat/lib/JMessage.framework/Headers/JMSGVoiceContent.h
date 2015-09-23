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
#import <JMessage/JMSGMediaAbstractContent.h>

/*!
 * @abstract 语音内容类型
 */
@interface JMSGVoiceContent : JMSGMediaAbstractContent <NSCopying>

JMSG_ASSUME_NONNULL_BEGIN

/*!
 * @abstract 语音时长 (单位:秒)
 */
@property(nonatomic, copy, readonly) NSNumber *duration;

/*!
 * @abstract 语音文件路径 (绝对路径, 可用于通过此路径获取数据)
 */
@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE voicePath;

- (instancetype)init NS_UNAVAILABLE;

/*!
 @abstract 根据语音数据与时长来创建对象

 @param data 该语音内容的数据. 不允许为 nil, 并且内容长度应大于 0
 @param duration 该语音内容的持续时长. 单位是秒. 不允许为 nil, 并且应大于 0.
 */
- (instancetype)initWithVoiceData:(NSData *)data
                    voiceDuration:(NSNumber *)duration;

/*!
 @abstract 获取图片消息的缩略图数据
 
 @param completionHandler 结果回调。返回正常时 resultObject 内容是缩略图数据，类型是 NSData
 
 @discussion
 如果本地还没有语音数据，会发起网络请求下载。下载完后再回调。
 */
- (void)voiceData:(JMSGAsyncDataHandler)handler;


JMSG_ASSUME_NONNULL_END

@end
