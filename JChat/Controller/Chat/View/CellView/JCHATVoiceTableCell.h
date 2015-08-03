//
//  JCHATVoiceTableCell.h
//  JChat
//
//  Created by HuminiOS on 15/8/2.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATChatModel.h"
#import "JCHATAudioPlayerHelper.h"
#import <JMessage/JMessage.h>

@protocol playVoiceDelegate <NSObject>
- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)getContinuePlay:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)selectHeadView:(JCHATChatModel *)model;

- (void)setMessageIDWithMessage:(JMSGMessage *)message
                      chatModel:(JCHATChatModel * __strong *)chatModel
                          index:(NSInteger)index;


@end

@interface JCHATVoiceTableCell : UITableViewCell<XHAudioPlayerHelperDelegate,
playVoiceDelegate>

@property(strong, nonatomic) UIImageView *voiceBgView;
@property(strong, nonatomic) UILabel *voiceTimeLable;
@property(strong, nonatomic) UIImageView *voiceImgView;
@property(assign, nonatomic) BOOL playing;
@property(assign, nonatomic) NSInteger index;
@property(strong, nonatomic) UIImageView *headView;
@property(strong, nonatomic) JCHATChatModel *model;
@property(strong, nonatomic) UIActivityIndicatorView *stateView;
@property(strong, nonatomic) UIImageView *sendFailView;
@property(strong, nonatomic) UIImageView *readView;
@property(strong, nonatomic) JMSGVoiceMessage *voiceFailMessage;
@property(strong, nonatomic) JMSGConversation *conversation;
@property(strong, nonatomic) NSIndexPath *indexPath;
@property(assign, nonatomic) BOOL continuePlayer;
@property(assign, nonatomic) id <playVoiceDelegate> delegate;
@property(strong, nonatomic) JMSGVoiceMessage *message;

- (void)playVoice;

- (void)setCellData:(JCHATChatModel *)model
           delegate:(id <playVoiceDelegate>)delegate
            message:(JMSGVoiceMessage *)message
          indexPath:(NSIndexPath *)indexPath;

- (void)sendVoiceMessage;




@end
