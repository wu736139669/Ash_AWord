//
//  NotePublishViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "NotePublishViewController.h"
#import "NotePublishViewModel.h"
@interface NotePublishViewController ()<UIAlertViewDelegate,UITextViewDelegate>
{
    NSInteger _textLeft;
}
@end

@implementation NotePublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"发表图片";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
    
    _contentHeight.constant = kScreenHeight-216-64-60;
    _textLeft = 500;
    _contentTextView.placeholder = @"把你喜欢的好玩的图片发上来，配上美美的文字。so good！";
    _contentTextView.delegate = self;
    _imageView.image = _publishImage;
    
    [_contentTextView becomeFirstResponder];
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
    
}
-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
}

-(void)cancel
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"退出此次编辑" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}
-(void)publish
{
    if (_contentTextView.text.length>0 && _publishImage) {
        [MobClick event:kUmen_addnote];

        [MBProgressHUD hudWithView:self.view label:@"发布中"];
        PropertyEntity* notePublishViewModel = [NotePublishViewModel requireAddNote:_contentTextView.text withImage:_publishImage];
        [RequireEngine requireWithProperty:notePublishViewModel completionBlock:^(id viewModel) {
            NotePublishViewModel* notePublishViewModel = (NotePublishViewModel*)viewModel;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([notePublishViewModel success]) {
                [MBProgressHUD checkHudWithView:self.view label:@"发布成功" hidesAfter:1.0];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [MBProgressHUD errorHudWithView:self.view label:notePublishViewModel.errMessage hidesAfter:1.0];
            }
        } failedBlock:^(NSError *error) {
            [MBProgressHUD errorHudWithView:self.view label:kNetworkErrorTips hidesAfter:2.0];

        }];
    }
}
#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
#define MY_MAX 500
    if ((textView.text.length - range.length + text.length) > MY_MAX)
    {
        NSString *substring = [text substringToIndex:MY_MAX - (textView.text.length - range.length)];
        NSMutableString *lastString = [textView.text mutableCopy];
        [lastString replaceCharactersInRange:range withString:substring];
        textView.text = [lastString copy];
        return NO;
    }
    else
    {
        _textLeft = 500-(textView.text.length-range.length+text.length);
        _lengthLabel.text = [NSString stringWithFormat:@"%ld",(long)_textLeft];
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
