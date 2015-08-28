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

@interface JMSGVoiceContent : JMSGMediaContent <NSCopying>

/*!
 @abstract 语音时长
 */
@property(nonatomic, copy, readonly) NSNumber *duration;

@property(nonatomic, copy, readonly) NSString *voicePath;


/*!
 @abstract 根据语音数据与时长来创建对象
 */
- (instancetype)initWithVoiceData:(NSData *)data
                    voiceDuration:(NSNumber *)duration;

@end