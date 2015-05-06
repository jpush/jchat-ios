//
//  JMSGConversationSpec.m
//  极光IM
//
//  Created by zhang on 15/3/31.
//  Copyright 2015年 Apple. All rights reserved.
//

#import "Kiwi.h"
#import "JMSGConversation+JMSGInner.h"
#import "JMSGConversationManager+Inner.h"
#import "NSObject+JMSGUtils.h"
#import "JMSGMessage+Inner.h"
#import "JMSGManager.h"
#import "JMSGManager+execute.h"
#import "JMSGResultSet.h"
#import "JMessage.h"
#import "JMSGInnerMessageModel.h"

//#define WEAK(obj) typeof(obj) __weak weak##obj = obj;
//#define STRONG(obj) typeof(obj) __strong strong##obj = obj;

SPEC_BEGIN(JMSGConversationSpec)

describe(@"JMSGConversation", ^{
  context(@"when create single Conversation", ^(){
    __block JMSGConversation *conversation;
    __block JMSGInnerMessageModel *insertMessage;
    __block JMSGInnerMessage *mockMessage;

    beforeEach(^(){
      [
JMessage setupJMessage:nil appKey:@"f86800a09ca123ec7251c1db" channel:@"test" apsForProduction:TRUE category:nil];

      conversation = [[JMSGConversation alloc] initInnerConversationWithTargetUserName:@"user1"
                                                                                  type:kSingle
                                                                           avatarThumb:nil];
      //send Message Model
      mockMessage = [[JMSGInnerMessage alloc]init];
      mockMessage.targetUid = 1;
      mockMessage.fromUid = 2;
      mockMessage.text  = [@{@"msg_type":@"text", @"target_name":@"userNick1", @"target_id":@"user1", @"from_id":@"user2", @"from_name":@"userNick2", kExtra:@{@"test":@"extras"},@"msg_body": @{kTextContent:@"text"}, @"create_time":[self getCurrentTime], @"target_type":@"single"} mutableCopy];
      mockMessage.type = kSingleSendMessage;
      mockMessage.msgid = 100;
      mockMessage.resourcePath = @"test/resource";
      mockMessage.thumbPath    = @"test/thumb";
//      mockMessage.duration     = @"test/";
      [JMSGConversationManager insertMessage:mockMessage insertType:kSendInsert];

      //
      insertMessage = [[JMSGInnerMessageModel alloc] init];
      insertMessage.messageId = [NSString stringWithFormat:@"%zd",mockMessage.msgid];
      insertMessage.from_name = mockMessage.text[@"from_name"];
      insertMessage.from_nickName = nil;
      insertMessage.from_noteName = insertMessage.from_name;
      insertMessage.target_name = mockMessage.text[@"target_name"];
      insertMessage.target_nickName = nil;
      insertMessage.target_noteName = insertMessage.target_name;
      insertMessage.status = @(kSendSucceed);
      insertMessage.timestamp = mockMessage.text[@"create_time"];
      insertMessage.extra = mockMessage.text[kExtra];
      [insertMessage setInnerMessageType:kTextMessage];
    });
    afterEach(^() {
      conversation = nil;
      insertMessage = nil;

      [g_pService executeSelectWithBlock:^(BOOL *isSucceed, JMSGResultSet *resultSet) {
        /*delete all message*/
        NSString *messageTableName = [resultSet stringForColumn:@"msg_table_name"];
        NSString *updateSql = [NSString stringWithFormat:@"DELETE FROM %@ ", messageTableName];
        if (messageTableName) {
          [g_pService executeUpdateWithBlock:^(BOOL *updateIsSucceed){
          }usingSQLSentence:updateSql];
        }
      }usingSQLSentence:JMSG_SELECT_CONVERSATION_SQL_STRING(mockMessage.text[@"target_id"])];
    });

    __block NSError *error1;
    __block JMSGMessage *message;
    it(@"should getMessage", ^(){
      [conversation getMessage:insertMessage.messageId completionHandler:^(id resultObject, NSError *error){
        message = resultObject;
        error1 = error;
      }];
      [[expectFutureValue(error1) shouldEventuallyBeforeTimingOutAfter(30)] beNil];
      [[expectFutureValue(message) shouldEventuallyBeforeTimingOutAfter(30)] beNonNil];
    });
  });
});



SPEC_END
