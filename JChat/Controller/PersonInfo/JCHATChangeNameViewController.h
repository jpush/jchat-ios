//
//  JCHATChangeNameViewController.h
//  JChat
//
//  Created by HuminiOS on 15/8/3.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATChangeNameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIView *baseLine;
@property (weak, nonatomic) IBOutlet UILabel *suggestLabel;
@property (weak, nonatomic) IBOutlet UILabel *charNumber;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (assign, nonatomic)JMSGUserField updateType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baselineTop;

@end
