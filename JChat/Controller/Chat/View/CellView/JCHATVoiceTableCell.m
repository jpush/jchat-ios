//
//  JCHATVoiceTableCell.m
//  JChat
//
//  Created by HuminiOS on 15/8/2.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATVoiceTableCell.h"
#import "JChatConstants.h"
#import "MBProgressHUD+Add.h"
#import "Masonry.h"

#define headHeight 46
#define gapWidth 5
#define chatBgViewHeight 50

@implementation JCHATVoiceTableCell {
  float chatBgViewWidth;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  self.backgroundColor = [UIColor redColor];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    chatBgViewWidth = 60;
    [self setBackgroundColor:[UIColor clearColor]];

    self.voiceTimeLable = [UILabel new];
    self.voiceBgView = [UIImageView new];
    [self.voiceBgView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.voiceBgView];
    
    self.headView = [UIImageView new];
    [self.headView setImage:[UIImage imageNamed:@"headDefalt_34.png"]];
    self.headView.layer.cornerRadius = 23;
    [self.headView.layer setMasksToBounds:YES];
    [self addSubview:self.headView];
    
    self.voiceImgView = [UIImageView new];
    [self.voiceImgView setBackgroundColor:[UIColor clearColor]];
    [self.voiceImgView setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"]];
    [self addSubview:self.voiceTimeLable];
    
    [self.voiceTimeLable setBackgroundColor:[UIColor clearColor]];
    [self.voiceTimeLable setTextColor:UIColorFromRGB(0x636363)];
    self.voiceTimeLable.textAlignment = NSTextAlignmentLeft;
    self.voiceTimeLable.font = [UIFont systemFontOfSize:18];
    self.voiceTimeLable.text = @"60''";
    [self.voiceBgView addSubview:self.voiceImgView];
    
    UIImage *img = nil;
    img = [UIImage imageNamed:@"mychatBg"];
    UIImage *newImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];
    [self.voiceBgView setImage:newImg];
    self.voiceBgView.layer.cornerRadius = 6;
    [self.voiceBgView.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVoice:)];
    [self.voiceBgView addGestureRecognizer:gesture];
    [self.voiceBgView setUserInteractionEnabled:YES];
    self.playing = NO;
    self.stateView = [[UIActivityIndicatorView alloc] init];
    [self addSubview:self.stateView];
    [self.stateView setBackgroundColor:[UIColor clearColor]];
    [self.stateView setHidden:NO];
    self.stateView.hidesWhenStopped = YES;
    
//    self.sendFailView = [[UIImageView alloc] init];
    self.sendFailView = [UIImageView new];
    
    [self.sendFailView setImage:[UIImage imageNamed:@"fail05"]];
    [self.sendFailView setUserInteractionEnabled:YES];
    [self.sendFailView setBackgroundColor:[UIColor clearColor]];
    [self.sendFailView setHidden:YES];
    [self addSubview:self.sendFailView];
    
//    self.readView = [[UIImageView alloc] init];
    self.readView = [UIImageView new];
    [self.readView setBackgroundColor:[UIColor redColor]];
    self.readView.layer.cornerRadius = 4;
    [self addSubview:self.readView];
    self.continuePlayer = NO;
    [self headAddGesture];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(sendMessageResponse:)
//                                                 name:JMSGNotification_SendMessageResult object:nil];
  }
  return self;
}

- (void)setupMessageDelegateWithConversation:(JMSGConversation *)converstion {
  [JMessage addDelegate:self withConversation:converstion];
}

#pragma mark --发送消息响应
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
  DDLogDebug(@"Event - sendMessageResponse");

  JPIMMAINTHEAD(^{
    if (message.contentType != kJMSGContentTypeVoice) {
      return;
    }
    [self.stateView stopAnimating];
    if (![message.msgId isEqualToString:_message.msgId]) {
      DDLogWarn(@"The response msgId is not for this cell");
      return;
    }
    
    if (error == nil) {
      DDLogVerbose(@"VoiceMessage response - %@", message);
      self.model.messageStatus = kJMSGMessageStatusSendSucceed;
      [self.sendFailView setHidden:YES];
      [self.stateView stopAnimating];
      [self.stateView setHidden:YES];
    } else {
      DDLogDebug(@"VoiceMessage response error - %@", error);
      self.model.messageStatus = kJMSGMessageStatusSendFailed;
      [self.sendFailView setHidden:NO];
      [self.stateView stopAnimating];
      [self.stateView setHidden:YES];
      _voiceFailMessage = message;
    }
    
    [self updateFrame];
  });
}

#pragma mark -- 语音时长算法
- (float)getLengthWithDuration:(NSInteger)duration {
  if (duration <= 2) {
    chatBgViewWidth = 60;
  } else if (duration >2 && duration <=20) {
    chatBgViewWidth = 60 + 4 * duration;
  }else if (duration > 20 && duration < 30){
    chatBgViewWidth = 130 + 2 * duration;
  }else if (duration >30  && duration < 60) {
    chatBgViewWidth = 160 + 1.3 * duration;
  }else {
    chatBgViewWidth = 300;
  }
  
  return chatBgViewWidth;
}

- (void)updateTimeLable:(UILabel *)lable {
  CGSize thelableSize;
  if([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
    thelableSize = [lable.text sizeWithFont:[UIFont systemFontOfSize:18]];
  }else {
    thelableSize = [lable.text  sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
  }
  [lable mas_updateConstraints:^(MASConstraintMaker *make) {
//    make.size.mas_equalTo(thelableSize);
    make.width.mas_equalTo(thelableSize.width+5);
  }];
  
}

- (void)headAddGesture {
  [self.headView setUserInteractionEnabled:YES];
  [self.voiceBgView setUserInteractionEnabled:YES];
  [self.voiceImgView setUserInteractionEnabled:YES];
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPersonInfoCtlClick)];
  [self.headView addGestureRecognizer:gesture];
  
  UITapGestureRecognizer *messageFailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSendMessage)];
  [self.sendFailView addGestureRecognizer:messageFailGesture];
}

- (void)reSendMessage {
  DDLogDebug(@"Action - reSendMessage");
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"是否重新发送消息"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
  DDLogDebug(@"Action - alertView");
  if (buttonIndex == 1) {
    [self.sendFailView setHidden:YES];
    [self.stateView setHidden:NO];
    [self.stateView startAnimating];
    self.model.messageStatus = kJMSGMessageStatusSending;
    if (!self.voiceFailMessage) {
      self.voiceFailMessage = [self.conversation messageWithMessageId:self.model.messageId];
      if (self.voiceFailMessage != nil) {
        self.message = self.voiceFailMessage;
        [JMSGMessage sendMessage:self.voiceFailMessage];
      }else {
        DDLogDebug(@"Action get messageWithMessageid fail");
      }

    } else {
      [JMSGMessage sendMessage:self.voiceFailMessage];
    }
  }
}

- (void)pushPersonInfoCtlClick {
  if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeadView:)]) {
    [self.delegate selectHeadView:self.model];
  }
}

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  if (!self) {
    return nil;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  
}

- (void)changeVoiceImage {
  if (!self.playing) {
    return;
  }
  NSString *voiceImagePreStr = @"";
  if (self.model.isMyMessage) {
    voiceImagePreStr = @"SenderVoiceNodePlaying00";
  } else {
    voiceImagePreStr = @"ReceiverVoiceNodePlaying00";
  }
  self.voiceImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%zd", voiceImagePreStr, self.index % 4]];
  if (self.playing) {
    self.index++;
    [self performSelector:@selector(changeVoiceImage) withObject:nil afterDelay:0.25];
  }
}

- (void)setCellData:(JCHATChatModel *)model
           delegate:(id)delegate
            message:(JMSGMessage *)message
          indexPath:(NSIndexPath *)indexPath {
  self.conversation = model.conversation;
  self.headViewFlag = model.fromUser.username;
  self.delegate = delegate;
  [self.stateView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  self.model = model;

  [self.imageView setImage:[UIImage imageNamed:@"headDefalt_34"]];
//  typeof(self) __weak weakSelf = self;
//  JMSGUser *tmpUser = _message.fromUser;
//  [tmpUser thumbAvatarData:^(id resultObject, NSError *error) {
//    NSLog(@"huangmin dashuai in");
//    if (error == nil) {
//      JPIMMAINTHEAD(^{
//        if (resultObject !=nil) {
//          [weakSelf.headView setImage:[UIImage imageWithData:resultObject]];
//        }
//      });
//    }else {
//      DDLogDebug(@"Action -- get thumbavatar fail");
//    }
//  }];
  _message = model.message;
  if (_model.avatar == nil) {
    [_model.fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
      if (error == nil) {
        JPIMMAINTHEAD(^{
          if ([objectId isEqualToString:self.headViewFlag]) {
            [self.headView setImage:[UIImage imageWithData:data]];
          } else {
            DDLogDebug(@"该头像是异步乱序的头像");
          }
        });
      } else {
        DDLogDebug(@"Action -- get thumbavatar fail");
      }
    }];
  } else {
    [self.headView setImage:[UIImage imageWithData:_model.avatar]];
  }
  
  self.indexPath = indexPath;
  if ([model.voiceTime rangeOfString:@"''"].location != NSNotFound) {
    self.voiceTimeLable.text = model.voiceTime;
  } else {
    self.voiceTimeLable.text = [model.voiceTime stringByAppendingString:@"''"];
  }
  self.delegate = (id) delegate;
  [self.voiceBgView setImage:[UIImage imageNamed:@""]];
  if (self.model.isMyMessage) {
    [self.voiceImgView setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"]];
  } else {
    [self.voiceImgView setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying"]];
  }
  if (!_model.sendFlag) {
    _model.sendFlag = YES;
    // 展示这一条消息时检查状态，从而发送
    [self sendVoiceMessage];
  }
  [self getLengthWithDuration:[model.voiceTime integerValue]];
  [self updateFrame];
}

- (void)tapVoice:(UIGestureRecognizer *)gesture {
  [self playVoice];
}

#pragma mark --连续播放语音
- (void)playVoice {
  DDLogDebug(@"Action - playVoice");
  __block NSString *status = nil;
  if (self.model.messageStatus == kJMSGMessageStatusReceiveDownloadFailed) {
    // 这条消息之前的状态是下载失败，则先重新下载
    self.message = [self.conversation messageWithMessageId:self.model.messageId];

    [((JMSGVoiceContent *)self.message.content) voiceData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error == nil) {
      
              if (data != nil) {
                self.model.mediaData = data;
                self.model.messageStatus = kJMSGMessageStatusReceiveSucceed;
                status =  @"下载语音成功";
                DDLogDebug(@"%@ -%@", status, [(NSURL *) data path]);
                [self playVoice];
                [MBProgressHUD showMessage:status view:self];
              }
            }else {
              DDLogDebug(@"Action  voiceData");
              status = @"获取消息失败。。。";
              [MBProgressHUD showMessage:status view:self];
            }
      
    }];
    return;
  }
  
  self.continuePlayer = NO;
  if ([self.delegate respondsToSelector:@selector(getContinuePlay:indexPath:)]) {
    [self.delegate getContinuePlay:self indexPath:self.indexPath];
  }
  [self.readView setHidden:YES];
  self.model.readState = YES;
  self.index = 0;
  if (!self.playing) {
    if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
      [[JCHATAudioPlayerHelper shareInstance] stopAudio];
      [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
    }
    [[JCHATAudioPlayerHelper shareInstance] setDelegate:(id) self];
    [[JCHATAudioPlayerHelper shareInstance] managerAudioWithFileName:self.model.voicePath toPlay:YES];
    self.playing = YES;
  } else {
    self.playing = NO;
    self.continuePlayer = NO;
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
  }
  [self changeVoiceImage];
}

#pragma mark ---播放完成后
- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
  [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
  self.playing = NO;
  self.index = 0;
  if (self.model.isMyMessage) {
    [self.voiceImgView setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying.png"]];
  } else {
    [self.voiceImgView setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying.png"]];
  }
  if (self.continuePlayer) {
    self.continuePlayer = NO;
    if ([self.delegate respondsToSelector:@selector(successionalPlayVoice:indexPath:)]) {
      [self performSelector:@selector(prepare) withObject:nil afterDelay:0.5];
    }
  }
}

#pragma mark --
- (void)prepare {
  [self.delegate successionalPlayVoice:self indexPath:self.indexPath];
}

#pragma mark-上传语音
- (void)sendVoiceMessage {
  DDLogDebug(@"Action - sendVoiceMessage");
  [self.stateView setHidden:NO];
  [self.stateView startAnimating];
  self.model.messageStatus = kJMSGMessageStatusSending;
  DDLogVerbose(@"The voiceMessage - %@", _message);
  [JMSGMessage sendMessage:_message];
}

- (void)layoutSubviews {
  [self updateFrame];
}

- (void)updateFrame {
  /*信息读取状态显示*/
  if (self.model.readState) {
    [self.readView setHidden:YES];
  } else {
    [self.readView setHidden:NO];
  }
  if (self.model.messageStatus == kJMSGMessageStatusSending) {
    [self.stateView setHidden:NO];
    [self.sendFailView setHidden:YES];
  } else if (self.model.messageStatus == kJMSGMessageStatusSending) {
    [self.stateView setHidden:YES];
    [self.sendFailView setHidden:YES];
  } else if (self.model.messageStatus == kJMSGMessageStatusSendFailed) {
    [self.stateView setHidden:YES];
    [self.sendFailView setHidden:NO];
  } else {
    [self.stateView setHidden:YES];
    [self.sendFailView setHidden:YES];
  }
  
  [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.voiceBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.voiceImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.voiceTimeLable mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.sendFailView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.readView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  
  UIImage *img = nil;
  if (self.model.isMyMessage) {//wo
    img = [UIImage imageNamed:@"mychatBg"];
//    [self.headView setFrame:CGRectMake(kApplicationWidth - headHeight - gapWidth, 0, headHeight, headHeight)];//头像位置
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(headHeight, headHeight));
      make.top.mas_equalTo(0);
      make.right.mas_equalTo(self).with.offset(-gapWidth);
    }];
//    [self.voiceBgView setFrame:CGRectMake(kApplicationWidth - chatBgViewWidth - (headHeight + 2 * gapWidth), 0, chatBgViewWidth, chatBgViewHeight)];
    [self.voiceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(chatBgViewWidth, chatBgViewHeight));
      make.right.mas_equalTo(self.headView.mas_left).with.offset(-gapWidth);
      make.top.mas_equalTo(0);
    }];
////    [self.voiceImgView setFrame:CGRectMake(20, 15, 20, 20)];
    [self.voiceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(9, 16));
      make.right.mas_equalTo(self.voiceBgView.mas_right).with.offset(-15);
      make.centerY.mas_equalTo(self.voiceBgView);
    }];
////    [self.voiceTimeLable setFrame:CGRectMake(self.voiceBgView.frame.origin.x - 50, 10, 40, 30)];
    [self.voiceTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(40, 30));
      make.centerY.mas_equalTo(self.voiceBgView);
      make.right.mas_equalTo(self.voiceBgView.mas_left).with.offset(-10);
    }];
////    [self.stateView setFrame:CGRectMake(self.voiceTimeLable.frame.origin.x - 40, 10, 30, 30)];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(30, 30));
      make.right.mas_equalTo(self.voiceTimeLable.mas_left).with.offset(-10);
    }];
////    [self.sendFailView setFrame:CGRectMake(self.voiceTimeLable.frame.origin.x - 20, (50 - 15) / 2, 17, 15)];
    [self.sendFailView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(15, 17));
      make.centerY.mas_equalTo(self.voiceBgView);
      make.right.mas_equalTo(self.voiceTimeLable.mas_left).with.offset(-1);
    }];
////    [self.readView setFrame:CGRectMake(self.voiceBgView.frame.origin.x - 10, 5, 8, 8)];
    [self.readView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(8, 8));
      make.right.mas_equalTo(self.voiceBgView.mas_left).with.offset(-10);
      make.top.mas_equalTo(self).with.offset(5);
    }];
  } else {
    img = [UIImage imageNamed:@"otherChatBg"];
//    [self.headView setFrame:CGRectMake(gapWidth, 0, headHeight, headHeight)];
//    [self.voiceBgView setFrame:CGRectMake(headHeight + 2 * gapWidth, 0, chatBgViewWidth, chatBgViewHeight)];
//    [self.voiceImgView setFrame:CGRectMake(20, 15, 20, 20)];
//    [self.voiceTimeLable setFrame:CGRectMake(self.voiceBgView.frame.origin.x + chatBgViewWidth + gapWidth + 10, 10, 40, 30)];
//    [self.stateView setFrame:CGRectMake(self.voiceTimeLable.frame.origin.x + self.voiceTimeLable.frame.size.width + 5, 10, 30, 30)];
//    [self.sendFailView setFrame:CGRectMake(self.voiceTimeLable.frame.origin.x + self.voiceTimeLable.frame.size.width + 5, (50 - 15) / 2, 17, 15)];
//    [self.readView setFrame:CGRectMake(self.voiceBgView.frame.origin.x + self.voiceBgView.frame.size.width + 10, 5, 8, 8)];
    
    //    [self.headView setFrame:CGRectMake(kApplicationWidth - headHeight - gapWidth, 0, headHeight, headHeight)];//头像位置
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(headHeight, headHeight));
      make.top.mas_equalTo(0);
      make.left.mas_equalTo(self).with.offset(gapWidth);
    }];
    //    [self.voiceBgView setFrame:CGRectMake(kApplicationWidth - chatBgViewWidth - (headHeight + 2 * gapWidth), 0, chatBgViewWidth, chatBgViewHeight)];
    [self.voiceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(chatBgViewWidth, chatBgViewHeight));
      make.left.mas_equalTo(self.headView.mas_right).with.offset(gapWidth);
      make.top.mas_equalTo(0);
    }];
    ////    [self.voiceImgView setFrame:CGRectMake(20, 15, 20, 20)];
    [self.voiceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(9, 16));
      make.left.mas_equalTo(self.voiceBgView.mas_left).with.offset(15);
      make.centerY.mas_equalTo(self.voiceBgView);
    }];
    ////    [self.voiceTimeLable setFrame:CGRectMake(self.voiceBgView.frame.origin.x - 50, 10, 40, 30)];
    [self.voiceTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(40, 30));
      make.centerY.mas_equalTo(self.voiceBgView);
      make.left.mas_equalTo(self.voiceBgView.mas_right).with.offset(10);
    }];
    ////    [self.stateView setFrame:CGRectMake(self.voiceTimeLable.frame.origin.x - 40, 10, 30, 30)];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(30, 30));
      make.left.mas_equalTo(self.voiceTimeLable.mas_right).with.offset(10);
    }];
    ////    [self.sendFailView setFrame:CGRectMake(self.voiceTimeLable.frame.origin.x - 20, (50 - 15) / 2, 17, 15)];
    [self.sendFailView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(15, 17));
      make.centerY.mas_equalTo(self.voiceBgView);
      make.left.mas_equalTo(self.voiceTimeLable.mas_right).with.offset(1);
    }];
    ////    [self.readView setFrame:CGRectMake(self.voiceBgView.frame.origin.x - 10, 5, 8, 8)];
    [self.readView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(8, 8));
      make.left.mas_equalTo(self.voiceBgView.mas_right).with.offset(10);
      make.top.mas_equalTo(self).with.offset(5);
    }];
  }
  [self updateTimeLable:self.voiceTimeLable];
  UIImage *newImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];
  [self.voiceBgView setImage:newImg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
  
}

- (void)getContinuePlay:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
  
}

- (void)selectHeadView:(JCHATChatModel *)model {
  
}

- (void)dealloc {
  [JMessage removeDelegate:self];
}
@end
