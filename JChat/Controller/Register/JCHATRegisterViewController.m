//
//  JCHATRegisterViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATRegisterViewController.h"
#import "JChatConstants.h"
#import "NSString+MessageInputView.h"
#import "JCHATSetDetailViewController.h"
#import "JCHATTimeOutManager.h"

@interface JCHATRegisterViewController ()

@end

@implementation JCHATRegisterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  [self setupNavigationBar];
  [self layoutAllView];
}

- (void)setupNavigationBar {
  self.title = @"极光IM";
  
  UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [backBtn setFrame:kNavigationLeftButtonRect];
  
  [backBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
  [backBtn setImageEdgeInsets:kGoBackBtnImageOffset];
  [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
  self.navigationItem.leftBarButtonItem = backItem;
  self.navigationController.navigationBar.translucent = NO;
}

- (void)layoutAllView {
  self.registerBtn.layer.cornerRadius = 4;
  [self.registerBtn.layer setMasksToBounds:YES];
  [self.registerBtn setBackgroundImage:[ViewUtil colorImage:UIColorFromRGB(0x3f80de) frame:self.registerBtn.frame] forState:UIControlStateNormal];
  [self.registerBtn setBackgroundImage:[ViewUtil colorImage:UIColorFromRGB(0x2840b0) frame:self.registerBtn.frame] forState:UIControlStateHighlighted];
  [self.usernameTextField becomeFirstResponder];
  self.passwordTextField.secureTextEntry = YES;
  self.passwordTextField.keyboardType = UIKeyboardTypeDefault;

}

- (void)doBack:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.usernameTextField resignFirstResponder];
  [self.passwordTextField resignFirstResponder];
}

- (IBAction)registerBtnClick:(id)sender {
  DDLogDebug(@"Action - registerBtnClick");
  if ([self.usernameTextField.text isEqualToString:@""]) {
    [MBProgressHUD showMessage:@"用户名不能为空" view:self.view];
    return;
  }
  
  if ([self.passwordTextField.text isEqualToString:@""]) {
    [MBProgressHUD showMessage:@"密码不能为空" view:self.view];
    return;
  }
  
  [self.usernameTextField resignFirstResponder];
  [self.passwordTextField resignFirstResponder];
  
  NSString *username = self.usernameTextField.text.stringByTrimingWhitespace;
  NSString *password = self.passwordTextField.text.stringByTrimingWhitespace;
  
  if ([self checkValidUsername:username AndPassword:password]) {
    [MBProgressHUD showMessage:@"正在注册" view:self.view];
    [[JCHATTimeOutManager ins] startTimerWithVC:self];
    [JMSGUser registerWithUsername:username
                          password:password
                 completionHandler:^(id resultObject, NSError *error) {
                   [[JCHATTimeOutManager ins] stopTimer];
                   if (error == nil) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [MBProgressHUD showMessage:@"注册成功" view:self.view];
                     [[JCHATTimeOutManager ins] startTimerWithVC:self];
                     [JMSGUser loginWithUsername:username
                                        password:password
                               completionHandler:^(id resultObject, NSError *error) {
                                 [[JCHATTimeOutManager ins] stopTimer];
                                 if (error == nil) {
                                   [[NSUserDefaults standardUserDefaults] setObject:username forKey:kuserName];
                                   [[NSUserDefaults standardUserDefaults] setObject:username forKey:klastLoginUserName];
                                   
                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   JCHATSetDetailViewController *detailVC = [[JCHATSetDetailViewController alloc] init];
                                   [self.navigationController pushViewController:detailVC animated:YES];
                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 } else {
                                   DDLogDebug(@"login fail error  %@",error);
                                   NSString *alert = [JCHATStringUtils errorAlert:error];
                                   alert = [JCHATStringUtils errorAlert:error];
                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   [MBProgressHUD showMessage:alert view:self.view];
                                   DDLogError(alert);
                                 }
                               }];
                   } else {
                     NSString *alert = @"注册失败";
                     alert = [JCHATStringUtils errorAlert:error];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [MBProgressHUD showMessage:alert view:self.view];
                   }
                 }];
  }
}

- (void)userLoginSave {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:self.usernameTextField.text forKey:kuserName];
  [userDefaults setObject:self.passwordTextField.text forKey:kPassword];
  [userDefaults synchronize];
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
