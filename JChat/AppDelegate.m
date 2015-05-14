#import "AppDelegate.h"
#import "JCHATLoginViewController.h"
#import "JCHATChatViewController.h"
#import "JCHATContactsViewController.h"
#import "JCHATUserInfoViewController.h"
#import "JCHATFileManager.h"
#import "MobClick.h"
#import "JCHATCustomFormatter.h"
#import "JCHATStringUtils.h"

#import <JMessage/JMessage.h>

@implementation AppDelegate


- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self initLogger];

  DDLogInfo(@"Action - didFinishLaunchingWithOptions");

  // init third-party SDK
  [JMessage setupJMessage:launchOptions
                   appKey:JMSSAGE_APPKEY
                  channel:CHANNEL apsForProduction:NO
                 category:nil];
  [self registerJPushStatusNotification];
  [self umengTrack];


  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  [self.window makeKeyAndVisible];

  [self initTheMainGTablebar];

  if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
    self.tabBarCtl.loginIdentify = kHaveLogin;
    self.window.rootViewController = self.tabBarCtl;
  } else {
    JCHATLoginViewController *rootCtl = [[JCHATLoginViewController alloc] initWithNibName:@"JCHATLoginViewController" bundle:nil];
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:rootCtl];
    self.window.rootViewController = navLogin;
  }

  [JCHATFileManager initWithFilePath];//demo 初始化存储路径
  return YES;
}

- (void)registerJPushStatusNotification {
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
}

- (void)initLogger {
  JCHATCustomFormatter *formatter = [[JCHATCustomFormatter alloc] init];

  // XCode console
  [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];

  // Apple System
  [[DDASLLogger sharedInstance] setLogFormatter:formatter];
  [DDLog addLogger:[DDASLLogger sharedInstance]];

  DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
  fileLogger.rollingFrequency = 60 * 60 * 24; // 一个LogFile的有效期长，有效期内Log都会写入该LogFile
  fileLogger.logFileManager.maximumNumberOfLogFiles = 7;//最多LogFile的数量
  [fileLogger setLogFormatter:formatter];
  [DDLog addLogger:fileLogger];

  [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(255, 0, 0)
                                      backgroundColor:nil
                                              forFlag:LOG_FLAG_ERROR];
  [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(255, 215, 0)
                                      backgroundColor:nil
                                              forFlag:LOG_FLAG_WARN];
  [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(0, 255, 0)
                                      backgroundColor:nil
                                              forFlag:LOG_FLAG_DEBUG];
  [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(0, 0, 255)
                                      backgroundColor:nil
                                              forFlag:LOG_FLAG_INFO];
  [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

}

// notification from JPush
- (void)networkDidSetup:(NSNotification *)notification {
  DDLogDebug(@"Action - networkDidSetup");
}

// notification from JPush
- (void)networkDidClose:(NSNotification *)notification {
  DDLogDebug(@"Action - networkDidClose");
}

// notification from JPush
- (void)networkDidRegister:(NSNotification *)notification {
  DDLogDebug(@"Action - networkDidRegister");
}

// notification from JPush
- (void)networkDidLogin:(NSNotification *)notification {
  DDLogDebug(@"Action - networkDidLogin");
}

// notification from JPush
- (void)networkDidReceiveMessage:(NSNotification *)notification {
  DDLogDebug(@"Action - networkDidReceiveMessage");
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
  DDLogDebug(@"Action - applicationDidEnterBackground");
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.

  [self resetApplicationBadge];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  DDLogDebug(@"Action - applicationWillEnterForeground");

  [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  DDLogVerbose(@"Action - applicationWillTerminate");
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}


// ---------------------- JPUSH
// 通常会调用 JPUSHService 方法去完成 Push 相关的功能

- (void)                             application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  DDLogInfo(@"Action - didRegisterForRemoteNotificationsWithDeviceToken");

  [NSString stringWithFormat:@"%@", deviceToken];
  [UIColor colorWithRed:0.0 / 255
                  green:122.0 / 255
                   blue:255.0 / 255
                  alpha:1];
  DDLogVerbose(@"Got Device Token - %@", deviceToken);

  [JPUSHService registerDeviceToken:deviceToken];
}

- (void)                             application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  DDLogVerbose(@"Action - didFailToRegisterForRemoteNotificationsWithError - %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

- (void)                application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  DDLogInfo(@"Action - didRegisterUserNotificationSettings");
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)       application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
      forLocalNotification:(UILocalNotification *)notification
         completionHandler:(void (^)())completionHandler {
  DDLogDebug(@"Action - handleActionWithIdentifier:forLocalNotification");
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)       application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
     forRemoteNotification:(NSDictionary *)userInfo
         completionHandler:(void (^)())completionHandler {
  DDLogDebug(@"Action - handleActionWithIdentifier:forRemoteNotification");
}

#endif // end of - > __IPHONE_7_1

- (void)         application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
  DDLogDebug(@"Action - didReceiveRemoteNotification");

  [JPUSHService handleRemoteNotification:userInfo];

  DDLogVerbose(@"收到通知 - %@", [JCHATStringUtils dictionary2String:userInfo]);
}

- (void)         application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
      fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  DDLogDebug(@"Action - didReceiveRemoteNotification:fetchCompletionHandler");

  [JPUSHService handleRemoteNotification:userInfo];

  DDLogVerbose(@"收到通知 - %@", [JCHATStringUtils dictionary2String:userInfo]);

  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)        application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
  DDLogDebug(@"Action - didReceiveLocalNotification");

  [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


// ---------- end of JPUSH



- (void)sendApnsNotificationSkipPage:(NSDictionary *)notificaton {
  [[NSNotificationCenter defaultCenter] postNotificationName:KApnsNotification object:notificaton];
}

#pragma mark --初始化各个功能模块
-(void)initTheMainGTablebar {
    self.tabBarCtl =[[JCHATTabBarViewController alloc] init];
    self.tabBarCtl.loginIdentify = kFirstLogin;
    NSArray *normalImageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"menu_25.png"],
            [UIImage imageNamed:@"menu_18.png"], [UIImage imageNamed:@"menu_13.png"], nil];

    JCHATChatViewController *chatViewController = [[JCHATChatViewController alloc] initWithNibName:@"JCHATChatViewController"
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
    JCHATContactsViewController *contactsViewController = [[JCHATContactsViewController alloc]
            initWithNibName:@"JCHATContactsViewController" bundle:nil];
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
    JCHATUserInfoViewController *settingViewController = [[JCHATUserInfoViewController alloc]
            initWithNibName:@"JCHATUserInfoViewController" bundle:nil];
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

- (void)umengTrack {
    // [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    // [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy)REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH, SENDDAILY, SENDWIFIONLY 几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
}

- (void)resetApplicationBadge {
  DDLogVerbose(@"Action - resetApplicationBadge");

  NSInteger badge = [[[NSUserDefaults standardUserDefaults] objectForKey:kBADGE] integerValue];
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];

  [JPUSHService setBadge:badge];
}



@end
