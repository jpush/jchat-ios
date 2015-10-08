//
//  JCHATImgTableViewCell.h
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATChatModel.h"
#import <JMessage/JMessage.h>

@protocol PictureDelegate <NSObject>
@optional
-(void)tapPicture :(NSIndexPath *)index
          tapView :(UIImageView *)tapView
     tableViewCell:(UITableViewCell *)tableViewCell;

-(void)selectHeadView:(JCHATChatModel *)model;

//- (void)setMessageIDWithMessage:(JMSGMessage *)message
//                      chatModel:(JCHATChatModel * __strong *)chatModel
//                          index:(NSInteger)index;
@end

@interface JCHATImgTableViewCell : UITableViewCell<UIAlertViewDelegate>{
  UIImage *img;
}
@property (strong, nonatomic)  NSIndexPath *cellIndex;
@property (assign, nonatomic)  id <PictureDelegate> delegate;
@property (strong, nonatomic)  UIImageView *contentImgView;
@property (strong, nonatomic)  JCHATChatModel *model;
@property (strong, nonatomic)  UILabel *percentLabel;
@property (strong, nonatomic)  UIImageView *headView;
@property (nonatomic,strong)   UIActivityIndicatorView *circleView;
@property (strong, nonatomic)  UIImageView *pictureImgView;
@property (nonatomic,strong)   UIImageView *sendFailView;
@property (nonatomic,strong)   JMSGImageMessage *sendFailImgMessage;
@property (nonatomic,strong)   JMSGConversation *conversation;
@property (nonatomic,strong)   UIActivityIndicatorView *downLoadIndicatorView;
@property (strong, nonatomic)  JMSGImageMessage *message;
-(void)sendImageMessage;
-(void)initAutoLayout;
-(void)setCellData :(UIViewController *)controler
         chatModel :(JCHATChatModel *)chatModel
            message:(JMSGImageMessage *)message
         indexPath :(NSIndexPath *)indexPath;


@end
