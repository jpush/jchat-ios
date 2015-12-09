//
//  ChatBubbleLayer.h
//  ChatImageBubbleDemo
//
//  Created by HuminiOS on 15/10/28.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

static NSInteger const cornerRadiuslength = 3; //倒角的半径
static NSInteger const crossgrap = 10; // bubble 尖角 的width
static NSInteger const triangleY = 15; // bubble 尖角 的frame.origin.y

@interface ChatBubbleLayer : CALayer
@property(assign, nonatomic)BOOL isReceivedBubble;// 左边泡泡

@end
