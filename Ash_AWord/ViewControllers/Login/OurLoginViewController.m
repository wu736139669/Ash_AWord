//
//  OurLoginViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "OurLoginViewController.h"
#import "LoginViewModel.h"
#import "EaseMob.h"
@interface OurLoginViewController ()<UITextFieldDelegate>

@end

@implementation OurLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"登录";
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
    
    _userAccountTextField.delegate = self;
    _passwordTextField.delegate = self;
}
-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 36 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _userAccountTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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

- (IBAction)loginBtnClick:(id)sender {
    if (_userAccountTextField.text.length <= 0) {
        [MBProgressHUD errorHudWithView:nil label:@"请输入用户名" hidesAfter:1.0];
        return;
    }
    if (_passwordTextField.text.length <= 0){
        [MBProgressHUD errorHudWithView:nil label:@"请输入密码" hidesAfter:1.0];
        return;

    }
    [MBProgressHUD hudWithView:self.view label:@"登录中"];
    PropertyEntity* pro = [LoginViewModel requireLoginWithUserName:_userAccountTextField.text withPassWord:_passwordTextField.text];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        LoginViewModel* loginViewModel = (LoginViewModel*)viewModel;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([loginViewModel success]) {
            [Ash_UIUtil EaseMobLoginWithUserName:loginViewModel.uId];
            [AWordUser sharedInstance].isLogin = YES;
            [AWordUser sharedInstance].loginType = 1;
            [AWordUser sharedInstance].uid = loginViewModel.uId;
            [AWordUser sharedInstance].userName = loginViewModel.userName;
            [AWordUser sharedInstance].userAvatar = loginViewModel.figureurl;
            [AWordUser sharedInstance].userGender = @"";
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationName object:nil];
            
            [MBProgressHUD checkHudWithView:nil label:@"登录成功" hidesAfter:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1.0), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            
            
        }else{
            [MBProgressHUD errorHudWithView:self.view label:loginViewModel.errMessage hidesAfter:2.0];
        }
        
        
    } failedBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD errorHudWithView:nil label:kNetworkErrorTips hidesAfter:1.0];
    }];

}
@end
