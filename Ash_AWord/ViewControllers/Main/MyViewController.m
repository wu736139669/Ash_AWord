//
//  MyViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/30.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MyViewController.h"
#import "UMSocial.h"
#import "LoginViewModel.h"
@interface MyViewController ()
{
    NSArray* cellTitleArr;
}
@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的";
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = @"登录";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"我发表的文字";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"我发表的声音";
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"清楚缓存";
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"推荐给朋友";
        }
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                    [MBProgressHUD hudWithView:self.view label:@"登录中"];
                    NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
                        NSLog(@"SnsInformation is %@",response.data);
                        if (response.data) {
                            [self loginWithOpenId:[response.data objectForKey:@"openid"] withName:[response.data objectForKey:@"screen_name"] withGender:[response.data objectForKey:@"gender"] withFigureUrl:[response.data objectForKey:@"profile_image_url"]];
                        }else{
                            [MBProgressHUD errorHudWithView:self.view label:@"信息获取失败，重新授权" hidesAfter:1.0];
                        }
                    }];
                    
                }});
        }
            break;
            
        default:
            break;
    }
}

-(void)loginWithOpenId:(NSString*)openId withName:(NSString*)name withGender:(NSString*)gender withFigureUrl:(NSString*)figureUrl;
{
    PropertyEntity* loginViewModel = [LoginViewModel requireLoginWithOpenId:openId withName:name withGender:gender withFigureUrl:figureUrl];
    [RequireEngine requireWithProperty:loginViewModel completionBlock:^(id viewModel) {
        LoginViewModel* loginViewModel = (LoginViewModel*)viewModel;
        
    } failedBlock:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
