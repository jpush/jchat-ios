//
//  JCHATMessageTableView.m
//  JChat
//
//  Created by HuminiOS on 15/10/24.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATMessageTableView.h"

@implementation JCHATMessageTableView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)setContentSize:(CGSize)contentSize
{
  if(_isFlashToLoad){// 去除发消息滚动的影响
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
      if (contentSize.height > self.contentSize.height)
      {
        CGPoint offset = self.contentOffset;
        offset.y += (contentSize.height - self.contentSize.height);
        self.contentOffset = offset;
      }
    }
  }
  _isFlashToLoad = NO;
  [super setContentSize:contentSize];
}

- (void)loadMoreMessage {
  _isFlashToLoad = YES;
  [self reloadData];
}
@end
