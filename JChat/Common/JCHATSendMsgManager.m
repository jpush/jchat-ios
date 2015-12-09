//
//  JCHATSendMsgManager.m
//  JChat
//
//  Created by HuminiOS on 15/10/30.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATSendMsgManager.h"
#import "JCHATSendMsgController.h"

@implementation JCHATSendMsgManager
+ (JCHATSendMsgManager *)ins {
  static JCHATSendMsgManager *sendMsgManage = nil;
  if (sendMsgManage == nil) {
    sendMsgManage = [[JCHATSendMsgManager alloc] init];
  }
  return sendMsgManage;
}

- (void)addMessage:(JMSGMessage *)imgMsg withConversation:(JMSGConversation *)conversation {
  NSString *key = nil;
  if (conversation.conversationType == kJMSGConversationTypeSingle) {
    key = ((JMSGUser *)conversation.target).username;
  } else {
    key = ((JMSGGroup *)conversation.target).gid;
  }
  
  if (_sendMsgListDic[key] == nil) {
    JCHATSendMsgController *sendMsgCtl = [[JCHATSendMsgController alloc] init];
    sendMsgCtl.msgConversation = conversation;
    [sendMsgCtl addDelegateForConversation:conversation];
    [sendMsgCtl prepareImageMessage:imgMsg];
    _sendMsgListDic[key] = sendMsgCtl;
  } else {
    JCHATSendMsgController *sendMsgCtl = _sendMsgListDic[key];
    [sendMsgCtl prepareImageMessage:imgMsg];
  }
}

- (id)init {
  self = [super init];
  if (self) {
    _sendMsgListDic  = @{}.mutableCopy;
  }
  return self;
}


@end
