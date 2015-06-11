//
//  JCHATFrIendDetailMessgeCell.m
//  极光IM
//
//  Created by Apple on 15/4/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATFrIendDetailMessgeCell.h"

@implementation JCHATFrIendDetailMessgeCell

- (void)awakeFromNib {
    // Initialization code
    [self.skipBtn.layer setMasksToBounds:YES];
    self.skipBtn.layer.cornerRadius = 4;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)skipToSendMessage:(id)sender {
    if (self.skipToSendMessage && [self.skipToSendMessage respondsToSelector:@selector(skipToSendMessage)]) {
        [self.skipToSendMessage skipToSendMessage];
    }
}

@end
