//
//  JCHATDetailsInfoViewController.m
//
//
//  Created by Apple on 15/1/21.
//
//

#import "JCHATDetailsInfoViewController.h"
#import "JChatConstants.h"
#import "JCHATFriendDetailViewController.h"
#import "JCHATConversationListViewController.h"

@interface JCHATDetailsInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic)NSArray *detailArr;
@property (strong, nonatomic)UIImageView *headView;

@end

@implementation JCHATDetailsInfoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  [self.view setBackgroundColor:[UIColor orangeColor]];
  
  self.detailArr =@[@{@"section0" :@[@"清空聊天记录"]}];
  [self setupNavigation];
  [self setupTableView];
}

- (void)setupNavigation {
  self.title=@"聊天详情";
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:kNavigationLeftButtonRect];
  [leftBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
  [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  self.navigationController.navigationBar.translucent = NO;
}

- (void)setupTableView {
  [self.detailTableView setBackgroundColor:[UIColor whiteColor]];
  self.detailTableView.dataSource=self;
  self.detailTableView.delegate=self;
  self.detailTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
  [self setupTableHeadView];
}

- (void)setupTableHeadView {
  UIView *tableHeadView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
  [tableHeadView setBackgroundColor:[UIColor whiteColor]];
  
  _headView =[[UIImageView alloc] initWithFrame:CGRectMake(23, (80-46)/2, 52, 52)];
  [_headView setBackgroundColor:[UIColor clearColor]];
  [_headView setUserInteractionEnabled:YES];
  UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadClick)];
  [_headView addGestureRecognizer:gesture];
  
  [_headView.layer setMasksToBounds:YES];
  [_headView.layer setCornerRadius:_headView.frame.size.height/2];
  [tableHeadView addSubview:_headView];
  
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99,kApplicationWidth, 0.5)];
  [lineView setBackgroundColor:kTableviewSeperateLineColor];
  [tableHeadView addSubview:lineView];
  
  UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 80, 52, 13)];
  nameLabel.textColor = [UIColor grayColor];
  nameLabel.font = [UIFont boldSystemFontOfSize:12];
  nameLabel.textAlignment = NSTextAlignmentCenter;
  
  nameLabel.text = [((JMSGUser *)self.conversation.target) displayName];
  [tableHeadView addSubview:nameLabel];
  UIButton *addView =[[UIButton alloc] initWithFrame:CGRectMake(85, (80-46)/2, 52, 52)];
  [addView setBackgroundColor:[UIColor clearColor]];
  [addView addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
  [addView setBackgroundImage:[UIImage imageNamed:@"addMan"] forState:UIControlStateNormal];
  [addView setBackgroundImage:[UIImage imageNamed:@"addMan_pre"] forState:UIControlStateHighlighted];
  
  [tableHeadView addSubview:addView];
  
  self.detailTableView.tableHeaderView = tableHeadView;
}

#pragma mark -- 加入好友到群
- (void)addFriend {
  UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"添加好友到群"
                                                    message:@"输入好友的用户名"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
  alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
  alerView.tag = kAlertViewTagCreateGroup;
  [alerView show];
}

- (void)tapHeadClick {
  JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
  friendCtl.userInfo = self.conversation.target;
  [self.navigationController pushViewController:friendCtl animated:YES];
}

- (void)backClick
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//  return 20;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSDictionary *dic =[self.detailArr objectAtIndex:section];
  switch (section) {
    case 0:
      return [dic[@"section0"] count];
      break;
    case 1:
      return [dic[@"section1"] count];
      break;
    case 2:
      return [dic[@"section2"] count];
      break;
    case 3:
      return [dic[@"section3"] count];
      break;
    default:
      return 0;
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  static NSString *cellIdentifier = @"detailCell";
  JCHATDetailTableViewCell *cell = (JCHATDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATDetailTableViewCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
  }
  [cell.switchView setHidden:YES];
  NSDictionary *dic =[self.detailArr objectAtIndex:indexPath.section];
  
  switch (indexPath.section) {
    case 0:
      cell.textLabel.text = dic[@"section0"][indexPath.row];
      break;
    case 1:
      cell.textLabel.text = dic[@"section1"][indexPath.row];
      break;
    case 2:
      cell.textLabel.text = dic[@"section2"][indexPath.row];
      break;
    case 3:
      cell.textLabel.text = dic[@"section3"][indexPath.row];
      break;
    default:
      break;
  }
  return cell;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  
  [self.conversation.target thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
    if (error == nil) {
      
      if (data == nil) {
        [_headView setImage:[UIImage imageNamed:@"headDefalt"]];
        
      } else {
        [_headView setImage:[UIImage imageWithData:data]];
      }
    } else {
      DDLogDebug(@"JCHATDetailsInfoVC thumbAvatarData fail");
    }
  }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  [_conversation deleteAllMessages];
  [self tapToClearChatRecord];
}

- (void)tapToClearChatRecord {
  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"清空聊天记录"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
  alerView.tag = kAlertViewTagClearSingleChatRecord;
  [alerView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) return;
  
  switch (alertView.tag) {
    case kAlertViewTagClearSingleChatRecord:
      [self.conversation deleteAllMessages];
      [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteAllMessage object:nil];
      break;
    case kAlertViewTagCreateGroup:
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
      break;
    default:
      break;
  }
  return;
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
