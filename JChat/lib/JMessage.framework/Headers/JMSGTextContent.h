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

/*!
 * @abstract 纯文本内容类型
 */
@interface JMSGTextContent : JMSGAbstractContent <NSCopying>

JMSG_ASSUME_NONNULL_BEGIN

/*!
 * @abstract 内容文本
 */
@property(nonatomic, readonly, copy) NSString *text;

- (instancetype)init NS_UNAVAILABLE;

/*!
 * @abstract 基于文本初始化内容对象
 * @discussion 这是唯一的创建此类型对象的方法
 */
- (instancetype)initWithText:(NSString *)text;

JMSG_ASSUME_NONNULL_END

@end
