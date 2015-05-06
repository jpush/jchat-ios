//
//  JMSGUser.h
//  JPush IM
//
//  Created by Apple on 15/1/27.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMSGConfig.h"
@interface JMSGUser : NSObject

 @property (nonatomic,strong) NSString *address;
 @property (nonatomic,strong) NSString *avatarResourcePath;
 @property (nonatomic,strong) NSString *avatarThumbPath;
 @property (nonatomic,strong) NSString *birthday;
 @property (nonatomic,strong) NSNumber *userGender;
 @property (nonatomic,strong) NSString *cTime;

 @property (nonatomic,assign) NSInteger star;
 @property (nonatomic,assign) NSInteger blackList;
 @property (nonatomic,strong) NSString *region;
 @property (nonatomic,strong) NSString *nickname;
 @property (nonatomic,strong) NSString *noteName;
 @property (nonatomic,strong) NSString *noteText;
 @property (nonatomic,strong) NSString *signature;
 @property (nonatomic,assign) SInt64    uid;
 @property (nonatomic,strong) NSString *username;
 @property (nonatomic,strong) NSString *password;

@end
