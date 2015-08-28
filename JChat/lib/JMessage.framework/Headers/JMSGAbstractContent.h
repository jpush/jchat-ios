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
#import <JMessage/JMSGConversation.h>

@interface JMSGAbstractContent : NSObject <NSCopying,NSCoding>{
}

@property(nonatomic, strong, readonly) NSDictionary *extras;


- (void)addStringExtra:(NSString *)value forKey:(NSString *)key;

- (void)addNumberExtra:(NSNumber *)value forKey:(NSString *)key;

- (void)addBooleanExtra:(BOOL)value forKey:(NSString *)key;

- (NSString *)toJsonString;

- (BOOL)isEqualToContent:(JMSGAbstractContent *)content;


@end
