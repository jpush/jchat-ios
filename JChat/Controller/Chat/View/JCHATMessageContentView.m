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
    [self attachTapHandler];

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
  }
  return self;
}

- (void)setMessageContentWith:(JMSGMessage *)message {
  BOOL isReceived = [message isReceived];
  _message = message;
  UIImageView *maskView = nil;
  UIImage *maskImage = nil;
  if (isReceived) {
    maskImage = [UIImage imageNamed:@"otherChatBg"];
  } else {
    maskImage = [UIImage imageNamed:@"mychatBg"];
  }
  maskImage = [maskImage resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];
  [self setImage:maskImage];
  maskView = [UIImageView new];
  maskView.image = maskImage;
  [maskView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
  self.layer.mask = maskView.layer;
  self.contentMode = UIViewContentModeScaleToFill;
  switch (message.contentType) {
    case kJMSGContentTypeText:
      _voiceConent.hidden = YES;
      _textContent.hidden = NO;
      
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
      self.contentMode = UIViewContentModeScaleAspectFill;
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

- (BOOL)canBecomeFirstResponder{
  return YES;
}

-(void)attachTapHandler{
  self.userInteractionEnabled = YES;  //用户交互的总开关
  UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  touch.minimumPressDuration = 1.0;
  [self addGestureRecognizer:touch];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer {
  [self becomeFirstResponder];
  [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
  [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  if (_message.contentType == kJMSGContentTypeVoice) {
    return action == @selector(delete:);
  }
  return (action == @selector(copy:) || action == @selector(delete:));
}

-(void)copy:(id)sender {
  __block UIPasteboard *pboard = [UIPasteboard generalPasteboard];
  switch (_message.contentType) {
    case kJMSGContentTypeText:
    {
      JMSGTextContent *textContent = (JMSGTextContent *)_message.content;
      pboard.string = textContent.text;
    }
      break;
      
    case kJMSGContentTypeImage:
    {
      JMSGImageContent *imgContent = (JMSGImageContent *)_message.content;
      [imgContent thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
        if (data == nil || error) {
          UIWindow *myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
          [MBProgressHUD showMessage:@"获取图片错误" view:myWindow];
          return ;
        }
        pboard.image = [UIImage imageWithData:data];
      }];
    }
      break;
      
    case kJMSGContentTypeVoice:
      break;
    case kJMSGContentTypeUnknown:
      break;
    default:
      break;
  }
  
}

-(void)delete:(id)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteMessage object:_message];
}
@end
