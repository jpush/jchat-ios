//
//  JCHATSetDisturbTableViewCell.m
//  JChat
//
//  Created by oshumini on 16/6/17.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JCHATSetDisturbTableViewCell.h"
#import "JChatConstants.h"

@interface JCHATSetDisturbTableViewCell()
{
  BOOL _isSetDisturb;
}

@end

@implementation JCHATSetDisturbTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  self.isDisturbBtn = [UISwitch new];

  UIView *baseLine = [UIView new];
  [self addSubview:baseLine];
  [baseLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self);
    make.right.mas_equalTo(self);
    make.height.mas_equalTo(0.5);
    make.bottom.mas_equalTo(self).with.offset(0.5);
  }];
  baseLine.backgroundColor = kSeparationLineColor;
  
  self.isDisturbBtn = [UISwitch new];
  [self.contentView addSubview: self.isDisturbBtn];
  [self.isDisturbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(self.contentView);
    make.size.mas_equalTo(CGSizeMake(49, 31));
    make.right.mas_equalTo(self.contentView).with.offset(-12);
  }];
  
  [self.isDisturbBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)layoutToSetDisturb:(BOOL)isNodistur {
  _isSetDisturb = YES;
  self.cellTitle.text = @"消息免打扰";
  [self.isDisturbBtn setOn:isNodistur];
}

- (void)layoutToSetBlack:(BOOL)isInBlack {
  _isSetDisturb = NO;
  self.cellTitle.text = @"黑名单";
  [self.isDisturbBtn setOn:isInBlack];
}


- (void)switchAction:(id)sender {
  UISwitch *switchButton = (UISwitch*)sender;
  if (_isSetDisturb == YES) {
    [_delegate switchDisturb];
  } else {
    [_delegate switchBlack];
  }
  
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
