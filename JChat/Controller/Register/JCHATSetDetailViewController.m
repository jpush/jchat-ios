//
//  JCHATSetDetailViewController.m
//  JChat
//
//  Created by HuminiOS on 15/7/14.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATSetDetailViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MBProgressHUD+Add.h"
#import "JChatConstants.h"
#import "AppDelegate.h"
@interface JCHATSetDetailViewController ()<UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
  UILabel *titleLabel;
}

@end

@implementation JCHATSetDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBar.translucent = NO;
  self.navigationItem.hidesBackButton = YES;
  _doneBtn.backgroundColor = UIColorFromRGB(0x6fd66b);
  _doneBtn.layer.cornerRadius = 5;
  _baseLine.backgroundColor = UIColorFromRGB(0xc1d2ec);
  _nameTextF.textColor = UIColorFromRGB(0x555555);
  [_nameTextF becomeFirstResponder];
  _setAvatarBtn.layer.cornerRadius = 28;
  _setAvatarBtn.layer.masksToBounds = YES;
  
  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = [UIFont boldSystemFontOfSize:20];
  titleLabel.textColor = [UIColor whiteColor];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.text = @"输入昵称";
  self.navigationItem.titleView = titleLabel;
}

- (IBAction)clickToFinish:(id)sender {
  NSString *nickName = _nameTextF.text;
  nickName = [nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if (nickName.length == 0) {
    [MBProgressHUD showMessage:@"请输入昵称" view:self.view];
    return;
  }
  
  [JMSGUser updateMyInfoWithParameter:nickName userFieldType:kJMSGUserFieldsNickname completionHandler:^(id resultObject, NSError *error) {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate setupMainTabBar];
    appDelegate.window.rootViewController = appDelegate.tabBarCtl;
  }];
}

- (IBAction)clickToSetAvatar:(id)sender {
  [_nameTextF resignFirstResponder];
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
  
  [MBProgressHUD showMessage:@"正在上传！" toView:self.view];
  __block UIImage *image;
  image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  [JMSGUser updateMyInfoWithParameter:UIImageJPEGRepresentation(image, 1) userFieldType:kJMSGUserFieldsAvatar completionHandler:^(id resultObject, NSError *error) {
    JCHATMAINTHREAD(^{
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      if (error == nil) {
        [MBProgressHUD showMessage:@"上传成功" view:self.view];
        [_setAvatarBtn setBackgroundImage:image forState:UIControlStateNormal];
      } else {
        DDLogDebug(@"update headView fail");
        [MBProgressHUD showMessage:@"上传失败!" view:self.view];
      }
    });
  }];
  [self dismissViewControllerAnimated:YES completion:nil];
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
