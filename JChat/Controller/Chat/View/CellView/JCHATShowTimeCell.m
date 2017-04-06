//
//  JCHATShowTimeCell.m
//  JPush IM
//
//  Created by Apple on 15/1/13.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATShowTimeCell.h"
#import "JCHATStringUtils.h"


@implementation JCHATShowTimeCell

- (void)awakeFromNib {
  // Initialization code
  [self setBackgroundColor:[UIColor clearColor]];
  self.messageTimeLabel.font = [UIFont systemFontOfSize:14];
  self.messageTimeLabel.textColor = [UIColor grayColor];
  self.messageTimeLabel.textAlignment = NSTextAlignmentCenter;
  self.messageTimeLabel.numberOfLines = 0;
  self.messageTimeLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setCellData:(id)model {
  self.model = model;
  [self setContentFram];
}

- (void)layoutSubviews {
  //  [self setContentFram];
}


- (void)setContentFram {
  UIFont *font =[UIFont systemFontOfSize:14];
  CGSize maxSize = CGSizeMake(200, 2000);
  
  NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
  CGSize realSize = [[JCHATStringUtils getFriendlyDateString:[self.model.messageTime doubleValue]] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
  [self.messageTimeLabel setFrame:CGRectMake(self.messageTimeLabel.frame.origin.x, self.messageTimeLabel.frame.origin.y, realSize.width,realSize.height)];
  self.messageTimeLabel.text= [NSString stringWithFormat:@"%@",self.model.messageTime];
}

@end
