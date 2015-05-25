//
//  JCHATChatTableViewCell.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATChatTableViewCell.h"
#import "NSObject+TimeConvert.h"

@implementation JCHATChatTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSInteger height =0;
        if (kApplicationHeight <=480 ) {
            height = 75;
        }else {
            height = 80;
        }
        self.headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headDefalt_34"]];
        [self.headView setFrame:CGRectMake(5, height/2 - 46/2, 46, 46)];
        [self addSubview:self.headView];
        
        self.nickName = [[UILabel alloc] init];
        self.nickName.textColor = [UIColor grayColor];
        self.nickName.font = [UIFont boldSystemFontOfSize:15];
        [self.nickName setFrame:CGRectMake(46 +10, height/2 -50/2, 100, 25)];
        [self addSubview:self.nickName];
        
        self.message = [[UILabel alloc] init];
        self.message.textColor = [UIColor grayColor];
        self.message.font = [UIFont boldSystemFontOfSize:15];
        if (kScreenHeight >= 480) {
            [self.message setFrame:CGRectMake(46 +10 , self.nickName.frame.origin.y + self.nickName.frame.size.height, 150, 25)];
        }else {
            [self.message setFrame:CGRectMake(46 +10, self.nickName.frame.origin.y + self.nickName.frame.size.height, 120, 25)];
        }
        [self addSubview:self.message];
        
        self.time = [[UILabel alloc] init];
        self.time.font = [UIFont boldSystemFontOfSize:15];
        self.time.textColor = [UIColor blackColor];
        self.time.textAlignment = NSTextAlignmentRight;
        [self.time setFrame:CGRectMake(kApplicationWidth - 150 , height/2 - 40/2, 150, 40)];
        [self addSubview:self.time];

        self.nickName.textColor = UIColorFromRGB(0x3f80dd);
        self.message.textColor = UIColorFromRGB(0x808080);
        
        self.cellLine=[[UIView alloc] initWithFrame:CGRectMake(0, height-1, kApplicationWidth, 1)];
        [self.cellLine setBackgroundColor:[UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1]];
        [self addSubview:self.cellLine];
        
        self.messageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, height-30, 25, 25)];
        [self.messageNumberLabel.layer setMasksToBounds:YES];
        self.messageNumberLabel.layer.cornerRadius = 12.5;
        self.messageNumberLabel.layer.borderWidth = 1;
        self.messageNumberLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.messageNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self.messageNumberLabel setBackgroundColor:UIColorFromRGB(0x6599e4)];
        self.messageNumberLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.messageNumberLabel];
    }
    return self;
}

- (void)awakeFromNib {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setcellDataWithConversation:(JMSGConversation *)conversation {
    self.headView.layer.cornerRadius = 23;
    [self.headView.layer setMasksToBounds:YES];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:conversation.avatarThumb]) {
    [self.headView setImage:[UIImage imageWithContentsOfFile:conversation.avatarThumb]];
    }else {
    [self.headView setImage:[UIImage imageNamed:@"headDefalt_34.png"]];
    }
    if (conversation.latest_displayName != nil) {
    self.nickName.text = conversation.latest_displayName;
    }else {
    self.nickName.text = conversation.target_id;
    }
    
    if ([conversation.unread_cnt integerValue]>0) {
    [self.messageNumberLabel setHidden:NO];
    self.messageNumberLabel.text = [NSString stringWithFormat:@"%@",conversation.unread_cnt];
    } else {
    [self.messageNumberLabel setHidden:YES];
    }
    
    if (conversation.latest_date !=nil && ![conversation.latest_date isEqualToString:@"(null)"]) {
    self.time.text = [self getTimeDate:[conversation.latest_date longLongValue]];
    }else {
    self.time.text = @"";
    }
    if (conversation.latest_type == nil) {
    self.message.text =@"";
    return ;
    }
    
    if ([conversation.latest_type isEqualToString:@"text"]) {
    self.message.text = conversation.latest_text;
    }else if ([conversation.latest_type isEqualToString:@"image"]){
    self.message.text =@"[图片]";
    }else if ([conversation.latest_type isEqualToString:@"voice"]){
       self.message.text =@"[语音]";
    }
}

@end
