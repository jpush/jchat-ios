#import <Foundation/Foundation.h>
#import "JMSGCommon.h"

@interface JMSGConversationModel : NSObject

 @property (nonatomic, strong) NSString *Id;//聊天会话ID
 @property (nonatomic, strong) NSString *type;//聊天会话类型
 @property (nonatomic, strong) NSString *target_id;//聊天会话目标id
 @property (nonatomic, strong) NSString *target_displayName;//聊天对象的昵称

 @property (nonatomic, strong) NSString *latest_type;//最后消息的内容类型
 @property (nonatomic, strong) NSString *latest_text;//最后消息内容
 @property (nonatomic, strong) NSString *latest_date;//最后消息日期
 @property (nonatomic, strong) NSString *latest_displayName;
 @property (nonatomic, assign) MessageStatusType latest_text_state;

 @property (nonatomic, strong) NSNumber *unread_cnt;//未读消息数量
 @property (nonatomic, assign) MessageStatusType latest_messageStatus;//最后消息状态
 @property (nonatomic, strong) NSString *latest_target_displayName;//最后消息展示名
 @property (nonatomic, strong) NSString *msg_table_name;//该会话所对应的Message表的表名

@end
