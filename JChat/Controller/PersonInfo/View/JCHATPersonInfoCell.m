//
//  JCHATPersonInfoCell.m
//  JPush IM
//
//  Created by Apple on 15/2/5.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATPersonInfoCell.h"
#import "JChatConstants.h"
@implementation JCHATPersonInfoCell

- (void)awakeFromNib {
  // Initialization code
  [_baseLine setBackgroundColor:UIColorFromRGB(0xd0d0cf)];
  [_personInfoConten setTextColor:UIColorFromRGB(0x808080)];
  _personInfoConten.textAlignment = NSTextAlignmentRight;
  [_personInfoConten setEnabled:NO];
  [_personInfoConten setNumberOfLines:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
