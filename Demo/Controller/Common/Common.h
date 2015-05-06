//
//  Common.h
//  JPush IM
//
//  Created by Apple on 14/12/29.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#ifndef JPush_IM_Common_h
#define JPush_IM_Common_h

/*========================================屏幕适配============================================*/
#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue] //获得iOS版本
#define kUIWindow    [[[UIApplication sharedApplication] delegate] window] //获得window
#define kUnderStatusBarStartY (kIOSVersions>=7.0 ? 20 : 0)                 //7.0以上stautsbar不占位置，内容视图的起始位置要往下20

#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight  (kIOSVersions>=7.0 ? [[UIScreen mainScreen] bounds].size.height + 64 : [[UIScreen mainScreen] bounds].size.height)
#define kIOS7OffHeight (kIOSVersions>=7.0 ? 64 : 0)

#define kApplicationSize      [[UIScreen mainScreen] applicationFrame].size       //(e.g. 320,460)
#define kApplicationWidth     [[UIScreen mainScreen] applicationFrame].size.width //(e.g. 320)
#define kApplicationHeight    [[UIScreen mainScreen] applicationFrame].size.height//不包含状态bar的高度(e.g. 460)

#define kStatusBarHeight         20
#define kNavigationBarHeight     44
#define kNavigationheightForIOS7 64
#define kContentHeight           (kApplicationHeight - kNavigationBarHeight)
#define kTabBarHeight            49
#define kTableRowTitleSize       14
#define maxPopLength             170

#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define headDefaltWidth             46
#define headDefaltHeight            46
#define upLoadImgWidth            720

#define kMessageChangeState  @"messageChangeState"


/**自定义Log调试***/

#ifdef DEBUG
#define JPIMLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:__VA_ARGS__])
#define DEBUGSTATE YES
#else
#define JMSGLog(...) do { } while (0)
#define DEBUGSTATE NO
#endif

#define kuserName @"userName"
#define kBADGE @"badge"

#define kPassword @"password"
#define kLogin_NotifiCation @"loginNotification"
#define kFirstLogin @"firstLogin"
#define kHaveLogin @"haveLogin"

#define kimgKey @"imgKey"
#define kmessageKey @"messageKey"
#define kupdateUserInfo @"updateUserInfo"
#define KNull @"(null)"
#define KApnsNotification @"apnsNotification"

#define JPIMMAINTHEAD(block) dispatch_async(dispatch_get_main_queue(), block)
#endif
