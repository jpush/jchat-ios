//
//  HMPhotoSelectViewController.h
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class HMPhotoModel;
@class JCHATPhotoSelectViewController;

@protocol JCHATPhotoPickerViewControllerDelegate <NSObject>

- (void)JCHATPhotoPickerViewController:(JCHATPhotoSelectViewController *)PhotoPickerVC
                 selectedPhotoArray:(NSArray *)selected_photo_array;

@end

@interface JCHATPhotoSelectViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic)id<JCHATPhotoPickerViewControllerDelegate> photoDelegate;
@property (strong,nonatomic) PHFetchResult *allFetchResult;
@property (strong, nonatomic)PHCollection *photoCollection;

@property (strong, nonatomic)ALAssetsGroup *assetsGroup;

- (void)didSelectStatusChange:(HMPhotoModel *)model;
- (void)finshToSelectPhoto:(HMPhotoModel *)model;
@end
