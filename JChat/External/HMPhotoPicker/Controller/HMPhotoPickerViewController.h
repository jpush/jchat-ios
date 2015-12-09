//
//  HMPhotoPickerViewController.h
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMPhotoSelectViewController.h"
@interface HMPhotoPickerViewController : UINavigationController
@property (weak, nonatomic)id<HMPhotoPickerViewControllerDelegate> photoDelegate;
@end
