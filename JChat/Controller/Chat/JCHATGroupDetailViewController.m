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

@interface JCHATGroupDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate> {
  BOOL _isInEditToDeleteMember;
}
@property (weak, nonatomic) IBOutlet UICollectionView *groupMemberGrip;

@end

@implementation JCHATGroupDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _isInEditToDeleteMember = NO;
  [self setupNavigationBar];
  [self getAllMember];
  [self setupGroupMemberGrip];
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
}

- (void)setupGroupMemberGrip {
  _groupMemberGrip.minimumZoomScale = 0;
  [_groupMemberGrip registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [_groupMemberGrip registerNib:[UINib nibWithNibName:@"JCHATGroupMemberCollectionViewCell" bundle:nil]
     forCellWithReuseIdentifier:@"JCHATGroupMemberCollectionViewCell"];
  
  [_groupMemberGrip registerNib:[UINib nibWithNibName:@"JCHATGroupDetailFooterReusableView" bundle:nil]
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:@"JCHATGroupDetailFooterReusableView"];
  _groupMemberGrip.backgroundColor = [UIColor whiteColor];
  _groupMemberGrip.delegate = self;
  _groupMemberGrip.dataSource = self;
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
  
  JMSGGroup *group = (JMSGGroup *)_conversation.target;
  if ([group.owner isEqualToString:[JMSGUser myInfo].username]) {
    return _memberArr.count + 2;
  } else {
    return _memberArr.count +1;
  }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  return CGSizeMake(46, 80);
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
  
  [cell setDataWithUser:_memberArr[indexPath.item] withEditStatus:_isInEditToDeleteMember];
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  JCHATGroupDetailFooterReusableView *reusableview = nil;
  
  static NSString *footerIdentifier = @"JCHATGroupDetailFooterReusableView";
  if (kind == UICollectionElementKindSectionFooter) {
    JCHATGroupDetailFooterReusableView *footer = [_groupMemberGrip dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                      withReuseIdentifier:footerIdentifier
                                                                                             forIndexPath:indexPath];
    
    if (footer.gestureRecognizers.count != 0) {
      [footer removeGestureRecognizer:footer.gestureRecognizers[0]];
    }
    footer.delegate = self;
    switch (indexPath.section) {
        //    case 0 为修改 group.name 的 footer suplementary
      case 0:
        [footer setDataWithGroupName:((JMSGGroup *)_conversation.target).displayName];
        [footer addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(tapToEditGroupName)]];
        break;
        //    case 1 为修改 清除聊天记录 的  footer suplementary
      case 1:
        [footer layoutToClearChatRecord];
        [footer addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(tapToClearChatRecord)]];
        break;
      case 2:
        //    case 2 为修改 退出group 的  footer suplementary
        [footer layoutToQuitGroup];
        break;
        
      default:
        break;
    }
    reusableview = footer;
  }
  
  return reusableview;
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
}

- (void)tapToClearChatRecord {
  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"清空聊天记录"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
  alerView.tag = kAlertViewTagClearChatRecord;
  [alerView show];
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

- (void)collectionView:(UICollectionView * _Nonnull)collectionView
didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
  if (indexPath.item == _memberArr.count) {
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
  
  if (indexPath.item == _memberArr.count + 1) {
    _isInEditToDeleteMember = !_isInEditToDeleteMember;
    [_groupMemberGrip reloadData];
    return;
  }
  
  if (_isInEditToDeleteMember) {
    JMSGUser *userToDelete = _memberArr[indexPath.item];
    [self deleteMemberWithUserName:userToDelete.username];
  } else {
    JMSGUser *user = _memberArr[indexPath.item];
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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
