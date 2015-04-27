//
//  ReportViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "ReportViewController.h"
#import "LoginViewModel.h"
@interface ReportViewController ()<UITextViewDelegate>

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customViewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"举报";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(report)];
    
    _reportContentTextView.placeholder = @"请输入举报原因";
    _reportContentTextView.delegate = self;
    _reportNameLabel.text = [NSString stringWithFormat:@"举报作者%@的内容",_authorName];
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
}
-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
}
-(void)report
{
    if ([_reportContentTextView.text isEqualToString:@""]) {
        [MBProgressHUD errorHudWithView:nil label:@"请输入举报内容" hidesAfter:1.0];
        return;
    }
    [MBProgressHUD hudWithView:self.view label:@"举报中"];
    PropertyEntity* pro = [LoginViewModel requireReportWith:_msgType withMsgId:_msgId withContent:_reportContentTextView.text];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        LoginViewModel* loginViewModel = (LoginViewModel*)viewModel;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([loginViewModel success]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationName object:nil];
            
            [MBProgressHUD checkHudWithView:nil label:@"举报成功" hidesAfter:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1.0), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        }else{
            [MBProgressHUD errorHudWithView:self.view label:kSSoErrorTips hidesAfter:1.0];
        }

    } failedBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD errorHudWithView:nil label:kNetworkErrorTips hidesAfter:1.0];

    }];
    
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    
    self.view.frame = CGRectMake(0.0f, -20, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];

    
}


//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}


//输入框编辑完成以后，将视图恢复到原始状态
-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
