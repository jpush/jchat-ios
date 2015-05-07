//
//  JPIMSettingViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JPIMSettingViewController.h"
#import "JPIMCommon.h"
#import "JPIMSetting_Cell.h"
#import "JPIMNewsReminderCtl.h"
#import "JPIMUpdatePasswordCtl.h"
#import "MBProgressHUD+Add.h"
#import <JMessage/JMessage.h>
@interface JPIMSettingViewController ()<UIGestureRecognizerDelegate>
{
    NSArray *titleArr;
    
    UITableView *settingTabl;
}
@end

@implementation JPIMSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JPIMLog(@"Action");
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x3f80dd);
    self.navigationController.navigationBar.alpha=0.8;
    self.title=@"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont boldSystemFontOfSize:18], UITextAttributeFont,
                                                                     nil]]; UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
    titleArr = @[@"密码修改"];
    settingTabl =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kScreenHeight-kNavigationBarHeight-kStatusBarHeight)];
    [settingTabl setBackgroundColor:[UIColor whiteColor]];
    settingTabl.scrollEnabled=NO;
    settingTabl.dataSource=self;
    settingTabl.delegate=self;
    settingTabl.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:settingTabl];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"setCell";
    JPIMSetting_Cell *cell = (JPIMSetting_Cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JPIMSetting_Cell" owner:self options:nil] lastObject];
    }
    cell.textLabel.text=[titleArr objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row==0) {
//        JPIMNewsReminderCtl *newsReminderCtl =[[JPIMNewsReminderCtl alloc] init];
//        [self.navigationController pushViewController:newsReminderCtl animated:YES];
//    }
    if (indexPath.row==0) {
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"修改密码前请输入原密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alerView.alertViewStyle=UIAlertViewStyleSecureTextInput;
        [alerView show];
    }
//    if (indexPath.row==2) {
//        
//    }
}

- (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:YES];
        //    // 禁用 iOS7 返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
               self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }else if (buttonIndex==1)
    {
        if (![[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
            [[alertView textFieldAtIndex:0] resignFirstResponder];
          
            JPIMLog(@"%@ %@",[alertView textFieldAtIndex:0].text, [JMSGUserManager getMyInfo].password);
            if ([[alertView textFieldAtIndex:0].text isEqualToString:[JMSGUserManager getMyInfo].password] ) {
                
                JPIMUpdatePasswordCtl *updateWordCtl =[[JPIMUpdatePasswordCtl alloc] init];
                [self.navigationController pushViewController:updateWordCtl animated:YES];
            }
            [MBProgressHUD showMessage:@"输入原密码错误" view:self.view];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
