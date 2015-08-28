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
#import <JMessage/JMSGAbstractContent.h>

@class JMSGData;

@interface JMSGMediaContent : JMSGAbstractContent <NSCopying>

/*!
 @abstract 媒体ID

 @discussion 这是 JMessage 内部用于表示资源文件的ID，使用该 ID 可以定位到网络上的资源。
 收到消息时，通过此 ID 可以下载到资源；发出消息时，文件上传成功会生成此ID。
 不支持外部设置媒体ID，或者把此字段设置为 URL 来下载到资源文件。
 */
@property(nonatomic, strong, readonly) NSString *mediaID;

/*!
 @abstract 媒体文件大小

 @discussion
 */
@property(nonatomic, assign, readonly) NSNumber *fSize;

- (instancetype)initWithMediaData:(NSData *)data;


@end

