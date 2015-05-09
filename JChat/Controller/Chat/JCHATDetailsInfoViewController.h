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
#import <JMessage/JMessage.h>

@interface JCHATDetailsInfoViewController : UIViewController
@property (nonatomic,strong) JMSGUser *chatUser;
@property (nonatomic,strong) JMSGConversation *conversation;

@end
