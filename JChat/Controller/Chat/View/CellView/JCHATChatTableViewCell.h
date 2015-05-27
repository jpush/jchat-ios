//
//  JCHATChatTableViewCell.h
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JChatConstants.h"
#import <JMessage/JMessage.h>


@interface JCHATChatTableViewCell : UITableViewCell
@property(strong, nonatomic) UIImageView *headView;
@property(strong, nonatomic) UILabel *nickName;
@property(strong, nonatomic) UILabel *message;
@property(strong, nonatomic) UILabel *time;
@property(nonatomic, strong) UIView *cellLine;
@property(nonatomic, strong) UILabel *messageNumberLabel;

- (void)setCellDataWithConversation:(JMSGConversation *)conversation;

@end
