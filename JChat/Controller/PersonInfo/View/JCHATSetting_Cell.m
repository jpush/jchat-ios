//
//  JCHATSetting_Cell.m
//  JPush IM
//
//  Created by Apple on 15/2/5.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATSetting_Cell.h"
#import "JChatConstants.h"
@implementation JCHATSetting_Cell

- (void)awakeFromNib {
  // Initialization code
  UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(0, 56,kApplicationWidth, 0.5)];
  [line setBackgroundColor:UIColorFromRGB(0xd0d0cf)];
  [self addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
