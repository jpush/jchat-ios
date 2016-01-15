//
//  JCHATTabBarViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATTabBarViewController.h"
#import "JChatConstants.h"

@interface JCHATTabBarViewController ()

@end

@implementation JCHATTabBarViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  self.navigationController.navigationBar.translucent = NO;
  
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
