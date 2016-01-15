//
//  JCHATAvatarView.m
//  JChat
//
//  Created by HuminiOS on 15/7/28.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATAvatarView.h"
#import "JChatConstants.h"
#import <Accelerate/Accelerate.h>
#import "Masonry.h"
@implementation JCHATAvatarView

#define centerAvatarFrame CGRectMake(0, 0, 70, 70)
#define avaterCenter CGPointMake(self.center.x, self.center.y-15)
#define nameLabelFrame CGRectMake(0, 0, 100, 18)
#define nameLableCenter CGPointMake(self.center.x, self.center.y+40)
#define nameLableFont [UIFont fontWithName:@"helvetica" size:16]

static CGFloat const blurLevel = 22.0f;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    
  }
  
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.centeraverter = [UIImageView new];
    self.centeraverter.layer.cornerRadius = 35;
    [self addSubview:self.centeraverter];
    [self.centeraverter mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self);
      make.size.mas_equalTo(CGSizeMake(70, 70));
      make.bottom.mas_equalTo(self.mas_bottom).with.offset(-70);
    }];
    
    self.centeraverter.layer.masksToBounds = YES;
    self.centeraverter.center = avaterCenter;
    self.centeraverter.contentMode = UIViewContentModeScaleAspectFill;
    
    _nameLable = [UILabel new];
    [self addSubview:_nameLable];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self);
      make.left.mas_equalTo(self.mas_left);
      make.right.mas_equalTo(self.mas_right);
      make.bottom.mas_equalTo(self.mas_bottom).with.offset(-40);
    }];
    _nameLable.backgroundColor = [UIColor clearColor];
    _nameLable.font = nameLableFont;
    _nameLable.textColor = [UIColor whiteColor];
    _nameLable.shadowColor = [UIColor grayColor];
    _nameLable.textAlignment = NSTextAlignmentCenter;
    _nameLable.shadowOffset = CGSizeMake(-1.0, 1.0);
    JMSGUser *userinfo =  [JMSGUser myInfo];
    _nameLable.text = (userinfo.nickname ?userinfo.nickname:(userinfo.username?userinfo.username:@""));

  }
  return self;
}

- (void)setDefoultAvatar {
  _centeraverter.image = [UIImage imageNamed:@"wo_05"];
  self.backgroundColor = UIColorFromRGB(0xe1e1e1);
  
}
- (void)updataNameLable {
  JMSGUser *userinfo =  [JMSGUser myInfo];
  JCHATMAINTHREAD(^{
    _nameLable.text = (userinfo.nickname ?userinfo.nickname:(userinfo.username?userinfo.username:@""));
  });
}

- (void)setOriginImage:(UIImage *)originImage{
  self.centeraverter.image = originImage;
  [self performSelector:@selector(setBlurImage:) withObject:originImage afterDelay:0.01];
}

- (void)setBlurImage:(UIImage *) originImage{
  self.image = [self blurryImage:originImage withBlurLevel:blurLevel];
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
  if (blur < 0.f || blur > 1.f) {
    blur = 0.5f;
  }
  int boxSize = (int)(blur * 100);
  boxSize = boxSize - (boxSize % 2) + 1;
  
  CGImageRef img = image.CGImage;
  
  vImage_Buffer inBuffer, outBuffer;
  vImage_Error error;
  
  void *pixelBuffer;
  
  CGDataProviderRef inProvider = CGImageGetDataProvider(img);
  CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
  
  inBuffer.width = CGImageGetWidth(img);
  inBuffer.height = CGImageGetHeight(img);
  inBuffer.rowBytes = CGImageGetBytesPerRow(img);
  
  inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
  
  pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                       CGImageGetHeight(img));
  
  if(pixelBuffer == NULL)
    NSLog(@"No pixelbuffer");
  
  outBuffer.data = pixelBuffer;
  outBuffer.width = CGImageGetWidth(img);
  outBuffer.height = CGImageGetHeight(img);
  outBuffer.rowBytes = CGImageGetBytesPerRow(img);
  
  error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                     &outBuffer,
                                     NULL,
                                     0,
                                     0,
                                     boxSize,
                                     boxSize,
                                     NULL,
                                     kvImageEdgeExtend);
  
  
  if (error) {
    NSLog(@"error from convolution %ld", error);
  }
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef ctx = CGBitmapContextCreate(
                                           outBuffer.data,
                                           outBuffer.width,
                                           outBuffer.height,
                                           8,
                                           outBuffer.rowBytes,
                                           colorSpace,
                                           kCGImageAlphaNoneSkipLast);
  CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
  UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
  
  //clean up
  CGContextRelease(ctx);
  CGColorSpaceRelease(colorSpace);
  
  free(pixelBuffer);
  CFRelease(inBitmapData);
  
  CGColorSpaceRelease(colorSpace);
  CGImageRelease(imageRef);
  
  return returnImage;
}


@end
