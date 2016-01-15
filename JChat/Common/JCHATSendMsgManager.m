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
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sendMsgManage = [[JCHATSendMsgManager alloc] init];
  });
  return sendMsgManage;
}

- (id)init {
  self = [super init];
  if (self) {
    _sendMsgListDic  = @{}.mutableCopy;
    _textDraftDic = @{}.mutableCopy;
  }
  return self;
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

- (void)updateConversation:(JMSGConversation *)conversation withDraft:(NSString *)draftString {
  NSString *key = nil;
  key = [JCHATStringUtils conversationIdWithConversation:conversation];
  _textDraftDic[key] = draftString;
}

- (NSString *)draftStringWithConversation:(JMSGConversation *)conversation {
  NSString *key = nil;
  key = [JCHATStringUtils conversationIdWithConversation:conversation];
  return _textDraftDic[key] ? _textDraftDic[key] : @"";
}
@end
