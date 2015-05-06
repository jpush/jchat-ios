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
- (NSString *)getTimeDate :(NSTimeInterval) time {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

#pragma mark --获取当前的时间
- (NSString *)getCurrentTimeDate {
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

#pragma mark --获取当前服务器纠正的时间戳
- (NSTimeInterval )getCurrentTimeInterval {
    NSTimeInterval timeInterval=[[NSDate date] timeIntervalSince1970];
    [JMessage correctTimerWithServer:&timeInterval];
    return timeInterval;
}

#pragma mark --时间格式化
- (NSString *)findendliyTime:(NSString *)dataTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置格式 年yyyy 月 MM 日dd 小时hh(HH) 分钟 mm 秒 ss MMM单月 eee周几 eeee星期几 a上午下午
    //与字符串保持一致
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //现在的时间转换成字符串
    NSDate * nowDate = [NSDate date];
    NSString * noewTime = [formatter stringFromDate:nowDate];
    //参数字符串转化成时间格式
    NSDate * date = [formatter dateFromString:dataTime];
    //参数时间距现在的时间差
    NSTimeInterval time = -[date timeIntervalSinceNow];
    NSLog(@"%f",time);
    //上述时间差输出不同信息
    if (time < 60) {
        return @"刚刚";
    }else if (time <3600){
        int minute = time/60;
        NSString * minuteStr = [NSString stringWithFormat:@"%d分钟前",minute];
        return  minuteStr;
    }else {
        //如果年不同输出某年某月某日
        if ([[dataTime substringToIndex:4] isEqualToString:[noewTime substringToIndex:4]]) {
            //截取字符串从下标为5开始 2个
            NSRange rangeM = NSMakeRange(5, 2);
            //如果月份不同输出某月某日某时
            if ([[dataTime substringWithRange:rangeM]isEqualToString:[noewTime substringWithRange:rangeM]]) {
                NSRange rangD = NSMakeRange(8, 2);
                //如果日期不同输出某日某时
                if ([[dataTime substringWithRange:rangD]isEqualToString:[noewTime substringWithRange:rangD]]) {
                    NSRange rangeSSD = NSMakeRange(11, 5);
                    NSString * Rstr = [NSString stringWithFormat:@"今日%@",[dataTime substringWithRange:rangeSSD]];
                    return  Rstr;
                }else{
                    NSRange rangSD = NSMakeRange(5, 5);
                    return [dataTime substringWithRange:rangSD];
                }
            }else{
                NSRange rangeSM = NSMakeRange(5,5);
                return [dataTime substringWithRange:rangeSM];
            }
        }else{
            return [dataTime substringToIndex:10];
        }
    }
}




@end
