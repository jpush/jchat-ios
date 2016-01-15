//
//  JCHATMsgAlertSoundTableViewCell.h
//  JChat
//
//  Created by HuminiOS on 15/8/3.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATMsgAlertSoundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *titleText;

- (void)setData;
@end
