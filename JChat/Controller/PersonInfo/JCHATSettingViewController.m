//
//  JCHATSettingViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATSettingViewController.h"
#import "JChatConstants.h"
#import "JCHATSetting_Cell.h"
#import "JCHATNewsReminderCtl.h"
#import "JCHATUpdatePasswordCtl.h"
#import "MBProgressHUD+Add.h"
#import "JCHATAboutViewController.h"
#import "JCHATDebugViewController.h"

@interface JCHATSettingViewController ()<UIGestureRecognizerDelegate>
{
  NSArray *titleArr;
  
  UITableView *settingTabl;
}
@end

@implementation JCHATSettingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  [self setupNavigationBar];
  [self layoutAllView];
}

- (void)setupNavigationBar {
  self.navigationController.interactivePopGestureRecognizer.delegate = self;
  self.navigationController.navigationBar.translucent = NO;
  self.title = @"设置";
  
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:kNavigationLeftButtonRect];
  [leftBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
  [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
}

- (void)layoutAllView {
  titleArr = @[@"密码修改", @"关于", @"Debug"];
  settingTabl =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kScreenHeight-kNavigationBarHeight-kStatusBarHeight)];
  [settingTabl setBackgroundColor:[UIColor whiteColor]];
  settingTabl.scrollEnabled=NO;
  settingTabl.dataSource=self;
  settingTabl.delegate=self;
  settingTabl.separatorStyle=UITableViewCellSeparatorStyleNone;
  [settingTabl registerNib:[UINib nibWithNibName:@"JCHATSetting_Cell" bundle:nil] forCellReuseIdentifier:@"JCHATSetting_Cell"];
  [self.view addSubview:settingTabl];
  settingTabl.backgroundColor = [UIColor whiteColor];
  self.view.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [titleArr count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  static NSString *cellIdentifier = @"JCHATSetting_Cell";
  JCHATSetting_Cell *cell = (JCHATSetting_Cell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  cell.tittleLabel.text = [titleArr objectAtIndex:indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.selected = NO;
  
  if (indexPath.row==0) {
    JCHATUpdatePasswordCtl *updateWordCtl =[[JCHATUpdatePasswordCtl alloc] init];
    [self.navigationController pushViewController:updateWordCtl animated:YES];
  }
  
  if (indexPath.row == 1) {
    JCHATAboutViewController *about = [[JCHATAboutViewController alloc]initWithNibName:@"JCHATAboutViewController" bundle:nil];
    [self.navigationController pushViewController:about animated:YES];
    
  }
  
  if (indexPath.row == 2) {
    return;
    JCHATDebugViewController *debugVC = [[JCHATDebugViewController alloc] init];
    [self.navigationController pushViewController:debugVC animated:YES];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  //    // 禁用 iOS7 返回手势
  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 57;
}

- (void)backClick
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
