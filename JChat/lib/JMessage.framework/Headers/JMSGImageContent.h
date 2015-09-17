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
#import <JMessage/JMSGConstants.h>

@interface JMSGImageContent : JMSGMediaAbstractContent <NSCopying>

/*!
 @abstract 图片链接
 */
@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE imageLink;

/*!
 @abstract 缩略图路径

 @discussion 可以
 */
@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE thumbImagePath;

@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE largeImagePath;

- (nullable instancetype)init NS_UNAVAILABLE;

/*!
 @abstract 从图片数据初始化消息图片内容
 */
- (nullable instancetype)initWithImageData:(NSData * JMSG_NONNULL)data;

/*!
 @abstract 获取图片消息的大图数据
 
 @param progress 下载进度。会持续回调更新进度。如果为 nil 则表示不关心进度。
 @param completionHandler 结果回调(。返回正常时 resultObject 类型为 NSData.
 
 @discussion 一般在预览图片大图时，要用此接口。
 */
- (void)largeImageDataWithProgress:(NSProgress * JMSG_NULLABLE)progress
                 completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 @abstract 获取图片消息的缩略图数据
 
 @param completionHandler 结果回调。返回正常时 resultObject 内容是缩略图数据，类型是 NSData
 
 @discussion 展示缩略时调用此接口，获取缩略图数据。
 如果本地还没有图片，会发起网络请求下载。下载完后再回调。
 */
- (void)thumbImageData:(JMSGCompletionHandler JMSG_NULLABLE)handler;



@end
