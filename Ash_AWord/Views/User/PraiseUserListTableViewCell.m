//
//  PraiseUserListTableViewCell.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/5.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "PraiseUserListTableViewCell.h"
#import "UserViewModel.h"
@implementation PraiseUserListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUserInfoViewModel:(UserInfoViewModel *)userInfoViewModel
{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfoViewModel.figureurl] placeholderImage:DefaultUserIcon];
    _nameLabel.text = userInfoViewModel.name;
}
@end
