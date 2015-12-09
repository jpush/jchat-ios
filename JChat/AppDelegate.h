
#import <UIKit/UIKit.h>
#import <CocoaLumberjack/DDLegacyMacros.h>
#import "JCHATTabBarViewController.h"
#import "JChatConstants.h"


#define UMENG_APPKEY @"55487cee67e58e5431003b06"

// 需要填写为您自己的 JPush Appkey
#define JMSSAGE_APPKEY @""

#define CHANNEL @""



@interface AppDelegate : UIResponder <UIApplicationDelegate,JMessageDelegate>

@property (nonatomic,strong) JCHATTabBarViewController *tabBarCtl;

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic)BOOL isDBMigrating;

- (void)setupMainTabBar;
@end
