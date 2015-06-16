//
//  CommentTableViewCell.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/2.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentViewModel.h"
#import "PersonalInfoViewController.h"
#import "AppDelegate.h"
@interface CommentInfoViewModel()<DTAttributedTextContentViewDelegate>
@end
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
    
    _contentTextView.textDelegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_contentTextView addGestureRecognizer:tap];
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
- (IBAction)avatarBtnClick:(id)sender {
    PersonalInfoViewController* personalInfoViewController = [[PersonalInfoViewController alloc] init];
    personalInfoViewController.hidesBottomBarWhenPushed = YES;
    personalInfoViewController.otherUserId = _commentInfoViewModel.ownerId;
    [[AppDelegate visibleViewController].navigationController pushViewController:personalInfoViewController animated:YES];
}

-(void)setCommentInfoViewModel:(CommentInfoViewModel *)commentInfoViewModel
{
    _commentInfoViewModel = commentInfoViewModel;
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
    CGFloat height = [Ash_UIUtil calculateSizeWithHtmlstring:content limitWidth:kScreenWidth-55 withFontSize:13].height;
    
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

#pragma mark  DTAttributedTextContentViewDelegate
- (void)linkPushed:(DTLinkButton *)button
{
    DLog(@"%@",button.URL);
    if(button.URL)
    {
        PersonalInfoViewController* personalInfoViewController = [[PersonalInfoViewController alloc] init];
        personalInfoViewController.hidesBottomBarWhenPushed = YES;
        personalInfoViewController.otherUserId = button.URL.absoluteString;
        [[AppDelegate visibleViewController].navigationController pushViewController:personalInfoViewController animated:YES];
    }
}
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame
{
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    button.URL = url;
    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        if (_commentWithUid) {
            _commentWithUid(_commentInfoViewModel.ownerId);
        }
    }
}

@end
