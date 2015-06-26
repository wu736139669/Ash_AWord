//
//  CommentTableViewCell.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/2.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>
@class CommentInfoViewModel;

typedef void (^CommentWithUid)(NSString*);
typedef void (^DelCommentSuccess)(void);
@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet DTAttributedTextView *contentTextView;
@property (strong, nonatomic)NSString* ownerId;
@property (strong, nonatomic)CommentWithUid commentWithUid;
@property (strong, nonatomic)DelCommentSuccess delCommentSuccess;

@property (assign, nonatomic)CommentType commentType;
- (IBAction)avatarBtnClick:(id)sender;
-(void)setCommentInfoViewModel:(CommentInfoViewModel*)commentInfoViewModel;
+(CGFloat)getHeightWithCommentInfoViewModel:(CommentInfoViewModel*)commentInfoViewModel isReplyOwner:(BOOL)isReplyOwner;
@end
