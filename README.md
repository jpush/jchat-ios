# JChat iOS


### 介绍

JChat 是一个聊天 App。

JChat 具有完备的即时通讯功能。主要有：

- 基本的聊天类型：文本、语音、图片；
- 单聊与群聊；
- 用户属性，包括头像；
- 黑名单；
- 好友通讯录；

JChat 的功能基于 JMessage SDK 来开发。它是一个 JMessage SDK 的完备的 Demo，但不仅仅是 Demo。我们的预期与目标是，当你的业务需要一个企业级的聊天 App 时，可以基于这里提供的源代码，更换 Logo 与应用名称，就可以直接用上。

JChat 当前提供 Android 与 iOS 版本。稍后也将提供 Web 版本。

- [JChat Android](https://github.com/jpush/jchat-android)

### 运行

本源代码项目要编译运行跑起来，需要注意以下几个地方。

##### 打开项目文件 JChat.xcworkspace

因为这是一个 [CocoaPods](https://cocoapods.org) 项目。打开 .xcodeproj 项目目录将缺少依赖。

##### 下载取得 JMessage.framework

JChat 项目依赖 JMessage iOS SDK。

JMessage iOS SDK 以 framework 的方式提供。从本项目的 [Release 页面](https://github.com/jpush/jchat-ios/releases) 可以下载到发布版本相应的 JMessage framework 压缩文件。解压缩后得到一个 JMessage.framework 目录。把这个目录 copy 至 JChat 根目录。

之所以单独提供 JMessage framework 文件而不直接放在 JChat 源代码里，是因为文件太大，并且经常变更版本，会导致版本库很大。也尝试过 git lfs 的方式，但国内的情况大家也是懂的，很不方便使用。

##### JMessage framework 依赖版本检查

JChat 根目录有一个文件 JMESSAGE_VERSION，里边定义了当前 JChat 项目代码匹配的 JMessage framework 的版本号。文件内容类似如下：

	JMESSAGE_VERSION=2.0.0
	JMESSAGE_BUILD=1036

JChat 根目录下的脚本 check_jmessage_version.sh 会来检查放进来的 "JMessage.framework" 的版本号与该文本里的定义是否匹配。如果不匹配，则报错。JChat.xcworkspace 在编译时，调用了此脚本进行这个检查。

上面的定义，要求 JMessage framework 的构建ID都完全匹配。但有时候，多个构建ID 可能并未有大的变更，所以不必要求匹配得那么严格。这时，可以改为这样：

	JMESSAGE_BUILD=~
	
##### 配置运行的基本属性

- appKey：JPush appKey 是 JMessage SDK 运行的基本参数。请到 [JPush 官方网站](https://jpush.cn)登录控制台创建应用获取。
- bundle_id：这是一个 iOS 应用的基本属性。你需要登录到 Apple 开发者网站去创建应用。

### JMessage 文档

- [JMessage iOS 集成指南](http://docs.jpush.io/guideline/jmessage_ios_guide/)
- [JMessage iOS 说明](http://docs.jpush.io/client/im_sdk_ios/)
- [JMessage iOS API Docs](http://docs.jpush.io/client/jmessage_ios_appledoc_html/)

### JMessage 升级

JMessage 当前版本为 2.0.x。与之前 1.0.x 版本有比较大的变更。

因为变更太大，所以这次变更有点不够友好，大部分 API 有调整，包括对象结构。这会导致集成 JMessage SDK 1.0.x 版本的 App 切换到新版本时，会编译不通过，某些 API 调用需要调整。调整的具体思路，可参考本项目 JChat iOS 源代码，以及 JMessage iOS 相关文档。

## JChat 介绍

## JChat 工程结构
![如图](https://github.com/jpush/jchat-ios/blob/master/READMERecource/JChat流程图.png)

## JChat 代码结构
主要分为五个功能模块：用户详情 (UserInfo)，会话列表 (Conversation List)，会话 (Conversation) 登录 (Login) 和 设置 (Setting)。每个功能模块按照 MVC 模式划分，部分模块还有一些 Util 类。

CustomUI
自定义 View

Category
通用 Category

Util
通用辅助类

## 主要功能索引
### JMessage 初始化代码
建议在 appdelegate didFinishLaunchingWithOptions 方式初始化，如JChat 所示
```
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self initLogger];

  // init third-party SDK
  **[JMessage addDelegate:self withConversation:nil];**// 这句代码放到前面目的是，应用启动是会做数据库是否升级盘点，如果需要升级，则锁定数据库，进行升级
  
  [JMessage setupJMessage:launchOptions
                   appKey:JMSSAGE_APPKEY
                  channel:CHANNEL apsForProduction:NO
                 category:nil];
  
  [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound |
                                                    UIUserNotificationTypeAlert)
                                        categories:nil];
  
  [self registerJPushStatusNotification];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [UIViewController new];
  [self.window makeKeyAndVisible];
  [self setupMainTabBar];
  [self setupRootView];
  
  [JCHATFileManager initWithFilePath];//demo 初始化存储路径
  
  return YES;
}

```

注册SDK
注册APNS
成功获得APNS token 传入JPUSHService 如下代码所示
```
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [JPUSHService registerDeviceToken:deviceToken];
}
```
JMessage 还有一个很重要的方法,用于添加执行回调的对象delegate，具体的回调方法可以看详细文档代码如下：
```
/*!
 * @abstract 增加回调(delegate protocol)监听
 *
 * @param delegate 需要监听的 Delegate Protocol
 * @param conversation 允许为nil.
 *
 * - 为 nil, 表示接收所有的通知, 不区分会话.
 * - 不为 nil，表示只接收指定的 conversation 相关的通知.
 *
 * @discussion 默认监听全局 JMessageDelegate 即可.
 *
 * 这个调用可以在任何地方, 任何时候调用, 可以在未进行 SDK
 * 启动 setupJMessage:appKey:channel:apsForProduction:category: 时就被调用.
 *
 * 并且, 如果你有必要接收数据库升级通知 [JMSGDBMigrateDelegate](建议要做这一步),
 * 就应该在 SDK 启动前就调用此方法, 来注册通知接收.
 * 这样, SDK启动过程中发现需要进行数据库升级, 给 App 发送数据库升级通知时,
 * App 才可以收到并进行处理.
 */
+ (void)addDelegate:(id <JMessageDelegate>)delegate
   withConversation:(JMSGConversation *)conversation;
```
### 注册
首次使用JMessage 需要有JMessage 账户，通过如下代码注册一个新用户
```
+ (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
           completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;
```
注册完成会回调 handler ，如下代码。如果出现错误会返回的error 部位nil，注意resultOvject 不同接口会返回不同类型的值或者nil，详细信息可以关注 [JMessage 官方文档](http://docs.jpush.io/client/im_sdk_ios/#summary)
```
typedef void (^JMSGCompletionHandler)(id resultObject, NSError *error);
```

### 登录
成功注册账户之后，需要登录该用户，才能在该用户创建会话，收发消息。
```
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
        completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;
```

### 会话 (Conversation)
会话是一个用户与用户之间聊天的载体，要有会话用户之间才能收发消息
获得会话有两种方式 1. 创建会话 2. 获取历史会话
#### 1.创建会话
如下代码分别创建了 单聊会话，和群聊会话
```
+ (void)createSingleConversationWithUsername:(NSString *)username
                           completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;

+ (void)createGroupConversationWithGroupId:(NSString *)groupId
                         completionHandler:(JMSGCompletionHandler JMSG_NULLABLE)handler;
```

#### 2. 获取历史会话
如下代码分别获取 单聊会话，群聊会话，所有会话
```
+ (JMSGConversation * JMSG_NULLABLE)singleConversationWithUsername:(NSString *)username;

+ (JMSGConversation * JMSG_NULLABLE)groupConversationWithGroupId:(NSString *)groupId;

+ (void)allConversations:(JMSGCompletionHandler)handler;
```
#### 3. 发送消息
JMSGMessage 是消息的实体。需要自己创建要发送的消息，示例代码如下
```  
  JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
  JCHATChatModel *model = [[JCHATChatModel alloc] init];
  message = [_conversation createMessageWithContent:textContent];//!
```

获得JMSGMessage 后便可以调用如下接口向会话中发送消息，会话中的target(会话的对方，可以是user,可以是group 的所有成员)就会收到所有的消息
```
// JMSGConversation 实力方法
- (void)sendMessage:(JMSGMessage *)message;
```

#### 4. 接收消息
前面已经说了可以给conversation 添加回调delegate，收到消息也是通过回调函数来获取的，回调方法如下
```
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error;
```
message 是收到的message，



