//
//  JCHATAboutViewController.m
//  JChat
//
//  Created by zhang on 15/7/1.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATAboutViewController.h"

@interface JCHATAboutViewController ()

@end

@implementation JCHATAboutViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBar.translucent = NO;
  _JChatVersion.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  _JMessageVersion.text = JMESSAGE_VERSION;
  _JMessageBuild.text   = [NSString stringWithFormat:@"%d", JMESSAGE_BUILD];
  
  _JChatBuild.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
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
