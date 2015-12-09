//
//  JCHATSendMsgController.h
//  JChat
//
//  Created by HuminiOS on 15/10/30.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCHATSendMsgController : NSObject<JMessageDelegate>

@property(strong, nonatomic)JMSGConversation *msgConversation;
@property(strong, nonatomic)NSMutableArray *draftImageMessageArr;

- (void)prepareImageMessage:(JMSGMessage *)imgMsg;
- (void)removeDelegate;
- (void)addDelegateForConversation:(JMSGConversation *)conversation;
@end
