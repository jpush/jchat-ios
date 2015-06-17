//
//  JCHATChatViewController.h
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATChatTable.h"
@interface JCHATChatViewController : UIViewController<UISearchBarDelegate,UISearchControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,TouchTableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *addBgView;
@property (weak, nonatomic) IBOutlet JCHATChatTable *chatTableView;

@end
