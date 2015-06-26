//
//  MessageListTableViewCell.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MessageListTableViewCell.h"
#import "EMConversation.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "UserViewModel.h"
@implementation MessageListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _unReadLabel.layer.cornerRadius = 10.0;
    _unReadLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUnReadCount:(NSInteger)count
{
    if (count == 0) {
        _unReadLabel.hidden = YES;
    }else{
        _unReadLabel.hidden = NO;
        _unReadLabel.text = [NSString stringWithFormat:@"%ld",count];
    }
}
-(void)setEMConversation:(EMConversation *)conversation
{
    
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        _timeLabel.hidden = NO;
        NSString* str = [NSString stringWithFormat:@"%lld",lastMessage.timestamp];
        _timeLabel.text = [CommonUtil timeFromtimeSp:str];
    }else{
        _timeLabel.hidden = YES;
    }
    
    [self setUnReadCount:conversation.unreadMessagesCount];
    
    _lastMsgLabel.text = [self subTitleMessageByConversation:conversation];
    
    _nameLabel.text = conversation.chatter;
}
-(void)setUserInfo:(UserInfoViewModel *)userInfo
{

    if (userInfo) {
        _nameLabel.text = userInfo.name;
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.figureurl] placeholderImage:DefaultUserIcon];

    }else{
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:DefaultUserIcon];
    }

}
// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.vidio1", @"[vidio]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

@end
