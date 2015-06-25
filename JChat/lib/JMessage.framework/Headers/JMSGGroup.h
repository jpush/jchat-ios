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

/**
 * 收取收到群成员变更通知和key,用以更新当前会话展示的群组信息
 */
extern NSString * const JMSGNotification_GroupChange;
extern NSString * const JMSGNotification_GroupMemberKey;


@interface JMSGGroup : NSObject

/**
*  群组的gid,为long型的NSString包装
*/
@property (atomic,strong,readonly) NSString *gid;

/**
*  群组的拥有者
*/
@property (atomic,strong,readonly) NSString *groupOwner;

/**
*  群组的名称
*/
@property (atomic,strong) NSString *groupName;

/**
*  群组的描述
*/
@property (atomic,strong) NSString *groupDescription;

/**
*  群组的等级
*/
@property (atomic,strong, readonly) NSNumber *group_level;

/**
*  群组的flag(暂时未使用,保留属性)
*/
@property (atomic,strong) NSNumber *group_flag;

/**
*  群组成员,由每个成员的username,通过,(逗号)来分隔组成
*/
@property (atomic,strong) NSString *group_members;

/**
*  创建一个群组
*  group对象可填写信息为:groupName,groupDescription,group_flag(暂时无用处)
*  创建群组SDK自动会被自己加入group_members中,不需要自己做处理
*
*  @param group             待创建的群组
*  @param completionHandler 结果回调。resultObject值不需要关心,始终为nil
*/
+ (void)createGroup:(JMSGGroup *)group
  completionHandler:(JMSGCompletionHandler)handler;

/**
*  向群组中添加成员
*
*  @param groupId       群组ID
*  @param members       需要加入的群组成员(username)。多个成员时使用,(逗号)隔开。
*  @param callbackBlock 结果回调。resultObject值不需要关心,始终为nil
*/
+ (void)addMembers:(NSString *)groupId
           members:(NSString *)members
 completionHandler:(JMSGCompletionHandler)handler;

/**
* 群组删除成员
*
*  @param groupID       群组的ID
*  @param members       需要删除的群组成员(username)。多个成员时使用,(逗号)隔开。
*  @param callbackBlock 结果回调。resultObject值不需要关心,始终为nil
*/
+ (void)deleteGroupMember:(NSString *)groupId
                  members:(NSString *)members
        completionHandler:(JMSGCompletionHandler)handler;

/**
*  用户退出群组
*
*  @param groupId       待退出的群组ID
*  @param callbackBlock 结果回调。resultObject值不需要关心,始终为nil
*/
+ (void)exitGroup:(NSString *)groupId
completionHandler:(JMSGCompletionHandler)handler;

/**
*  更新群组信息
*
*  @param group         待更新的群组,目前支持的变更支持groupName,groupDescription,group_flag(暂时无用处)
*  @param handler       结果回调。resultObject值不需要关心,始终为nil
*/
+ (void)updateGroupInfo:(JMSGGroup *)group
      completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取一个群的所有组成员列表
*
*  @param handler       结果回调。正常返回时resultObject对象类型为NSArray,成员为JMSGUser类型。
*/
+ (void)getGroupMemberList:(NSString *)groupId
         completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取当前登录用户（我）的所有群组列表
*
*  @param handler       结果回调。正常返回时resultObject对象类型为NSArray,成员为JMSGGroup类型。
*
*/
+ (void)getGroupListWithCompletionHandler:(JMSGCompletionHandler)handler;

/**
* 获取群组信息
*
* @param groupId        群组ID。
* @param handler        结果回调。正常返回时resultObject对象类型为JMSGGroup。
*
*/
+ (void)getGroupInfo:(NSString *)groupId
   completionHandler:(JMSGCompletionHandler)handler;

@end

