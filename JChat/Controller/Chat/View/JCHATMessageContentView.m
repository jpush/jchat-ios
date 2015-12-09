//
//  JCHATMessageContentView.m
//  JChat
//
//  Created by HuminiOS on 15/11/2.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATMessageContentView.h"
#import "JChatConstants.h"

static NSInteger const textMessageContentTopOffset = 10;
static NSInteger const textMessageContentRightOffset = 15;

@implementation JCHATMessageContentView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self != nil) {
    
  }
  return self;
}

- (id)init {
  self = [super init];
  if (self != nil) {
    _textContent = [UILabel new];
    _textContent.numberOfLines = 0;
    _textContent.backgroundColor = [UIColor clearColor];
    _voiceConent = [UIImageView new];
    _isReceivedSide = NO;
    [self addSubview:_textContent];
    [self addSubview:_voiceConent];
    self.contentMode = UIViewContentModeScaleAspectFill;
  }
  return self;
}

- (void)setMessageContentWith:(JMSGMessage *)message {
  BOOL isReceived = self.maskBubbleLayer.isReceivedBubble;
  switch (message.contentType) {
    case kJMSGContentTypeText:
      _voiceConent.hidden = YES;
      _textContent.hidden = NO;
      
      [self setImage:nil];
      if (isReceived) {
        [_textContent setFrame:CGRectMake(textMessageContentRightOffset + 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
      } else {
        [_textContent setFrame:CGRectMake(textMessageContentRightOffset - 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
      }
      _textContent.text = ((JMSGTextContent *)message.content).text;
      break;
      
    case kJMSGContentTypeImage:
      _voiceConent.hidden = YES;
      _textContent.hidden = YES;
      if (message.status == kJMSGMessageStatusReceiveDownloadFailed) {
        [self setImage:[UIImage imageNamed:@"receiveFail"]];
      } else {
        [(JMSGImageContent *)message.content thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
          if (error == nil) {
            if (data != nil) {
              [self setImage:[UIImage imageWithData:data]];
            } else {
              [self setImage:[UIImage imageNamed:@"receiveFail"]];
            }
          } else {
            [self setImage:[UIImage imageNamed:@"receiveFail"]];
          }
        }];
      }
      break;
      
    case kJMSGContentTypeVoice:
      _textContent.hidden = YES;
      _voiceConent.hidden = NO;
      [self setImage:nil];
      if (isReceived) {
        [_voiceConent setFrame:CGRectMake(20, 15, 9, 16)];
        [_voiceConent setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying"]];
      } else {
        [_voiceConent setFrame:CGRectMake(self.frame.size.width - 30, 15, 9, 16)];
        [_voiceConent setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"]];
      }
      break;
    case kJMSGContentTypeUnknown:
      _voiceConent.hidden = YES;
      _textContent.hidden = NO;
      
      [self setImage:nil];
      if (isReceived) {
        [_textContent setFrame:CGRectMake(textMessageContentRightOffset + 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
      } else {
        [_textContent setFrame:CGRectMake(textMessageContentRightOffset - 5, textMessageContentTopOffset, self.frame.size.width - 2 * textMessageContentRightOffset, self.frame.size.height- 2 * textMessageContentTopOffset)];
      }
      _textContent.text = st_receiveUnknowMessageDes;
      break;
    default:
      break;
  }
}

@end
