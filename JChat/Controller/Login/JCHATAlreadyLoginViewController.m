//
//  JCHATAlreadyLoginViewController.m
//  JPush IM
//
//  Created by Apple on 15/2/2.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATAlreadyLoginViewController.h"
#import "JChatConstants.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
#import "JCHATLoginViewController.h"
#import <JMessage/JMessage.h>
#import "NSString+MessageInputView.h"
#import "JCHATRegisterViewController.h"
#import "ViewUtil.h"

@interface JCHATAlreadyLoginViewController ()

@end

@implementation JCHATAlreadyLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  // Do any additional setup after loading the view from its nib.
  _loginBtn.layer.cornerRadius=4;
  [_loginBtn.layer setMasksToBounds:YES];
  [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _loginBtn.backgroundColor = UIColorFromRGB(0x6fd66b);
  [_loginBtn setBackgroundImage:[ViewUtil colorImage:UIColorFromRGB(0x498d47) frame:_loginBtn.frame] forState:UIControlStateHighlighted];
  
  NSString *userName =[[NSUserDefaults standardUserDefaults] objectForKey:klastLoginUserName];
  self.navigationController.navigationBar.barTintColor =kNavigationBarColor;
  self.navigationController.navigationBar.translucent = NO;
  
  [_userName setTitle:userName forState:UIControlStateNormal];
  self.title=@"极光IM";
  [_passwordField setSecureTextEntry:YES];
  [_passwordField becomeFirstResponder];
  
  NSShadow *shadow = [[NSShadow alloc]init];
  [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   shadow,NSShadowAttributeName,
                                                                   [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                                                   nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (IBAction)userSwitchingBtnClick:(id)sender {
  JCHATLoginViewController *loginCtl = [[JCHATLoginViewController alloc] initWithNibName:@"JCHATLoginViewController" bundle:nil];
  [self.navigationController pushViewController:loginCtl animated:YES];
//  UINavigationController *nvloginCtl = [[UINavigationController alloc] initWithRootViewController:loginCtl];
//  AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//  appDelegate.window.rootViewController = nvloginCtl;
}

- (IBAction)loginBtnClick:(id)sender {
  
  [MBProgressHUD showMessage:@"正在登陆" toView:self.view];
  if (![_passwordField.text isEqualToString:@""] && ![_passwordField.text isEqualToString:@""]) {
    NSString *username = ([[NSUserDefaults standardUserDefaults] objectForKey:klastLoginUserName]);
    NSString *password = _passwordField.text.stringByTrimingWhitespace;
    [JMSGUser loginWithUsername:username
                       password:password
              completionHandler:^(id resultObject, NSError *error) {
                if (error == nil) {
                  [[NSUserDefaults standardUserDefaults] setObject:username forKey:klastLoginUserName];
                  [[NSUserDefaults standardUserDefaults] setObject:username forKey:kuserName];

                  JPIMMAINTHEAD(^{
                    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                    appDelegate.window.rootViewController = appDelegate.tabBarCtl;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                  });
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:kupdateUserInfo object:nil];
                } else {
                  if (error.code == 100) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [MBProgressHUD showMessage:@"用户不存在!" view:self.view];
                  } else {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [MBProgressHUD showMessage:@"登录失败!" view:self.view];
                  }
                }
              }];
  }else{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showMessage:@"密码不能为空!" view:self.view];
  }
  
}
- (IBAction)registerBtnClick:(id)sender {
  DDLogDebug(@"Action - registerBtnClick");
  JCHATRegisterViewController *registerCtl = [[JCHATRegisterViewController alloc] initWithNibName:@"JCHATRegisterViewController" bundle:nil];
  [self.navigationController pushViewController:registerCtl animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --触摸屏幕
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.passwordField resignFirstResponder];
}

@end
