//
//  HMPhotoPickerViewController.m
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMPhotoPickerViewController.h"
#import "HMAlbumViewController.h"

@interface HMPhotoPickerViewController ()
@property(strong, nonatomic)HMAlbumViewController *albumVC;
@end

@implementation HMPhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  _albumVC = [[HMAlbumViewController alloc] init];
  _albumVC.photoDelegate = _photoDelegate;
  [self pushViewController:_albumVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
