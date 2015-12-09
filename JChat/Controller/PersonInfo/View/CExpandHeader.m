//
//  CExpandHeader.m
//  CExpandHeaderViewExample
//
//  Created by cml on 14-8-27.
//  Copyright (c) 2014年 Mei_L. All rights reserved.
//

#define CExpandContentOffset @"contentOffset"

#import "CExpandHeader.h"

@implementation CExpandHeader{
  __weak UIScrollView *_scrollView; //scrollView或者其子类
  __weak UIView *_expandView; //背景可以伸展的View
  
  CGFloat _expandHeight;
}

- (void)dealloc{
  if (_scrollView) {
    [_scrollView removeObserver:self forKeyPath:CExpandContentOffset];
    _scrollView = nil;
  }
  _expandView = nil;
}

+ (id)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
  CExpandHeader *expandHeader = [CExpandHeader new];
  [expandHeader expandWithScrollView:scrollView expandView:expandView];
  return expandHeader;
}

- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
  
  
  _expandHeight = CGRectGetHeight(expandView.frame);
  
  _scrollView = scrollView;
  _scrollView.contentInset = UIEdgeInsetsMake(_expandHeight, 0, 0, 0);
  [_scrollView insertSubview:expandView atIndex:0];
  [_scrollView addObserver:self forKeyPath:CExpandContentOffset options:NSKeyValueObservingOptionNew context:nil];
  [_scrollView setContentOffset:CGPointMake(0, -180)];
  
  _expandView = expandView;
  
  //使View可以伸展效果  重要属性
  _expandView.contentMode= UIViewContentModeScaleAspectFill;
  _expandView.clipsToBounds = YES;
  
  [self reSizeView];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
  if (![keyPath isEqualToString:CExpandContentOffset]) {
    return;
  }
  [self scrollViewDidScroll:_scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
  
  CGFloat offsetY = scrollView.contentOffset.y;
  if(offsetY < _expandHeight * -1) {
    CGRect currentFrame = _expandView.frame;
    currentFrame.origin.y = offsetY;
    currentFrame.size.height = -1*offsetY;
    _expandView.frame = currentFrame;
  }
  
}

- (void)reSizeView{
  
  //重置_expandView位置
  [_expandView setFrame:CGRectMake(0, -1*_expandHeight, CGRectGetWidth(_expandView.frame), _expandHeight)];
  
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
