//
//  JCHATUserInfoViewController
//  JPush IM
//
//  Created by Apple on 14/12/25.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATUserInfoViewController : UIViewController <
    UITableViewDataSource,
    UITableViewDelegate,
    UIAlertViewDelegate,
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate>

- (void)updateUserInfo;


@end
