//
//  JCHATGroupDetailFooterReusableView.m
//  JChat
//
//  Created by HuminiOS on 15/11/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATGroupDetailFooterReusableView.h"

#define kQuitBtnColor UIColorFromRGB(0xc6403b)
#define kQuitBtnHighlighedColor UIColorFromRGB(0xc0303b)

@implementation JCHATGroupDetailFooterReusableView

- (void)awakeFromNib {
  // Initialization code
  _quitGroupBtn.layer.cornerRadius = 4;
  _quitGroupBtn.layer.masksToBounds = YES;
  _quitGroupBtn.backgroundColor = [UIColor redColor];
  [_quitGroupBtn setBackgroundImage:[ViewUtil colorImage:[UIColor blackColor] frame:_quitGroupBtn.frame] forState:UIControlStateHighlighted];
}

- (void)setDataWithGroupName:(NSString *)groupName {
  _footerTittle.hidden = NO;
  _userName.hidden = NO;
  _arrow.hidden = NO;
  _quitGroupBtn.hidden = YES;
  
  _footerTittle.text = @"群聊名称";
  _userName.text = groupName;
  
}

- (void)layoutToClearChatRecord {
  _footerTittle.hidden = NO;
  _userName.hidden = NO;
  _arrow.hidden = NO;
  _quitGroupBtn.hidden = YES;
  
  _footerTittle.text = @"清空聊天记录";
  _userName.text = @"";
}

- (void)layoutToQuitGroup {
  _footerTittle.hidden = YES;
  _userName.hidden = YES;
  _arrow.hidden = YES;
  _quitGroupBtn.hidden = NO;
}

- (IBAction)clickToQuitGroup:(id)sender {// rename
  [_delegate quitGroup];
}
@end
