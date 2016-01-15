//
//  HMAlbumViewController.h
//  photosFramework
//
//  Created by HuminiOS on 15/11/11.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "JCHATPhotoSelectViewController.h"
@interface JCHATAlbumViewController : UIViewController
@property (weak, nonatomic)id<JCHATPhotoPickerViewControllerDelegate> photoDelegate;
@end
