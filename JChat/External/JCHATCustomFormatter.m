//
// Created by Javen on 15/5/8.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import "JCHATCustomFormatter.h"
#import "JChatConstants.h"


@implementation JCHATCustomFormatter {

}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
  NSString *logLevel;
  switch (logMessage->_flag) {
    case DDLogFlagError    : logLevel = @"  ERROR"; break;
    case DDLogFlagWarning  : logLevel = @"   WARN"; break;
    case DDLogFlagInfo     : logLevel = @"   INFO"; break;
    case DDLogFlagDebug    : logLevel = @"  DEBUG"; break;
    default                : logLevel = @"VERBOSE"; break;
  }

  return [NSString stringWithFormat:@"%@ | %@ | %@\n", JCHAT_LOG_PREFIX, logLevel, logMessage->_message];
}

@end