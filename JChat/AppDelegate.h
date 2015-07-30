
#import <UIKit/UIKit.h>
#import <CocoaLumberjack/DDLegacyMacros.h>
#import "JCHATTabBarViewController.h"
#import "JChatConstants.h"


#define UMENG_APPKEY @"55487cee67e58e5431003b06"

// 需要填写为您自己的 JPush Appkey
#define JMSSAGE_APPKEY @"d237f366f6b75c1738cd8fa1"

#define CHANNEL @""



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,strong) JCHATTabBarViewController *tabBarCtl;

@property (strong, nonatomic) UIWindow *window;



@end

