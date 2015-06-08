//
//  JCHATGroupSettingCtl.m
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATGroupSettingCtl.h"
#import "JChatConstants.h"
#import "JCHATGroupSettingCell.h"
#import "JCHATGroupPersonView.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import <JMessage/JMessage.h>

#define kheadViewHeight 100

@interface JCHATGroupSettingCtl ()
{
    UIScrollView *_headView;
    NSArray *_groupTitleData;
   __block NSMutableArray *_groupData;
    UIButton *_deleteBtn;
    NSMutableArray *_groupBtnArr;
}
@end

@implementation JCHATGroupSettingCtl

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gropMemberChange:) name:JMSGNotification_GroupMemberChange object:nil];
  self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x3f80dd);
  self.navigationController.navigationBar.alpha=0.8;
  
  NSShadow *shadow = [[NSShadow alloc]init];
  shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
  shadow.shadowOffset = CGSizeMake(0,-1);
  [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   shadow,NSShadowAttributeName,
                                                                   [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                                                   nil]];
  DDLogDebug(@"Action - viewDidLoad");
  self.title=@"聊天详情";
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
  [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  _groupTitleData =@[@"群聊名称",@"清空聊天记录",@"删除并退出"];

  self.groupTab = [[JCHATChatTable alloc]initWithFrame:CGRectMake(0, 0, kApplicationWidth, kScreenHeight)];
  self.groupTab.dataSource = self;
  self.groupTab.delegate = self;
  self.groupTab.touchDelegate = self;
  [self.groupTab setBackgroundColor:[UIColor whiteColor]];
  self.groupTab.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:self.groupTab];
  
  _headView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, kApplicationWidth, kheadViewHeight)];
  [_headView setBackgroundColor:[UIColor whiteColor]];
  UIView *headLine = [[UIView alloc]initWithFrame:CGRectMake(0, kheadViewHeight-1, kApplicationWidth, 1)];
  [headLine setBackgroundColor:[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:197/255.0]];
  [_headView addSubview:headLine];
  _headView.showsHorizontalScrollIndicator =NO;
  _headView.showsVerticalScrollIndicator =NO;
  self.groupTab.tableHeaderView = _headView;
  
  [self getGroupMemberList];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gropMemberChange:(NSNotification *)notificationObject {
  NSDictionary *userInfo = [notificationObject userInfo];
  NSMutableArray *userList = [userInfo objectForKey:JMSGNotification_GroupMemberKey];
  JPIMMAINTHEAD(^{
    _groupData = [NSMutableArray arrayWithArray:userList];
    [self reloadHeadViewData];
  });
}

- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
    JCHATGroupSettingCell *groupNameCell =(JCHATGroupSettingCell *)[self.groupTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [groupNameCell.groupName resignFirstResponder];
    [self showDeleteMemberIcon:NO];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getGroupMemberList {
   typeof(self) __weak weakSelf = self;
  [JMSGGroup getGroupMemberList:self.conversation.target_id completionHandler:^(id resultObject, NSError *error) {
    typeof(weakSelf) __strong strongSelf = weakSelf;
    if (error == nil) {
      _groupData = [NSMutableArray arrayWithArray:resultObject];
      [strongSelf reloadHeadViewData];
    }else {
    }
  }];
}

- (void)reloadHeadViewData {
    _groupBtnArr = [[NSMutableArray alloc]init];
    NSInteger n = 0;
    if ([_groupData count] ==1) {
        n = 1;
    }else {
        n = 2;
    }
    for (NSInteger i=0; i<[_groupData count] +n; i++) {
        NSArray *personXib = [[NSBundle mainBundle]loadNibNamed:@"JCHATGroupPersonView"owner:self options:nil];
       JCHATGroupPersonView * personView = [personXib objectAtIndex:0];
        [personView setFrame:CGRectMake(10+(i * (56 + 10)), 10, 56, 75)];
        [personView.headViewBtn setFrame:CGRectMake(0, 0, 46, 46)];
        [personView.headViewBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_groupBtnArr addObject:personView];
        personView.delegate = self;
        [personView.deletePersonBtn setHidden:YES];
        [_headView addSubview:personView];
        if (i == [_groupData count]) {
        [personView.headViewBtn setImage:[UIImage imageNamed:@"addMan_13"] forState:UIControlStateNormal];
        personView.headViewBtn.tag = 10000;
        [personView.deletePersonBtn setHidden:YES];
        personView.memberLable.text = @"";
        }else if (i == [_groupData count] + 1) {
        _deleteBtn = personView.headViewBtn;
        [personView.deletePersonBtn setHidden:YES];
        [personView.headViewBtn setImage:[UIImage imageNamed:@"deleteMan"] forState:UIControlStateNormal];
        personView.headViewBtn.tag = 20000;
        personView.memberLable.text = @"";
        }else {
          personView.headViewBtn.tag = 1000+i;
          JMSGUser *user = [_groupData objectAtIndex:i];
          [personView.headViewBtn setBackgroundColor:[UIColor redColor]];
          if ([[NSFileManager defaultManager] fileExistsAtPath:user.avatarThumbPath]) {
            [personView.headViewBtn setImage:[UIImage imageWithContentsOfFile:user.avatarThumbPath] forState:UIControlStateNormal];
          }else {
            [personView.headViewBtn setImage:[UIImage imageNamed:@"headDefalt_34"] forState:UIControlStateNormal];
          }
          if (user.nickname && ![user.nickname isEqualToString:@"(null)"]) {
            personView.memberLable.text = user.nickname;
          }else {
            personView.memberLable.text = user.username;
          }
        }
    }
    [self reloadHeadScrollViewContentSize];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
  
  [MBProgressHUD showMessage:@"更新群组名称" toView:self.view];
  typeof(self) __weak weakSelf = self;
  [JMSGGroup getGroupInfo:self.conversation.target_id completionHandler:^(id resultObject, NSError *error) {
    typeof(weakSelf) __strong strongSelf = weakSelf;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (error == nil) {
      JMSGGroup *group = (JMSGGroup *)resultObject;
      group.group_name = textField.text;
      [JMSGGroup updateGroupInfo:group completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
          strongSelf.conversation.target_name = textField.text;
          strongSelf.sendMessageCtl.title = textField.text;
          JPIMMAINTHEAD(^{
            [strongSelf.groupTab reloadData];
          });
          [MBProgressHUD showMessage:@"更新群组名称成功" view:self.view];
        }else {
          [MBProgressHUD showMessage:@"更新群组名称失败" view:self.view];
        }
      }];
    }else {
      [MBProgressHUD showMessage:@"更新群组名称失败" view:self.view];
    }
  }];
}

- (void)reloadHeadScrollViewContentSize {
    [_headView setContentSize:CGSizeMake(10 +((56+10) *[_groupBtnArr count]), _headView.bounds.size.height)];
}

- (void)groupPersonBtnClick:(JCHATGroupPersonView *)personView
{
    if (personView.headViewBtn.tag == 20000) {
        if (personView.headViewBtn.selected) {
            personView.headViewBtn.selected = NO;
            [self showDeleteMemberIcon:NO];
        }else {
            personView.headViewBtn.selected = YES;
            [self showDeleteMemberIcon:YES];
        }
    }else if (personView.headViewBtn.tag == 10000) {
        [self showDeleteMemberIcon:NO];
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加好友进群" message:@"输入好友用户名!"
                                                         delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
        alerView.tag =300;
        [alerView show];
    }else {
        if (_deleteBtn.selected == YES) {
            [self deleteMemberWithPersonView:personView];
        }
    }
}

- (void)deleteMemberWithPersonView:(JCHATGroupPersonView *)personView {
  if ([_groupData count] == 1) {
        return;
  }
  
  [MBProgressHUD showMessage:@"正在删除好友！" toView:self.view];
  JMSGUser *user = [_groupData objectAtIndex:personView.headViewBtn.tag - 1000];
  [JMSGGroup deleteGroupMember:self.conversation.target_id members:user.username completionHandler:^(id resultObject, NSError *error) {
  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (error == nil) {
      [MBProgressHUD showMessage:@"删除好友成功！" view:self.view];
      [personView removeFromSuperview];
      [_groupBtnArr removeObjectAtIndex:personView.headViewBtn.tag - 1000];
      [_groupData removeObjectAtIndex:personView.headViewBtn.tag - 1000];
      [self reloadGroupPersonViewFrame];
      if ([_groupData count] == 1) {
        JCHATGroupPersonView *personView = [_groupBtnArr lastObject];
        if (personView.headViewBtn.tag == 20000) {
          [personView removeFromSuperview];
          [_groupBtnArr removeLastObject];
          [self showDeleteMemberIcon:NO];
        }
        return;
      }
    }else {
      [MBProgressHUD showMessage:@"删除好友失败！" view:self.view];
    }
  }];
}

- (void)reloadGroupPersonViewFrame {
    for (NSInteger i=0; i<[_groupBtnArr count]; i++) {
        JCHATGroupPersonView *personView = [_groupBtnArr objectAtIndex:i];
        personView.memberLable.text = @"";
        if (i <= [_groupData count] -1) {
            personView.headViewBtn.tag = 1000+i;
          JMSGUser *user = [_groupData objectAtIndex:i];
          if (user.nickname) {
            personView.memberLable.text = user.nickname;
          }else {
            personView.memberLable.text = user.username;
          }
        }
        [UIView animateWithDuration:0.3 animations:^{
            [personView setFrame:CGRectMake(10+(i * (56 + 10)), 10, 56, 75)];
        }];
    }
    [self reloadHeadScrollViewContentSize];
}

- (void)showDeleteMemberIcon:(BOOL)flag {
    for (UIView *view in _headView.subviews) {
        if ([view isKindOfClass:[JCHATGroupPersonView class]]) {
            JCHATGroupPersonView *merberView = (JCHATGroupPersonView *)view;
            if (flag) {
                if (merberView.headViewBtn.tag == 10000 || merberView.headViewBtn.tag ==20000) {
                    [merberView.deletePersonBtn setHidden:YES];
                }else {
                    [merberView.deletePersonBtn setHidden:NO];
                }
            }else {
                [merberView.deletePersonBtn setHidden:YES];
                _deleteBtn.selected = NO;
            }
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_groupTitleData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row !=[_groupTitleData count]-1) {
        static NSString *cellIdentifier = @"groupCell";
        JCHATGroupSettingCell *cell = (JCHATGroupSettingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATGroupSettingCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor clearColor]];
            UIView *cellLine = [[UIView alloc]initWithFrame:CGRectMake(0, 53, kApplicationWidth, 1)];
            [cellLine setBackgroundColor:[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:197/255.0]];
            [cell addSubview:cellLine];
            cell.groupName.textAlignment = NSTextAlignmentRight;
        }
        cell.groupTitle.text = [_groupTitleData objectAtIndex:indexPath.row];
      if (indexPath.row == 0) {
        cell.groupName.delegate = self;
        cell.groupName.text = self.conversation.target_name;
      }
        if (indexPath.row == 1) {
            [cell.groupName setHidden:YES];
        }
        return cell;
    }else {
        static NSString *cellIdentifier = @"groupDeleteCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor clearColor]];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.layer.cornerRadius = 6;
            [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setFrame:CGRectMake(20, 10, kApplicationWidth - 20*2, 40)];
            [deleteBtn setTitle:[_groupTitleData objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [deleteBtn setBackgroundColor:UIColorFromRGB(0xf05662)];
            [cell addSubview:deleteBtn];
        }
        return cell;
    }
}

- (void)deleteClick:(UIButton *)btn
{
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"退出群聊" message:@""
                                                     delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alerView.tag=200;
    [alerView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (alertView.tag == 300) {
      if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
          return;
    }
    [MBProgressHUD showMessage:@"获取成员信息" toView:self.view];
    [JMSGGroup addMembers:self.conversation.target_id members:[alertView textFieldAtIndex:0].text completionHandler:^(id resultObject, NSError *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      if (error == nil) {
        for (NSInteger i=0; i<[(NSMutableArray *)resultObject count]; i++) {
          [self addMember:[(NSMutableArray *)resultObject objectAtIndex:i]];
        }
      }else {
        [MBProgressHUD showMessage:@"获取成员信息失败" view:self.view];
      }
    }];
  }else if (alertView.tag !=100) {
    if (buttonIndex ==1) {
      [MBProgressHUD showMessage:@"正在推出群组！" toView:self.view];
      [JMSGGroup exitGoup:self.conversation.target_id completionHandler:^(id resultObject, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error == nil) {
          [MBProgressHUD showMessage:@"退出群组成功！" view:self.view];
          [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
          DDLogDebug(@"exit group error :%@",error);
          [MBProgressHUD showMessage:@"退出群组失败！" view:self.view];
        }
      }];
    }
  }else {
    if (buttonIndex ==1) {
      [self.conversation deleteAllMessageWithCompletionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
          [MBProgressHUD showMessage:@"删除消息成功" view:self.view];
          [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteAllMessage object:nil];
        }else {
          [MBProgressHUD showMessage:@"删除消息失败" view:self.view];
        }
      }];
    }
  }
}

- (void)addMember:(JMSGUser *)member {
    [_groupData addObject:member];
    if ([_groupBtnArr count] ==2) {
        for (NSInteger i=0; i<2; i++) {
            NSArray *personXib = [[NSBundle mainBundle]loadNibNamed:@"JCHATGroupPersonView"owner:self options:nil];
            JCHATGroupPersonView * personView = [personXib objectAtIndex:0];
            if (i==0) {
                personView.headViewBtn.tag =1000 +i;
                [_groupBtnArr insertObject:personView atIndex:1];
                personView.delegate = self;
              if ([[NSFileManager defaultManager] fileExistsAtPath:member.avatarThumbPath]) {
                [personView.headViewBtn setImage:[UIImage imageWithContentsOfFile:member.avatarThumbPath] forState:UIControlStateNormal];
              }else {
                [personView.headViewBtn setImage:[UIImage imageNamed:@"headDefalt_34"] forState:UIControlStateNormal];
              }
            }else {
                personView.headViewBtn.tag =20000;//删除按钮标示
                [_groupBtnArr addObject:personView];
                personView.delegate = self;
                _deleteBtn = personView.headViewBtn;
                [personView.headViewBtn setImage:[UIImage imageNamed:@"deleteMan"] forState:UIControlStateNormal];
            }
            [personView setFrame:CGRectMake(10+([_groupData count]-1 * (56 + 10)), 10, 56, 75)];
            [personView.deletePersonBtn setHidden:YES];
            [_headView addSubview:personView];
        }
    } else {
        NSArray *personXib = [[NSBundle mainBundle]loadNibNamed:@"JCHATGroupPersonView"owner:self options:nil];
        JCHATGroupPersonView * personView = [personXib objectAtIndex:0];
        [personView.deletePersonBtn setHidden:YES];
        personView.headViewBtn.tag = 1000+[_groupData count]-1;
        personView.delegate = self;
        if ([[NSFileManager defaultManager] fileExistsAtPath:member.avatarThumbPath]) {
          [personView.headViewBtn setImage:[UIImage imageWithContentsOfFile:member.avatarThumbPath] forState:UIControlStateNormal];
        }else {
          [personView.headViewBtn setImage:[UIImage imageNamed:@"headDefalt_34"] forState:UIControlStateNormal];
        }
        [personView setFrame:CGRectMake(10+([_groupData count]-1 * (56 + 10)), 10, 56, 75)];
        [_headView addSubview:personView];
        [_groupBtnArr insertObject:personView atIndex:[_groupData count]-1];
    }
    [self reloadGroupPersonViewFrame];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"清空聊天记录" message:@""
                                                         delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alerView.tag=100;
        [alerView show];
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
