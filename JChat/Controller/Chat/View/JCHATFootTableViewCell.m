//
//  JCHATFootTableViewCell.m
//  JChat
//
//  Created by oshumini on 15/12/15.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATFootTableViewCell.h"

@implementation JCHATFootTableViewCell

- (void)awakeFromNib {
  // Initialization code
  _quitGroupBtn.layer.cornerRadius = 4;
  _quitGroupBtn.layer.masksToBounds = YES;
  _quitGroupBtn.backgroundColor = [UIColor redColor];
  [_quitGroupBtn setBackgroundImage:[ViewUtil colorImage:[UIColor blackColor] frame:_quitGroupBtn.frame] forState:UIControlStateHighlighted];
  UIView *separatLine = [UIView new];
  [self addSubview:separatLine];
  [separatLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self);
    make.right.mas_equalTo(self);
    make.height.mas_equalTo(0.5);
    make.top.mas_equalTo(self);
  }];
  separatLine.backgroundColor = kSeparationLineColor;
  
  _baseLine = [UIView new];
  [self addSubview:_baseLine];
  [_baseLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self);
    make.right.mas_equalTo(self);
    make.height.mas_equalTo(0.5);
    make.bottom.mas_equalTo(self).with.offset(0.5);
  }];
  _baseLine.backgroundColor = kSeparationLineColor;
  _baseLine.hidden = YES;
  
}

- (void)setDataWithGroupName:(NSString *)groupName {
  _footerTittle.hidden = NO;
  _userName.hidden = NO;
  _arrow.hidden = NO;
  _quitGroupBtn.hidden = YES;
  _baseLine.hidden = YES;
  _footerTittle.text = @"群聊名称";
  _userName.text = groupName;
  
}

- (void)layoutToClearChatRecord {
  _footerTittle.hidden = NO;
  _userName.hidden = NO;
  _arrow.hidden = NO;
  _quitGroupBtn.hidden = YES;
  _baseLine.hidden = NO;
  _footerTittle.text = @"清空聊天记录";
  _userName.text = @"";
}

- (void)layoutToQuitGroup {
  _footerTittle.hidden = YES;
  _userName.hidden = YES;
  _arrow.hidden = YES;
  _quitGroupBtn.hidden = NO;
  _baseLine.hidden = YES;
}

- (IBAction)clickToQuitGroup:(id)sender {// rename
  [_delegate quitGroup];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  self.backgroundColor = [UIColor whiteColor];
    // Configure the view for the selected state
}

@end
