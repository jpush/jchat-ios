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
@implementation JCHATAvatarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

    
    self.centeraverter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    self.centeraverter.layer.cornerRadius = 35;
    self.centeraverter.layer.masksToBounds = YES;
    self.centeraverter.center = CGPointMake(self.center.x, self.center.y+20);
    self.centeraverter.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.centeraverter];
    
    _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
    _nameLable.center = CGPointMake(self.center.x, self.center.y+75);
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
  [self setImageToBlur:originImage blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:^(NSError *error) {
    NSLog(@"blur done");
  }];
  
  self.centeraverter.image = originImage;
  
}

@end
