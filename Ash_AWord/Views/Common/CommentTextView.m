//
//  CommentTextView.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/4.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "CommentTextView.h"
#import "CommentViewModel.h"
@interface CommentTextView()<UITextViewDelegate>
@end

@implementation CommentTextView
{
    NSString* _commentId;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)bgBtnClick:(id)sender {
    [self hide];
}

-(void)showWithUid:(NSString *)uid
{
    _commentId = uid;
    [_contentTextView becomeFirstResponder];
    self.hidden = NO;
    self.alpha = 1;

}
-(void)hide
{
    [_contentTextView resignFirstResponder];
}


-(void)awakeFromNib
{
    _contentTextView.layer.borderWidth = 0.5;
    _contentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _contentTextView.delegate = self;
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _contentBgView.frame;
        frame.origin.y = kScreenHeight - kbSize.height - _contentBgView.frame.size.height-64;
        _contentBgView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _contentBgView.frame;
        frame.origin.y = kScreenHeight-64;
        _contentBgView.frame = frame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)cancelBtnClick:(id)sender {
    [self hide];
}

- (IBAction)sendBtnClick:(id)sender {
    if ([_contentTextView.text isEqualToString:@""]) {
        _tipLabel.text = @"写点什么吧。。。";
        _tipLabel.textColor = [UIColor redColor];
    } else if(_contentTextView.text.length > 500)
    {
        _tipLabel.text = @"评论内容500字内";
        _tipLabel.textColor = [UIColor redColor];
    }else
    {
        if (![AWordUser sharedInstance].isLogin)
        {
            [LoginViewController presentLoginViewControllerInView:nil success:nil];
            return;
        }
        [self comment];
    }
}

-(void)comment
{

    [MBProgressHUD hudWithView:nil label:@"评论中"];

    NSString* commentId = _commentId;
    if (!commentId) {
        commentId = _aothourId;
    }
    PropertyEntity* pro = [CommentViewModel requireAddCommentWithReconrdId:_recordId withContent:_contentTextView.text WithType:_commentType withToUid:commentId];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        [MBProgressHUD hideAllHUDsForView:nil animated:YES];

        if ([viewModel success]) {
            [MBProgressHUD checkHudWithView:nil label:@"评论成功" hidesAfter:1.0];
            _contentTextView.text = @"";
            [self hide];
            if (_comentComplete) {
                _comentComplete();
            }
        }else{
            [MBProgressHUD checkHudWithView:nil label:[viewModel errMessage] hidesAfter:1.0];

        }
    } failedBlock:^(NSError *error) {
        [MBProgressHUD errorHudWithView:nil label:kNetworkErrorTips hidesAfter:2.0];

    }];
}
#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (![_contentTextView.text isEqualToString:@""]) {
        _tipLabel.text = @"写评论";
        _tipLabel.textColor = [UIColor blackColor];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
