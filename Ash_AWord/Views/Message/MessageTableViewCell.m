//
//  MessageTableViewCell.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/7.
//  Copyright (c) 2015年 ash. All rights reserved.
//
#import "MessageViewModel.h"
#import "MessageTableViewCell.h"
#import "SetUpViewController.h"
#import "MessageViewModel.h"
#import "AudioPlayer.h"
#import "AppDelegate.h"
#import "MyMessageViewController.h"
#import "PersonalInfoViewController.h"
#import "MessageCommentViewController.h"

@interface MessageTableViewCell()<AudioPlayerDelegate>
@end
@implementation MessageTableViewCell
{
    Text_Voice* _text_voice;
    AudioPlayer* _audioPlayer;
    NSTimer* _timer;
}
- (void)awakeFromNib {
    // Initialization code
    _content.font = [UIFont appFontOfSize:14.0];
    _content.scrollEnabled = NO;
    _timeLabel.font = [UIFont appFontOfSize:14.0];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.width/2;
    _avatarImageView.layer.masksToBounds = YES;
    
    
    _goodBtn.layer.cornerRadius = 3;
    _goodBtn.layer.masksToBounds = YES;
    _shareBtn.layer.cornerRadius = 3;
    _shareBtn.layer.masksToBounds = YES;
    _goodBtn.backgroundColor = [UIColor lineColor];
    _shareBtn.backgroundColor = [UIColor lineColor];
    _commitBtn.layer.cornerRadius = 3;
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.backgroundColor = [UIColor lineColor];
    
    _audioPlayer = [[AudioPlayer alloc] init];
    _audioPlayer.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIsComment:(BOOL)isComment
{
    if (isComment) {
        _commitBtn.hidden = YES;
    }else
    {
        _commitBtn.hidden = NO;
    }
}
- (IBAction)playBtnClick:(id)sender {
    if (_playBtn.selected == NO) {
        _playBtn.selected = YES;
        if ([_delegate respondsToSelector:@selector(playWithIndex:)]) {
            [_delegate playWithIndex:self.tag];
        }
        
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        }
        
        if(_audioPlayer.state == AudioPlayerStatePaused){
            [_audioPlayer resume];
        }else{
            [_audioPlayer play:_text_voice.voiceUrl];
        }
        
    }else{
        [_timer invalidate];
        _timer = nil;
        _playBtn.selected = NO;
        if (_audioPlayer.state == AudioPlayerStatePlaying) {
            [_audioPlayer pause];
        }

    }
}
-(void)stopPlay
{
    [_timer invalidate];
    _timer = nil;
    _playBtn.selected = NO;
    if (_audioPlayer.state == AudioPlayerStatePlaying)
    {
        [_audioPlayer pause];
    }

}
-(void) tick
{
    if (!_audioPlayer || _audioPlayer.duration == 0)
    {
        _timeProgressView.progress = 0;
        
        return;
    }
    
//    DLog("%f",_audioPlayer.progress);
    _nowTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)_audioPlayer.progress/60,(long)_audioPlayer.progress%60];
    _timeProgressView.progress = _audioPlayer.progress/_audioPlayer.duration;
    if (_audioPlayer.progress == _audioPlayer.duration) {
        [_audioPlayer stop];
    }
}


-(void)setText_Voice:(Text_Voice *)text_voice
{
    _text_voice = text_voice;
    
    _userNameLabel.text = text_voice.ownerName;
    
    _totalTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld",_text_voice.voiceLength.longValue/60,_text_voice.voiceLength.longValue%60];

    
    [_avatarImageView sd_setImageWithURL:text_voice.ownerFigureurl placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    _timeLabel.text = [CommonUtil timeFromtimeSp:text_voice.createTime.stringValue];
    _timeLabel.hidden = NO;
    UIFont *font = [UIFont appFontOfSize:14.0];
    CGSize size = CGSizeMake(300*[Ash_UIUtil currentScreenSizeRate],MAXFLOAT);
    
    CGRect labelRect = [text_voice.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    _contentHeight.constant = labelRect.size.height+25;
    _content.text = text_voice.content;
    
    [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",(long)text_voice.praiseCount] forState:UIControlStateNormal];
    [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",(long)text_voice.praiseCount] forState:UIControlStateSelected];
    [_shareBtn setTitle:[NSString stringWithFormat:@"%ld",(long)text_voice.shareCount] forState:UIControlStateNormal];
    [_commitBtn setTitle:[NSString stringWithFormat:@"%ld",(long)text_voice.commentCount] forState:UIControlStateNormal];

    _closeBtn.hidden = YES;
    [self setGoodBtnSelect:text_voice.hasPraised];

}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([_delegate respondsToSelector:@selector(reportWithIndex:)]) {
        [_delegate reportWithIndex:self.tag];
    }
    return NO;
}
-(void)setGoodBtnSelect:(BOOL)isSelect
{
    if (isSelect) {
        _goodBtn.selected = YES;
        _goodBtn.backgroundColor = [UIColor lineColor];
        
    }else{
        _goodBtn.selected = NO;
        _goodBtn.backgroundColor = [UIColor lineColor];
    }
}
+(CGFloat)heightWith:(Text_Voice *)text_voice
{
    UIFont *font = [UIFont appFontOfSize:14.0];
    CGSize size = CGSizeMake(300*[Ash_UIUtil currentScreenSizeRate],MAXFLOAT);
    
    
    CGRect labelRect = [text_voice.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    return labelRect.size.height+160;
}
- (IBAction)shareBtnClick:(id)sender {
    
    [SetUpViewController shareAppWithViewController:nil andTitle:@"遇见你" andContent:_text_voice.content andImage:nil andUrl:[NSString stringWithFormat:@"%@/web/voice_share_info?record_id=%ld",Ash_AWord_API_URL,_text_voice.messageId]];
    PropertyEntity* pro = [MessageViewModel requireShareWithRecordId:_text_voice.messageId];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        if ([viewModel success]) {
            _text_voice.shareCount++;
        }
    } failedBlock:^(NSError *error) {
    }];
}
- (IBAction)goodBtnClick:(id)sender {
    if (![AWordUser sharedInstance].isLogin)
    {
        [LoginViewController presentLoginViewControllerInView:nil success:nil];
        return;
    }
    
//    _goodBtn.enabled = NO;
    if (_goodBtn.selected) {
        [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",_text_voice.praiseCount-1] forState:UIControlStateNormal];
        [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",_text_voice.praiseCount-1] forState:UIControlStateSelected];
    }else{
        [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",_text_voice.praiseCount+1] forState:UIControlStateNormal];
        [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",_text_voice.praiseCount+1] forState:UIControlStateSelected];
    }
    [self setGoodBtnSelect:!_goodBtn.selected];
    
    PropertyEntity* pro = [MessageViewModel requirePraiseWithRecordId:_text_voice.messageId];
    
    Text_Voice* tempTI = _text_voice;
    
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        MessageViewModel* noteViewModel = (MessageViewModel*)viewModel;
        _goodBtn.enabled = YES;
        if ([noteViewModel success]) {
            
            if (tempTI.hasPraised) {
                tempTI.hasPraised = NO;
                tempTI.praiseCount--;
            }else{
                tempTI.hasPraised = YES;
                tempTI.praiseCount++;
            }
            
        }else{
            [MBProgressHUD errorHudWithView:nil label:noteViewModel.errMessage hidesAfter:1.0];
            [self setGoodBtnSelect:!_goodBtn.selected];
        }
    } failedBlock:^(NSError *error) {
        _goodBtn.enabled = YES;
        [self setGoodBtnSelect:!_goodBtn.selected];
        [MBProgressHUD errorHudWithView:nil label:kNetworkErrorTips hidesAfter:1.0];
    }];
    

}

-(void) updateControls
{
    if (_audioPlayer == nil)
    {
    }
    else if (_audioPlayer.state == AudioPlayerStatePaused)
    {
        _playBtn.selected = NO;
    }
    else if (_audioPlayer.state == AudioPlayerStatePlaying)
    {
        _playBtn.selected = YES;

    }
    else
    {
        _timeProgressView.progress = 0.0;
        _nowTimeLabel.text = @"00:00";
        _playBtn.selected = NO;

    }

}
#pragma mark AudioPlayerDelegate
-(void) audioPlayer:(AudioPlayer*)audioPlayer stateChanged:(AudioPlayerState)state
{
    [self updateControls];
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didEncounterError:(AudioPlayerErrorCode)errorCode
{
    [self updateControls];
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    [self updateControls];
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    [self updateControls];
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(AudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    [self updateControls];
}

- (IBAction)commitBtnClick:(id)sender {
    MessageCommentViewController* messageCommentViewController = [[MessageCommentViewController alloc] init];
    messageCommentViewController.hidesBottomBarWhenPushed = YES;
    messageCommentViewController.text_Voice = _text_voice;
    [[AppDelegate visibleViewController].navigationController pushViewController:messageCommentViewController animated:YES];
}

- (IBAction)avatarBtnClick:(id)sender {
    if (![_text_voice.ownerId isEqualToString:[AWordUser sharedInstance].uid] ) {        PersonalInfoViewController* personalInfoViewController = [[PersonalInfoViewController alloc] initWithNibName:@"NoteCommentViewController" bundle:nil];
        personalInfoViewController.hidesBottomBarWhenPushed = YES;
        personalInfoViewController.otherUserId = _text_voice.ownerId;
        [[AppDelegate visibleViewController].navigationController pushViewController:personalInfoViewController animated:YES];
    }
}
- (IBAction)closeBtnClick:(id)sender {
}
@end
