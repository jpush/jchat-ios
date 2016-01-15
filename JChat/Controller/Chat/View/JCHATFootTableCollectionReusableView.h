//
//  JCHATFootTableCollectionReusableView.h
//  JChat
//
//  Created by oshumini on 15/12/15.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHATFootTableCollectionReusableView : UICollectionReusableView<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *footTableView;
@end
