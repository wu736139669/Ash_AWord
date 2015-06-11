//
//  PersonalTopView.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/10.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "PersonalTopView.h"

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
}
- (IBAction)attentionBtnClick:(id)sender {
}
@end
