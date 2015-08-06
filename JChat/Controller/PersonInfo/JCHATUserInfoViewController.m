//
//  JCHATUserInfoViewController
//  JPush IM
//
//  Created by Apple on 14/12/25.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATUserInfoViewController.h"
#import "JCHATSettingCell.h"
#import "JCHATPersonViewController.h"
#import "JCHATSettingViewController.h"
#import "JChatConstants.h"
#import "JCHATLoginViewController.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
#import "UIImage+ResizeMagick.h"
#import <JMessage/JMessage.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "JCHATAlreadyLoginViewController.h"
#import "CExpandHeader.h"
#import "UIImageView+LBBlurredImage.h"
#import "JCHATAvatarView.h"
@interface JCHATUserInfoViewController ()

@property(strong, nonatomic) UITableView *settingTableView;
@property(strong, nonatomic) NSArray *titleArr;
@property(strong, nonatomic) NSArray *imgArr;
@property(strong, nonatomic) JCHATAvatarView* bgView;

@end

/**
* 头像更新逻辑：
* 1. 初始化时先用小头像（缩略图）；
* 2. 大头像如果存在，则变更为大头像；
* 3. 大头像如果不存在，则尝试去获取，后续再设置上来。
*/
@implementation JCHATUserInfoViewController {
  CExpandHeader *_header;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");

  [self.view setBackgroundColor:[UIColor clearColor]];

  
  self.settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kApplicationHeight - 45 + kStatusBarHeight) style:UITableViewStylePlain];
  [self.view addSubview:self.settingTableView];
  [self.settingTableView setBackgroundColor:[UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:243 / 255.0 alpha:1]];
  self.settingTableView.dataSource = self;
  self.settingTableView.delegate = self;

  self.settingTableView.tableFooterView = [[UIView alloc] init];

  [self setAvatar];
  
  if ([JMSGUser getMyInfo].nickname) {
    self.titleArr = @[[JMSGUser getMyInfo].nickname, @"设置", @"退出登录"];
  } else if ([JMSGUser getMyInfo].username) {
    self.titleArr = @[[JMSGUser getMyInfo].username, @"设置", @"退出登录"];
  } else {
    self.titleArr = @[@"", @"设置", @"退出登录"];
  }

  self.imgArr = @[@"wo_20", @"setting_22", @"loginOut_17"];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateAvatar)
                                               name:kupdateUserInfo
                                             object:nil];


//  [_bgView setBlurLevel:0.5]x;
}


- (void)setAvatar {
  
  //设置背景图片
  _bgView = [[JCHATAvatarView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, 176)/*(kApplicationHeight) / 2)*/];
  [_bgView setUserInteractionEnabled:YES];


  JMSGUser *user = [JMSGUser getMyInfo];
  
  [JMSGUser getOriginAvatarImage:user
               completionHandler:^(id resultObject, NSError *error) {
                 if (error == nil) {
                   if (user.avatarResourcePath) {
                     UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
                     UIImage *img = [headImg resizedImageByHeight:headImg.size.height];

                     _bgView.originImage = img;
                   } else {
                      _bgView.originImage = [UIImage imageNamed:@"wo.png"];
                   }
                 } else {
                    _bgView.originImage = [UIImage imageNamed:@"wo.png"];
                 }
               }];
  
  if (user.avatarThumbPath) {
    _bgView.originImage = [UIImage imageNamed:user.avatarThumbPath];
  } else {
    _bgView.originImage = [UIImage imageNamed:@"wo.png"];
  }

  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
  [_bgView addGestureRecognizer:gesture];
  _header = [CExpandHeader expandWithScrollView:_settingTableView expandView:_bgView];


}
- (void)updateAvatar {
  DDLogDebug((@"Action - updateAvatar"));

  JMSGUser *user = [JMSGUser getMyInfo];
  [_bgView updataNameLable];
  DDLogDebug(@"Current avatarResourcePath - %@", user.avatarResourcePath);

  if (user.avatarResourcePath) {
    UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
    UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
    _bgView.image = img;
  } else {
    JMSGUser *user = [JMSGUser getMyInfo];
    [JMSGUser getOriginAvatarImage:user completionHandler:^(id resultObject, NSError *error) {
      if (error == nil) {
        JMSGUser *updated = (JMSGUser *) resultObject;
        DDLogDebug(@"UPdated avatarResourcePath - %@", updated.avatarResourcePath);
        if (user.avatarResourcePath) {
          UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
          UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
          _bgView.originImage = img;
        } else {
          _bgView.originImage = [UIImage imageNamed:@"wo"];
        }
      } else {
        _bgView.originImage = [UIImage imageNamed:@"wo"];
      }
    }];
  }
}

- (void)tapPicture:(UIGestureRecognizer *)gesture {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍照", @"相册", nil];
  actionSheet.tag = 201;
  [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {//拍照
    [self cameraClick];
  } else if (buttonIndex == 1) { // 相册
    [self photoClick];
  }
}


#pragma mark -调用相册
-(void)photoClick {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
  picker.mediaTypes = temp_MediaTypes;
  picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark --调用相机
-(void)cameraClick {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *requiredMediaType = ( NSString *)kUTTypeImage;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
    [picker setMediaTypes:arrMediaTypes];
    picker.showsCameraControls = YES;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    picker.editing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
  }
}

#pragma mark - UIImagePickerController Delegate

//相机,相册Finish的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  DDLogDebug(@"Action - imagePickerController");

  [MBProgressHUD showMessage:@"正在上传！" toView:self.view];
  UIImage *image;
  image = [info objectForKey:UIImagePickerControllerOriginalImage];
  JMSGUser *user = [JMSGUser getMyInfo];
  image = [image resizedImageByWidth:upLoadImgWidth];
  [JMSGUser updateMyInfoWithParameter:UIImageJPEGRepresentation(image, 1)
                             withType:kJMSGAvatar
                    completionHandler:^(id resultObject, NSError *error) {
    JPIMMAINTHEAD(^{
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      if (error == nil) {
        [MBProgressHUD showMessage:@"上传成功" view:self.view];
        if (user.avatarResourcePath) {
          DDLogDebug(@"update headView success %@", user);
          UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
          UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
          _bgView.originImage = img;
        } else {
          _bgView.originImage = [UIImage imageNamed:@"wo.png"];
        }
      } else {
        DDLogDebug(@"update headView fail");
        [MBProgressHUD showMessage:@"上传失败!" view:self.view];
      }
    });
  }];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.titleArr count];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  [self.settingTableView reloadData];
  [self.navigationController.navigationBar setHidden:NO];
  [self.navigationController setNavigationBarHidden:NO];
  self.navigationController.navigationBar.barTintColor =kNavigationBarColor;
  self.navigationController.navigationBar.translucent = NO;

  self.title = @"我";
  [_bgView updataNameLable];
  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
  shadow.shadowOffset = CGSizeMake(0, 0);

  NSDictionary *dic = @{
      NSForegroundColorAttributeName:[UIColor whiteColor],
      NSShadowAttributeName:shadow,
      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
  };
  [self.navigationController.navigationBar setTitleTextAttributes:dic];
  self.view.backgroundColor = [UIColor whiteColor];
  self.settingTableView.backgroundColor = [UIColor whiteColor];
  [self updateUserInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:YES];
  [self.navigationController setNavigationBarHidden:NO];
}

// FIXME 这里应该是想要重新拉取一次整个的 MyInfo。但实际上只是重新取了 avatar
- (void)updateUserInfo {
  DDLogDebug(@"Action - updateUserInfo");

  JMSGUser *user = [JMSGUser getMyInfo];
  DDLogDebug(@"Now the avatarResourcePath - %@", user.avatarResourcePath);
  if (user.avatarResourcePath) {
    UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
    UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
    _bgView.originImage = img;
  } else {
    [JMSGUser getOriginAvatarImage:user
                 completionHandler:^(id resultObject, NSError *error) {
      if (error == nil) {
        // 原 userInfo 对象，如果获取成功，avatarResourcePath 被重新赋值了。
        JMSGUser *userObject = (JMSGUser *) resultObject;
        DDLogDebug(@"Updated avatarResourcePath - %@", userObject.avatarResourcePath);
        if (user.avatarResourcePath) {
          UIImage *headImg = [UIImage imageWithContentsOfFile:userObject.avatarResourcePath];
          UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
          [_bgView setImage:img];
          _bgView.originImage = img;
        } else {
          _bgView.originImage = [UIImage imageNamed:@"wo.png"];
        }
      } else {
          _bgView.originImage = [UIImage imageNamed:@"wo.png"];
      }
    }];
  }

  if (user.nickname) {
    self.titleArr = @[user.nickname, @"设置", @"退出登录"];
  } else if (user.username) {
    self.titleArr = @[user.username, @"设置", @"退出登录"];
  } else {
    self.titleArr = @[@"", @"设置", @"退出登录"];
  }

  [self.settingTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"headCell";
  JCHATSettingCell *cell = (JCHATSettingCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATSettingCell" owner:self options:nil] lastObject];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, kApplicationWidth, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(0xd0d0cf)];

  }
  cell.nickNameBtn.text = self.titleArr[indexPath.row];
  cell.headImgView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    JCHATPersonViewController *personCtl = [[JCHATPersonViewController alloc] init];
    personCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personCtl animated:YES];
  } else if (indexPath.row == 1) {
    JCHATSettingViewController *settingCtl = [[JCHATSettingViewController alloc] init];
    settingCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingCtl animated:YES];
  } else if (indexPath.row == 2) {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                       message:@"退出登录!"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    [alerView show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
  } else if (buttonIndex == 1) {
    [MBProgressHUD showMessage:@"正在退出登录！" view:self.view];
    DDLogDebug(@"Logout anyway.");
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    if ([appDelegate.tabBarCtl.loginIdentify isEqualToString:kFirstLogin]) {
//      [self.navigationController.navigationController popToViewController:[self.navigationController.navigationController.childViewControllers objectAtIndex:0] animated:YES];
//    } else {
//      JCHATLoginViewController *loginCtl = [[JCHATLoginViewController alloc] initWithNibName:@"JCHATLoginViewController" bundle:nil];
//      loginCtl.hidesBottomBarWhenPushed = YES;
//      [self.navigationController pushViewController:loginCtl animated:YES];
//    }
    [appDelegate.tabBarCtl setSelectedIndex:0];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [JMSGUser logoutWithCompletionHandler:^(id resultObject, NSError *error) {
      DDLogDebug(@"Logout callback with - %@", error);
    }];
    JCHATAlreadyLoginViewController *loginCtl = [[JCHATAlreadyLoginViewController alloc] init];
    UINavigationController *nvLoginCtl = [[UINavigationController alloc] initWithRootViewController:loginCtl];
    appDelegate.window.rootViewController = nvLoginCtl;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserName];


  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
