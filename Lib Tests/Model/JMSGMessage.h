#import <Foundation/Foundation.h>
#import "JMSGCommon.h"

@class JMSGConversation;

@interface JMSGMessage : NSObject

 @property (nonatomic, strong) NSString              *messageId;   //聊天ID

 @property (nonatomic, strong) NSString              *from_name;
 @property (nonatomic, strong) NSString              *from_nickName;
 @property (nonatomic, strong) NSString              *from_noteName;
 @property (nonatomic, strong) NSString              *target_name;
 @property (nonatomic, strong) NSString              *target_nickName;
 @property (nonatomic, strong) NSString              *target_noteName;


 @property (nonatomic, strong) NSNumber              *status;     //消息的状态
 @property (nonatomic, strong) NSNumber              *timestamp;  //消息时间戳
 @property (nonatomic, strong) NSString              *mediaID;  //media ID

 @property (nonatomic, strong) NSDictionary          *extra;
 @property (nonatomic, strong) NSDictionary          *custom;

 @property (nonatomic, assign, readonly)MessageContentType  messageType;
 @property (nonatomic, strong) JMSGConversation *conversation;

 - (instancetype)init;

@end

@interface JMSGMediaMessage : JMSGMessage <NSCopying>

 @property(nonatomic, strong)JMSGonProgressUpdate     progressCallback;
 @property (nonatomic, strong)NSString               *resourcePath;

@end

@interface JMSGContentMessage : JMSGMessage <NSCopying>

 @property(nonatomic, strong)NSString                *contentText;

@end

@interface JMSGImageMessage : JMSGMediaMessage <NSCopying>

 @property(nonatomic, strong)NSString                *thumbPath;

@end

@interface JMSGVoiceMessage : JMSGMediaMessage <NSCopying>

 @property(nonatomic, strong)NSString                *duration;

@end
