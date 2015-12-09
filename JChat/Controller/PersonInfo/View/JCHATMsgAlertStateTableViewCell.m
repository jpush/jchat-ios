//
//  JCHATMsgAlertStateTableViewCell.m
//  JChat
//
//  Created by HuminiOS on 15/8/3.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATMsgAlertStateTableViewCell.h"
#import "JChatConstants.h"

@implementation JCHATMsgAlertStateTableViewCell

- (void)awakeFromNib {
  // Initialization code
  [self.titleMain setTextColor:UIColorFromRGB(0x000000)];
  [self.title1 setTextColor:UIColorFromRGB(0xa4a4a4)];
  [self.stateLable setTextColor:UIColorFromRGB(0xa4a2a3)];
  
}

- (void)setData {
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
