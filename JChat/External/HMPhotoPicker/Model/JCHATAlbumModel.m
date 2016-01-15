//
//  HMAlbumModel.m
//  JChat
//
//  Created by oshumini on 15/12/1.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATAlbumModel.h"

#define kAlbumImageSize CGSizeMake(55, 54)
@implementation JCHATAlbumModel

- (void)setDataWithAssets:(ALAssetsGroup *)assetsGroup {
  _assetsGroup = assetsGroup;
  _albumImage = [UIImage imageWithCGImage:assetsGroup.posterImage];
  _albumTittle = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
  _albumCount = assetsGroup.numberOfAssets;
}

- (void)setDataWithAlbumCollection:(PHCollection *)albumCollection {
  _albumCollection = albumCollection;
  _albumTittle = albumCollection.localizedTitle;
  PHFetchResult *albumImagaAssert = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)albumCollection options:nil];
  
  if (albumImagaAssert.count > 0) {
    PHAsset *imageAsset = albumImagaAssert[albumImagaAssert.count - 1];
    PHCachingImageManager *imageManage = [[PHCachingImageManager alloc] init];
    
    [imageManage requestImageForAsset:imageAsset targetSize:kAlbumImageSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
      _albumImage = result;
    }];
  }
}

- (void)setDataWithAlbumResult:(PHFetchResult *)albumFetchResult {
  _albumFetchResult = albumFetchResult;
  _albumTittle = @"相机胶卷";
  
  if (_albumFetchResult.count > 0) {
    PHAsset *imageAsset = _albumFetchResult[_albumFetchResult.count - 1];
    PHCachingImageManager *imageManage = [[PHCachingImageManager alloc] init];
    [imageManage requestImageForAsset:imageAsset
                           targetSize:kAlbumImageSize
                          contentMode:PHImageContentModeDefault
                              options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                _albumImage = result;
                              }];
  }
}

@end
