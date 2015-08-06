//
//  JCHATNewsReminderCtl.m
//  JPush IM
//
//  Created by Apple on 15/2/5.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATNewsReminderCtl.h"
#import "JChatConstants.h"
#import "JCHATDetailTableViewCell.h"
@interface JCHATNewsReminderCtl ()
{
    NSArray *titleArr;
    UITableView *newsReminderTable;
}
@end

@implementation JCHATNewsReminderCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0x3f80dd);
    self.navigationController.navigationBar.alpha=0.8;
    self.title=@"新消息提醒";
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
    shadow.shadowOffset = CGSizeMake(0,0);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     shadow,NSShadowAttributeName,
                                                                     [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                                                     nil]];
    titleArr = @[@"接受新消息通知",@"声音",@"震动"];
    
    newsReminderTable =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kScreenHeight-kNavigationBarHeight-kStatusBarHeight)];
    [newsReminderTable setBackgroundColor:[UIColor whiteColor]];
    newsReminderTable.scrollEnabled=NO;
    newsReminderTable.dataSource=self;
    newsReminderTable.delegate=self;
    newsReminderTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:newsReminderTable];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"JCHATDetailTableViewCell";
    JCHATDetailTableViewCell *cell = (JCHATDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATDetailTableViewCell" owner:self options:nil] lastObject];
    }
    cell.textLabel.text=[titleArr objectAtIndex:indexPath.row];
    return cell;
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
