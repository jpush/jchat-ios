//
//  AlbumTableViewCell.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "HMAlbumModel.h"

@interface HMAlbumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *albumTittle;
@property (weak, nonatomic) PHCollection *albumCollection;

//- (void)setDataWithAlbumCollection:(PHCollection *)albumCollection;
//- (void)setDataWithAlbumResult:(PHFetchResult *)albumFetchResult;
- (void)layoutWithAlbumModel:(HMAlbumModel *)model;
@end
