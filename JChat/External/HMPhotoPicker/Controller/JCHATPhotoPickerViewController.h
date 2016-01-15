//
//  HMPhotoPickerViewController.h
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATPhotoSelectViewController.h"
@interface JCHATPhotoPickerViewController : UINavigationController
@property (weak, nonatomic)id<JCHATPhotoPickerViewControllerDelegate> photoDelegate;
@end
