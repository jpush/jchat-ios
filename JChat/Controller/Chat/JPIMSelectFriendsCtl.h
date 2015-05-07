//
//  JPIMSelectFriendsCtl.h
//  JPush IM
//
//  Created by Apple on 15/2/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTable.h"

@interface JPIMSelectFriendsCtl : UIViewController<UITableViewDataSource,UITableViewDelegate,TouchTableViewDelegate>
@property (nonatomic,strong) ChatTable *selectFriendTab;
@property (nonatomic,strong) NSMutableArray *arrayOfCharacters;
@end
