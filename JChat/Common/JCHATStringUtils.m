//
// Created by Javen on 15/5/11.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import "JCHATStringUtils.h"


@implementation JCHATStringUtils {

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