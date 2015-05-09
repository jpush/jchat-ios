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
@interface JCHATGroupSettingCtl : UIViewController<UITableViewDataSource,UITableViewDelegate,TouchTableViewDelegate,GroupPersonDelegate>
@property (nonatomic,strong) JCHATChatTable *groupTab;

@end
