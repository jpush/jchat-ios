//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoLoadingView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "JCHATChatModel.h"
#import "JChatConstants.h"

@interface MJPhotoView ()
{
    BOOL _doubleTap;
    UIImageView *_imageView;
    MJPhotoLoadingView *_photoLoadingView;
}
@end

@implementation MJPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		_imageView = [[UIImageView alloc] init];
		[self addSubview:_imageView];
        
        // 进度条
        _photoLoadingView = [[MJPhotoLoadingView alloc] init];
		
		// 属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;

		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
    }
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(MJPhoto *)photo {
    _photo = photo;
    
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
  if (_photo.firstShow) { // 首次显示
    _imageView.image = _photo.placeholder; // 占位图片
    _photo.srcImageView.image = nil;
    // 不是gif，就马上开始下载
    if (![_photo.url.absoluteString hasSuffix:@"gif"]) {
      __weak MJPhoto *photo = _photo;
      __weak MJPhotoView *photoView = self;
      if (_photo.message.message.msgId) {
        JMSGMessage *message = [_conversation messageWithMessageId:_photo.message.message.msgId];
        [((JMSGImageContent *)message.content) largeImageDataWithProgress:^(float percent,NSString *msgId){
          _photoLoadingView.progress = percent;
        } completionHandler:^(NSData *data,NSString *objectId, NSError *error) {
          if (error == nil) {
            NSLog(@"下载大图 success the image message id is %@",objectId);
            photo.image = [UIImage imageWithData:data];
            _imageView.image = [UIImage imageWithData:data];
            [photoView adjustFrame];
          } else {
            JPIMLog(@"下载大图 error");
            [MBProgressHUD showMessage:@"下载大图失败！" view:self];
            [photoView adjustFrame];
          }
        }];
        
      } else {
        JPIMLog(@"messageid is nil");
      }
    }
  } else {
    [self photoStartLoad];
  }
  // 调整frame参数
  [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    self.scrollEnabled = NO;
        // 直接显示进度条
    _imageView.image = _photo.placeholder; // 占位图片

    [_photoLoadingView showLoading];
    [self addSubview:_photoLoadingView];
    __weak MJPhotoView *photoView = self;

    __weak MJPhoto *photo = _photo;
      if (_photo.message.message) {
        JMSGMessage *message = _photo.message.message;
        [((JMSGImageContent *)message.content) thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
          if (error == nil) {
            _imageView.image = [UIImage imageWithData:data];
          }
        }];
        
        [((JMSGImageContent *)message.content) largeImageDataWithProgress:^(float percent,NSString *msgId){
            _photoLoadingView.progress = percent;
                        } completionHandler:^(NSData *data,NSString *objectId, NSError *error) {
          __strong __typeof(photo)strongPhoto = photo;
          if (error == nil) {
            NSLog(@"下载大图 success the image message id is %@",objectId);
            strongPhoto.image = [UIImage imageWithData:data];
            [photoView photoDidFinishLoadWithImage:strongPhoto.image];
            _imageView.image = strongPhoto.image;
            [photoView adjustFrame];
          } else {
            [MBProgressHUD showMessage:@"下载大图失败!！" view:self];
          }
        }];
      } else {
          JPIMLog(@"messageid is nil");
      }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"Progress is %f", progress.fractionCompleted);
      _photoLoadingView.progress = progress.fractionCompleted;
    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
	if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat widthRatio = boundsWidth/imageWidth;
    CGFloat heightRatio = boundsHeight/imageHeight;
    CGFloat minScale = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    
    if (minScale >= 1) {
		minScale = 0.8;
	}
    
	CGFloat maxScale = 4.0;
    
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // 宽大
    if ( imageWidth <= imageHeight &&  imageHeight <  boundsHeight ) {
        imageFrame.origin.x = floorf( (boundsWidth - imageFrame.size.width ) / 2.0) * minScale;
        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0) * minScale;
    } else{
        imageFrame.origin.x = floorf( (boundsWidth - imageFrame.size.width ) / 2.0);
        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0);
    }
    

    
//    // y值
//    if (imageFrame.size.height < boundsHeight) {
//        
//        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0) * minScale;
//        
////        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0) * minScale;
//        
//	} else {
//        imageFrame.origin.y = 0;
//	}
    
    if (_photo.firstShow) { // 第一次显示的图片
        _photo.firstShow = NO; // 已经显示过了
        
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];

        [UIView animateWithDuration:  0.3  animations:^{
            
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            _photo.srcImageView.image = _photo.placeholder;
            [self photoStartLoad];
        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
	return _imageView;
}

// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                            scrollView.contentSize.height * 0.5 + offsetY);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}

- (void)hide
{
    if (_doubleTap) return;
    
    // 移除进度条
    [_photoLoadingView removeFromSuperview];
    self.contentOffset = CGPointZero;
    
    // 清空底部的小图
    _photo.srcImageView.image = nil;
    
    CGFloat duration = 0.15;
    if (_photo.srcImageView.clipsToBounds) {
        [self performSelector:@selector(reset) withObject:nil afterDelay:duration];
    }
    
    [UIView animateWithDuration:duration + 0.1 animations:^{
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        
        // gif图片仅显示第0张
        if (_imageView.image.images) {
            _imageView.image = _imageView.image.images[0];
        }
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }
    } completion:^(BOOL finished) {
        // 设置底部的小图片
        _photo.srcImageView.image = _photo.placeholder;
        
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
            [self.photoViewDelegate photoViewDidEndZoom:self];
        }
    }];
}

- (void)reset
{
    _imageView.image = _photo.capture;
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
    
}

- (void)dealloc
{
    // 取消请求
    [_imageView setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}
@end