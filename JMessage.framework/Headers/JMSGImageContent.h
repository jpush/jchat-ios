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


/*!
 * 图片内容
 */
@interface JMSGImageContent : JMSGMediaAbstractContent <NSCopying>

/*!
 * @abstract 图片链接
 */
@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE imageLink;

/*!
 * @abstract 缩略图路径
 * @discussion 缩略图的概念, 是指基于调用 SDK API 发图时的原图, SDK 进一步进行裁减得更小的图.
 * 这个缩略图一般用于直接展示在聊天界面.
 */
@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE thumbImagePath;

/*!
 * @abstract 大图路径
 * @discussion 大图的概念, 是指发图片消息的原图.
 * 一般来说, 发图片消息的"原图" 也是经过裁减的, 而不是拍照的原图.
 * 这个大图一般是用户在聊天窗口点击缩略图后, 才展示出来.
 */
@property(nonatomic, strong, readonly) NSString * JMSG_NULLABLE largeImagePath;

// 不支持使用的初始化方法
- (nullable instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 初始化消息图片内容
 *
 * @param data 图片数据
 *
 * @discussion 这是预设的初始化方法. 创建一个图片内容对象, 必须要传入图片数据.
 *
 * 对于图片消息, 一般来说创建此图片内容的数据, 是对拍照原图经过裁减处理的, 否则发图片消息太大.
 * 这里传入的图片数据, SDK视为大图. 方法 largeImageDataWithProgress:completionHandler 下载到的,
 * 就是这个概念上的图片数据.
 */
- (nullable instancetype)initWithImageData:(NSData * JMSG_NONNULL)data;

/*!
 * @abstract 获取图片消息的缩略图数据
 *
 * @param completionHandler 结果回调。返回正常时 resultObject 内容是缩略图数据，类型是 NSData
 *
 * @discussion 展示缩略时调用此接口，获取缩略图数据。
 * 如果本地还没有图片，会发起网络请求下载。下载完后再回调。
 */
- (void)thumbImageData:(JMSGAsyncDataHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 获取图片消息的大图数据
 *
 * @param progress 下载进度。会持续回调更新进度。如果为 nil 则表示不关心进度。
 * @param completionHandler 结果回调(。返回正常时 resultObject 类型为 NSData.
 *
 * @discussion 一般在预览图片大图时，要用此接口。
 */
- (void)largeImageDataWithProgress:(NSProgress * JMSG_NULLABLE)progress
                 completionHandler:(JMSGAsyncDataHandler JMSG_NULLABLE)handler;

@end
