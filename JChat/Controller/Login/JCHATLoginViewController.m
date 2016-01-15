//
//  RootViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/23.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATLoginViewController.h"
#import "JCHATTabBarViewController.h"
#import "JCHATRegisterViewController.h"
#import "AppDelegate.h"
#import "NSString+MessageInputView.h"
#import "JChatConstants.h"
#import "JCHATTimeOutManager.h"

@interface JCHATLoginViewController ()

@property(weak, nonatomic) IBOutlet UILabel *userNameLine;
@property(weak, nonatomic) IBOutlet UILabel *passwordLine;
@property(weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(weak, nonatomic) IBOutlet UIButton *registerBtn;
@property(weak, nonatomic) IBOutlet UIButton *loginBtn;
@property(assign, nonatomic)BOOL logging;
@end


@implementation JCHATLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  [self layoutAllView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(dBMigrateFinish)
                                               name:kDBMigrateFinishNotification object:nil];
  
  AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
  if (appDelegate.isDBMigrating) {
    NSLog(@"is DBMigrating don't get allconversations");
    [MBProgressHUD showMessage:@"正在升级数据库" toView:self.view];
  }
}

- (void)dBMigrateFinish {
  JCHATMAINTHREAD(^{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  });
}

- (void)layoutAllView {
  self.navigationController.navigationBar.translucent = NO;
  if ([[NSUserDefaults standardUserDefaults] objectForKey:klastLoginUserName] == nil) {
    self.navigationItem.hidesBackButton = YES;
  } else {
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:kNavigationLeftButtonRect];
    [leftBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  }

  [self.view setBackgroundColor:[UIColor colorWithRed:72 / 255.0 green:62 / 255.0 blue:39 / 255.0 alpha:1.0]];
  _passwordTextField.secureTextEntry = YES;
  _passwordTextField.keyboardType = UIKeyboardTypeDefault;
  self.title = @"极光IM";
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
  [_userNameLine setBackgroundColor:[UIColor grayColor]];//TODO: UI 分开
  [_passwordLine setBackgroundColor:[UIColor grayColor]];
  
  _userNameLine.alpha = 0.5;
  _passwordLine.alpha = 0.5;
  [_loginBtn setBackgroundImage:[ViewUtil colorImage:UIColorFromRGB(0x6fd66b) frame:_loginBtn.frame] forState:UIControlStateNormal];
  [_loginBtn setBackgroundImage:[ViewUtil colorImage:UIColorFromRGB(0x498d67) frame:_loginBtn.frame] forState:UIControlStateHighlighted];
  _loginBtn.layer.cornerRadius = 4;
  [_loginBtn.layer setMasksToBounds:YES];
  [_usernameTextField becomeFirstResponder];
}

- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  _usernameTextField.text = @"";
  _passwordTextField.text = @"";
  [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:YES];
}

- (void)requestTimeout {
  DDLogDebug(@"login request timeout");
  if (_logging == YES) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  }
}

#pragma mark --登录按钮响应
- (IBAction)loginBtnClick:(id)sender {
  DDLogDebug(@"Action - loginBtnClick");
  [_passwordTextField resignFirstResponder];
  [_usernameTextField resignFirstResponder];
  
  NSString *username = _usernameTextField.text.stringByTrimingWhitespace;
  NSString *password = _passwordTextField.text.stringByTrimingWhitespace;
  
  if ([self checkValidUsername:username AndPassword:password]) {
    _logging = YES;
    [MBProgressHUD showMessage:@"正在登陆" toView:self.view];
    [[JCHATTimeOutManager ins] startTimerWithVC:self];
    [JMSGUser loginWithUsername:username
                       password:password
              completionHandler:^(id resultObject, NSError *error) {
                [[JCHATTimeOutManager ins] stopTimer];
                _logging = NO;
                if (error == nil) {
                  [[NSUserDefaults standardUserDefaults] setObject:username forKey:klastLoginUserName];
                  AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                  [appDelegate setupMainTabBar];
                  [appDelegate.tabBarCtl setSelectedIndex:0];
                  // 显示登录状态？
                  appDelegate.window.rootViewController = appDelegate.tabBarCtl;
                  [MBProgressHUD hideAllHUDsForView:self.view animated:NO];

                  [[NSNotificationCenter defaultCenter] postNotificationName:kupdateUserInfo object:nil];
                  [self userLoginSave];
                } else {
                  JCHATMAINTHREAD(^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  });
                  [MBProgressHUD showMessage:[JCHATStringUtils errorAlert:error] view:self.view];
                }
              }];
    
  }
}

- (BOOL)checkValidUsername:username AndPassword:password {
  if (![password isEqualToString:@""] && ![username isEqualToString:@""]) {
    return YES;
  }
  
  NSString *alert = @"用户名或者密码不合法.";
  if ([username isEqualToString:@""]) {
    alert =  @"用户名不能为空";
  } else if ([password isEqualToString:@""]) {
    alert = @"密码不能为空";
  }
  
  [MBProgressHUD hideHUDForView:self.view animated:YES];
  [MBProgressHUD showMessage:alert view:self.view];
  
  DDLogError(alert);
  
  return NO;
}

- (void)userLoginSave {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:_usernameTextField.text forKey:kuserName];
  [userDefaults setObject:_passwordTextField.text forKey:kPassword];
  [userDefaults synchronize];
}

#pragma mark --注册按钮响应
- (IBAction)registerBtnClick:(id)sender {
  DDLogDebug(@"Action - registerBtnClick");
  JCHATRegisterViewController *registerCtl = [[JCHATRegisterViewController alloc] initWithNibName:@"JCHATRegisterViewController" bundle:nil];
  [self.navigationController pushViewController:registerCtl animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_usernameTextField resignFirstResponder];
  [_passwordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
