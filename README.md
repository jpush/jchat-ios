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
建议在 AppDelegate didFinishLaunchingWithOptions 方式初始化，如JChat 所示
```
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self initLogger];

  // init third-party SDK
  [JMessage addDelegate:self withConversation:nil];// 这句代码放到前面目的是，应用启动是会做数据库是否升级盘点，如果需要升级，则锁定数据库，进行升级
  
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

### 注册 登录
首次使用JMessage 需要有JMessage 账户，通过如下代码注册一个新用户。JChat 项目在JCHATRegisterViewController 类中执行了注册操作，并且在注册完成回调执行登录操作(登录操作也可以移动到其它地方进行，具体看程序业务)。
```
- (IBAction)registerBtnClick:(id)sender {
  DDLogDebug(@"Action - registerBtnClick");
  if ([self.usernameTextField.text isEqualToString:@""]) {
    [MBProgressHUD showMessage:@"用户名不能为空" view:self.view];
    return;
  }
  
  if ([self.passwordTextField.text isEqualToString:@""]) {
    [MBProgressHUD showMessage:@"密码不能为空" view:self.view];
    return;
  }
  
  [self.usernameTextField resignFirstResponder];
  [self.passwordTextField resignFirstResponder];
  
  NSString *username = self.usernameTextField.text.stringByTrimingWhitespace;
  NSString *password = self.passwordTextField.text.stringByTrimingWhitespace;
  
  if ([self checkValidUsername:username AndPassword:password]) {
    [MBProgressHUD showMessage:@"正在注册" view:self.view];
    [[JCHATTimeOutManager ins] startTimerWithVC:self];
    [JMSGUser registerWithUsername:username
                          password:password
                 completionHandler:^(id resultObject, NSError *error) {
                   [[JCHATTimeOutManager ins] stopTimer];
                   if (error == nil) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [MBProgressHUD showMessage:@"注册成功" view:self.view];
                     [[JCHATTimeOutManager ins] startTimerWithVC:self];
                     [JMSGUser loginWithUsername:username
                                        password:password
                               completionHandler:^(id resultObject, NSError *error) {
                                 [[JCHATTimeOutManager ins] stopTimer];
                                 if (error == nil) {
                                   [[NSUserDefaults standardUserDefaults] setObject:username forKey:kuserName];
                                   [[NSUserDefaults standardUserDefaults] setObject:username forKey:klastLoginUserName];
                                   
                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   JCHATSetDetailViewController *detailVC = [[JCHATSetDetailViewController alloc] init];
                                   [self.navigationController pushViewController:detailVC animated:YES];
                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                 } else {
                                   DDLogDebug(@"login fail error  %@",error);
                                   NSString *alert = [JCHATStringUtils errorAlert:error];
                                   alert = [JCHATStringUtils errorAlert:error];
                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   [MBProgressHUD showMessage:alert view:self.view];
                                   DDLogError(alert);
                                 }
                               }];
                   } else {
                     NSString *alert = @"注册失败";
                     alert = [JCHATStringUtils errorAlert:error];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [MBProgressHUD showMessage:alert view:self.view];
                   }
                 }];
  }
}
```
注册完成会回调 handler ，如下代码。如果出现错误会返回的error 部位nil，注意resultOvject 不同接口会返回不同类型的值或者nil，详细信息可以关注 [JMessage 官方文档](http://docs.jpush.io/client/im_sdk_ios/#summary)
```
typedef void (^JMSGCompletionHandler)(id resultObject, NSError *error);
```

### 会话 (Conversation)
会话是一个用户与用户之间聊天的载体，要有会话用户之间才能收发消息
获得会话有两种方式 1. 创建会话 2. 获取历史会话
#### 1.创建会话
如下代码分别创建了 单聊会话，和群聊会话, JChat 在JCHATConversationListViewController类 实现创建会话操作
```

- (void)skipToSingleChatView :(NSNotification *)notification {
  JMSGUser *user = [[notification object] copy];
  __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
  __weak typeof(self)weakSelf = self;
  sendMessageCtl.superViewController = self;
  [JMSGConversation createSingleConversationWithUsername:user.username completionHandler:^(id resultObject, NSError *error) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    if (error == nil) {
      sendMessageCtl.conversation = resultObject;
      JPIMMAINTHEAD(^{
        sendMessageCtl.hidesBottomBarWhenPushed = YES;
        [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
      });
    } else {
      DDLogDebug(@"createSingleConversationWithUsername");
    }
  }];
}
```

#### 2. 获取历史会话
JCHat在JCHATConversationListViewController类中获取所有历史会话的具体代码如下
```
- (void)getConversationList {
  [self.addBgView setHidden:YES];
  [JMSGConversation allConversations:^(id resultObject, NSError *error) {
    NSLog(@"the result");
    JPIMMAINTHEAD(^{
      if (error == nil) {
        _conversationArr = [self sortConversation:resultObject];
        _unreadCount = 0;
        for (NSInteger i=0; i < [_conversationArr count]; i++) {
          JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
          _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
        }
        [self saveBadge:_unreadCount];
      } else {
        _conversationArr = nil;
      }
      [self.chatTableView reloadData];
    });
  }];
}
```
#### 3. 添加代理
若想监听conversation 的消息需要把某个对象设为conversation的delegate（可以是任何对象），比如JChat JCHATConversationViewController类需要监听发送回调，受消息回调则必须先设置代理，具体代码如下
```
- (void)addDelegate {
  [JMessage addDelegate:self withConversation:self.conversation];
}
```

#### 4. 发送消息
JMSGMessage 是消息的实体。需要自己创建要发送的消息，JChat JCHATConversationViewController类中发送消息的代码如下
```  
  - (void)prepareTextMessage:(NSString *)text {
  DDLogDebug(@"Action - prepareTextMessage");
  if ([text isEqualToString:@""] || text == nil) {
    return;
  }
  [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:@""];
  JMSGMessage *message = nil;
  JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
  JCHATChatModel *model = [[JCHATChatModel alloc] init];
  
  message = [_conversation createMessageWithContent:textContent];
  [_conversation sendMessage:message];// 发送该条消息
  [self addmessageShowTimeData:message.timestamp];
  [model setChatModelWith:message conversationType:_conversation];
  [self addMessage:model];
}
```

#### 5. 接收消息
前面已经说了可以给conversation 添加回调delegate，收到消息也是通过回调函数来获取的，JChat JCHATConversationViewController类 收到消息回调方法如下
```
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
  if (error != nil) {
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setErrorMessageChatModelWithError:error];
    [self addMessage:model];
    return;
  }
  
  if (![self.conversation isMessageForThisConversation:message]) {
    return;
  }
  
  if (message.contentType == kJMSGContentTypeCustom) {
    return;
  }
  DDLogDebug(@"Event - receiveMessageNotification");
  JPIMMAINTHEAD((^{
    if (!message) {
      DDLogWarn(@"get the nil message .");
      return;
    }
    
    if (_allMessageDic[message.msgId] != nil) {
      DDLogDebug(@"该条消息已加载");
      return;
    }
    
    if (message.contentType == kJMSGContentTypeEventNotification) {
      if (((JMSGEventContent *)message.content).eventType == kJMSGEventNotificationRemoveGroupMembers
          && ![((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
        [self setupNavigation];
      }
    }
    
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
      return;
    }
    
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgDataArr addObject:model];
    }
    model.photoIndex = [_imgDataArr count] -1;
    [self addmessageShowTimeData:message.timestamp];
    [self addMessage:model];
  }));
}
```
