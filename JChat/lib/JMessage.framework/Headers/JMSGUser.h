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

/**
*  更新用户信息类型Enum
*/
typedef NS_ENUM(NSUInteger, JMSGUpdateUserInfoType) {
  kJMSGNickname  = 0,//别名
  kJMSGBirthday  = 1,//生日
  kJMSGSignature = 2,//个性签名
  kJMSGGender    = 3,//性别
  kJMSGRegion    = 4,//地区
  kJMSGAvatar    = 5,//个人头像
};

/**
 *  性别Enum
 */
typedef NS_ENUM(NSUInteger, JMSGUserGender){
  kJMSGUnknown = 0,
  kJMSGMale,
  kJMSGFemale,
};


@interface JMSGUser : NSObject <NSCopying, NSCoding>

 @property (atomic,strong, readonly) NSString *address;
 @property (atomic,strong, readonly) NSString *avatarResourcePath;
 @property (atomic,strong, readonly) NSString *avatarThumbPath;
 @property (atomic,strong, readonly) NSString *birthday;
 @property (atomic,assign, readonly) JMSGUserGender userGender;
 @property (atomic,strong, readonly) NSString *cTime;

 @property (atomic,assign, readonly) NSInteger star;
 @property (atomic,assign, readonly) NSInteger blackList;
 @property (atomic,strong, readonly) NSString *region;
 @property (atomic,strong, readonly) NSString *nickname;
 @property (atomic,strong, readonly) NSString *noteName;
 @property (atomic,strong, readonly) NSString *noteText;
 @property (atomic,strong, readonly) NSString *signature;
 @property (atomic,assign, readonly) SInt64    uid;
 @property (atomic,strong, readonly) NSString *username;
 @property (atomic,strong, readonly) NSString *password;

/**
 *  用户登录接口
 *
 *  @param username      用户名。定义参照注册接口。
 *  @param password      用户密码。定义参照注册接口。
 *  @param handler       结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
        completionHandler:(JMSGCompletionHandler)handler;

/**
 *  用户注册接口
 *
 *  @param username      用户名，或者说用户帐号。长度 4~128 位，支持的字符：字母、数字、下划线、英文减号、英文点、@符号，首字母只允许是字母或者数字。
 *  @param password      用户密码。长度 4~128 位，字符不限。
 *  @param handler       结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
           completionHandler:(JMSGCompletionHandler)handler;

/**
 *  用户登出接口
 *
 *  @param handler       结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)logoutWithCompletionHandler:(JMSGCompletionHandler)handler;

/**
 *  获取用户信息接口
 *
 *  @param username      用户名
 *  @param handler       结果回调。resultObject对象类型为JMSGUser。
 */
+ (void)getUserInfoWithUsername:(NSString *)username
              completionHandler:(JMSGCompletionHandler)handler;

/**
 *  获取用户本身个人信息接口
 *
 *  @return 当前登陆账号个人信息
 */
 + (JMSGUser *)getMyInfo;

/**
 *  获取头像原始图片
 *
 *  @param  userInfo      需要获取头像的用户信息(可以通过getUserInfo接口获取)
 *  @param  handler       结果回调。resultObject对象为JMSGUser类型,通过avatarResourcePath属性获取下载图片绝对路径
 *
 */
+ (void)getOriginAvatarImage:(JMSGUser *)userInfo
           completionHandler:(JMSGCompletionHandler)handler;

/**
 *  更新用户信息接口
 *
 *  @param parameter     更新的值。kJMSGGender性别类型，需要传入JMSGUserGender包装成NSNumber的对象，更新头像需要传入NSData类型的parameter,其他类型传NSString类型的对象。
 *  @param type          更新属性类型,这是一个 enum 类型
 *  @param handler       结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)updateMyInfoWithParameter:(id)parameter
                         withType:(JMSGUpdateUserInfoType)type
                completionHandler:(JMSGCompletionHandler)handler;

/**
 *  更新密码接口
 *
 *  @param newPassword   用户新的密码,长度 4~128 位，字符不限。
 *  @param oldPassword   用户旧的密码,长度 4~128 位，字符不限。
 *  @param handler       结果回调。resultObject值不需要关心,始终为nil
 */
+ (void)updatePasswordWithNewPassword:(NSString *)newPassword
                          oldPassword:(NSString *)oldPassword
                    completionHandler:(JMSGCompletionHandler)handler;

@end
