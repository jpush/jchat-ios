//
//  JCHATAlreadyLoginViewController.h
//  JPush IM
//
//  Created by Apple on 15/2/2.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMSGUser.h>
@interface JCHATAlreadyLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *userName;

@end
