//
//  JCHATUpdatePasswordCtl.h
//  JPush IM
//
//  Created by Apple on 15/2/5.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATUpdatePasswordCtl : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *pressBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldpassword;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFieldAgain;
@property (weak, nonatomic) IBOutlet UILabel *separateLine1;

@property (weak, nonatomic) IBOutlet UILabel *separateLine2;
@property (weak, nonatomic) IBOutlet UILabel *separateLine3;

@end
