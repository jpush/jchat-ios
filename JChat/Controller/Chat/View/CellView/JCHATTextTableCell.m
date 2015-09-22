//
//  JCHATTextTableCell.m
//  JChat
//
//  Created by HuminiOS on 15/8/6.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATTextTableCell.h"
#import "JChatConstants.h"
#import <JMessage/JMessage.h>
#import "JCHATSendMessageViewController.h"
#import "Masonry.h"
#define headHeight 46

@implementation JCHATTextTableCell

- (void)awakeFromNib {
  // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor clearColor]];

    self.contentLabel = [UILabel new];
    self.chatView = [UIImageView new];

    self.headImgView = [UIImageView new];
    [self.headImgView setImage:[UIImage imageNamed:@"headDefalt_34"]];
    self.stateView =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.stateView setHidden:NO];
    [self.stateView startAnimating];
    self.stateView.hidesWhenStopped=YES;
    self.sendFailView =[[UIImageView alloc]init];
    [self.sendFailView setBackgroundColor:[UIColor clearColor]];
    [self.sendFailView setImage:[UIImage imageNamed:@"fail05"]];
    [self.sendFailView setUserInteractionEnabled:YES];
    [self addSubview:self.stateView];
    [self addSubview:self.sendFailView];
    [self addSubview:self.chatView];
    [self.chatView addSubview:self.contentLabel];
    [self addSubview:self.headImgView];
    [self headAddGesture];
    self.isMe = YES;
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void)setCellData:(JCHATChatModel *)model delegate:(id )delegate
{
//  if (!model.sendFlag) {
//    model.sendFlag = YES;
//    // 消息展示出来时，调用发文本消息
//    [self sendTextMessage:model.messageId];
//  }
  
  self.headImgView.layer.cornerRadius = 23;
  self.conversation = model.conversation;
  [self.headImgView.layer setMasksToBounds:YES];
  _model = model;
  self.delegate = delegate;

  [self.imageView setImage:[UIImage imageNamed:@"headDefalt_34"]];
  _message = model.message;
  typeof(self) __weak weakSelf = self;
  JMSGUser *tmpUser = _message.fromUser;
  [tmpUser thumbAvatarData:^(id resultObject, NSError *error) {
    NSLog(@"huangmin dashuai in");
    if (error == nil) {
      JPIMMAINTHEAD(^{
        if (resultObject !=nil) {
          [weakSelf.headImgView setImage:[UIImage imageWithData:resultObject]];
        } else {
          [weakSelf.imageView setImage:[UIImage imageNamed:@"headDefalt_34"]];
        }
      });
    }else {
      DDLogDebug(@"Action -- get thumbavatar fail");
      [weakSelf.imageView setImage:[UIImage imageNamed:@"headDefalt_34"]];
    }
  }];
    NSLog(@"huangmin dashuai out");
//  if (model.avatar != nil) {
////    [self.headImgView setImage:[UIImage imageWithData:model.avatar]];
//    typeof(self) __weak weakSelf = self;
//
//    
//    [[model.conversation messageWithMessageId:model.messageId].fromUser thumbAvatarData:^(id resultObject, NSError *error) {
//      if (error == nil) {
//        JPIMMAINTHEAD(^{
//          [weakSelf.headImgView setImage:[UIImage imageWithData:resultObject]];
//        });
//        
//      }else {
//        DDLogDebug(@"Action -- get thumbavatar fail");
//      }
//    }];
//  }else {
//    [self.headImgView setImage:[UIImage imageNamed:@"headDefalt_34"]];
//  }
  [self creadBuddleChatView];
}

- (void)layoutSubviews
{
  [self creadBuddleChatView];
}

- (void)deleteAllConstrait {
  [self.chatView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.sendFailView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.headImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
  [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
  }];
}
- (void)creadBuddleChatView
{
  
  
  [self deleteAllConstrait];
  
  if (_model.type == kJMSGContentTypeText) {
    UIFont *font =[UIFont systemFontOfSize:18];
    CGSize maxSize = CGSizeMake(200, 2000);
    
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize realSize = [_model.chatContent boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;

    if (_model.isMyMessage) {//isme
      [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(0);
        make.right.mas_equalTo(self).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(headHeight, headHeight));
      }];

      [self.chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self.headImgView.mas_left).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(realSize.width + 30, realSize.height +20));
      }];

      [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.mas_equalTo(self.chatView.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(self);
      }];
      [self.sendFailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 15));
        make.right.mas_equalTo(self.chatView.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(self);
      }];
//
      [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chatView).with.offset(5);
        make.right.mas_equalTo(self.chatView).with.offset(-15);
        make.left.mas_equalTo(self.chatView).with.offset(5);
        make.bottom.mas_equalTo(self.chatView).with.offset(-5);
      }];
      
    }else
    {
      [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(0);
        make.left.mas_equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(headHeight, headHeight));
      }];

      [self.chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self.headImgView.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(realSize.width + 30, realSize.height +20));
      }];

      [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(self.chatView.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self);
      }];

      [self.sendFailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 15));
        make.left.mas_equalTo(self.chatView.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self);
      }];
      
      [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chatView).with.offset(5);
        make.right.mas_equalTo(self.chatView).with.offset(-5);
        make.left.mas_equalTo(self.chatView).with.offset(15);
        make.bottom.mas_equalTo(self.chatView).with.offset(-5);
      }];

    }
    self.contentLabel.font = font;
  }
    UIImage *img=nil;
    if (_model.isMyMessage) {
      img =[UIImage imageNamed:@"mychatBg"];
    }else
    {
      img =[UIImage imageNamed:@"otherChatBg"];
    }
    UIImage *newImg =[img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)
                                         resizingMode:UIImageResizingModeTile];
    [self.chatView setImage:newImg];
    [self.chatView setBackgroundColor:[UIColor clearColor]];
//    CGSize imgSize =realSize;
//    imgSize.height=realSize.height+20;
//    imgSize.width=realSize.width+2*15;
    self.chatView.layer.cornerRadius=6;
    [self.chatView.layer setMasksToBounds:YES];

    [self.contentLabel setBackgroundColor:[UIColor clearColor]];
    self.contentLabel.numberOfLines=0;
    self.contentLabel.text = _model.chatContent;



//    CGSize bgSize =CGSizeMake(imgSize.width+headHeight+10, imgSize.height);
//    [self.headImgView setBackgroundColor:[UIColor clearColor]];

//  }else{
//    NSLog(@"消息错误");
//  }
  
  [self.stateView setHidden:YES];
  [self.stateView stopAnimating];
  [self.sendFailView setHidden:YES];
  if (_model.messageStatus == kJMSGMessageStatusSending || _model.messageStatus == kJMSGMessageStatusReceiving) {
    [self.stateView setHidden:NO];
    [self.stateView startAnimating];
    [self.sendFailView setHidden:YES];
  }else if (_model.messageStatus == kJMSGMessageStatusSendSucceed || _model.messageStatus == kJMSGMessageStatusReceiveSucceed)
  {
    [self.stateView stopAnimating];
    [self.stateView setHidden:YES];
    [self.sendFailView setHidden:YES];
  }else if (_model.messageStatus == kJMSGMessageStatusSendFailed || _model.messageStatus == kJMSGMessageStatusReceiveDownloadFailed)
  {
    [self.stateView stopAnimating];
    [self.stateView setHidden:YES];
    [self.sendFailView setHidden:NO];
  }else {
    [self.stateView stopAnimating];
    [self.stateView setHidden:YES];
    [self.sendFailView setHidden:YES];
  }
}

- (void)headAddGesture {
  [self.headImgView setUserInteractionEnabled:YES];
  [self.chatView setUserInteractionEnabled:YES];
  UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPersonInfoCtlClick)];
  [self.headImgView addGestureRecognizer:gesture];
  
  UITapGestureRecognizer *messageFailGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSendMessage)];
  [self.sendFailView addGestureRecognizer:messageFailGesture];
}

- (void)reSendMessage {
  UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:nil message:@"是否重新发送消息"
                                                   delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
  [alerView show];
  
}

-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [self.sendFailView setHidden:YES];
    _model.messageStatus = kJMSGMessageStatusSending;
    [self.stateView setHidden:NO];
    [self.stateView startAnimating];
    if (!_sendFailMessage) {
//      _sendFailMessage = [self.conversation messageWithMessageId:_model.messageId];
      _message = _model.message;//!!
      _message = _sendFailMessage;
      [JMSGMessage sendMessage:_message];
//      if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
//        [JMSGMessage sendMessage:<#(JMSGMessage *)#>]
//      }else {
//      
//      }
//      [self.conversation getMessage:_model.messageId
//                  completionHandler:^(id resultObject, NSError *error) {
//                    if (error == nil) {
//                      _message = _sendFailMessage = resultObject;
//                      _message.targetId = self.conversation.targetId;
//                      _message.conversationType = self.conversation.chatType;
//                      _sendFailMessage.targetId = self.conversation.targetId;
//                      [JMSGMessage sendMessage:_sendFailMessage];
//                    }else {
//                      NSLog(@"获取消息失败!");
//                    }
//                  }];
    }else {
      [JMSGMessage sendMessage:_sendFailMessage];
      JPIMLog(@"重新发送消息:%@",_sendFailMessage);
    }
  }
}

- (void)pushPersonInfoCtlClick {
  if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeadView:)]) {
    NSLog(@"%@",_model.targetId);
    [self.delegate selectHeadView:_model];
  }
}

#pragma mark --JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {

}

- (void)dealloc {
  DDLogDebug(@"Action -- dealloc");
}
@end
