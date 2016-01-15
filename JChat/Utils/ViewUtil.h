//
//  ViewUtil.h
//  JChat
//
//  Created by HuminiOS on 15/7/23.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NIB(x)  (x *)[ViewUtil nib:#x]
#define NIB_OWN(x, y)  (x *)[ViewUtil nib:#x owner:y]
#define REG_NIB(x, y)  [ViewUtil table:x registerNib:#y]
#define CELL(x, y) (y *)[ViewUtil table:x nib:#y]


@interface ViewUtil : NSObject
+ (UIImage *)colorImage:(UIColor *)c frame:(CGRect)frame;

+ (UIView *)nib:(char *)nib;
+ (UIView *)nib:(char *)nib owner:(id)owner;

+ (UITableViewCell *)table:(UITableView *)table nib:(char *)nib;
+ (void)table:(UITableView *)table registerNib:(char *)nib;
@end
