//
//  JPIMGroupSettingCtl.h
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTable.h"
#import "JPIMGroupPersonView.h"
@interface JPIMGroupSettingCtl : UIViewController<UITableViewDataSource,UITableViewDelegate,TouchTableViewDelegate,GroupPersonDelegate>
@property (nonatomic,strong) ChatTable *groupTab;

@end
