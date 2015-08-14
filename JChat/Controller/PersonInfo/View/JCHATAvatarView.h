//
//  JCHATAvatarView.h
//  JChat
//
//  Created by HuminiOS on 15/7/28.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JChatConstants.h"
#import "UIImageView+LBBlurredImage.h"
#import "GPUImage/GPUImage.h"
@interface JCHATAvatarView : UIImageView {
  GPUImageView * imageView;
  GPUImagePicture *sourcePicture;
  GPUImageOutput<GPUImageInput> *sepiaFilter, *sepiaFilter2;
}
@property(strong,nonatomic)UIImage *originImage;
@property(strong,nonatomic)UIImageView *centeraverter;
@property(strong,nonatomic)UILabel *nameLable;
- (void)updataNameLable;
//- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
@end
