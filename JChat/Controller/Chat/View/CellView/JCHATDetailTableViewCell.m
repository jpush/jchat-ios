//
//  JCHATDetailTableViewCell.m
//  JPush IM
//
//  Created by Apple on 15/1/22.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATDetailTableViewCell.h"
#import "JChatConstants.h"

@implementation JCHATDetailTableViewCell

- (void)awakeFromNib {
  UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(0, 56,kApplicationWidth, 0.5)];
  [line setBackgroundColor:UIColorFromRGB(0xd0d0cf)];
  [self addSubview:line];}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
