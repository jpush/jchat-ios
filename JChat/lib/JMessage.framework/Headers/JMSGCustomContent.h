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

@interface JMSGCustomContent : JMSGAbstractContent <NSCopying>

@property(nonatomic, strong, readonly) NSDictionary *customDictionary;


- (void)addStringValue:(NSString *)value forKey:(NSString *)key;

- (void)addNumberValue:(NSNumber *)value forKey:(NSString *)key;

- (void)addBooleanValue:(BOOL)value forKey:(NSString *)key;

- (void)setContentText:(NSString *)contentText;

@end