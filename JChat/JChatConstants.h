//
//  Common.h
//  JPush IM
//
//  Created by Apple on 14/12/29.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#ifndef JPush_IM_Common_h
#define JPush_IM_Common_h

#import <CocoaLumberjack/CocoaLumberjack.h>


#define TICK      NSDate *startTime = [NSDate date]
#define TOCK(action) DDLogDebug(@"%@ - TimeInSeconds - %f", action, -[startTime timeIntervalSinceNow])



/*========================================屏幕适配============================================*/

#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue] //获得iOS版本
#define kUIWindow    [[[UIApplication sharedApplication] delegate] window] //获得window
#define kUnderStatusBarStartY (kIOSVersions>=7.0 ? 20 : 0)                 //7.0以上stautsbar不占位置，内容视图的起始位置要往下20

#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight  (kIOSVersions>=7.0 ? [[UIScreen mainScreen] bounds].size.height + 64 : [[UIScreen mainScreen] bounds].size.height)
#define kIOS7OffHeight (kIOSVersions>=7.0 ? 64 : 0)

#define kApplicationSize      [UIScreen mainScreen].bounds.size       //(e.g. 320,460)
#define kApplicationWidth     [UIScreen mainScreen].bounds.size.width //(e.g. 320)
#define kApplicationHeight    [UIScreen mainScreen].bounds.size.height//不包含状态bar的高度(e.g. 460)

#define kStatusBarHeight         20
#define kNavigationBarHeight     44
#define kNavigationheightForIOS7 64
#define kContentHeight           (kApplicationHeight - kNavigationBarHeight)
#define kTabBarHeight            49
#define kTableRowTitleSize       14
#define maxPopLength             170

#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.7]

#define kNavigationBarColor    UIColorFromRGB(0x3f80de)
#define headDefaltWidth             46
#define headDefaltHeight            46
#define upLoadImgWidth            720

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define kMessageChangeState  @"messageChangeState"

#define kCreatGroupState  @"creatGroupState"

#define kSkipToSingleChatViewState  @"SkipToSingleChatViewState"


#define kDeleteAllMessage  @"deleteAllMessage"

#define kConversationChange @"ConversationChange"

#define JPIMLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:__VA_ARGS__])

#define LOG_PREFIX @"JChat"

#define kWEAKSELF __weak __typeof(self)weakSelf = self;
/**
  DDLogError 错误：真的出错了，逻辑不正常
  DDLogWarn  警告：不是预期的情况，但也基本正常，不会导致逻辑问题
  DDLogInfo  信息：比较重要的信息，重要的方法入口
  DDLogDebug 调试：一般调试日志输出
  DDLogVerbose 过度：也用于调试，但输出时会过度，比如循环展示列表时输出其部分信息。
               默认 DEBUG 模式时也不输出 Verbose 日志，有需要临时修改下面的定义打开这个日志信息。
*/
#ifdef DEBUG
  static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
  static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif



#define kuserName @"userName"
#define klastLoginUserName @"lastUserName"
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

#define kDBMigrateStartNotification @"DBMigrateStartNotification"
#define kDBMigrateFinishNotification @"DBMigrateFinishNotification"
#define JCHATMAINTHREAD(block) dispatch_async(dispatch_get_main_queue(), block)
#endif


typedef NS_ENUM(NSInteger, JCHATErrorCode) {
  JCHAT_ERROR_SERVER_ERROR = 898000,
  JCHAT_ERROR_REGISTER_EXIST = 898001,
  JCHAT_ERROR_USER_NOT_EXIST = 898002,
  JCHAT_ERROR_USER_PARAS_INVALID = 898003,
  JCHAT_ERROR_USER_WRONG_PASSWORD = 898004,
  JCHAT_ERROR_APPKEY_NOT_EXIST = 898009,

  JCHAT_ERROR_STATE_USER_NEVER_LOGIN = 800012,
  JCHAT_ERROR_STATE_USER_LOGOUT = 800013,

  JCHAT_ERROR_LOGIN_USERNAME_EMPTY = 801001,
  JCHAT_ERROR_LOGIN_PASSWORD_EMPTY = 801002,
  JCHAT_ERROR_LOGIN_NOT_REGISTERED = 801003,
  JCHAT_ERROR_LOGIN_PASSWORD_WRONG = 801004,

  JCHAT_ERROR_MSG_SERVER_ERROR = 803001,
  JCHAT_ERROR_MSG_TARGET_NOT_EXIST = 803003,
  JCHAT_ERROR_MSG_GROUP_NOT_EXIST = 803004,
  JCHAT_ERROR_MSG_USER_NOT_IN_GROUP = 803005,

  JCHAT_ERROR_GROUP_ADD_MEMBER_NOT_IN = 810003,
  JCHAT_ERROR_GROUP_ADD_MEMBER_NOT_REGISTERED = 810005,
  JCHAT_ERROR_GROUP_ADD_MEMBER_DUPLICATED = 810007,

  JCHAT_ERROR_GROUP_DEL_MEMBER_NOT_IN = 811003,


};

//ToolBar
static NSInteger const st_toolBarTextSize = 17.0f;

//Notification
#define kAlertToSendImage @"AlertToSendImage"
#define kDeleteMessage @"DeleteMessage"

//Color
#define kNavigationBarColor UIColorFromRGB(0x3f80de)
#define kTabbarColor UIColorFromRGB(0x3e3e3e)
#define kTextfieldPlaceholderColor UIColorFromRGB(0x555555)
#define kTableviewCellClickColor UIColorFromRGB(0xdddddd)
#define kTableviewSeperateLineColor UIColorFromRGB(0xcfcfcf)
#define kSeparationLineColor UIColorFromRGB(0xd0d0d0)
//NavigationBar
#define kGoBackBtnImageOffset UIEdgeInsetsMake(0, 0, 0, 15)
#define kNavigationLeftButtonRect CGRectMake(0, 0, 30, 30)
//static const
static NSString * const st_chatViewController = @"JCHATChatViewController";
static NSString * const st_contactsViewController = @"JCHATContactsViewController";
static NSString * const st_userInfoViewController = @"JCHATUserInfoViewController";

static NSString * const st_chatViewControllerTittle = @"会话";
static const NSInteger st_chatTabTag = 10;

static NSString * const st_contactsTabTitle = @"通讯录";
static NSInteger const st_contactsTabTag = 11;

static NSString * const st_settingTabTitle = @"我";
static NSInteger const st_settingTag = 12;

static NSString * const st_receiveUnknowMessageDes = @"收到新消息类型无法解析的数据，请升级查看";
static NSString * const st_receiveErrorMessageDes = @"接收消息错误";
