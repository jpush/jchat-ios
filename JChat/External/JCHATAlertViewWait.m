//
//  JCHATAlertViewWait.m
//  JChat
//
//  Created by HuminiOS on 15/8/6.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATAlertViewWait.h"
#import "Masonry.h"
#import "JChatConstants.h"
#import "AppDelegate.h"
@implementation JCHATAlertViewWait
+ (JCHATAlertViewWait *)ins {
  static JCHATAlertViewWait *alertwait = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    alertwait = [[JCHATAlertViewWait alloc] init];
  });
  return alertwait;
}

- (id)init {
  self = [super init];
  if (self) {
//    self.alertView = [UIView new];
  }
  return self;
}

- (void)showInView {

  self.alertView = [UIView new];
  self.alertView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
  AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
  [appDelegate.window addSubview:self.alertView];
  
  [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(appDelegate.window);
    make.top.mas_equalTo(appDelegate.window).with.offset(0);
    make.left.mas_equalTo(appDelegate.window);
    make.bottom.mas_equalTo(appDelegate.window);
  }];
  
  UIView *alertHub = [UIView new];
  alertHub.backgroundColor = [UIColor whiteColor];
  alertHub.layer.cornerRadius = 5;
  alertHub.layer.masksToBounds = YES;
  
  [self.alertView addSubview:alertHub];
  [alertHub mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self.alertView);
    make.size.mas_equalTo(CGSizeMake(270, 61));
  }];
  
  UIImageView *clockImage = [UIImageView new];
  [alertHub addSubview:clockImage];
  clockImage.image = [UIImage imageNamed:@"talking_icon_c_"];
  
  [clockImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(17, 17));
    make.centerY.mas_equalTo(alertHub);
    make.centerX.mas_equalTo(alertHub).with.offset(-45);
  }];
  
  UILabel *label = [UILabel new];
  [alertHub addSubview:label];
  label.text = @"请稍后.";
  [label setFont:[UIFont fontWithName:@"helvetica" size:20]];
  [label setTextColor:UIColorFromRGB(0x6f6f6f)];
  [label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(80, 22));
    make.centerY.mas_equalTo(alertHub);
    make.left.mas_equalTo(clockImage.mas_right).with.offset(15);
  }];
  
}

- (void)click {
  [[JCHATAlertViewWait ins] hidenAll];
}


- (void)hidenAll {
  [self.alertView removeFromSuperview];
  self.alertView = nil;
}

@end
