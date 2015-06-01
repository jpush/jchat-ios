//
//  JCHATRegisterViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATRegisterViewController.h"
#import "JChatConstants.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "NSString+MessageInputView.h"
#import <JMessage/JMessage.h>


@interface JCHATRegisterViewController ()

@end

@implementation JCHATRegisterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");

  self.registerBtn.layer.cornerRadius = 4;
  [self.registerBtn.layer setMasksToBounds:YES];
  self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x3f80dd);
  self.navigationController.navigationBar.alpha = 0.8;
  self.title = @"极光IM";
  self.passwordField.secureTextEntry = YES;

  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
  shadow.shadowOffset = CGSizeMake(0, -1);

  NSDictionary *dic = @{
      NSForegroundColorAttributeName:[UIColor whiteColor],
      NSShadowAttributeName:shadow,
      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
  };

  [self.navigationController.navigationBar setTitleTextAttributes:dic];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.accountField resignFirstResponder];
  [self.passwordField resignFirstResponder];
}

- (IBAction)registerBtnClick:(id)sender {
  DDLogDebug(@"Action - registerBtnClick");

  [self.accountField resignFirstResponder];
  [self.passwordField resignFirstResponder];
  [MBProgressHUD showMessage:@"正在注册" view:self.view];

  // 要去掉空格
  NSString *username = self.accountField.text.stringByTrimingWhitespace;
  NSString *password = self.passwordField.text.stringByTrimingWhitespace;

  if ([self checkValidUsername:username AndPassword:password]) {
    [JMSGUser registerWithUsername:username
                          password:password
                 completionHandler:^(id resultObject, NSError *error) {
      if (error == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"注册成功！" toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
      } else {
        NSString *alert = @"注册失败";
        if (error.code == JCHAT_ERROR_REGISTER_EXIST) {
          alert = @"用户已经存在！";
        } else if (error.code == JCHAT_ERROR_USER_PARAS_INVALID) {
          alert = @"用户名或者密码不合法";
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:alert toView:self.view];
      }
    }];
  }
}

// TODO javen 还没有加基本的有效性校验
- (BOOL)checkValidUsername:username AndPassword:password {
  if (![password isEqualToString:@""] && ![username isEqualToString:@""]) {
    return YES;
  }

  NSString *alert = @"用户名或者密码不合法.";
  if ([password isEqualToString:@""]) {
    alert = @"密码不能为空";
  } else if ([username isEqualToString:@""]) {
    alert =  @"用户名不能为空";
  }

  [MBProgressHUD hideHUDForView:self.view animated:YES];
  [MBProgressHUD showMessage:alert view:self.view];

  DDLogError(alert);

  return NO;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
}


@end
