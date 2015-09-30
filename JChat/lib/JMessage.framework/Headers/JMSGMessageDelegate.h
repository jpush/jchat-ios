#import <Foundation/Foundation.h>
#import <JMessage/JMSGMessage.h>

/*!
 * @abstract 消息相关的回调定义
 */
@protocol JMSGMessageDelegate <NSObject>

/*!
 * @abstract 发送消息结果返回回调
 * @discussion 应检查 error 是否为空来判断是否出错. 如果未出错, 则成功.
 */
@optional
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error;

/*!
 * @abstract 接收消息(服务器端下发的)回调
 * @discussion 应检查 error 是否为空来判断有没有出错. 如果未出错, 则成功.
 * 留意的是, 这里的 error 不包含媒体消息下载文件错误. 这类错误有单独的回调 onReceiveMessageDownloadFailed:
 *
 * 收到的消息里, 也包含服务器端下发的各类事件, 比如有人被加入了群聊. 这类事件处理为特殊的 JMSGMessage 类型.
 */
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error;

/*!
 * @abstract 接收消息媒体文件下载失败的回调
 * @discussion 因为对于接收消息, 最主要需要特别做处理的就是媒体文件下载, 所以单列出来. 一定要处理.
 *
 * 通过的作法是: 如果是图片, 则 App 展示一张特别的表明未下载成功的图, 用户点击再次发起下载. 如果是语音,
 * 则不必特别处理, 还是原来的图标展示. 用户点击时, SDK 发现语音文件在本地没有, 会再次发起下载.
 */
@optional
/*!
  针对多媒体消息的接受回调，当多媒体消息下载失败的时候，进入此回调.
 */
- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message;

@end
