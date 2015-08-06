//
//  JCHATChangeNameViewController.m
//  JChat
//
//  Created by HuminiOS on 15/8/3.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATChangeNameViewController.h"
#import "JChatConstants.h"
#import "MBProgressHUD+Add.h"

@interface JCHATChangeNameViewController ()<UITextFieldDelegate>

@end

@implementation JCHATChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickToSave)];
  [rightbutton setTintColor:[UIColor whiteColor]];
  self.navigationItem.rightBarButtonItem = rightbutton;
  [self.charNumber setTextColor:UIColorFromRGB(0xbbbbbb)];
  self.baseLine.backgroundColor = UIColorFromRGB(0x3f80de);
  [self.nameTextField setTextColor:UIColorFromRGB(0x2d2d2d)];
  [self.suggestLabel setTextColor:UIColorFromRGB(0xbbbbbb)];
//  [self.nameTextField setValue:UIColorFromRGB(0x000000) forKeyPath:@"_placeholderLabel.textColor"];
  [self.nameTextField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = [UIFont boldSystemFontOfSize:20];
  titleLabel.textColor = [UIColor whiteColor];
  titleLabel.textAlignment = NSTextAlignmentCenter;

  JMSGUser *user = [JMSGUser getMyInfo];
  if (self.updateType == 0) {
    self.deleteButton.hidden = YES;
    self.charNumber.hidden = YES;
    self.suggestLabel.text = @"好名字可以让你的朋友更加容易记住你";
    self.nameTextField.placeholder = user.nickname;
//    self.baselineTop.constant = 58;
    titleLabel.text = @"修改姓名";
  }
  if (self.updateType == 4) {
    self.deleteButton.hidden = YES;
    self.charNumber.hidden = YES;
    titleLabel.text = @"修改地区";
//    self.baselineTop.constant = 58;
    self.nameTextField.placeholder = user.region;
  }
  if (self.updateType == 2) {
    self.suggestLabel.hidden = YES;
//    self.nameTextField.delegate = self;
    [self.nameTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];

    self.nameTextField.placeholder = user.signature;
    titleLabel.text = @"修改签名";
  }

  self.navigationItem.titleView = titleLabel;
  
  
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
  [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
//  self.navigationController.interactivePopGestureRecognizer.delegate = self;
  
  
}

- (void)textFieldChange {
  self.charNumber.text = [NSString stringWithFormat:@"%ld",self.nameTextField.text.length];
}
- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickToSave {
  [JMSGUser updateMyInfoWithParameter:self.nameTextField.text withType:self.updateType completionHandler:^(id resultObject, NSError *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error == nil) {
      [MBProgressHUD showMessage:@"修改成功" view:self.view];

      [self.navigationController popViewControllerAnimated:YES];
    } else {
      [MBProgressHUD showMessage:@"修改失败" view:self.view];
    }
  }];
  
}
- (IBAction)deleteText:(id)sender {
  self.nameTextField.text = @"";
  self.charNumber.text = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
