/*
 *	| |    | |  \ \  / /  | |    | |   / _______|
 *	| |____| |   \ \/ /   | |____| |  / /
 *	| |____| |    \  /    | |____| |  | |   _____
 * 	| |    | |    /  \    | |    | |  | |  |____ |
 *  | |    | |   / /\ \   | |    | |  \ \______| |
 *  | |    | |  /_/  \_\  | |    | |   \_________|
 *
 * Copyright (c) 2011 ~ 2015 Shenzhen HXHG. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <JMessage/JMSGConversation.h>


/*!
 @abstract 消息内容（抽象类）

 @discussion 所有消息内容的实体类，都直接或者间接继承这个类。很多 API 上使用这个抽象类作为类型。
 有少量时候，通过 API 你拿到的是这个类型，需要基于实际的 contentType 来转型为相应的具体子类，做进一步的动作。

    JMSGAbstractContent *content = oneMessage.content;
    if (oneMessage.contentType == kJMSGContentTypeText) {
        JMSGTextContent *textContent = (JMSGTextContent *)content;
        String text = textContent.text;
    }

 */
@interface JMSGAbstractContent : NSObject <NSCopying, NSCoding> {}

JMSG_ASSUME_NONNULL_BEGIN

/*!
 * @abstract 附加参数
 * @discussion 对某个类型的消息, 比如 VoiceContent, 可以附加参数以便用于业务逻辑
 */
@property(nonatomic, strong, readonly) NSDictionary * JMSG_NULLABLE extras;

- (nullable instancetype)init NS_UNAVAILABLE;

- (BOOL)addStringExtra:(NSString *)value forKey:(NSString *)key;

- (BOOL)addNumberExtra:(NSNumber *)value forKey:(NSString *)key;

/*!
 * @abstract 调用此方法得到 JSON 格式描述的 Message Content
 */
- (NSString *)toJsonString;

/*!
 * @abstract 判断消息类型是否相等
 * @discussion 对于媒体类的内容, 即使同样的内容, 每次也视为新的资源, 会生成不同的资源ID, 从而最终 content 不相等
 * 所有的子类都提供本方法
 */
- (BOOL)isEqualToContent:(JMSGAbstractContent * JMSG_NULLABLE)content;

JMSG_ASSUME_NONNULL_END

@end
