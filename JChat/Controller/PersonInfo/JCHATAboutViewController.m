//
//  JCHATAboutViewController.m
//  JChat
//
//  Created by zhang on 15/7/1.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATAboutViewController.h"
#import <JMessage/JMessage.h>

@interface JCHATAboutViewController ()

@end

@implementation JCHATAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  _JChatVersion.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  _JMessageVersion.text = JMESSAGE_VERSION;
  _JMessageBuild.text   = JMESSAGE_BUILD;
    // Do any additional setup after loading the view from its nib.
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
