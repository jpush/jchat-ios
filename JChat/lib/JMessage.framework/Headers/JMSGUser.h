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
*  更新用户信息类型
*/
typedef NS_ENUM(NSUInteger, JMSGUpdateUserInfoType) {
  kJMSGNickname  = 0,
  kJMSGBirthday  = 1,
  kJMSGSignature = 2,
  kJMSGGender    = 3,
  kJMSGRegion    = 4,
  kJMSGAvatar    = 5,
};

typedef NS_ENUM(NSUInteger, JMSGUserGender){
  kJMSGUnknown = 0,
  kJMSGMale,
  kJMSGFemale,
};

@interface JMSGUser : NSObject <NSCopying>

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
*  @param username      用户登录用户名
*  @param password      用户登录密码
*  @param handler       用户登录回调接口
*/
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
        completionHandler:(JMSGCompletionHandler)handler;

/**
*  用户注册接口
*
*  @param username      用户注册用户名
*  @param password      用户注册密码
*  @param handler       用户注册回调接口函数
*/
+ (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
           completionHandler:(JMSGCompletionHandler)handler;

/**
*  用户登出接口
*/

+ (void)logoutWithCompletionHandler:(JMSGCompletionHandler)handler;

/**
 *  获取用户信息接口
 *
 *  @param username      需要获取信息的用户名
 *  @param handler       用户获取信息回调接口函数(resultObject为JMSGUser类型)
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
 *  @param  userInfo      需要获取头像的用户信息(通过getUserInfo接口获取)
 *  @param  handler       用户获取头像接口函数(resultObject为JMSGUser类型,通过avatarResourcePath属性获取下载图片位置)
 *
 */
 + (void)getOriginAvatarImage         : (JMSGUser *)userInfo
         completionHandler            : (JMSGCompletionHandler)handler;

/**
 *  更新用户信息接口
 *
 *  @param parameter     新的属性值
 *  @param type          更新属性类型
 *  @param handler       用户注册回调接口函数
 */
+ (void)updateMyInfoWithParameter:(id)parameter
                         withType:(JMSGUpdateUserInfoType)type
                completionHandler:(JMSGCompletionHandler)handler;

/**
 *  更新密码接口
 *
 *  @param newPassword   用户新的密码
 *  @param oldPassword   用户旧的密码
 *  @param handler       用户注册回调接口函数
 */
+ (void)updatePasswordWithNewPassword:(NSString *)newPassword
                          oldPassword:(NSString *)oldPassword
                    completionHandler:(JMSGCompletionHandler)handler;

@end
