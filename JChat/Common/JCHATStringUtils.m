//
// Created by Javen on 15/5/11.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import "JCHATStringUtils.h"
#import "NSDate+Utilities.h"

@implementation JCHATStringUtils {

}

static NSString * const FORMAT_PAST = @"yyyy/MM/dd";
static NSString * const FORMAT_THIS_WEEK = @"eee ahh:mm";
static NSString * const FORMAT_YESTERDAY = @"昨天 ahh:mm";
static NSString * const FORMAT_TODAY = @"ahh:mm";

/**
下午11:56 （是今天的）
会话：同样以上字符 - 下午11:56

昨天 上午10:22 （昨天的）
会话：只显示 - 昨天

星期二 上午08:21 （今天昨天之前的一周显示星期）
会话：只显示 - 星期二

2015年1月22日 上午11:58 （一周之前显示具体的日期了）
会话：显示 - 2015/04/18
*/
//设置格式 年yyyy 月 MM 日dd 小时hh(HH) 分钟 mm 秒 ss MMM单月 eee周几 eeee星期几 a上午下午
+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval {
  NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  NSString *output = nil;

  NSTimeInterval theDiff = theDate.timeIntervalSinceNow;

  //上述时间差输出不同信息
  if (theDiff < 60) {
    output = @"刚刚";

  } else if (theDiff < 60 * 60) {
    int minute = (int) (theDiff / 60);
    output = [NSString stringWithFormat:@"%d分钟前", minute];

  } else {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([theDate isToday]) {
      [formatter setDateFormat:FORMAT_TODAY];
    } else if ([theDate isYesterday]) {
      [formatter setDateFormat:FORMAT_YESTERDAY];
    } else if ([theDate isThisWeek]) {
      [formatter setDateFormat:FORMAT_THIS_WEEK];
    } else {
      [formatter setDateFormat:FORMAT_PAST];
    }
    output = [formatter stringFromDate:theDate];
  }

  return output;
}


+ (NSString *)dictionary2String:(NSDictionary *)dictionary {
  if (![dictionary count]) {
    return nil;
  }

  NSString *tempStr1 = [[dictionary description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
  NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
  NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
  NSString *str = [NSPropertyListSerialization propertyListFromData:tempData
                                                   mutabilityOption:NSPropertyListImmutable
                                                             format:NULL
                                                   errorDescription:NULL];
  return str;
}


@end