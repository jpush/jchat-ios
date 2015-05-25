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
#import "JCHATLoginViewController.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JCHATFileManager.h"
#import "UIImageView+MJWebCache.h"
#import "UIImage+ResizeMagick.h"
#import <JMessage/JMessage.h>

@interface JCHATUserInfoViewController ()

@property (strong, nonatomic) UITableView *settingTableView;
@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) NSArray *imgArr;
@property (strong, nonatomic) UIImageView *bgView;

@end

@implementation JCHATUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JPIMLog(@"Action");
    [self.view setBackgroundColor:[UIColor clearColor]];
    //设置背景图片
    _bgView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, (kApplicationHeight)/2)];
    [_bgView setUserInteractionEnabled:YES];
    [_bgView setBackgroundColor:[UIColor clearColor]];
    [_bgView setImage:[UIImage imageNamed:@"wo.png"]];
    JMSGUser *user = [JMSGUser getMyInfo];
    [JMSGUser getOriginAvatarImage:user completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            if (user.avatarResourcePath) {
                UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
                UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
                [_bgView setImage:img];            }else {
                [_bgView setImage:[UIImage imageNamed:@"wo.png"]];
            }
        }else {
            [_bgView setImage:[UIImage imageNamed:@"wo.png"]];
        }
    }];
    if (user.avatarThumbPath) {
        [_bgView setImage:[UIImage imageNamed:user.avatarThumbPath]];
    }else {
        [_bgView setImage:[UIImage imageNamed:@"wo.png"]];
        }
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
    [_bgView addGestureRecognizer:gesture];
    
    self.settingTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kApplicationHeight-45+kStatusBarHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.settingTableView];
    [self.settingTableView setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:243/255.0 alpha:1]];
    self.settingTableView.dataSource=self;
    self.settingTableView.delegate=self;
    self.settingTableView.scrollEnabled=NO;
    self.settingTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.settingTableView.separatorColor = [UIColor clearColor];
    self.settingTableView.tableHeaderView = _bgView;
    
    if ([JMSGUser getMyInfo].nickname) {
        self.titleArr = @[[JMSGUser getMyInfo].nickname,@"设置",@"退出登录"];
    }else if ([JMSGUser getMyInfo].username){
        self.titleArr = @[[JMSGUser getMyInfo].username,@"设置",@"退出登录"];
    }else {
        self.titleArr = @[@"",@"设置",@"退出登录"];
    }
    self.imgArr = @[@"wo_20",@"setting_22",@"loginOut_17"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAvatar) name:kupdateUserInfo object:nil];
}

- (void)updateAvatar {
    JMSGUser *user = [JMSGUser getMyInfo];
    JPIMLog(@"avatarResourcePath :%@",user.avatarResourcePath);
    if (user.avatarResourcePath) {
        UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
        UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
        [_bgView setImage:img];
    }else {
        JMSGUser *user = [JMSGUser getMyInfo];
        [JMSGUser getOriginAvatarImage:user completionHandler:^(id resultObject, NSError *error) {
            if (error == nil) {
                JPIMLog(@"getOriginAvatarImage avatarResourcePath :%@",user.avatarResourcePath);
                if (user.avatarResourcePath) {
                    UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
                    UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
                    [_bgView setImage:img];
                }else {
                    [_bgView setImage:[UIImage imageNamed:@"wo.png"]];
                }
            }else {
                [_bgView setImage:[UIImage imageNamed:@"wo.png"]];
            }
        }];
    }
}

- (void)tapPicture :(UIGestureRecognizer *)gesture {
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
-(void)photoClick
{
    JPIMLog(@"Action");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.editing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.mediaTypes = temp_MediaTypes;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark --调用相机
-(void)cameraClick
{
    JPIMLog(@"Action");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.mediaTypes = temp_MediaTypes;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.editing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController Delegate
//相机,相册Finish的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    JPIMLog(@"Action");
    [MBProgressHUD showMessage:@"正在上传！" toView:self.view];
    UIImage *image;
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    JMSGUser *user = [JMSGUser getMyInfo];
    image = [image resizedImageByWidth:upLoadImgWidth];
    NSString *imgPath = [JCHATFileManager saveImageWithConversationID:user.username andData:UIImageJPEGRepresentation(image, 1)];
    [JMSGUser updateMyInfoWithParameter:imgPath withType:kJMSGAvatar completionHandler:^(id resultObject, NSError *error) {
        JPIMMAINTHEAD(^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error == nil) {
                [MBProgressHUD showMessage:@"上传成功" view:self.view];
                if (user.avatarResourcePath) {
                    JPIMLog(@"update headView success %@",user);
                    UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
                    UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
                    [_bgView setImage:img];
                } else {
                    [_bgView setImage:[UIImage imageNamed:@"wo.png"]];
                }
            } else {
                JPIMLog(@"update headView fail");
                [MBProgressHUD showMessage:@"上传失败!" view:self.view];
            }
        });
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr count];
}

-(void)viewWillAppear:(BOOL)animated
{ 
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x3f80dd);
    self.navigationController.navigationBar.alpha=0.8;
    self.title=@"我";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont boldSystemFontOfSize:18], UITextAttributeFont,
                                                                     nil]];
    [self updateUserInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)updateUserInfo {
    JMSGUser *user = [JMSGUser getMyInfo];
    NSLog(@"avatarResourcePath :%@",user.avatarResourcePath);
    if (user.avatarResourcePath) {
        UIImage *headImg = [UIImage imageWithContentsOfFile:user.avatarResourcePath];
        UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
        [_bgView setImage:img];
    } else {
        JMSGUser *user = [JMSGUser getMyInfo];
        [JMSGUser getOriginAvatarImage:user completionHandler:^(id resultObject, NSError *error) {
            if (error == nil) {
              JMSGUser *userObject = (JMSGUser *)resultObject;
              DDLogInfo(@"getOriginAvatarImage:%@",userObject);
                if (user.avatarResourcePath) {
                    UIImage *headImg = [UIImage imageWithContentsOfFile:userObject.avatarResourcePath];
                    UIImage *img = [headImg resizedImageByHeight:headImg.size.height];
                    [_bgView setImage:img];
                }else {
                    [_bgView setImage:[UIImage imageNamed:@"wo.png"]];
                }
            }else {
                [_bgView setImage:[UIImage imageNamed:@"wo.png"]];
            }
        }];
    }
    if ([JMSGUser getMyInfo].nickname) {
        self.titleArr = @[[JMSGUser getMyInfo].nickname,@"设置",@"退出登录"];
    }else if ([JMSGUser getMyInfo].username){
        self.titleArr = @[[JMSGUser getMyInfo].username,@"设置",@"退出登录"];
    }else {
        self.titleArr = @[@"",@"设置",@"退出登录"];
    }
    [self.settingTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"headCell";
    JCHATSettingCell *cell = (JCHATSettingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATSettingCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(0, 56, kApplicationWidth, 0.5)];
        [line setBackgroundColor:UIColorFromRGB(0xd0d0cf)];
        [cell addSubview:line];
    }
    cell.nickNameBtn.text =[self.titleArr objectAtIndex:indexPath.row];
    cell.headImgView.image=[UIImage imageNamed:[self.imgArr objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        JCHATPersonViewController *personCtl =[[JCHATPersonViewController alloc] init];
        personCtl.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:personCtl animated:YES];
    }
    if (indexPath.row==1) {
        JCHATSettingViewController *settingCtl =[[JCHATSettingViewController alloc] init];
        settingCtl.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:settingCtl animated:YES];
    }
    if (indexPath.row==2) {
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"退出登录!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alerView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    }else if (buttonIndex==1)
    {
      [MBProgressHUD showMessage:@"正在退出登录！" view:self.view];
        NSLog(@"loginOutWithSuccessCallback success");
        AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        if ([appdelegate.tabBarCtl.loginIdentify isEqualToString:kFirstLogin]) {
            [self.navigationController.navigationController popToViewController:[self.navigationController.navigationController.childViewControllers objectAtIndex:0] animated:YES];
        } else {
            JCHATLoginViewController *loginCtl = [[JCHATLoginViewController alloc] initWithNibName:@"JCHATLoginViewController" bundle:nil];
            loginCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginCtl animated:YES];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserName];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JMSGUser logoutWithCompletionHandler:^(id resultObject, NSError *error) {
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
