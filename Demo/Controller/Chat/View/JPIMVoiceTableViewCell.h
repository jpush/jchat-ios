//
//  JPIMVoiceTableViewCell.h
//  JPush IM
//
//  Created by Apple on 15/1/4.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
#import "PlayerManager.h"
@interface JPIMVoiceTableViewCell : UITableViewCell<PlayingDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *voiceBgView;
@property (strong, nonatomic)  UILabel *voiceTimeLable;
@property (strong, nonatomic)  UIImageView *voiceImgView;
@property (assign, nonatomic)  BOOL playing;
@property (assign, nonatomic)  NSInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (strong, nonatomic)  ChatModel *model;

@property (copy, nonatomic)  NSString *voicePath;
-(void)setCellData :(ChatModel *)model;
@end
