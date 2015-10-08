//
//  JCHATAlertViewWait.h
//  JChat
//
//  Created by HuminiOS on 15/8/6.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCHATAlertViewWait : NSObject
@property(strong,nonatomic)UIView *alertView;

+ (JCHATAlertViewWait *)ins;

- (void)showInView;

- (void)hidenAll;
@end
