//
//  JCHATFrIendDetailMessgeCell.h
//  极光IM
//
//  Created by Apple on 15/4/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SkipToSendMessageDelegate <NSObject>
/*跳转到聊天消息*/
- (void)skipToSendMessage;
@end

@interface JCHATFrIendDetailMessgeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (strong, nonatomic) id<SkipToSendMessageDelegate> skipToSendMessage;

@end
