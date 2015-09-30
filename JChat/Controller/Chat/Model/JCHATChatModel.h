//
//  JCHATChatModel.h
//  test project
//
//  Created by guan jingFen on 14-3-10.
//  Copyright (c) 2014年 guan jingFen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

@interface JCHATChatModel : NSObject //去掉
@property (nonatomic, strong) JMSGMessage * message;
@property (nonatomic, strong) JMSGUser *fromUser;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *targetId;
//@property (nonatomic,strong)  id target;

@property (nonatomic, strong) NSString *fromId; //重复
@property (nonatomic, strong) NSData   *mediaData;
@property (nonatomic, strong) NSData *avatar;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *chatContent;
@property (nonatomic, assign) JMSGConversationType chatType;
@property (nonatomic, strong) NSString *voicePath;
@property (nonatomic, strong) NSString *voiceTime;
@property (nonatomic, assign) JMSGContentType type;
@property (nonatomic, strong) NSString  *pictureImgPath;
@property (nonatomic, strong) NSString  *pictureThumbImgPath;
@property (nonatomic, assign) JMSGMessageStatus messageStatus;
@property (nonatomic, assign) BOOL isReceived;
@property (nonatomic, strong) NSNumber *messageTime;
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, assign) BOOL readState;
@property (nonatomic, strong) JMSGConversation *conversation; //
@property (nonatomic, assign) BOOL sendFlag;
@property (nonatomic, assign) BOOL isSending;
@property (nonatomic, assign) float contentHeight;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) BOOL isTime;

-(float)getTextHeight;
-(CGSize)getImageSize;

-(void)setChatModelWith:(JMSGMessage *)message conversationType:(JMSGConversation *)conversation;

@end
