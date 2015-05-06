//
//  JPIMVoiceTableViewCell.m
//  JPush IM
//
//  Created by Apple on 15/1/4.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JPIMVoiceTableViewCell.h"
#import "JPIMCommon.h"
#import "ChatModel.h"
#import "Common.h"
#import "PlayerManager.h"


#define headHeight 51
@implementation JPIMVoiceTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    self.voiceTimeLable =[[UILabel alloc] init];
    [self.voiceBgView setBackgroundColor:[UIColor redColor]];

    self.voiceImgView =[[UIImageView alloc] init];
    [self.voiceImgView setBackgroundColor:[UIColor clearColor]];
    [self.voiceImgView setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"]];
    [self.voiceBgView addSubview:self.voiceTimeLable];
    [self.voiceImgView setFrame:CGRectMake(30, 5, 20, 30)];
    
    [self.voiceTimeLable setBackgroundColor:[UIColor clearColor]];
    [self.voiceTimeLable setFrame:CGRectMake(5, 5, 20, 30)];
    self.voiceTimeLable.text=@"60''";
    [self.voiceBgView addSubview:self.voiceImgView];
    
    UIImage *img=nil;
    img =[UIImage imageNamed:@"chattwo.png"];
    UIImage *newImg =[img resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 15, 20)];
    [self.voiceBgView setImage:newImg];
    [self.voiceBgView setFrame:CGRectMake(kApplicationWidth-70, 0, 100, 60)];
    self.voiceBgView.layer.cornerRadius=6;
    [self.voiceBgView.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVoice:)];
    [self.voiceBgView addGestureRecognizer:gesture];
    [self.voiceBgView setUserInteractionEnabled:YES];
    self.playing=NO;
    NSLog(@"awakeFromNib");
//    [self updateFrame];

}




-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    NSLog(@"initWithCoder");
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    NSLog(@"drawRect");
}


-(void)changeVoiceImage{
    if (!self.playing) {
        return;
    }
    NSString *voiceImagePreStr = @"";
    if (self.model.who) {
        voiceImagePreStr = @"SenderVoiceNodePlaying00";
    }else{
        voiceImagePreStr = @"ReceiverVoiceNodePlaying00";
    }
    self.voiceImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld.png",voiceImagePreStr,self.index%4]];
    if (self.playing) {
        self.index ++;
        [self performSelector:@selector(changeVoiceImage) withObject:nil afterDelay:0.25];
    }
}

#pragma mark - 播放原wav
- (void)playVoice:(NSString *)filepath
{
    if ( ! self.playing) {
        [[PlayerManager sharedManager] stopPlaying];
        [PlayerManager sharedManager].delegate = nil;
        self.playing = YES;
        [[PlayerManager sharedManager] playAudioWithFileName:filepath delegate:self];
    }
    else {
        self.playing = NO;
        [[PlayerManager sharedManager] stopPlaying];
        if (![filepath isEqualToString:[PlayerManager sharedManager].currentPath]) {
            [PlayerManager sharedManager].delegate = nil;
            self.playing = YES;
            [[PlayerManager sharedManager] playAudioWithFileName:filepath delegate:self];
        }
    }
}

-(void)setCellData :(ChatModel *)model
{
    self.voicePath=model.chatContent;
    self.model=model;
    self.voiceTimeLable.text=model.voiceTime;
    [self.voiceBgView setImage:[UIImage imageNamed:@""]];
    if (self.model.who) {
        [self.voiceImgView setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"]];
        
    }else{
        [self.voiceImgView setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying.png"]];
    }
}

-(void)tapVoice:(UIGestureRecognizer *)gesture
{
    self.index=0;
    [self playVoice:self.voicePath];
    [self changeVoiceImage];
}

- (void)playingStoped
{
    self.playing=NO;
    self.index=0;
    if (self.model.who) {
        [self.voiceImgView setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"]];

    }else{
        [self.voiceImgView setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying.png"]];

    }
}

-(void)stopVoice
{
    self.playing=NO;
}

-(void)layoutSubviews
{
    [self updateFrame];
}

-(void)updateFrame
{
    UIImage *img=nil;
    if (self.model.who) {
        img =[UIImage imageNamed:@"chattwo.png"];
        [self.headView setFrame:CGRectMake(kApplicationWidth-headHeight, 0, headHeight, headHeight)];
        [self.voiceImgView setFrame:CGRectMake(50, 20, 20, 20)];
        [self.voiceTimeLable setFrame:CGRectMake(15, 15, 30, 30)];
        [self.voiceBgView setFrame:CGRectMake(kApplicationWidth-110-headHeight+5, 0, 100, 60)];
    }else{
        img =[UIImage imageNamed:@"chatone.png"];
        [self.headView setFrame:CGRectMake(0, 0, headHeight, headHeight)];
        [self.voiceImgView setFrame:CGRectMake(50, 20, 20, 20)];
        [self.voiceTimeLable setFrame:CGRectMake(15, 15, 30, 30)];
        [self.voiceBgView setFrame:CGRectMake(headHeight+5, 0, 100, 60)];
    }
    UIImage *newImg =[img resizableImageWithCapInsets:UIEdgeInsetsMake(15, 20, 15, 20)];
    [self.voiceBgView setImage:newImg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
