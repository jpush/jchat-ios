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

