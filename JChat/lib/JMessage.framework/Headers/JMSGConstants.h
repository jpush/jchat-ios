//
//  JMSGConstants.h
//  Untitled
//
//  Created by zhang on 15/5/4.
//  Copyright (c) 2015 HXHG. All rights reserved.
//

#ifndef JMessage_JMSGConstants____FILEEXTENSION___
#define JMessage_JMSGConstants____FILEEXTENSION___
#import <Foundation/Foundation.h>

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
