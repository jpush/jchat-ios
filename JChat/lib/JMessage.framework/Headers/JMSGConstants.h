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

#ifndef JMessage_JMSGConstants____FILEEXTENSION___
#define JMessage_JMSGConstants____FILEEXTENSION___

/***************************************声明枚举类型*********************************************/
typedef void (^JMSGCompletionHandler)(id resultObject, NSError *error);
typedef void (^JMSGSpecificFailHandler)();

/**
*  JMessage 请求超时
*/
#define kJMSGRequestTimeout (16002)


/**
*  消息下载回调block
*/
typedef void (^JMSGonProgressUpdate)(float percent);


/*******************************************************************************************/
#endif
