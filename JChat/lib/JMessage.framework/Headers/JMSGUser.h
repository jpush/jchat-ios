//
//  JMSGUser.h
//  JPush IM
//
//  Created by Apple on 15/1/27.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/***************************************声明枚举类型*********************************************/
/**
 *  更新用户信息类型
 */
typedef NS_ENUM(NSUInteger,JMSGUpdateUserInfoType){
    kJMSGNickname  = 0,
    kJMSGBirthday  = 1,
    kJMSGSignature = 2,
    kJMSGGender    = 3,
    kJMSGRegion    = 4,
    kJMSGAvatar    = 5,
};
/*******************************************************************************************/

@interface JMSGUser : NSObject

 @property (atomic,strong, readonly) NSString *address;
 @property (atomic,strong, readonly) NSString *avatarResourcePath;
 @property (atomic,strong, readonly) NSString *avatarThumbPath;
 @property (atomic,strong, readonly) NSString *birthday;
 @property (atomic,strong, readonly) NSNumber *userGender;
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

@end
