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

@implementation JCHATChatModel
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.readState = YES;
    self.sendFlag = YES;
    self.isSending = NO;
  }
  return self;
}

-(void)setChatModelWith:(JMSGMessage *)message conversationType:(JMSGConversation *)conversation {
  _chatType = conversation.conversationType;
  _messageId = message.msgId;
  _fromId = message.fromUser.username;
  _type = message.contentType;
  _isMyMessage = ![message isReceivedSide];
  _messageStatus = message.status;
  _messageTime = message.timestamp;
  _sendFlag = NO;
  _isSending =NO;
  _conversation = conversation;
  if (_chatType == kJMSGConversationTypeSingle) {
    _targetId = ((JMSGUser *)message.target).username;
    _displayName =  [((JMSGUser *)message.target) displayName];
  }else {
    _targetId = ((JMSGGroup *)message.target).gid;//
    _displayName = [((JMSGGroup *)message.target) displayName];
  }
  _chatContent =@"";
  switch (_type) {
    case kJMSGContentTypeText:
    {
      _chatContent = ((JMSGTextContent *)message.content).text;
    }
      break;
    case kJMSGContentTypeImage:
    {
      _pictureThumbImgPath = ((JMSGImageContent *)message.content).thumbImagePath;
      _pictureImgPath = ((JMSGImageContent *)message.content).largeImagePath;
        __weak __typeof(self)weakSelf = self;
      [message thumbImageData:^(id resultObject, NSError *error) {
        NSLog(@"huangmin   thumbimagedata  %@",resultObject);
        if (error == nil) {

          _mediaData = resultObject;
          [weakSelf getImageSize];
        }else {
          DDLogDebug(@"get thumbImageData fail,with error %@",error);
        }
      }];
    }
      break;
    case kJMSGContentTypeVoice:
    {
      _voicePath = ((JMSGVoiceContent *)message.content).voicePath;
      _voiceTime = [NSString stringWithFormat:@"%@",((JMSGVoiceContent *)message.content).duration];
      [message voiceData:^(id resultObject, NSError *error) {
        if (error == nil) {
          _mediaData = resultObject;
        }else {
          DDLogDebug(@"get message voiceData fail");
        }
      }];
    }
      break;
    case kJMSGContentTypeEventNotification:
    {
      _chatContent = [((JMSGEventContent *)message.content) showEventNotification];
    }
      break;
    default:
      break;
  }
  
  __weak __typeof(self)weakSelf = self;
  [message.fromUser thumbAvatarData:^(id resultObject, NSError *error) {
    if (error == nil) {
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      strongSelf.avatar = resultObject;
    }else {
      DDLogDebug(@"get thumbAvatarData fail with error %@",error);
    }
  }];
  [self getTextHeight];
}

-(float )getTextHeight {
  if (self.type == kJMSGContentTypeText || self.type == kJMSGContentTypeEventNotification || self.type == kJMSGContentTypeTime) {
    UIFont *font =[UIFont systemFontOfSize:18];
    CGSize maxSize = CGSizeMake(200, 2000);
    
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize realSize = [self.chatContent boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    CGSize imgSize =realSize;
    imgSize.height=realSize.height+20;
    imgSize.width=realSize.width+2*15;
    self.contentHeight = imgSize.height;

  }else{
    self.contentHeight = CGSizeZero.height;
  }
  return self.contentHeight;
}



-(CGSize)getImageSize {

  UIImage *img;
  if ([[NSFileManager defaultManager] fileExistsAtPath:self.pictureThumbImgPath]) {
    img = [UIImage imageWithContentsOfFile:self.pictureThumbImgPath];
  }else if (self.mediaData) {
    img = [UIImage imageWithData:self.mediaData];
  }else {
    img = [UIImage imageNamed:@"receiveFail.png"];
    return img.size;
  }
  float imgHeight;
  float imgWidth;
  if (img.size.height >= img.size.width) {
    imgHeight = 135;
    imgWidth = (img.size.width/img.size.height) *imgHeight;
  }else {
    imgWidth = 135;
    imgHeight = (img.size.height/img.size.width) *imgWidth;
  }
  if ((imgWidth > imgHeight?imgHeight/imgWidth:imgWidth/imgHeight)<0.47) {
    return imgWidth > imgHeight?CGSizeMake(135, 55):CGSizeMake(55, 135);//CGSizeMake(55, 135);
  }
  self.imageSize = CGSizeMake(imgWidth, imgHeight);
  return  self.imageSize;
}
@end
