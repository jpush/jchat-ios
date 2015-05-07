//
//  JPIMTabBarViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JPIMTabBarViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "JPIMCommon.h"
#import <JMessage/JMessage.h>

@interface JPIMTabBarViewController ()

@end

@implementation JPIMTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JPIMLog(@"Action");
    if ([self getLoginInfoValue:kuserName]) {
    }
}

- (void)getUserInfo {
//    [JMSGUserManager getUserInfo:[self getLoginInfoValue:kUSERNAME] completionHandler:^(id resultObject, NSError *error) {
//        if (error ==nil) {
//            NSLog(@"重登获取用户信息 success");
//            [[NSNotificationCenter defaultCenter] postNotificationName:kLogin_NotifiCation object:nil];
//        }else {
//            NSLog(@"重登获取用户信息 fail");
//        }
//    }];
}

- (NSString *)getLoginInfoValue:(NSString *)identify {
    return[[NSUserDefaults standardUserDefaults] objectForKey:identify];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//     禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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
