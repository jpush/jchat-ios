//
//  JCHATSelectFriendsCtl.m
//  JPush IM
//
//  Created by Apple on 15/2/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATSelectFriendsCtl.h"
#import "JChatConstants.h"
#import "JCHATSelectFriendCell.h"
#import "JCHATSendMessageViewController.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import <JMessage/JMessage.h>

@interface JCHATSelectFriendsCtl ()
{
    UITextField *_groupTextField;
}
@end

@implementation JCHATSelectFriendsCtl

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");
  [self sectionIndexTitles];
  UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kApplicationWidth, 60)];
  [headView setBackgroundColor:[UIColor whiteColor]];
  
  UILabel *groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 50)];
  groupNameLabel.text = @"群名称:";
  groupNameLabel.textAlignment = NSTextAlignmentCenter;
  [headView addSubview:groupNameLabel];
  
  _groupTextField =[[UITextField alloc] initWithFrame:CGRectMake(60, 5, 150, 50)];
  [headView addSubview:_groupTextField];
  _groupTextField.placeholder = @"请输入群名称";
  
  UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59, kApplicationWidth, 1)];
  [line setBackgroundColor:[UIColor grayColor]];
  [headView addSubview:line];

  self.selectFriendTab =[[JCHATChatTable alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kScreenHeight) style:UITableViewStylePlain];
  [self.selectFriendTab setBackgroundColor:[UIColor clearColor]];
  self.selectFriendTab.dataSource=self;
  self.selectFriendTab.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.selectFriendTab.delegate=self;
  self.selectFriendTab.touchDelegate = self;
  self.selectFriendTab.tableHeaderView=headView;
  self.selectFriendTab.delegate = self;
  [self.view addSubview:self.selectFriendTab];
  
  NSShadow *shadow = [[NSShadow alloc]init];
  shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
  shadow.shadowOffset = CGSizeMake(0,0);
  
  self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x3f80dd);
  self.navigationController.navigationBar.alpha=0.8;
  [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   shadow,NSShadowAttributeName,
                                                                   [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                                                   nil]];
  
  UIButton *leftbtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftbtn setFrame:CGRectMake(0, 0, 30, 30)];
  [leftbtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  [leftbtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];//为导航栏添加右侧按钮
  
  UIButton *rightbtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [rightbtn setFrame:CGRectMake(0, 0, 50, 50)];
  [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
  [rightbtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];//为导航栏添加右侧按钮
}

- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event
{
    [_groupTextField resignFirstResponder];
}

- (void)rightBtnClick {
  if ([_groupTextField.text isEqualToString:@""]) {
    [MBProgressHUD showMessage:@"请输入群名称！" view:self.view];
    return;
  }
  [_groupTextField resignFirstResponder];
  [MBProgressHUD showMessage:@"正在创建群组！" toView:self.view];
  JMSGGroup *group = [[JMSGGroup alloc]init];
  group.groupName = _groupTextField.text;
  [JMSGGroup createGroup:group completionHandler:^(id resultObject, NSError *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (error ==nil) {
      [self.navigationController dismissViewControllerAnimated:YES completion:nil];
      [[NSNotificationCenter defaultCenter] postNotificationName:kCreatGroupState object:resultObject];
    }else if (error.code == 808003) {
      [MBProgressHUD showMessage:@"创建群组数量达到上限！" view:self.view];
    }else {
      [MBProgressHUD showMessage:@"创建群组失败！" view:self.view];
    }
  }];
}

- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)sectionIndexTitles {
    self.arrayOfCharacters =[[NSMutableArray alloc] init];
    for(char c = 'A';c<='Z';c++)
    [self.arrayOfCharacters addObject:[NSString stringWithFormat:@"%c",c]];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.arrayOfCharacters;
//}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger count = 0;
    for(NSString *character in self.arrayOfCharacters)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 0;
//    return [self.arrayOfCharacters count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier =@"selectFriendIdentify";
    JCHATSelectFriendCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATSelectFriendCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
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
