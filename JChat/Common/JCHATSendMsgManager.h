//
//  JCHATSendMsgManager.h
//  JChat
//
//  Created by HuminiOS on 15/10/30.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCHATSendMsgManager : NSObject
@property(strong, nonatomic)NSMutableDictionary *sendMsgListDic;

- (void)addMessage:(JMSGMessage *)imgMsg withConversation:(JMSGConversation *)conversation;

+ (JCHATSendMsgManager *)ins;
@end
