//
//  JCHATDetailsInfoViewController.m
//  
//
//  Created by Apple on 15/1/21.
//
//

#import "JCHATDetailsInfoViewController.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "JChatConstants.h"
#import "JCHATFriendDetailViewController.h"
#import <JMessage/JMessage.h>

@interface JCHATDetailsInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic)NSArray *detailArr;
@property (strong, nonatomic)UIImageView *headView;

@end

@implementation JCHATDetailsInfoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  self.title=@"聊天详情";
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
  [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮

  [self.view setBackgroundColor:[UIColor orangeColor]];
  [self.detailTableView setBackgroundColor:[UIColor whiteColor]];
  UIView *tableHeadView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
  [tableHeadView setBackgroundColor:[UIColor whiteColor]];
  
  _headView =[[UIImageView alloc] initWithFrame:CGRectMake(20, (80-46)/2, 46, 46)];
  [_headView setBackgroundColor:[UIColor clearColor]];
  [_headView setUserInteractionEnabled:YES];
  UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadClick)];
  [_headView addGestureRecognizer:gesture];

  [((JMSGUser *)self.conversation.target) thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error == nil) {
              if (data == nil) {
                [_headView setImage:[UIImage imageNamed:@"headDefalt_34"]];
              }else {
                [_headView setImage:[UIImage imageWithData:data]];
              }
            }else {
              DDLogDebug(@"JCHATDetailsInfoVC thumbAvatarData fail");
            }
  }];
  [_headView.layer setMasksToBounds:YES];
  [_headView.layer setCornerRadius:23];
  [tableHeadView addSubview:_headView];
  
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99,kApplicationWidth, 1)];
  [lineView setBackgroundColor:[UIColor grayColor]];
  [tableHeadView addSubview:lineView];
  
  UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100-40, 150, 40)];
  nameLabel.textColor = [UIColor grayColor];
  nameLabel.font = [UIFont boldSystemFontOfSize:18];
  nameLabel.textAlignment = NSTextAlignmentLeft;

  nameLabel.text = [((JMSGUser *)self.conversation.target) displayName];
  [tableHeadView addSubview:nameLabel];
  UIButton *addView =[[UIButton alloc] initWithFrame:CGRectMake(75, (80-46)/2, 46, 46)];
  [addView setBackgroundColor:[UIColor clearColor]];
  [addView addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
  [addView setImage:[UIImage imageNamed:@"addMan_13"] forState:UIControlStateNormal];
  [addView setImage:[UIImage imageNamed:@"addMan_13_pre"] forState:UIControlStateHighlighted];
  [tableHeadView addSubview:addView];
  
  self.detailTableView.tableHeaderView = tableHeadView;
  self.detailArr =@[@{@"section0" :@[@"清空聊天记录"]}];
  self.detailTableView.dataSource=self;
  self.detailTableView.delegate=self;
  self.detailTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

#pragma mark -- 加入好友到群
- (void)addFriend {
  UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"添加好友到群" message:@"输入好友的用户名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
  alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
  [alerView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    
  }else {
    [MBProgressHUD showMessage:@"加好友进群组" toView:self.view];
    __block JMSGGroup *group =nil;
    typeof(self) __weak weakSelf = self;
    NSLog(@"huangmin merbers %@",@[[JMSGUser myInfo].username,((JMSGUser *)self.conversation.target).username,[alertView textFieldAtIndex:0].text].description);
    [JMSGGroup createGroupWithName:[NSString stringWithFormat:@"%@,%@,%@",[JMSGUser myInfo].username,((JMSGUser *)self.conversation.target).username,[alertView textFieldAtIndex:0].text] description:@"" memberArray:@[((JMSGUser *)self.conversation.target).username,[alertView textFieldAtIndex:0].text] completionHandler:^(id resultObject, NSError *error) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      typeof(weakSelf) __strong strongSelf = weakSelf;
      group = (JMSGGroup *)resultObject;
      if (error == nil) {
        [MBProgressHUD showMessage:@"创建群成功" view:self.view];
        [JMSGConversation createGroupConversationWithGroupId:group.gid completionHandler:^(id resultObject, NSError *error) {
          JMSGConversation *groupConversation = (JMSGConversation *)resultObject;
          strongSelf.sendMessageCtl.conversation = groupConversation;
          strongSelf.sendMessageCtl.targetName = group.name;
          strongSelf.sendMessageCtl.title = group.name;
          [strongSelf.sendMessageCtl setupView];
          [strongSelf.navigationController popViewControllerAnimated:YES];
        }];//[JMSGConversation groupConversationWithGroupId:group.gid];
        

      }else {
        [MBProgressHUD showMessage:@"创建群失败" view:self.view];
      }
    }];
  }
}

- (void)tapHeadClick {
    JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
    friendCtl.userInfo = self.chatUser;
    [self.navigationController pushViewController:friendCtl animated:YES];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if ([self.detailArr count]>0) {
//        return [self.detailArr count];
//    }else{
        return 0;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic =[self.detailArr objectAtIndex:section];
    if (section==0) {
        return [[dic objectForKey:@"section0"] count];
    }else if (section==1)
    {
        return [[dic objectForKey:@"section1"] count];
    }else if (section==2)
    {
        return [[dic objectForKey:@"section2"] count];
    }else if (section==3)
    {
        return [[dic objectForKey:@"section3"] count];
    }
    return 0;
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
    if (indexPath.section==0) {
        if (indexPath.row==0) {
//            [cell.switchView setHidden:NO];
        }
        cell.textLabel.text=[[dic objectForKey:@"section0"] objectAtIndex:indexPath.row];
    }else if (indexPath.section==1)
    {
        cell.textLabel.text=[[dic objectForKey:@"section1"] objectAtIndex:indexPath.row];
    }else if (indexPath.section==2)
    {
        cell.textLabel.text=[[dic objectForKey:@"section2"] objectAtIndex:indexPath.row];
    }else if (indexPath.section==3)
    {
        cell.textLabel.text=[[dic objectForKey:@"section3"] objectAtIndex:indexPath.row];
    }
    return cell;

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];

  [self.chatUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
    if (error == nil) {
      if (data == nil) {
        [_headView setImage:[UIImage imageNamed:@"headDefalt_34"]];
      }else {
        [_headView setImage:[UIImage imageWithData:data]];
      }
    }else {
      DDLogDebug(@"JCHATDetailsInfoVC thumbAvatarData fail");
    }
  }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [_conversation deleteAllMessages];
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
