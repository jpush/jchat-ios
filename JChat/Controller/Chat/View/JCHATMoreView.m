//
//  JPIMMore.m
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATMoreView.h"
#import "JChatConstants.h"
@implementation JCHATMoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {

}

- (IBAction)photoBtnClick:(id)sender {
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(photoClick)]) {
        [self.delegate photoClick];
    }
}
- (IBAction)cameraBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(cameraClick)]) {
        [self.delegate cameraClick];
    }
}
@end
