//
// Created by Javen on 15/5/11.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import "JCHATStringUtils.h"
#import "NSDate+Utilities.h"
#import <JMessage/JMessage.h>

@implementation JCHATStringUtils {

}

static NSString * const FORMAT_PAST_SHORT = @"yyyy/MM/dd";
static NSString * const FORMAT_PAST_TIME = @"ahh:mm";
static NSString * const FORMAT_THIS_WEEK = @"eee ahh:mm";
static NSString * const FORMAT_THIS_WEEK_SHORT = @"eee";
static NSString * const FORMAT_YESTERDAY = @"ahh:mm";
static NSString * const FORMAT_TODAY = @"ahh:mm";

+ (NSString *)errorAlert:(NSError *)error {
  NSString *errorAlert = nil;
  
  switch (error.code) {
    case JMSG_ERROR_NETWORK_REQUEST_TIMEOUT:
      errorAlert = @"服务器返回超时";
      break;
    case JMSG_ERROR_NETWORK_REQUEST_FAIL:
      errorAlert = @"服务器请求失败";
      break;
    case JMSG_ERROR_NETWORK_SERVER_FAIL:
      errorAlert = @"服务端错误";
      break;
    case JMSG_ERROR_NETWORK_HOST_UNKNOWN:
      errorAlert = @"地址错误";
      break;
    case kJMSGErrorSDKNetworkDownloadFailed:
      errorAlert = @"下载失败";
      break;
    case kJMSGErrorSDKNetworkUploadFailed:
      errorAlert = @"上传资源文件失败";
      break;
    case kJMSGErrorSDKNetworkUploadTokenVerifyFailed:
      errorAlert = @"上传资源文件Token验证失败";
      break;
    case kJMSGErrorSDKNetworkUploadTokenGetFailed:
      errorAlert = @"获取服务器Token失败";
      break;
    case kJMSGErrorNetworkDataFormatInvalid:
      errorAlert = @"数据格式错误";
      break;
    case kJMSGErrorSDKDBDeleteFailed:
      errorAlert = @"数据库删除失败";
      break;
    case kJMSGErrorSDKDBUpdateFailed:
      errorAlert = @"数据库更新失败";
      break;
    case kJMSGErrorSDKDBSelectFailed:
      errorAlert = @"数据库查询失败";
      break;
    case kJMSGErrorSDKDBInsertFailed:
      errorAlert = @"数据库插入失败";
      break;
    case kJMSGErrorSDKParamAppkeyInvalid:
      errorAlert = @"appkey不合法";
      break;
    case kJMSGErrorPartyQiniuUnknown:
      errorAlert = @"七牛出错";
      break;
    case kJMSGErrorSDKParamUsernameInvalid:
      errorAlert = @"用户名不合法";
      break;
    case kJMSGErrorSDKParamPasswordInvalid:
      errorAlert = @"用户密码不合法";
      break;
    case kJMSGErrorSDKParamAvatarNil:
      errorAlert = @"用户头像属性为空";
      break;
    case kJMSGErrorSDKUserNotLogin:
      errorAlert = @"用户没有登录";
      break;
    case kJMSGErrorSDKNotMediaMessage:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKMediaResourceMissing:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKMediaCrcCodeIllegal:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKMediaCrcVerifyFailed:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKMediaUploadEmptyFile:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKParamContentInvalid:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKParamMessageNil:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKMessageNotPrepared:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKParamConversationTypeUnknown:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKParamConversationUsernameInvalid:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKParamConversationGroupIdInvalid:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKParamGroupGroupIdInvalid:
      errorAlert = @"";
      break;
    case kJMSGErrorSDKParamGroupGroupInfoInvalid:
      errorAlert = @"";
      break;
    case kJMSGErrorMediaCrcInvalid:
      errorAlert = @"CRC32 错误";
      break;

    default:
      errorAlert = @"未知错误";
      break;
  }
  return errorAlert;
}

//{
//  
//  // network - 80
//  JMSG_ERROR_NETWORK_USER_NOT_REGISTER = 801003,
//  
//  /// Network - 860
//  
//  JMSG_ERROR_NETWORK_REQUEST_INVALIDATE = 860010,
//  JMSG_ERROR_NETWORK_REQUEST_TIMEOUT = 860011,   // 服务器返回超时
//  JMSG_ERROR_NETWORK_REQUEST_FAIL = 860012,   // 服务器请求失败
//  JMSG_ERROR_NETWORK_SERVER_FAIL = 860013,   // 服务端错误
//  JMSG_ERROR_NETWORK_HOST_UNKNOWN = 860014,   // 地址错误
//  kJMSGErrorSDKNetworkDownloadFailed = 860015,   // 下载失败
//  JMSG_ERROR_NETWORK_OTHER = 860016,   // 网络原因
//  JMSG_ERROR_NETWORK_TOKEN_FAILED = 860017,   // 服务器获取用户Token失败
//  kJMSGErrorSDKNetworkUploadFailed = 860018,   // 上传资源文件失败
//  kJMSGErrorSDKNetworkUploadTokenVerifyFailed = 860019,   // 上传资源文件Token验证失败
//  kJMSGErrorSDKNetworkUploadTokenGetFailed = 860020,   // 获取服务器Token失败
//  
//  KJMSG_ERROR_NETWORK_RESULT_ERROR = 860021,    // 服务器返回数据错误（没有按约定返回）
//  kJMSGErrorNetworkDataFormatInvalid = 860030,   // 数据格式错误
//  
//  JMSG_ERROR_LACK_PARAMETER = 860041,   // 缺少本地参数
//  
//  
//  /// DB & Global params - 861
//  
//  kJMSGErrorSDKDBDeleteFailed = 861000,
//  kJMSGErrorSDKDBUpdateFailed = 861001,
//  kJMSGErrorSDKDBSelectFailed = 861002,
//  kJMSGErrorSDKDBInsertFailed = 861003,
//  
//  kJMSGErrorSDKParamAppkeyInvalid = 861100, // AppKey invalid
//  JMSG_ERROR_LOCAL_PARAMETER = 860040,   // 本地参数错误
//  
//  /// Third party - 862
//  
//  kJMSGErrorPartyQiniuUnknown = 862010,
//  
//  
//  // User - 863
//  
//  kJMSGErrorSDKParamUsernameInvalid = 863001, // 用户名不合法
//  kJMSGErrorSDKParamPasswordInvalid = 863002, // 用户密码不合法
//  kJMSGErrorSDKParamAvatarNil = 86303,        // 用户头像属性为空
//  kJMSGErrorSDKUserNotLogin = 86304,          // 用户没登录
//  
//  /// Media Resource - 864
//  
//  kJMSGErrorSDKNotMediaMessage = 864001,
//  kJMSGErrorSDKMediaResourceMissing = 864002,
//  kJMSGErrorSDKMediaCrcCodeIllegal = 864003,
//  kJMSGErrorSDKMediaCrcVerifyFailed = 864004,
//  kJMSGErrorSDKMediaUploadEmptyFile = 864005,
//  
//  
//  /// Message - 865
//  
//  kJMSGErrorSDKParamContentInvalid = 865001,  // 消息内容无效
//  kJMSGErrorSDKParamMessageNil = 865002, // 空消息
//  kJMSGErrorSDKMessageNotPrepared = 865003, // 消息不符合发送的基本条件检查
//  
//  /// Conversation - 866
//  
//  kJMSGErrorSDKParamConversationTypeUnknown = 866001, // 会话类型错误
//  kJMSGErrorSDKParamConversationUsernameInvalid = 866002, // 会话 username 无效
//  kJMSGErrorSDKParamConversationGroupIdInvalid = 866003, // 会话 groupId 无效
//  kJMSGErrorSDKParamConversationLackAvatarPath = 866004, // 会话没有 avatarPath
//  
//  /// Group - 867
//  
//  kJMSGErrorSDKParamGroupGroupIdInvalid = 867001, // GroupId 错误
//  kJMSGErrorSDKParamGroupGroupInfoInvalid = 867002, // Group 其他信息不对
//  
//  // Media - 868
//  kJMSGErrorMediaCrcInvalid = 868001,   // crc32 错误
//}

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval {
  return [JCHATStringUtils getFriendlyDateString:timeInterval forConversation:NO];
}

/**
下午11:56 （是今天的）
会话：同样以上字符 - 下午11:56

昨天 上午10:22 （昨天的）
会话：只显示 - 昨天

星期二 上午08:21 （今天昨天之前的一周显示星期）
会话：只显示 - 星期二

2015年1月22日 上午11:58 （一周之前显示具体的日期了）
会话：显示 - 2015/04/18
*/
//设置格式 年yyyy 月 MM 日dd 小时hh(HH) 分钟 mm 秒 ss MMM单月 eee周几 eeee星期几 a上午下午
+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)isShort {
  NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  NSString *output = nil;

  NSTimeInterval theDiff = -theDate.timeIntervalSinceNow;

  //上述时间差输出不同信息
  if (theDiff < 60) {
    output = @"刚刚";

  } else if (theDiff < 60 * 60) {
    int minute = (int) (theDiff / 60);
    output = [NSString stringWithFormat:@"%d分钟前", minute];

  } else {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    [formatter setLocale:locale];

    BOOL isTodayYesterday = NO;
    BOOL isPastLong = NO;

    if ([theDate isToday]) {
      [formatter setDateFormat:FORMAT_TODAY];
    } else if ([theDate isYesterday]) {
      [formatter setDateFormat:FORMAT_YESTERDAY];
      isTodayYesterday = YES;
    } else if ([theDate isThisWeek]) {
      if (isShort) {
        [formatter setDateFormat:FORMAT_THIS_WEEK_SHORT];
      } else {
        [formatter setDateFormat:FORMAT_THIS_WEEK];
      }
    } else {
      if (isShort) {
        [formatter setDateFormat:FORMAT_PAST_SHORT];
      } else {
        [formatter setDateFormat:FORMAT_PAST_TIME];
        isPastLong = YES;
      }
    }

    if (isTodayYesterday) {
      NSString *todayYesterday = [JCHATStringUtils getTodayYesterdayString:theDate];
      if (isShort) {
        output = todayYesterday;
      } else {
        output = [formatter stringFromDate:theDate];
        output = [NSString stringWithFormat:@"%@ %@", todayYesterday, output];
      }
    } else {
      output = [formatter stringFromDate:theDate];
      if (isPastLong) {
        NSString *thePastDate = [JCHATStringUtils getPastDateString:theDate];
        output = [NSString stringWithFormat:@"%@ %@", thePastDate, output];
      }
    }
  }

  return output;
}

+ (NSString *)getTodayYesterdayString:(NSDate *)theDate {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
  [formatter setLocale:locale];
  formatter.dateStyle = NSDateFormatterShortStyle;
  formatter.timeStyle = NSDateFormatterNoStyle;
  formatter.doesRelativeDateFormatting = YES;
  return [formatter stringFromDate:theDate];
}

+ (NSString *)getPastDateString:(NSDate *)theDate {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
  [formatter setLocale:locale];
  formatter.dateStyle = NSDateFormatterLongStyle;
  formatter.timeStyle = NSDateFormatterNoStyle;
  return [formatter stringFromDate:theDate];
}

+ (NSString *)dictionary2String:(NSDictionary *)dictionary {
  if (![dictionary count]) {
    return nil;
  }

  NSString *tempStr1 = [[dictionary description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
  NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
  NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
  NSString *str = [NSPropertyListSerialization propertyListFromData:tempData
                                                   mutabilityOption:NSPropertyListImmutable
                                                             format:NULL
                                                   errorDescription:NULL];
  return str;
}


@end