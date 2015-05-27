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

- (void)testGetFriendlyDateString {
  NSDate *theDate = [NSDate dateWithMinutesFromNow:62];
  
  NSTimeInterval theInterval = theDate.timeIntervalSince1970;
  NSString *result = [JCHATStringUtils getFriendlyDateString:theInterval];
  
  NSLog(@"The dateString - %@", result);

  XCTAssert(YES, @"Pass");
}


@end
