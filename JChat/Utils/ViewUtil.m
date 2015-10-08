//
//  ViewUtil.m
//  JChat
//
//  Created by HuminiOS on 15/7/23.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil
+ (UIImage *)colorImage:(UIColor *)c frame:(CGRect)frame {
  static NSMutableDictionary *imageCache;
  if (!imageCache) { imageCache = [[NSMutableDictionary alloc] init];}
  
  CGFloat w = frame.size.width;
  CGFloat h = frame.size.height;
  
  NSString *cache_key = [NSString stringWithFormat:@"%@_%d_%d",c, (int)w, (int)h];
  
  if (![imageCache objectForKey:cache_key]) {
    UIImage *img;
    CGRect rect=CGRectMake(0.0f, 0.0f, w, h);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [c CGColor]);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageCache[cache_key] = img;
  }
  
  return imageCache[cache_key];
}


+ (UIView *)nib:(char *)nib {
  NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:[NSString stringWithUTF8String:nib]
                                              owner:self
                                            options:nil];
  return [nibs objectAtIndex:0];
}

+ (UIView *)nib:(char *)nib owner:(id)owner{
  NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:[NSString stringWithUTF8String:nib]
                                              owner:owner
                                            options:nil];
  return [nibs objectAtIndex:0];
}


+ (UITableViewCell *)table:(UITableView *)table nib:(char *)nib {
  UITableViewCell *cell = (UITableViewCell *)[table dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:nib]];
  if (cell == nil) {
    cell = (UITableViewCell *)[self nib:nib];
  }
  return cell;
}

+ (void)table:(UITableView *)table registerNib:(char *)nib {
  [table registerNib:[UINib nibWithNibName:[NSString stringWithUTF8String:nib] bundle:nil] forCellReuseIdentifier:[NSString stringWithUTF8String:nib]];
}



@end
