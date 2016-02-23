//
//  JCHATToolBar.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATToolBar.h"
#import "JChatConstants.h"
#import "JCHATRecordAnimationView.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+MessageInputView.h"
#import "JCHATFileManager.h"
#import "Masonry.h"
#import "JCHATAudioPlayerHelper.h"


@implementation JCHATToolBar

- (instancetype)init
{
  self = [super init];
  if (self) {
    
  }
  return self;
}


#pragma mark---加载子view
- (void)loadSubView
{
  //录音按钮
}

- (IBAction)addBtnClick:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(noPressmoreBtnClick:)]) {
    if (self.addButton.selected) {
      self.addButton.selected = NO;
      [self.delegate noPressmoreBtnClick:sender];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(pressMoreBtnClick:)]){
      [self.delegate pressMoreBtnClick:sender];
      self.addButton.selected=YES;
    }
  }
}

- (IBAction)voiceBtnClick:(id)sender {
  [self switchInputMode];
}

- (void)switchInputMode {
  if (self.voiceButton.selected == NO) {
  _textViewHeight.constant = 36;
    [self switchToVoiceInputMode];
  } else {
    [self switchToTextInputMode];
  }
}

- (void)switchToVoiceInputMode {
  self.voiceButton.selected = YES;
  [self.voiceButton setImage:[UIImage imageNamed:@"keyboard_toolbar"] forState:UIControlStateNormal];
  [self.voiceButton setImage:[UIImage imageNamed:@"keyboard_toolbar_pre"] forState:UIControlStateHighlighted];

  [self.textView setHidden:YES];
  [self.startRecordButton setHidden:NO];
  if (self.delegate && [self.delegate respondsToSelector:@selector(pressVoiceBtnToHideKeyBoard)]) {
    [self.delegate pressVoiceBtnToHideKeyBoard];
  }
}

- (void)switchToTextInputMode {
  [self switchToolbarToTextMode];
  JPIMLog(@"startRecordButton is :%@",self.startRecordButton);
  if (self.delegate && [self.delegate respondsToSelector:@selector(switchToTextInputMode)]) {
    [self.delegate switchToTextInputMode];
  }
}

- (void)switchToolbarToTextMode {
  self.voiceButton.selected=NO;
  self.voiceButton.contentMode = UIViewContentModeCenter;
  [self.voiceButton setImage:[UIImage imageNamed:@"voice_toolbar"] forState:UIControlStateNormal];
  [self.voiceButton setImage:[UIImage imageNamed:@"voice_toolbar_pre"] forState:UIControlStateHighlighted];
  [self.startRecordButton setHidden:YES];
  [self.textView setHidden:NO];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (self.voiceButton.selected == NO) {
    [self.voiceButton setImage:[UIImage imageNamed:@"voice_toolbar"] forState:UIControlStateNormal];
    [self.voiceButton setImage:[UIImage imageNamed:@"voice_toolbar_pre"] forState:UIControlStateHighlighted];
  } else{
    [self.voiceButton setImage:[UIImage imageNamed:@"keyboard_toolbar"] forState:UIControlStateNormal];
    [self.voiceButton setImage:[UIImage imageNamed:@"keyboard_toolbar_pre"] forState:UIControlStateHighlighted];
  }
  [self setBackgroundColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1]];
}

- (void)drawRect:(CGRect)rect {
  if (self.startRecordButton){
    [self.startRecordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
      
    }];
    
    [self.startRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self).with.offset(5);
      make.bottom.mas_equalTo(self).with.offset(-4);
      make.left.mas_equalTo(self.voiceButton.mas_right).with.offset(5);
      make.right.mas_equalTo(self.addButton.mas_left).with.offset(-5);
    }];
    return;
  }
  self.voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
  [self.voiceButton setImage:[UIImage imageNamed:@"voice_toolbar"] forState:UIControlStateNormal];
  self.textView.delegate = self;
  
  self.textView.returnKeyType = UIReturnKeySend;
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
  [self addGestureRecognizer:gesture];
  [self setFrame:CGRectMake(0, kApplicationHeight + kStatusBarHeight - 45, self.bounds.size.width, 45)];
  
  //    self.startRecordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.startRecordButton = [UIButton new];
  
  [self.startRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.startRecordButton setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
  [self.startRecordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
  [self.startRecordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
  self.startRecordButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
  [self.startRecordButton setBackgroundColor:UIColorFromRGB(0x3f80dc)];
  [self.startRecordButton addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
  [self.startRecordButton addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
  [self.startRecordButton addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
  [self.startRecordButton addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
  [self.startRecordButton addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
  [self.startRecordButton setHidden:YES];
  [self addSubview:self.startRecordButton];
  
  UIWindow *window =(UIWindow *)[UIApplication sharedApplication].keyWindow;
  self.recordAnimationView=[[JCHATRecordAnimationView alloc]initWithFrame:CGRectMake((kApplicationWidth-140)/2, (kScreenHeight -kNavigationBarHeight - kTabBarHeight - 140)/2, 140, 140)];
  [window addSubview:self.recordAnimationView];
}

- (void)holdDownButtonTouchDown {
  if ([self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction)]) {
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    [self.delegate didStartRecordingVoiceAction];
  }
}

- (void)holdDownButtonTouchUpOutside {
  if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
    [self.delegate didCancelRecordingVoiceAction];
  }
}

- (void)holdDownButtonTouchUpInside {
  if ([self.delegate respondsToSelector:@selector(didFinishRecordingVoiceAction)]) {
    [self.delegate didFinishRecordingVoiceAction];
  }
}

- (void)holdDownDragOutside {
  if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
    [self.delegate didDragOutsideAction];
  }
}

- (void)holdDownDragInside {
  if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
    [self.delegate didDragInsideAction];
  }
}

- (void)levelMeterChanged:(float)levelMeter{
  [self.recordAnimationView changeanimation:levelMeter];
}

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
  // 动态改变自身的高度和输入框的高度
  CGRect prevFrame = self.textView.frame;
  
  NSUInteger numLines = MAX([self.textView numberOfLinesOfText],
                            [self.textView.text numberOfLines]);
  
  if ([_textView.text isEqualToString: @""]) {
    return;
  }
  
  CGSize textSize = [JCHATStringUtils stringSizeWithWidthString:_textView.text withWidthLimit:_textView.frame.size.width withFont:[UIFont systemFontOfSize:st_toolBarTextSize]];
  CGFloat textViewHeight = textSize.height + 30;
  _textViewHeight.constant = textViewHeight>36?textViewHeight:36;
  self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                0.0f,
                                                (numLines >= 6 ? 4.0f : 0.0f),
                                                0.0f);
  // from iOS 7, the content size will be accurate only if the scrolling is enabled.
  self.textView.scrollEnabled = YES;
  if (numLines >= 6) {
    CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
    [self.textView setContentOffset:bottomOffset animated:YES];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 2, 1)];
  }
}

#pragma mark --判断能否录音
- (BOOL)canRecord
{
  __block BOOL bCanRecord = YES;
  if (kIOSVersions >= 7.0)
  {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
      [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
        if (granted) {
          bCanRecord = YES;
        }
        else {
          bCanRecord = NO;
          dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"无法录音"
                                        message:@"请在“设置-隐私-麦克风”选项中，允许jpushIM访问你的手机麦克风。"
                                       delegate:nil
                              cancelButtonTitle:@"关闭"
                              otherButtonTitles:nil]  show];
          });
        }
      }];
    }
  } else{
    bCanRecord = YES;
  }
  return bCanRecord;
}

- (void)tapClick:(UIGestureRecognizer *)gesture
{
  [self.textView resignFirstResponder];
}

#pragma mark -
#pragma mark RecordingDelegate
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval
{
  JPIMLog(@"录音完成，文件路径:%@",filePath);
  if (interval < 0.50) {
    [JCHATFileManager deleteFile:filePath];
    return;
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    NSRange range = [filePath rangeOfString:@"spx"];
    if (range.length > 0) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(playVoice:time:)]) {
        [self.delegate playVoice:filePath time:[NSString stringWithFormat:@"%.f",ceilf(interval)]];
      }
    }
  });
}

- (void)recordingTimeout
{
  [self.recordAnimationView stopAnimation];
  self.isRecording = NO;
}

- (void)recordingStopped //录音机停止采集声音
{
  self.isRecording = NO;
  
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"]) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendText:)]) {
      [self.delegate sendText:textView.text];
    }
    textView.text=@"";
    return NO;
  }
  return YES;
}

#pragma mark - Text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
    [self.delegate inputTextViewWillBeginEditing:self.textView];
  }
  return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  [textView becomeFirstResponder];
  if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
    [self.delegate inputTextViewDidBeginEditing:self.textView];
  }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([self.delegate respondsToSelector:@selector(inputTextViewDidEndEditing:)]) {
    [self.delegate inputTextViewDidEndEditing:self.textView];
  }
}

- (void)textViewDidChange:(UITextView *)textView {
  if ([self.delegate respondsToSelector:@selector(inputTextViewDidChange:)]) {
    [self.delegate inputTextViewDidChange:self.textView];
  }
}

+ (CGFloat)textViewLineHeight {
  return st_toolBarTextSize * [UIScreen mainScreen].scale; // for fontSize 16.0f
}

+ (CGFloat)maxLines {
  return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)maxHeight {
  return ([JCHATToolBar maxLines] + 1.0f) * [JCHATToolBar textViewLineHeight];
}

- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
  _textView = nil;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

@end


@implementation JCHATToolBarContainer

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  _toolbar = NIB(JCHATToolBar);
  [self performSelector:@selector(addtoolbar) withObject:nil afterDelay:0.02];
}
- (void)addtoolbar {
  self.toolbar.frame = CGRectMake(0, 0, kApplicationWidth, 45);
  [self addSubview:_toolbar];
}

@end
