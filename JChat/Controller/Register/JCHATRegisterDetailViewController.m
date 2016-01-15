//
//  JCHATRegisterDetailViewController.m
//  JPush IM
//
//  Created by Apple on 15/2/2.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATRegisterDetailViewController.h"
#import "AppDelegate.h"


@interface JCHATRegisterDetailViewController ()

@end


@implementation JCHATRegisterDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  [self setupNavigationBar];
}

- (void)setupNavigationBar {
  UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:kNavigationLeftButtonRect];
  [leftBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
  [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)laterBtnClick:(id)sender {
  DDLogDebug(@"Action - laterBtnClick");
  AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
  [self.navigationController pushViewController:appDelegate.tabBarCtl animated:YES];
}

- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:NO];
  [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.nickNameField resignFirstResponder];
}

@end
