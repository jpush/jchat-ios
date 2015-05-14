//
// Created by Javen on 15/5/8.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import "JCHATCustomFormatter.h"


@implementation JCHATCustomFormatter {

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

  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];

  NSString *fixString = [dateFormatter stringFromDate:logMessage->_timestamp];

  NSString *formatStr = [NSString stringWithFormat:@"%@ | %@ | %@ - [%@] %@", fixString,
          logLevel, COMMON_LOGGER_NAME, logMessage.fileName, logMessage->_message];
  return formatStr;
}

@end