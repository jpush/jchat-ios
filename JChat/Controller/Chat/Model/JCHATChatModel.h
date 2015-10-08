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

@interface JCHATChatModel : NSObject
@property (nonatomic,strong)   NSString *messageId;
@property (nonatomic,strong)   NSString *targetId;
@property (nonatomic,strong)   NSString *fromId;
@property (nonatomic,strong)   NSData   *mediaData;
@property (nonatomic,strong)   NSString *avatar;
@property (nonatomic,strong)   NSString *displayName;
@property (nonatomic,strong)   NSString *chatContent;
@property (nonatomic,assign)   JMSGConversationType chatType;
@property (nonatomic,strong)   NSString *voicePath;
@property (nonatomic,strong)   NSString *voiceTime;
@property (nonatomic,assign)   JMSGMessageContentType type;
@property (nonatomic,strong)   NSString  *pictureImgPath;
@property (nonatomic,strong)   NSString  *pictureThumbImgPath;
@property (nonatomic,assign)   JMSGMessageStatusType messageStatus;
@property (nonatomic,assign)   BOOL who;
@property (nonatomic,strong)   NSNumber *messageTime;
@property (nonatomic,assign)   NSInteger photoIndex;
@property (nonatomic,assign)   BOOL readState;
@property (nonatomic,strong)   JMSGConversation *conversation;
@property (nonatomic,assign)   BOOL sendFlag;
@property (nonatomic,assign)   BOOL isSending;
@property (nonatomic,assign)   float contentHeight;
@property (nonatomic,assign)   CGSize imageSize;
-(float)getTextHeight;
-(CGSize)getImageSize;
@end
