//
//  CommentTableViewCell.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/2.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentViewModel.h"
@implementation CommentTableViewCell
{
    CommentInfoViewModel* _commentInfoViewModel;
}
- (void)awakeFromNib {
    // Initialization code
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = 18.0;
    _contentTextView.scrollEnabled = NO;
    
    _floorLabel.layer.masksToBounds = YES;
    _floorLabel.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsAuthor:(BOOL)isAuthor
{
    if (isAuthor) {
        _floorLabel.hidden = NO;
    }else{
        _floorLabel.hidden = YES;
    }
}
-(void)setCommentInfoViewModel:(CommentInfoViewModel *)commentInfoViewModel
{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:commentInfoViewModel.ownerFigureurl] placeholderImage:DefaultUserIcon];
    _nameLabel.text = commentInfoViewModel.ownerName;
    _contentTextView.text = commentInfoViewModel.content;
    _timeLabel.text = [CommonUtil timeFromtimeSp:commentInfoViewModel.createTime];
}
+(CGFloat)getHeightWithCommentInfoViewModel:(CommentInfoViewModel *)commentInfoViewModel
{
    UIFont *font = [UIFont appFontOfSize:13.0];
    CGSize size = CGSizeMake(kScreenWidth - 60,MAXFLOAT);
    
    
    CGRect labelRect = [commentInfoViewModel.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return labelRect.size.height+60;
}
@end
