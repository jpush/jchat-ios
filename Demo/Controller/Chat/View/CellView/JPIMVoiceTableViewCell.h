//
//  JPIMVoiceTableViewCell.h
//  JPush IM
//
//  Created by Apple on 15/1/4.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
#import "XHAudioPlayerHelper.h"
#import <JMessage/JMessage.h>

@protocol playVoiceDelegate <NSObject>
-(void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
-(void)getContinuePlay:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
-(void)selectHeadView:(ChatModel *)model;
@end

@interface JPIMVoiceTableViewCell : UITableViewCell<XHAudioPlayerHelperDelegate,playVoiceDelegate>
@property (strong, nonatomic)    UIImageView *voiceBgView;
@property (strong, nonatomic)  UILabel *voiceTimeLable;
@property (strong, nonatomic)  UIImageView *voiceImgView;
@property (assign, nonatomic)  BOOL playing;
@property (assign, nonatomic)  NSInteger index;
@property (strong, nonatomic)    UIImageView *headView;
@property (strong, nonatomic)  ChatModel *model;
@property (strong, nonatomic)  UIActivityIndicatorView *stateView;
@property (strong, nonatomic)  UIImageView *sendFailView;
@property (strong, nonatomic)  UIImageView *readView;
@property (strong, nonatomic)  JMSGVoiceMessage *voiceFailMessage;
@property (strong, nonatomic)  JMSGConversation *conversation;
@property (strong, nonatomic)  NSIndexPath *indexPath;
@property (assign, nonatomic)  BOOL continuePlayer;
@property (assign, nonatomic)  id<playVoiceDelegate> delegate;
@property (strong, nonatomic)  JMSGVoiceMessage *message;

-(void)playerVoice;
-(void)setCellData :(ChatModel *)model delegate :(id<playVoiceDelegate>)delegate indexPath :(NSIndexPath *)indexPath;
-(void)uploadVoice;

@end
