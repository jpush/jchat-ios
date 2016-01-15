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

#define kCharNumberColor UIColorFromRGB(0xbbbbbb)
#define kBaseLineColor UIColorFromRGB(0x3f80de)
#define kNameTextFieldColor UIColorFromRGB(0x2d2d2d)
#define kSuggestTextColor UIColorFromRGB(0xbbbbbb)
#define kNavigationTittleFrame CGRectMake(0, 0, 150, 44)

static NSInteger const st_nameLengthLime = 30;

@interface JCHATChangeNameViewController ()<UITextFieldDelegate>

@end

@implementation JCHATChangeNameViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.

  [self.charNumber setTextColor:kCharNumberColor];
  self.baseLine.backgroundColor = kBaseLineColor;
  [self.nameTextField setTextColor:kNameTextFieldColor];
  [self.suggestLabel setTextColor:kSuggestTextColor];
  
  [self.nameTextField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:kNavigationTittleFrame];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = [UIFont boldSystemFontOfSize:20];
  titleLabel.textColor = [UIColor whiteColor];
  titleLabel.textAlignment = NSTextAlignmentCenter;

  [self.nameTextField becomeFirstResponder];
  JMSGUser *user = [JMSGUser myInfo];

  switch (_updateType) {
    case kJMSGUserFieldsNickname:
      self.deleteButton.hidden = NO;
      self.charNumber.hidden = NO;
      self.suggestLabel.text = @"好名字可以让你的朋友更加容易记住你";
      self.nameTextField.placeholder = user.nickname?:@"请输入你的姓名";
      [self.nameTextField addTarget:self action:@selector(textFieldDidChangeName) forControlEvents:UIControlEventEditingChanged];
      titleLabel.text = @"修改昵称";
      break;
    case kJMSGUserFieldsBirthday:
      
      break;
    case kJMSGUserFieldsSignature:
      self.suggestLabel.hidden = YES;
//      [self.nameTextField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
      [self.nameTextField addTarget:self action:@selector(textFieldDidChangeName) forControlEvents:UIControlEventEditingChanged];
      
      self.nameTextField.placeholder = user.signature?:@"请输入你的签名";
      titleLabel.text = @"修改签名";
      break;
    case kJMSGUserFieldsGender:
      
      break;
    case kJMSGUserFieldsRegion:
      self.deleteButton.hidden = YES;
      self.charNumber.hidden = YES;
      self.suggestLabel.hidden = YES;
      titleLabel.text = @"修改地区";
      self.nameTextField.placeholder = user.region?:@"请输入你所在的地区";
      break;
    case kJMSGUserFieldsAvatar:
      
      break;
    default:
      break;
  }
  self.navigationItem.titleView = titleLabel;
  [self setupNavigationBar];
}

- (void)setupNavigationBar {
  self.navigationController.navigationBar.translucent = NO;
  UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickToSave)];
  [rightbutton setTintColor:[UIColor whiteColor]];
  self.navigationItem.rightBarButtonItem = rightbutton;
  
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:kNavigationLeftButtonRect];
  [leftBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
  [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
}

- (void)textFieldChange {
  self.charNumber.text = [NSString stringWithFormat:@"%d",self.nameTextField.text.length];
}

- (void)textFieldDidChangeName {
  if (self.nameTextField.text.length > 30) {
    self.nameTextField.text = [self.nameTextField.text substringWithRange:NSMakeRange(0, st_nameLengthLime)];
    [MBProgressHUD showMessage:[NSString stringWithFormat:@"最多输入 %d 个字符",st_nameLengthLime] view:self.view];
    return;
  }
  self.charNumber.text = [NSString stringWithFormat:@"%d",st_nameLengthLime - self.nameTextField.text.length];
}

- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToSave {
  kWEAKSELF
  [JMSGUser updateMyInfoWithParameter:self.nameTextField.text userFieldType:self.updateType completionHandler:^(id resultObject, NSError *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error == nil) {
      [MBProgressHUD showMessage:@"修改成功" view:self.view];
      
      [weakSelf.navigationController popViewControllerAnimated:YES];
    } else {
      [MBProgressHUD showMessage:@"修改失败" view:self.view];
    }
  }];
}

- (IBAction)deleteText:(id)sender {
  if (_updateType == kJMSGUserFieldsSignature) {
    self.nameTextField.text = @"";
    self.charNumber.text = @"0";
  } else {
    self.nameTextField.text = @"";
    self.charNumber.text = [NSString stringWithFormat:@"%ld",st_nameLengthLime];
  }
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
