//
//  JCHATRecordAnimationView.m
//  PALifeInsurance
//
//  Created by da zhan on 13-7-27.
//  Copyright (c) 2013年 pingan. All rights reserved.
//

#import "JCHATRecordAnimationView.h"

@implementation JCHATRecordAnimationView


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.hidden=YES;
    self.layer.cornerRadius=3.0;
    self.clipsToBounds = YES;
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backView.image = [[UIImage imageNamed:@"chat_voice"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self addSubview:backView];
    
    phoneIV=[[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 72, 99)];
    phoneIV.image=[UIImage imageNamed:@"RecordingBkg"];
    [self addSubview:phoneIV];
    
    cancelIV = [[UIImageView alloc] initWithFrame:CGRectMake(35, 10, 72, 99)];
    cancelIV.image = [UIImage imageNamed:@"voice_delete"];
    cancelIV.hidden = YES;
    [self addSubview:cancelIV];
    
    signalIV=[[UIImageView alloc]initWithFrame:CGRectMake(96,40, 18, 62)];
    signalIV.image=[UIImage imageNamed:@"RecordingSignal001"];
    [self addSubview:signalIV];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, 140, 25)];
    tipLabel.clipsToBounds = YES;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"上滑取消语音发送";
    tipLabel.font = [UIFont boldSystemFontOfSize:16];
    tipLabel.backgroundColor = [UIColor colorWithRed:193.0/255 green:98.0/255 blue:60.0/255 alpha:1];
    [self addSubview:tipLabel];
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
//切换录音和取消界面 YES：显示录音 NO：显示取消
- (void)changeRecordView:(BOOL)flag{
  if (flag) {
    phoneIV.hidden = NO;
    cancelIV.hidden = YES;
    signalIV.hidden = NO;
    tipLabel.text = @"上滑取消语音发送";
  } else {
    phoneIV.hidden = YES;
    cancelIV.hidden = NO;
    signalIV.hidden = YES;
    tipLabel.text = @"松开取消语音发送";
  }
}

- (void)changeanimation:(double)lowPassResults;
{
  //     int index=arc4random()%8;
  //
  //     signalIV.image=[UIImage imageNamed:[NSString stringWithFormat:@"RecordingSignal00%d",index]];
  if (0<lowPassResults<=0.06)
  {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal000.png"]];
    
  }
  else if (0.06<lowPassResults<=0.13) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal000.png"]];
    
  }
  else if (0.13<lowPassResults<=0.20) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal001"]];
    
  }
  else if (0.20<lowPassResults<=0.27) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal001"]];
    
  }
  else if (0.27<lowPassResults<=0.34) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal002.png"]];
    
  }
  else if (0.34<lowPassResults<=0.41) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal003.png"]];
    
  }
  else if (0.41<lowPassResults<=0.48) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal004.png"]];
    
  }
  else if (0.48<lowPassResults<=0.55) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal005.png"]];
    
  }
  else if (0.55<lowPassResults<=0.62) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal005.png"]];
    
  }
  else if (0.62<lowPassResults<=0.69) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal006.png"]];
    
  }
  else if (0.69<lowPassResults<=0.76) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal007.png"]];
    
  }
  else if (0.76<lowPassResults<=0.83) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal007.png"]];
    
  }
  else if (0.83<lowPassResults<=0.9) {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal008.png"]];
    
  }
  else {
    [signalIV setImage:[UIImage imageNamed:@"RecordingSignal000.png"]];
    
  }
}

- (void)change{
  
}

- (void)startAnimation
{
  tipLabel.text = @"上滑取消语音发送";
  self.hidden=NO;
  phoneIV.hidden = NO;
  cancelIV.hidden = YES;
  signalIV.hidden = NO;
}

- (void)stopAnimation{
  self.hidden=YES;
}

@end
