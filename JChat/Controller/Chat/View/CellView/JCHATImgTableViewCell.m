//
//  JCHATImgTableViewCell.m
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATImgTableViewCell.h"
#import "JChatConstants.h"
#import "MBProgressHUD+Add.h"
#import "Masonry.h"
#define headHeight 46

//这段如果使用约束，会出现卡顿显现，先使用绝对布局，后面再研究

@implementation JCHATImgTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headHeight, headHeight)];
//    self.headView = [UIImageView new];
    
    [self.headView setImage:[UIImage imageNamed:@"headDefalt_34.png"]];
    [self addSubview:self.headView];
    self.headView.layer.cornerRadius = 23;
    [self.headView.layer setMasksToBounds:YES];
    
    self.pictureImgView = [[UIImageView alloc]init];
//    self.pictureImgView = [UIImageView new];
    
    [self addSubview:self.pictureImgView];
    self.pictureImgView.layer.cornerRadius=6;
    [self.pictureImgView.layer setMasksToBounds:YES];
    [self setUserInteractionEnabled:YES];
    [self.pictureImgView setUserInteractionEnabled:YES];
    UIImage *img=nil;
    img =[UIImage imageNamed:@"mychatBg"];
    UIImage *newImg =[img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];
    [self.pictureImgView setImage:newImg];
    [self.pictureImgView setBackgroundColor:[UIColor clearColor]];
    
    self.contentImgView  =[[UIImageView alloc] init];
//    self.contentImgView = [UIImageView new];
    
    [self.contentImgView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
    [self.contentImgView addGestureRecognizer:gesture];
    [self.contentImgView setFrame:CGRectMake(5, 5, self.pictureImgView.bounds.size.width-2*8-2, self.pictureImgView.bounds.size.height)];
    
    self.percentLabel =[[UILabel alloc]init];
//    self.percentLabel = [UILabel new];
    
    self.percentLabel.font =[UIFont systemFontOfSize:18];
    self.percentLabel.textAlignment=NSTextAlignmentCenter;
    self.percentLabel.textColor=[UIColor whiteColor];
    [self.percentLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentImgView addSubview:self.percentLabel];
    [self.pictureImgView addSubview:self.contentImgView];
    
    self.circleView =[[UIActivityIndicatorView alloc] init];
//    self.circleView = [UIActivityIndicatorView new];
    
    [self addSubview:self.circleView];
    [self.circleView setBackgroundColor:[UIColor clearColor]];
    [self.circleView setHidden:NO];
    self.circleView.hidesWhenStopped=YES;
    
    self.downLoadIndicatorView =[[UIActivityIndicatorView alloc] init];
//    self.downLoadIndicatorView = [UIActivityIndicatorView new];
    
    [self.contentImgView addSubview:self.downLoadIndicatorView];
    [self.downLoadIndicatorView setBackgroundColor:[UIColor clearColor]];
    [self.downLoadIndicatorView setHidden:NO];
    self.downLoadIndicatorView.hidesWhenStopped=YES;
    
    self.sendFailView =[[UIImageView alloc] init];
//    self.sendFailView = [UIImageView new];
    
    [self.sendFailView setUserInteractionEnabled:YES];
    [self.sendFailView setImage:[UIImage imageNamed:@"fail05"]];
    [self addSubview:self.sendFailView];
    [self headAddGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageResponse:) name:JMSGNotification_SendMessageResult object:nil];
  }
  return self;
}

#pragma mark --发送消息响应
- (void)sendMessageResponse:(NSNotification *)response {
  DDLogDebug(@"Event - sendMessageResponse");

  JPIMMAINTHEAD(^{
        NSDictionary *responseDic = [response userInfo];
        NSError *error = [responseDic objectForKey:JMSGSendMessageError];
        JMSGImageMessage *message = [responseDic objectForKey:JMSGSendMessageObject];
        if (error == nil) {
        }else {
            JPIMLog(@"Sent voiceMessage Response error:%@",error);
        }
        if (![message.messageId isEqualToString:_message.messageId]) {
            return ;
        }
        [self.circleView stopAnimating];
        self.contentImgView.alpha = 1;
        if (error == nil) {
            self.model.messageStatus = kJMSGStatusSendSucceed;
            [self.sendFailView setHidden:YES];
            [self.circleView stopAnimating];
            [self.circleView setHidden:YES];
        }else {
            self.model.messageStatus = kJMSGStatusSendFail;
            [self.sendFailView setHidden:NO];
            [self.circleView stopAnimating];
            [self.circleView setHidden:YES];
            _sendFailImgMessage = [message copy];
        }
        [self updateFrame];
    });
}

- (void)headAddGesture {
    [self.headView setUserInteractionEnabled:YES];
    [self.contentImgView setUserInteractionEnabled:YES];
    [self.pictureImgView setUserInteractionEnabled:YES];

    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPersonInfoCtlClick)];
    [self.headView addGestureRecognizer:gesture];
    UITapGestureRecognizer *messageFailGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSendMessage)];
    [self.sendFailView addGestureRecognizer:messageFailGesture];
}

- (void)reSendMessage {
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:nil message:@"是否重新发送消息"
                                                     delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.sendFailView setHidden:YES];
        [self.circleView setHidden:NO];
        [self.circleView startAnimating];
        self.contentImgView.alpha = 0.5;
        self.model.messageStatus = kJMSGStatusSending;
        __weak typeof(self)weakSelf = self;
        if (!self.sendFailImgMessage) {
            [self.conversation getMessage:self.model.messageId completionHandler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    weakSelf.sendFailImgMessage = resultObject;
                    weakSelf.message = resultObject;
                    weakSelf.sendFailImgMessage.progressCallback=^(float percent){
                      weakSelf.percentLabel.text=[NSString stringWithFormat:@"%d%%",(int)percent*100];
                    };
                    self.sendFailImgMessage.conversationType = self.conversation.chatType;
                    [JMSGMessage sendMessage:self.sendFailImgMessage];
                }else {
                    NSLog(@"获取消息失败!");
                }
            }];
        }else {
            self.sendFailImgMessage.progressCallback=^(float percent){
                weakSelf.percentLabel.text=[NSString stringWithFormat:@"%d%%",(int)percent*100];
            };
            [JMSGMessage sendMessage:self.sendFailImgMessage];
        }
    }
}

- (void)pushPersonInfoCtlClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeadView:)]) {
        [self.delegate selectHeadView:self.model];
    }
}

- (void)setCellData :(UIViewController *)controler chatModel :(JCHATChatModel *)chatModel message:(JMSGImageMessage *)message indexPath :(NSIndexPath *)indexPath
{
    self.conversation = chatModel.conversation;
    self.model = chatModel;
     _message= message;
     [self.circleView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    if (self.model.messageStatus == kJMSGStatusReceiveDownloadFailed) {
        [self.contentImgView setImage:[UIImage imageNamed:@"receiveFail"]];
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:self.model.pictureThumbImgPath]) {
        [self.contentImgView setImage:[UIImage imageWithContentsOfFile:self.model.pictureThumbImgPath]];
    }else if (message.mediaData){
      [self.contentImgView setImage:[UIImage imageWithData:message.mediaData]];
    }else {
      [self.contentImgView setImage:[UIImage imageNamed:@"receiveFail"]];
    }
    self.delegate = (id)controler;
    self.cellIndex = indexPath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:chatModel.avatar]) {
       [self.headView setImage:[UIImage imageWithContentsOfFile:chatModel.avatar]];
    }else {
      [self.headView setImage:[UIImage imageNamed:@"headDefalt_34"]];
    }
    [self updateFrame];
    if (!_model.sendFlag) {
        _model.sendFlag = YES;
      [self sendImageMessage];
    }
}

#pragma mark --上传图片
- (void)sendImageMessage {
  DDLogDebug(@"Action - sendImageMessage");
  [self.circleView setHidden:NO];
  [self.circleView startAnimating];
  self.contentImgView.alpha = 0.5;
  self.model.messageStatus = kJMSGStatusSending;
  self.model.messageId = _message.messageId;
  __weak typeof(self) weakSelf = self;
  _message.progressCallback = ^(float percent) {
    weakSelf.percentLabel.text = [NSString stringWithFormat:@"%d%%", (int) percent * 100];
  };
  if (self.conversation.chatType == kJMSGSingle) {
    _message.conversationType = kJMSGSingle;
  }else {
    _message.conversationType = kJMSGGroup;
  }
  _message.targetId = self.model.targetId;
  _message.mediaData = self.model.mediaData;
  
  DDLogVerbose(@"The imageMessage - %@", _message);
  [JMSGMessage sendMessage:_message];
}

- (void)tapPicture:(UIGestureRecognizer *)gesture
{
    if (self.model.messageStatus == kJMSGStatusReceiveDownloadFailed) {
        NSLog(@"正在下载缩略图");
        JPIMLog(@"Action");
        [self.downLoadIndicatorView setHidden:NO];
        [self.downLoadIndicatorView startAnimating];
        [self.conversation getMessage:self.model.messageId completionHandler:^(id resultObject, NSError *error) {
            if (error == nil) {
                NSProgress *progress = [NSProgress progressWithTotalUnitCount:1000];
                [JMSGMessage downloadThumbImage:resultObject
                                   withProgress:progress
                              completionHandler:^(id resultObject, NSError *error) {
                    JPIMMAINTHEAD(^{
                        [self.downLoadIndicatorView stopAnimating];
                        if (error == nil) {
                            self.model.pictureThumbImgPath = [(NSURL *)resultObject path];
                            self.model.messageStatus = kJMSGStatusReceiveSucceed;
                            [self.contentImgView setImage:[UIImage imageWithContentsOfFile:[(NSURL *)resultObject path]]];
                            [self updateFrame];
                            JPIMLog(@"下载缩略图成功 :%@",[(NSURL *)resultObject path]);
                        }else {
                            JPIMLog(@"下载缩略图失败");
                            [MBProgressHUD showMessage:@"下载缩略图失败" view:self];
                        }
                    });
                }];
            }else {
                JPIMLog(@"下载缩略图获取消息失败。。。");
                JPIMMAINTHEAD(^{
                    [MBProgressHUD showMessage:@"下载缩略图失败" view:self];
                });
            }
        }];
        //下载缩略图
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapPicture:tapView:tableViewCell:)]) {
            [self.delegate tapPicture:self.cellIndex tapView:(UIImageView *)gesture.view tableViewCell:self];
        }
    }
}

- (void)layoutSubviews
{
    [self updateFrame];
}

- (void)updateFrame
{
    NSInteger imgHeight;
    NSInteger imgWidth;
    [self.percentLabel setHidden:NO];
    if (self.model.messageStatus == kJMSGStatusReceiveDownloadFailed) {
      imgHeight = [UIImage imageNamed:@"receiveFail"].size.height;
      imgWidth = [UIImage imageNamed:@"receiveFail"].size.width;
      [self.downLoadIndicatorView setCenter:CGPointMake(self.contentImgView.frame.size.width/2, self.contentImgView.frame.size.height/2)];
    }else {
        [self.downLoadIndicatorView setHidden:YES];
      UIImage *showImg;
      if ([[NSFileManager defaultManager] fileExistsAtPath:self.model.pictureThumbImgPath]) {
       showImg = [UIImage imageWithContentsOfFile:self.model.pictureThumbImgPath];
      }else if (self.message.mediaData) {
        showImg = [UIImage imageWithData:self.message.mediaData];
      } else {
        showImg = [UIImage imageNamed:@"receiveFail"];
      }
        if (IS_IPHONE_6P) {
            imgHeight = showImg.size.height/3;
            imgWidth  = showImg.size.width/3;
        }else {
            imgHeight = showImg.size.height/2;
            imgWidth  = showImg.size.width/2;
        }
//      imgHeight = showImg.size.height/showImg.scale;
//      imgWidth = showImg.size.width/showImg.scale;

    }
    if (self.model.messageStatus == kJMSGStatusSending || self.model.messageStatus == kJMSGStatusReceiving) {
        [self.circleView setHidden:NO];
        [self.sendFailView setHidden:YES];
    }else if (self.model.messageStatus == kJMSGStatusSendSucceed || self.model.messageStatus == kJMSGStatusReceiveSucceed)
    {
        [self.circleView setHidden:YES];
        [self.sendFailView setHidden:YES];
        [self.percentLabel setHidden:YES];
    }else if (self.model.messageStatus == kJMSGStatusSendFail)
    {
        [self.circleView setHidden:YES];
        [self.sendFailView setHidden:NO];
    }else {
        [self.circleView setHidden:YES];
        [self.sendFailView setHidden:YES];
    }
    UIImage *img=nil;
  
//  [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
//  }];
//  [self.pictureImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//  }];
//  [self.contentImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//  }];
//  [self.percentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//  }];
//  [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {
//  }];
//  [self.downLoadIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
//  }];
  
  self.sendFailView = [UIImageView new];
    if (self.model.who) {//myself
        img =[UIImage imageNamed:@"mychatBg"];
        [self.headView setFrame:CGRectMake(kApplicationWidth - headHeight - 5, 0, headHeight, headHeight)];
//      [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(headHeight, headHeight));
//        make.right.mas_equalTo(self).with.offset(-5);
//        make.top.mas_equalTo(self);
//      }];
        [self.pictureImgView setFrame:CGRectMake(kApplicationWidth - headHeight - 5 - imgWidth, 0, imgWidth, imgHeight)];

//      [self.pictureImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(imgWidth, imgHeight));
//        make.width.mas_equalTo(imgWidth);
//        make.height.mas_equalTo(imgHeight);
//        make.top.mas_equalTo(self);
//        make.right.mas_equalTo(self.headView.mas_left).with.offset(-5);
//      }];
        [self.contentImgView setFrame:CGRectMake(5, 5, self.pictureImgView.bounds.size.width-2*8-2, self.pictureImgView.bounds.size.height-10)];
//      [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.pictureImgView).with.offset(5);
//        make.left.mas_equalTo(self.pictureImgView).with.offset(5);
//        make.right.mas_equalTo(self.pictureImgView).with.offset(-13);
//        make.bottom.mas_equalTo(self.pictureImgView).with.offset(-5);
//      }];
        [self.circleView setFrame:CGRectMake(self.pictureImgView.frame.origin.x-25, 40, 20, 20)];
//      [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//        make.top.mas_equalTo(self).with.offset(40);
//        make.right.mas_equalTo(self.pictureImgView.mas_left).with.offset(25);
//      }];
      [self.sendFailView setFrame:CGRectMake(self.pictureImgView.frame.origin.x-25, 42.5, 17, 15)];
//      [self.sendFailView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(17, 15));
//        make.top.mas_equalTo(self).with.offset(42);
////        make.right.mas_equalTo(self.pictureImgView.mas_left).with.offset(25);
//      }];

    }else{
        img =[UIImage imageNamed:@"otherChatBg"];
        [self.headView setFrame:CGRectMake(5, 0, headHeight, headHeight)];
//      [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(headHeight, headHeight));
//        make.left.mas_equalTo(self).with.offset(5);
//        make.top.mas_equalTo(self);
//      }];
      [self.pictureImgView setFrame:CGRectMake(headHeight + 5, 0, imgWidth, imgHeight)];
//      [self.pictureImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(imgWidth, imgHeight));
//        make.left.mas_equalTo(self.headView.mas_right).with.offset(5);
//        make.top.mas_equalTo(self);
//      }];
        [self.contentImgView setFrame:CGRectMake(12, 5, self.pictureImgView.bounds.size.width - 2 * 8 - 2, self.pictureImgView.bounds.size.height-10)];
//      [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.pictureImgView).with.offset(12);
//        make.top.mas_equalTo(self.pictureImgView).with.offset(5);
//        make.right.mas_equalTo(self.pictureImgView).with.offset(-5);
//        make.bottom.mas_equalTo(self.pictureImgView).with.offset(-5);
//        
//      }];
        [self.circleView setFrame:CGRectMake(self.pictureImgView.frame.origin.x + 5, 40, 20, 20)];
//      [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//        make.left.mas_equalTo(self.pictureImgView.mas_right).with.offset(5);
//        make.top.mas_equalTo(self).with.offset(40);
//      }];
        [self.sendFailView setFrame:CGRectMake(self.pictureImgView.frame.origin.x + 5, 42.5, 17, 15)];
//      [self.sendFailView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(17, 15));
//        make.left.mas_equalTo(self.pictureImgView.mas_left).with.offset(5);
//        make.top.mas_equalTo(self).with.offset(42.5);
//      }];
    }
    [self.percentLabel setFrame:CGRectMake(0, 0, 50, 50)];
    [self.percentLabel setCenter:CGPointMake(self.contentImgView.frame.size.width/2, self.contentImgView.frame.size.height/2)];
//    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.size.mas_equalTo(CGSizeMake(50, 50));
//      make.center.mas_equalTo(self.contentImgView);
//    }];
    [self.downLoadIndicatorView setCenter:CGPointMake(self.contentImgView.frame.size.width/2, self.contentImgView.frame.size.height/2)];
//    [self.downLoadIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.center.mas_equalTo(self.contentImgView);
//    }];
    UIImage *newImg =[img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];
    [self.pictureImgView setImage:newImg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
