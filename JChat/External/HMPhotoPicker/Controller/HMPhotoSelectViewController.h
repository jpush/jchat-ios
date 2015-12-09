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

@class HMPhotoSelectViewController;

@protocol HMPhotoPickerViewControllerDelegate <NSObject>

- (void)HMPhotoPickerViewController:(HMPhotoSelectViewController *)PhotoPickerVC
                 selectedPhotoArray:(NSArray *)selected_photo_array;

@end

@interface HMPhotoSelectViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic)id<HMPhotoPickerViewControllerDelegate> photoDelegate;
@property (strong,nonatomic) PHFetchResult *allFetchResult;
@property (strong, nonatomic)PHCollection *photoCollection;

@property (strong, nonatomic)ALAssetsGroup *assetsGroup;
@end
