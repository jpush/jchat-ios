//
//  JCHATDetailsInfoViewController.h
//  
//
//  Created by Apple on 15/1/21.
//
//

#import <UIKit/UIKit.h>
#import "JCHATDetailTableViewCell.h"
#import "JCHATChatModel.h"
#import "JCHATConversationViewController.h"

typedef NS_ENUM(NSInteger, AlertViewTagInDetailVC) {
  //清除聊天记录
  kAlertViewTagClearSingleChatRecord = 100,
  //创建群聊
  kAlertViewTagCreateGroup = 200,
};

@interface JCHATDetailsInfoViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic,strong) JMSGConversation *conversation;
@property (nonatomic,strong) JCHATConversationViewController *sendMessageCtl;

@end
