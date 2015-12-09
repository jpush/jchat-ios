//
//  JCHATMessageTableView.h
//  JChat
//
//  Created by HuminiOS on 15/10/24.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATMessageTableView : UITableView
@property(assign,nonatomic)BOOL isFlashToLoad;

- (void)loadMoreMessage;
@end
