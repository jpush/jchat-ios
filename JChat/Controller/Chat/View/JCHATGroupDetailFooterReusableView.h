//
//  JCHATGroupDetailFooterReusableView.h
//  JChat
//
//  Created by HuminiOS on 15/11/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATGroupDetailViewController.h"

@interface JCHATGroupDetailFooterReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *footerTittle;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *quitGroupBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic)JCHATGroupDetailViewController *delegate;

- (void)setDataWithGroupName:(NSString *)groupName;
- (void)layoutToClearChatRecord;
- (void)layoutToQuitGroup;
@end
