//
// Created by Javen on 15/5/8.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import <libkern/OSAtomic.h>
#import "JCHATCustomFormatter.h"


@implementation JCHATCustomFormatter {
  //thread safe
  int atomicLoggerCount;
  NSDateFormatter *threadUnsafeDateFormatter;
}


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{
  NSString *logLevel = nil;
  switch (logMessage->_flag) {
    case LOG_FLAG_ERROR:
      logLevel = @"E";
      break;
    case LOG_FLAG_WARN:
      logLevel = @"W";
      break;
    case LOG_FLAG_INFO:
      logLevel = @"I";
      break;
    case LOG_FLAG_DEBUG:
      logLevel = @"D";
      break;
    default:
      logLevel = @"V";
      break;
  }

  //获取当前时区时间
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];

  [dateFormatter setDateStyle:NSDateFormatterFullStyle];

  NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)];

  NSString *formatStr = [NSString stringWithFormat:@"%@ | %@ | %@ - [%@] %@", dateAndTime,
          COMMON_LOGGER_NAME, logLevel, logMessage.fileName, logMessage->_message];
  return formatStr;
}



- (NSString *)stringFromDate:(NSDate *)date {
  int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);

  NSString *timeFormatString = @"yyyy-MM-dd HH:mm:ss.SSS";

  if (loggerCount <= 1) {
    // Single-threaded mode.

    if (threadUnsafeDateFormatter == nil) {
      threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
      [threadUnsafeDateFormatter setDateFormat:timeFormatString];
    }

    return [threadUnsafeDateFormatter stringFromDate:date];
  } else {
    // Multi-threaded mode.
    // NSDateFormatter is NOT thread-safe.

    NSString *key = @"MyCustomFormatter_NSDateFormatter";

    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[key];

    if (dateFormatter == nil) {
      dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:timeFormatString];

      threadDictionary[key] = dateFormatter;
    }

    return [dateFormatter stringFromDate:date];
  }
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&atomicLoggerCount);
}

@end