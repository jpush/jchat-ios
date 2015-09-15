#import <Foundation/Foundation.h>
#import <JMessage/JMSGMessage.h>

@protocol JMSGMessageDelegate <NSObject>

@optional
/*!
  消息发送回调,需要关心error来判断是否成功
 */
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error;

@optional
/*!
  收到消息回调,包含event事件(特殊的message类型),error错误不包含下载的错误
 */
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error;

@optional
/*!
  针对多媒体消息的接受回调，当多媒体消息下载失败的时候，进入此回调.
 */
- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message;

@end
