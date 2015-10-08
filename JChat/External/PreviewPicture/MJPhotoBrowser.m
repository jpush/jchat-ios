//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "SDWebImageManager+MJ.h"
#import "MJPhotoView.h"
#import "MJPhotoToolbar.h"
#import <JMessage/JMessage.h>
#import "JChatConstants.h"
//#define kPadding 10
#define kPadding 0
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface MJPhotoBrowser () <MJPhotoViewDelegate, MJPhotoToolbarDelegate>
{
    // 滚动的view
	UIScrollView *_photoScrollView;
    // 所有的图片view
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    MJPhotoToolbar * _toolbar;
    NSProgress *_progress;
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
}
@end

@implementation MJPhotoBrowser

#pragma mark - Lifecycle
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
	self.view.backgroundColor = [UIColor blackColor];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.创建UIScrollView
    [self createScrollView];
    
    // 2.创建工具条
    [self createToolbar];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];

    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
}

#pragma mark - 私有方法
#pragma mark 创建工具条
- (void)createToolbar
{
    CGFloat barHeight = 44;
    
//    CGFloat barHeight = 0;
    CGFloat barY = self.view.frame.size.height - barHeight;
    _toolbar = [[MJPhotoToolbar alloc] init];
    _toolbar.Delegate = self;
    _toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.photos = _photos;
    [self.view addSubview:_toolbar];
    [self updateTollbarState];
}

- (void)downLoadThisImage:(NSInteger)ThisImageIndex {
//    MJPhoto *photo = [_photos objectAtIndex:ThisImageIndex];
//    JPIMMessageModel *messageModel = [_conversation getMessage:photo.messageId];
//    if (![[self jsonStringToDictionary:messageModel.content] objectForKey:kimgresource]) {
//        _progress= [NSProgress progressWithTotalUnitCount:100];
//        [_progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
//        [JMSGMessageManager getMetaImageFromMessage:messageModel withConversation:_conversation withProgress:_progress succeedBlock:^(NSData *image) {
//            JPIMMessageModel * model = [_conversation getMessage:photo.messageId];
//            NSLog(@"download img successs %@,",model.content);
//            [_photos removeObjectAtIndex:_currentPhotoIndex];
//            [_photos insertObject:[[self jsonStringToDictionary:messageModel.content] objectForKey:kimgresource] atIndex:_currentPhotoIndex];
//            [self setCurrentPhotoIndex:_currentPhotoIndex];
//        } failBlock:^(NSError *error) {
//            NSLog(@"download img error");
//        }];
//    }
}


#pragma mark --jsonStringTo字典
- (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return content;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  DDLogDebug(@"_progress=  %f", _progress.fractionCompleted);
}

- (void)DeleteThisImage:(NSInteger)ThisImageIndex {
    NSLog(@"ThisImageIndex---%ld", (long)ThisImageIndex );
    NSLog(@"_currentPhotoIndex---%lu", (unsigned long)_currentPhotoIndex );
    if ( ThisImageIndex == 0 ) {
        _currentPhotoIndex = 1;
    }else if ( ThisImageIndex == _currentPhotoIndex ) {
        _currentPhotoIndex = _currentPhotoIndex - 1;
    }else{
        _currentPhotoIndex = _currentPhotoIndex - 1;
    }
    [_photos removeObjectAtIndex: ThisImageIndex];
    [self setCurrentPhotoIndex: _currentPhotoIndex ];
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
	_photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
	[self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    
    // 移除工具条
    [_toolbar removeFromSuperview];
    
    if ( [_delegate respondsToSelector:@selector(CellPhotoImageReload)] ) {
        [_delegate CellPhotoImageReload];
    }
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
    MJPhoto *photo = [_photos objectAtIndex:_currentPhotoIndex];
    photo.url = photoView.photo.url;
    
    MJPhoto *toolbarPhoto = [_toolbar.photos objectAtIndex:_currentPhotoIndex];
    toolbarPhoto.url = photoView.photo.url;
}

#pragma mark 显示照片
- (void)showPhotos
{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
	int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = (int)_photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = (int)_photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
    
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:(int)index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(int)index
{
    MJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    MJPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    photoView.conversation = _conversation;
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(int)index
{
    if (index > 0) {
        MJPhoto *photo = _photos[index - 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
    
    if (index < _photos.count - 1) {
        MJPhoto *photo = _photos[index + 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (MJPhotoView *photoView in _visiblePhotoViews) {
		if (kPhotoViewIndex(photoView) == index) {
           return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (MJPhotoView *)dequeueReusablePhotoView
{
    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
    [self updateTollbarState];
}
@end