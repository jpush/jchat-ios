//
//  JCHATFriendDetailViewController.h
//  极光IM
//
//  Created by Apple on 15/4/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATFrIendDetailMessgeCell.h"
#import "JCHATChatModel.h"

@interface JCHATFriendDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SkipToSendMessageDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) JMSGUser *userInfo;
@property (assign, nonatomic) BOOL isGroupFlag;
@end
