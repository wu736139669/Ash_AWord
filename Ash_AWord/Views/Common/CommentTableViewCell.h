//
//  CommentTableViewCell.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/2.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentInfoViewModel;
@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

-(void)setCommentInfoViewModel:(CommentInfoViewModel*)commentInfoViewModel;
-(void)setIsAuthor:(BOOL)isAuthor;
+(CGFloat)getHeightWithCommentInfoViewModel:(CommentInfoViewModel*)commentInfoViewModel;
@end
