//
// Created by Javen on 15/5/11.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import "JCHATStringUtils.h"
#import "NSDate+Utilities.h"

@implementation JCHATStringUtils {

}

static NSString * const FORMAT_PAST_SHORT = @"yyyy/MM/dd";
static NSString * const FORMAT_PAST_TIME = @"ahh:mm";
static NSString * const FORMAT_THIS_WEEK = @"eee ahh:mm";
static NSString * const FORMAT_THIS_WEEK_SHORT = @"eee";
static NSString * const FORMAT_YESTERDAY = @"ahh:mm";
static NSString * const FORMAT_TODAY = @"ahh:mm";

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval {
  return [JCHATStringUtils getFriendlyDateString:timeInterval forConversation:NO];
}

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
+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)isShort {
  NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  NSString *output = nil;

  NSTimeInterval theDiff = -theDate.timeIntervalSinceNow;

  //上述时间差输出不同信息
  if (theDiff < 60) {
    output = @"刚刚";

  } else if (theDiff < 60 * 60) {
    int minute = (int) (theDiff / 60);
    output = [NSString stringWithFormat:@"%d分钟前", minute];

  } else {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [formatter setLocale:locale];

    BOOL isTodayYesterday = NO;
    BOOL isPastLong = NO;

    if ([theDate isToday]) {
      [formatter setDateFormat:FORMAT_TODAY];
    } else if ([theDate isYesterday]) {
      [formatter setDateFormat:FORMAT_YESTERDAY];
      isTodayYesterday = YES;
    } else if ([theDate isThisWeek]) {
      if (isShort) {
        [formatter setDateFormat:FORMAT_THIS_WEEK_SHORT];
      } else {
        [formatter setDateFormat:FORMAT_THIS_WEEK];
      }
    } else {
      if (isShort) {
        [formatter setDateFormat:FORMAT_PAST_SHORT];
      } else {
        [formatter setDateFormat:FORMAT_PAST_TIME];
        isPastLong = YES;
      }
    }

    if (isTodayYesterday) {
      NSString *todayYesterday = [JCHATStringUtils getTodayYesterdayString:theDate];
      if (isShort) {
        output = todayYesterday;
      } else {
        output = [formatter stringFromDate:theDate];
        output = [NSString stringWithFormat:@"%@ %@", todayYesterday, output];
      }
    } else {
      output = [formatter stringFromDate:theDate];
      if (isPastLong) {
        NSString *thePastDate = [JCHATStringUtils getPastDateString:theDate];
        output = [NSString stringWithFormat:@"%@ %@", thePastDate, output];
      }
    }
  }

  return output;
}

+ (NSString *)getTodayYesterdayString:(NSDate *)theDate {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
  [formatter setLocale:locale];
  formatter.dateStyle = NSDateFormatterShortStyle;
  formatter.timeStyle = NSDateFormatterNoStyle;
  formatter.doesRelativeDateFormatting = YES;
  return [formatter stringFromDate:theDate];
}

+ (NSString *)getPastDateString:(NSDate *)theDate {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
  [formatter setLocale:locale];
  formatter.dateStyle = NSDateFormatterLongStyle;
  formatter.timeStyle = NSDateFormatterNoStyle;
  return [formatter stringFromDate:theDate];
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