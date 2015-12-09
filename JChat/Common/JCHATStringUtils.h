//
// Created by Javen on 15/5/11.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCHATStringUtils : NSObject

+ (NSString*)errorAlert:(NSError *)error;

+ (NSString *)dictionary2String:(NSDictionary *)dictionary;

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval;

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)isShort;

+ (BOOL)isValidatIP:(NSString *)ipAddress;


+ (CGSize)stringSizeWithWidthString:(NSString *)string withWidthLimit:(CGFloat)width withFont:(UIFont *)font;
@end

