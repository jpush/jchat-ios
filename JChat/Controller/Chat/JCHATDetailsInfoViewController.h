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
#import "JCHATChatViewController.h"

@interface JCHATDetailsInfoViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic,strong) JMSGConversation *conversation;
@property (nonatomic,strong) JCHATChatViewController *sendMessageCtl;

@end
