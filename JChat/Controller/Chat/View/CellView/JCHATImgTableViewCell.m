//
//  JCHATImgTableViewCell.m
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATImgTableViewCell.h"
#import "JCHATChatModel.h"
#import "JChatConstants.h"
#import "JCHATFileManager.h"
#import <JMessage/JMessage.h>
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#define headHeight 46

@implementation JCHATImgTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.headView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headHeight, headHeight)];
        [self.headView setImage:[UIImage imageNamed:@"headDefalt_34.png"]];
        [self addSubview:self.headView];
        self.headView.layer.cornerRadius = 23;
        [self.headView.layer setMasksToBounds:YES];
        
        self.pictureImgView = [[UIImageView alloc]init];
        [self addSubview:self.pictureImgView];
        self.pictureImgView.layer.cornerRadius=6;
        [self.pictureImgView.layer setMasksToBounds:YES];
        [self setUserInteractionEnabled:YES];
        [self.pictureImgView setUserInteractionEnabled:YES];
        UIImage *img=nil;
        img =[UIImage imageNamed:@"mychatBg"];
        UIImage *newImg =[img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];
        [self.pictureImgView setImage:newImg];
        [self.pictureImgView setBackgroundColor:[UIColor clearColor]];
        
        self.contentImgView  =[[UIImageView alloc] init];
        [self.contentImgView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
        [self.contentImgView addGestureRecognizer:gesture];
        [self.contentImgView setFrame:CGRectMake(5, 5, self.pictureImgView.bounds.size.width-2*8-2, self.pictureImgView.bounds.size.height)];
        
        self.percentLabel =[[UILabel alloc]init];
        self.percentLabel.font =[UIFont systemFontOfSize:18];
        self.percentLabel.textAlignment=NSTextAlignmentCenter;
        self.percentLabel.textColor=[UIColor whiteColor];
        [self.percentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentImgView addSubview:self.percentLabel];
        [self.pictureImgView addSubview:self.contentImgView];
        
        self.circleView =[[UIActivityIndicatorView alloc] init];
        [self addSubview:self.circleView];
        [self.circleView setBackgroundColor:[UIColor clearColor]];
        [self.circleView setHidden:NO];
        self.circleView.hidesWhenStopped=YES;
        
        self.downLoadIndicatorView =[[UIActivityIndicatorView alloc] init];
        [self.contentImgView addSubview:self.downLoadIndicatorView];
        [self.downLoadIndicatorView setBackgroundColor:[UIColor clearColor]];
        [self.downLoadIndicatorView setHidden:NO];
        self.downLoadIndicatorView.hidesWhenStopped=YES;
        
        self.sendFailView =[[UIImageView alloc] init];
        [self.sendFailView setUserInteractionEnabled:YES];
        [self.sendFailView setImage:[UIImage imageNamed:@"fail05"]];
        [self addSubview:self.sendFailView];
        [self headAddGesture];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageResponse:) name:JMSGSendMessageResult object:nil];
    }
    return self;
}

#pragma mark --发送消息响应
- (void)sendMessageResponse:(NSNotification *)response {
    JPIMMAINTHEAD(^{
        NSDictionary *responseDic = [response userInfo];
        NSError *error = [responseDic objectForKey:JMSGSendMessageError];
        JMSGImageMessage *message = [responseDic objectForKey:JMSGSendMessageObject];
        if (error == nil) {
            JPIMLog(@"Sent voiceMessage Response:%@",message);
        }else {
            JPIMLog(@"Sent voiceMessage Response:%@",message);
            JPIMLog(@"Sent voiceMessage Response error:%@",error);
        }
        if (![message.messageId isEqualToString:_message.messageId]) {
            return ;
        }
        [self.circleView stopAnimating];
        self.contentImgView.alpha = 1;
        if (error == nil) {
            self.model.messageStatus = kSendSucceed;
            [self.sendFailView setHidden:YES];
            [self.circleView stopAnimating];
            [self.circleView setHidden:YES];
        }else {
            self.model.messageStatus = kSendFail;
            [self.sendFailView setHidden:NO];
            [self.circleView stopAnimating];
            [self.circleView setHidden:YES];
            _sendFailImgMessage = message;
        }
        [self updateFrame];
    });
}

- (void)headAddGesture {
    [self.headView setUserInteractionEnabled:YES];
    [self.contentImgView setUserInteractionEnabled:YES];
    [self.pictureImgView setUserInteractionEnabled:YES];

    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPersonInfoCtlClick)];
    [self.headView addGestureRecognizer:gesture];
    UITapGestureRecognizer *messageFailGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSendMessage)];
    [self.sendFailView addGestureRecognizer:messageFailGesture];
}

- (void)reSendMessage {
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:nil message:@"是否重新发送消息"
                                                     delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.sendFailView setHidden:YES];
        [self.circleView setHidden:NO];
        [self.circleView startAnimating];
        self.contentImgView.alpha = 0.5;
        self.model.messageStatus = kSending;
        __weak typeof(self)weakSelf = self;
        if (!self.sendFailImgMessage) {
            [self.conversation getMessage:self.model.messageId completionHandler:^(id resultObject, NSError *error) {
                if (error == nil) {
                    weakSelf.sendFailImgMessage = resultObject;
                    weakSelf.message = resultObject;
                    weakSelf.sendFailImgMessage.progressCallback=^(float percent){
                    weakSelf.percentLabel.text=[NSString stringWithFormat:@"%d%%",(int)percent*100];
                    };
                    [JMSGMessage sendMessage:self.sendFailImgMessage];
                }else {
                    NSLog(@"获取消息失败!");
                }
            }];
        }else {
            self.sendFailImgMessage.progressCallback=^(float percent){
                weakSelf.percentLabel.text=[NSString stringWithFormat:@"%d%%",(int)percent*100];
            };
            [JMSGMessage sendMessage:self.sendFailImgMessage];
        }
    }
}

- (void)pushPersonInfoCtlClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeadView:)]) {
        [self.delegate selectHeadView:self.model];
    }
}

- (void)setCellData :(UIViewController *)controler chatModel :(JCHATChatModel *)chatModel indexPath :(NSIndexPath *)indexPath
{
    self.conversation = chatModel.conversation;
    self.model = chatModel;
     [self.circleView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    if (self.model.messageStatus == kReceiveDownloadFailed) {
        [self.contentImgView setImage:[UIImage imageNamed:@"receiveFailed.png"]];
    } else {
        [self.contentImgView setImage:[UIImage imageWithContentsOfFile:self.model.pictureThumbImgPath]];
    }
    self.delegate = (id)controler;
    self.cellIndex = indexPath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:chatModel.avatar]) {
       [self.headView setImage:[UIImage imageWithContentsOfFile:chatModel.avatar]];
    }else {
      [self.headView setImage:[UIImage imageNamed:@"headDefalt_34"]];
    }
    [self updateFrame];
    if (!_model.sendFlag) {
        _model.sendFlag = YES;
        [self uploadPicturePhoto];
    }
}

#pragma mark --上传图片
- (void)uploadPicturePhoto
{
    JPIMLog(@"Action");
    [self.circleView setHidden:NO];
    [self.circleView startAnimating];
    self.contentImgView.alpha=0.5;
    self.model.messageStatus = kSending;
    _message =[[JMSGImageMessage alloc] init];
    _message.target_name=self.model.targetName;
    _message.timestamp = self.model.messageTime;
    __weak typeof(self)weakSelf = self;
    _message.progressCallback=^(float percent){
        weakSelf.percentLabel.text=[NSString stringWithFormat:@"%d%%",(int)percent*100];
    };
    _message.resourcePath = self.model.pictureImgPath;
    _message.thumbPath = self.model.pictureThumbImgPath;
    [JMSGMessage sendMessage:_message];
    JPIMLog(@"sendt imgMessage:%@",_message);
}

- (void)tapPicture:(UIGestureRecognizer *)gesture
{
    if (self.model.messageStatus == kReceiveDownloadFailed) {
        NSLog(@"正在下载缩略图");
        JPIMLog(@"Action");
        [self.downLoadIndicatorView setHidden:NO];
        [self.downLoadIndicatorView startAnimating];
        [self.conversation getMessage:self.model.messageId completionHandler:^(id resultObject, NSError *error) {
            if (error == nil) {
                NSProgress *progress = [NSProgress progressWithTotalUnitCount:1000];
                [JMSGMessage getThumbImageFromMessage:resultObject withProgress:progress completionHandler:^(id resultObject, NSError *error) {
                    JPIMMAINTHEAD(^{
                        [self.downLoadIndicatorView stopAnimating];
                        if (error == nil) {
                            self.model.pictureThumbImgPath = [(NSURL *)resultObject path];
                            self.model.messageStatus = kReceiveSucceed;
                            [self.contentImgView setImage:[UIImage imageWithContentsOfFile:[(NSURL *)resultObject path]]];
                            [self updateFrame];
                            JPIMLog(@"下载缩略图成功 :%@",[(NSURL *)resultObject path]);
                        }else {
                            JPIMLog(@"下载缩略图失败");
                            [MBProgressHUD showMessage:@"下载缩略图失败" view:self];
                        }
                    });
                }];
            }else {
                JPIMLog(@"下载缩略图获取消息失败。。。");
                JPIMMAINTHEAD(^{
                    [MBProgressHUD showMessage:@"下载缩略图失败" view:self];
                });
            }
        }];
        //下载缩略图
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapPicture:tapView:tableViewCell:)]) {
            [self.delegate tapPicture:self.cellIndex tapView:(UIImageView *)gesture.view tableViewCell:self];
        }
    }
}

- (void)layoutSubviews
{
    [self updateFrame];
}

- (void)updateFrame
{
    NSInteger imgHeight;
    NSInteger imgWidth;
    [self.percentLabel setHidden:NO];
    if (self.model.messageStatus == kReceiveDownloadFailed) {
        imgHeight = 200;
        imgWidth  = 150;
        [self.downLoadIndicatorView setCenter:CGPointMake(self.contentImgView.frame.size.width/2, self.contentImgView.frame.size.height/2)];
    }else {
        [self.downLoadIndicatorView setHidden:YES];
        UIImage *showImg = [UIImage imageWithContentsOfFile:self.model.pictureThumbImgPath];
        if (kScreenWidth > 320 ) {
            imgHeight = showImg.size.height/3;
            imgWidth  = showImg.size.width/3;
        }else {
            imgHeight = showImg.size.height/2;
            imgWidth  = showImg.size.width/2;
        }
    }
    if (self.model.messageStatus == kSending || self.model.messageStatus == kReceiving) {
        [self.circleView setHidden:NO];
        [self.sendFailView setHidden:YES];
    }else if (self.model.messageStatus == kSendSucceed || self.model.messageStatus == kReceiveSucceed)
    {
        [self.circleView setHidden:YES];
        [self.sendFailView setHidden:YES];
        [self.percentLabel setHidden:YES];
    }else if (self.model.messageStatus == kSendFail || self.model.messageStatus == kReceiveDownloadFailed)
    {
        [self.circleView setHidden:YES];
        [self.sendFailView setHidden:NO];
    }else {
        [self.circleView setHidden:YES];
        [self.sendFailView setHidden:YES];
    }
    UIImage *img=nil;
    if (self.model.who) {
        img =[UIImage imageNamed:@"mychatBg"];
        [self.pictureImgView setFrame:CGRectMake(kApplicationWidth - headHeight - 5 - imgWidth, 0, imgWidth, imgHeight)];
        [self.contentImgView setFrame:CGRectMake(5, 5, self.pictureImgView.bounds.size.width-2*8-2, self.pictureImgView.bounds.size.height-10)];
        [self.headView setFrame:CGRectMake(kApplicationWidth - headHeight - 5, 0, headHeight, headHeight)];
        [self.circleView setFrame:CGRectMake(self.pictureImgView.frame.origin.x-25, 40, 20, 20)];
        [self.sendFailView setFrame:CGRectMake(self.pictureImgView.frame.origin.x-25, 42.5, 17, 15)];
    }else{
        img =[UIImage imageNamed:@"otherChatBg"];
        [self.pictureImgView setFrame:CGRectMake(headHeight + 5, 0, imgWidth, imgHeight)];
        [self.contentImgView setFrame:CGRectMake(12, 5, self.pictureImgView.bounds.size.width - 2 * 8 - 2, self.pictureImgView.bounds.size.height-10)];
        [self.headView setFrame:CGRectMake(5, 0, headHeight, headHeight)];
        [self.circleView setFrame:CGRectMake(self.pictureImgView.frame.origin.x + 5, 40, 20, 20)];
        [self.sendFailView setFrame:CGRectMake(self.pictureImgView.frame.origin.x + 5, 42.5, 17, 15)];
    }
    [self.percentLabel setFrame:CGRectMake(0, 0, 50, 50)];
    [self.percentLabel setCenter:CGPointMake(self.contentImgView.frame.size.width/2, self.contentImgView.frame.size.height/2)];
    UIImage *newImg =[img resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 28, 20)];
    [self.pictureImgView setImage:newImg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
