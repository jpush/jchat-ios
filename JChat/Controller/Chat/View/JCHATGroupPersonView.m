//
//  GroupPersonView.m
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATGroupPersonView.h"

@implementation JCHATGroupPersonView

- (void)awakeFromNib {
  [self setFrame:CGRectMake(0, 0, 56, 75)];
  [self bringSubviewToFront:self.deletePersonBtn];
  self.deletePersonBtn.layer.cornerRadius = 10;
  [self.headViewBtn setFrame:CGRectMake(0, 0, 46, 46)];
  [self.headViewBtn.layer setMasksToBounds:YES];
  [self.headViewBtn.layer setCornerRadius:23];
  [self.headViewBtn setBackgroundColor:[UIColor redColor]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)headViewBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupPersonBtnClick:)]) {
        [self.delegate groupPersonBtnClick:self];
    }
}

- (IBAction)deleteBtnClick:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(groupPersonBtnClick:)]) {
    [self.delegate groupPersonBtnClick:self];
  }
}
@end
