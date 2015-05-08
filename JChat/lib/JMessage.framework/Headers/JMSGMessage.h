#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JMessage/JMSGConstants.h>

@class JMSGConversation;

/***************************************声明枚举类型*********************************************/
extern NSString *JMSGSendMessageResult;
#define JMSGSendMessageObject  @"message"
#define JMSGSendMessageError   @"error"

/**
 *  收取收到消息通知
 */
extern NSString *KJMSG_ReceiveMessage;

/**
 *  消息内容类型
 */
typedef NS_ENUM(NSInteger, MessageContentType) {
    kTextMessage = 0,
    kImageMessage,
    kVoiceMessage,
    kCustomMessage,
    kLocationMessage,
    kCmdMessage,
    kTimeMessage,
};

/**
 *  消息状态类型
 */
typedef NS_ENUM(NSInteger, MessageStatusType) {
    kNone,
    kSendSucceed ,
    kSendFail,
    kSending,
    kUploadSucceed,
    kSendDraft,
    kReceiving,
    kReceiveSucceed,
    kReceiveFailed,
    kReceiveDownloadFailed,
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, MessageMetaType) {
    kSendType,
    kReceiveType,
};

/**
 *  上传文件类型
 */
typedef NS_ENUM(NSInteger, FileType) {
    kTextFileType,
    kImageFileType,
    kVoiceFileType,
    kCustomFileType,
};
/*******************************************************************************************/

@interface JMSGMessage : NSObject <NSCopying>

 @property (atomic, strong, readonly) NSString            *messageId;   //聊天ID
 @property (atomic, strong) NSString                    *target_name;
 @property (atomic, strong, getter=display_name) NSString *display_name;

 @property (atomic, strong)   NSDictionary                *extra;
 @property (atomic, strong)   NSDictionary                *custom;

 @property (assign, readonly) MessageContentType           messageType;
 @property (atomic, strong  ) JMSGConversation            *conversation;
 @property (atomic, strong  ) NSNumber                    *timestamp;  //消息时间戳
 @property (strong, readonly) NSNumber                    *status;     //消息的状态


 - (instancetype)init;

@end

@interface JMSGMediaMessage : JMSGMessage <NSCopying>

 @property (atomic, strong)JMSGonProgressUpdate   progressCallback;
 @property (atomic, strong)NSString              *resourcePath;
 @property (atomic, assign)CGSize                 imgSize;

@end

@interface JMSGContentMessage : JMSGMessage <NSCopying>

 @property(atomic, strong)NSString                *contentText;

@end

@interface JMSGImageMessage : JMSGMediaMessage <NSCopying>

 @property(atomic, strong)NSString                *thumbPath;

@end

@interface JMSGVoiceMessage : JMSGMediaMessage <NSCopying>

 @property(atomic, strong)NSString                *duration;

@end
