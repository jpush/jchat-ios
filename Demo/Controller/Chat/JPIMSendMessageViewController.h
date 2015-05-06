//
//  JPIMSendMessageViewController.h
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPIMToolBar.h"
#import "JPIMMoreView.h"
#import "RecordAnimationView.h"
#import "JPIMImgTableViewCell.h"
#import "ChatModel.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "JPIMVoiceTableViewCell.h"
#import <JMessage/JMessage.h>

@interface JPIMSendMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SendMessageDelegate,AddBtnDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PictureDelegate,playVoiceDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic)  JPIMToolBar *toolBar;
@property (strong,nonatomic)   UITableView *messageTableView;
@property (strong, nonatomic)  JPIMMoreView *moreView;
@property (nonatomic, assign) JPIMInputViewType textViewInputViewType;
@property (assign, nonatomic)   BOOL barBottomFlag;
@property (nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
@property (nonatomic, strong, readwrite) JPIMVoiceTableViewCell *saveVoiceCell;
@property (strong, nonatomic)  JMSGConversation *conversation;
@property (assign, nonatomic)  ConversationType conversationType;
@property (strong, nonatomic)  NSString *targetName;
@property (strong, nonatomic)  JMSGUser *user;
@property (strong, nonatomic)  NSMutableArray *conversationList;

/**
 *  管理录音工具对象
 */
@property (nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;
/**
 *  记录旧的textView contentSize Heigth
 */
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;
@end
