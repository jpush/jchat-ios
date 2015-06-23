//
//  JCHATTabBarViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATTabBarViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "JChatConstants.h"
#import <JMessage/JMessage.h>

@interface JCHATTabBarViewController ()

@end

@implementation JCHATTabBarViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  if ([self getLoginInfoValue:kuserName]) {
  }
}

- (NSString *)getLoginInfoValue:(NSString *)identify {
    return[[NSUserDefaults standardUserDefaults] objectForKey:identify];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
//     禁用 iOS7 返回手势
  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
      self.navigationController.interactivePopGestureRecognizer.enabled = NO;
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
