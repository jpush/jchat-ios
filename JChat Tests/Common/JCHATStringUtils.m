//
//  JCHATStringUtils.m
//  JChat Tests
//
//  Created by Javen on 15/5/27.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSDate+Utilities.h"
#import "JCHATStringUtils.h"

@interface JCHATStringUtilsTests : XCTestCase

@end

@implementation JCHATStringUtilsTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testGetFriendlyDateString_Full {
  // just now
  NSDate *theDate = [NSDate dateWithTimeIntervalSinceNow:-10];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970]);

  // minutes
  theDate = [NSDate dateWithMinutesBeforeNow:3];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970]);

  // today
  theDate = [NSDate dateWithHoursBeforeNow:2];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970]);

  // yesterday
  theDate = [NSDate dateWithHoursBeforeNow:24];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970]);
  
  // this week
  theDate = [NSDate dateWithDaysBeforeNow:2];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970]);
  
  // past days
  theDate = [NSDate dateWithDaysBeforeNow:10];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970]);
  

  XCTAssert(YES, @"Pass");
}

- (void)testGetFriendlyDateString_Short {
  // just now
  NSDate *theDate = [NSDate dateWithTimeIntervalSinceNow:-10];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970
                                                        forConversation:YES]);

  // minutes
  theDate = [NSDate dateWithMinutesBeforeNow:3];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970
                                                        forConversation:YES]);

  // today
  theDate = [NSDate dateWithHoursBeforeNow:2];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970
                                                        forConversation:YES]);

  // yesterday
  theDate = [NSDate dateWithHoursBeforeNow:24];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970
                                                        forConversation:YES]);

  // this week
  theDate = [NSDate dateWithDaysBeforeNow:2];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970
                                                        forConversation:YES]);

  // past days
  theDate = [NSDate dateWithDaysBeforeNow:10];
  NSLog(@"The dateString - %@", [JCHATStringUtils getFriendlyDateString:theDate.timeIntervalSince1970
                                                        forConversation:YES]);

  XCTAssert(YES, @"Pass");
}

@end
