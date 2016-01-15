//
//  CollectionViewCell.m
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "ThumbImageCollectionViewCell.h"
#import "JCHATPhotoPickerConstants.h"

@interface ThumbImageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UIButton *seletStatusBtn;
@property (strong, nonatomic)JCHATPhotoModel *thumbImageModel;
@property (strong, nonatomic)JCHATPhotoSelectViewController *SelectImagedelegate;
@end

@implementation ThumbImageCollectionViewCell

- (void)awakeFromNib {
  _thumbImage.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setDataWithModel:(JCHATPhotoModel *)model withDelegate:(id)delegate{
  _SelectImagedelegate = delegate;
  _seletStatusBtn.selected = model.isSelected;
  _thumbImageModel = model;
  if (model.asset == nil) {
    PHAsset *asset = model.photoAsset;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(self.frame.size.width * scale, self.frame.size.width * scale);
    [model.cachingManager requestImageForAsset:asset
                                    targetSize:imageSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:nil
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                   if ([_thumbImageModel.photoAsset.localIdentifier isEqualToString:asset.localIdentifier]) {
                                     self.thumbImage.image = result;
                                   }
                                 }];
  } else {
    
    [[[ALAssetsLibrary alloc]init] assetForURL:model.imgURL resultBlock:^(ALAsset *asset)  {
      self.thumbImage.image = [UIImage imageWithCGImage:[asset thumbnail]];
    } failureBlock:^(NSError *error) {
      NSLog(@"error=%@",error);
    }];
  }
}

- (IBAction)selectedStatusChange:(id)sender {
  UIButton *selectBtn = (UIButton *)sender;
  _thumbImageModel.isSelected = !_thumbImageModel.isSelected;
  selectBtn.selected = _thumbImageModel.isSelected;
  [_SelectImagedelegate didSelectStatusChange:_thumbImageModel];
}

@end
