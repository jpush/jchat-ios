//
//  JCHATMessageTableViewCell.h
//  JChat
//
//  Created by HuminiOS on 15/7/13.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//重构聊天界面代码用

// TODO:
#import <UIKit/UIKit.h>
#import "JCHATMessageContentView.h"
#import "JCHATAudioPlayerHelper.h"
#import "JCHATChatModel.h"

@protocol playVoiceDelegate <NSObject>
@optional
- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)getContinuePlay:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)selectHeadView:(JCHATChatModel *)model;

- (void)setMessageIDWithMessage:(JMSGMessage *)message
                      chatModel:(JCHATChatModel * __strong *)chatModel
                          index:(NSInteger)index;
@end

@protocol PictureDelegate <NSObject>
@optional
- (void)tapPicture :(NSIndexPath *)index
           tapView :(UIImageView *)tapView
      tableViewCell:(UITableViewCell *)tableViewCell;

- (void)selectHeadView:(JCHATChatModel *)model;
@end


@interface JCHATMessageTableViewCell : UITableViewCell <XHAudioPlayerHelperDelegate,
playVoiceDelegate,JMSGMessageDelegate>

@property(strong,nonatomic)UIImageView *headView;
@property(strong,nonatomic)JCHATMessageContentView *messageContent;
@property(strong,nonatomic)JCHATChatModel *model;
@property(weak, nonatomic)JMSGConversation *conversation;
@property(weak, nonatomic) id delegate;

@property (strong, nonatomic) UIImageView *sendFailView;
@property (strong, nonatomic) UIActivityIndicatorView *circleView;

//image
@property (strong, nonatomic) UILabel *percentLabel;

//voice
@property(assign, nonatomic)BOOL continuePlayer;
@property(assign, nonatomic)BOOL isPlaying;
@property(assign, nonatomic)NSInteger index;//voice 语音图片的当前显示
@property(strong, nonatomic)NSIndexPath *indexPath;
@property(strong, nonatomic)UIView *readView;
@property(strong, nonatomic)UILabel *voiceTimeLabel;

- (void)playVoice;
- (void)setCellData:(JCHATChatModel *)model
           delegate:(id <playVoiceDelegate>)delegate
          indexPath:(NSIndexPath *)indexPath
;
- (void)layoutAllView;
@end
