//
//  FeedbackViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/27.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "FeedbackViewController.h"
#import "LoginViewModel.h"
@interface FeedbackViewController ()<UITextViewDelegate>

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"意见反馈";
    [self customViewDidLoad];
    _contentTextView.placeholder = @"感谢您提出宝贵的意见";
    _contentTextView.delegate = self;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(completeBtnClick:)];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
}
-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
}

//当用户按下return键或者按回车键，keyboard消失

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];

    }
    return YES;

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

- (IBAction)completeBtnClick:(id)sender {
    if(_contentTextView.text.length <= 0 || [_contentTextView.text isEqualToString:@""]){
        [MBProgressHUD errorHudWithView:nil label:@"请输入内容" hidesAfter:1.0];
        return;
    }
    [MBProgressHUD hudWithView:self.view label:@"提交中"];
    PropertyEntity* pro = [LoginViewModel requireFeedbackWithContent:_contentTextView.text];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        LoginViewModel* loginViewModel = (LoginViewModel*)viewModel;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([loginViewModel success]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationName object:nil];
            
            [MBProgressHUD checkHudWithView:nil label:@"反馈成功" hidesAfter:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1.0), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD errorHudWithView:self.view label:loginViewModel.errMessage hidesAfter:1.0];
        }
        
    } failedBlock:^(NSError *error) {
        [MBProgressHUD errorHudWithView:nil label:kNetworkErrorTips hidesAfter:1.0];
        
    }];

}
@end
