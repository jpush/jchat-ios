//
//  JCHATAlertToSendImage.m
//  JChat
//
//  Created by oshumini on 15/12/9.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATAlertToSendImage.h"
#import "Masonry.h"
#import "JChatConstants.h"
#import "AppDelegate.h"

@implementation JCHATAlertToSendImage
+ (JCHATAlertToSendImage *)shareInstance {
  static JCHATAlertToSendImage *alertSendImage = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    alertSendImage = [[JCHATAlertToSendImage alloc] init];
  });
  return alertSendImage;
}

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)showInViewWith:(UIImage *) image{
  _preImage = image;
  self.alertView = [UIView new];
  self.alertView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
  AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
  UIWindow *myWindow = [UIApplication sharedApplication].windows.lastObject;

  myWindow.windowLevel = UIWindowLevelAlert;
  [myWindow addSubview:_alertView];
  [myWindow makeKeyAndVisible];

  [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(myWindow);
    make.top.mas_equalTo(myWindow).with.offset(0);
    make.left.mas_equalTo(myWindow);
    make.bottom.mas_equalTo(myWindow);
  }];

  UIView *alertHub = [UIView new];
  alertHub.backgroundColor = [UIColor whiteColor];
  alertHub.layer.cornerRadius = 5;
  alertHub.layer.masksToBounds = YES;
  
  [self.alertView addSubview:alertHub];
  [alertHub mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self.alertView);
    make.size.mas_equalTo(CGSizeMake(280, 235));
  }];

  UIImageView *imgView = [UIImageView new];
  imgView.contentMode = UIViewContentModeScaleAspectFit;
  [alertHub addSubview:imgView];
  imgView.image = image;
  [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(alertHub.mas_top).with.offset(15);
    make.left.mas_equalTo(alertHub.mas_left).with.offset(15);
    make.right.mas_equalTo(alertHub.mas_right).with.offset(-15);
    make.bottom.mas_equalTo(alertHub.mas_bottom).with.offset(-65);
  }];
  
  UIButton *leftBtn = [UIButton new];
  leftBtn.backgroundColor = [UIColor whiteColor];
  [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  leftBtn.layer.borderWidth = 0.5;
  leftBtn.layer.borderColor = [UIColor grayColor].CGColor;
  [alertHub addSubview:leftBtn];
  [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
  [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(50);
    make.width.mas_equalTo(140);
    make.left.mas_equalTo(alertHub.mas_left).with.offset(-1);
    make.bottom.mas_equalTo(alertHub.mas_bottom).with.offset(0);
  }];
  [leftBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];

  UIButton *rightBtn = [UIButton new];
  [rightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
  rightBtn.backgroundColor = [UIColor whiteColor];
  rightBtn.layer.borderWidth = 0.5;
  rightBtn.layer.borderColor = [UIColor grayColor].CGColor;
  [alertHub addSubview:rightBtn];
  [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
  [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(50);
    make.width.mas_equalTo(142);
    make.right.mas_equalTo(alertHub.mas_right).with.offset(0.5);
    make.bottom.mas_equalTo(alertHub.mas_bottom).with.offset(0);
  }];
  [rightBtn addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickCancel {
  [[JCHATAlertToSendImage shareInstance] removeAlertView];
}

- (void)clickSend {
  [[NSNotificationCenter defaultCenter] postNotificationName:kAlertToSendImage object:_preImage];
  [[JCHATAlertToSendImage shareInstance] removeAlertView];
}


- (void)removeAlertView {//rename
  [self.alertView removeFromSuperview];
  self.alertView = nil;
}
@end
