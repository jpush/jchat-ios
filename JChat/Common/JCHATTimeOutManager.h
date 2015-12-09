//
//  JCHATTimeOutManager.h
//  JChat
//
//  Created by HuminiOS on 15/11/2.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCHATTimeOutManager : NSObject

+ (JCHATTimeOutManager *)ins;
+ (void)releaseMemery;

- (void)startTimerWithVC:(UIViewController *)viewCtl;
- (void)stopTimer;

@end
