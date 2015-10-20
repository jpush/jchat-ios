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
    [self.headImgView setImage:[UIImage imageNamed:@"headDefalt"]];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ConversationChange:)
                                                 name:kConversationChange
                                               object:nil];
  }
  return self;
}

- (void)ConversationChange:(NSNotification *)notif {
  [self setupMessageDelegateWithConversation:notif.object];
}

- (void)setupMessageDelegateWithConversation:(JMSGConversation *)converstion {
  [JMessage removeDelegate:self];
  [JMessage addDelegate:self withConversation:converstion];
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
//  if (!model.sendFlag) {
//    model.sendFlag = YES;
//    [self sendTextMessage:model.message];
//  }
  self.headViewFlag = model.fromUser.username;
  self.headImgView.layer.cornerRadius = 23;
  self.conversation = model.conversation;
  [self.headImgView.layer setMasksToBounds:YES];
  _model = model;
  self.delegate = delegate;

  [self.imageView setImage:[UIImage imageNamed:@"headDefalt"]];
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {

  }
  _fromUser = model.message.fromUser;
  
  [_fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
    if (error == nil) {
      if ([objectId isEqualToString:self.headViewFlag]) {
        if (data != nil) {
          [self.headImgView setImage:[UIImage imageWithData:data]];
        } else {
          [self.headImgView setImage:[UIImage imageNamed:@"headDefalt"]];
        }
      } else {
        DDLogDebug(@"该头像是异步乱序的头像");
      }
    } else {
      DDLogDebug(@"Action -- get thumbavatar fail");
      [self.headImgView setImage:[UIImage imageNamed:@"headDefalt"]];
    }
  }];
  [self updateFrame];
}

- (void)layoutSubviews
{
  [self updateFrame];
}

- (void)updateFrame {
  if (_model.type == kJMSGContentTypeText) {
    UIFont *font =[UIFont systemFontOfSize:18];
    CGSize maxSize = CGSizeMake(200, 2000);
    
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize realSize = [_model.chatContent boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    CGSize imgSize =realSize;
    imgSize.height=realSize.height+20;
    imgSize.width=realSize.width+2*15;
    CGSize bgSize =CGSizeMake(imgSize.width+headHeight+10, imgSize.height);

    [self.contentLabel setFrame:CGRectMake(15, 10, realSize.width, realSize.height)];
    [self.contentLabel setBackgroundColor:[UIColor clearColor]];
    
    if (!_model.isReceived) {//isme
      [self.chatView setFrame:CGRectMake(kApplicationWidth - imgSize.width - headHeight - 10, 0, imgSize.width, imgSize.height)];
      [self.headImgView setFrame:CGRectMake(kApplicationWidth - headHeight - 5, 0, headHeight, headHeight)];
      [self.stateView setFrame:CGRectMake(self.chatView.frame.origin.x - 25, imgSize.height/2 - 5, 20, 20)];
    }else
    {
      
      [self.headImgView setFrame:CGRectMake( 5, 0, headHeight, headHeight)];
      [self.chatView setFrame:CGRectMake(headHeight + 10, 0, imgSize.width, imgSize.height)];
    }
    self.contentLabel.font = font;
  }
  UIImage *img=nil;
  if (!_model.isReceived) {
    img =[UIImage imageNamed:@"mychatBg"];
  } else
  {
    img =[UIImage imageNamed:@"otherChatBg"];
  }
  UIImage *newImg =[img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)
                                       resizingMode:UIImageResizingModeTile];
  [self.chatView setImage:newImg];
  [self.chatView setBackgroundColor:[UIColor clearColor]];
  self.chatView.layer.cornerRadius=6;
  [self.chatView.layer setMasksToBounds:YES];
  
  [self.contentLabel setBackgroundColor:[UIColor clearColor]];
  self.contentLabel.numberOfLines=0;
  self.contentLabel.text = _model.chatContent;
  
  [self.stateView setHidden:YES];
  [self.stateView stopAnimating];
  [self.sendFailView setHidden:YES];
  if (_model.message.status == kJMSGMessageStatusSending || _model.messageStatus == kJMSGMessageStatusReceiving) {
    [self.stateView setHidden:NO];
    [self.stateView startAnimating];
    [self.sendFailView setHidden:YES];
  }else if (_model.message.status == kJMSGMessageStatusSendSucceed || _model.messageStatus == kJMSGMessageStatusReceiveSucceed)
  {
    [self.stateView stopAnimating];
    [self.stateView setHidden:YES];
    [self.sendFailView setHidden:YES];
  }else if (_model.message.status == kJMSGMessageStatusSendFailed || _model.messageStatus == kJMSGMessageStatusReceiveDownloadFailed)
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

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    [self.sendFailView setHidden:YES];
    _model.messageStatus = kJMSGMessageStatusSending;
    [self.stateView setHidden:NO];
    [self.stateView startAnimating];
    if (!_sendFailMessage) {
      [JMSGMessage sendMessage:_model.message];
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
  if (![message.msgId isEqualToString:self.model.message.msgId]) {
    return;
  }
  [self updateFrame];


}

- (void)dealloc {
  DDLogDebug(@"Action -- dealloc");
  [JMessage removeDelegate:self];
}
@end
