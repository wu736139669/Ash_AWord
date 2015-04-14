//
//  MessageTableViewCell.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/7.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Text_Voice;

@protocol MessageTableViewCellDelegate<NSObject>
-(void) playWithIndex:(NSInteger)index;
@end

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgressView;
- (IBAction)avatarBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nowTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic)id<MessageTableViewCellDelegate> delegate;
- (IBAction)goodBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
- (IBAction)shareBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
- (IBAction)playBtnClick:(id)sender;

-(void)stopPlay;
-(void)setText_Voice:(Text_Voice*)text_voice;
+(CGFloat)heightWith:(Text_Voice*)text_voice;
@end
