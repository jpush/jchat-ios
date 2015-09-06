//
//  JCHATChatTableViewCell.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATChatTableViewCell.h"
#import "JCHATStringUtils.h"

@implementation JCHATChatTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    NSInteger height =0;
    if (kApplicationHeight <=480 ) {
      height = 75;
    }else {
      height = 80;
    }

    NSInteger width = (NSInteger) kApplicationWidth;
    self.headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headDefalt_34"]];
    [self.headView setFrame:CGRectMake(5, height/2 - 46/2, 46, 46)];
    [self addSubview:self.headView];
    
    self.nickName = [[UILabel alloc] init];
    self.nickName.textColor = [UIColor grayColor];
    self.nickName.font = [UIFont boldSystemFontOfSize:15];
    [self.nickName setFrame:CGRectMake(46 +10, height/2 -50/2, width/2, 25)];
    [self addSubview:self.nickName];
    
    self.message = [[UILabel alloc] init];
    self.message.textColor = [UIColor grayColor];
    self.message.font = [UIFont boldSystemFontOfSize:15];
    if (kScreenHeight >= 480) {
      [self.message setFrame:CGRectMake(46 +10 ,
                                        self.nickName.frame.origin.y + self.nickName.frame.size.height,
                                        width*3 / 4, 25)];
    }else {
      [self.message setFrame:CGRectMake(46 +10,
                                        self.nickName.frame.origin.y + self.nickName.frame.size.height,
                                        width*3 / 4, 25)];
    }
    [self addSubview:self.message];
    
    self.time = [[UILabel alloc] init];
    self.time.font = [UIFont systemFontOfSize:13];
    self.time.textColor = [UIColor grayColor];
    self.time.textAlignment = NSTextAlignmentRight;
    [self.time setFrame:CGRectMake(kApplicationWidth - 150 , height/2 - 40/2 -10, 130, 40)];
    [self addSubview:self.time];
    
    self.nickName.textColor = UIColorFromRGB(0x3f80dd);
    self.message.textColor = UIColorFromRGB(0x808080);
    
    self.cellLine=[[UIView alloc] initWithFrame:CGRectMake(0, height-1, kApplicationWidth, 1)];
    [self.cellLine setBackgroundColor:[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1]];
    [self addSubview:self.cellLine];
    
    self.messageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, height/2 - 46/2, 22, 22)];
    [self.messageNumberLabel.layer setMasksToBounds:YES];
    self.messageNumberLabel.layer.cornerRadius = 11;
    self.messageNumberLabel.layer.borderWidth = 1;
    self.messageNumberLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.messageNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.messageNumberLabel setBackgroundColor:UIColorFromRGB(0xfa3e32)];
    self.messageNumberLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.messageNumberLabel];
  }
  return self;
}

- (void)awakeFromNib {
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  if (selected){
    self.messageNumberLabel.backgroundColor = UIColorFromRGB(0xfa3e32);
  }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
  
  [super setHighlighted:highlighted animated:animated];
  
  if (highlighted){
    self.messageNumberLabel.backgroundColor = UIColorFromRGB(0xfa3e32);
  }
}

- (void)setCellDataWithConversation:(JMSGConversation *)conversation {
  self.headView.layer.cornerRadius = 23;
  [self.headView.layer setMasksToBounds:YES];

  if (conversation.conversationType == kJMSGConversationTypeSingle) {
    [self.headView setImage:[UIImage imageNamed:@"headDefalt_34"]];
    self.nickName.text = ((JMSGUser *)conversation.target).nickname?:((JMSGUser *)conversation.target).username;
  } else {
    [self.headView setImage:[UIImage imageNamed:@"talking_icon_group"]];
    self.nickName.text = ((JMSGGroup *)conversation.target).gid;
  }
  [conversation avatarData:^(id resultObject, NSError *error) {
    [self.headView setImage:[UIImage imageWithData:resultObject]];
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
  
  if (conversation.latestMessage.contentType == kJMSGContentTypeUnknown) {
    self.message.text = @"";
    return;
  }

  switch (conversation.latestMessage.contentType) {
    case kJMSGContentTypeText:
      self.message.text = ((JMSGTextContent *)conversation.latestMessage.content).text;
      break;
    case kJMSGContentTypeImage:
      self.message.text = @"[图片]";
      break;
    case kJMSGContentTypeVoice:
    self.message.text = @"[语音]";
    case kJMSGContentTypeEventNotification:
      self.message.text = [((JMSGEventContent *)conversation.latestMessage.content) showEventNotification];
    default:
      break;
  }
}




@end
