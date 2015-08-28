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
#import <JMessage/JMSGMediaContent.h>

@interface JMSGImageContent : JMSGMediaContent <NSCopying>

/*!
 @abstract 图片链接
 */
@property(nonatomic, strong, readonly) NSString *imageLink;

/*!
 @abstract 缩略图路径

 @discussion 可以
 */
@property(nonatomic, strong, readonly) NSString *thumbImagePath;

@property(nonatomic, strong, readonly) NSString *largeImagePath;

/*!
 @abstract 从图片数据初始化消息图片内容
 */
- (instancetype)initWithImageData:(NSData *)data;


@end