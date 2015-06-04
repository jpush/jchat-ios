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
 * 收取收到群成员变更通知和key
 */
extern NSString * const JMSGNotification_GroupMemberChange;
extern NSString * const JMSGNotification_GroupMemberKey;


@interface JMSGGroup : NSObject

@property (atomic,strong,readonly) NSString *gid;
@property (atomic,strong,readonly) NSString *group_owner;
@property (atomic,strong) NSString *group_name;
@property (atomic,strong) NSString *group_desc;
@property (atomic,strong) NSNumber *group_level;
@property (atomic,strong) NSNumber *group_flag;
@property (atomic,strong) NSString *group_members;


/**
*  创建一个群组
*
*  @param grounpName    群组名称
*  @param completionHandler 请求返回的block
*/
+ (void)createGroup:(JMSGGroup *)group
  completionHandler:(JMSGCompletionHandler)handler;

/**
*  向群组中添加成员
*
*  @param grounpID      群组ID
*  @param userIds       添加群组的成员的集合
*  @param callbackBlock 添加成员回调接口
*/
+ (void)addMembers:(NSString *)groupId
           members:(NSString *)members
 completionHandler:(JMSGCompletionHandler)handler;

/**
*  解散群组
*
*  @param groupID       解散群组的ID
*  @param callbackBlock 解散群组回调接口
*/
+ (void)deleteGroupMember:(NSString *)groupId
                  members:(NSString *)members
        completionHandler:(JMSGCompletionHandler)handler;

/**
*  用户退出群组
*
*  @param groupId       群组ID
*  @param userId        用户ID
*  @param callbackBlock 用户退出群组回调接口
*/
+ (void)exitGoup:(NSString *)groupId
    completionHandler:(JMSGCompletionHandler)handler;

/**
*  更新群组信息
*
*  @param handler       异步回调 Block。
*         Handler 里 resultObject 是更新后的群组信息，其内容类型是 JMSGGroup。
*/
+ (void)updateGroupInfo:(JMSGGroup *)group
      completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取一个群的所有组成员列表
*
*  @param handler       异步回调 Block。
*
*/
+ (void)getGroupMemberList:(NSString *)groupId
         completionHandler:(JMSGCompletionHandler)handler;

/**
*  获取当前登录用户（我）的所有群组列表
*
*  @param handler       异步回调 Block。
*
*/
+ (void)getGroupListWithCompletionHandler:(JMSGCompletionHandler)handler;

/**
* 获取群组信息
*
* @param gid 群组ID。
* @param handler 异步回调 Block。
*        handler 里 resultObject 是更新后的群组信息，其内容类型是 JMSGGroup。
*/
+ (void)getGroupInfo:(NSString *)groupId
   completionHandler:(JMSGCompletionHandler)handler;

@end

