//
//  JCHATGroupSettingCtl.h
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
// TODO: 换成collectionview

#import <UIKit/UIKit.h>
#import "JCHATChatTable.h"
#import "JCHATGroupPersonView.h"
#import "JCHATConversationViewController.h"

@class JMSGConversation;

@interface JCHATGroupSettingCtl : UIViewController<UITableViewDataSource,UITableViewDelegate,TouchTableViewDelegate,GroupPersonDelegate,UITextFieldDelegate>
@property (nonatomic,strong) JCHATChatTable *groupTab;
@property (nonatomic,strong) JMSGConversation *conversation;
@property (nonatomic,strong) JCHATConversationViewController *sendMessageCtl;
@property (nonatomic,strong) NSMutableArray *groupData;
@end
