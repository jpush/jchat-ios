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
@implementation JCHATAlertViewWait
+ (JCHATAlertViewWait *)ins {
  static JCHATAlertViewWait *alertwait = nil;
  if (alertwait == nil) {
    alertwait = [[JCHATAlertViewWait alloc] init];

  }
  return alertwait;
}

- (id)init {
  self = [super init];
  if (self) {
//    self.alertView = [UIView new];
  }
  return self;
}

- (void)showInView:(UIView *)needshowview {
  NSLog(@"kaishi   show in view");
  self.alertView = [UIView new];
//  self.alertView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 300, 300)];
  self.alertView.alpha = 0.5;
  self.alertView.backgroundColor = [UIColor grayColor];
  [needshowview addSubview:self.alertView];
  [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(needshowview);
    make.top.mas_equalTo(needshowview);
    make.left.mas_equalTo(needshowview);
    make.bottom.mas_equalTo(needshowview);
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
  [clockImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(17, 17));
    make.centerY.mas_equalTo(alertHub);
    make.centerX.mas_equalTo(alertHub).with.offset(-30);
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
  
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
  button.backgroundColor = [UIColor yellowColor];
  [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
  [self.alertView addSubview:button];
}

- (void)click {
  [[JCHATAlertViewWait ins] hidenAll];
}


- (void)hidenAll {
  [self.alertView removeFromSuperview];
  self.alertView = nil;
}

@end
