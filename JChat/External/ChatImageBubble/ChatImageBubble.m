//
//  ChatImageBubble.m
//  ChatImageBubbleDemo
//
//  Created by HuminiOS on 15/10/28.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "ChatImageBubble.h"

@implementation ChatImageBubble

- (id)init {
  self = [super init];
  if (self != nil) {
    if (self.maskBubbleLayer == nil) {
      self.maskBubbleLayer = [ChatBubbleLayer layer];
    }
    self.layer.mask = self.maskBubbleLayer;
    self.backgroundColor = [UIColor yellowColor];
  }
  return self;
}
- (void)setBubbleSide:(BOOL)isReci {
  self.maskBubbleLayer.isReceivedBubble = isReci;
}
- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  //  self.maskBubbleLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
  self.maskBubbleLayer.frame = self.bounds;
  [CATransaction begin];
  self.maskBubbleLayer.duration = 0; // CALayer 的隐式动画的duration 为0.25秒， 可以通过事务在主动修改
  [self.maskBubbleLayer setNeedsDisplay];
  [CATransaction commit];
}
@end
