
#import <UIKit/UIKit.h>
#import <CocoaLumberjack/DDLegacyMacros.h>
#import "JCHATTabBarViewController.h"
#import "JChatConstants.h"


#define UMENG_APPKEY @"55487cee67e58e5431003b06"

// 需要填写为您自己的 JPush Appkey
#define JMSSAGE_APPKEY @"4f7aef34fb361292c566a1cd"

#define CHANNEL @""



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,strong) JCHATTabBarViewController *tabBarCtl;

@property (strong, nonatomic) UIWindow *window;



@end

