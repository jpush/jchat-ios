
#import "JPIMChatViewController.h"
#import "JPIMChatTableViewCell.h"
#import "JPIMSendMessageViewController.h"
#import "JPIMSelectFriendsCtl.h"
#import "MBProgressHUD+Add.h"
#import "MobClick.h"
#import <JMessage/JMessage.h>

@interface JPIMChatViewController ()
{
   __block NSMutableArray *_conversationArr;
    UIButton *_rightBarButton;
    NSInteger _unreadCount;
    UILabel *titleLabel;
}

@property (nonatomic,strong)UISearchDisplayController * searchDisplayController ;

@end

@implementation JPIMChatViewController

@synthesize searchDisplayController;

- (void)viewDidLoad {
    [super viewDidLoad];
    JPIMLog(@"Action ");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectClose)
                                                 name:kJPFNetworkDidCloseNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectSetup)
                                                 name:kJPFNetworkDidSetupNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectSucceed)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reveiveMessageNotifi:) name:KJMSG_ReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alreadyLoginClick) name:kLogin_NotifiCation object:nil];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x3f80dd);
    self.navigationController.navigationBar.alpha=0.8;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont boldSystemFontOfSize:18], UITextAttributeFont,
                                                                     nil]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.chatTableView setBackgroundColor:[UIColor whiteColor]];
    self.chatTableView.dataSource=self;
    self.chatTableView.delegate=self;
    self.chatTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.chatTableView.touchDelegate = self;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"会话";
    self.navigationItem.titleView = titleLabel;
    
    _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBarButton setFrame:CGRectMake(0, 0, 30, 30)];
    [_rightBarButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarButton setImage:[UIImage imageNamed:@"add_37"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];//为导航栏添加右侧按钮
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    [searchBar sizeToFit];
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    // 添加 searchbar 到 headerview
//    self.chatTableView.tableHeaderView = searchBar;
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
   self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    self.addBgView =[[UIImageView alloc] initWithFrame:CGRectMake(kApplicationWidth-100, 65, 100, 100)];
    [self.addBgView setBackgroundColor:[UIColor clearColor]];
    [self.addBgView setUserInteractionEnabled:YES];
    UIImage *frameImg =[UIImage imageNamed:@"frame"];
    frameImg =[frameImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 10) resizingMode:UIImageResizingModeTile];
    [self.addBgView setImage:frameImg];
    [self.view addSubview:self.addBgView];
    [self.view bringSubviewToFront:self.addBgView];
    [self.addBgView setHidden:YES];
    [self addBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationSkipToChatPageView:) name:KApnsNotification object:nil];
}

- (void)receiveNotificationSkipToChatPageView:(NSNotification *)no {
    JPIMLog(@"%@",no);
    JPIMSendMessageViewController *sendMessageCtl;
    for (UIViewController *ctl in self.navigationController.childViewControllers) {
        if ([ctl isKindOfClass:[JPIMSendMessageViewController class]]) {
            return;
        }
    }
    if (!sendMessageCtl) {
       sendMessageCtl =[[JPIMSendMessageViewController alloc] init];
    }
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    sendMessageCtl.conversationType = kSingle;
    NSDictionary *apnsDic = [no object];
    NSString *targetName = [apnsDic[@"aps"] objectForKey:@"alert"];
    if ([targetName isEqualToString:[JMSGUserManager getMyInfo].username]) {
        return;
    }
   __block JMSGConversation *conversation;
    for (NSInteger i =0; i<[_conversationArr count]; i++) {
        JMSGConversation *getConversation = [_conversationArr objectAtIndex:i];
        if ([getConversation.target_id isEqualToString:[[targetName componentsSeparatedByString:@":"] objectAtIndex:0]]) {
            conversation = getConversation;
        }
    }
    if (!conversation) {
        [JMSGConversationManager createConversation:targetName withType:kSingle completionHandler:^(id resultObject, NSError *error) {
            conversation = (JMSGConversation  *)resultObject ;
            sendMessageCtl.conversation = conversation;
            sendMessageCtl.conversationList = _conversationArr;
            [self.navigationController pushViewController:sendMessageCtl animated:YES];
            NSInteger badge = _unreadCount - [conversation.unread_cnt integerValue];
            [self saveBadge:badge];
            [conversation resetUnreadMessageCountWithCompletionHandler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    JPIMLog(@"消息清零成功");
                    //                         [self setbadge];
                }else {
                    JPIMLog(@"消息清零失败");
                }
            }];
        }];
        return;
    }
    sendMessageCtl.conversation = conversation;
    sendMessageCtl.conversationList = _conversationArr;
    [self.navigationController pushViewController:sendMessageCtl animated:YES];
    NSInteger badge = _unreadCount - [conversation.unread_cnt integerValue];
    [self saveBadge:badge];
}

- (void)netWorkConnectClose {
    titleLabel.text =@"未连接...";
}

- (void)netWorkConnectSetup {
    titleLabel.text =@"正在连接...";
}

- (void)connectSucceed {
    titleLabel.text =@"连接成功...";
    [self performSelector:@selector(showName) withObject:nil afterDelay:1];
}

- (void)showName {
    titleLabel.text =@"会话";
}

#pragma mark --收到消息
- (void)reveiveMessageNotifi :(NSNotification *)notifi {
    [self getConversationList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self getConversationList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

- (void)getConversationList {
    [self.addBgView setHidden:YES];
    [JMSGConversationManager getConversationListWithCompletionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            JPIMMAINTHEAD(^{
                _conversationArr = [self sortConversation:resultObject];
                _unreadCount = 0;
                for (NSInteger i=0; i < [_conversationArr count]; i++) {
                    JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
                    _unreadCount = _unreadCount + [conversation.unread_cnt integerValue];
                }
                [self saveBadge:_unreadCount];
                [self.chatTableView reloadData];
            });
        }else {
        }
    }];
}

NSInteger sortType(id object1,id object2,void *cha) {
    JMSGConversation *model1 = (JMSGConversation *)object1;
    JMSGConversation *model2 = (JMSGConversation *)object2;
    if([model1.latest_date integerValue] > [model2.latest_date integerValue]) {
        return NSOrderedAscending;
    }else if([model1.latest_date integerValue] < [model2.latest_date integerValue]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
    return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)alreadyLoginClick {
    [self getConversationList];
}

- (void)addBtn {
    for (NSInteger i=0; i<2; i++) {
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    if (i==0) {
        [btn setTitle:@"发起群聊" forState:UIControlStateNormal];
    }
    if (i==1) {
        [btn setTitle:@"添加朋友" forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag=i + 100;
    [btn setFrame:CGRectMake(10, i*30+30, 80, 30)];
    [self.addBgView addSubview:btn];
    }
}

-(void)btnClick :(UIButton *)btn {
    [self.addBgView setHidden:YES];
    if (btn.tag == 100) {
    JPIMSelectFriendsCtl *selectCtl =[[JPIMSelectFriendsCtl alloc] init];
    UINavigationController *selectNav =[[UINavigationController alloc] initWithRootViewController:selectCtl];
    [self.navigationController presentViewController:selectNav animated:YES completion:nil];
    }else if (btn.tag == 101) {
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加好友" message:@"输入好友用户名!"
                                                     delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
    [alerView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    }else if (buttonIndex == 1)
    {
        [MBProgressHUD showMessage:@"正在获取好友信息" view:self.view];
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
            return;
        }
        JPIMSendMessageViewController *sendMessageCtl =[[JPIMSendMessageViewController alloc] init];
        sendMessageCtl.hidesBottomBarWhenPushed=YES;
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        __weak __typeof(self)weakSelf = self;
        [JMSGUserManager getUserInfoWithUsername:[alertView textFieldAtIndex:0].text completionHandler:^(id resultObject, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (error == nil) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                sendMessageCtl.user = ((JMSGUser *) resultObject);
                NSLog(@"username :%@", sendMessageCtl.user.username);
                if (![sendMessageCtl.user.username isEqualToString:[JMSGUserManager getMyInfo].username]) {
                    [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
                } else {
                    [MBProgressHUD showMessage:@"不能加自己为好友!" view:self.view];
                }
                NSLog(@"getuserinfo success");
            } else {
                NSLog(@"没有这个用户!");
                [MBProgressHUD showMessage:@"获取信息失败" view:self.view];
            }
        }];
    }
}

-(void)addBtnClick:(UIButton *)btn {
    if (btn.selected) {
        btn.selected=NO;
        [self.addBgView setHidden:YES];
    }else
    {
        btn.selected=YES;
        [self.addBgView setHidden:NO];
    }
    [self.view bringSubviewToFront:self.addBgView];
}

-(void)perFormAdd {
    
}

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
    [self.addBgView setHidden:YES];
    _rightBarButton.selected=NO;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    JPIMLog(@"Action");
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    [JMSGConversationManager deleteConversation:conversation.targetName completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            JPIMLog(@"delete conversation success");
        }else {
            JPIMLog(@"delete conversation error");
        }
    }];
    [conversation deleteAllMessageWithCompletionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            JPIMLog(@"delete message success");
        }else {
            JPIMLog(@"delete message error");
        }
    }];
    [_conversationArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_conversationArr count] > 0) {
        return [_conversationArr count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"chatCell";
    JPIMChatTableViewCell *cell = (JPIMChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[JPIMChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    JMSGConversation *conversation =[_conversationArr objectAtIndex:indexPath.row];
    [cell setcellDataWithConversation:conversation];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kApplicationHeight <=480 ) {
        return 65;
    }
    return 80;
}

#pragma mark - SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar {

}

//响应点击索引时的委托方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_conversationArr count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JPIMSendMessageViewController *sendMessageCtl =[[JPIMSendMessageViewController alloc] init];
    sendMessageCtl.hidesBottomBarWhenPushed=YES;
    sendMessageCtl.conversationType = kSingle;
    JMSGConversation *conversation =[_conversationArr objectAtIndex:indexPath.row];
    sendMessageCtl.conversation = conversation;
    sendMessageCtl.conversationList = _conversationArr;
    [self.navigationController pushViewController:sendMessageCtl animated:YES];
    NSInteger badge = _unreadCount - [conversation.unread_cnt integerValue];
    [self saveBadge:badge];
}

- (void)saveBadge:(NSInteger)badge {
    [JPUSHService setBadge:badge];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",badge] forKey:kBADGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Via Jack Lucky
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar {
    
}

#pragma mark - SearchDisplay Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
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
