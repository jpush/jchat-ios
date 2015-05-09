//
//  GroupPersonView.h
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupPersonDelegate <NSObject>
- (void)groupPersonBtnClick:(UIView *)personView;
@end

@interface JCHATGroupPersonView : UIView
@property (weak, nonatomic) IBOutlet UILabel *memberLable;
@property (weak, nonatomic) IBOutlet UIButton *deletePersonBtn;
@property (weak, nonatomic) IBOutlet UIButton *headViewBtn;
@property (strong, nonatomic) id <GroupPersonDelegate> delegate;

@end
