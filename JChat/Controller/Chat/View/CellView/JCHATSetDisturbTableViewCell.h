//
//  JCHATSetDisturbTableViewCell.h
//  JChat
//
//  Created by oshumini on 16/6/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATFriendDetailViewController.h"

@interface JCHATSetDisturbTableViewCell : UITableViewCell
@property(strong,nonatomic) UISwitch *isDisturbBtn;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property(weak,nonatomic) JCHATFriendDetailViewController *delegate;

- (void)layoutToSetDisturb:(BOOL)isNodistur;
- (void)layoutToSetBlack:(BOOL)isInBlack;
@end
