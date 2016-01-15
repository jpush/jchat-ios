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
  UIView *subLine = [UIView new];
  [self  addSubview:subLine];
  [subLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self);
    make.right.mas_equalTo(self);
    make.height.mas_equalTo(0.5);
    make.bottom.mas_equalTo(self);
  }];
  subLine.backgroundColor = kSeparationLineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
