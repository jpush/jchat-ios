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
#import <JMessage/JMSGConstants.h>

@class JMSGUser;

@interface JMSGGroup : NSObject

///----------------------------------------------------
/// @name Class methods 类方法
///----------------------------------------------------

/*!
 @abstract 创建群组。

 @param groupName 群组名称
 @param groupDesc 群组描述信息
 @param usernameArray 初始成员列表。NSArray 里的类型是 NSString
 @param handler 结果回调。正常时 resultObject 的类型是 JMSGGroup。

 @discussion 向服务器端提交创建群组请求，服务器端会生成群组ID，可以基于这个ID做后续很多操作。
 */
+ (void)createGroupWithName:(NSString *)groupName
                description:(NSString *)groupDesc
                memberArray:(NSArray *)usernameArray
          completionHandler:(JMSGCompletionHandler)handler;

/**
*  更新群组信息
*
*  @param handler       异步回调 Block。
*         Handler 里 resultObject 是更新后的群组信息，其内容类型是 JMSGGroup。
*/
+ (void)updateGroupInfoWithGroup:(JMSGGroup *)group
               completionHandler:(JMSGCompletionHandler)handler;

/**
* 获取群组信息
*
* @param groupId 群组ID。
* @param handler 异步回调 Block。
*        handler 里 resultObject 是更新后的群组信息，其内容类型是 JMSGGroup。
*/
+ (void)groupInfoWithGroupId:(NSString *)groupId
           completionHandler:(JMSGCompletionHandler)handler;

/*!
 @abstract 获取我的群组列表

 @param handler 结果回调。正常返回时 resultObject 的类型是 NSArray，数组里的成员类型是 JMSGGroup

 @discussion 该接口总是向服务器端发起请求。
 */
+ (void)myGroupArray:(JMSGCompletionHandler)handler;


///----------------------------------------------------
/// @name Group basic fields 群组基本属性
///----------------------------------------------------


/*!
 @abstract 群组ID

 @discussion 该ID由服务器端生成，全局唯一。可以用于服务器端 API。
 */
@property(nonatomic, strong, readonly) NSString *gid;

/*!
 @abstract 群组名称

 @discussion 用于群组聊天的展示名称；以及向群组发消息时的 target_name
 */
@property(nonatomic, copy, readonly) NSString *name;

/*!
 @abstract 群组描述信息
 */
@property(nonatomic, copy, readonly) NSString *desc;

/*!
 @abstract 群组等级

 @discussion 不同等级的群组，人数上限不同。当前默认等级 4，人数上限 200。客户端不可更改。
 */
@property(nonatomic, strong, readonly) NSNumber *level;

/*!
 @abstract 群组设置标志位

 @discussion 这是一个内部状态标志，对外展示仅用于调试目的。客户端不可更改。
 */
@property(nonatomic, strong, readonly) NSNumber *flag;

/*!
 @abstract 群主（用户的 username）

 @discussion 有一套确认群主的策略。简单地说，群创建人是群主；如果群主退出，则是第二个加入的人，以此类似。客户端不可更改。
 */
@property(nonatomic, copy, readonly) NSString *owner;


/*!
 @abstract 获取群组成员列表

 @param groupId 群组ID
 @param handler 结果回调。正常返回时 resultObject 为 NSArray 类型，数组里的成员类型为 JMSGUser。

 @discussion 一般在群组成员界面调用此接口，展示群组的所有成员列表。
 本接口只是在本地请求成员列表，不会发起服务器端请求。
 */
- (NSArray *)memberArray;

/*!
 @abstract 向群组中添加成员

 @param usernameArray 用户名数组。数据里的成员类型是 NSString
 @param handler 结果回调。正常返回时 resultObject 为当前新加入的成员数据。数据里成员类型为 JMSGUser
 */
- (void)addMembersFromUsernameArray:(NSArray *)usernameArray
                  completionHandler:(JMSGCompletionHandler)handler;

/*!
 @abstract 删除群成员

 @param usernameArray 元素是 username
 @param handler 结果回调。正常返回时 resultObject 为 当前删除成员数组，数组里的成员类型为 JMSGUser
 */
- (void)removeMembersFromUsernameArray:(NSArray *)usernameArray
                     completionHandler:(JMSGCompletionHandler)handler;

/*!
 @abstract 我退出当前群组

 @param handler 结果回调。正常返回时 resultObject 为 nil。
 */
- (void)exit:(JMSGCompletionHandler)handler;

/*!
 @abstract 群组的展示名

 @discussion 如果 group_name 存在则就是 group_name。否则返回 “群聊”（中文）。
 */
- (NSString *)displayName;

- (BOOL)isEqualToGroup:(JMSGGroup *)group;

@end


