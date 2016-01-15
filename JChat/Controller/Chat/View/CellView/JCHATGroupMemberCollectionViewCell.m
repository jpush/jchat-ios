//
//  JCHATGroupMemberCollectionViewCell.m
//  JChat
//
//  Created by HuminiOS on 15/11/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATGroupMemberCollectionViewCell.h"

@interface JCHATGroupMemberCollectionViewCell()
{
  __weak IBOutlet UIImageView *_AvatarImgView;
  __weak IBOutlet UILabel *_userNameLabel;
  __weak IBOutlet UIButton *_deleteMemberBtn;
}

@end

@implementation JCHATGroupMemberCollectionViewCell

- (void)awakeFromNib {
  _AvatarImgView.layer.masksToBounds = YES;
  _deleteMemberBtn.layer.masksToBounds = YES;
  _AvatarImgView.layer.cornerRadius = _AvatarImgView.bounds.size.height/2;
  _AvatarImgView.contentMode = UIViewContentModeScaleAspectFill;
  _deleteMemberBtn.layer.cornerRadius = 10;
  
}

- (void)setDataWithUser:(JMSGUser *)user withEditStatus:(BOOL)isInEdit {
  _userNameLabel.text = user.displayName;
  _deleteMemberBtn.hidden = !isInEdit;//rename isDeleting

  [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
    if (error == nil) {
      if (data != nil) {
        _AvatarImgView.image = [UIImage imageWithData:data];
      } else {
        _AvatarImgView.image = [UIImage imageNamed:@"headDefalt"];
      }
    } else {
      _AvatarImgView.image = [UIImage imageNamed:@"headDefalt"];
    }
  }];
}

- (void)setDeleteMember {
  _userNameLabel.text = @"";
  _deleteMemberBtn.hidden = YES;
  _AvatarImgView.image = [UIImage imageNamed:@"deleteMan"];
}

- (void)setAddMember {
  _userNameLabel.text = @"";
  _deleteMemberBtn.hidden = YES;
  _AvatarImgView.image = [UIImage imageNamed:@"addMan"];
}
@end
