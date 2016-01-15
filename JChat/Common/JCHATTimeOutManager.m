//
//  JCHATTimeOutManager.m
//  JChat
//
//  Created by HuminiOS on 15/11/2.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATTimeOutManager.h"

@interface JCHATTimeOutManager ()
{
  NSTimer *Gtimer;
  UIViewController *viewController;
}

@end

@implementation JCHATTimeOutManager
static JCHATTimeOutManager *timeoutManager = nil;
+ (JCHATTimeOutManager *)ins {

  if (timeoutManager == nil) {
    timeoutManager = [[JCHATTimeOutManager alloc] init];
  }
  return timeoutManager;
}

- (void)startTimerWithVC:(UIViewController *)viewCtl {
  viewController = viewCtl;
  Gtimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
}

- (void)stopTimer {
  [Gtimer invalidate];
  Gtimer = nil;
  timeoutManager = nil;
}

- (void)timerFired: (NSTimer *)timer {
  [MBProgressHUD hideAllHUDsForView:viewController.view animated:YES];
  viewController = nil;
  [Gtimer invalidate];
  Gtimer = nil;
  timeoutManager = nil;
}

+ (void)releaseMemery {
  timeoutManager = nil;
}
@end
