//
//  JCHATGroupSettingCell.m
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATGroupSettingCell.h"

@implementation JCHATGroupSettingCell

- (void)awakeFromNib {
  // Initialization code
  [_groupName setEnabled:NO];
}

//- (void)setDataWithConversation:(JMSGConversation *)conversation {
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
