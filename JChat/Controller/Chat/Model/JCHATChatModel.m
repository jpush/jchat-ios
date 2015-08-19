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
    self.readState=NO;
    self.sendFlag =YES;
    self.isSending = NO;
  }
  return self;
}

-(float )getTextHeight {
  if (self.type == kJMSGTextMessage || self.type == kJMSGEventMessage || self.type == kJMSGTimeMessage) {
    UIFont *font =[UIFont systemFontOfSize:18];
    CGSize maxSize = CGSizeMake(200, 2000);
    
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize realSize = [self.chatContent boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    //        CGSize realSize =[self.chatContent sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    CGSize imgSize =realSize;
    imgSize.height=realSize.height+20;
    imgSize.width=realSize.width+2*15;
    return imgSize.height;
  }else{
    return CGSizeZero.height;
  }
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
//  if (IS_IPHONE_6P) {
//    imgHeight = img.size.height / 3;
//    imgWidth = img.size.width /3;
//  } else {
//    imgHeight = img.size.height / 2 ;
//    imgWidth = img.size.width /2;
//  }

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
  return  CGSizeMake(imgWidth, imgHeight);

}
@end
