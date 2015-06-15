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
   
    if ([commentInfoViewModel.ownerId isEqualToString:_ownerId] ) {
        [self setIsAuthor:YES];
    }else{
        [self setIsAuthor:NO];
    }
    NSString* content = commentInfoViewModel.content;
    if (![commentInfoViewModel.toUserId isEqualToString:_ownerId]){
        content = [CommentTableViewCell getContentWithCommentInfoViewModel:commentInfoViewModel];
    }
    [self setContent:content];
    
    _timeLabel.text = [CommonUtil timeFromtimeSp:commentInfoViewModel.createTime];
}
+(CGFloat)getHeightWithCommentInfoViewModel:(CommentInfoViewModel *)commentInfoViewModel isReplyOwner:(BOOL)isReplyOwner
{
    NSString* content = commentInfoViewModel.content;
    if (!isReplyOwner){
        content = [CommentTableViewCell getContentWithCommentInfoViewModel:commentInfoViewModel];
    }
    CGFloat height = [Ash_UIUtil calculateSizeWithHtmlstring:content limitWidth:kScreenWidth-50 withFontSize:13].height;
    
    return height+50;
}
-(void)setContent:(NSString*)content
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
       NSAttributedString *percentString = [[NSAttributedString alloc] initWithHTMLData:data options:[Ash_UIUtil getHtmlDicWithFontSize:13] documentAttributes:nil];
    _contentTextView.attributedString = percentString;
}
+(NSString*)getContentWithCommentInfoViewModel:(CommentInfoViewModel*)commentInfoViewModel;
{
    NSString* content = commentInfoViewModel.content;
    content = [NSString stringWithFormat:@"<font color=\"lightGray\">回复</font>  <a href=\"%@\">%@</a>:  %@",commentInfoViewModel.toUserId,commentInfoViewModel.toUserName,content];
    
    return content;
}
@end
