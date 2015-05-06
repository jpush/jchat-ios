//
//  JPIMMore.h
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddBtnDelegate <NSObject>
@optional
-(void)photoClick;
-(void)cameraClick;
@end
@interface JPIMMoreView : UIView
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (assign, nonatomic)  id<AddBtnDelegate>delegate;

@end
