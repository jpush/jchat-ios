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

@end
