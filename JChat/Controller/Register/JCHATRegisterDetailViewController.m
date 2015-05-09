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
    JPIMLog(@"Action");
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
}

- (IBAction)laterBtnClick:(id)sender {
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.navigationController pushViewController:appdelegate.tabBarCtl animated:YES];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nickNameField resignFirstResponder];
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
