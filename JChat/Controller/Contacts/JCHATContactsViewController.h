//
//  JCHATContactsViewController.h
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATContactsViewController : UIViewController<UISearchBarDelegate,UISearchControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contractTable;

@end
