//
//  JCHATFootTableCollectionReusableView.m
//  JChat
//
//  Created by oshumini on 15/12/15.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATFootTableCollectionReusableView.h"
#import "JCHATFootTableViewCell.h"

@implementation JCHATFootTableCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
  _footTableView.tableFooterView = [UIView new];
  [_footTableView registerNib:[UINib nibWithNibName:@"JCHATFootTableViewCell" bundle:nil] forCellReuseIdentifier:@"JCHATFootTableViewCell"];
  _footTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _footTableView.scrollEnabled = NO;
}


@end
