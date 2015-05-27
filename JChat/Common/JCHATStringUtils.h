//
// Created by Javen on 15/5/11.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JCHATStringUtils : NSObject


+ (NSString *)dictionary2String:(NSDictionary *)dictionary;

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval;

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)isShort;

@end

