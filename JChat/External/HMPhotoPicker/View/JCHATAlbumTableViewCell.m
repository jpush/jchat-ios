//
//  AlbumTableViewCell.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "JCHATAlbumTableViewCell.h"

@implementation JCHATAlbumTableViewCell

- (void)awakeFromNib {
    // Initialization code
  _albumImage.contentMode = UIViewContentModeScaleAspectFill;
  _albumImage.layer.masksToBounds = YES;
}

- (void)layoutWithAlbumModel:(JCHATAlbumModel *)model {
  _albumImage.image = model.albumImage;
  _albumTittle.text = model.albumTittle;
}

- (void)setDataWithAlbumCollection:(PHCollection *)albumCollection {
  _albumTittle.text = albumCollection.localizedTitle;

  PHFetchResult *albumImagaAssert = [PHAsset fetchAssetsInAssetCollection:albumCollection options:nil];
  
  if (albumImagaAssert.count > 0) {
    PHAsset *imageAsset = albumImagaAssert[albumImagaAssert.count - 1];
    PHCachingImageManager *imageManage = [[PHCachingImageManager alloc] init];
    
    [imageManage requestImageForAsset:imageAsset targetSize:_albumImage.frame.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
      _albumImage.image = result;
    }];
  }
}

- (void)setDataWithAlbumResult:(PHFetchResult *)albumFetchResult {
  _albumTittle.text = @"相机胶卷";
  
  PHFetchResult *albumImagaAssert = albumFetchResult;
  
  if (albumImagaAssert.count > 0) {
    PHAsset *imageAsset = albumImagaAssert[albumImagaAssert.count - 1];
    PHCachingImageManager *imageManage = [[PHCachingImageManager alloc] init];
    [imageManage requestImageForAsset:imageAsset
                           targetSize:_albumImage.frame.size
                          contentMode:PHImageContentModeDefault
                              options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
      _albumImage.image = result;
    }];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  self.backgroundColor = [UIColor whiteColor];
    // Configure the view for the selected state
}

@end
