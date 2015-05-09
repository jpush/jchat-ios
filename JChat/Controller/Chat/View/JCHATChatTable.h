//
//  chatTable.h
//  JPush IM
//
//  Created by Apple on 15/3/4.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchTableViewDelegate <NSObject>
- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;
@end

@interface JCHATChatTable : UITableView

@property (nonatomic,assign) id<TouchTableViewDelegate> touchDelegate;

@end
