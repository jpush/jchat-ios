//
//  JCHATFriendDetailViewController.m
//  极光IM
//
//  Created by Apple on 15/4/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATFriendDetailViewController.h"
#import "JCHATPersonInfoCell.h"
#import "JChatConstants.h"
#import "JCHATFrIendDetailMessgeCell.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "JCHATSendMessageViewController.h"
#import <JMessage/JMessage.h>

@interface JCHATFriendDetailViewController () {
  NSArray *_titleArr;
  NSArray *_imgArr;
  NSMutableArray *_infoArr;
  UILabel *_nameLabel;
  UIImageView *_headView;
}
@end

@implementation JCHATFriendDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  self.title = @"详细资料";
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
  [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  
  _detailTableView.dataSource = self;
  _detailTableView.delegate = self;
  [_detailTableView setBackgroundColor:[UIColor clearColor]];
  _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.detailTableView.frame.size.width, 150)];
  [tableHeadView setBackgroundColor:[UIColor whiteColor]];
  _detailTableView.tableHeaderView = tableHeadView;
  UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(0, 150-0.5,kApplicationWidth, 0.5)];
  [line setBackgroundColor:UIColorFromRGB(0xd0d0cf)];
  [tableHeadView addSubview:line];
  
  _headView =[[UIImageView alloc] initWithFrame:CGRectMake((kApplicationWidth - 70)/2, (150-70)/2, 70, 70)];
  _headView.layer.cornerRadius = 35;
  [_headView.layer setMasksToBounds:YES];
  [_headView setBackgroundColor:[UIColor clearColor]];
  [_headView setContentMode:UIViewContentModeScaleAspectFit];
  [_headView.layer setMasksToBounds:YES];
  [tableHeadView addSubview:_headView];
  
  _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((kApplicationWidth - 60)/2, 150-40, 60, 40)];
  _nameLabel.textColor = [UIColor grayColor];
  _nameLabel.font = [UIFont boldSystemFontOfSize:18];
  _nameLabel.textAlignment =NSTextAlignmentCenter;
  [tableHeadView addSubview:_nameLabel];
  [self loadUserInfoData];
}

- (void)loadUserInfoData {
  _titleArr = @[@"性别",@"地区",@"个性签名"];
  _imgArr = @[@"gender",@"location_21",@"signature"];
  _infoArr = [[NSMutableArray alloc]init];
  [MBProgressHUD showMessage:@"正在加载！" toView:self.view];
  __weak __typeof(self)weakSelf = self;
  NSLog(@"huagnmin   username  %@",self.userInfo.username);
  [JMSGUser userInfoArrayWithUsernameArray:@[self.userInfo.username] completionHandler:^(id resultObject, NSError *error) {
    __strong __typeof(weakSelf) strongSelf = weakSelf;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (error) {
      [_headView setImage:[UIImage imageNamed:@"headDefalt_34"]];
      [MBProgressHUD showMessage:@"获取数据失败！" view:self.view];
      return;
    }
    JMSGUser *user = resultObject[0];
    [user thumbAvatarData:^(id resultObject, NSError *error) {
      if (error == nil) {
        if (resultObject != nil) {
          [_headView setImage:[UIImage imageWithData:resultObject]];
        }else {
          [_headView setImage:[UIImage imageNamed:@"headDefalt_34"]];
        }
      }else {
        DDLogDebug(@"JCHATFriendDetailVC  thumbAvatarData fail");
      }
    }];
    if (user.nickname) {
      _nameLabel.text = user.nickname;
    } else {
      _nameLabel.text = user.username;
    }
    if (user.gender == kJMSGUserGenderUnknown) {
      [_infoArr addObject:@"未知"];
    } else if (user.gender == kJMSGUserGenderMale) {
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
    [strongSelf.detailTableView reloadData];
  }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_titleArr count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  if (indexPath.row == 3) {
    static NSString *cellIdentifier = @"JCHATFrIendDetailMessgeCell";
    JCHATFrIendDetailMessgeCell *cell = (JCHATFrIendDetailMessgeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATFrIendDetailMessgeCell" owner:self options:nil] lastObject];
    }
    cell.skipToSendMessage = self;
    return cell;
  }else {
    static NSString *cellIdentifier = @"JCHATPersonInfoCell";
    JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATPersonInfoCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.infoTitleLabel.text=[_titleArr objectAtIndex:indexPath.row];
    if ([_infoArr count] >0) {
      cell.personInfoConten.text=[_infoArr objectAtIndex:indexPath.row];
    }
    cell.titleImgView.image=[UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]];
    return cell;
  }
}

- (void)skipToSendMessage {
  for (UIViewController *ctl in self.navigationController.childViewControllers) {
    if ([ctl isKindOfClass:[JCHATSendMessageViewController class]]) {
      if (self.isGroupFlag) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSkipToSingleChatViewState object:_userInfo];
      }else {
        [self.navigationController popToViewController:ctl animated:YES];
      }
    }
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 3) {
    return 80;
  }
  return 57;
}

- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
  
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
