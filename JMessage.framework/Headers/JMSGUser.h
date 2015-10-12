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

#import <Foundation/Foundation.h>
#import <JMessage/JMSGConstants.h>

/*!
 * @abstract 更新用户字段
 */
typedef NS_ENUM(NSUInteger, JMSGUserField) {
  kJMSGUserFieldsNickname = 0,
  kJMSGUserFieldsBirthday = 1,
  kJMSGUserFieldsSignature = 2,
  kJMSGUserFieldsGender = 3,
  kJMSGUserFieldsRegion = 4,
  kJMSGUserFieldsAvatar = 5,
};

/*!
 * @abstract 用户性别
 */
typedef NS_ENUM(NSUInteger, JMSGUserGender) {
  kJMSGUserGenderUnknown = 0,
  kJMSGUserGenderMale,
  kJMSGUserGenderFemale,
};


/*!
 * @abstract 用户
 *
 * @discussion 表征一个用户
 */
@interface JMSGUser : NSObject <NSCopying>

JMSG_ASSUME_NONNULL_BEGIN


///----------------------------------------------------
/// @name Class Methods 类方法
///----------------------------------------------------

/*!
 * @abstract 用户注册接口
 *
 * @param username 用户注册用户名
 * @param password 用户注册密码
 * @param handler  用户注册回调接口函数
 */
+ (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
           completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 用户登录接口
 *
 * @param username 用户登录用户名
 * @param password 用户登录密码
 * @param handler  用户登录回调接口
 */
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
        completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 退出登录
 *
 * @param handler 结果回调。正常返回时 resultObject 也是 nil。
 *
 * @discussion 这个接口一般总是返回成功，即使背后与服务器端通讯失败，客户端也总是会退出登录的。
 */
+ (void)logout:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 批量获取用户信息
 *
 * @param usernameArray 用户名列表。NSArray 里的数据类型为 NSString
 * @param handler 结果回调。正常返回时 resultObject 的类型为 NSArray，数组里的数据类型为 JMSGUser
 *
 @discussion 这是一个批量接口。
 */
+ (void)userInfoArrayWithUsernameArray:(NSArray JMSG_GENERIC(__kindof NSString *)*)usernameArray
                     completionHandler:(JMSGCompletionHandler)handler;


/*!
 * @abstract 获取用户本身个人信息接口
 *
 * @return 当前登陆账号个人信息
 */
+ (JMSGUser *)myInfo;

/*!
 * @abstract 更新用户信息接口
 *
 * @param parameter     新的属性值
 *        Birthday&&Gender 是NSNumber类型, Avatar NSData类型 其他 NSString
 * @param type          更新属性类型
 * @param handler       用户注册回调接口函数
 */
+ (void)updateMyInfoWithParameter:(id)parameter
                             type:(JMSGUserField)type
                completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

/*!
 * @abstract 更新密码接口
 *
 * @param newPassword   用户新的密码
 * @param oldPassword   用户旧的密码
 * @param handler       用户注册回调接口函数
 */
+ (void)updateMyPasswordWithNewPassword:(NSString *)newPassword
                            oldPassword:(NSString *)oldPassword
                      completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;


///----------------------------------------------------
/// @name Basic Fields 基本属性
///----------------------------------------------------

/*!
 * @abstract 用户名
 *
 * @discussion 这是用户帐号，注册后不可变更。App 级别唯一。这是所有用户相关 API 的用户标识。
 */
@property(nonatomic, copy, readonly) NSString *username;

/*!
 * @abstract 用户昵称
 *
 * @discussion 用户自定义的昵称，可任意定义。
 */
@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE nickname;

/*!
 * @abstract 用户头像（媒体文件ID）
 *
 * @discussion 此文件ID仅用于内部更新，不支持外部URL。
 */
@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE avatar;

/*!
 * @abstract 性别
 *
 * @discussion 这是一个 enum 类型，支持 3 个选项：未知，男，女
 */
@property(nonatomic, assign, readonly) JMSGUserGender gender;

/*!
 * @abstract 生日
 */
@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE birthday;

@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE region;

@property(nonatomic, copy, readonly) NSString * JMSG_NULLABLE signature;


/*!
 * @abstract 获取头像缩略图文件数据
 *
 * @param handler 结果回调。resultObject 是缩略图文件数据，类型是 NSData.
 * resultObject 返回 nil, 并且 error 也为 nil (没有出错) 时, 表示用户没有头像.
 *
 * @discussion 需要展示缩略图时使用。
 * 如果本地已经有文件，则会返回本地，否则会从服务器上下载。
 */
- (void)thumbAvatarData:(JMSGAsyncDataHandler)handler;

/*!
 * @abstract 获取头像大图文件数据
 *
 * @param handler 结果回调。resultObject 是缩略图文件数据，类型是 NSData
 * resultObject 返回 nil, 并且 error 也为 nil (没有出错) 时, 表示用户没有头像.
 *
 * @discussion 需要展示大图图时使用
 * 如果本地已经有文件，则会返回本地，否则会从服务器上下载。
 */
- (void)largeAvatarData:(JMSGAsyncDataHandler)handler;

/*!
 * @abstract 用户展示名
 *
 * @discussion 如果 nickname 存在则返回 nickname，否则返回 username
 */
- (NSString *)displayName;

- (BOOL)isEqualToUser:(JMSGUser * JMSG_NULLABLE)user;

JMSG_ASSUME_NONNULL_END

@end
