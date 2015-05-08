
#import <UIKit/UIKit.h>
#import "JPIMTabBarViewController.h"

#define UMENG_APPKEY @"55487cee67e58e5431003b06"

// 需要填写为您自己的 JPush Appkey
#define JMSSAGE_APPKEY @""

#define CHANNEL @"test"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,strong) JPIMTabBarViewController *tabBarCtl;

@property (strong, nonatomic) UIWindow *window;



@end

