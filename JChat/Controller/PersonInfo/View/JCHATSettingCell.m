//
//  JCHATSettingCell.m
//  JPush IM
//
//  Created by Apple on 14/12/25.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATSettingCell.h"
#import "JChatConstants.h"
@implementation JCHATSettingCell

- (void)awakeFromNib {
  // Initialization code
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
