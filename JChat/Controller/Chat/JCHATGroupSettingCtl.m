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
#import "JCHATPersonViewController.h"
#import "JCHATFriendDetailViewController.h"
#import "JCHATDetailsInfoViewController.h"

#define kheadViewHeight 100

@interface JCHATGroupSettingCtl ()
{
  UIScrollView *_headView;
  NSArray *_groupTitleData;
 __block NSMutableArray *_groupData;
 __block UIButton *_deleteBtn;
 __block UIButton *_addBtn;
  NSMutableArray *_groupBtnArr;
  UIView *_headLine;
}
@end

@implementation JCHATGroupSettingCtl

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor clearColor]];

  DDLogDebug(@"Action - viewDidLoad");
  self.title=@"聊天详情";
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
  [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  _groupTitleData =@[@"群聊名称",@"清空聊天记录",@"删除并退出"];

  self.groupTab = [[JCHATChatTable alloc]initWithFrame:CGRectMake(0, 0, kApplicationWidth,self.view.frame.size.height)];
  self.groupTab.dataSource = self;
  self.groupTab.delegate = self;
  self.groupTab.touchDelegate = self;
  [self.groupTab setBackgroundColor:[UIColor whiteColor]];
  self.groupTab.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:self.groupTab];
  
  _headView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, kApplicationWidth, kheadViewHeight)];
  [_headView setBackgroundColor:[UIColor clearColor]];
  _headLine = [[UIView alloc]initWithFrame:CGRectMake(0, kheadViewHeight-1, kApplicationWidth, 1)];
  [_headLine setBackgroundColor:[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:197/255.0]];
  [_headView addSubview:_headLine];
  _headView.showsHorizontalScrollIndicator = NO;
  _headView.showsVerticalScrollIndicator = NO;
  self.groupTab.tableHeaderView = _headView;
  
  [self getGroupMemberList];
  
  NSShadow *shadow = [[NSShadow alloc]init];
  shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
  shadow.shadowOffset = CGSizeMake(0,0);
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gropMemberChange:) name:JMSGNotification_GroupChange object:nil];
  self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x3f80dd);
  self.navigationController.navigationBar.alpha=0.8;
  
  [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   shadow,NSShadowAttributeName,
                                                                   [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                                                   nil]];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


NSInteger userNameSortGroup(id user1, id user2, void *context) {
  JMSGUser *u1,*u2;
  //类型转换
  u1 = (JMSGUser*)user1;
  u2 = (JMSGUser*)user2;
  return (NSComparisonResult)[u1.username compare:u2.username options:NSNumericSearch];
}

- (void)gropMemberChange:(NSNotification *)notificationObject {
  [self getGroupMemberList];
 }

-  (void)sorteUserArr:(NSArray *)arr {
  JMSGUser *userInfo;
  _groupData = [[(NSArray *)arr sortedArrayUsingFunction:userNameSortGroup context:NULL] mutableCopy];
  for (NSInteger i=0; i< [_groupData count]; i++) {

    userInfo = [[_groupData objectAtIndex:i] copy];
    if ([self.sendMessageCtl.groupInfo.groupOwner longLongValue] == userInfo.uid ) {
      [_groupData removeObjectAtIndex:i];
      [_groupData insertObject:userInfo atIndex:0];
      break;
    }
  }

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
  
  
  [JMSGGroup getGroupMemberList:self.conversation.targetId completionHandler:^(id resultObject, NSError *error) {
    typeof(weakSelf) __strong strongSelf = weakSelf;
    if (error == nil) {
      [strongSelf sorteUserArr:resultObject];
      JPIMMAINTHEAD(^{
          [strongSelf reloadHeadViewData];
      });
    }else {
    }
  }];
}

- (void)reloadHeadViewData {
  for (UIView *v in _headView.subviews) {
    if ([v isKindOfClass:[JCHATGroupPersonView class]]) {
      [v removeFromSuperview];
    }
  }
  
  _groupBtnArr = [[NSMutableArray alloc]init];
  NSInteger headWidth = 56;
  NSInteger headHeight = 75;
  
  [self setHeadViewContentSize];
  NSInteger width = (self.view.bounds.size.width - 4* headWidth)/5;
  for (NSInteger i = 0; i< [self getRowFromGroupData]; i++) {
    for (NSInteger j = 0; j < 4; j++) {
     
      NSArray *personXib = [[NSBundle mainBundle]loadNibNamed:@"JCHATGroupPersonView"owner:self options:nil];
      JCHATGroupPersonView * personView = [personXib objectAtIndex:0];
      [personView setFrame:CGRectMake(width +j*(headWidth + width), 10 + (headHeight +10) * i, headWidth, headHeight)];
      [personView.headViewBtn setFrame:CGRectMake(0, 0, 46, 46)];
      [personView.headViewBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
      [_groupBtnArr addObject:personView];
      personView.delegate = self;
      [personView.deletePersonBtn setHidden:YES];
      if (i*4 +j == [_groupData count]) {
        [personView.headViewBtn setImage:[UIImage imageNamed:@"addMan_13"] forState:UIControlStateNormal];
        personView.headViewBtn.tag = 10000;
        _addBtn = personView.headViewBtn;
        [personView.deletePersonBtn setHidden:YES];
        personView.memberLable.text = @"";
        [_headView addSubview:personView];
      }else if (i*4 +j == [_groupData count] + 1) {
        [personView.headViewBtn setImage:[UIImage imageNamed:@"deleteMan"] forState:UIControlStateNormal];
        personView.headViewBtn.tag = 20000;
        _deleteBtn = personView.headViewBtn;
        [personView.deletePersonBtn setHidden:YES];
        personView.memberLable.text = @"";
        if ([self.sendMessageCtl.groupInfo.groupOwner longLongValue] == [JMSGUser getMyInfo].uid && [_groupData count] !=1) {
          [_headView addSubview:personView];
        }
        return;
      }else {
        personView.headViewBtn.tag = 1000 + i*4+j;
        JMSGUser *user = [_groupData objectAtIndex:i*4+j];
        [personView.headViewBtn setBackgroundColor:[UIColor redColor]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:user.avatarThumbPath]) {
          [personView.headViewBtn setImage:[UIImage imageWithContentsOfFile:user.avatarThumbPath] forState:UIControlStateNormal];
        }else {
          [personView.headViewBtn setImage:[UIImage imageNamed:@"headDefalt_34"] forState:UIControlStateNormal];
        }
        
        if (user.nickname && ![user.nickname isEqualToString:@"(null)"] && ![user.nickname isEqualToString:@""]) {
          personView.memberLable.text = user.nickname;
        }else {
          personView.memberLable.text = user.username;
        }
        [_headView addSubview:personView];
      }
    }
  }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
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
        alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alerView.tag =300;
        [alerView show];
    }else {
        if (_deleteBtn.selected == YES) {
            [self deleteMemberWithPersonView:personView];
        }else {
          JMSGUser *user = [_groupData objectAtIndex:personView.headViewBtn.tag - 1000];
          if ([user.username isEqualToString:[JMSGUser getMyInfo].username]) {
            JCHATPersonViewController *personCtl =[[JCHATPersonViewController alloc] init];
            personCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personCtl animated:YES];
          }else {
            JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
              friendCtl.userInfo = user;
              friendCtl.isGroupFlag = YES;
            [self.navigationController pushViewController:friendCtl animated:YES];
          }
        }
    }
}

- (void)deleteMemberWithPersonView:(JCHATGroupPersonView *)personView {
  
  if ([_groupData count] == 1) {
        return;
  }
  
  [MBProgressHUD showMessage:@"正在删除好友！" toView:self.view];
  JMSGUser *user = [_groupData objectAtIndex:personView.headViewBtn.tag - 1000];
  [JMSGGroup deleteGroupMember:self.conversation.targetId members:user.username completionHandler:^(id resultObject, NSError *error) {
    JPIMMAINTHEAD(^{
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      if (error == nil) {
        [MBProgressHUD showMessage:@"删除好友成功！" view:self.view];
        [personView removeFromSuperview];
        [_groupBtnArr removeObjectAtIndex:personView.headViewBtn.tag - 1000];
        [_groupData removeObjectAtIndex:personView.headViewBtn.tag - 1000];
        [self reloadHeadViewData];
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
    });
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
        cell.groupName.text = self.conversation.targetName;
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
    alerView.tag=400;
    [alerView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (alertView.tag == 300) {
      if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
          return;
    }
    [MBProgressHUD showMessage:@"获取成员信息" toView:self.view];
    [JMSGGroup addMembers:self.conversation.targetId members:[alertView textFieldAtIndex:0].text completionHandler:^(id resultObject, NSError *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      if (error == nil) {
        for (NSInteger i=0; i<[(NSMutableArray *)resultObject count]; i++) {
          [self addMemberToReload:[(NSMutableArray *)resultObject objectAtIndex:i]];
        }
      }else {
        [MBProgressHUD showMessage:@"获取成员信息失败" view:self.view];
      }
    }];
  }else if (alertView.tag ==400) {
    if (buttonIndex ==1) {
      [MBProgressHUD showMessage:@"正在推出群组！" toView:self.view];
      [JMSGGroup exitGroup:self.conversation.targetId completionHandler:^(id resultObject, NSError *error) {
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
  }else if (alertView.tag == 100){
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
  }else {
    if (buttonIndex ==1) {
      
      [MBProgressHUD showMessage:@"更新群组名称" toView:self.view];
      typeof(self) __weak weakSelf = self;
      [JMSGGroup getGroupInfo:self.conversation.targetId completionHandler:^(id resultObject, NSError *error) {
        typeof(weakSelf) __strong strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error == nil) {
          JMSGGroup *group = (JMSGGroup *)resultObject;
          group.groupName = [alertView textFieldAtIndex:0].text;
          [JMSGGroup updateGroupInfo:group completionHandler:^(id resultObject, NSError *error) {
            if (error == nil) {
              JPIMMAINTHEAD(^{
                JCHATGroupSettingCell * cell = (JCHATGroupSettingCell *)[_groupTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.groupName.text = [alertView textFieldAtIndex:0].text;
                strongSelf.conversation.targetName = [alertView textFieldAtIndex:0].text;
                strongSelf.sendMessageCtl.title = [alertView textFieldAtIndex:0].text;
                [MBProgressHUD showMessage:@"更新群组名称成功" view:self.view];
              });
            }else {
              [MBProgressHUD showMessage:@"更新群组名称失败" view:self.view];
            }
          }];
        }else {
          [MBProgressHUD showMessage:@"更新群组名称失败" view:self.view];
        }
      }];

    }
  }
}

- (void)addMemberToReload:(JMSGUser *)user {
  [_groupData addObject:user];
  [self reloadHeadViewData];
}

- (CGRect)getLastGect {
  NSInteger width = (self.view.bounds.size.width - 4* 56)/5;
  return  CGRectMake(width + (56 + width)*[self getVerticalNumberlLast], 10 + (75 +10) * ([self getRowFromGroupData]-1), 56, 75);
}

- (void)reloadAddBtnAndDeleteBtnFrame {
  NSInteger n = 0;
  NSInteger width = (self.view.bounds.size.width - 4* 56)/5;
  if ([self.sendMessageCtl.groupInfo.groupOwner longLongValue] != [JMSGUser getMyInfo].uid) {
    n = 1;
  }else {
    n = 2;
  }
  
  UIButton *addBtn = (UIButton *)[_headView viewWithTag:10000];
  [addBtn setFrame:CGRectMake(width + (56 + width) * (([_groupData count])%4), 10 + (75 +10) * ([self getRowFromGroupData]-1), 56, 75)];
  
  if (n == 2) {
    if (!_deleteBtn) {
      NSArray *personXib = [[NSBundle mainBundle]loadNibNamed:@"JCHATGroupPersonView"owner:self options:nil];
      JCHATGroupPersonView * personView = [personXib objectAtIndex:0];
      _deleteBtn = personView.headViewBtn;
      personView.headViewBtn.tag = 20000;//删除按钮标示
      personView.delegate = self;
      [personView.headViewBtn setImage:[UIImage imageNamed:@"deleteMan"] forState:UIControlStateNormal];
      [personView.deletePersonBtn setHidden:YES];
      [_headView addSubview:personView];
      [_groupBtnArr addObject:_deleteBtn];
    }
    [_deleteBtn setFrame:CGRectMake(width + (56 + width) * (([_groupData count] + 1)%4), 10 + (75 +10) * ([self getRowFromGroupData] -1), 56, 75)];
  }
}

- (void)setHeadViewContentSize {
  NSInteger headViewHeight;
  NSInteger headHeight = 75;
  headViewHeight = [self getRowFromGroupData] * (headHeight + 10)+10;
  
  [_headView setFrame:CGRectMake(_headView.frame.origin.x, _headView.frame.origin.y, _headView.frame.size.width, headViewHeight+2)];
  [_headView setContentSize:CGSizeMake(self.view.bounds.size.width, headViewHeight)];
  [_headLine setFrame:CGRectMake(0, _headView.bounds.size.height - 1.5, self.view.bounds.size.width, 0.5)];
  _groupTab.tableHeaderView = _headView;
  [_groupTab reloadData];
}

#pragma mark --计算row的行数
- (NSInteger)getRowFromGroupData {
  NSInteger n = 0;
  if ([_groupData count] == 1 ||[self.sendMessageCtl.groupInfo.groupOwner longLongValue] != [JMSGUser getMyInfo].uid ) {
    n = 1;
  }else {
    n = 2;
  }
  NSInteger row = ([_groupData count] + n)/4;
  NSInteger remainderNumber = ([_groupData count] + n)%4;
  if (remainderNumber!=0) {
    row = row +1;
  }
  return row;
}


#pragma mark --
-  (NSInteger )getVerticalNumberlLast {
  return ([_groupData count] -1)%4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"清空聊天记录" message:@""
                                                         delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alerView.tag=100;
        [alerView show];
    }
  
  if (indexPath.row == 0) {
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"输入群名称" message:@""
                                                     delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
    alerView.tag=200;
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
