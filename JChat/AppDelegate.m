#import "AppDelegate.h"
#import "JCHATLoginViewController.h"
#import "JCHATConversationListViewController.h"
#import "JCHATContactsViewController.h"
#import "JCHATUserInfoViewController.h"
#import "JCHATFileManager.h"

#import "JCHATCustomFormatter.h"
#import "JCHATStringUtils.h"
#import "JCHATAlreadyLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initLogger];
//    NSLog(@"%@",@(INTERNAL_VERSION));
    // init third-party SDK
    [JMessage addDelegate:self withConversation:nil];
    
//    [JMessage setLogOFF];
    [JMessage setDebugMode];
    [JMessage setupJMessage:launchOptions
                     appKey:JMESSAGE_APPKEY
                    channel:CHANNEL
           apsForProduction:NO
                   category:nil
             messageRoaming:YES];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JMessage registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [self registerJPushStatusNotification];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    [self setupMainTabBar];
    [self setupRootView];
    
    [JCHATFileManager initWithFilePath];//demo 初始化存储路径
    
    [JMessage resetBadge];
    
    return YES;
}

- (void)setupRootView {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kuserName]) {
        _tabBarCtl.loginIdentify = kHaveLogin;
        self.window.rootViewController = _tabBarCtl;
    } else {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:klastLoginUserName]) {
            JCHATAlreadyLoginViewController *rLoginCtl = [[JCHATAlreadyLoginViewController alloc] init];
            UINavigationController *nvrLoginCtl = [[UINavigationController alloc] initWithRootViewController:rLoginCtl];
            nvrLoginCtl.navigationBar.tintColor = kNavigationBarColor;
            self.window.rootViewController = nvrLoginCtl;
        } else {
            JCHATLoginViewController *rootCtl = [[JCHATLoginViewController alloc] init];
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
- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    SInt32 eventType = (JMSGEventNotificationType)event.eventType;
    switch (eventType) {
        case kJMSGEventNotificationCurrentUserInfoChange:{
            NSLog(@"Current user info change Notification Event ");
        }
            break;
        case kJMSGEventNotificationReceiveFriendInvitation:
        case kJMSGEventNotificationAcceptedFriendInvitation:
        case kJMSGEventNotificationDeclinedFriendInvitation:
        case kJMSGEventNotificationDeletedFriend:
        {
            //JMSGFriendNotificationEvent *friendEvent = (JMSGFriendNotificationEvent *)event;
            NSLog(@"Friend Notification Event");
        }
            break;
        case kJMSGEventNotificationReceiveServerFriendUpdate:
            NSLog(@"Receive Server Friend update Notification Event");
            break;
            
            
        case kJMSGEventNotificationLoginKicked:
            NSLog(@"LoginKicked Notification Event ");
        case kJMSGEventNotificationServerAlterPassword:{
            if (event.eventType == kJMSGEventNotificationServerAlterPassword) {
                NSLog(@"AlterPassword Notification Event ");
            }
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            if (event.eventType == kJMSGEventNotificationServerAlterPassword) {
                NSLog(@"User login status unexpected Notification Event ");
            }
            if (!myAlertView) {
                myAlertView =[[UIAlertView alloc] initWithTitle:@"登录状态出错"
                                                      message:event.eventDescription
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"确定", nil];
                [myAlertView show];
            }
        }
            break;
            
        default:
            break;
    }
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
    
    myAlertView = nil;
    return;
}

- (void)registerJPushStatusNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJMSGNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkIsConnecting:)
                          name:kJMSGNetworkIsConnectingNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJMSGNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJMSGNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJMSGNetworkDidLoginNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(receivePushMessage:)
                          name:kJMSGNetworkDidReceiveMessageNotification
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
}

- (void)networkDidSetup:(NSNotification *)notification {
    DDLogDebug(@"Event - networkDidSetup");
}

- (void)networkIsConnecting:(NSNotification *)notification {
    DDLogDebug(@"Event - networkIsConnecting");
}

- (void)networkDidClose:(NSNotification *)notification {
    DDLogDebug(@"Event - networkDidClose");
}

- (void)networkDidRegister:(NSNotification *)notification {
    DDLogDebug(@"Event - networkDidRegister");
}

- (void)networkDidLogin:(NSNotification *)notification {
    DDLogDebug(@"Event - networkDidLogin");
}

- (void)receivePushMessage:(NSNotification *)notification {
    DDLogDebug(@"Event - receivePushMessage");
    
    NSDictionary *info = notification.userInfo;
    if (info) {
        DDLogDebug(@"The message - %@", info);
    } else {
        DDLogWarn(@"Unexpected - no user info in jpush mesasge");
    }
}



- (void)applicationDidBecomeActive:(UIApplication *)application{
    [JMessage resetBadge];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    DDLogDebug(@"Action - applicationDidEnterBackground");
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DDLogDebug(@"Action - applicationWillEnterForeground");
    
    [application cancelAllLocalNotifications];
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    DDLogInfo(@"Action - didReceiveRemoteNotification:fetchCompletionHandler:");
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DDLogInfo(@"Action - didRegisterForRemoteNotificationsWithDeviceToken");
    DDLogVerbose(@"Got Device Token - %@", deviceToken);
    
    [JMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DDLogVerbose(@"Action - didFailToRegisterForRemoteNotificationsWithError - %@", error);
}

#pragma mark --初始化各个功能模块
- (void)setupMainTabBar {
    self.tabBarCtl =[[JCHATTabBarViewController alloc] init];
    self.tabBarCtl.loginIdentify = kFirstLogin;
    
    JCHATConversationListViewController *chatViewController = [[JCHATConversationListViewController alloc] init];
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    
    
    //聊天
    chatViewController.navigationItem.title = st_chatViewControllerTittle;
    UITabBarItem *chatTab = [[UITabBarItem alloc] initWithTitle:st_chatViewControllerTittle image:[UIImage imageNamed:@"menu_25"] selectedImage:[UIImage imageNamed:@"menu_23"]];
    chatTab.tag = st_chatTabTag;
    chatNav.tabBarItem = chatTab;
    
    //联系人
    JCHATContactsViewController *contactsViewController = [[JCHATContactsViewController alloc] init];
    UINavigationController *contactsNav = [[UINavigationController alloc]
                                           initWithRootViewController:contactsViewController];
    
    contactsViewController.navigationItem.title=st_contactsTabTitle;
    UITabBarItem *contactsTab = [[UITabBarItem alloc] initWithTitle:st_contactsTabTitle image:[UIImage imageNamed:@"menu_16"] selectedImage:[UIImage imageNamed:@"menu_16"]];
    contactsTab.tag = st_contactsTabTag;
    contactsNav.tabBarItem = contactsTab;
    
    //设置
    JCHATUserInfoViewController *settingViewController = [[JCHATUserInfoViewController alloc] init];
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

@end
