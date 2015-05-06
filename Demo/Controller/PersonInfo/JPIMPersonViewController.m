//
//  JPIMPersonViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JPIMPersonViewController.h"
#import "Common.h"
#import "JPIMpersonInfoCell.h"
#import "ChatTable.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "MobClick.h"
#import <JMessage/JMessage.h>

@interface JPIMPersonViewController ()<TouchTableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    ChatTable *_personTabl;
    NSArray *_titleArr;
    NSArray *_imgArr;
    NSMutableArray *_infoArr;
}
@end

@implementation JPIMPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JPIMLog(@"Action");
    [self.view setBackgroundColor:[UIColor whiteColor]];
     self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x3f80dd);
    self.navigationController.navigationBar.alpha=0.8;
    self.title=@"个人信息";
    [self loadUserInfoData];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont boldSystemFontOfSize:18], UITextAttributeFont,
                                                                     nil]];
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
    _personTabl =[[ChatTable alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kScreenHeight-kNavigationBarHeight-kStatusBarHeight)];
    _personTabl.touchDelegate = self;
    [_personTabl setBackgroundColor:[UIColor whiteColor]];
    _personTabl.scrollEnabled=NO;
    _personTabl.dataSource=self;
    _personTabl.delegate=self;
    _personTabl.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_personTabl];
    NSString *name;
    JMSGUser *user = [JMSGUserManager getMyInfo];
    if (user.nickname) {
        name = user.nickname;
    }else {
        name = user.username;
    }
    _titleArr = @[@"昵称",@"性别",@"地区",@"个性签名"];
    _imgArr = @[@"wo_20",@"gender",@"location_21",@"signature"];
}

- (void)loadUserInfoData {
    _infoArr = [[NSMutableArray alloc]init];
    NSString *name;
    JMSGUser *user = [JMSGUserManager getMyInfo];

    if (user.nickname) {
        name = user.nickname;
    } else{
        name = user.username;
    }
    [_infoArr addObject:name];

    if ([user.userGender integerValue]==0) {
        [_infoArr addObject:@"未知"];
    } else if ([user.userGender integerValue] == 1){
        [_infoArr addObject:@"男"];
    } else {
        [_infoArr addObject:@"女"];
    }
    if (user.region) {
        [_infoArr addObject:user.region];
    } else {
        [_infoArr addObject:@""];
    }
    if (user.signature) {
        [_infoArr addObject:user.signature];
    } else {
        [_infoArr addObject:@""];
    }
}

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"JPIMpersonInfoCell";
    JPIMpersonInfoCell *cell = (JPIMpersonInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JPIMpersonInfoCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.infoTitleLabel.text=[_titleArr objectAtIndex:indexPath.row];
    cell.personInfoConten.text=[_infoArr objectAtIndex:indexPath.row];
    cell.titleImgView.image=[UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArr =@[@"输入昵称",@"输入性别",@"输入地区",@"个性签名"];
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:[titleArr objectAtIndex:indexPath.row] message:nil
                                                     delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
    alerView.tag =indexPath.row;
    [alerView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    JMSGUser *user = [JMSGUserManager getMyInfo];
    if (buttonIndex ==1) {
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        [MBProgressHUD showMessage:@"正在修改" toView:self.view];
        if (![[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
            if (alertView.tag == 0) {
                [JMSGUserManager updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text withType:kJMSGNickname completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        JPIMpersonInfoCell *cell = (JPIMpersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
                        cell.personInfoConten.text = user.nickname;
                        [MBProgressHUD showMessage:@"修改成功" view:self.view];
                    } else {
                        [MBProgressHUD showMessage:@"修改失败" view:self.view];
                    }
                }];
            } else if (alertView.tag ==1) {
                [JMSGUserManager updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text withType:kJMSGGender completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                    if (error == nil) {
                        JPIMpersonInfoCell *cell = (JPIMpersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
                        if ([user.userGender integerValue] == 1) {
                            cell.personInfoConten.text = @"男";

                        } else if ([user.userGender integerValue] == 2) {
                            cell.personInfoConten.text = @"女";
                        } else {
                            cell.personInfoConten.text = @"未知";
                        }
                        [MBProgressHUD showMessage:@"修改成功" view:self.view];

                    } else {
                        [MBProgressHUD showMessage:@"修改失败" view:self.view];
                    }
                }];
            } else if (alertView.tag == 2) {
                [JMSGUserManager updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text withType:kJMSGRegion completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        JPIMpersonInfoCell *cell = (JPIMpersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
                        cell.personInfoConten.text = user.region;
                        [MBProgressHUD showMessage:@"修改成功" view:self.view];
                    } else {
                        [MBProgressHUD showMessage:@"修改失败" view:self.view];
                    }
                }];
            } else if (alertView.tag ==3) {
                [JMSGUserManager updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text withType:kJMSGSignature completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        [MBProgressHUD showMessage:@"修改成功" view:self.view];
                        JPIMpersonInfoCell *cell = (JPIMpersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
                        cell.personInfoConten.text = user.signature;
                    } else {
                        [MBProgressHUD showMessage:@"修改失败" view:self.view];
                    }
                }];
            }
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
       }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
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
