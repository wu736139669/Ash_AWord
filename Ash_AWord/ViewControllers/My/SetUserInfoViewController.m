//
//  SetUserInfoViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "SetUserInfoViewController.h"
#import "LoginViewModel.h"
@interface SetUserInfoViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImage* _avatarImage;
}
@end

@implementation SetUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _avatarBtn.layer.cornerRadius = _avatarBtn.frame.size.width/2;
    _avatarBtn.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.width/2;
    _avatarImageView.layer.masksToBounds = YES;
    
    _nickNameTextField.delegate = self;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[AWordUser sharedInstance].userAvatar] placeholderImage:[UIImage imageNamed:@"Icon"]];
    _nickNameTextField.text = [AWordUser sharedInstance].userName;
    _nickNameTextField.placeholder = [AWordUser sharedInstance].userName;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
    
    self.navigationItem.title = @"个人信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定修改" style:UIBarButtonItemStyleDone target:self action:@selector(sureModify)];
}
-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
}
#pragma mark UITextField
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 76 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, self.view.frame.origin.y-offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
- (IBAction)avatarBtnClick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }else{
        [self actionSheet:nil clickedButtonAtIndex:1];
    }
}

#pragma mark UIActonSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    if (buttonIndex == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if(buttonIndex == 2)
    {
        return;
    }
    [self presentViewController:picker animated:YES completion:nil];
    
}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated: YES completion: ^(void){}];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    // resize image
    image = [Ash_UIUtil fixOrientation:image];
    image = [Ash_UIUtil compressImageDownToPhoneScreenSize:image];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    _avatarImage = image;
    _avatarImageView.image = _avatarImage;
    
}
-(void)sureModify
{
    
    if ( [_nickNameTextField.text isEqualToString:[AWordUser sharedInstance].userName] && !_avatarImage) {
        [MBProgressHUD errorHudWithView:nil label:@"没有内容修改" hidesAfter:1.0];
        return;
    }
    if ([_nickNameTextField.text isEqualToString:@""]) {
        [MBProgressHUD errorHudWithView:nil label:@"昵称不能为空" hidesAfter:1.0];
        return;
    }
    NSString* nickName = _nickNameTextField.text;
    if (nickName.length <= 0 || [_nickNameTextField.text isEqualToString:@""]) {
        nickName = _nickNameTextField.placeholder;
    }
    PropertyEntity* pro = [LoginViewModel requireModifyInfoWithNickName:nickName withGender:@"" withAvatarImg:_avatarImage];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        LoginViewModel* loginViewModel = (LoginViewModel*)viewModel;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([loginViewModel success]) {
            [AWordUser sharedInstance].userName = nickName;
            [AWordUser sharedInstance].userAvatar = loginViewModel.figureurl;
            [AWordUser sharedInstance].userGender = @"";
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationName object:nil];
            
            [MBProgressHUD checkHudWithView:nil label:@"修改成功" hidesAfter:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1.0), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        }else{
            [MBProgressHUD errorHudWithView:self.view label:kSSoErrorTips hidesAfter:1.0];
        }
        
        
    } failedBlock:^(NSError *error) {
        [MBProgressHUD errorHudWithView:nil label:kNetworkErrorTips hidesAfter:1.0];
    }];

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
