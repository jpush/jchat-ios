//
//  JPIMGroupSettingCtl.m
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JPIMGroupSettingCtl.h"
#import "JChatConstants.h"
#import "JPIMGroupSettingCell.h"
#import "JPIMGroupPersonView.h"

#define kheadViewHeight 100

@interface JPIMGroupSettingCtl ()
{
    UIScrollView *_headView;
    NSArray *_groupTitleData;
    NSMutableArray *_groupData;
    UIButton *_deleteBtn;
    NSMutableArray *_groupBtnArr;
}
@end

@implementation JPIMGroupSettingCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self laodData];
    JPIMLog(@"Action");
    self.groupTab = [[ChatTable alloc]initWithFrame:CGRectMake(0, 0, kApplicationWidth, kScreenHeight)];
    self.groupTab.dataSource = self;
    self.groupTab.delegate = self;
    self.groupTab.touchDelegate = self;
    [self.groupTab setBackgroundColor:[UIColor whiteColor]];
    self.groupTab.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.groupTab];
   
    self.title=@"聊天详情";
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
    _groupTitleData =@[@"群聊名称",@"清空聊天记录",@"删除并退出"];
    
    _headView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, kApplicationWidth, kheadViewHeight)];
    [_headView setBackgroundColor:[UIColor whiteColor]];
    UIView *headLine = [[UIView alloc]initWithFrame:CGRectMake(0, kheadViewHeight-1, kApplicationWidth, 1)];
    [headLine setBackgroundColor:[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:197/255.0]];
    [_headView addSubview:headLine];
    _headView.showsHorizontalScrollIndicator =NO;
    _headView.showsVerticalScrollIndicator =NO;
    self.groupTab.tableHeaderView = _headView;
    
    [self reloadHeadViewData];
}

- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
    JPIMGroupSettingCell *groupNameCell =(JPIMGroupSettingCell *)[self.groupTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [groupNameCell.groupName resignFirstResponder];
    [self showDeleteMemberIcon:NO];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)laodData {
    NSString *name;
    _groupData = [[NSMutableArray alloc]init];
    for (NSInteger i=0; i<3; i++) {
        if (i == 0) {
            name = @"账上";
        }else if (i ==1) {
            name = @"张三";
        }else if (i ==2) {
            name = @"李四";
        }
        [_groupData addObject:name];
    }
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
        NSArray *personXib = [[NSBundle mainBundle]loadNibNamed:@"JPIMGroupPersonView"owner:self options:nil];
       JPIMGroupPersonView * personView = [personXib objectAtIndex:0];
        [personView setFrame:CGRectMake(10+(i * (56 + 10)), 10, 56, 75)];
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
            [personView.headViewBtn setImage:[UIImage imageNamed:@"headDefalt_34"] forState:UIControlStateNormal];
            personView.headViewBtn.tag = 1000+i;
            personView.memberLable.text = [_groupData objectAtIndex:i];
        }
    }
    [self reloadHeadScrollViewContentSize];
}


- (void)reloadHeadScrollViewContentSize {
    [_headView setContentSize:CGSizeMake(10 +((56+10) *[_groupBtnArr count]), _headView.bounds.size.height)];
}

- (void)groupPersonBtnClick:(JPIMGroupPersonView *)personView
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

- (void)deleteMemberWithPersonView:(JPIMGroupPersonView *)personView {
    if ([_groupData count] == 1) {
        return;
    }
    [personView removeFromSuperview];
    [_groupBtnArr removeObjectAtIndex:personView.headViewBtn.tag - 1000];
    [_groupData removeObjectAtIndex:personView.headViewBtn.tag - 1000];
    [self reloadGroupPersonViewFrame];

    if ([_groupData count] == 1) {
        JPIMGroupPersonView *personView = [_groupBtnArr lastObject];
        if (personView.headViewBtn.tag == 20000) {
            [personView removeFromSuperview];
            [_groupBtnArr removeLastObject];
            [self showDeleteMemberIcon:NO];
        }
        return;
    }
}

- (void)reloadGroupPersonViewFrame {
    for (NSInteger i=0; i<[_groupBtnArr count]; i++) {
        JPIMGroupPersonView *personView = [_groupBtnArr objectAtIndex:i];
        personView.memberLable.text = @"";
        if (i <= [_groupData count] -1) {
            personView.headViewBtn.tag = 1000+i;
            personView.memberLable.text = [_groupData objectAtIndex:i];
        }
        [UIView animateWithDuration:0.3 animations:^{
            [personView setFrame:CGRectMake(10+(i * (56 + 10)), 10, 56, 75)];
        }];
    }
    [self reloadHeadScrollViewContentSize];
}

- (void)showDeleteMemberIcon:(BOOL)flag {
    for (UIView *view in _headView.subviews) {
        if ([view isKindOfClass:[JPIMGroupPersonView class]]) {
            JPIMGroupPersonView *merberView = (JPIMGroupPersonView *)view;
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
        JPIMGroupSettingCell *cell = (JPIMGroupSettingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JPIMGroupSettingCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor clearColor]];
            UIView *cellLine = [[UIView alloc]initWithFrame:CGRectMake(0, 53, kApplicationWidth, 1)];
            [cellLine setBackgroundColor:[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:197/255.0]];
            [cell addSubview:cellLine];
            cell.groupName.textAlignment = NSTextAlignmentRight;
        }
        cell.groupTitle.text = [_groupTitleData objectAtIndex:indexPath.row];
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
        [self addMember:[alertView textFieldAtIndex:0].text];
    }else {
    }
}

- (void)addMember:(NSString *)memberName {
    [_groupData addObject:memberName];
    if ([_groupBtnArr count] ==2) {
        for (NSInteger i=0; i<2; i++) {
            NSArray *personXib = [[NSBundle mainBundle]loadNibNamed:@"JPIMGroupPersonView"owner:self options:nil];
            JPIMGroupPersonView * personView = [personXib objectAtIndex:0];
            if (i==0) {
                personView.headViewBtn.tag =1000 +i;
                [_groupBtnArr insertObject:personView atIndex:1];
                personView.delegate = self;
                [personView.headViewBtn setImage:[UIImage imageNamed:@"headDefalt_34"] forState:UIControlStateNormal];
            }else {
                personView.headViewBtn.tag =20000;//删除按钮标示
                [_groupBtnArr addObject:personView];
                personView.delegate = self;
                _deleteBtn =personView.headViewBtn;
                [personView.headViewBtn setImage:[UIImage imageNamed:@"deleteMan"] forState:UIControlStateNormal];
            }
            [personView setFrame:CGRectMake(10+([_groupData count]-1 * (56 + 10)), 10, 56, 75)];
            [personView.deletePersonBtn setHidden:YES];
            [_headView addSubview:personView];
        }
    } else {
        NSArray *personXib = [[NSBundle mainBundle]loadNibNamed:@"JPIMGroupPersonView"owner:self options:nil];
        JPIMGroupPersonView * personView = [personXib objectAtIndex:0];
        [personView.deletePersonBtn setHidden:YES];
        personView.headViewBtn.tag = 1000+[_groupData count]-1;
        personView.delegate = self;
        [personView.headViewBtn setImage:[UIImage imageNamed:@"headDefalt_34"] forState:UIControlStateNormal];
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
