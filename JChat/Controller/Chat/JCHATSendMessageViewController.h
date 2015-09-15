//
//  JCHATSendMessageViewController.h
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATToolBar.h"
#import "JCHATMoreView.h"
#import "JCHATRecordAnimationView.h"
#import "JCHATImgTableViewCell.h"
#import "JCHATChatModel.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
//#import "JCHATVoiceTableViewCell.h"
#import "JCHATVoiceTableCell.h"
#import <JMessage/JMessage.h>


@interface JCHATSendMessageViewController : UIViewController <
    UITableViewDataSource,
    UITableViewDelegate,
    SendMessageDelegate,
    AddBtnDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    PictureDelegate,
    playVoiceDelegate,
    UIGestureRecognizerDelegate,
    UIAlertViewDelegate,
    JMessageDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgTableBottomToToolBar;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (weak, nonatomic) IBOutlet JCHATToolBarContainer *toolBarContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarToBottomConstrait;
@property (weak, nonatomic) IBOutlet JCHATMoreViewContainer *moreViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreViewHeight;
@property(nonatomic, assign) JPIMInputViewType textViewInputViewType;
@property(assign, nonatomic) BOOL barBottomFlag;
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
@property(nonatomic, strong, readwrite) JCHATVoiceTableCell *saveVoiceCell;
@property(strong, nonatomic) JMSGConversation *conversation;
@property(strong, nonatomic) NSString *targetName;
@property(strong, nonatomic) JMSGUser *user;
@property(strong, nonatomic) JMSGGroup *groupInfo;

/**
*  管理录音工具对象
*/
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;

/**
*  记录旧的textView contentSize Heigth
*/
@property(nonatomic, assign) CGFloat previousTextViewContentHeight;

@end
