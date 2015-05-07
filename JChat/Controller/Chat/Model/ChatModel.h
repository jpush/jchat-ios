//
//  ChatModel.h
//  test project
//
//  Created by guan jingFen on 14-3-10.
//  Copyright (c) 2014年 guan jingFen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

@interface ChatModel : NSObject
@property (nonatomic,strong)   NSString *messageId;
@property (nonatomic,strong)   NSString *targetName;
@property (nonatomic,strong)   NSString *avatar;
@property (nonatomic,strong)   NSString *displayName;
@property (nonatomic,strong)   NSString *chatContent;
@property (nonatomic,assign)   ConversationType chatType;
@property (nonatomic,strong)   NSString *voicePath;
@property (nonatomic,strong)   NSString *voiceTime;
@property (nonatomic,assign)   MessageContentType type;
@property (nonatomic,strong)   NSString  *pictureImgPath;
@property (nonatomic,strong)   NSString  *pictureThumbImgPath;
@property (nonatomic,assign)   MessageStatusType messageStatus;
@property (nonatomic,assign)   BOOL who;
@property (nonatomic,strong)   NSNumber *messageTime;
@property (nonatomic,assign)   NSInteger photoIndex;
@property (nonatomic,assign)   BOOL readState;
@property (nonatomic,strong)   JMSGConversation *conversation;
@property (nonatomic,assign)   BOOL sendFlag;

-(CGSize)getTextSize;
@end
