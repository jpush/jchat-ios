//
//  JCHATChatTableViewCell.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATConversationListCell.h"
#import "JCHATStringUtils.h"
#import "JCHATSendMsgManager.h"
#import <CoreText/CoreText.h>
#import "Masonry.h"

@implementation JCHATConversationListCell

- (void)awakeFromNib {
  self.time.textColor = [UIColor grayColor];
  self.nickName.textColor = UIColorFromRGB(0x3f80dd);
  self.message.textColor = UIColorFromRGB(0x808080);
  
  [self.messageNumberLabel.layer setMasksToBounds:YES];
  self.messageNumberLabel.layer.cornerRadius = 11;
  self.messageNumberLabel.layer.borderWidth = 1;
  self.messageNumberLabel.layer.borderColor = [UIColor whiteColor].CGColor;
  self.messageNumberLabel.textAlignment = NSTextAlignmentCenter;
  [self.messageNumberLabel setBackgroundColor:UIColorFromRGB(0xfa3e32)];
  self.messageNumberLabel.textColor = [UIColor whiteColor];
  
  UIView *cellLine = [UIView new];
  [self addSubview:cellLine];
  [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self);
    make.right.mas_equalTo(self);
    make.height.mas_equalTo(0.5);
    make.bottom.mas_equalTo(self);
  }];
  _cellLine.backgroundColor = kSeparationLineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  if (selected){
    self.messageNumberLabel.backgroundColor = UIColorFromRGB(0xfa3e32);
  }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
  
  [super setHighlighted:highlighted animated:animated];
  
  if (highlighted){
    self.messageNumberLabel.backgroundColor = UIColorFromRGB(0xfa3e32);
  }
}

- (void)setCellDataWithConversation:(JMSGConversation *)conversation {
  self.headView.layer.cornerRadius = 23;
  [self.headView.layer setMasksToBounds:YES];
  self.nickName.text = conversation.title;
  self.conversationId = [self conversationIdWithConversation:conversation];
  
  [conversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
    if (![objectId isEqualToString:_conversationId]) {
      NSLog(@"out-of-order avatar");
      return ;
    }
    
    if (error == nil) {
      if (data != nil) {
        [self.headView setImage:[UIImage imageWithData:data]];
      } else {
        if (conversation.conversationType == kJMSGConversationTypeSingle) {
          [self.headView setImage:[UIImage imageNamed:@"headDefalt"]];
        } else {
          [self.headView setImage:[UIImage imageNamed:@"talking_icon_group"]];
        }
      }
    } else {
      DDLogDebug(@"fail get avatar");
    }
  }];
  
  if ([conversation.unreadCount integerValue] > 0) {
    [self.messageNumberLabel setHidden:NO];
    self.messageNumberLabel.text = [NSString stringWithFormat:@"%@", conversation.unreadCount];
  } else {
    [self.messageNumberLabel setHidden:YES];
  }
  
  if (conversation.latestMessage.timestamp != nil ) {
    double time = [conversation.latestMessage.timestamp doubleValue];
    self.time.text = [JCHATStringUtils getFriendlyDateString:time forConversation:YES];
  } else {
    self.time.text = @"";
  }
  
  if ([[[JCHATSendMsgManager ins] draftStringWithConversation:conversation] isEqualToString:@""]) {
    self.message.text = conversation.latestMessageContentText;
  } else {

    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[草稿] %@",[[JCHATSendMsgManager ins] draftStringWithConversation:conversation]]];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor redColor]
                        range:NSMakeRange(0, 4)];

    self.message.attributedText = attriString;
  }
}

- (NSString *)conversationIdWithConversation:(JMSGConversation *)conversation {
  NSString *conversationId = nil;
  if (conversation.conversationType == kJMSGConversationTypeSingle) {
    JMSGUser *user = conversation.target;
    conversationId = [NSString stringWithFormat:@"%@_%ld",user.username, kJMSGConversationTypeSingle];
  } else {
    JMSGGroup *group = conversation.target;
    conversationId = [NSString stringWithFormat:@"%@_%ld",group.gid,kJMSGConversationTypeGroup];
  }
  return conversationId;
}


@end
