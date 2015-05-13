//
//  RegistAccountViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "RegistAccountViewController.h"
#import "RegistInfoViewController.h"
@interface RegistAccountViewController ()<UITextFieldDelegate>

@end

@implementation RegistAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self customViewDidLoad];
    self.navigationItem.title = @"注册";
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
    
    _userAccountTextField.delegate = self;
    _firstPassWordTextField.delegate = self;
    _secondPassWordTextField.delegate = self;
}

-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 80 - (self.view.frame.size.height - 216.0);//键盘高度216
    if (textField == _secondPassWordTextField || textField == _firstPassWordTextField) {
        
    }
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
        [_firstPassWordTextField becomeFirstResponder];
    }else if(textField == _firstPassWordTextField){
        [_secondPassWordTextField becomeFirstResponder];
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

- (IBAction)nextBtnClick:(id)sender {
    if (![CommonUtil validateUserName:_userAccountTextField.text]) {
        [MBProgressHUD errorHudWithView:nil label:@"用户名不合法" hidesAfter:1.0];
        return;
    }
    if (_firstPassWordTextField.text.length<6 || _firstPassWordTextField.text.length>20){
        [MBProgressHUD errorHudWithView:nil label:@"密码长度应在6-20" hidesAfter:1.0];
        return;
    }
    if(![_firstPassWordTextField.text isEqualToString:_secondPassWordTextField.text]){
        [MBProgressHUD errorHudWithView:nil label:@"两次密码输入不同" hidesAfter:1.0];
        return;
    }
    
    RegistInfoViewController* registInfoViewController = [[RegistInfoViewController alloc] init];
    registInfoViewController.userAccount = _userAccountTextField.text;
    registInfoViewController.passWord = _firstPassWordTextField.text;
    [self.navigationController pushViewController:registInfoViewController animated:YES];
}

- (IBAction)userNoticeBtnClick:(id)sender {
    SVWebViewController* svWebViewController = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/notice.html",Ash_AWord_API_URL]]];
    [self.navigationController pushViewController:svWebViewController animated:YES];
}
@end
