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


@implementation JCHATImgTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.headView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headHeight, headHeight)];
    self.headView = [UIImageView new];
    
    [self.headView setImage:[UIImage imageNamed:@"headDefalt_34.png"]];
    [self addSubview:self.headView];
    self.headView.layer.cornerRadius = 23;
    [self.headView.layer setMasksToBounds:YES];
    
//    self.pictureImgView = [[UIImageView alloc]init];
    self.pictureImgView = [UIImageView new];
    self.pictureImgView.contentMode = UIViewContentModeScaleAspectFill;
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
    
    self.pictureImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
    [self.pictureImgView addGestureRecognizer:gesture];
//    self.contentImgView  =[[UIImageView alloc] init];
//    self.contentImgView = [UIImageView new];
//    self.contentImgView.contentMode = UIViewContentModeScaleAspectFill;
//    self.contentImgView.clipsToBounds = YES;
//    [self.contentImgView setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
//    [self.contentImgView addGestureRecognizer:gesture];
//    [self.contentImgView setFrame:CGRectMake(5, 5, self.pictureImgView.bounds.size.width-2*8-2, self.pictureImgView.bounds.size.height)];
    
//    self.percentLabel =[[UILabel alloc]init];
    self.percentLabel = [UILabel new];
    self.percentLabel.hidden = NO;
    self.percentLabel.font =[UIFont systemFontOfSize:18];
    self.percentLabel.textAlignment=NSTextAlignmentCenter;
    self.percentLabel.textColor=[UIColor whiteColor];
    [self.percentLabel setBackgroundColor:[UIColor clearColor]];
//    [self.contentImgView addSubview:self.percentLabel];
    [self.pictureImgView addSubview:self.percentLabel];
    
//    [self.pictureImgView addSubview:self.contentImgView];
    
//    self.circleView =[[UIActivityIndicatorView alloc] init];
    self.circleView = [UIActivityIndicatorView new];
    
    [self addSubview:self.circleView];
    [self.circleView setBackgroundColor:[UIColor clearColor]];
    [self.circleView setHidden:NO];
    self.circleView.hidesWhenStopped=YES;
    
//    self.downLoadIndicatorView =[[UIActivityIndicatorView alloc] init];
    self.downLoadIndicatorView = [UIActivityIndicatorView new];
    
//    [self.contentImgView addSubview:self.downLoadIndicatorView];
    [self.pictureImgView addSubview:self.downLoadIndicatorView];
    [self.downLoadIndicatorView setBackgroundColor:[UIColor clearColor]];
    [self.downLoadIndicatorView setHidden:NO];
    self.downLoadIndicatorView.hidesWhenStopped=YES;
    
//    self.sendFailView =[[UIImageView alloc] init];
    self.sendFailView = [UIImageView new];
    [self addSubview:self.sendFailView];
    [self.sendFailView setUserInteractionEnabled:YES];
    [self.sendFailView setImage:[UIImage imageNamed:@"fail05"]];

    [self headAddGesture];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageResponse:) name:JMSGNotification_SendMessageResult object:nil];
  }
  return self;
}

#pragma mark --发送消息响应
//- (void)sendMessageResponse:(NSNotification *)response {
//  DDLogDebug(@"Event - sendMessageResponse");
//
//  JPIMMAINTHEAD(^{
//        NSDictionary *responseDic = [response userInfo];
//        NSError *error = [responseDic objectForKey:JMSGSendMessageError];
//        JMSGImageMessage *message = [responseDic objectForKey:JMSGSendMessageObject];
//        if (error == nil) {
//        }else {
//            JPIMLog(@"Sent voiceMessage Response error:%@",error);
//        }
//        if (![message.messageId isEqualToString:_message.messageId]) {
//            return ;
//        }
//        [self.circleView stopAnimating];
////        self.contentImgView.alpha = 1;
//        self.pictureImgView.alpha = 1;
//        _model.isSending = NO;
//        if (error == nil) {
//            self.model.messageStatus = kJMSGStatusSendSucceed;
//            [self.sendFailView setHidden:YES];
//            [self.circleView stopAnimating];
//            [self.circleView setHidden:YES];
//        }else {
//            self.model.messageStatus = kJMSGStatusSendFail;
//            [self.sendFailView setHidden:NO];
//            [self.circleView stopAnimating];
//            [self.circleView setHidden:YES];
//            _sendFailImgMessage = [message copy];
//        }
//        [self updateFrame];
//
//    });
//}

- (void)headAddGesture {
    [self.headView setUserInteractionEnabled:YES];
//    [self.contentImgView setUserInteractionEnabled:YES];
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
//        self.contentImgView.alpha = 0.5;
      self.pictureImgView.alpha = 0.5;
        _model.isSending = YES;
        self.model.messageStatus = kJMSGMessageStatusSending;
        __weak typeof(self)weakSelf = self;
        if (!self.sendFailImgMessage) {
         self.sendFailImgMessage = [self.conversation messageWithMessageId:self.model.messageId];
//            [self.conversation getMessage:self.model.messageId completionHandler:^(id resultObject, NSError *error) {
//                if (error == nil) {
//                    weakSelf.sendFailImgMessage = resultObject;
//                    weakSelf.message = resultObject;
//                    weakSelf.sendFailImgMessage.progressCallback=^(float percent){
//                      weakSelf.percentLabel.text=[NSString stringWithFormat:@"%d%%",(int)percent*100];
//                    };
//                    self.sendFailImgMessage.conversationType = self.conversation.chatType;
//                    [JMSGMessage sendMessage:self.sendFailImgMessage];
//                }else {
//                    NSLog(@"获取消息失败!");
//                }
//            }];
        }else {
//            self.sendFailImgMessage.progressCallback=^(float percent){
//                weakSelf.percentLabel.text=[NSString stringWithFormat:@"%d%%",(int)percent*100];
//            };
          self.sendFailImgMessage.uploadHandler = ^(float percent){
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

- (void)setCellData :(UIViewController *)controler chatModel :(JCHATChatModel *)chatModel message:(JMSGMessage *)message indexPath :(NSIndexPath *)indexPath {
  self.conversation = chatModel.conversation;
  self.model = chatModel;
  _message= message;
  if (_model.isSending) {
    self.pictureImgView.alpha = 0.5;
  }else {
    self.pictureImgView.alpha = 1;
  }
  [self.circleView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  if (self.model.messageStatus == kJMSGMessageStatusReceiveDownloadFailed) {
    [self.pictureImgView setImage:[UIImage imageNamed:@"receiveFail"]];
  } else if ([[NSFileManager defaultManager] fileExistsAtPath:self.model.pictureThumbImgPath]) {
    [self.pictureImgView setImage:[UIImage imageWithContentsOfFile:self.model.pictureThumbImgPath]];//!
  }else if (((JMSGImageContent *)message.content).thumbImagePath){
    [self.pictureImgView setImage:[UIImage imageWithContentsOfFile:((JMSGImageContent *)message.content).thumbImagePath]];
  }else {
    //      [self.pictureImgView setImage:[UIImage imageWithContentsOfFile:((JMSGImageContent *)message.content).thumbImagePath]];
  }
  self.delegate = (id)controler;
  self.cellIndex = indexPath;
//  if ([[NSFileManager defaultManager] fileExistsAtPath:chatModel.avatar]) {
//    [self.headView setImage:[UIImage imageWithContentsOfFile:chatModel.avatar]];
//  }else {
//    [self.headView setImage:[UIImage imageNamed:@"headDefalt_34"]];
//  }

//    [self.headView setImage:[UIImage imageWithData:chatModel.avatar]];
    [self.headView setImage:[UIImage imageNamed:@"headDefalt_34"]];
  NSLog(@"huangmin  message  %@",_model.message);
    typeof(self) __weak weakSelf = self;
    [_model.message.fromUser thumbAvatarData:^(id resultObject, NSError *error) {
            if (error == nil) {
              JPIMMAINTHEAD(^{
                [weakSelf.headView setImage:[UIImage imageWithData:resultObject]];
              });
      
            }else {
              DDLogDebug(@"Action -- get thumbavatar fail");
            }
          }];


  
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
//  self.contentImgView.alpha = 0.5;
  self.pictureImgView.alpha = 0.5;
  _model.isSending = YES;
  self.model.messageStatus = kJMSGMessageStatusSending;
  self.model.messageId = _message.msgId;
  __weak typeof(self) weakSelf = self;
  _message.uploadHandler = ^(float percent) {
    weakSelf.percentLabel.text = [NSString stringWithFormat:@"%d%%", (int) percent * 100];
  };
//  if (self.conversation.chatType == kJMSGConversationTypeSingle) {
//    _message.conversationType = kJMSGConversationTypeSingle;
//  }else {
//    _message.conversationType = kJMSGConversationTypeGroup;
//  }
//  _message.targetId = self.model.targetId;
//  _message.mediaData = self.model.mediaData;
  
  DDLogVerbose(@"The imageMessage - %@", _message);
  [JMSGMessage sendMessage:_message];
}

- (void)tapPicture:(UIGestureRecognizer *)gesture {
  
    NSLog(@"nslog  tap gesture");
    if (self.model.messageStatus == kJMSGMessageStatusReceiveDownloadFailed) {
      NSLog(@"正在下载缩略图");
      JPIMLog(@"Action");
      [self.downLoadIndicatorView setHidden:NO];
      [self.downLoadIndicatorView startAnimating];
      [self.conversation messageWithMessageId:self.model.messageId];
//      [self.conversation getMessage:self.model.messageId completionHandler:^(id resultObject, NSError *error) {
//        if (error == nil) {
//          NSProgress *progress = [NSProgress progressWithTotalUnitCount:1000];
//          [JMSGMessage downloadThumbImage:resultObject
//                             withProgress:progress
//                        completionHandler:^(id resultObject, NSError *error) {
//                          JPIMMAINTHEAD(^{
//                            [self.downLoadIndicatorView stopAnimating];
//                            if (error == nil) {
//                              self.model.pictureThumbImgPath = [(NSURL *)resultObject path];
//                              self.model.messageStatus = kJMSGStatusReceiveSucceed;
////                              [self.contentImgView setImage:[UIImage imageWithContentsOfFile:[(NSURL *)resultObject path]]];
//                              [self.pictureImgView setImage:[UIImage imageWithContentsOfFile:[(NSURL *)resultObject path]]];
//                              [self updateFrame];
//                              JPIMLog(@"下载缩略图成功 :%@",[(NSURL *)resultObject path]);
//                            }else {
//                              JPIMLog(@"下载缩略图失败");
//                              [MBProgressHUD showMessage:@"下载缩略图失败" view:self];
//                            }
//                          });
//                        }];
//        }else {
//          JPIMLog(@"下载缩略图获取消息失败。。。");
//          JPIMMAINTHEAD(^{
//            [MBProgressHUD showMessage:@"下载缩略图失败" view:self];
//          });
//        }
//      }];
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
    NSInteger imgHeight = 0;
    NSInteger imgWidth = 0;
    [self.percentLabel setHidden:NO];
    if (self.model.messageStatus == kJMSGMessageStatusReceiveDownloadFailed) {
//      imgHeight = [UIImage imageNamed:@"receiveFail"].size.height;
//      imgWidth = [UIImage imageNamed:@"receiveFail"].size.width;
//      [self.downLoadIndicatorView setCenter:CGPointMake(self.contentImgView.frame.size.width/2, self.contentImgView.frame.size.height/2)];
      [self.downLoadIndicatorView setCenter:CGPointMake(self.pictureImgView.frame.size.width/2, self.pictureImgView.frame.size.height/2)];
    }else {
      [self.downLoadIndicatorView setHidden:YES];
      _model.isSending = NO;
      __block UIImage *showImg;

      if ([[NSFileManager defaultManager] fileExistsAtPath:self.model.pictureThumbImgPath]) {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          showImg = [UIImage imageWithContentsOfFile:self.model.pictureThumbImgPath];
        });
      }else if (((JMSGImageContent *)self.message.content).thumbImagePath) {
//        showImg = [UIImage imageWithData:((JMSGImageContent *)self.message.content).];
        showImg = [UIImage imageWithContentsOfFile:((JMSGImageContent *)self.message.content).thumbImagePath];
      } else {
        showImg = [UIImage imageNamed:@"receiveFail"];
      }
//        if (IS_IPHONE_6P) {
//            imgHeight = showImg.size.height/3;
//            imgWidth  = showImg.size.width/3;
//        }else {
//            imgHeight = showImg.size.height/2;
//            imgWidth  = showImg.size.width/2;
//        }
      imgHeight = _model.imageSize.height;
      imgWidth = _model.imageSize.width;
    }
    if (self.model.messageStatus == kJMSGMessageStatusSending || self.model.messageStatus == kJMSGMessageStatusReceiving) {
        [self.circleView setHidden:NO];
        [self.sendFailView setHidden:YES];
    }else if (self.model.messageStatus == kJMSGMessageStatusSendSucceed || self.model.messageStatus == kJMSGMessageStatusReceiveSucceed)
    {
        [self.circleView setHidden:YES];
        [self.sendFailView setHidden:YES];
        [self.percentLabel setHidden:YES];
    }else if (self.model.messageStatus == kJMSGMessageStatusSendFailed)
    {
        [self.circleView setHidden:YES];
        [self.sendFailView setHidden:NO];
    }else {
        [self.circleView setHidden:YES];
        [self.sendFailView setHidden:YES];
    }
//    UIImage *img=nil;//!
  
  [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
  [self.pictureImgView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
//  [self.contentImgView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
  [self.percentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {}];
  [self.circleView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
  [self.downLoadIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
  

    if (self.model.isMyMessage) {//myself
        img =[UIImage imageNamed:@"mychatBg"];
//        [self.headView setFrame:CGRectMake(kApplicationWidth - headHeight - 5, 0, headHeight, headHeight)];
      [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headHeight, headHeight));
        make.right.mas_equalTo(self).with.offset(-5);
        make.top.mas_equalTo(self);
      }];
//        [self.pictureImgView setFrame:CGRectMake(kApplicationWidth - headHeight - 5 - imgWidth, 0, imgWidth, imgHeight)];

      [self.pictureImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imgWidth, imgHeight));
//        make.top.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.headView.mas_left).with.offset(-5);
      }];
//        [self.contentImgView setFrame:CGRectMake(5, 5, self.pictureImgView.bounds.size.width-2*8-2, self.pictureImgView.bounds.size.height-10)];
//      [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.pictureImgView).with.offset(5);
//        make.left.mas_equalTo(self.pictureImgView).with.offset(5);
//        make.right.mas_equalTo(self.pictureImgView).with.offset(-13);
//        make.bottom.mas_equalTo(self.pictureImgView).with.offset(-5);
//      }];
//        [self.circleView setFrame:CGRectMake(self.pictureImgView.frame.origin.x-25, 40, 20, 20)];
      [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(self).with.offset(40);
        make.right.mas_equalTo(self.pictureImgView.mas_left).with.offset(-15);
      }];
//      [self.sendFailView setFrame:CGRectMake(self.pictureImgView.frame.origin.x-25, 42.5, 17, 15)];
      [self.sendFailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 15));
        make.top.mas_equalTo(self).with.offset(42);
        make.right.mas_equalTo(self.pictureImgView.mas_left).with.offset(25);
      }];

    }else{
        img =[UIImage imageNamed:@"otherChatBg"];
//        [self.headView setFrame:CGRectMake(5, 0, headHeight, headHeight)];
      [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headHeight, headHeight));
        make.left.mas_equalTo(self).with.offset(5);
        make.top.mas_equalTo(self);
      }];
//      [self.pictureImgView setFrame:CGRectMake(headHeight + 5, 0, imgWidth, imgHeight)];
      [self.pictureImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(imgWidth, imgHeight));
        make.left.mas_equalTo(self.headView.mas_right).with.offset(5);
//        make.top.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
      }];
//        [self.contentImgView setFrame:CGRectMake(12, 5, self.pictureImgView.bounds.size.width - 2 * 8 - 2, self.pictureImgView.bounds.size.height-10)];
//      [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.pictureImgView).with.offset(12);
//        make.top.mas_equalTo(self.pictureImgView).with.offset(5);
//        make.right.mas_equalTo(self.pictureImgView).with.offset(-5);
//        make.bottom.mas_equalTo(self.pictureImgView).with.offset(-5);
//        
//      }];
//        [self.circleView setFrame:CGRectMake(self.pictureImgView.frame.origin.x + 5, 40, 20, 20)];
      [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(self.pictureImgView.mas_right).with.offset(5);
        make.top.mas_equalTo(self).with.offset(40);
      }];
//        [self.sendFailView setFrame:CGRectMake(self.pictureImgView.frame.origin.x + 5, 42.5, 17, 15)];
      [self.sendFailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 15));
        make.left.mas_equalTo(self.pictureImgView.mas_left).with.offset(5);
        make.top.mas_equalTo(self).with.offset(42.5);
      }];
    }
    [self.percentLabel setFrame:CGRectMake(0, 0, 50, 50)];
//    [self.percentLabel setCenter:CGPointMake(self.contentImgView.frame.size.width/2, self.contentImgView.frame.size.height/2)];
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(50, 50));
//      make.center.mas_equalTo(self.contentImgView);
      make.center.mas_equalTo(self.pictureImgView);
    }];
//    [self.downLoadIndicatorView setCenter:CGPointMake(self.contentImgView.frame.size.width/2, self.contentImgView.frame.size.height/2)];
    [self.downLoadIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.center.mas_equalTo(self.contentImgView);
      make.center.mas_equalTo(self.pictureImgView);
    }];
  CALayer *imagemask = [CALayer layer];
//  img =[img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];//(28, 20, 28, 20)
  imagemask.contents = (__bridge id)(img.CGImage);

//  self.pictureImgView.layer.mask = imagemask;
  
//  img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)]
//  UIGraphicsBeginImageContext(self.pictureImgView.frame.size);
//  // 绘制改变大小的图片
//  [img drawInRect:CGRectMake(0, 0, self.pictureImgView.frame.size.width, self.pictureImgView.frame.size.height)];
//  // 从当前context中创建一个改变大小后的图片
//  UIImage* newImg = UIGraphicsGetImageFromCurrentImageContext();
//  // 使当前的context出堆栈
//  UIGraphicsEndImageContext();
//    [self.pictureImgView setImage:newImg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
