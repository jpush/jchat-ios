//
//  NSObject+NSObject_TimeConvert.m
//  JPush IM
//
//  Created by Apple on 15/3/17.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "NSObject+TimeConvert.h"
#import <JMessage/JMessage.h>

@implementation NSObject (TimeConvert)

#pragma mark 时间戳转日期

- (NSString *)getTimeDate:(NSTimeInterval)time {
  NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:time];

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];

  return [formatter stringFromDate:timestamp];
}

#pragma mark --获取当前的时间

- (NSString *)getCurrentTimeString {
  NSString *date;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
  date = [formatter stringFromDate:[NSDate date]];
  NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
  return timeNow;
}

#pragma mark --获取当前服务器纠正的时间戳

- (NSTimeInterval)getCurrentTimeInterval {
  NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
  [JMessage correctTimerWithServer:&timeInterval];
  return timeInterval;
}



@end
