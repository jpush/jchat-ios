//
//  ChatBubbleLayer.m
//  ChatImageBubbleDemo
//
//  Created by HuminiOS on 15/10/28.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "ChatBubbleLayer.h"

#define BubbleWidth self.bounds.size.width
#define BubbleHeight self.bounds.size.height

@implementation ChatBubbleLayer

- (void)drawInContext:(CGContextRef)ctx {
  if (_isReceivedBubble) {
    
    //  C----D    -
    //  |    |    | -> triangleY
    //  |    |    |
    // <     |    -
    //  |    |
    //  |    |
    //  B----A   四个点
    //
    UIBezierPath *bubblePath = [UIBezierPath bezierPath];
    // point A
    [bubblePath moveToPoint:CGPointMake(BubbleWidth  , BubbleHeight - cornerRadiuslength)];
    [bubblePath addQuadCurveToPoint:CGPointMake(BubbleWidth - cornerRadiuslength, BubbleHeight) controlPoint:CGPointMake(BubbleWidth - crossgrap, BubbleHeight)];
    // point B
    [bubblePath addLineToPoint:CGPointMake(cornerRadiuslength + crossgrap, BubbleHeight)];
    [bubblePath addQuadCurveToPoint:CGPointMake(crossgrap, BubbleHeight - cornerRadiuslength) controlPoint:CGPointMake(crossgrap, BubbleHeight)];
    // point C
    [bubblePath addLineToPoint:CGPointMake(crossgrap, cornerRadiuslength)];
    [bubblePath addQuadCurveToPoint:CGPointMake(cornerRadiuslength + crossgrap, 0) controlPoint:CGPointMake(crossgrap, 0)];
    // point D
    [bubblePath addLineToPoint:CGPointMake(BubbleWidth - cornerRadiuslength, 0)];
    [bubblePath addQuadCurveToPoint:CGPointMake(BubbleWidth, cornerRadiuslength) controlPoint:CGPointMake(BubbleWidth, 0)];
    [bubblePath closePath];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(crossgrap, triangleY)];
    [trianglePath addLineToPoint:CGPointMake(0, triangleY + 6)];
    [trianglePath addLineToPoint:CGPointMake(crossgrap, triangleY + 12)];
    [trianglePath closePath];
    CGContextAddPath(ctx, trianglePath.CGPath);
    
    CGContextAddPath(ctx, bubblePath.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:29.0/255.0 green:163.0/255.0 blue:1 alpha:1].CGColor);
    CGContextFillPath(ctx);

  } else {
    
  
  // C----D    -
  // |    |    | -> triangleY
  // |    |    |
  // |      >  -
  // |    |
  // |    |
  // B----A   四个点
  //
  UIBezierPath *bubblePath = [UIBezierPath bezierPath];
  // point A
  [bubblePath moveToPoint:CGPointMake(BubbleWidth - crossgrap , BubbleHeight - cornerRadiuslength)];
  [bubblePath addQuadCurveToPoint:CGPointMake(BubbleWidth - crossgrap - cornerRadiuslength, BubbleHeight) controlPoint:CGPointMake(BubbleWidth - crossgrap, BubbleHeight)];
  // point B
  [bubblePath addLineToPoint:CGPointMake(cornerRadiuslength, BubbleHeight)];
  [bubblePath addQuadCurveToPoint:CGPointMake(0, BubbleHeight - cornerRadiuslength) controlPoint:CGPointMake(0, BubbleHeight)];
  // point C
  [bubblePath addLineToPoint:CGPointMake(0, cornerRadiuslength)];
  [bubblePath addQuadCurveToPoint:CGPointMake(cornerRadiuslength, 0) controlPoint:CGPointMake(0, 0)];
  // point D
  [bubblePath addLineToPoint:CGPointMake(BubbleWidth - crossgrap - cornerRadiuslength, 0)];
  [bubblePath addQuadCurveToPoint:CGPointMake(BubbleWidth - crossgrap, cornerRadiuslength) controlPoint:CGPointMake(BubbleWidth - crossgrap, 0)];
  [bubblePath closePath];
  UIBezierPath *trianglePath = [UIBezierPath bezierPath];
  [trianglePath moveToPoint:CGPointMake(BubbleWidth - crossgrap, triangleY)];
  [trianglePath addLineToPoint:CGPointMake(BubbleWidth, triangleY + 6)];
  [trianglePath addLineToPoint:CGPointMake(BubbleWidth - crossgrap, triangleY + 12)];
  [trianglePath closePath];
  CGContextAddPath(ctx, trianglePath.CGPath);
  
  CGContextAddPath(ctx, bubblePath.CGPath);
  CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:29.0/255.0 green:163.0/255.0 blue:1 alpha:1].CGColor);
  CGContextFillPath(ctx);

}
}

@end
