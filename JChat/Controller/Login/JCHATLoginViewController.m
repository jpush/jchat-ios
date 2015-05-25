//
//  RootViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/23.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATLoginViewController.h"
#import "JCHATTabBarViewController.h"
#import "MBProgressHUD.h"
#import "JCHATUserInfoViewController.h"
#import "JCHATContactsViewController.h"
#import "JCHATChatViewController.h"
#import "MBProgressHUD+Add.h"
#import "JCHATTabBarViewController.h"
#import "JChatConstants.h"
#import "JCHATRegisterViewController.h"
#import "JCHATAlreadyLoginViewController.h"
#import "AppDelegate.h"
#import <JMessage/JMessage.h>


@interface JCHATLoginViewController ()
{
    SInt64 uid;
    BOOL pushFlag;
}

@property (weak, nonatomic) IBOutlet UILabel *userNameLine;
@property (weak, nonatomic) IBOutlet UILabel *passwordLine;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation JCHATLoginViewController

- (void)dealloc {
//    [self unObserveAllNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    JPIMLog(@"Action");
    pushFlag=NO;
    [self.view setBackgroundColor:[UIColor colorWithRed:72/255.0 green:62/255.0 blue:39/255.0 alpha:1.0]];
    self.passwordField.secureTextEntry=YES;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x3f80dd);
    self.navigationController.navigationBar.alpha=0.8;
    self.title=@"极光IM";
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
    shadow.shadowOffset = CGSizeMake(0,-1);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow, NSShadowAttributeName,
                                                                     [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                                                     nil]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.userNameLine setBackgroundColor:[UIColor grayColor]];
    [self.passwordLine setBackgroundColor:[UIColor grayColor]];
    self.userNameLine.alpha=0.5;
    self.passwordLine.alpha=0.5;
    self.loginBtn.layer.cornerRadius=4;
    [self.loginBtn.layer setMasksToBounds:YES];
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark --增加通知
-(void)addNotification
{
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidSetup:)
//                          name:kJPFNetworkDidSetupNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidClose:)
//                          name:kJPFNetworkDidCloseNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidRegister:)
//                          name:kJPFNetworkDidRegisterNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidLogin:)
//                          name:kJPFNetworkDidLoginNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidReceiveMessage:)
//                          name:kJPFNetworkDidReceiveMessageNotification
//                        object:nil];
//    [defaultCenter addObserver:self
//                      selector:@selector(serviceError:)
//                          name:kJPFServiceErrorNotification
//                        object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (pushFlag) {
        [self.navigationController.navigationBar setHidden:NO];
    }else {
        [self.navigationController.navigationBar setHidden:YES];
    }
}

#pragma mark --登录按钮响应
- (IBAction)loginBtnClick:(id)sender {
    [MBProgressHUD showMessage:@"正在登陆" toView:self.view];
    if (![self.passwordField.text isEqualToString:@""] && ![self.accountField.text isEqualToString:@""]) {
        [JMSGUser loginWithUsername:self.accountField.text password:self.passwordField.text completionHandler:^(id resultObject, NSError *error) {
            if (error == nil) {
                AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                if ([appdelegate.tabBarCtl.loginIdentify isEqualToString:kHaveLogin]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                } else {
                    [self.navigationController pushViewController:appdelegate.tabBarCtl animated:YES];
                    pushFlag = NO;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kupdateUserInfo object:nil];
                [self userLoginSave];
                //登录成功
            } else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showMessage:@"登录失败!" view:self.view];
            }
        }];
    }else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showMessage:@"账号或者密码不能为空!" view:self.view];
    }
//    JCHATAlreadyLoginViewController *alreadyLoginCtl = [[JCHATAlreadyLoginViewController alloc] initWithNibName:@"JCHATAlreadyLoginViewController" bundle:nil];
//    [self.navigationController pushViewController:alreadyLoginCtl animated:YES];
}

-(void)userLoginSave
{
    NSUserDefaults *userDefalts =[NSUserDefaults standardUserDefaults];
    [userDefalts setObject:self.accountField.text forKey:kuserName];
    [userDefalts setObject:self.passwordField.text forKey:kPassword];
    [userDefalts synchronize];
}

-(void)click
{
    NSLog(@"successCallback ");
}
#pragma mark --注册按钮响应
- (IBAction)registerBtnClick:(id)sender {
    JCHATRegisterViewController *registerCtl = [[JCHATRegisterViewController alloc] initWithNibName:@"JCHATRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerCtl animated:YES];
    pushFlag=YES;
}

- (void)networkDidSetup:(NSNotification *)notification {
    
}

- (void)networkDidClose:(NSNotification *)notification {
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    
    
}

- (void)networkDidLogin:(NSNotification *)notification {
    
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
}

- (void)serviceError:(NSNotification *)notification {
    
}


#pragma mark --触摸屏幕
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.accountField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
