//
//  JCHATSendMessageViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATSendMessageViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "JCHATFileManager.h"
#import "JCHATShowTimeCell.h"
#import "JCHATDetailsInfoViewController.h"
#import "JCHATGroupSettingCtl.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Add.h"
#import "UIImage+ResizeMagick.h"
#import "JCHATPersonViewController.h"
#import "JCHATFriendDetailViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <JMessage/JMSGConversation.h>
#import "JCHATStringUtils.h"
#import "JCHATAlreadyLoginViewController.h"
#import "ViewUtil.h"
#import "JCHATVoiceTableCell.h"
#import "JCHATTextTableCell.h"
#import <UIKit/UIPrintInfo.h>
#define interval 60*2

NSString * const JCHATMessage      = @"JCHATMessage";
NSString * const JCHATMessageIdKey = @"JCHATMessageIdKey";

@interface JCHATSendMessageViewController () {
  
@private
  NSMutableArray *_imgDataArr;
  __block JMSGConversation *_conversation;
  NSMutableDictionary *_messageDic;
  __block NSMutableArray *_userArr;
  NSMutableDictionary *_JMSgMessageDic;
  UIButton *_rightBtn;
}

@end


@implementation JCHATSendMessageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
  _JMSgMessageDic = [[NSMutableDictionary alloc]init];
  _messageDic = [[NSMutableDictionary alloc]init];
  NSMutableArray *messageIdArr = [[NSMutableArray alloc]init];
  NSMutableDictionary *messageDic = [[NSMutableDictionary alloc]initWithCapacity:10];
  _messageDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:messageDic,JCHATMessage,messageIdArr,JCHATMessageIdKey,nil];
  _imgDataArr =[[NSMutableArray alloc] init];
  DDLogDebug(@"Action - viewDidLoad");
  if (_user) {
    _targetName = _user.username;
    [self setTitleWithUser:self.user];
  } else if (_conversation) {
    self.title = _targetName = _conversation.title;
  } else {
    DDLogWarn(@"聊天未知错误 - 非单聊，且无会话。");
  }
  
  if (!_conversation) {
    if (_user) {
      DDLogDebug(@"No conversation - to create single");
      __weak typeof(self) weakSelf = self;
      [JMSGConversation createSingleConversationWithUsername:self.user.username completionHandler:^(id resultObject, NSError *error) {
        _conversation = (JMSGConversation *) resultObject;
        weakSelf.title = _conversation.title;
        [_conversation clearUnreadCount];
      }];
    } else {
      DDLogWarn(@"No conversation - no create group yet.");
    }
  } else {
    DDLogDebug(@"Conversation existed.");
  }
  if (_conversation && _conversation.conversationType == kJMSGConversationTypeGroup) {
    self.title = _conversation.title;
    _groupInfo = _conversation.target;
  } else {
    if (!_user) {
      _user = _conversation.target;
    }else {
    }
  }
  [self initView];
  [self getGroupMemberListWithGetMessageFlag:YES];
  [self addNotification];
  [self sendInfoRequest];
  [self addDelegate];


}

- (void)viewWillAppear:(BOOL)animated {
  DDLogDebug(@"Event - viewWillAppear");
  [super viewWillAppear:NO];
  [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
  [self.navigationController setNavigationBarHidden:NO];
  // 禁用 iOS7 返回手势
  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
  }
  
  if (self.conversation.conversationType == kJMSGConversationTypeGroup) {
    [self getGroupMemberListWithGetMessageFlag:NO];
    if (self.user != nil) {
      self.user = nil;
      [self cleanMessageCache];
      [_messageTableView reloadData];
    }
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  DDLogDebug(@"Event - viewWillDisappear");
  [super viewWillAppear:animated];
  [_conversation clearUnreadCount];
  [[JCHATAudioPlayerHelper shareInstance] stopAudio];
  [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
}


-(void)initView {
  [self initNavigation];
  [self initComponentView];
}

- (void)addtoolbar {
  self.toolBarContainer.toolbar.frame = CGRectMake(0, 0, kApplicationWidth, 45);
  [self.toolBarContainer addSubview:self.toolBarContainer.toolbar];
}

-(void)initComponentView {
  [self performSelector:@selector(addtoolbar) withObject:nil afterDelay:0.1];
  UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
  [self.view addGestureRecognizer:gesture];
  [self.view setBackgroundColor:[UIColor clearColor]];
  _toolBarContainer.toolbar.delegate = self;
  [_toolBarContainer.toolbar setUserInteractionEnabled:YES];
  
  _messageTableView.userInteractionEnabled = YES;
  _messageTableView.showsVerticalScrollIndicator = NO;
  _messageTableView.delegate = self;
  _messageTableView.dataSource = self;
  _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _messageTableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1];
  
  _moreViewContainer.moreView.delegate = self;
  
}
-(void)initNavigation {
  _rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [_rightBtn setFrame:CGRectMake(0, 0, 14, 17)];
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    [_rightBtn setImage:[UIImage imageNamed:@"dialogue_nav_b_"] forState:UIControlStateNormal];
  }else {
    [_rightBtn setImage:[UIImage imageNamed:@"dialogue_nav_a_"] forState:UIControlStateNormal];
  }
  [_rightBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];//为导航栏添加右侧按钮
  
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
  [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  self.navigationController.interactivePopGestureRecognizer.delegate = self;
  
}

-(void)getGroupMemberListWithGetMessageFlag:(BOOL)getMesageFlag {
  if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeGroup) {
    JMSGGroup *group = nil;
    group = self.conversation.target;
    _userArr = [NSMutableArray arrayWithArray:[group memberArray]];
    [self isContantMeWithUserArr:_userArr];
    if (getMesageFlag) {
      [self getAllMessage];      
    }

  }else {
    if (getMesageFlag) {
      [self getAllMessage];
    }
    [self hidenDetailBtn:NO];
  }
}


- (void)isContantMeWithUserArr:(NSMutableArray *)userArr {
  BOOL hideFlag = YES;
  for (NSInteger i =0; i< [userArr count]; i++) {
    JMSGUser *user = [userArr objectAtIndex:i];
    if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
      hideFlag = NO;
      break;
    }
  }
  
  [self hidenDetailBtn:hideFlag];
  
}

- (void)hidenDetailBtn:(BOOL)flag {
  [_rightBtn setHidden:flag];
}


- (void)setTitleWithUser:(JMSGUser *)user {
  //  if (user.noteName != nil && ![user.noteName isEqualToString:KNull]) {
  //    self.title = user.noteName;
  //  } else if (user.nickname != nil && ![user.nickname isEqualToString:KNull]) {
  //    self.title = user.nickname;
  //  } else {
  //    self.title = user.username;
  //  }
  self.title = _conversation.title;
}

- (void)sendInfoRequest {
    if (self.user) {
//      [JMSGUser getUserInfoWithUsername:self.user.username completionHandler:^(id resultObject, NSError *error) {
//        if (resultObject) {
//          [self setTitleWithUser:resultObject];
//        }
//      }];
      [JMSGUser userInfoArrayWithUsernameArray:@[self.user.username] completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
          [self setTitleWithUser:resultObject];
        } else {
          DDLogDebug(@"get user info fail");
        }
      }];
    }else if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeGroup) {
//      [JMSGGroup getGroupInfo:self.conversation.targetId completionHandler:^(id resultObject, NSError *error) {
//        if (error == nil) {
//          _groupInfo = resultObject;
//        }else {
//          DDLogDebug(@"获取groupInfo fail");
//        }
//      }];

//      [JMSGGroup groupInfoWithGroupId:self.conversation.target completionHandler:<#^(id resultObject, NSError *error)handler#>]
//    }else if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeSingle) {
//      [JMSGUser getUserInfoWithUsername:self.conversation.targetId completionHandler:^(id resultObject, NSError *error) {
//        [self setTitleWithUser:resultObject];
//      }];
//    }
}
}


#pragma mark --JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {
  DDLogDebug(@"Event - sendMessageResponse");
  if (error == nil) {
  } else {
    DDLogDebug(@"Sent response error - %@", error);
    NSString *alert = @"发消息返回错误";
    if (error.code == JCHAT_ERROR_STATE_USER_LOGOUT) {
      alert = @"本用户登出了。可能在其他设备上做了登录。";
    } else if (error.code == JCHAT_ERROR_STATE_USER_NEVER_LOGIN) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"登录错误，请重新登录"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"退出",nil];
      [alertView show];
      return;
      
    } else if (error.code == JCHAT_ERROR_MSG_TARGET_NOT_EXIST) {
      alert = @"发送消息的目标用户不存在。";
    } else if (error.code == JCHAT_ERROR_MSG_GROUP_NOT_EXIST) {
      alert = @"发送消息的目标群组不存在。";
    } else if (error.code == JCHAT_ERROR_MSG_USER_NOT_IN_GROUP) {
      alert = @"当前用户不在本群组里";
    }
    DDLogWarn(alert);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showMessage:alert view:self.view];
  }
  NSMutableDictionary *messageDataDic =_messageDic[JCHATMessage];
  JCHATChatModel *model = messageDataDic[message.msgId];
  if (!model) {
    return;
  }
  if (message.contentType == kJMSGContentTypeVoice) {
    JMSGMessage *voiceMessage = (JMSGMessage *) message;
    model.voicePath = ((JMSGVoiceContent *)voiceMessage.content).voicePath;
  } else if (message.contentType == kJMSGContentTypeImage) {
    JMSGMessage *imgMessage = (JMSGMessage *) message;
    model.pictureImgPath = ((JMSGImageContent *)imgMessage.content).largeImagePath;
    model.pictureThumbImgPath = ((JMSGImageContent *)imgMessage.content).thumbImagePath;
    model.imageSize = [model getImageSize];
  }
  model.messageStatus = message.status;
  NSInteger cellIndex = [self getIndexWithMessageId:message.msgId];
  JPIMMAINTHEAD(^{
    [self reloadCellDataWith:cellIndex];
  });
}


#pragma mark --收到消息
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
//  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
//    if ([_conversation.target isEqualToUser:message.fromUser]) {
//      
//    } else {
//      return;
//    }
//  }
  if (![self.conversation isMessageForThisConversation:message]) {
    return;
  }
  DDLogDebug(@"Event - receiveMessageNotification");
  NSLog(@"huangmin  receive the message %@",message);
  JPIMMAINTHEAD((^{
    [_JMSgMessageDic setObject:message forKey:message.msgId];
    
    DDLogDebug(@"The received msg - %@", message);
    if (!message) {
      DDLogWarn(@"get the nil message .");
      return;
    }
    
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
//      if (![((JMSGUser *)message.target).username isEqualToString:self.user.username]) {
//        // FIXME - This condition should be done by SDK.
//        DDLogWarn(@"It's single chat, but the targetId of the msg is not me. Throw away.");
//        return;
//      }
//      if{}
    } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
      DDLogWarn(@"It's group chat, but the targetId of the msg is not group. Throw away.");
      return;
    }
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
        [_imgDataArr addObject:model];
    }
    model.photoIndex = [_imgDataArr count] -1;
    [self addmessageShowTimeData:message.timestamp];
    model.sendFlag = YES;
    model.readState = NO;
    [self addMessage:model];
  }));
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {
    [self.navigationController popViewControllerAnimated:NO];//目的回到根视图
    [MBProgressHUD showMessage:@"正在退出登录！" view:self.view];
    DDLogDebug(@"Logout anyway.");
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if ([appDelegate.tabBarCtl.loginIdentify isEqualToString:kFirstLogin]) {
      [self.navigationController.navigationController popToViewController:[self.navigationController.navigationController.childViewControllers objectAtIndex:0] animated:YES];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserName];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [JMSGUser logout:^(id resultObject, NSError *error) {
      DDLogDebug(@"Logout callback with - %@", error);
    }];
    //    [JMSGUser logoutWithCompletionHandler:^(id resultObject, NSError *error) {
    //      DDLogDebug(@"Logout callback with - %@", error);
    //    }];
    
    JCHATAlreadyLoginViewController *loginCtl = [[JCHATAlreadyLoginViewController alloc] init];
    loginCtl.hidesBottomBarWhenPushed = YES;
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:loginCtl];
    appDelegate.window.rootViewController = navLogin;
  }
}
#pragma mark --获取对应消息的索引
- (NSInteger )getIndexWithMessageId:(NSString *)messageID {
  for (NSInteger i=0; i< [_messageDic[JCHATMessageIdKey] count]; i++) {
    NSString *getMessageID = _messageDic[JCHATMessageIdKey][i];
    if ([getMessageID isEqualToString:messageID]) {
      return i;
    }
  }
  return 0;
}

- (void)changeMessageState:(JMSGMessage *)message {
  DDLogDebug(@"Action - changeMessageState");
  NSMutableDictionary *messageDataDic =_messageDic[JCHATMessage];
  
  JCHATChatModel *model = messageDataDic[message.msgId];
  model.messageStatus = message.status;
  
  NSInteger index = [self getIndexWithMessageId:message.msgId];
  JPIMMAINTHEAD(^{
    [self reloadCellDataWith:index];
  });
}

- (bool)checkDevice:(NSString *)name {
  NSString *deviceType = [UIDevice currentDevice].model;
  DDLogDebug(@"deviceType = %@", deviceType);
  NSRange range = [deviceType rangeOfString:name];
  return range.location != NSNotFound;
}

#pragma mark -- 清空消息缓存
- (void)cleanMessageCache {
  [_messageDic[JCHATMessage] removeAllObjects];
  [_messageDic[JCHATMessageIdKey] removeAllObjects];
  [self.messageTableView reloadData];
}

#pragma mark --添加message
- (void)addMessage:(JCHATChatModel *)model {
  
  [_messageDic[JCHATMessage] setObject:model forKey:model.messageId];
  NSLog(@"houangmin   _messageDic idkey  %ld",[_messageDic[JCHATMessageIdKey] count]);
  [_messageDic[JCHATMessageIdKey] addObject:model.messageId];
  NSLog(@"houangmin   _messageDic idkey  %ld",[_messageDic[JCHATMessageIdKey] count]);
  //  NSLog(@"huangmin  _messageDic[JChatMessage] %@",)
//  [self performSelector:@selector(addCellToTabel) withObject:nil afterDelay:1];
  [self addCellToTabel];
}

NSInteger sortMessageType(id object1,id object2,void *cha) {
  JMSGMessage *message1 = (JMSGMessage *)object1;
  JMSGMessage *message2 = (JMSGMessage *)object2;
  if([message1.timestamp integerValue] > [message2.timestamp integerValue]) {
    return NSOrderedDescending;
  }else if([message1.timestamp integerValue] < [message2.timestamp integerValue]) {
    return NSOrderedAscending;
  }
  return NSOrderedSame;
}

#pragma mark --排序conversation
- (NSMutableArray *)sortMessage:(NSMutableArray *)messageArr {
  NSArray *sortResultArr = [messageArr sortedArrayUsingFunction:sortMessageType context:nil];
  return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)getAllMessage {
  DDLogDebug(@"Action - getAllMessage");
  __block NSMutableArray * arrList = [[NSMutableArray alloc] init];
  [self cleanMessageCache];
  [arrList addObjectsFromArray:[[[_conversation messageArrayFromNewestWithOffset:@0 limit:@200] reverseObjectEnumerator] allObjects]];

  for (NSInteger i=0; i< [arrList count]; i++) {
    JMSGMessage *message = [arrList objectAtIndex:i];
    [_JMSgMessageDic setObject:message forKey:message.msgId];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgDataArr addObject:model];
      model.photoIndex = [_imgDataArr count] - 1;
    }
    model.sendFlag = YES;
    model.isSending = NO;
    [self dataMessageShowTime:message.timestamp];
    [_messageDic[JCHATMessage] setObject:model forKey:model.messageId];
    [_messageDic[JCHATMessageIdKey] addObject:model.messageId];
  }
  [_messageTableView reloadData];
  if ([_messageDic[JCHATMessageIdKey] count] != 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messageDic[JCHATMessageIdKey]  count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
  }
  
}

- (JMSGUser *)getAvatarWithTargetId:(NSString *)targetId {
  for (NSInteger i=0; i<[_userArr count]; i++) {
    JMSGUser *user = [_userArr objectAtIndex:i];
    if ([user.username isEqualToString:targetId]) {
      return user;
    }
  }
  return nil;
}

- (XHVoiceRecordHelper *)voiceRecordHelper {
  if (!_voiceRecordHelper) {
    WEAKSELF
    _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
    _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
      DDLogDebug(@"已经达到最大限制时间了，进入下一步的提示");
      [weakSelf finishRecorded];
    };
    _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
      weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
    };
    _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
  }
  return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
  if (!_voiceRecordHUD) {
    _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
  }
  return _voiceRecordHUD;
}

-(void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressVoiceBtnToHideKeyBoard
{
  [self.toolBarContainer.toolbar.textView resignFirstResponder];
  [self dropToolBar];
}

#pragma mark --增加朋友
-(void)addFriends
{
  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
    JCHATDetailsInfoViewController *detailsInfoCtl = [[JCHATDetailsInfoViewController alloc] initWithNibName:@"JCHATDetailsInfoViewController" bundle:nil];
    detailsInfoCtl.chatUser = self.user;
    detailsInfoCtl.conversation = self.conversation;
    detailsInfoCtl.sendMessageCtl = self;
    detailsInfoCtl.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailsInfoCtl animated:YES];
  }else{
    JCHATGroupSettingCtl *groupSettingCtl = [[JCHATGroupSettingCtl alloc] init];
    groupSettingCtl.hidesBottomBarWhenPushed=YES;
    groupSettingCtl.conversation = _conversation;
    groupSettingCtl.sendMessageCtl = self;
    [self.navigationController pushViewController:groupSettingCtl animated:YES];
  }
}

#pragma mark -调用相册
-(void)photoClick {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
  picker.mediaTypes = temp_MediaTypes;
  picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

  [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark --调用相机
-(void)cameraClick {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *requiredMediaType = ( NSString *)kUTTypeImage;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
    [picker setMediaTypes:arrMediaTypes];
    picker.showsCameraControls = YES;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    picker.editing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
  }
}

#pragma mark - UIImagePickerController Delegate
//相机,相册Finish的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  if ([mediaType isEqualToString:@"public.movie"]) {
    [self dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD showMessage:@"不支持视频发送" view:self.view];
    return;
  }
  UIImage *image;
  image = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self prepareImageMessage:image];
  [self dropToolBarNoAnimate];
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --发送图片
- (void)prepareImageMessage:(UIImage *)img {
  DDLogDebug(@"Action - prepareImageMessage");
  img = [img resizedImageByWidth:upLoadImgWidth];
//  UIImage *smallpImg = [UIImage imageWithImageSimple:img scaled:0.5];
  JMSGMessage* message = nil;
  __block JCHATChatModel *model = [[JCHATChatModel alloc] init];
  JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
  model.mediaData = UIImagePNGRepresentation(img);
//  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
////    message = [JMSGMessage createSingleMessageWithContent:imageContent username:((JMSGUser *)_conversation.target).username];
//    message = [_conversation createMessageWithContent:imageContent];
//  } else {
//    message = [JMSGMessage createGroupMessageWithContent:imageContent groupId:((JMSGGroup *)_conversation.target).gid];
//    message = [_conversation]
//  }//!
  message = [_conversation createMessageWithContent:imageContent];
  [self addmessageShowTimeData:message.timestamp];
  [model setChatModelWith:message conversationType:_conversation];
  NSLog(@"huangmin   send imagemessage %@",message);
  model.messageStatus = kJMSGMessageStatusSending;
  model.isSending = YES;
  [_imgDataArr addObject:model];
  model.photoIndex = [_imgDataArr count] - 1;
  [_JMSgMessageDic setObject:message forKey:message.msgId];
  model.imageSize = [model getImageSize];
  [self addMessage:model];


}


#pragma mark --
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --add Delegate
- (void)addDelegate {
  [JMessage addDelegate:self withConversation:self.conversation];
//  [JMessage addDelegate:self withConversation:nil];
}
#pragma mark --加载通知
-(void)addNotification{
  //给键盘注册通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillShow:)
   
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  //    [[NSNotificationCenter defaultCenter] addObserver:self
  //                                             selector:@selector(sendMessageResponse:)
  //                                                 name:JMSGNotification_SendMessageResult object:nil];//done
  //    [[NSNotificationCenter defaultCenter] addObserver:self
  //                                             selector:@selector(receiveMessageNotification:)
  //                                                 name:JMSGNotification_ReceiveMessage object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeMessageState:)
                                               name:kMessageChangeState
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(cleanMessageCache)
                                               name:kDeleteAllMessage
                                             object:nil];
  
  //  [[NSNotificationCenter defaultCenter] addObserver:self
  //                                           selector:@selector(receiveEventNotification:)
  //                                               name:JMSGNotification_EventMessage
  //                                             object:nil];
  [self.toolBarContainer.toolbar.textView addObserver:self
                                           forKeyPath:@"contentSize"
                                              options:NSKeyValueObservingOptionNew
                                              context:nil];
  //  [[NSNotificationCenter defaultCenter] addObserver:self
  //                                           selector:@selector(receiveConversationChange)
  //                                               name:JMSGNotification_ConversationInfoChanged
  //                                             object:nil];
  //  [[NSNotificationCenter defaultCenter] addObserver:self
  //                                           selector:@selector(receiveGroupChange)
  //                                               name:JMSGNotification_GroupChange
  //                                             object:nil];
}

#pragma mark - ConversationChanged
//- (void)receiveGroupChange{
//  [JMSGConversation getConversation:_conversation.targetId withType:kJMSGGroup completionHandler:^(id resultObject, NSError *error){
//    if(error == nil){
//      JMSGConversation *conversation = resultObject;
//      self.title = conversation.targetName;
//    } else{
//      DDLogError(@"get coneversation failed");
//    }
//  }];
//}

//- (void)receiveConversationChange{
//  [JMSGConversation getConversation:_conversation.targetId withType:kJMSGGroup completionHandler:^(id resultObject, NSError *error){
//    if(error == nil){
//      JMSGConversation *conversation = resultObject;
//      self.title = conversation.targetName;
//    } else{
//      DDLogError(@"get coneversation failed");
//    }
//  }];
//}

//#pragma mark --接收EventNotification
//- (void)receiveEventNotification:(NSNotification *)notification {
//  DDLogDebug(@"Event - receiveEventNotification");
//  NSDictionary *infoDic = [notification userInfo];
//
//  JMSGEventMessage *eventMessage = [infoDic objectForKey:JMSGNotification_EventKey];
//
//  if (self.conversation.chatType == kJMSGGroup && eventMessage.gid == [self.conversation.targetId longLongValue]) {
//    if (eventMessage.type == kJMSGExitGroupEvent && eventMessage.isContainsMe) {
//      [self hidenDetailBtn:YES];
//    }else if(eventMessage.type == kJMSGAddGroupMemberEvent) {
//      [self getGroupMemberListWithGetMessageFlag:NO];
//    }
//    [self addEventMessage:eventMessage];
//  }
//}

//- (void)addEventMessage:(JMSGMessage *)eventMessage {
//  if (eventMessage.type == kJMSGDeleteGroupMemberEvent || eventMessage.type == kJMSGAddGroupMemberEvent || eventMessage.type == kJMSGExitGroupEvent) {
//    JCHATChatModel *model = [[JCHATChatModel alloc]init];
//    model.messageId = eventMessage.messageId;
//    model.chatType = kJMSGGroup;
//    model.type = kJMSGEventMessage;
//    model.chatContent = eventMessage.contentText;
//    [self addMessage:model];
//  }
//}

-(void)inputKeyboardWillShow:(NSNotification *)notification{
  _barBottomFlag=NO;
  CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
  [_messageTableView setNeedsLayout];
  [_toolBarContainer setNeedsLayout];
  [_moreViewContainer setNeedsLayout];
  [UIView animateWithDuration:animationTime animations:^{
    
    _moreViewHeight.constant = keyBoardFrame.size.height;
    
    [self scrollToEnd];
    [_toolBarContainer layoutIfNeeded];
    [_messageTableView layoutIfNeeded];
    [_moreViewContainer layoutIfNeeded];
  }];
  [self scrollToEnd];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
  CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
  [_messageTableView setNeedsLayout];
  [_toolBarContainer setNeedsLayout];
  [_moreViewContainer setNeedsLayout];
  
  [UIView animateWithDuration:animationTime animations:^{
    _moreViewHeight.constant = 0;
    [_toolBarContainer layoutIfNeeded];
    [_messageTableView layoutIfNeeded];
    [_moreViewContainer layoutIfNeeded];
  }];
  [self scrollToBottomAnimated:NO];
}

#pragma mark --发送文本
- (void)sendText:(NSString *)text {
  [self prepareTextMessage:text];
}

- (void)perform {
  _moreViewHeight.constant = 0;
  _toolBarToBottomConstrait.constant = 0;
}

#pragma mark --返回下面的位置
- (void)dropToolBar {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
  _toolBarContainer.toolbar.addButton.selected = NO;
  [_messageTableView reloadData];
  [UIView animateWithDuration:0.3 animations:^{
    _toolBarToBottomConstrait.constant = 0;
    _moreViewHeight.constant = 0;
  }];
}

- (void)dropToolBarNoAnimate {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
  _toolBarContainer.toolbar.addButton.selected = NO;
  [_messageTableView reloadData];
  _toolBarToBottomConstrait.constant = 0;
  _moreViewHeight.constant = 0;
}
#pragma mark --按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
  _barBottomFlag=NO;
  [_toolBarContainer.toolbar.textView resignFirstResponder];
  
  _toolBarToBottomConstrait.constant = 0;
  _moreViewHeight.constant = 227;
  [_messageTableView setNeedsDisplay];
  [_moreViewContainer setNeedsLayout];
  [_toolBarContainer setNeedsLayout];
  [UIView animateWithDuration:0.25 animations:^{
    _toolBarToBottomConstrait.constant = 0;
    _moreViewHeight.constant = 227;
    [_messageTableView layoutIfNeeded];
    [_toolBarContainer layoutIfNeeded];
    [_moreViewContainer layoutIfNeeded];
  }];
  [self scrollToBottomAnimated:NO];
}

-(void)noPressmoreBtnClick:(UIButton *)btn {
  [_toolBarContainer.toolbar.textView becomeFirstResponder];
}

#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
  DDLogDebug(@"Action - prepareTextMessage");
  if ([text isEqualToString:@""] || text == nil) {
    return;
  }
  JMSGMessage *message = nil;
  JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
  __block JCHATChatModel *model = [[JCHATChatModel alloc] init];
//  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
//    model.targetId = ((JMSGUser *)_conversation.target).username;
//    message = [JMSGMessage createSingleMessageWithContent:textContent username:model.targetId];
//    NSLog(@"huagnmin    conversation target   %@    ",_conversation);
//    NSLog(@"需要发送的message  是  %@",message);
//  }else {
//
//    model.targetId = ((JMSGGroup *)_conversation.target).gid;
//    message = [JMSGMessage createGroupMessageWithContent:textContent groupId:model.targetId];
//  }
  message = [_conversation createMessageWithContent:textContent];//!
  NSLog(@"huagnmin    conversation target   %@    ",_conversation);
  NSLog(@"需要发送的message  是  %@",message);
  [self addmessageShowTimeData:message.timestamp];
  [model setChatModelWith:message conversationType:_conversation];
  [_JMSgMessageDic setObject:message forKey:message.msgId];
  [self addMessage:model];
}

#pragma mark -- 刷新对应的
- (void)reloadCellDataWith:(NSInteger)Index {
  [_messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:Index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];//UITableViewRowAnimationNone
  //  [self scrollToEnd];
  UITableViewCell *tableCell = [_messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:Index inSection:0]];
  [tableCell setHighlighted:YES animated:NO];
  [tableCell setHighlighted:NO animated:NO];
  
}

- (void)addCellToTabel {
  NSIndexPath *path = [NSIndexPath indexPathForRow:[_messageDic[JCHATMessageIdKey] count]-1 inSection:0];
  [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  [self scrollToEnd];
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
  NSString *messageId = [_messageDic[JCHATMessageIdKey] lastObject];
  JCHATChatModel *lastModel =_messageDic[JCHATMessage][messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if ([_messageDic[JCHATMessageIdKey] count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      [self addTimeData:timeInterVal];
    }
  }else if ([_messageDic[JCHATMessageIdKey] count] ==0) {//首条消息显示时间
    [self addTimeData:timeInterVal];
  }else {
    DDLogDebug(@"不用显示时间");
  }
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
  NSString *messageId = [_messageDic[JCHATMessageIdKey] lastObject];
  JCHATChatModel *lastModel =_messageDic[JCHATMessage][messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if ([_messageDic[JCHATMessageIdKey] count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.messageId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];//!
      [_messageDic[JCHATMessage] setObject:timeModel forKey:timeModel.messageId];
      [_messageDic[JCHATMessageIdKey] addObject:timeModel.messageId];
    }
  }else if ([_messageDic[JCHATMessageIdKey] count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.messageId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];//!
    [_messageDic[JCHATMessage] setObject:timeModel forKey:timeModel.messageId];
    [_messageDic[JCHATMessageIdKey] addObject:timeModel.messageId];
  }else {
    DDLogDebug(@"不用显示时间");
  }
}

- (void)addTimeData:(NSTimeInterval)timeInterVal {
  JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
  timeModel.messageId = [self getTimeId];
  timeModel.isTime = YES;
  timeModel.messageTime = @(timeInterVal);
  timeModel.contentHeight = [timeModel getTextHeight];//!
  [self addMessage:timeModel];
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}

#pragma mark --滑动至尾端
- (void)scrollToEnd {
  if ([_messageDic[JCHATMessageIdKey] count] != 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messageDic[JCHATMessageIdKey] count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//!
  }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *messageId = _messageDic[JCHATMessageIdKey][indexPath.row];
  JCHATChatModel *model = _messageDic[JCHATMessage][messageId ];
  if (model.type == kJMSGContentTypeText || model.isTime == YES ||  model.type ==kJMSGContentTypeEventNotification) {
    return model.contentHeight +8;
  } else if (model.type == kJMSGContentTypeImage) {
    if (model.imageSize.height == 0) {
      model.imageSize = [model getImageSize];
    }
    return model.imageSize.height < 44?50:model.imageSize.height+5;
  } else if (model.type == kJMSGContentTypeVoice) {
    return 60;
  } else {
    return 40;
  }
}

#pragma mark --释放内存
- (void)dealloc {
  DDLogDebug(@"Action -- dealloc");
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self.toolBarContainer.toolbar.textView removeObserver:self forKeyPath:@"contentSize"];
//remove delegate
  [JMessage removeDelegate:self];
}

- (void)tapClick:(UIGestureRecognizer *)gesture {
  [self.toolBarContainer.toolbar.textView resignFirstResponder];
  [self dropToolBar];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_messageDic[JCHATMessageIdKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *messageId = _messageDic[JCHATMessageIdKey][indexPath.row];
  if (!messageId) {
    DDLogDebug(@"messageId is nill%@",messageId);
    return nil;
  }
  JCHATChatModel *model = _messageDic[JCHATMessage][messageId];
  if (!model) {
    DDLogDebug(@"JCHATChatModel is nill%@",messageId);
    return nil;
  }
  if (model.type == kJMSGContentTypeText) {
    static NSString *cellIdentifier = @"textCell";
    JCHATTextTableCell *cell = (JCHATTextTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[JCHATTextTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (!model.sendFlag) {
      model.sendFlag = YES;
      // 消息展示出来时，调用发文本消息
      [self sendTextMessage:model.messageId];
    }
    [cell setCellData:model delegate:self];
    return cell;
  }else if(model.type == kJMSGContentTypeImage)
  {
    static NSString *cellIdentifier = @"imgCell";
//    JCHATImgTableViewCell *cell = (JCHATImgTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    JCHATImgTableViewCell *cell = (JCHATImgTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
      cell = [[JCHATImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    JMSGMessage *imgMessage = _JMSgMessageDic[model.messageId];
    [cell setCellData:self chatModel:model message:imgMessage indexPath:indexPath];
    return cell;
  }else if (model.type == kJMSGContentTypeVoice)
  {
    static NSString *cellIdentifier = @"voiceCell";
    JCHATVoiceTableCell *cell = (JCHATVoiceTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[JCHATVoiceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    JMSGMessage *voiceMessage = _JMSgMessageDic[model.messageId];
    [cell setCellData:model delegate:self message:voiceMessage indexPath:indexPath];
    return cell;
  }else if (model.isTime == YES || model.type == kJMSGContentTypeEventNotification) {
    static NSString *cellIdentifier = @"timeCell";
    JCHATShowTimeCell *cell = (JCHATShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATShowTimeCell" owner:self options:nil] lastObject];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (model.type == kJMSGContentTypeEventNotification) {
      cell.messageTimeLabel.text = model.chatContent;
      //        [cell setCellData:model];
    }else {
      cell.messageTimeLabel.text = [JCHATStringUtils getFriendlyDateString:[model.messageTime doubleValue]];
    }
    return cell;
  }
  else{
    return nil;
  }
}

#pragma mark --发送消息
- (void)sendTextMessage:(NSString *)messageId{
  DDLogDebug(@"Action - sendTextMessage");
  JMSGMessage *message = _JMSgMessageDic[messageId];
  DDLogVerbose(@"The message:%@", message);
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [JMSGMessage sendMessage:message];
  });
}

- (void)setMessageIDWithMessage:(JMSGMessage *)message chatModel:(JCHATChatModel * __strong *)chatModel index:(NSInteger)index {
  [_messageDic[JCHATMessage] removeObjectForKey:(*chatModel).messageId];
  [_messageDic[JCHATMessage] setObject:*chatModel forKey:message.msgId];
  if ([_messageDic[JCHATMessageIdKey] count] > index) {
    [_messageDic[JCHATMessageIdKey] removeObjectAtIndex:index];
    [_messageDic[JCHATMessageIdKey] insertObject:message.msgId atIndex:index];
  }
}

- (void)selectHeadView:(JCHATChatModel *)model {
  if (model.isMyMessage) {
    JCHATPersonViewController *personCtl =[[JCHATPersonViewController alloc] init];
    personCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personCtl animated:YES];
  }else {
    JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
    if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
      friendCtl.userInfo = self.user;
      friendCtl.isGroupFlag = NO;
    }else {
      friendCtl.userInfo = [self getAvatarWithTargetId:model.fromId];
      friendCtl.isGroupFlag = YES;
    }
    [self.navigationController pushViewController:friendCtl animated:YES];
  }
}

#pragma mark --预览图片
- (void)tapPicture:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell {
  JCHATImgTableViewCell *cell =(JCHATImgTableViewCell *)tableViewCell;
  NSInteger count = _imgDataArr.count;
  NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
  for (int i = 0; i<count; i++) {
    JCHATChatModel *messageObject = [_imgDataArr objectAtIndex:i];
    NSString *url;
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.message = messageObject;
    url = messageObject.pictureImgPath;
    if (url) {
      photo.url = [NSURL fileURLWithPath:url]; // 图片路径
    }else {
      if (messageObject.pictureThumbImgPath == nil) {
        photo.url = [NSURL fileURLWithPath:messageObject.pictureThumbImgPath];
      }else {
        photo.url = [NSURL fileURLWithPath:url]; // 图片路径
      }
    }
    photo.srcImageView = tapView; // 来源于哪个UIImageView
    [photos addObject:photo];
  }
  MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
  browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
  browser.photos = photos; // 设置所有的图片
  browser.conversation =_conversation;
  [browser show];
}

#pragma mark --获取所有发送消息图片
- (NSArray *)getAllMessagePhotoImg {
  NSMutableArray *urlArr =[NSMutableArray array];
  for (NSInteger i=0; i<[_messageDic[JCHATMessageIdKey] count]; i++) {
    NSString *messageId = _messageDic[JCHATMessageIdKey][i];
    JCHATChatModel *model = _messageDic[JCHATMessage][messageId];
    if (model.type == kJMSGContentTypeImage) {
      [urlArr addObject:model.pictureImgPath];
    }
  }
  return urlArr;
}

- (void)didStartRecordingVoiceAction {
  DDLogVerbose(@"Action - didStartRecordingVoice");
  [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
  DDLogVerbose(@"Action - didCancelRecordingVoice");
  [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
  DDLogVerbose(@"Action - didFinishRecordingVoiceAction");
  [self finishRecorded];
}

- (void)didDragOutsideAction {
  DDLogVerbose(@"Actino - didDragOutsideAction");
  [self resumeRecord];
}

- (void)didDragInsideAction {
  DDLogVerbose(@"Action - didDragInsideAction");
  [self pauseRecord];
}

- (void)pauseRecord {
  [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
  [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
  WEAKSELF
  [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
    weakSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
    
  }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
  DDLogDebug(@"Action - startRecord");
  [self.voiceRecordHUD startRecordingHUDAtView:self.view];
  [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
  }];
}

#pragma mark --录音完毕
- (void)finishRecorded {
  DDLogDebug(@"Action - finishRecorded");
  WEAKSELF
  [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
    weakSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
    [weakSelf didSendMessageWithVoice:weakSelf.voiceRecordHelper.recordPath voiceDuration:weakSelf.voiceRecordHelper.recordDuration];
  }];
}

#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)didSendMessageWithVoice:(NSString *)voicePath
                  voiceDuration:(NSString*)voiceDuration {
  DDLogDebug(@"Action - didSendMessageWithVoice");
  
  if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
    if ([voiceDuration integerValue]<0.5) {
      DDLogDebug(@"录音时长小于 0.5s");
    }else {
      DDLogDebug(@"录音时长大于 60s");
    }
    return;
  }
  
  
  JMSGMessage *voiceMessage = nil;
  __block JCHATChatModel *model =[[JCHATChatModel alloc] init];
  model.messageId = voiceMessage.msgId;
  JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath] voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];

//  if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
//    voiceMessage = [JMSGMessage createSingleMessageWithContent:voiceContent username:((JMSGUser *)(_conversation.target)).username];
//  }else {
//    voiceMessage = [JMSGMessage createGroupMessageWithContent:voiceContent groupId:((JMSGGroup *)(_conversation.target)).gid];
//  }
  voiceMessage = [_conversation createMessageWithContent:voiceContent];//!
//  model.messageTime = voiceMessage.timestamp;
  [model setChatModelWith:voiceMessage conversationType:_conversation];
  [_JMSgMessageDic setObject:voiceMessage forKey:voiceMessage.msgId];
  [JCHATFileManager deleteFile:voicePath];
  [self addMessage:model];
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
  NSString *recorderPath = nil;
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yy-MMMM-dd";
  recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
  //    dateFormatter.dateFormat = @"hh-mm-ss";
  dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
  recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
  return recorderPath;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (self.barBottomFlag) {
    return;
  }
  if (object == self.toolBarContainer.toolbar.textView && [keyPath isEqualToString:@"contentSize"]) {
    [self layoutAndAnimateMessageInputTextView:object];
  }
}

#pragma mark ---
- (void)getContinuePlay:(UITableViewCell *)cell
              indexPath:(NSIndexPath *)indexPath {
  JCHATVoiceTableCell *tempCell = (JCHATVoiceTableCell *) cell;
  if ([_messageDic[JCHATMessageIdKey] count] - 1 > indexPath.row) {
    NSString *messageId = _messageDic[JCHATMessageIdKey][indexPath.row+1];
    JCHATChatModel *model = _messageDic[JCHATMessage][ messageId];
    if (model.type == kJMSGContentTypeVoice && !model.readState) {
      tempCell.continuePlayer = YES;
    }
  }
}

#pragma mark --连续播放语音
- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
  if ([_messageDic[JCHATMessageIdKey] count]-1 > indexPath.row) {
    NSString *messageId = _messageDic[JCHATMessageIdKey][indexPath.row+1];
    JCHATChatModel *model = _messageDic[JCHATMessage][ messageId];
    if (model.type==kJMSGContentTypeVoice && !model.readState) {
      JCHATVoiceTableCell *voiceCell =(JCHATVoiceTableCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
      [voiceCell playVoice];
    }
  }
}

#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    return ceilf([textView sizeThatFits:textView.frame.size].height);
  } else {
    return textView.contentSize.height;
  }
}

#pragma mark - Layout Message Input View Helper Method

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
  CGFloat maxHeight = [JCHATToolBar maxHeight];
  
  CGFloat contentH = [self getTextViewContentH:textView];
  
  BOOL isShrinking = contentH < _previousTextViewContentHeight;
  CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
  
  if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
    changeInHeight = 0;
  }
  else {
    changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
  }
  if (changeInHeight != 0.0f) {
    [UIView animateWithDuration:0.25f
                     animations:^{
                       [self setTableViewInsetsWithBottomValue:_messageTableView.contentInset.bottom + changeInHeight];
                       
                       [self scrollToBottomAnimated:NO];
                       
                       if (isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           _previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // if shrinking the view, animate text view frame BEFORE input view frame
                         [_toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                       
                       //                             CGRect inputViewFrame = self.toolBarContainer.toolbar.frame;
                       //                             self.toolBarContainer.toolbar.frame = CGRectMake(0.0f,
                       //                                                                      inputViewFrame.origin.y - changeInHeight,
                       //                                                                      inputViewFrame.size.width,
                       //                                                                      inputViewFrame.size.height + changeInHeight);
                       if (!isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // growing the view, animate the text view frame AFTER input view frame
                         [self.toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                     }
                     completion:^(BOOL finished) {
                     }];
    
    self.previousTextViewContentHeight = MIN(contentH, maxHeight);
  }
  
  // Once we reached the max height, we have to consider the bottom offset for the text view.
  // To make visible the last line, again we have to set the content offset.
  if (self.previousTextViewContentHeight == maxHeight) {
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime,
                   dispatch_get_main_queue(),
                   ^(void) {
                     CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                     [textView setContentOffset:bottomOffset animated:YES];
                   });
  }
}

- (void)scrollToBottomAnimated:(BOOL)animated {
  if (![self shouldAllowScroll])
    return;
  
  NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
  
  if (rows > 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                 atScrollPosition:UITableViewScrollPositionBottom
                                         animated:animated];
  }
}

#pragma mark - Previte Method

- (BOOL)shouldAllowScroll {
  //    if (self.isUserScrolling) {
  //        if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
  //            && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
  //            return NO;
  //        }
  //    }
  return YES;
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
  //    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
  //    self.messageTableView.contentInset = insets;
  //    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
  UIEdgeInsets insets = UIEdgeInsetsZero;
  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    insets.top = 64;
  }
  insets.bottom = bottom;
  return insets;
}

#pragma mark - XHMessageInputView Delegate

- (void)inputTextViewWillBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  _textViewInputViewType = JPIMInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(JCHATMessageTextView *)messageInputTextView;
{
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

// ---------------------------------- Private methods





@end
