//
//  JCHATMsgAlertStateTableViewCell.h
//  JChat
//
//  Created by HuminiOS on 15/8/3.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATMsgAlertStateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleMain;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *stateLable;

- (void)setData;
@end
