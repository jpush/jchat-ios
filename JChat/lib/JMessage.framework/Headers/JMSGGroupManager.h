//
//  JMSGGroupRequest.h
//  JPush IM
//
//  Created by Apple on 15/1/20.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMSGConstants.h>

@interface JMSGGroupManager : NSObject
/**
 *
 *
 *  @param completionHandler 请求返回的block
 */

/**
 *  创建一个群组
 *
 *  @param grounpName    群组名称
 *  @param callbackBlock 创建群组回调接口
 */
+(void)createGroupWithParameter:(NSDictionary *)parameter completionHandler:(JMSGCompletionHandler)handler;

+(void)getGroupInfoWithParameter:(NSString *)targetId completionHandler:(JMSGCompletionHandler)handler;

+(void)getGroupListWithCompletionHandler:(JMSGCompletionHandler)handler;
/**
 *  向群组中添加成员
 *
 *  @param grounpID      群组ID
 *  @param userIds       添加群组的成员的集合
 *  @param callbackBlock 添加成员回调接口
 */
+(void)addMembersToGroupWithParameter:(NSDictionary *)parameter completionHandler:(JMSGCompletionHandler)handler;

/**
 *  解散群组
 *
 *  @param groupID       解散群组的ID
 *  @param callbackBlock 解散群组回调接口
 */
+(void)deleteGroupMemberWithParameter:(NSDictionary *)parameter completionHandler:(JMSGCompletionHandler)handler;

/**
 *  用户退出群组
 *
 *  @param groupId       群组ID
 *  @param userId        用户ID
 *  @param callbackBlock 用户退出群组回调接口
 */
+(void)exitGoupWithParameter:(NSDictionary *)parameter completionHandler:(JMSGCompletionHandler)handler;

/**
 *  更新群组信息
 *
 *  @param groupID       群组ID
 *  @param groupName     群名称
 *  @param callbackBlock 回调函数
 */
+(void)updateGroupInfoWithParameter:(NSDictionary *)parameter completionHandler:(JMSGCompletionHandler)handler;

@end
