//
//  JCHATMessageTextView.m
//  JPush IM
//
//  Created by Apple on 15/1/14.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATMessageTextView.h"
#import "JChatConstants.h"

@implementation JCHATMessageTextView
#pragma mark - Setters

- (void)setPlaceHolder:(NSString *)placeHolder {
  if([placeHolder isEqualToString:_placeHolder]) {
    return;
  }
  
  NSUInteger maxChars = [JCHATMessageTextView maxCharactersPerLine];
  if([placeHolder length] > maxChars) {
    placeHolder = [placeHolder substringToIndex:maxChars - 8];
    placeHolder = [[placeHolder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@"..."];
  }
  
  _placeHolder = placeHolder;
  [self setNeedsDisplay];
}

//"反馈"关心的功能
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
  return (action == @selector(paste:));
}

- (void)paste:(id)sender {
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  NSTextAttachment *textAttachment = [NSTextAttachment new];
  if (pasteboard.string != nil) {
    [super paste:sender];
    return;
  }
  if (pasteboard.image != nil) {
    textAttachment.image = pasteboard.image;
    NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [[JCHATAlertToSendImage shareInstance] showInViewWith:pasteboard.image];
  }
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
  if([placeHolderTextColor isEqual:_placeHolderTextColor]) {
    return;
  }
  
  _placeHolderTextColor = placeHolderTextColor;
  [self setNeedsDisplay];
}

#pragma mark - Message text view

- (NSUInteger)numberOfLinesOfText {
  return [JCHATMessageTextView numberOfLinesForMessage:self.text];
}

+ (NSUInteger)maxCharactersPerLine {
  return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text {
  return (text.length / [JCHATMessageTextView maxCharactersPerLine]) + 1;
}

#pragma mark - Text view overrides

- (void)setText:(NSString *)text {
  [super setText:text];
  [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
  [super setAttributedText:attributedText];
  [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
  [super setContentInset:contentInset];
  [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
  JCHATMAINTHREAD(^{
    [super setFont:font];
    [self setNeedsDisplay];
  });
  
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
  [super setTextAlignment:textAlignment];
  [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
  [self setNeedsDisplay];
}

#pragma mark - Life cycle

- (void)setup {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didReceiveTextDidChangeNotification:)
                                               name:UITextViewTextDidChangeNotification
                                             object:self];
  
  _placeHolderTextColor = [UIColor lightGrayColor];
  
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
  self.contentInset = UIEdgeInsetsZero;
  self.scrollEnabled = YES;
  self.scrollsToTop = NO;
  self.userInteractionEnabled = YES;
  self.font = [UIFont systemFontOfSize:16.0f];
  self.textColor = [UIColor blackColor];
  self.backgroundColor = [UIColor whiteColor];
  self.keyboardAppearance = UIKeyboardAppearanceDefault;
  self.keyboardType = UIKeyboardTypeDefault;
  self.returnKeyType = UIReturnKeyDefault;
  self.textAlignment = NSTextAlignmentLeft;
  self.layer.cornerRadius = 6;
  [self.layer setMasksToBounds:YES];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setup];
  }
  return self;
}

- (void)dealloc {
  _placeHolder = nil;
  _placeHolderTextColor = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
  if([self.text length] == 0 && self.placeHolder) {
    CGRect placeHolderRect = CGRectMake(10.0f,
                                        7.0f,
                                        rect.size.width,
                                        rect.size.height);
    
    [self.placeHolderTextColor set];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0) {
      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
      paragraphStyle.alignment = self.textAlignment;
      
      [self.placeHolder drawInRect:placeHolderRect
                    withAttributes:@{ NSFontAttributeName : self.font,
                                      NSForegroundColorAttributeName : self.placeHolderTextColor,
                                      NSParagraphStyleAttributeName : paragraphStyle }];
    }
    else {
      NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
      paragraphStyle.alignment = self.textAlignment;
      [self.placeHolder drawInRect:placeHolderRect withAttributes:@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraphStyle}];
    }
  }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
