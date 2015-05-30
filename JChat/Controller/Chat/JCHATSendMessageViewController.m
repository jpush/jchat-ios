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
#import "JCHATTextTableViewCell.h"
#import "JCHATGroupSettingCtl.h"
#import "AppDelegate.h"
#import "NSObject+TimeConvert.h"
#import "MBProgressHUD+Add.h"
#import "UIImage+ResizeMagick.h"
#import "JCHATPersonViewController.h"
#import "JCHATFriendDetailViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "JCHATStringUtils.h"
#import <JMessage/JMessage.h>

#define interval 60*2

@interface JCHATSendMessageViewController () {

@private
  NSMutableArray *_messageDataArr;
  NSMutableArray *_imgDataArr;
  __block JMSGConversation *_conversation;
}

@end


@implementation JCHATSendMessageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DDLogDebug(@"Action - viewDidLoad");

  if (self.user) {
    self.targetName = self.user.username;
  } else if (_conversation) {
    self.targetName = _conversation.target_name;
  } else {
    DDLogWarn(@"聊天未知错误 - 非单聊，且无会话。");
  }

  if (!_conversation) {
    if (self.user) {
      DDLogDebug(@"No conversation - to create single");
      [JMSGConversation createConversation:self.user.username
                                  withType:kJMSGSingle
                         completionHandler:^(id resultObject, NSError *error) {
                           _conversation = (JMSGConversation *) resultObject;

                           [_conversation resetUnreadMessageCountWithCompletionHandler:^(id resultObject, NSError *error) {
                             if (error == nil) {
                             } else {
                               DDLogWarn(@"消息计数清零失败");
                             }
                           }];

                         }];
    } else {
      DDLogWarn(@"No conversation - no create group yet.");
    }
  } else {
    DDLogDebug(@"Conversation existed.");
  }

  if (self.conversation && self.conversation.chatType == kJMSGGroup) {
    self.title = _conversation.target_name;
  } else {
    __weak __typeof(self) weakSelf = self;
    if (!self.user) {
      [JMSGUser getUserInfoWithUsername:_conversation.target_id completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
          JPIMMAINTHEAD(^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.user = ((JMSGUser *) resultObject);
            if (strongSelf.user.noteName != nil && ![strongSelf.user.noteName isEqualToString:KNull]) {
              strongSelf.title = strongSelf.user.noteName;
            } else if (strongSelf.user.nickname != nil && ![strongSelf.user.nickname isEqualToString:KNull]) {
              strongSelf.title = strongSelf.user.nickname;
            } else {
              strongSelf.title = strongSelf.user.username;
            }
          });
        } else {
          __strong __typeof(weakSelf) strongSelf = weakSelf;
          JPIMMAINTHEAD(^{
            strongSelf.title = _conversation.target_id;
            DDLogDebug(@"没有这个用户");
          });
        }
      }];
    }
  }

  _messageDataArr = [[NSMutableArray alloc] init];
  _imgDataArr =[[NSMutableArray alloc] init];

  [self getAllMessage];

  self.messageTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kApplicationWidth,kApplicationHeight-45-(kNavigationBarHeight)) style:UITableViewStylePlain];
  self.messageTableView.userInteractionEnabled = YES;
  self.messageTableView.showsVerticalScrollIndicator=NO;
  self.messageTableView.delegate = self;
  self.messageTableView.dataSource = self;
  self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.messageTableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1];

  [self.view addSubview:self.messageTableView];
  NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"JCHATToolBar"owner:self options:nil];
  self.toolBar = [nib objectAtIndex:0];
  self.toolBar.contentMode = UIViewContentModeRedraw;
  [self.toolBar setFrame:CGRectMake(0, self.view.bounds.size.height-45, self.view.bounds.size.width, 45)];
  self.toolBar.delegate = self;
  [self.toolBar setUserInteractionEnabled:YES];
  [self.view addSubview:self.toolBar];

  [self.view setBackgroundColor:[UIColor whiteColor]];
  UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [rightBtn setFrame:CGRectMake(0, 0, 46, 46)];
  [rightBtn setImage:[UIImage imageNamed:@"setting_55"] forState:UIControlStateNormal];
  [rightBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];//为导航栏添加右侧按钮

  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:CGRectMake(0, 0, 30, 30)];
  [leftBtn setImage:[UIImage imageNamed:@"login_15"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  self.navigationController.interactivePopGestureRecognizer.delegate = self;
  UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
  [self.view addGestureRecognizer:gesture];
  NSArray *temXib = [[NSBundle mainBundle]loadNibNamed:@"JCHATMoreView"owner:self options:nil];
  self.moreView = [temXib objectAtIndex:0];
  self.moreView.delegate = self;
  if ([self checkDevice:@"iPad"] || kApplicationHeight <= 480) {
      [self.moreView setFrame:CGRectMake(0, kScreenHeight, self.view.bounds.size.width, 300)];
  }else {
      [self.moreView setFrame:CGRectMake(0, kScreenHeight, self.view.bounds.size.width, 200)];
  }
  [self.view addSubview:self.moreView];

  [self addNotification];
}

- (void)receiveNotificationSkipToChatPageView:(NSNotification *)notification {
  DDLogDebug(@"Action - receiveNotificationSkipToChatPageView");
  NSDictionary *apnsDic = [notification object];
  NSString *targetNameStr = [apnsDic[@"aps"] objectForKey:@"alert"];
  NSString *targetName = [[targetNameStr componentsSeparatedByString:@":"] objectAtIndex:0];
  if ([targetName isEqualToString:_conversation.target_id] || [targetName isEqualToString:_conversation.target_id]) {
    return;
  }
  if ([targetName isEqualToString:[JMSGUser getMyInfo].username]) {
    return;
  }
  [JMSGConversation getConversation:targetName completionHandler:^(id resultObject, NSError *error) {
    if (error == nil) {
      _conversation = resultObject;
      [_conversation resetUnreadMessageCountWithCompletionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
          DDLogDebug(@"清零成功");
        } else {
          DDLogDebug(@"清零失败");
        }
      }];
      [JMSGUser getUserInfoWithUsername:targetName completionHandler:^(id resultObject, NSError *error) {
        self.user = resultObject;
        [self getAllMessage];
        self.title = targetName;
      }];
    } else {

    }
  }];
}

#pragma mark --发送消息响应
- (void)sendMessageResponse:(NSNotification *)response {
  DDLogDebug(@"Event - sendMessageResponse");
  NSDictionary *responseDic = [response userInfo];
  JMSGMessage *message = responseDic[JMSGSendMessageObject];
  NSError *error = responseDic[JMSGSendMessageError];
  if (error == nil) {
  } else {
    DDLogDebug(@"Sent response error - %@", error);
    if (error.code == 800013) {
      DDLogError(@"用户登出了");
    }
  }

  JCHATChatModel *model;
  for (NSInteger i = 0; i < [_messageDataArr count]; i++) {
    model = _messageDataArr[i];
    if ([message.messageId isEqualToString:model.messageId]) {
      if (message.messageType == kJMSGVoiceMessage) {
        JMSGVoiceMessage *voiceMessage = (JMSGVoiceMessage *) message;
        model.voicePath = voiceMessage.resourcePath;
      } else if (message.messageType == kJMSGImageMessage) {
        JMSGImageMessage *imgMessage = (JMSGImageMessage *) message;
        model.pictureImgPath = imgMessage.resourcePath;
      }
      model.messageStatus = [message.status integerValue];
    }
  }

  JPIMMAINTHEAD(^{
    [_messageTableView reloadData];
  });
}

// FIXME - 现在的作法效率低，一条一条搜索。应该用个 HashMap 其 Key 是 messageID
- (void)changeMessageState:(JMSGMessage *)message {
  DDLogDebug(@"Action - changeMessageState");
  for (NSInteger i = 0; i < [_messageDataArr count]; i++) {
    JCHATChatModel *model = [_messageDataArr objectAtIndex:i];
    if ([message.messageId isEqualToString:model.messageId]) {
      model.messageStatus = [message.status integerValue];
      [self.messageTableView reloadData];
    }
  }
}

- (bool)checkDevice:(NSString *)name {
  NSString *deviceType = [UIDevice currentDevice].model;
  DDLogDebug(@"deviceType = %@", deviceType);
  NSRange range = [deviceType rangeOfString:name];
  return range.location != NSNotFound;
}

- (void)getAllMessage {
    __block NSMutableArray * arrList;
    [_messageDataArr removeAllObjects];
    [_conversation getAllMessageWithCompletionHandler:^(id resultObject, NSError *error) {
        arrList = resultObject;
        for (NSInteger i=0; i< [arrList count]; i++) {
            JMSGMessage *message =[arrList objectAtIndex:i];
            JCHATChatModel *model =[[JCHATChatModel alloc]init];
            model.messageId = message.messageId;
            model.conversation = _conversation;
            model.messageStatus = [message.status integerValue];
            model.displayName = message.display_name;
            model.readState = YES;
            JMSGUser *user = [JMSGUser getMyInfo];
            if ([message.target_id isEqualToString :user.username]) {
                model.who=NO;
                model.avatar = _conversation.avatarThumb;
                model.targetId = _conversation.target_id;
            }else{
                model.who=YES;
                model.avatar = user.avatarThumbPath;
                model.targetId = user.username;
            }
            if (message.messageType == kJMSGTextMessage) {
                model.type=kJMSGTextMessage;
                JMSGContentMessage *contentMessage = (JMSGContentMessage *)message;
                model.chatContent = contentMessage.contentText;
            }else if (message.messageType == kJMSGImageMessage)
            {
                model.type= kJMSGImageMessage;
                JMSGImageMessage *imageMessage = (JMSGImageMessage *)message;
                if (imageMessage.resourcePath != nil) {
                    model.pictureImgPath = imageMessage.resourcePath;
                    if (imageMessage.thumbPath != nil) {
                        model.pictureThumbImgPath = imageMessage.thumbPath;
                    }
                    [_imgDataArr addObject:model];
                }else {
                    model.pictureThumbImgPath = imageMessage.thumbPath;
                    [_imgDataArr addObject:model];
                }
                model.photoIndex = [_imgDataArr count] -1;
            }else if (message.messageType == kJMSGVoiceMessage)
            {
                model.type = kJMSGVoiceMessage;
                JMSGVoiceMessage *voiceMessage = (JMSGVoiceMessage *)message;
                model.voicePath = voiceMessage.resourcePath;
                model.voiceTime = [NSString stringWithFormat:@"%@",voiceMessage.duration];
                model.chatContent =@"";
            }
            model.messageTime = message.timestamp;
            [self compareReceiveMessageTimeInterVal:[model.messageTime doubleValue]];
            [_messageDataArr addObject:model];
        }
            [_messageTableView reloadData];
        if ([_messageDataArr count] != 0) {
            [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messageDataArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}

#pragma mark --收到消息
-(void)receiveMessageNotification:(NSNotification *)notification {
  DDLogDebug(@"Event - receiveMessageNotification");
    JPIMMAINTHEAD(^{
        JMSGUser *user = [JMSGUser getMyInfo];
        [_conversation resetUnreadMessageCountWithCompletionHandler:^(id resultObject, NSError *error) {
            if (error == nil) {
            }else {
                DDLogDebug(@"消息未读数清空失败");
            }
        }];

        NSDictionary *userInfo = [notification userInfo];
        JMSGMessage *message = (JMSGMessage *)(userInfo[JMSGNotification_SendMessageResult]);
        DDLogDebug(@"The received msg - %@", message);
        if (!message) {
          DDLogWarn(@"No message content in notification.");
          return;
        }

        if (_conversation.chatType == kJMSGSingle) {
          if (![message.target_id isEqualToString:self.user.username]) {
            // FIXME - This condition should be done by SDK.
            DDLogWarn(@"It's single chat, but the targetId of the msg is not me. Throw away.");
            return;
          }
        } else {
          DDLogVerbose(@"It is a group chat.");
        }

        JCHATChatModel *model =[[JCHATChatModel alloc] init];
        model.messageId = message.messageId;
        model.conversation = _conversation;
        model.targetId = message.target_id;
        model.messageStatus = [message.status integerValue];
        if (message.messageType == kJMSGTextMessage) {
            model.type=kJMSGTextMessage;
            JMSGContentMessage *contentMessage =  (JMSGContentMessage *)message;
            model.chatContent = contentMessage.contentText;
        } else if (message.messageType == kJMSGImageMessage) {
            model.type=kJMSGImageMessage;
            model.pictureThumbImgPath = ((JMSGImageMessage *)message).thumbPath;
            [_imgDataArr addObject:model];
            model.photoIndex = [_imgDataArr count] -1;
        } else if (message.messageType == kJMSGVoiceMessage){
            model.type = kJMSGVoiceMessage;
            model.voicePath =((JMSGVoiceMessage *)message).resourcePath;
            model.voiceTime = [((JMSGVoiceMessage *)message).duration stringByAppendingString:@"''"];
            model.readState = NO;
        }

        if ([user.username isEqualToString:message.target_id]) {
            model.who = YES;
            model.avatar = user.avatarThumbPath;
            model.targetId = [JMSGUser getMyInfo].username;
        }else {
            model.who = NO;
            model.avatar = _conversation.avatarThumb;
            model.targetId = _conversation.target_id;
        }

        model.messageTime = message.timestamp;
        [self compareReceiveMessageTimeInterVal:[model.messageTime doubleValue]];
        [_messageDataArr addObject:model];
        [self addCellToTabel];
        [self scrollToEnd];
    });
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
    [self.toolBar.textView resignFirstResponder];
    [self dropToolBar];
}

#pragma mark --增加朋友
-(void)addFriends
{
  if (self.conversation.chatType == kJMSGSingle) {
    JCHATDetailsInfoViewController *detailsInfoCtl = [[JCHATDetailsInfoViewController alloc] initWithNibName:@"JCHATDetailsInfoViewController" bundle:nil];
    detailsInfoCtl.chatUser = self.user;
    detailsInfoCtl.sendMessageCtl = self;
    [self.navigationController pushViewController:detailsInfoCtl animated:YES];
  }else{
    JCHATGroupSettingCtl *groupSettingCtl = [[JCHATGroupSettingCtl alloc] init];
    groupSettingCtl.conversation = self.conversation;
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
  UIImage *image;
  image = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self prepareImageMessage:image];
  [self dismissViewControllerAnimated:YES completion:nil];
  [self dropToolBar];
}

#pragma mark --发送图片
- (void)prepareImageMessage:(UIImage *)img {
  DDLogDebug(@"Action - prepareImageMessage");
  img = [img resizedImageByWidth:upLoadImgWidth];
  UIImage *smallpImg = [UIImage imageWithImageSimple:img scaled:0.5];
  NSString *bigPath = [JCHATFileManager saveImageWithConversationID:_conversation.target_id andData:UIImageJPEGRepresentation(img, 1)];
  NSString *smallImgPath = [JCHATFileManager saveImageWithConversationID:_conversation.target_id andData:UIImageJPEGRepresentation(smallpImg, 1)];

  JCHATChatModel *model = [[JCHATChatModel alloc] init];
  model.who = YES;
  model.sendFlag = NO;
  model.conversation = _conversation;
  model.targetId = self.conversation.target_id;
  model.avatar = [JMSGUser getMyInfo].avatarThumbPath;
  model.messageStatus = kJMSGStatusSending;
  model.type = kJMSGImageMessage;
  model.pictureImgPath = bigPath;
  model.mediaData = UIImageJPEGRepresentation(smallpImg, 1);
  model.pictureThumbImgPath = smallImgPath;
  NSTimeInterval timeInterVal = [self getCurrentTimeInterval];
  model.messageTime = @(timeInterVal);
  [_imgDataArr addObject:model];
  model.photoIndex = [_imgDataArr count] - 1;

  [_messageDataArr addObject:model];
  [self.messageTableView reloadData];
  [self dropToolBar];
  [self scrollToEnd];
}

#pragma mark --
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendMessageResponse:)
                                                 name:JMSGNotification_SendMessageResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessageNotification:)
                                                 name:JMSGNotification_ReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotificationSkipToChatPageView:)
                                                 name:KApnsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMessageState:)
                                                 name:kMessageChangeState
                                               object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(deleteAllMessage)
                                               name:kDeleteAllMessage
                                             object:nil];
//    [self.toolBar.textView addObserver:self
//                            forKeyPath:@"contentSize"
//                               options:NSKeyValueObservingOptionNew
//                               context:nil];
}

- (void)deleteAllMessage {
  [_messageDataArr removeAllObjects];
  [_messageTableView reloadData];
}

-(void)inputKeyboardWillShow:(NSNotification *)notification{
    self.barBottomFlag=NO;
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self.messageTableView setFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kApplicationWidth,kApplicationHeight-45-(kNavigationBarHeight)-keyBoardFrame.size.height)];
    [self scrollToEnd];
    [UIView animateWithDuration:animationTime animations:^{
        [self.toolBar setFrame:CGRectMake(0, kApplicationHeight+kStatusBarHeight-45-keyBoardFrame.size.height, self.view.bounds.size.width, 45)];
    }];
    [self.moreView setFrame:CGRectMake(0, kScreenHeight, self.view.bounds.size.width, self.moreView.bounds.size.height)];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self.messageTableView setFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kApplicationWidth,kApplicationHeight-45-(kNavigationBarHeight))];
        [UIView animateWithDuration:animationTime animations:^{
            [self.toolBar setFrame:CGRectMake(0, kApplicationHeight+kStatusBarHeight-45, self.view.bounds.size.width, 45)];
        }];
}

#pragma mark --发送文本
- (void)sendText:(NSString *)text {
  [self prepareTextMessage:text];
}

- (void)perform {
    [self.moreView setFrame:CGRectMake(0, kScreenHeight, self.view.bounds.size.width, self.moreView.bounds.size.height)];
    [self.toolBar setFrame:CGRectMake(0, kApplicationHeight+kStatusBarHeight-45, self.view.bounds.size.width, 45)];
}

#pragma mark --返回下面的位置
- (void)dropToolBar {
    self.barBottomFlag=YES;
    self.previousTextViewContentHeight = 31;
    self.toolBar.addButton.selected = NO;
    [self.messageTableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        [self.moreView setFrame:CGRectMake(0, kScreenHeight, self.view.bounds.size.width, self.moreView.bounds.size.height)];
        [self.toolBar setFrame:CGRectMake(0, self.view.bounds.size.height - self.toolBar.bounds.size.height, self.toolBar.bounds.size.width, 45)];
      [self.messageTableView setFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kApplicationWidth,kApplicationHeight-45-(kNavigationBarHeight))];
    }];
}

#pragma mark --按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
  self.barBottomFlag=NO;
  [self.toolBar.textView resignFirstResponder];
  [self.moreView setFrame:CGRectMake(0, kScreenHeight, self.moreView.bounds.size.width, self.moreView.bounds.size.height)];
  [UIView animateWithDuration:0.3 animations:^{
  [self.toolBar setFrame:CGRectMake(0, kScreenHeight-45-self.moreView.bounds.size.height, self.view.bounds.size.width, 45)];
  [self.moreView setFrame:CGRectMake(0, kScreenHeight-self.moreView.bounds.size.height, self.view.bounds.size.width, self.moreView.bounds.size.height)];
  }];
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.messageTableView setFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kApplicationWidth,kScreenHeight-45-(kNavigationBarHeight+kStatusBarHeight) - self.moreView.bounds.size.height)];
    [self scrollToEnd];
  }];
}

-(void)noPressmoreBtnClick:(UIButton *)btn {
    [self.toolBar.textView becomeFirstResponder];
}

#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
  DDLogDebug(@"Action - prepareTextMessage");
  if ([text isEqualToString:@""] || text == nil) {
    return;
  }

  [self addmessageShowTimeData];
  JCHATChatModel *model = [[JCHATChatModel alloc] init];
  model.who = YES;
  model.conversation = _conversation;
  model.displayName = self.targetName;
  JMSGUser *user = [JMSGUser getMyInfo];
  model.avatar = user.avatarThumbPath;
  model.targetId = _conversation.target_id;
  model.messageStatus = kJMSGStatusSending;
  NSTimeInterval timeInterVal = [self getCurrentTimeInterval];
  model.messageTime = @(timeInterVal);
  model.sendFlag = NO;
  model.type = kJMSGTextMessage;
  model.chatContent = text;

  [_messageDataArr addObject:model];
  [self addCellToTabel];
  [self scrollToEnd];
}

- (void)addCellToTabel {
  [_messageTableView reloadData];
//    NSIndexPath *path = [NSIndexPath indexPathForRow:[_messageDataArr count]-1 inSection:0];
//    [self.messageTableView beginUpdates];
//    [self.messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//    [self.messageTableView endUpdates];
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData {
    JCHATChatModel *lastModel =[_messageDataArr lastObject];
    NSTimeInterval timeInterVal = [self getCurrentTimeInterval];
    if ([_messageDataArr count]>0 && lastModel.type != kJMSGTimeMessage) {
        NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
        NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
        NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
        if (fabs(timeBetween) > interval) {
            JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
            timeModel.type = kJMSGTimeMessage;
            timeModel.messageTime = @(timeInterVal);
            [_messageDataArr addObject:timeModel];
            [self addCellToTabel];
        }
    }
}

- (void)compareReceiveMessageTimeInterVal :(NSTimeInterval )timeInterVal {
    JCHATChatModel *lastModel =[_messageDataArr lastObject];
    if ([_messageDataArr count]>0 && lastModel.type != kJMSGTimeMessage) {
        NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
        NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
        NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
        if (fabs(timeBetween) > interval) {
            JCHATChatModel *timeModel = [[JCHATChatModel alloc] init];
            timeModel.type = kJMSGTimeMessage;
            timeModel.messageTime = @(timeInterVal);
//            [self getTimeDate:timeInterVal];
            [_messageDataArr addObject:timeModel];
            [self addCellToTabel];
        }
    }
}

#pragma mark --滑动至尾端
- (void)scrollToEnd {
    if ([_messageDataArr count] != 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messageDataArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  JCHATChatModel *model = [_messageDataArr objectAtIndex:indexPath.row];
  if (model.type == kJMSGTextMessage) {
    return model.getTextSize.height + 8;
  } else if (model.type == kJMSGImageMessage) {
    if (model.messageStatus == kJMSGStatusReceiveDownloadFailed) {
      return 150;
    } else {
      UIImage *img = [UIImage imageWithContentsOfFile:model.pictureThumbImgPath];
      if (kScreenWidth > 320) {
        return img.size.height / 3;
      } else {
        return img.size.height / 2;
      }
    }
  } else if (model.type == kJMSGVoiceMessage) {
    return 60;
  } else {
    return 40;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:NO];
  [self.toolBar drawRect:self.toolBar.frame];
  [self.navigationController setNavigationBarHidden:NO];
  [_conversation resetUnreadMessageCountWithCompletionHandler:^(id resultObject, NSError *error) {
      if (error == nil) {
        DDLogDebug(@"清零成功");
      }else {
        DDLogDebug(@"清零失败");
      }
  }];
  
//    // 禁用 iOS7 返回手势
  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
      self.navigationController.interactivePopGestureRecognizer.enabled = YES;
  }
  if (self.user != nil && self.conversation.chatType == kJMSGGroup) {
    self.user = nil;
    [_messageDataArr removeAllObjects];
  }
  self.title = self.conversation.target_name;
  [self.messageTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
}


#pragma mark --释放内存
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tapClick:(UIGestureRecognizer *)gesture {
    [self.toolBar.textView resignFirstResponder];
    [self dropToolBar];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messageDataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JCHATChatModel *model = [_messageDataArr objectAtIndex:indexPath.row];
    if (model.type == kJMSGTextMessage) {
        static NSString *cellIdentifier = @"textCell";
        JCHATTextTableViewCell *cell = (JCHATTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JCHATTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (!model.sendFlag) {
            model.sendFlag = YES;
            // 消息展示出来时，调用发文本消息
          [self sendTextMessage:model];
        }
        [cell setCellData:model delegate:self];
        return cell;
    }else if(model.type == kJMSGImageMessage)
    {
        static NSString *cellIdentifier = @"imgCell";
        JCHATImgTableViewCell *cell = (JCHATImgTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JCHATImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setCellData:self chatModel:model indexPath:indexPath];
        return cell;
    }else if (model.type == kJMSGVoiceMessage)
    {
        static NSString *cellIdentifier = @"voiceCell";
        JCHATVoiceTableViewCell *cell = (JCHATVoiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JCHATVoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setCellData:model delegate:self indexPath:indexPath];
        return cell;
    }else if (model.type == kJMSGTimeMessage) {
        static NSString *cellIdentifier = @"timeCell";
        JCHATShowTimeCell *cell = (JCHATShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATShowTimeCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.messageTimeLabel.text = [JCHATStringUtils getFriendlyDateString:[model.messageTime doubleValue]];
        return cell;
    }
    else{
        return nil;
    }
}

#pragma mark --发送消息
- (void)sendTextMessage:(JCHATChatModel *)model {
  DDLogDebug(@"Action - sendTextMessage");
  model.messageStatus = kJMSGStatusSending;

  JMSGContentMessage *  message = [[JMSGContentMessage alloc] init];
  model.messageId = message.messageId;

  if (self.conversation.chatType == kJMSGSingle) {
    message.sendMessageType = kJMSGSingle;
  }else {
    message.sendMessageType = kJMSGGroup;
  }
  message.target_id = model.targetId;
  message.timestamp = model.messageTime;
  message.contentText = model.chatContent;

  DDLogVerbose(@"The message:%@", message);
  [JMSGMessage sendMessage:message];
}

- (void)selectHeadView:(JCHATChatModel *)model {
    if (model.who) {
        JCHATPersonViewController *personCtl =[[JCHATPersonViewController alloc] init];
        personCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personCtl animated:YES];
    }else {
        JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
        friendCtl.userInfo = self.user;
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
            url = messageObject.pictureThumbImgPath;
            photo.url = [NSURL fileURLWithPath:url]; // 图片路径
        }
        photo.srcImageView = tapView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.conversation =_conversation;
    [browser show];
    [self.messageTableView reloadData];
}

#pragma mark --获取所有发送消息图片
- (NSArray *)getAllMessagePhotoImg {
    NSMutableArray *urlArr =[NSMutableArray array];
    for (NSInteger i=0; i<[_messageDataArr count]; i++) {
        JCHATChatModel *model = [_messageDataArr objectAtIndex:i];
        if (model.type == kJMSGImageMessage) {
            [urlArr addObject:model.pictureImgPath];
        }
    }
    return urlArr;
}

- (void)didStartRecordingVoiceAction {
  DDLogDebug(@"Action - didStartRecordingVoice");
  [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
  DDLogDebug(@"Action - didCancelRecordingVoice");
  [self cancelRecord];
}

- (void)didFinishRecoingVoiceAction {
  DDLogDebug(@"Action - didFinishRecoingVoice");
  [self finishRecorded];
}

- (void)didDragOutsideAction {
  DDLogDebug(@"Actino - didDragOutsideAction");
  [self resumeRecord];
}

- (void)didDragInsideAction {
  DDLogDebug(@"Action - didDragInsideAction");
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
  JCHATChatModel *model =[[JCHATChatModel alloc] init];
  if ([voiceDuration integerValue] >= 60) {
      model.voiceTime = @"60''";
  }else{
      model.voiceTime = [NSString stringWithFormat:@"%d''",(int)[voiceDuration integerValue]];
  }
  model.avatar = [JMSGUser getMyInfo].avatarThumbPath;
  model.type=kJMSGVoiceMessage;
  model.conversation = _conversation;
  NSTimeInterval timeInterVal = [self getCurrentTimeInterval];
  model.messageTime = @(timeInterVal);
  model.targetId = self.conversation.target_id;
  model.displayName = self.targetName;
  model.readState=YES;
  model.who=YES;
  model.sendFlag = NO;
  model.mediaData = [NSData dataWithContentsOfFile:voicePath];
  [JCHATFileManager deleteFile:voicePath];
  [_messageDataArr addObject:model];
  [self.messageTableView reloadData];
  [self scrollToEnd];
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
    if (object == self.toolBar.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}


#pragma mark ---
- (void)getContinuePlay:(UITableViewCell *)cell
              indexPath:(NSIndexPath *)indexPath {
  JCHATVoiceTableViewCell *tempCell = (JCHATVoiceTableViewCell *) cell;
  if ([_messageDataArr count] - 1 > indexPath.row) {
    JCHATChatModel *model = [_messageDataArr objectAtIndex:indexPath.row + 1];
    if (model.type == kJMSGVoiceMessage && !model.readState) {
      tempCell.continuePlayer = YES;
    }
  }
}

#pragma mark --连续播放语音
- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([_messageDataArr count]-1>indexPath.row) {
        JCHATChatModel *model =[_messageDataArr objectAtIndex:indexPath.row+1];
        if (model.type==kJMSGVoiceMessage&& !model.readState) {
             JCHATVoiceTableViewCell *voiceCell =(JCHATVoiceTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
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

    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;

    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }

    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.messageTableView.contentInset.bottom + changeInHeight];

                             [self scrollToBottomAnimated:NO];

                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.toolBar adjustTextViewHeightBy:changeInHeight];
                             }

                             CGRect inputViewFrame = self.toolBar.frame;
                             self.toolBar.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.toolBar adjustTextViewHeightBy:changeInHeight];
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
    self.textViewInputViewType = JPIMInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(JCHATMessageTextView *)messageInputTextView {
    if (!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(JCHATMessageTextView *)messageInputTextView;
{
    if (!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




// ---------------------------------- Private methods





@end
