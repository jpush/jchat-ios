#import "AppDelegate.h"
#import "Common.h"
#import "JPIMLoginViewController.h"
#import "JPIMChatViewController.h"
#import "JPIMContactsViewController.h"
#import "JPIMUserInfoViewController.h"
#import "JPIMFileManager.h"
#import "MobClick.h"
#import <JMessage/JMessage.h>

@implementation AppDelegate


- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self umengTrack];
    [JMessage setupJMessage:launchOptions
                     appKey:@"4f7aef34fb361292c566a1cd"
                    channel:@"test" apsForProduction:NO
                   category:nil];
    [self initTheMainGTablebar];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
        self.tabBarCtl.loginIdentify = kHaveLogin;
        self.window.rootViewController=self.tabBarCtl;
    } else {
        JPIMLoginViewController *rootCtl = [[JPIMLoginViewController alloc] initWithNibName:@"JPIMLoginViewController" bundle:nil];
        UINavigationController *navLogin =[[UINavigationController alloc] initWithRootViewController:rootCtl];
        self.window.rootViewController=navLogin;
    }

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    
    [JPIMFileManager initWithFilePath];//demo 初始化存储路径
    return YES;
}

- (void)networkDidSetup:(NSNotification *)notification {
    JPIMLog(@"networkDidSetup");
}

- (void)networkDidClose:(NSNotification *)notification {
    JPIMLog(@"networkDidClose");

}

- (void)networkDidRegister:(NSNotification *)notification {
  JPIMLog(@"networkDidRegister");
}

- (void)networkDidLogin:(NSNotification *)notification {
    JPIMLog(@"networkDidLogin");
 
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    JPIMLog(@"networkDidReceiveMessage");
}

- (void)serviceError:(NSNotification *)notification {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //    [JPUSHService stopLogPageView:@"aa"];
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    NSInteger badge = [[[NSUserDefaults standardUserDefaults] objectForKey:kBADGE] integerValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSInteger badge = [[[NSUserDefaults standardUserDefaults] objectForKey:kBADGE] integerValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
        didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [NSString stringWithFormat:@"%@", deviceToken];
    [UIColor colorWithRed:0.0 / 255
                    green:122.0 / 255
                     blue:255.0 / 255
                    alpha:1];
    JPIMLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
        didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    JPIMLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
        didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
        handleActionWithIdentifier:(NSString *)identifier
        forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
        didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    NSInteger badge = [[[NSUserDefaults standardUserDefaults] objectForKey:kBADGE] integerValue];
//    badge++;
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",badge] forKey:kBADGE];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application
        didReceiveRemoteNotification:(NSDictionary *)userInfo
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    [self sendApnsNotificationSkipPage:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
        didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData
                                                     mutabilityOption:NSPropertyListImmutable
                                                               format:NULL
                                                     errorDescription:NULL];
    return str;
}

- (void)sendApnsNotificationSkipPage:(NSDictionary *)notificaton {
    [[NSNotificationCenter defaultCenter] postNotificationName:KApnsNotification object:notificaton];
}

#pragma mark --初始化各个功能模块
-(void)initTheMainGTablebar {
    self.tabBarCtl =[[JPIMTabBarViewController alloc] init];
    self.tabBarCtl.loginIdentify = kFirstLogin;
    NSArray *normalImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"menu_25.png"], [UIImage imageNamed:@"menu_18.png"], [UIImage imageNamed:@"menu_13.png"], nil];

    JPIMChatViewController *chatViewController = [[JPIMChatViewController alloc] initWithNibName:@"JPIMChatViewController"
                                                                                          bundle:nil];
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatViewController];

    /**
     *  聊天
     */
    chatViewController.navigationItem.title = @"会话";
    UITabBarItem *chatTab = [[UITabBarItem alloc] initWithTitle:@"会话"
                                                          image:[normalImageArray objectAtIndex:0]
                                                            tag:10];
    [chatTab setFinishedSelectedImage:[UIImage imageNamed:@"menu_25.png"]
          withFinishedUnselectedImage:[UIImage imageNamed:@"menu_23.jpg"]];
    chatNav.tabBarItem = chatTab;

    /**
     * 联系人
     */
    JPIMContactsViewController *contactsViewController = [[JPIMContactsViewController alloc]
            initWithNibName:@"JPIMContactsViewController" bundle:nil];
    UINavigationController *contactsNav = [[UINavigationController alloc]
            initWithRootViewController:contactsViewController];

    contactsViewController.navigationItem.title=@"通信录";
    UITabBarItem *contractsTab = [[UITabBarItem alloc] initWithTitle:@"通信录"
                                                               image:[normalImageArray objectAtIndex:1]
                                                                 tag:11];
    [contractsTab setFinishedSelectedImage:[UIImage imageNamed:@"menu_18.png"]
               withFinishedUnselectedImage:[UIImage imageNamed:@"menu_16.jpg"]];
    contactsNav.tabBarItem = contractsTab;

    /**
     * 设置
     */
    JPIMUserInfoViewController *settingViewController = [[JPIMUserInfoViewController alloc]
            initWithNibName:@"JPIMUserInfoViewController" bundle:nil];
    UINavigationController *settingNav = [[UINavigationController alloc]
            initWithRootViewController:settingViewController];

    settingViewController.navigationItem.title=@"我";
    UITabBarItem *settingTab = [[UITabBarItem alloc] initWithTitle:@"我"
                                                             image:[normalImageArray objectAtIndex:2]
                                                               tag:12];
    [settingTab setFinishedSelectedImage:[UIImage imageNamed:@"menu_13.png"]
             withFinishedUnselectedImage:[UIImage imageNamed:@"menu_12.jpg"]];
    settingNav.tabBarItem = settingTab;

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1.0], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor whiteColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
    UIImage* tabBarBackground = [UIImage imageNamed:@"bar"];
    [[UITabBar appearance] setBackgroundImage:[tabBarBackground resizableImageWithCapInsets:UIEdgeInsetsZero]];
    //    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selectItem"]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor grayColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateHighlighted];
    self.tabBarCtl.viewControllers = [NSArray arrayWithObjects:chatNav,contactsNav,settingNav,nil];
}

@end
