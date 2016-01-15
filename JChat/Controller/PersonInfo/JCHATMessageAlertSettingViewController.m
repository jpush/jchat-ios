//
//  JCHATMessageAlertSettingViewController.m
//  JChat
//
//  Created by HuminiOS on 15/8/3.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATMessageAlertSettingViewController.h"
#import "Masonry.h"
@interface JCHATMessageAlertSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
  UITableView *settingTableView;
}
@end

@implementation JCHATMessageAlertSettingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationController.navigationBar.translucent = NO;
  settingTableView = [UITableView new];
  [self.view addSubview:settingTableView];
  [settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.view);
    make.left.mas_equalTo(self.view);
    make.right.mas_equalTo(self.view);
    make.bottom.mas_equalTo(self.view);
  }];
  settingTableView.dataSource = self;
  settingTableView.delegate = self;
  
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
