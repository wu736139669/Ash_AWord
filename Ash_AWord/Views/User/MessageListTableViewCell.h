//
//  MessageListTableViewCell.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMConversation;
@class UserInfoViewModel;
@interface MessageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMsgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
-(void)setEMConversation:(EMConversation*)conversation;
-(void)setUserInfo:(UserInfoViewModel*)userInfo;
@end
