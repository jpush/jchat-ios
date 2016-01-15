//
//  HMThumbImageModel.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "JCHATPhotoModel.h"

@implementation JCHATPhotoModel
- (instancetype)init
{
  self = [super init];
  if (self) {
    _isSelected = NO;
    _isOriginPhoto = NO;
  }
  return self;
}

- (void)setDatawithAsset:(ALAsset *)asset {
  _asset = asset;
  _imgURL = asset.defaultRepresentation.url;
  CGSize imgSize;
  if (_isOriginPhoto) {
    
  } else {
    
  }
  
}

- (void)setDataWithPhotoAsset:(PHAsset *)asset imageManager:(PHCachingImageManager *)imageManager {
  _cachingManager = imageManager;
  _photoAsset = asset;
  CGSize imgSize;
  
  if (_isOriginPhoto) {
    imgSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
  } else {
    imgSize = [[UIScreen mainScreen] bounds].size;
    CGFloat imgScale = [[UIScreen mainScreen] scale];
    imgSize = CGSizeMake(imgSize.width * imgScale, imgSize.height * imgScale);
  }
  
  _largeImageSize = imgSize;
}

- (void)setIsSelected:(BOOL)isSelected {
  _isSelected = isSelected;
  
  if (isSelected) {
    if (_asset == nil) {
      CGSize originSize = CGSizeMake(_photoAsset.pixelHeight/2, _photoAsset.pixelWidth/2);//改一下 720 width
      _largeImageSize = originSize;
      PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
      options.synchronous  = YES;
      [_cachingManager requestImageForAsset:_photoAsset
                                 targetSize:[self fetchImageSizeWithOriginSize:originSize]
                                contentMode:PHImageContentModeAspectFill
                                    options:options
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                _largeImage = result;
                              }];//rename
    } else {
      [[[ALAssetsLibrary alloc]init] assetForURL:_imgURL resultBlock:^(ALAsset *asset)  {
        _largeImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
      }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
      }];
    }
  } else {
    _largeImage = nil;
  }
}

- (void)setIsOriginPhoto:(BOOL)isOriginPhoto {
  _isOriginPhoto = isOriginPhoto;
  
  if (_isSelected) {
    if (_asset == nil) {
      CGSize originSize = CGSizeMake(_photoAsset.pixelWidth, _photoAsset.pixelHeight);
      _largeImageSize = originSize;
      PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
      options.synchronous  = YES;
      [_cachingManager requestImageForAsset:_photoAsset
                                 targetSize:[self fetchImageSizeWithOriginSize:originSize]//imgSize
                                contentMode:PHImageContentModeDefault
                                    options:options
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                _largeImage = result;
                              }];
    }
  }
}

- (CGSize)fetchImageSizeWithOriginSize:(CGSize)originSize {
  CGFloat scale = originSize.width/originSize.height;
  CGSize fetchSize;
  if (scale > 1) {//长图
    fetchSize = CGSizeMake(1280, 1280 / scale );
  } else {
    fetchSize = CGSizeMake(720 * scale, 720);
  }
  return fetchSize;
}


@end
