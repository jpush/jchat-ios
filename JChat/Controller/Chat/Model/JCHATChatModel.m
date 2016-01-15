//
//  JCHATChatModel.m
//  test project
//
//  Created by guan jingFen on 14-3-10.
//  Copyright (c) 2014年 guan jingFen. All rights reserved.
//

#import "JCHATChatModel.h"
#import "JChatConstants.h"
#define headHeight 46

static NSInteger const voiceBubbleHeight = 50;

@implementation JCHATChatModel
- (instancetype)init
{
  self = [super init];
  if (self) {
    _isTime = NO;
  }
  return self;
}

- (void)setChatModelWith:(JMSGMessage *)message conversationType:(JMSGConversation *)conversation {
  _message = message;
  _messageTime = message.timestamp;
  
  switch (message.contentType) {
    case kJMSGContentTypeUnknown:
    {
      if (message.content == nil) {
        [self getTextHeight];
      }
    }
      break;
    case kJMSGContentTypeText:
    {
      [self getTextHeight];
    }
      break;
    case kJMSGContentTypeImage:
    {
      
      [((JMSGImageContent *)message.content) thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil) {
          [self setupImageSize];
        } else {
          DDLogDebug(@"get thumbImageData fail,with error %@",error);
        }
      }];
    }
      break;
    case kJMSGContentTypeVoice:
    {
      [self setupVoiceSize:((JMSGVoiceContent *)message.content).duration];
      [((JMSGVoiceContent *)message.content) voiceData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil) {
        } else {
          DDLogDebug(@"get message voiceData fail with error %@",error);
        }
      }];
    }
      break;
    case kJMSGContentTypeEventNotification:
    {
    }
      break;
    default:
      break;
  }
  
  [self getTextHeight];
}

- (void)setErrorMessageChatModelWithError:(NSError *)error{
  _isErrorMessage = YES;
  _messageError = error;
  [self getTextSizeWithString:st_receiveErrorMessageDes];
}

- (float)getTextHeight {
  switch (self.message.contentType) {
    case kJMSGContentTypeUnknown:
    {
      [self getTextSizeWithString:st_receiveUnknowMessageDes];
    }
      break;
    case kJMSGContentTypeText:
    {
      [self getTextSizeWithString:((JMSGTextContent *)self.message.content).text];
    }
      break;
    case kJMSGContentTypeImage:
    {
    }
      break;
    case kJMSGContentTypeVoice:
    {
    }
      break;
    case kJMSGContentTypeEventNotification:
    {
//      [self getTextSizeWithString:[((JMSGEventContent *)self.message.content) showEventNotification]];
      [self getNotificationWithString:[((JMSGEventContent *)self.message.content) showEventNotification]];
    }
      break;
    default:
      break;
  }
  
  return self.contentHeight;
}

- (CGSize)getTextSizeWithString:(NSString *)string {
  CGSize maxSize = CGSizeMake(200, 2000);
  UIFont *font =[UIFont systemFontOfSize:18];
  NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
  CGSize realSize = [string boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
  CGSize imgSize =realSize;
  imgSize.height=realSize.height+20;
  imgSize.width=realSize.width+2*15;
  _contentSize = imgSize;
  _contentHeight = imgSize.height;
  return imgSize;
}

- (CGSize)getNotificationWithString:(NSString *)string {
  CGSize notiSize= [JCHATStringUtils stringSizeWithWidthString:string withWidthLimit:280 withFont:[UIFont systemFontOfSize:14]];
  _contentHeight = notiSize.height;
  _contentSize = notiSize;
  return notiSize;
}

- (void)setupImageSize {
  if (self.message.status == kJMSGMessageStatusReceiveDownloadFailed) {
    _contentSize = CGSizeMake(77, 57);
    return;
  }
  
  [((JMSGImageContent *)self.message.content) thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
    if (error == nil) {
      UIImage *img = [UIImage imageWithData:data];
      float imgHeight;
      float imgWidth;
      
      if (img.size.height >= img.size.width) {
        imgHeight = 135;
        imgWidth = (img.size.width/img.size.height) *imgHeight;
      } else {
        imgWidth = 135;
        imgHeight = (img.size.height/img.size.width) *imgWidth;
      }
      
      if ((imgWidth > imgHeight?imgHeight/imgWidth:imgWidth/imgHeight)<0.47) {
        self.imageSize = imgWidth > imgHeight?CGSizeMake(135, 55):CGSizeMake(55, 135);//
        _contentSize = imgWidth > imgHeight?CGSizeMake(135, 55):CGSizeMake(55, 135);
        return;
      }
      self.imageSize = CGSizeMake(imgWidth, imgHeight);
      _contentSize = CGSizeMake(imgWidth, imgHeight);
    } else {
      NSLog(@"get thumbImageData fail with error %@",error);
    }
  }];
}

- (float)getLengthWithDuration:(NSInteger)duration {
  NSInteger voiceBubbleWidth = 0;
  
  if (duration <= 2) {
    voiceBubbleWidth = 60;
  } else if (duration >2 && duration <=20) {
    voiceBubbleWidth = 60 + 2.5 * duration;
  } else if (duration > 20 && duration < 30){
    voiceBubbleWidth = 110 + 2 * (duration - 20);
  } else if (duration >30  && duration < 60) {
    voiceBubbleWidth = 130 + 1 * (duration - 30);
  } else {
    voiceBubbleWidth = 160;
  }
  
  _contentSize = CGSizeMake(voiceBubbleWidth, voiceBubbleHeight);
  return voiceBubbleWidth;
}

- (void)setupVoiceSize:(NSNumber *)timeduration {
  NSInteger voiceBubbleWidth = 0;
  NSInteger duration = [timeduration integerValue];
  
  if (duration <= 2) {
    voiceBubbleWidth = 60;
  } else if (duration >2 && duration <=20) {
    voiceBubbleWidth = 60 + 2.5 * duration;
  } else if (duration > 20 && duration < 30){
    voiceBubbleWidth = 110 + 2 * (duration - 20);
  } else if (duration >30  && duration < 60) {
    voiceBubbleWidth = 130 + 1 * (duration - 30);
  } else {
    voiceBubbleWidth = 160;
  }
  _contentSize = CGSizeMake(voiceBubbleWidth, voiceBubbleHeight);
}
@end
