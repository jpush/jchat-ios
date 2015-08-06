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
    self.chatView =[[UIImageView alloc]init];
    self.chatbgView =[[UIImageView alloc]init];
    self.contentLabel =[[UILabel alloc]init];
    self.headImgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headHeight, headHeight)];
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
    [self.chatbgView addSubview:self.chatView];
    [self.chatView addSubview:self.contentLabel];
    [self.chatbgView addSubview:self.headImgView];
    [self addSubview:self.chatbgView];
    [self headAddGesture];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void)setCellData:(JCHATChatModel *)model delegate:(id )delegate
{
  self.headImgView.layer.cornerRadius = 23;
  self.conversation = model.conversation;
  [self.headImgView.layer setMasksToBounds:YES];
  _model = model;
  self.delegate = delegate;
  if ([[NSFileManager defaultManager] fileExistsAtPath:model.avatar]) {
    [self.headImgView setImage:[UIImage imageWithContentsOfFile:model.avatar]];
  }else {
    [self.headImgView setImage:[UIImage imageNamed:@"headDefalt_34"]];
  }
  [self creadBuddleChatView];
}

- (void)layoutSubviews
{
  [self creadBuddleChatView];
}

- (void)creadBuddleChatView
{
  if (_model.type == kJMSGTextMessage) {
    UIFont *font =[UIFont systemFontOfSize:18];
    CGSize maxSize = CGSizeMake(200, 2000);
    
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize realSize = [_model.chatContent boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    //            [_model.chatContent sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    UIImage *img=nil;
    if (_model.who) {
      img =[UIImage imageNamed:@"mychatBg"];
    }else
    {
      img =[UIImage imageNamed:@"otherChatBg"];
    }
    UIImage *newImg =[img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)
                                         resizingMode:UIImageResizingModeTile];
    [self.chatView setImage:newImg];
    [self.chatView setBackgroundColor:[UIColor clearColor]];
    CGSize imgSize =realSize;
    imgSize.height=realSize.height+20;
    imgSize.width=realSize.width+2*15;
    self.chatView.layer.cornerRadius=6;
    [self.chatView.layer setMasksToBounds:YES];
    if (_model.who) {
      [self.chatView setFrame:CGRectMake(kApplicationWidth-imgSize.width, 0, imgSize.width, imgSize.height)];
    }else
    {
      [self.chatView setFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    }
    [self.contentLabel setFrame:CGRectMake(15, 10, realSize.width, realSize.height)];
    [self.contentLabel setBackgroundColor:[UIColor clearColor]];
    self.contentLabel.numberOfLines=0;
    self.contentLabel.text = _model.chatContent;
    self.contentLabel.font = font;
    self.chatbgView.tag = 99;
    [self.chatbgView setBackgroundColor:[UIColor clearColor]];
    CGSize bgSize =CGSizeMake(imgSize.width+headHeight+10, imgSize.height);
    [self.headImgView setBackgroundColor:[UIColor clearColor]];
    if (_model.who) {
      [self.chatbgView setFrame:CGRectMake(kApplicationWidth-bgSize.width, 0, bgSize.width, bgSize.height)];
      [self.headImgView setFrame:CGRectMake(imgSize.width+5, 0, headHeight, headHeight)];
      [self.chatView setFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
      [self.stateView setFrame:CGRectMake(self.chatbgView.frame.origin.x-35, (self.chatbgView.frame.size.height-30)/2, 30, 30)];
      [self.sendFailView setFrame:CGRectMake(self.chatbgView.frame.origin.x-25, (self.chatbgView.frame.size.height-15)/2, 17, 15)];
    }else
    {
      [self.chatbgView setFrame:CGRectMake(0, 0, bgSize.width, bgSize.height)];
      [self.headImgView setFrame:CGRectMake(5, 0, headHeight, headHeight)];
      [self.chatView setFrame:CGRectMake(headHeight+10, 0, imgSize.width, imgSize.height)];
      [self.stateView setFrame:CGRectMake(self.chatbgView.frame.origin.x+self.chatbgView.frame.size.width+5, (self.chatbgView.frame.size.height-30)/2, 30, 30)];
      [self.sendFailView setFrame:CGRectMake(self.chatbgView.frame.origin.x+self.chatbgView.frame.size.width+5, (self.chatbgView.frame.size.height-15)/2, 17, 15)];
    }
  }else{
    NSLog(@"消息错误");
  }
  [self.stateView setHidden:YES];
  [self.stateView stopAnimating];
  [self.sendFailView setHidden:YES];
  if (_model.messageStatus == kJMSGStatusSending || _model.messageStatus == kJMSGStatusReceiving) {
    [self.stateView setHidden:NO];
    [self.stateView startAnimating];
    [self.sendFailView setHidden:YES];
  }else if (_model.messageStatus == kJMSGStatusSendSucceed || _model.messageStatus == kJMSGStatusReceiveSucceed)
  {
    [self.stateView stopAnimating];
    [self.stateView setHidden:YES];
    [self.sendFailView setHidden:YES];
  }else if (_model.messageStatus == kJMSGStatusSendFail || _model.messageStatus == kJMSGStatusReceiveDownloadFailed)
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
  [self.chatbgView setUserInteractionEnabled:YES];
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
    _model.messageStatus = kJMSGStatusSending;
    [self.stateView setHidden:NO];
    [self.stateView startAnimating];
    if (!_sendFailMessage) {
      [self.conversation getMessage:_model.messageId
                  completionHandler:^(id resultObject, NSError *error) {
                    if (error == nil) {
                      _message = _sendFailMessage = resultObject;
                      _message.targetId = self.conversation.targetId;
                      _message.conversationType = self.conversation.chatType;
                      _sendFailMessage.targetId = self.conversation.targetId;
                      [JMSGMessage sendMessage:_sendFailMessage];
                    }else {
                      NSLog(@"获取消息失败!");
                    }
                  }];
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

@end
