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
#import <MobileCoreServices/UTCoreTypes.h>
#import "JCHATAlreadyLoginViewController.h"
#import "CExpandHeader.h"
#import "UIImageView+LBBlurredImage.h"
#import "JCHATAvatarView.h"

#define settingTableFrame CGRectMake(0, 0, kApplicationWidth, kApplicationHeight - 45 + kStatusBarHeight)
#define settingTableBackgroupColor [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:243 / 255.0 alpha:1]
#define avatarFrame CGRectMake(0, 0, kApplicationWidth, 0.546 * kApplicationWidth)
#define navicationTitleShadowColor [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1]
#define separateLineFrame CGRectMake(0, 56, kApplicationWidth, 0.5)
#define separateLineColor UIColorFromRGB(0xd0d0cf)

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
  self.navigationController.navigationBar.translucent = NO;
  
  [self.view setBackgroundColor:[UIColor clearColor]];
  self.settingTableView = [[UITableView alloc] initWithFrame:settingTableFrame style:UITableViewStylePlain];
  [self.view addSubview:self.settingTableView];
  [self.settingTableView setBackgroundColor:settingTableBackgroupColor];
  self.settingTableView.dataSource = self;
  self.settingTableView.delegate = self;
  self.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.settingTableView.tableFooterView = [[UIView alloc] init];
  
  [self setAvatar];
  NSLog(@"huangmin  user %@",[JMSGUser myInfo]);
  if ([JMSGUser myInfo].nickname) {
    self.titleArr = @[[JMSGUser myInfo].nickname, @"设置", @"退出登录"];
  } else if ([JMSGUser myInfo].username) {
    self.titleArr = @[[JMSGUser myInfo].username, @"设置", @"退出登录"];
  } else {
    self.titleArr = @[@"", @"设置", @"退出登录"];
  }
  
  self.imgArr = @[@"wo_20", @"setting_22", @"loginOut_17"];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateAvatar)
                                               name:kupdateUserInfo
                                             object:nil];
}

- (void)setAvatar {
  //设置背景图片
  _bgView = [[JCHATAvatarView alloc] initWithFrame:avatarFrame];
  [_bgView setUserInteractionEnabled:YES];
  
  [self updateAvatar];
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
  [_bgView addGestureRecognizer:gesture];
  _header = [CExpandHeader expandWithScrollView:_settingTableView expandView:_bgView];
}

- (void)updateAvatar {
  DDLogDebug((@"Action - updateAvatar"));
  JMSGUser *user = [JMSGUser myInfo];
  [_bgView updataNameLable];
  
  [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
    if (error == nil) {
      if (data != nil) {
        _bgView.originImage = [UIImage imageWithData:data];
      } else {
        [_bgView setDefoultAvatar];
      }
    } else {
      DDLogDebug(@"Action -- largeAvatarData");
      [_bgView setDefoultAvatar];
    }
  }];
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
- (void)photoClick {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
  picker.mediaTypes = temp_MediaTypes;
  picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark --调用相机
- (void)cameraClick {
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
  __typeof(self) weakSelf = self;
  [MBProgressHUD showMessage:@"正在上传！" toView:self.view];
  __block UIImage *image;
  image = [info objectForKey:UIImagePickerControllerOriginalImage];
  image = [image resizedImageByWidth:upLoadImgWidth];
  
  [JMSGUser updateMyInfoWithParameter:UIImageJPEGRepresentation(image, 1) userFieldType:kJMSGUserFieldsAvatar completionHandler:^(id resultObject, NSError *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (error == nil) {
      JMSGUser *user = [JMSGUser myInfo];
      [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil) {
          weakSelf.bgView.originImage = [UIImage imageWithData:data];
        } else {
          DDLogDebug(@"Action -- largeAvatarData");
        }
      }];
      weakSelf.bgView.originImage = image;
      DDLogDebug(@"update headView success");
      [MBProgressHUD showMessage:@"上传成功" view:self.view];
    } else {
      DDLogDebug(@"update headView fail %@",error);
      [MBProgressHUD showMessage:@"上传失败!" view:self.view];
    }
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
  
  self.title = @"我";
  
  [_bgView updataNameLable];
  
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
  JMSGUser *user = [JMSGUser myInfo];
  [self updateAvatar];
  if (user.username) {
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UILabel *line = [[UILabel alloc] initWithFrame:separateLineFrame];
    [line setBackgroundColor:separateLineColor];
  }
  
  cell.nickNameBtn.text = self.titleArr[indexPath.row];
  cell.headImgView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.selected = NO;
  
  switch (indexPath.row) {
    case 0:
    {
      JCHATPersonViewController *personCtl = [[JCHATPersonViewController alloc] init];
      personCtl.hidesBottomBarWhenPushed = YES;
      [self.navigationController pushViewController:personCtl animated:YES];
    }
      break;
    case 1:
    {
      JCHATSettingViewController *settingCtl = [[JCHATSettingViewController alloc] init];
      settingCtl.hidesBottomBarWhenPushed = YES;
      [self.navigationController pushViewController:settingCtl animated:YES];
    }
      break;
    case 2:
    {
      UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"退出登录!"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
      [alerView show];
    }
      break;
    default:
      break;
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
  } else if (buttonIndex == 1) {
    [MBProgressHUD showMessage:@"正在退出登录！" view:self.view];
    DDLogDebug(@"Logout anyway.");
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate.tabBarCtl setSelectedIndex:0];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [JMSGUser logout:^(id resultObject, NSError *error) {
      if (error == nil) {
        DDLogDebug(@"Action logout success");
      }
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
