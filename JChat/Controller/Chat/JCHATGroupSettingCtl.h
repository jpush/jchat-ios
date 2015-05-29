//
//  JCHATGroupSettingCtl.h
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATChatTable.h"
#import "JCHATGroupPersonView.h"
#import "JCHATSendMessageViewController.h"

@class JMSGConversation;

@interface JCHATGroupSettingCtl : UIViewController<UITableViewDataSource,UITableViewDelegate,TouchTableViewDelegate,GroupPersonDelegate,UITextFieldDelegate>
@property (nonatomic,strong) JCHATChatTable *groupTab;
@property (nonatomic,strong) JMSGConversation *conversation;
@property (nonatomic,strong) JCHATSendMessageViewController *sendMessageCtl;

@end
