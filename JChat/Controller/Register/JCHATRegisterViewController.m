//
//  JCHATRegisterViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATRegisterViewController.h"
#import "JCHATRegisterDetailViewController.h"
#import "JChatConstants.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import <CommonCrypto/CommonDigest.h>
#import <JMessage/JMessage.h>
@interface JCHATRegisterViewController ()

@end

@implementation JCHATRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JPIMLog(@"Action");
    // Do any additional setup after loading the view from its nib.
    self.registerBtn.layer.cornerRadius=4;
    [self.registerBtn.layer setMasksToBounds:YES];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x3f80dd);
    self.navigationController.navigationBar.alpha=0.8;
    self.title=@"极光IM";
    self.passwordField.secureTextEntry=YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont boldSystemFontOfSize:18], UITextAttributeFont,
                                                                     nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --触摸屏幕
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.accountField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)registerBtnClick:(id)sender {
    [self.accountField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [MBProgressHUD showMessage:@"正在注册" view:self.view];
    if (![self.passwordField.text isEqualToString:@""] && ![self.accountField.text isEqualToString:@""]) {
        [JMSGUserManager registerWithUsername:self.accountField.text password:self.passwordField.text completionHandler:^(id resultObject, NSError *error) {
            if (error ==nil) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showSuccess:@"注册成功！" toView:self.view];
                JCHATRegisterDetailViewController *registerDetail = [[JCHATRegisterDetailViewController alloc] initWithNibName:@"JCHATRegisterDetailViewController" bundle:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                if (error.code == 1004 ) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showSuccess:@"用户已经存在！" toView:self.view];
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showSuccess:@"注册失败！" toView:self.view];
                }
            }
        }];
    }else if ([self.passwordField.text isEqualToString:@""] && [self.accountField.text isEqualToString:@""]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessage:@"请输入账号和密码" view:self.view];
    }else if ([self.accountField.text isEqualToString:@""]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessage:@"账号不能为空..." view:self.view];
    }else if ([self.passwordField.text isEqualToString:@""]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessage:@"密码不能为空..." view:self.view];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
