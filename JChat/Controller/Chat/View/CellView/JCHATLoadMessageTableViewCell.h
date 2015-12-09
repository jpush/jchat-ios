//
//  JCHATLoadMessageTableViewCell.h
//  JChat
//
//  Created by HuminiOS on 15/10/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATLoadMessageTableViewCell : UITableViewCell
{
  UIActivityIndicatorView *loadIndicator;
}

- (void)startLoading;
@end
