//
//  PraiseUserListTableViewCell.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/5.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoViewModel;
@interface PraiseUserListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


-(void)setUserInfoViewModel:(UserInfoViewModel*)userInfoViewModel;
@end
