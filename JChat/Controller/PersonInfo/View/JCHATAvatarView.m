//
//  JCHATAvatarView.m
//  JChat
//
//  Created by HuminiOS on 15/7/28.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATAvatarView.h"
#import <JMessage/JMessage.h>
#import "JChatConstants.h"
#import <Accelerate/Accelerate.h>
#import "Masonry.h"
@implementation JCHATAvatarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

//    imageView = [[GPUImageView alloc] initWithFrame:frame];
    imageView = [GPUImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.fillMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self);
      make.left.mas_equalTo(self);
      make.top.mas_equalTo(self);
      make.bottom.mas_equalTo(self);
    }];

 
    self.centeraverter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    self.centeraverter.layer.cornerRadius = 35;
    self.centeraverter.layer.masksToBounds = YES;
    self.centeraverter.center = CGPointMake(self.center.x, self.center.y-15);
    self.centeraverter.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.centeraverter];
    
    _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
    _nameLable.center = CGPointMake(self.center.x, self.center.y+40);
    _nameLable.backgroundColor = [UIColor clearColor];
    _nameLable.font = [UIFont fontWithName:@"helvetica" size:16];
//    _nameLable.text = @"小歪";
    _nameLable.textColor = [UIColor whiteColor];
    _nameLable.shadowColor = [UIColor grayColor];
    _nameLable.textAlignment = NSTextAlignmentCenter;
    _nameLable.shadowOffset = CGSizeMake(-1.0, 1.0);
    JMSGUser *userinfo =  [JMSGUser getMyInfo];
    _nameLable.text = (userinfo.nickname ?userinfo.nickname:(userinfo.username?userinfo.username:@""));
    
    [self addSubview:_nameLable];
  }
  return self;
}

- (void)updataNameLable {
  JMSGUser *userinfo =  [JMSGUser getMyInfo];
  JPIMMAINTHEAD(^{
    _nameLable.text = (userinfo.nickname ?userinfo.nickname:(userinfo.username?userinfo.username:@""));
  });
}


- (void)setOriginImage:(UIImage *)originImage{
  if(!originImage){
    self.image = originImage;
    return;
  }
  self.centeraverter.image = originImage;

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *inputImage = originImage; // The WID.jpg example is greater than 2048 pixels tall, so it fails on older devices
    self.centeraverter.image = originImage;

      sepiaFilter = [[GPUImageiOSBlurFilter alloc] init];
      sepiaFilter.blurRadiusInPixels = 3.0f;

      
      GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:inputImage];
      [picture addTarget:sepiaFilter];
      [sepiaFilter addTarget:imageView];

    dispatch_async(dispatch_get_main_queue(), ^{
          // switch back to the main thread to update your UI
     [picture processImage];
     [imageView setNeedsDisplay];
    });

  });
  

  
}






@end
