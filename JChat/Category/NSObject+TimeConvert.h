//
//  NSObject+NSObject_TimeConvert.h
//  JPush IM
//
//  Created by Apple on 15/3/17.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TimeConvert)

-(NSString *)getTimeDate :(NSTimeInterval) time;

-(NSString *)getCurrentTimeDate;

-(NSTimeInterval )getCurrentTimeInterval;

- (NSString *)findendliyTime:(NSString *)dataTime;

@end
