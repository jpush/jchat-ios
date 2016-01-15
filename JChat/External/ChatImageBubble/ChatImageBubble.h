//
//  ChatImageBubble.h
//  ChatImageBubbleDemo
//
//  Created by HuminiOS on 15/10/28.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBubbleLayer.h"

@interface ChatImageBubble : UIImageView
@property (strong, nonatomic)ChatBubbleLayer *maskBubbleLayer;
@property (assign, nonatomic)BOOL isReceivedBubble;
- (void)setBubbleSide:(BOOL)isReci;
@end
