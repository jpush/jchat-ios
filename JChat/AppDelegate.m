#import "AppDelegate.h"
#import "JCHATLoginViewController.h"
#import "JCHATConversationListViewController.h"
#import "JCHATContactsViewController.h"
#import "JCHATUserInfoViewController.h"
#import "JCHATFileManager.h"

#import "JCHATCustomFormatter.h"
#import "JCHATStringUtils.h"
#import "JCHATAlreadyLoginViewController.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self initLogger];

  // init third-party SDK
  [JMessage addDelegate:self withConversation:nil];
  
  [JMessage setupJMessage:launchOptions
                   appKey:JMSSAGE_APPKEY
                  channel:CHANNEL apsForProduction:NO
                 category:nil];
  
  [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound |
                                                    UIUserNotificationTypeAlert)
                                        categories:nil];
  
  [self registerJPushStatusNotification];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [UIViewController new];
  [self.window makeKeyAndVisible];
  [self setupMainTabBar];
  [self setupRootView];
  
  [JCHATFileManager initWithFilePath];//demo 初始化存储路径
  
  return YES;
}

- (void)setupRootView {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
    _tabBarCtl.loginIdentify = kHaveLogin;
    self.window.rootViewController = _tabBarCtl;
  } else {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:klastLoginUserName]) {
      JCHATAlreadyLoginViewController *rLoginCtl = [[JCHATAlreadyLoginViewController alloc] init];//TODO:
      UINavigationController *nvrLoginCtl = [[UINavigationController alloc] initWithRootViewController:rLoginCtl];
      nvrLoginCtl.navigationBar.tintColor = kNavigationBarColor;
      self.window.rootViewController = nvrLoginCtl;
    } else {
      JCHATLoginViewController *rootCtl = [[JCHATLoginViewController alloc] initWithNibName:@"JCHATLoginViewController" bundle:nil];
      UINavigationController *navLoginVC = [[UINavigationController alloc] initWithRootViewController:rootCtl];
      navLoginVC.navigationBar.tintColor = kNavigationBarColor;
      self.window.rootViewController = navLoginVC;
    }
  }
      
  [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x3f80de)];
  if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
    [[UINavigationBar appearance] setTranslucent:NO];//!
  }
  
  NSShadow* shadow = [NSShadow new];
  shadow.shadowOffset = CGSizeMake(0.0f, 0.0f);
  [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                          NSForegroundColorAttributeName: [UIColor whiteColor],
                                                          NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                                          NSShadowAttributeName: shadow
                                                          }];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

#pragma - mark JMessageDelegate
- (void)onLoginUserKicked {
  UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"登录状态出错"
                                                     message:@"你已在别的设备上登录!"
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
  alertView.tag = 1200;
  [alertView show];
}

- (void)onDBMigrateStart {
  NSLog(@"onDBmigrateStart in appdelegate");
  _isDBMigrating = YES;
}

- (void)onDBMigrateFinishedWithError:(NSError *)error {
  NSLog(@"onDBmigrateFinish in appdelegate");
  _isDBMigrating = NO;
  [[NSNotificationCenter defaultCenter] postNotificationName:kDBMigrateFinishNotification object:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserName];
  [JMSGUser logout:^(id resultObject, NSError *error) {
    NSLog(@"Logout callback with - %@", error);
  }];
  JCHATAlreadyLoginViewController *loginCtl = [[JCHATAlreadyLoginViewController alloc] init];
  loginCtl.hidesBottomBarWhenPushed = YES;
  UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:loginCtl];
  self.window.rootViewController = navLogin;
  return;
}

- (void)registerJPushStatusNotification {
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self
                    selector:@selector(networkDidSetup:)
                        name:kJPFNetworkDidSetupNotification
                      object:nil];
  [defaultCenter addObserver:self
                    selector:@selector(networkIsConnecting:)
                        name:kJPFNetworkIsConnectingNotification
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

  [defaultCenter addObserver:self
                    selector:@selector(receivePushMessage:)
                        name:kJPFNetworkDidReceiveMessageNotification
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

//  [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(255, 0, 0)
//                                      backgroundColor:nil
//                                              forFlag:LOG_FLAG_ERROR];
//  [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(255, 215, 0)
//                                      backgroundColor:nil
//                                              forFlag:LOG_FLAG_WARN];
//  [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(0, 255, 0)
//                                      backgroundColor:nil
//                                              forFlag:LOG_FLAG_DEBUG];
//  [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(0, 0, 255)
//                                      backgroundColor:nil
//                                              forFlag:LOG_FLAG_INFO];
//  [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

// notification from JPush
- (void)networkDidSetup:(NSNotification *)notification {
  DDLogDebug(@"Event - networkDidSetup");
}

// notification from JPush
- (void)networkIsConnecting:(NSNotification *)notification {
  DDLogDebug(@"Event - networkIsConnecting");
}

// notification from JPush
- (void)networkDidClose:(NSNotification *)notification {
  DDLogDebug(@"Event - networkDidClose");
}

// notification from JPush
- (void)networkDidRegister:(NSNotification *)notification {
  DDLogDebug(@"Event - networkDidRegister");
}

// notification from JPush
- (void)networkDidLogin:(NSNotification *)notification {
  DDLogDebug(@"Event - networkDidLogin");
}

// notification from JPush
- (void)receivePushMessage:(NSNotification *)notification {
  DDLogDebug(@"Event - receivePushMessage");

  NSDictionary *info = notification.userInfo;
  if (info) {
    DDLogDebug(@"The message - %@", info);
  } else {
    DDLogWarn(@"Unexpected - no user info in jpush mesasge");
  }
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

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  DDLogInfo(@"Action - didRegisterForRemoteNotificationsWithDeviceToken");
  DDLogVerbose(@"Got Device Token - %@", deviceToken);

  [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  DDLogVerbose(@"Action - didFailToRegisterForRemoteNotificationsWithError - %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  DDLogInfo(@"Action - didRegisterUserNotificationSettings");
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
  DDLogDebug(@"Action - handleActionWithIdentifier:forLocalNotification");
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
  DDLogDebug(@"Action - handleActionWithIdentifier:forRemoteNotification");
}

#endif // end of - > __IPHONE_7_1

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
  DDLogDebug(@"Action - didReceiveRemoteNotification");

  [JPUSHService handleRemoteNotification:userInfo];

  DDLogVerbose(@"收到通知 - %@", [JCHATStringUtils dictionary2String:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
      fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  DDLogDebug(@"Action - didReceiveRemoteNotification:fetchCompletionHandler");
  [JPUSHService handleRemoteNotification:userInfo];
  NSLog(@"收到通知 - %@", userInfo);
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
  DDLogDebug(@"Action - didReceiveLocalNotification");
  [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


// ---------- end of JPUSH


#pragma mark --初始化各个功能模块
- (void)setupMainTabBar {
  self.tabBarCtl =[[JCHATTabBarViewController alloc] init];
  self.tabBarCtl.loginIdentify = kFirstLogin;
  
  JCHATConversationListViewController *chatViewController = [[JCHATConversationListViewController alloc] initWithNibName:@"JCHATConversationListViewController" bundle:nil];
  UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatViewController];

  
  //聊天
  chatViewController.navigationItem.title = st_chatViewControllerTittle;
  UITabBarItem *chatTab = [[UITabBarItem alloc] initWithTitle:st_chatViewControllerTittle image:[UIImage imageNamed:@"menu_25"] selectedImage:[UIImage imageNamed:@"menu_23"]];
  chatTab.tag = st_chatTabTag;
  chatNav.tabBarItem = chatTab;
  
  //联系人
  JCHATContactsViewController *contactsViewController = [[JCHATContactsViewController alloc]
                                                         initWithNibName:@"JCHATContactsViewController" bundle:nil];
  UINavigationController *contactsNav = [[UINavigationController alloc]
                                         initWithRootViewController:contactsViewController];
  
  contactsViewController.navigationItem.title=st_contactsTabTitle;
  UITabBarItem *contactsTab = [[UITabBarItem alloc] initWithTitle:st_contactsTabTitle image:[UIImage imageNamed:@"menu_16"] selectedImage:[UIImage imageNamed:@"menu_16"]];
  contactsTab.tag = st_contactsTabTag;
  contactsNav.tabBarItem = contactsTab;
  
  //设置
  JCHATUserInfoViewController *settingViewController = [[JCHATUserInfoViewController alloc]
                                                        initWithNibName:@"JCHATUserInfoViewController" bundle:nil];
  UINavigationController *settingNav = [[UINavigationController alloc]
                                        initWithRootViewController:settingViewController];
  
  settingViewController.navigationItem.title = st_settingTabTitle;
  UITabBarItem *settingTab = [[UITabBarItem alloc] initWithTitle:st_settingTabTitle image:[UIImage imageNamed:@"menu_13"] selectedImage:[UIImage imageNamed:@"menu_12"]];
  settingTab.tag = st_contactsTabTag;
  settingNav.tabBarItem = settingTab;
  //TODO:uicolor define
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                     nil] forState:UIControlStateNormal];
  UIColor *titleHighlightedColor = UIColorFromRGB(0x3f80de);
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     titleHighlightedColor, NSForegroundColorAttributeName,
                                                     nil] forState:UIControlStateSelected];
  UIImage *tabBarBackground = [UIImage imageNamed:@"bar"];
  
  [[UITabBar appearance] setBackgroundImage:[tabBarBackground resizableImageWithCapInsets:UIEdgeInsetsZero]];
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     [UIColor grayColor], NSForegroundColorAttributeName,
                                                     nil] forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     titleHighlightedColor, NSForegroundColorAttributeName,
                                                     nil] forState:UIControlStateHighlighted];
  self.tabBarCtl.viewControllers = [NSArray arrayWithObjects:chatNav,contactsNav,settingNav,nil];
  self.tabBarCtl.navigationController.navigationItem.hidesBackButton = YES;

}

- (void)resetApplicationBadge {
  DDLogVerbose(@"Action - resetApplicationBadge");

  NSInteger badge = [[[NSUserDefaults standardUserDefaults] objectForKey:kBADGE] integerValue];
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];

  [JPUSHService setBadge:badge];
}

@end
