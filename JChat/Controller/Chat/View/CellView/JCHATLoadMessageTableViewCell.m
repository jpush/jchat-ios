//
//  JCHATLoadMessageTableViewCell.m
//  JChat
//
//  Created by HuminiOS on 15/10/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATLoadMessageTableViewCell.h"
#import "JChatConstants.h"
@implementation JCHATLoadMessageTableViewCell

- (void)awakeFromNib {
  // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self != nil) {
    loadIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kApplicationWidth/2 - 10, 10, 20, 20)];
    [loadIndicator startAnimating];
    loadIndicator.hidesWhenStopped = NO;
    loadIndicator.color = [UIColor grayColor];
    [self addSubview:loadIndicator];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}
- (void)startLoading {
  [loadIndicator startAnimating];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
