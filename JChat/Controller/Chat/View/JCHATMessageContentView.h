//
//  JCHATMessageContentView.h
//  JChat
//
//  Created by HuminiOS on 15/11/2.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatImageBubble.h"

@interface JCHATMessageContentView :ChatImageBubble
@property(assign, nonatomic)BOOL isReceivedSide;

@property(strong, nonatomic)UILabel *textContent;
@property(strong, nonatomic)UIImageView *voiceConent;

- (void)setMessageContentWith:(JMSGMessage *)message;
@end
