//
//  PersonalTopView.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/10.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "PersonalTopView.h"
#import "UserViewModel.h"
@implementation PersonalTopView
{
    BOOL _isSelectImage;
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
    _attentionBtn.layer.cornerRadius = 2.0;

}

-(void)setuserInfoViewModel:(UserViewModel *)userViewModel
{
    _nameLabel.text = userViewModel.userInfo.name;
    _attentionCountLabel.text = [NSString stringWithFormat:@"%ld",userViewModel.userInfo.followCount];
    _fansCountLabel.text = [NSString stringWithFormat:@"%ld",userViewModel.userInfo.followerCount];
    if (userViewModel.userInfo.signature) {
        _signatureLabel.text = userViewModel.userInfo.signature;
    }else{
        _signatureLabel.text = @"该用户暂时没有填写签名～";
    }
    

    [_avatarBtn sd_setImageWithURL:[NSURL URLWithString:userViewModel.userInfo.figureurl] forState:UIControlStateNormal placeholderImage:DefaultUserIcon];
}
- (IBAction)avatarBtnClick:(id)sender {
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
}

@end
