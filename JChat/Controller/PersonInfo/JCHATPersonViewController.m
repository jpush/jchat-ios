//
//  JCHATPersonViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATPersonViewController.h"
#import "JChatConstants.h"
#import "JCHATPersonInfoCell.h"
#import "MBProgressHUD+Add.h"
#import "JCHATChatTable.h"
#import <JMessage/JMessage.h>
#import "JCHATChangeNameViewController.h"

@interface JCHATPersonViewController () <
    TouchTableViewDelegate,
    UIAlertViewDelegate,
    UIGestureRecognizerDelegate,
    UIPickerViewDataSource,
    UIPickerViewDelegate> {

  JCHATChatTable *_personTabl;
  NSArray *_titleArr;
  NSArray *_imgArr;
  NSMutableArray *_infoArr;
  UIPickerView *_genderPicker;
  NSArray *_pickerDataArr;
  NSNumber *_genderNumber;
  BOOL _selectFlagGender;
}
@end


@implementation JCHATPersonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _selectFlagGender = NO;
  DDLogDebug(@"Action - viewDidLoad");
  _genderNumber = [NSNumber numberWithInt:1];
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
  self.navigationController.interactivePopGestureRecognizer.delegate = self;
  self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x3f80dd);
  self.navigationController.navigationBar.alpha = 0.8;
  self.title = @"个人信息";
  [self loadUserInfoData];

  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
  shadow.shadowOffset = CGSizeMake(0, 0);

  NSDictionary *dic = @{
      NSForegroundColorAttributeName:[UIColor whiteColor],
      NSShadowAttributeName:shadow,
      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
  };
  [self.navigationController.navigationBar setTitleTextAttributes:dic];

  UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
  [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮

  _personTabl = [[JCHATChatTable alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
  _personTabl.touchDelegate = self;
  _personTabl.backgroundColor = [UIColor whiteColor];
  _personTabl.scrollEnabled = NO;
  _personTabl.dataSource = self;
  _personTabl.delegate = self;
  _personTabl.separatorStyle = UITableViewCellSeparatorStyleNone;

  [self.view addSubview:_personTabl];

  NSString *name;
  JMSGUser *user = [JMSGUser getMyInfo];
  if (user.nickname) {
    name = user.nickname;
  } else {
    name = user.username;
  }
  
  _genderPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kApplicationWidth, 100)];
  _genderPicker.dataSource = self;
  _genderPicker.delegate = self;
  _genderPicker.tag = 200;
  [self.view addSubview:_genderPicker];

  _titleArr = @[@"用户名", @"性别", @"地区", @"个性签名"];
  _imgArr = @[@"wo_20", @"gender", @"location_21", @"signature"];
  _pickerDataArr = @[@"男", @"女",@"未知"];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

  return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  return [_pickerDataArr count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  return [_pickerDataArr objectAtIndex:row];
}


#pragma mark --选择更改性别
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if (component == 0 && row ==0) {
    _genderNumber = [NSNumber numberWithInt:1];
  }else if (component == 0 && row == 1) {
    _genderNumber = [NSNumber numberWithInt:2];
  }else {
    _genderNumber = [NSNumber numberWithInt:0];
  }

  [_personTabl reloadData];
}

- (void)showResultInfo:(id)resultObject error:(NSError *)error {
  if (error == nil) {
    JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    JMSGUser *user = [JMSGUser getMyInfo];
    if (user.userGender == kJMSGMale) {
      cell.personInfoConten.text = @"男";
    } else if (user.userGender == kJMSGFemale) {
      cell.personInfoConten.text = @"女";
    } else {
      cell.personInfoConten.text = @"未知";
    }
    [MBProgressHUD showMessage:@"修改成功" view:self.view];
  }else {
    [MBProgressHUD showMessage:@"修改失败！" view:self.view];
  }
}

- (void)loadUserInfoData {
  _infoArr = [[NSMutableArray alloc] init];
  NSString *name;
  JMSGUser *user = [JMSGUser getMyInfo];

  if (user.nickname) {
    name = user.nickname;
  } else {
    name = user.username;
  }
  [_infoArr addObject:name];

  if (user.userGender == kJMSGUnknown) {
    [_infoArr addObject:@"未知"];
  } else if (user.userGender == kJMSGMale) {
    [_infoArr addObject:@"男"];
  } else {
    [_infoArr addObject:@"女"];
  }
  if (user.region) {
    [_infoArr addObject:user.region];
  } else {
    [_infoArr addObject:@""];
  }
  if (user.signature) {
    [_infoArr addObject:user.signature];
  } else {
    [_infoArr addObject:@""];
  }
}

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
  if (_selectFlagGender) {
    [JMSGUser updateMyInfoWithParameter:_genderNumber withType:kJMSGGender completionHandler:^(id resultObject, NSError *error) {
      [self showResultInfo:resultObject error:error];
    }];
    _selectFlagGender = NO;
  }
  [self showSelectGenderView:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
  static NSString *cellIdentifier = @"JCHATPersonInfoCell";
  JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATPersonInfoCell" owner:self options:nil] lastObject];
  }
//  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.infoTitleLabel.text = [_titleArr objectAtIndex:indexPath.row];
  cell.personInfoConten.text = [_infoArr objectAtIndex:indexPath.row];
  cell.titleImgView.image = [UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 1) {
    _selectFlagGender = YES;
    [self showSelectGenderView:YES];
  }else {
//    NSArray *titleArr = @[@"输入昵称", @"输入性别", @"输入地区", @"个性签名"];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[titleArr objectAtIndex:indexPath.row] message:nil
//                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//    alertView.tag = indexPath.row;
//    [alertView show];
    JCHATChangeNameViewController *changeNameVC = [[JCHATChangeNameViewController alloc] init];
    if (indexPath.row == 0) {
      changeNameVC.updateType = kJMSGNickname;
    }else if(indexPath.row == 2) {
      changeNameVC.updateType = kJMSGRegion;
    }else if(indexPath.row == 3) {
      changeNameVC.updateType = kJMSGSignature;
    }
    [self.navigationController pushViewController:changeNameVC animated:YES];
  }
}

- (void)showSelectGenderView:(BOOL)flag {
  if (!flag) {
    [UIView animateWithDuration:0.5 animations:^{
      [_genderPicker setFrame:CGRectMake(0, self.view.bounds.size.height, _genderPicker.bounds.size.width, _genderPicker.bounds.size.height)];
    }];
  }else {
    [UIView animateWithDuration:0.5 animations:^{
      [_genderPicker setFrame:CGRectMake(0, self.view.bounds.size.height - _genderPicker.bounds.size.height, _genderPicker.bounds.size.width, _genderPicker.bounds.size.height)];
    }];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  JMSGUser *user = [JMSGUser getMyInfo];
  if (buttonIndex == 1) {
    if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
      [MBProgressHUD showMessage:@"请输入" view:self.view];
      return;
    }
    [[alertView textFieldAtIndex:0] resignFirstResponder];
    if (![[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
      [MBProgressHUD showMessage:@"正在修改" toView:self.view];
      if (alertView.tag == 0) {
        [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text withType:kJMSGNickname completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          if (error == nil) {
            JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
            cell.personInfoConten.text = user.nickname;
            [MBProgressHUD showMessage:@"修改成功" view:self.view];
          } else {
            [MBProgressHUD showMessage:@"修改失败" view:self.view];
          }
        }];
      } else if (alertView.tag == 1) {
        [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text withType:kJMSGGender completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];

          if (error == nil) {
            JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
            if (user.userGender == kJMSGMale) {
              cell.personInfoConten.text = @"男";

            } else if (user.userGender == kJMSGFemale) {
              cell.personInfoConten.text = @"女";
            } else {
              cell.personInfoConten.text = @"未知";
            }
            [MBProgressHUD showMessage:@"修改成功" view:self.view];

          } else {
            [MBProgressHUD showMessage:@"修改失败" view:self.view];
          }
        }];
      } else if (alertView.tag == 2) {
        [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text withType:kJMSGRegion completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          if (error == nil) {
            JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
            cell.personInfoConten.text = user.region;
            [MBProgressHUD showMessage:@"修改成功" view:self.view];
          } else {
            [MBProgressHUD showMessage:@"修改失败" view:self.view];
          }
        }];
      } else if (alertView.tag == 3) {
        [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text withType:kJMSGSignature completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          if (error == nil) {
            [MBProgressHUD showMessage:@"修改成功" view:self.view];
            JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
            cell.personInfoConten.text = user.signature;
          } else {
            [MBProgressHUD showMessage:@"修改失败" view:self.view];
          }
        }];
      }
    }
  }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 57;
}

- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  [self loadUserInfoData];
  [_personTabl reloadData];
  [self.navigationController setNavigationBarHidden:NO];
  // 禁用 iOS7 返回手势
  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:YES];
}


@end
