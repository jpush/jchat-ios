/*
 *	| |    | |  \ \  / /  | |    | |   / _______|
 *	| |____| |   \ \/ /   | |____| |  / /
 *	| |____| |    \  /    | |____| |  | |   _____
 * 	| |    | |    /  \    | |    | |  | |  |____ |
 *  | |    | |   / /\ \   | |    | |  \ \______| |
 *  | |    | |  /_/  \_\  | |    | |   \_________|
 *
 * Copyright (c) 2011 ~ 2015 Shenzhen HXHG. All rights reserved.
 */

#ifndef JMessage_JMSGConstants____FILEEXTENSION___
#define JMessage_JMSGConstants____FILEEXTENSION___

#import <Foundation/Foundation.h>


///----------------------------------------------------
/// @name type & define
///----------------------------------------------------

/*!
 @abstract 异步回调 block

 @discussion 大多数异步 API 都会以过个 block 回调。

 - 如果调用出错，则 error 不为空，可根据 error.code 来获取错误码。该错误码 JMessage 相关文档里有详细的定义。
 - 如果返回正常，则 error 为空。从 resultObject 去获取相应的返回。每个 API 的定义上都会有进一步的定义。

 */
typedef void (^JMSGCompletionHandler)(id resultObject, NSError *error);

/*!
 * @abstract 空的 CompletionHandler.
 *
 * @discussion 用于不需要进行处理时.
 */
#define JMSG_NULL_COMPLETION_BLOCK ^(id resultObject, NSError *error){}

/*!
 * @abstract 数据返回的异步回调
 *
 * @discussion 专用于数据返回 API.
 *
 * - objectId 当前数据的ID标识.
 *   - 消息里返回 voice/image 的 media data 时, objectId 是 msgId;
 *   - 用户里返回 avatar 头像数据时, objectId 是 username.
 *
 */
typedef void (^JMSGAsyncDataHandler)(NSData *data, NSString *objectId, NSError *error);

/*!
 * @abstract 媒体上传进度 block
 *
 * @discussion 在发送消息时，可向 JMSGMessage 对象设置此 block，从而可以得到上传的进度
 */
typedef void (^JMSGMediaUploadProgressHandler)(float percent);

/*!
 * @abstract Generic 泛型
 */
#if __has_feature(objc_generics) || __has_extension(objc_generics)
#  define JMSG_GENERIC(...) <__VA_ARGS__>
#else
#  define JMSG_GENERIC(...)
#endif

/*!
 * @abstract nullable 用于定义某属性或者变量是否可允许为空
 */
#if __has_feature(nullability)
#  define JMSG_NONNULL __nonnull
#  define JMSG_NULLABLE __nullable
#else
#  define JMSG_NONNULL
#  define JMSG_NULLABLE
#endif

#if __has_feature(assume_nonnull)
#  ifdef NS_ASSUME_NONNULL_BEGIN
#    define JMSG_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#  else
#    define JMSG_ASSUME_NONNULL_BEGIN _Pragma("clang assume_nonnull begin")
#  endif
#  ifdef NS_ASSUME_NONNULL_END
#    define JMSG_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#  else
#    define JMSG_ASSUME_NONNULL_END _Pragma("clang assume_nonnull end")
#  endif
#else
#  define JMSG_ASSUME_NONNULL_BEGIN
#  define JMSG_ASSUME_NONNULL_END
#endif


///----------------------------------------------------
/// @name enums
///----------------------------------------------------

/*!
 * @typedef
 * @abstract 会话类型 - 单聊、群聊
 */
typedef NS_ENUM(NSInteger, JMSGConversationType) {
  kJMSGConversationTypeSingle = 1,
  kJMSGConversationTypeGroup = 2,
};

/*!
 * @typedef
 * @abstract 消息内容类型 - 文本、语音、图片等
 */
typedef NS_ENUM(NSInteger, JMSGContentType) {
  kJMSGContentTypeUnknown = 0,  // 不知道类型的消息: 上层应提示升级之类
  kJMSGContentTypeText = 1,         // 文本消息
  kJMSGContentTypeImage = 2,        // 图片消息
  kJMSGContentTypeVoice = 3,        // 语音消息
  kJMSGContentTypeCustom = 4,       // 自定义消息
  kJMSGContentTypeEventNotification = 5, // 事件通知消息。服务器端下发的事件通知，本地展示为这个类型的消息展示出来
};

/*!
 * @typedef
 * @abstract 消息状态
 */
typedef NS_ENUM(NSInteger, JMSGMessageStatus) {
  /// Send Message
      kJMSGMessageStatusSendDraft = 0,    // 消息创建时的初始状态
  kJMSGMessageStatusSending = 1,      // 消息正在发送过程中. UI 一般显示进度条
  kJMSGMessageStatusSendUploadFailed = 2,   //
  kJMSGMessageStatusSendUploadSucceed = 3,  //
  kJMSGMessageStatusSendFailed = 4,
  kJMSGMessageStatusSendSucceed = 5,
  /// Received Message
      kJMSGMessageStatusReceiving = 6,
  kJMSGMessageStatusReceiveDownloadFailed = 7,
  kJMSGMessageStatusReceiveSucceed = 8,
};


/*!
 @typedef
 @abstract 上传文件的类型
 */
typedef NS_ENUM(NSInteger, JMSGFileType) {
  kJMSGFileTypeUnknown,
  kJMSGFileTypeImage,
  kJMSGFileTypeVoice,
};


///----------------------------------------------------
/// @name errors
///----------------------------------------------------

/*!
 * @typedef
 * @abstract JMessage SDK 的错误码汇总
 *
 * @discussion 错误码以 86 打头，都为 iOS SDK 内部的错误码
 */
typedef NS_ENUM(NSInteger, JMSGSDKErrorCode) {

  // network - 80
  JMSG_ERROR_NETWORK_USER_NOT_REGISTER = 801003,
  
  /// Network - 860

  JMSG_ERROR_NETWORK_REQUEST_INVALIDATE = 860010,
  JMSG_ERROR_NETWORK_REQUEST_TIMEOUT = 860011,   // 服务器返回超时
  JMSG_ERROR_NETWORK_REQUEST_FAIL = 860012,   // 服务器请求失败
  JMSG_ERROR_NETWORK_SERVER_FAIL = 860013,   // 服务端错误
  JMSG_ERROR_NETWORK_HOST_UNKNOWN = 860014,   // 地址错误
  kJMSGErrorSDKNetworkDownloadFailed = 860015,   // 下载失败
  JMSG_ERROR_NETWORK_OTHER = 860016,   // 网络原因
  JMSG_ERROR_NETWORK_TOKEN_FAILED = 860017,   // 服务器获取用户Token失败
  kJMSGErrorSDKNetworkUploadFailed = 860018,   // 上传资源文件失败
  kJMSGErrorSDKNetworkUploadTokenVerifyFailed = 860019,   // 上传资源文件Token验证失败
  kJMSGErrorSDKNetworkUploadTokenGetFailed = 860020,   // 获取服务器Token失败

  KJMSG_ERROR_NETWORK_RESULT_ERROR = 860021,    // 服务器返回数据错误（没有按约定返回）
  kJMSGErrorNetworkDataFormatInvalid = 860030,   // 数据格式错误

  JMSG_ERROR_LACK_PARAMETER = 860041,   // 缺少本地参数


  /// DB & Global params - 861

  kJMSGErrorSDKDBDeleteFailed = 861000,
  kJMSGErrorSDKDBUpdateFailed = 861001,
  kJMSGErrorSDKDBSelectFailed = 861002,
  kJMSGErrorSDKDBInsertFailed = 861003,

  kJMSGErrorSDKParamAppkeyInvalid = 861100, // AppKey invalid
  JMSG_ERROR_LOCAL_PARAMETER = 860040,   // 本地参数错误

  /// Third party - 862

  kJMSGErrorPartyQiniuUnknown = 862010,


  // User - 863

  kJMSGErrorSDKParamUsernameInvalid = 863001, // 用户名不合法
  kJMSGErrorSDKParamPasswordInvalid = 863002, // 用户密码不合法
  kJMSGErrorSDKParamAvatarNil = 86303,        // 用户头像属性为空
  kJMSGErrorSDKUserNotLogin = 86304,          // 用户没登录
  
  /// Media Resource - 864

  kJMSGErrorSDKNotMediaMessage = 864001,
  kJMSGErrorSDKMediaResourceMissing = 864002,
  kJMSGErrorSDKMediaCrcCodeIllegal = 864003,
  kJMSGErrorSDKMediaCrcVerifyFailed = 864004,
  kJMSGErrorSDKMediaUploadEmptyFile = 864005,


  /// Message - 865

  kJMSGErrorSDKParamContentInvalid = 865001,  // 消息内容无效
  kJMSGErrorSDKParamMessageNil = 865002, // 空消息
  kJMSGErrorSDKMessageNotPrepared = 865003, // 消息不符合发送的基本条件检查

  /// Conversation - 866

  kJMSGErrorSDKParamConversationTypeUnknown = 866001, // 会话类型错误
  kJMSGErrorSDKParamConversationUsernameInvalid = 866002, // 会话 username 无效
  kJMSGErrorSDKParamConversationGroupIdInvalid = 866003, // 会话 groupId 无效
  kJMSGErrorSDKParamConversationLackAvatarPath = 866004, // 会话没有 avatarPath

  /// Group - 867

  kJMSGErrorSDKParamGroupGroupIdInvalid = 867001, // GroupId 错误
  kJMSGErrorSDKParamGroupGroupInfoInvalid = 867002, // Group 其他信息不对
  
  // Media - 868
  kJMSGErrorMediaCrcInvalid = 868001,   // crc32 错误
};

/*!
 @abstract SDK依赖的内部 HTTP 服务返回的错误码。
 @discussion 这些错误码也会直接通过 SDK API 返回给应用层。
 */
typedef NS_ENUM(NSUInteger, JMSGHttpErrorCode) {
  kJMSGErrorHttpServerInternal = 898000,
  kJMSGErrorHttpUserExist = 898001,
  kJMSGErrorHttpUserNotExist = 898002,
  kJMSGErrorHttpPrameterInvalid = 898003,
  kJMSGErrorHttpPasswordError = 898004,
  kJMSGErrorHttpUidInvalid = 898005,
  kJMSGErrorHttpGidInvalid = 898006,
  kJMSGErrorHttpMissingAuthenInfo = 898007,
  kJMSGErrorHttpAuthenticationFailed = 898008,
  kJMSGErrorHttpAppkeyNotExist = 898009,
  kJMSGErrorHttpTokenExpired = 898010,
  kJMSGErrorHttpUserNotLoggedIn = 800012,
  kJMSGErrorHttpServerResponseTimeout = 898030,
  kJMSGErrorHttpUserNotExist2 = 899002,
};

/*!
 @abstract SDK依赖的内部 TCP 服务返回的错误码
 @discussion 这些错误码也会直接通过 SDK API 返回给应用层。
 */
typedef NS_ENUM(NSUInteger, JMSGTcpErrorCode) {
  kJMSGErrorTcpAppkeyNotRegistered = 800003,
  kJMSGErrorTcpUserIDEmpty = 800004,
  kJMSGErrorTcpUserIDNotRegistered = 800005,
  kJMSGErrorTcpServerInternalError = 800009,
  kJMSGErrorTcpUserLogoutState = 800012,
  kJMSGErrorTcpUserOfflineState = 800013,

};


///----------------------------------------------------
/// @name Global keys 全局静态变量定义
///----------------------------------------------------

// General key

static NSString *const KEY_APP_KEY = @"appkey";


// User

static NSString *const KEY_USERNAME = @"username";
static NSString *const KEY_PASSWORD = @"password";

static NSString *const KEY_NEW_PASSWORD = @"new_password";
static NSString *const KEY_OLD_PASSWORD = @"old_password";

static NSString *const KEY_NICKNAME = @"nickname";
static NSString *const KEY_AVATAR = @"avatar";
static NSString *const KEY_GENDER = @"gender";
static NSString *const KEY_BIRTHDAY = @"birthday";
static NSString *const KEY_REGION = @"region";
static NSString *const KEY_SIGNATURE = @"signature";
static NSString *const KEY_STAR = @"star";
static NSString *const KEY_UID = @"uid";
static NSString *const KEY_ADDRESS = @"address";


#endif

