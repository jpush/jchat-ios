//
//  JPIMDetailsInfoViewController.h
//  
//
//  Created by Apple on 15/1/21.
//
//

#import <UIKit/UIKit.h>
#import "JPIMDetailTableViewCell.h"
#import "ChatModel.h"
#import <JMessage/JMessage.h>

@interface JPIMDetailsInfoViewController : UIViewController
@property (nonatomic,strong) JMSGUser *chatUser;
@property (nonatomic,strong) JMSGConversation *conversation;

@end
