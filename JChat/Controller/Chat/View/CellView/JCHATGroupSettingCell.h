//
//  JCHATGroupSettingCell.h
//  JPush IM
//
//  Created by Apple on 15/3/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATGroupSettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *groupTitle;
@property (weak, nonatomic) IBOutlet UITextField *groupName;

//- (void)setDataWithConversation:(JMSGConversation *)conversation;
@end
