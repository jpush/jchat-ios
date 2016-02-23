//
// Created by Javen on 15/5/11.
// Copyright (c) 2015 HXHG. All rights reserved.
//

#import "JCHATStringUtils.h"
#import "NSDate+Utilities.h"

#import "sys/utsname.h"

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
//    case JMSG_ERROR_NETWORK_REQUEST_TIMEOUT:
//      errorAlert = @"服务器返回超时";
//      break;
//    case JMSG_ERROR_NETWORK_REQUEST_FAIL:
//      errorAlert = @"服务器请求失败";
//      break;
//    case JMSG_ERROR_NETWORK_SERVER_FAIL:
//      errorAlert = @"服务端错误";
//      break;
//    case JMSG_ERROR_NETWORK_HOST_UNKNOWN:
//      errorAlert = @"地址错误";
//      break;
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
//    case kJMSGErrorNetworkDataFormatInvalid:
//      errorAlert = @"数据格式错误";
//      break;
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
//    case kJMSGErrorPartyQiniuUnknown:
//      errorAlert = @"七牛出错";
//      break;
    case kJMSGErrorSDKParamUsernameInvalid:
      errorAlert = @"用户名不合法";
      break;
    case kJMSGErrorSDKParamPasswordInvalid:
      errorAlert = @"用户密码不合法";
      break;
//    case kJMSGErrorSDKParamAvatarNil:
//      errorAlert = @"用户头像属性为空";
//      break;
    case kJMSGErrorSDKUserNotLogin:
      errorAlert = @"用户没有登录";
      break;
    case kJMSGErrorSDKNotMediaMessage:
      errorAlert = @"这不是一条媒体消息";
      break;
    case kJMSGErrorSDKMediaResourceMissing:
      errorAlert = @"下载媒体资源路径或者数据意外丢失";
      break;
    case kJMSGErrorSDKMediaCrcCodeIllegal:
      errorAlert = @"媒体CRC码无效";
      break;
    case kJMSGErrorSDKMediaCrcVerifyFailed:
      errorAlert = @"媒体CRC校验失败";
      break;
    case kJMSGErrorSDKMediaUploadEmptyFile:
      errorAlert = @"上传媒体文件时, 发现文件不存在";
      break;
    case kJMSGErrorSDKParamContentInvalid:
      errorAlert = @"无效的消息内容";
      break;
    case kJMSGErrorSDKParamMessageNil:
      errorAlert = @"空消息";
      break;
    case kJMSGErrorSDKMessageNotPrepared:
      errorAlert = @"消息不符合发送的基本条件检查";
      break;
    case kJMSGErrorSDKParamConversationTypeUnknown:
      errorAlert = @"未知的会话类型";
      break;
    case kJMSGErrorSDKParamConversationUsernameInvalid:
      errorAlert = @"会话 username 无效";
      break;
    case kJMSGErrorSDKParamConversationGroupIdInvalid:
      errorAlert = @"会话 groupId 无效";
      break;
    case kJMSGErrorSDKParamGroupGroupIdInvalid:
      errorAlert = @"groupId 无效";
      break;
    case kJMSGErrorSDKParamGroupGroupInfoInvalid:
      errorAlert = @"group 相关字段无效";
      break;
    case kJMSGErrorSDKMessageNotInGroup:
      errorAlert = @"你已不在该群，无法发送消息";
      break;
    case 810009:
      errorAlert = @"超出群上限";
      break;
    case kJMSGErrorHttpServerInternal:
      errorAlert = @"服务器端内部错误";
      break;
    case kJMSGErrorHttpUserExist:
      errorAlert = @"用户已经存在";
      break;
    case kJMSGErrorHttpUserNotExist:
      errorAlert = @"用户不存在";
      break;
    case kJMSGErrorHttpPrameterInvalid:
      errorAlert = @"参数无效";
      break;
    case kJMSGErrorHttpPasswordError:
      errorAlert = @"密码错误";
      break;
    case kJMSGErrorHttpUidInvalid:
      errorAlert = @"内部UID 无效";
      break;
    case kJMSGErrorHttpMissingAuthenInfo:
      errorAlert = @"Http 请求没有验证信息";
      break;
    case kJMSGErrorHttpAuthenticationFailed:
      errorAlert = @"Http 请求验证失败";
      break;
    case kJMSGErrorHttpAppkeyNotExist:
      errorAlert = @"Appkey 不存在";
      break;
    case kJMSGErrorHttpTokenExpired:
      errorAlert = @"Http 请求 token 过期";
      break;
    case kJMSGErrorHttpServerResponseTimeout:
      errorAlert = @"服务器端响应超时";
      break;
    case kJMSGErrorTcpUserNotRegistered:
      errorAlert = @"用户名还没有被注册过";
      break;
    case kJMSGErrorTcpUserPasswordError:
      errorAlert = @"密码错误";
      break;
    default:
      errorAlert = nil;
      break;
  }
  return errorAlert;
}

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


- (NSString *)deviceString {
  struct utsname systemInfo;
  uname(&systemInfo);
  NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
  
  if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
  if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
  if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
  if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
  if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
  if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
  if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
  if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
  if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
  if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
  if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
  if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
  if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
  if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
  if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
  if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
  if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
  NSLog(@"NOTE: Unknown device type: %@", deviceString);
  return deviceString;
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
  
  NSString  *urlRegEx =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
  "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
  
  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
  
  if (regex != nil) {
    NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
    
    if (firstMatch) {
      NSRange resultRange = [firstMatch rangeAtIndex:0];
      NSString *result=[ipAddress substringWithRange:resultRange];
      //输出结果
      NSLog(@"%@",result);
      return YES;
    }
  }
  
  return NO;
}

+ (NSString *)conversationIdWithConversation:(JMSGConversation *)conversation {
  NSString *conversationId = nil;
  if (conversation.conversationType == kJMSGConversationTypeSingle) {
    JMSGUser *user = conversation.target;
    conversationId = [NSString stringWithFormat:@"%@_%ld",user.username, kJMSGConversationTypeSingle];
  } else {
    JMSGGroup *group = conversation.target;
    conversationId = [NSString stringWithFormat:@"%@_%ld",group.gid,kJMSGConversationTypeGroup];
  }
  return conversationId;
}

+ (CGSize)stringSizeWithWidthString:(NSString *)string withWidthLimit:(CGFloat)width withFont:(UIFont *)font {
  CGSize maxSize = CGSizeMake(width, 2000);
//  UIFont *font =[UIFont systemFontOfSize:18];
  NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
  CGSize realSize = [string boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
  return realSize;
}
@end