//
//  PersonalTopView.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/10.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "PersonalTopView.h"
#import "UserViewModel.h"
#import "PraiseUserListViewController.h"
#import "AppDelegate.h"
#import "MWPhotoBrowser.h"
@implementation PersonalTopView
{
    BOOL _isSelectImage;
    UserViewModel* _userViewModel;
    BOOL _isAttention;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    _isSelectImage = YES;
    _isAttention = NO;
    
    _line1.backgroundColor = [UIColor lineColor];
    _line2.backgroundColor = [UIColor lineColor];
    _line3.backgroundColor = [UIColor lineColor];
    _line1Width.constant = 0.5;
    _line2Width.constant = 0.5;
    _line3Height.constant = 0.5;
    
    _avatarBtn.layer.masksToBounds = YES;
    _avatarBtn.layer.cornerRadius = _avatarBtn.frame.size.width/2;
    
    [_voiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_imageBtn setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];
    
    [_attentionBtn setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];
    _attentionBtn.layer.masksToBounds = YES;
    _attentionBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _attentionBtn.layer.cornerRadius = 2.0;

}

-(void)setuserInfoViewModel:(UserViewModel *)userViewModel
{
    _userViewModel = userViewModel;
    _nameLabel.text = userViewModel.userInfo.name;
    _attentionCountLabel.text = [NSString stringWithFormat:@"%ld",userViewModel.userInfo.followCount];
    _fansCountLabel.text = [NSString stringWithFormat:@"%ld",userViewModel.userInfo.followerCount];
    if (userViewModel.userInfo.signature) {
        _signatureLabel.text = userViewModel.userInfo.signature;
    }else{
        _signatureLabel.text = @"该用户暂时没有填写签名～";
    }
    if ([userViewModel.userInfo.uid isEqualToString:[AWordUser sharedInstance].uid] ) {
        _attentionBtn.hidden = YES;
    }else{
        _attentionBtn.hidden = NO;

    }
    if (userViewModel.relation == 0 || userViewModel.relation == 2) {
        [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        _isAttention = NO;
    }else{
        [_attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _isAttention = YES;

    }
    [_avatarBtn sd_setImageWithURL:[NSURL URLWithString:userViewModel.userInfo.figureurl] forState:UIControlStateNormal placeholderImage:DefaultUserIcon];
}
- (IBAction)avatarBtnClick:(id)sender {
    MWPhotoBrowser *pBrowser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    //是否显示分享按钮
    pBrowser.displayActionButton = YES;
    //左右分页切换
    pBrowser.displayNavArrows = YES;
    //是否显示选择按钮
    pBrowser.displaySelectionButtons = NO;
    //是否显示条件控制控件
    pBrowser.alwaysShowControls = YES;
    //是否全屏
    pBrowser.zoomPhotosToFill = YES;
    
    //允许使用网络查看所有图片
    pBrowser.enableGrid = YES;
    //是否第一张
    pBrowser.startOnGrid = YES;
    pBrowser.enableSwipeToDismiss = YES;
    [pBrowser showNextPhotoAnimated:YES];
    [pBrowser showPreviousPhotoAnimated:YES];
    [pBrowser setCurrentPhotoIndex:0];
    [[AppDelegate visibleViewController].navigationController pushViewController:pBrowser animated:YES];

}
#pragma mark - MWPhotoBrowserDelegate
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}

-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [[MWPhoto alloc]initWithURL:[NSURL URLWithString:_userViewModel.userInfo.figureurl]];
    return photo;
}
- (IBAction)attentionListClick:(id)sender {
    PraiseUserListViewController* praiseUserListViewController = [[PraiseUserListViewController alloc] init];
    praiseUserListViewController.targetId = _userViewModel.userInfo.uid;
    praiseUserListViewController.userListType = UserList_Attention_Type;
    praiseUserListViewController.hidesBottomBarWhenPushed = YES;
    [[AppDelegate visibleViewController].navigationController pushViewController:praiseUserListViewController animated:YES];
    
}

- (IBAction)fansListClick:(id)sender {
    PraiseUserListViewController* praiseUserListViewController = [[PraiseUserListViewController alloc] init];
    praiseUserListViewController.targetId = _userViewModel.userInfo.uid;
    praiseUserListViewController.userListType = UserList_Fans_Type;
    praiseUserListViewController.hidesBottomBarWhenPushed = YES;
    [[AppDelegate visibleViewController].navigationController pushViewController:praiseUserListViewController animated:YES];

}
- (IBAction)voiceBtnClick:(id)sender {
    if (_isSelectImage == NO) {
        return;
    }
    _isSelectImage = NO;
    [_imageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_voiceBtn setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];
    
    CGRect frame = _selectView.frame;
    frame.origin.x = kScreenWidth/2;
    [UIView animateWithDuration:0.3 animations:^{
        _selectView.frame = frame;
    }];
    if (_isSelectImg) {
        _isSelectImg(NO);
    }
}
- (IBAction)imageBtnClick:(id)sender {
    if (_isSelectImage == YES) {
        return;
    }
    _isSelectImage = YES;
    [_imageBtn setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];
    [_voiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    CGRect frame = _selectView.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _selectView.frame = frame;
    }];
    if (_isSelectImg) {
        _isSelectImg(YES);
    }
}
- (IBAction)attentionBtnClick:(id)sender {
    PropertyEntity* pro;
    pro = [UserViewModel requireAttentionWithTargetUid:_userViewModel.userInfo.uid withIsAttention:!_isAttention];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        if ([viewModel success]) {
            if (!_isAttention) {
                [_attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
//                [_attentionBtn setBackgroundColor:[UIColor lightGrayColor]];
                [_attentionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            }else{
                [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                [_attentionBtn setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];

            }
            _isAttention = !_isAttention;
        }else{
            [MBProgressHUD errorHudWithView:nil label:[viewModel errMessage] hidesAfter:1.0];
        }
    } failedBlock:^(NSError *error) {
        [MBProgressHUD errorHudWithView:nil label:kNetworkErrorTips hidesAfter:1.0];
    }];
}

- (IBAction)headBtnClick:(id)sender {
    
}

@end
