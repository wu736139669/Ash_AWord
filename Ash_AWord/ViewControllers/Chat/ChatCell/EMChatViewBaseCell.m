/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "EMChatViewBaseCell.h"
//#import "UIImageView+EMWebCache.h"
#import "ReportViewController.h"
#import "AppDelegate.h"

NSString *const kRouterEventChatHeadImageTapEventName = @"kRouterEventChatHeadImageTapEventName";

@interface EMChatViewBaseCell()

@end

@implementation EMChatViewBaseCell

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImagePressed:)];
        
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPressGr];
        
        CGFloat originX = HEAD_PADDING;
        if (model.isSender) {
            originX = self.bounds.size.width - HEAD_SIZE - HEAD_PADDING;
        }
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, CELLPADDING, HEAD_SIZE, HEAD_SIZE)];
        [_headImageView addGestureRecognizer:tap];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.multipleTouchEnabled = YES;
        _headImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLabel];
        
        [self setupSubviewsForMessageModel:model];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = _headImageView.frame;
    frame.origin.x = _messageModel.isSender ? (self.bounds.size.width - _headImageView.frame.size.width - HEAD_PADDING) : HEAD_PADDING;
    _headImageView.frame = frame;

    [_nameLabel sizeToFit];
    frame = _nameLabel.frame;
    frame.origin.x = HEAD_PADDING * 2 + CGRectGetWidth(_headImageView.frame) + NAME_LABEL_PADDING;
    frame.origin.y = CGRectGetMinY(_headImageView.frame);
    frame.size.width = NAME_LABEL_WIDTH;
    _nameLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - setter

- (void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    
    _nameLabel.hidden = (messageModel.messageType == eMessageTypeChat);
    
    UIImage *placeholderImage = [UIImage imageNamed:@"chatListCellHead"];
    [self.headImageView sd_setImageWithURL:_messageModel.headImageURL placeholderImage:placeholderImage];
}

#pragma mark - private
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.superview];
        
        
        //启动弹出菜单

        NSMutableArray *menuItems = [NSMutableArray array];

        UIMenuItem *messageCopyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(messageCopy:)];
        [menuItems addObject:messageCopyItem];
        
        
        UIMenuItem *messageDelItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(messageDel:)];
        [menuItems addObject:messageDelItem];
        
        if (!_messageModel.isSender) {
            UIMenuItem *messageRepItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(messageRep:)];
            [menuItems addObject:messageRepItem];
        }

        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:menuItems];
        [self becomeFirstResponder];
        CGRect targetRect = self.frame;
        targetRect.origin.x = point.x;
        targetRect.origin.y = point.y;
        targetRect.size.height = 50;
        targetRect.size.width = 0;
        [menu setTargetRect:targetRect inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}
-(void)messageRep:(id)sender {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    
    ReportViewController* reportViewController = [[ReportViewController alloc] init];
    reportViewController.authorName = _messageModel.nickName;
    reportViewController.msgId = 0;
    reportViewController.hidesBottomBarWhenPushed = YES;
    [[AppDelegate visibleViewController].navigationController pushViewController:reportViewController animated:YES];
}
-(void)messageCopy:(id)sender{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_messageModel.content) {
        pasteboard.string = _messageModel.content;
    }
}
-(void)messageDel:(id)sender{
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确认删除" message:@"是否删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag = 0;
    [alertView show];
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (  action == @selector(messageRep:) || action == @selector(messageCopy:)|| action == @selector(messageDel:)) {
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
        if (_delMessage) {
            _delMessage(self.tag);
        }
    }
}
-(void)headImagePressed:(id)sender
{
    [super routerEventWithName:kRouterEventChatHeadImageTapEventName userInfo:@{KMESSAGEKEY:self.messageModel}];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [super routerEventWithName:eventName userInfo:userInfo];
}

#pragma mark - public

- (void)setupSubviewsForMessageModel:(MessageModel *)model
{
    if (model.isSender) {
        self.headImageView.frame = CGRectMake(self.bounds.size.width - HEAD_SIZE - HEAD_PADDING, CELLPADDING, HEAD_SIZE, HEAD_SIZE);
    }
    else{
        self.headImageView.frame = CGRectMake(0, CELLPADDING, HEAD_SIZE, HEAD_SIZE);
    }
}

+ (NSString *)cellIdentifierForMessageModel:(MessageModel *)model
{
    NSString *identifier = @"MessageCell";
    if (model.isSender) {
        identifier = [identifier stringByAppendingString:@"Sender"];
    }
    else{
        identifier = [identifier stringByAppendingString:@"Receiver"];
    }
    
    switch (model.type) {
        case eMessageBodyType_Text:
        {
            identifier = [identifier stringByAppendingString:@"Text"];
        }
            break;
        case eMessageBodyType_Image:
        {
            identifier = [identifier stringByAppendingString:@"Image"];
        }
            break;
        case eMessageBodyType_Voice:
        {
            identifier = [identifier stringByAppendingString:@"Audio"];
        }
            break;
        case eMessageBodyType_Location:
        {
            identifier = [identifier stringByAppendingString:@"Location"];
        }
            break;
        case eMessageBodyType_Video:
        {
            identifier = [identifier stringByAppendingString:@"Video"];
        }
            break;
            
        default:
            break;
    }
    
    return identifier;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model
{
    return HEAD_SIZE + CELLPADDING;
}

@end
