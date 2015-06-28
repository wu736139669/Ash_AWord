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
#import "ReportViewController.h"
@interface CommentInfoViewModel()<DTAttributedTextContentViewDelegate,UIAlertViewDelegate>
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
    
    _isNewLabel.layer.masksToBounds = YES;
    _isNewLabel.layer.cornerRadius = 5.0;
    
    _isNewView.hidden = YES;
    _isNewView.layer.cornerRadius = 5.0;
    _isNewView.backgroundColor = [UIColor appMainColor];
    _isNewView.layer.masksToBounds = YES;
    _isNewView.image = nil;
    
    _isAllowReport = YES;
    _contentTextView.textDelegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_contentTextView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longPressGr];
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
    if (commentInfoViewModel.status == 0) {
        _isNewView.hidden = NO;
    }else{
        _isNewView.hidden = YES;
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

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        
        //启动弹出菜单
        NSMutableArray *menuItems = [NSMutableArray array];

        
        if (_isAllowReport) {
            UIMenuItem *messageRepItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(messageRep:)];
            [menuItems addObject:messageRepItem];
            if ([_commentInfoViewModel.ownerId isEqualToString:[AWordUser sharedInstance].uid]) {
                UIMenuItem *messageDelItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(messageDel:)];
                [menuItems addObject:messageDelItem];
            }
        }
        UIMenuItem *messageCopyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(messageCopy:)];
        [menuItems addObject:messageCopyItem];
        

        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:menuItems];
        [self becomeFirstResponder];
        CGRect targetRect = self.frame;

        [menu setTargetRect:targetRect inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}
-(void)messageCopy:(id)sender{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _commentInfoViewModel.content;
}
-(void)messageDel:(id)sender{
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确认删除" message:@"是否删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag = 0;
    [alertView show];
}
-(void)messageRep:(id)sender {
//    UIMenuController *menu = [UIMenuController sharedMenuController];
//    [menu setMenuVisible:NO animated:YES];
    
    ReportViewController* reportViewController = [[ReportViewController alloc] init];
    reportViewController.authorName = _commentInfoViewModel.ownerName;
    reportViewController.msgId = _commentInfoViewModel.commentId.integerValue;
    if (_commentType == Image_Type) {
        reportViewController.msgType = Report_Note_Img_Type;
    }else{
        reportViewController.msgType = Report_Message_Voice_Type;
    }
    reportViewController.hidesBottomBarWhenPushed = YES;
    [[AppDelegate visibleViewController].navigationController pushViewController:reportViewController animated:YES];
    
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (  action == @selector(messageRep:) || action== @selector(messageCopy:)|| action== @selector(messageDel:)) {
        return YES;
    }
    
    return NO;
}
-(BOOL) canBecomeFirstResponder{
    return YES;
}

#pragma mark --UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //删除
    if (buttonIndex == 1) {
        PropertyEntity* pro = [CommentViewModel requireDelCommentWithCommentId:_commentInfoViewModel.commentId.integerValue];
        [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
            if ([viewModel success]) {
                if (_delCommentSuccess) {
                    _delCommentSuccess();
                }
            }else{
                [MBProgressHUD errorHudWithView:nil label:[viewModel errMessage] hidesAfter:1.0];
            }
        } failedBlock:nil];
    }
}


@end
