//
//  LoginViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/31.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "UMSocial.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/QQApi.h>
#import "WXApi.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![QQApi isQQInstalled]) {
        _qqBtn.hidden = YES;
    }
    if (![WXApi isWXAppInstalled]) {
        _wxBtn.hidden = YES;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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

- (IBAction)qqLoginBtnClick:(id)sender
{
    [MobClick event:kUmen_qqlogin attributes:nil];

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            [MBProgressHUD hudWithView:self.view label:kLoginTips];
            DLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
                DLog(@"SnsInformation is %@",response.data);
                if (response.data) {
                    [self loginWithOpenId:[response.data objectForKey:@"openid"] withName:[response.data objectForKey:@"screen_name"] withGender:[response.data objectForKey:@"gender"] withFigureUrl:[response.data objectForKey:@"profile_image_url"]];
                }else{
                    [MBProgressHUD errorHudWithView:self.view label:kSSoErrorTips hidesAfter:1.0];
                }
            }];
            
        }});

}

- (IBAction)sianLoginBtnClick:(id)sender {
    [MobClick event:kUmen_sinalogin attributes:nil];

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                NSLog(@"SnsInformation is %@",response.data);
                if (response.data) {
                    NSString* gender = @"男";
                    if ([[response.data objectForKey:@"gender"] integerValue]==0) {
                        gender = @"女";
                    }
                    NSString* openid = [NSString stringWithFormat:@"%ld",((NSNumber*)[response.data objectForKey:@"uid"]).integerValue];
                    [self loginWithOpenId:openid withName:[response.data objectForKey:@"screen_name"] withGender:gender withFigureUrl:[response.data objectForKey:@"profile_image_url"]];
                }else{
                    [MBProgressHUD errorHudWithView:self.view label:kSSoErrorTips hidesAfter:1.0];
                }
            }];
            
        }});
}

- (IBAction)weixinLoginBtnClick:(id)sender
{
    [MobClick event:kUmen_wxlogin attributes:nil];

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            [MBProgressHUD hudWithView:self.view label:kLoginTips];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            DLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                DLog(@"SnsInformation is %@",response.data);
                if (response.data) {
                    NSString* gender = @"男";
                    if ([[response.data objectForKey:@"gender"] integerValue]==0) {
                        gender = @"女";
                    }
                    [self loginWithOpenId:[response.data objectForKey:@"openid"] withName:[response.data objectForKey:@"screen_name"] withGender:gender withFigureUrl:[response.data objectForKey:@"profile_image_url"]];
                }else{
                    [MBProgressHUD errorHudWithView:self.view label:kSSoErrorTips hidesAfter:1.0];
                }
            }];
        }
        
    });
}

- (IBAction)closeBtnClick:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)loginWithOpenId:(NSString*)openId withName:(NSString*)name withGender:(NSString*)gender withFigureUrl:(NSString*)figureUrl;
{
    if ([gender isEqualToString:@"1"] ) {
        gender = @"男";
    }
    if ([gender isEqualToString:@"0"]) {
        gender = @"女";
    }
    PropertyEntity* loginViewModel = [LoginViewModel requireLoginWithOpenId:openId withName:name withGender:gender withFigureUrl:figureUrl];
    [RequireEngine requireWithProperty:loginViewModel completionBlock:^(id viewModel) {
        LoginViewModel* loginViewModel = (LoginViewModel*)viewModel;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([loginViewModel success]) {
            
            [AWordUser sharedInstance].isLogin = YES;
            [AWordUser sharedInstance].uid = loginViewModel.uId;
            [AWordUser sharedInstance].userName = name;
            [AWordUser sharedInstance].userAvatar = figureUrl;
            [AWordUser sharedInstance].userGender = gender;
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.loginSuccessBlock)
                {
                    self.loginSuccessBlock();
                    self.loginSuccessBlock = nil;
                }
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationName object:nil];
        }else{
            [MBProgressHUD errorHudWithView:self.view label:kSSoErrorTips hidesAfter:1.0];
        }
    } failedBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}

+ (LoginViewController *)shareLoginViewController
{
    static LoginViewController *loginVC = nil;
    if (loginVC == nil)
    {
        loginVC = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    }
    return loginVC;
}

+ (void)presentLoginViewControllerInView:(UIViewController *)vc success:(void (^)(void))completion
{
    //已登录
    if ([AWordUser sharedInstance].isLogin)
    {
        if (completion) completion();
        return;
    }
    
    if (!vc)
    {
        vc = [AppDelegate visibleViewController];
    }
    
    LoginViewController *loginVC = [LoginViewController shareLoginViewController];
    loginVC.loginSuccessBlock = completion;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    nav.delegate = loginVC;
    [vc presentViewController:nav animated:YES completion:nil];
}

@end
