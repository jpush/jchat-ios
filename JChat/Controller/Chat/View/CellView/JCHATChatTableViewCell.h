//
//  JCHATChatTableViewCell.h
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
// TODO: 改成nib

#import <UIKit/UIKit.h>
#import "JChatConstants.h"


@interface JCHATChatTableViewCell : UITableViewCell
//@property(strong, nonatomic) UIImageView *headView;
//@property(strong, nonatomic) UILabel *nickName;
//@property(strong, nonatomic) UILabel *message;
//@property(strong, nonatomic) UILabel *time;
//@property(nonatomic, strong) UIView *cellLine;
//@property(nonatomic, strong) UILabel *messageNumberLabel;
@property(strong, nonatomic) NSString *conversationId;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *messageNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *cellLine;

- (void)setCellDataWithConversation:(JMSGConversation *)conversation;

@end
