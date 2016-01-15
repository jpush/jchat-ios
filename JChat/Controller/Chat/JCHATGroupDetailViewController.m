//
//  JCHATGroupDetailViewController.m
//  JChat
//
//  Created by HuminiOS on 15/11/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATGroupDetailViewController.h"
#import "JCHATGroupMemberCollectionViewCell.h"
#import "JCHATGroupDetailFooterReusableView.h"
#import "JCHATPersonViewController.h"
#import "JCHATFriendDetailViewController.h"
#import "JCHATFootTableCollectionReusableView.h"
#import "JCHATFootTableViewCell.h"

@interface JCHATGroupDetailViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIAlertViewDelegate,
UITableViewDataSource,
UITabBarDelegate> {
  BOOL _isInEditToDeleteMember;
}

@property (weak, nonatomic) IBOutlet UICollectionView *groupMemberGrip;

@end

@implementation JCHATGroupDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _isInEditToDeleteMember = NO;
  [self setupNavigationBar];
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    _memberArr = @[_conversation.target];
    [self setupGroupMemberGrip];
  }else {
    [self getAllMember];
    [self setupGroupMemberGrip];
  }

}

- (void)refreshMemberGrid {
  [self getAllMember];
  [_groupMemberGrip reloadData];
}

- (void)setupNavigationBar {
  self.title=@"聊天详情";
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:kNavigationLeftButtonRect];
  [leftBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
  [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
  [leftBtn addTarget:self
              action:@selector(backClick)
    forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  self.navigationController.navigationBar.translucent = NO;
}

- (void)setupGroupMemberGrip {
  _groupMemberGrip.minimumZoomScale = 0;
  [_groupMemberGrip registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [_groupMemberGrip registerNib:[UINib nibWithNibName:@"JCHATGroupMemberCollectionViewCell" bundle:nil]
     forCellWithReuseIdentifier:@"JCHATGroupMemberCollectionViewCell"];
  
  [_groupMemberGrip registerNib:[UINib nibWithNibName:@"JCHATFootTableCollectionReusableView" bundle:nil]
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:@"JCHATFootTableCollectionReusableView"];
  _groupMemberGrip.backgroundColor = [UIColor whiteColor];
  _groupMemberGrip.delegate = self;
  _groupMemberGrip.dataSource = self;
  _groupMemberGrip.backgroundColor = [UIColor clearColor];
  
  _groupMemberGrip.backgroundView = [UIView new];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGripMember:)];
  [_groupMemberGrip.backgroundView addGestureRecognizer:tap];
}

- (void)tapGripMember:(id)sender {
  [self removeEditStatus];
}

- (void)removeEditStatus {
  _isInEditToDeleteMember = NO;
  [_groupMemberGrip reloadData];
}

- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)getAllMember {
  _memberArr = [((JMSGGroup *)(_conversation.target)) memberArray];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (section != 0) {
    return 0;
  }
  
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    return _memberArr.count + 1;
  }
  
  JMSGGroup *group = (JMSGGroup *)_conversation.target;
  if ([group.owner isEqualToString:[JMSGUser myInfo].username]) {
    return _memberArr.count + 2;
  } else {
    return _memberArr.count +1;
  }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  return CGSizeMake(52, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
  return CGSizeMake(kApplicationWidth, 200);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"JCHATGroupMemberCollectionViewCell";
  JCHATGroupMemberCollectionViewCell *cell = (JCHATGroupMemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  
  if (indexPath.item == _memberArr.count) {
    [cell setAddMember];
    return cell;
  }
  
  if (indexPath.item == _memberArr.count + 1) {
    [cell setDeleteMember];
    return cell;
  }
  
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    JMSGUser *user = _memberArr[indexPath.item];
    [cell setDataWithUser:user withEditStatus:_isInEditToDeleteMember];
  } else {
    JMSGGroup *group = _conversation.target;
    JMSGUser *user = _memberArr[indexPath.item];
    if ([group.owner isEqualToString:user.username]) {
      [cell setDataWithUser:user withEditStatus:NO];
    } else {
      [cell setDataWithUser:user withEditStatus:_isInEditToDeleteMember];
    }

  }
  
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  JCHATFootTableCollectionReusableView *footTable = nil;
  static NSString *footerIdentifier = @"JCHATFootTableCollectionReusableView";
  footTable = [_groupMemberGrip dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                    withReuseIdentifier:footerIdentifier
                                                                                           forIndexPath:indexPath];
  footTable.footTableView.delegate = self;
  footTable.footTableView.dataSource =self;
  [footTable.footTableView reloadData];
  return footTable;
}

- (void)tapToEditGroupName {
  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"输入群名称"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
  alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
  alerView.tag = kAlertViewTagRenameGroup;
  [alerView show];
  [self removeEditStatus];
}

- (void)tapToClearChatRecord {
  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"清空聊天记录"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
  alerView.tag = kAlertViewTagClearChatRecord;
  [alerView show];
  [self removeEditStatus];
}

- (void)quitGroup:(UIButton *)btn
{
  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"退出群聊"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
  alerView.tag = kAlertViewTagQuitGroup;
  [alerView show];
  [self removeEditStatus];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)return;

  switch (alertView.tag) {
    case kAlertViewTagClearChatRecord:
    {
      if (buttonIndex ==1) {
        [self.conversation deleteAllMessages];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteAllMessage object:nil];
      }
    }
      break;
    case kAlertViewTagAddMember:
    {
      
      if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
        return;
      }
      if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        [self createGroupWithAlertView:alertView];
      } else {
        __weak __typeof(self)weakSelf = self;
        [MBProgressHUD showMessage:@"获取成员信息" toView:self.view];
        [((JMSGGroup *)(self.conversation.target)) addMembersWithUsernameArray:@[[alertView textFieldAtIndex:0].text] completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
          if (error == nil) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf refreshMemberGrid];
          } else {
            DDLogDebug(@"addMembersFromUsernameArray fail with error %@",error);
            [MBProgressHUD showMessage:@"添加成员失败" view:weakSelf.view];
          }
        }];
      }
    }
      break;
    case kAlertViewTagQuitGroup:
    {
      if (buttonIndex ==1) {
        __weak __typeof(self)weakSelf = self;
        [MBProgressHUD showMessage:@"正在推出群组！" toView:self.view];
        JMSGGroup *deletedGroup = ((JMSGGroup *)(self.conversation.target));
        
        [deletedGroup exit:^(id resultObject, NSError *error) {
          [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
          if (error == nil) {
            DDLogDebug(@"推出群组成功");
            [MBProgressHUD showMessage:@"推出群组成功" view:weakSelf.view];
            [JMSGConversation deleteGroupConversationWithGroupId:deletedGroup.gid];
            [self.navigationController popToViewController:self.sendMessageCtl.superViewController animated:YES];
          } else {
            DDLogDebug(@"推出群组失败");
            [MBProgressHUD showMessage:@"推出群组失败" view:weakSelf.view];
          }
        }];
      }
    }
      break;
    default:
      [MBProgressHUD showMessage:@"更新群组名称" toView:self.view];
      JMSGGroup *needUpdateGroup = (JMSGGroup *)(self.conversation.target);
      
      [JMSGGroup updateGroupInfoWithGroupId:needUpdateGroup.gid
                                       name:[alertView textFieldAtIndex:0].text
                                       desc:needUpdateGroup.desc
                          completionHandler:^(id resultObject, NSError *error) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                            if (error == nil) {
                              [MBProgressHUD showMessage:@"更新群组名称成功" view:self.view];
                              [self refreshMemberGrid];
                            } else {
                              [MBProgressHUD showMessage:@"更新群组名称失败" view:self.view];
                            }
                          }];
      break;
  }
  return;
}

- (void)createGroupWithAlertView:(UIAlertView *)alertView {
  {
    [MBProgressHUD showMessage:@"加好友进群组" toView:self.view];
    __block JMSGGroup *tmpgroup =nil;
    typeof(self) __weak weakSelf = self;
    [JMSGGroup createGroupWithName:@"" desc:@"" memberArray:@[((JMSGUser *)self.conversation.target).username,[alertView textFieldAtIndex:0].text] completionHandler:^(id resultObject, NSError *error) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      typeof(weakSelf) __strong strongSelf = weakSelf;
      tmpgroup = (JMSGGroup *)resultObject;
      
      if (error == nil) {
        [JMSGConversation createGroupConversationWithGroupId:tmpgroup.gid completionHandler:^(id resultObject, NSError *error) {
          if (error == nil) {
            [MBProgressHUD showMessage:@"创建群成功" view:self.view];
            JMSGConversation *groupConversation = (JMSGConversation *)resultObject;
            strongSelf.sendMessageCtl.conversation = groupConversation;
            strongSelf.sendMessageCtl.isConversationChange = YES;
            [JMessage removeDelegate:strongSelf.sendMessageCtl withConversation:_conversation];
            [JMessage addDelegate:strongSelf.sendMessageCtl withConversation:groupConversation];
            strongSelf.sendMessageCtl.targetName = tmpgroup.name;
            strongSelf.sendMessageCtl.title = tmpgroup.name;
            [strongSelf.sendMessageCtl setupView];
            [[NSNotificationCenter defaultCenter] postNotificationName:kConversationChange object:resultObject];
            [strongSelf.navigationController popViewControllerAnimated:YES];
          } else {
            DDLogDebug(@"creategroupconversation error with error : %@",error);
          }
        }];
      } else {
        [MBProgressHUD showMessage:[JCHATStringUtils errorAlert:error] view:self.view];
      }
    }];
  }
}

- (void)collectionView:(UICollectionView * _Nonnull)collectionView didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
  if (indexPath.item == _memberArr.count) {// 添加群成员
    _isInEditToDeleteMember = NO;
    [_groupMemberGrip reloadData];
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加好友进群"
                                                      message:@"输入好友用户名!"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
    alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alerView.tag = kAlertViewTagAddMember;
    [alerView show];
    return;
  }
  
  if (indexPath.item == _memberArr.count + 1) {// 删除群成员
    _isInEditToDeleteMember = !_isInEditToDeleteMember;
    [_groupMemberGrip reloadData];
    return;
  }

//  点击群成员头像
  JMSGUser *user = _memberArr[indexPath.item];
  JMSGGroup *group = _conversation.target;
  if (_isInEditToDeleteMember) {
    if ([user.username isEqualToString:group.owner]) {
      return;
    }
    JMSGUser *userToDelete = _memberArr[indexPath.item];
    [self deleteMemberWithUserName:userToDelete.username];
  } else {
    if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
      JCHATPersonViewController *personCtl =[[JCHATPersonViewController alloc] init];
      personCtl.hidesBottomBarWhenPushed = YES;
      [self.navigationController pushViewController:personCtl animated:YES];
    } else {
      JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
      friendCtl.userInfo = user;
      friendCtl.isGroupFlag = YES;
      [self.navigationController pushViewController:friendCtl animated:YES];
    }
  }
  return ;
}

- (void)deleteMemberWithUserName:(NSString *)userName {
  if ([_memberArr count] == 1) {
    return;
  }
  
  [MBProgressHUD showMessage:@"正在删除好友！" toView:self.view];
  [((JMSGGroup *)(self.conversation.target)) removeMembersWithUsernameArray:@[userName] completionHandler:^(id resultObject, NSError *error) {
    
    if (error == nil) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      [MBProgressHUD showMessage:@"删除成员成功！" view:self.view];
      [self refreshMemberGrid];
    } else {
      DDLogDebug(@"JCHATGroupSettingCtl   fail to removeMembersFromUsernameArrary");
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      [MBProgressHUD showMessage:@"删除成员错误！" view:self.view];
    }
  }];
}

- (void)quitGroup {
  UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"退出群聊"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
  alerView.tag = 400;
  [alerView show];
  [self removeEditStatus];
}

#pragma -mark FootTableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    return 1;
  } else {
    return 3;
  }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"JCHATFootTableViewCell";
  JCHATFootTableViewCell *cell = (JCHATFootTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
      [cell layoutToClearChatRecord];
  } else {
    switch (indexPath.row) {
        //    case 0 为修改 group.name 的 footer suplementary
      case 0:
        [cell setDataWithGroupName:((JMSGGroup *)_conversation.target).displayName];
        break;
      case 1:
        [cell layoutToClearChatRecord];
        break;
      case 2:
        cell.delegate = self;
        [cell layoutToQuitGroup];
        break;

      default:
        break;
    }
  }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    [self tapToClearChatRecord];
  } else {
    switch (indexPath.row) {
      case 0:
        [self tapToEditGroupName];
        break;
      case 1:
        [self tapToClearChatRecord];
        break;
      case 2:
        break;
      default:
        break;
    }
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
