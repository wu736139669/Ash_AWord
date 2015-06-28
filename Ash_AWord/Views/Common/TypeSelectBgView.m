//
//  TypeSelectBgView.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/28.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "TypeSelectBgView.h"

@implementation TypeSelectBgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _allBtn.tag = 0;
    _attentionBtn.tag = 1;
    CGRect frame = _bgView.frame;
    frame.origin.y=-90;
    _bgView.frame = frame;
    
    _lineHeight.constant = 0.5;
    _lineView.backgroundColor = [UIColor lineColor];
}
- (IBAction)allBtnClick:(id)sender {
}

- (IBAction)bgBtnClick:(id)sender {
    [self hide];
}

- (IBAction)attentionBtnClick:(id)sender {
}

-(void)show{
    [self changeTypeState];
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _bgView.frame;
        frame.origin.y = 0;
        _bgView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hide{

    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _bgView.frame;
        frame.origin.y = -90;
        _bgView.frame = frame;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)changeTypeState
{
    if (_typeIndex == 0) {
        [_allBtn setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor appMainColor] forState:UIControlStateNormal];

    }
}
@end
