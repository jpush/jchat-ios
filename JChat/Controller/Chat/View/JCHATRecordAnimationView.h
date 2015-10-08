//
//  JCHATRecordAnimationView.h
//  PALifeInsurance
//
//  Created by da zhan on 13-7-27.
//  Copyright (c) 2013年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATRecordAnimationView : UIView
{
    UIImageView *signalIV;
    NSTimer *animationTimer;
    UILabel *tipLabel;
    UIImageView *phoneIV;
    UIImageView *cancelIV;
}

- (void)startAnimation;
- (void)stopAnimation;
- (void)changeanimation:(double)lowPassResults;
//切换录音和取消界面 YES：显示录音 NO：显示取消
- (void)changeRecordView:(BOOL)flag;
@end
