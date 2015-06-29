//
//  SetUpViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "SetUpViewController.h"
#import "EGOCache.h"
#import "UMSocial.h"
#import "ModifyPassWordViewController.h"
#import "AppDelegate.h"
#import "FeedbackViewController.h"
#import "LoginViewModel.h"
#import "MessageSetViewController.h"
#import "BlackListViewController.h"
@interface SetUpViewController ()<UIAlertViewDelegate>

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customViewDidLoad];
    self.navigationItem.title = @"设置";
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }
    if([AWordUser sharedInstance].isLogin && [AWordUser sharedInstance].loginType==1)
        return 8;
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 10.0;
    }
    return 100.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![AWordUser sharedInstance].isLogin || section == 0 || section == 1) {
        return nil;
    }
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    view.backgroundColor = [UIColor clearColor];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(lgout:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    button.layer.cornerRadius = 5.0;
    button.layer.masksToBounds = YES;
    button.frame = CGRectMake(20, 25, kScreenWidth-40, 40);
    [view addSubview:button];
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"消息设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }else if(indexPath.section == 1){
        cell.textLabel.text = @"黑名单";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"清除缓存";
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                SDImageCache *cache = [SDImageCache sharedImageCache];
                NSUInteger size = [cache getSize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.detailTextLabel.text = size/1024 < 1024 ? [NSString stringWithFormat:@"%.2fKB",(float)size/1024.0]:[NSString stringWithFormat:@"%.2fMB",(float)size/(1024.0*1024.0)];
                });
            });

        }
            
            break;
        case 1:
            cell.textLabel.text = @"推荐给朋友";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
        {
            cell.textLabel.text = @"当前版本";
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSString *buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
            NSString *version = [NSString stringWithFormat:@"v%@.%@",app_Version, buildVersion];
            cell.detailTextLabel.text = version;
        }
            break;
        case 3:
            cell.textLabel.text = @"关于我们";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            break;
        case 4:
            cell.textLabel.text = @"欢迎打5星好评";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            break;
        case 5:
            cell.textLabel.text = @"服务条款";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            break;
        case 6:
            
            cell.textLabel.text = @"意见反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            break;

        
        case 7:
            cell.textLabel.text = @"密码修改";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            break;
        default:
            break;
    }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self goMessageSet];
        return;
    }else if (indexPath.section == 1){
        [self goBlackList];
        return;
    }
    switch (indexPath.row) {
        case 0:
            [self cleanCache];
            break;
        case 1:
        {
            NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", kAppleID];
            
             [SetUpViewController shareAppWithViewController:self andTitle:@"遇见你" andContent:@"最真的表白，是我欲言又止的沉默" andImage:[UIImage imageNamed:@"Icon@2x"] andUrl:str];
        }
            break;
        case 3:
            [self showAbout];
            break;
        case 4:
            [self goToAppraisal];
            break;
        case 5:
            [self showUserNotice];
            break;
        case 6:
            [self goFeedback];
            break;
 
        case 7:
             [self modifyPsw];
            break;

        default:
            break;
    }
}
#pragma mark 跳到App Store评价
-(void)goBlackList
{
    if (![AWordUser sharedInstance].isLogin)
    {
        [LoginViewController presentLoginViewControllerInView:self success:nil];
    }else{
        BlackListViewController* blackListViewController = [[BlackListViewController alloc] init];
        blackListViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:blackListViewController animated:YES];
    }
    
}
-(void)goMessageSet
{
    MessageSetViewController* messageSetViewController = [[MessageSetViewController alloc] init];
    messageSetViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageSetViewController animated:YES];
}
-(void)goFeedback
{
    FeedbackViewController* feedbackViewController = [[FeedbackViewController alloc] init];
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}
-(void)modifyPsw
{
    ModifyPassWordViewController* modifyPassWordViewController = [[ModifyPassWordViewController alloc] init];
    [self.navigationController pushViewController:modifyPassWordViewController animated:YES];
}
-(void)showUserNotice
{
    SVWebViewController* svWebViewController = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/notice.html",Ash_Aword_Base_URL]]];
    [self.navigationController pushViewController:svWebViewController animated:YES];
}
- (void)goToAppraisal
{
//    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", kAppleID];
    NSString* str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id;=%d",kAppleID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark 关于
-(void)showAbout
{
    SVWebViewController* svWebViewController = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/about.html",Ash_Aword_Base_URL]]];
    [self.navigationController pushViewController:svWebViewController animated:YES];
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 &&alertView.tag == 101) {
        [MobClick event:kUmen_logout];
        [MBProgressHUD hudWithView:self.view label:@"正在退出..."];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if (!error && info) {

            }
            [AWordUser sharedInstance].isLogin = NO;
            [AWordUser sharedInstance].uid = @"";
            [AWordUser sharedInstance].notReadCommentNum = 0;
            [AWordUser sharedInstance].myNewFollowerCount = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotificationName object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            DLog(@"退出成功");
        } onQueue:nil];

    }
    if(buttonIndex == 1 && alertView.tag == 102){
        [MBProgressHUD hudWithView:nil label:@"清除缓存中"];
        
        //清除cookies
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        
        //清除UIWebView的缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[EGOCache globalCache] clearCache];
        
        //image缓存
        SDImageCache *cache = [SDImageCache sharedImageCache];
        [cache clearDiskOnCompletion:^{
            [self.tableView reloadData];
            [MBProgressHUD hideAllHUDsForView:nil animated:YES];
            [MBProgressHUD checkHudWithView:nil label:@"缓存清除成功" hidesAfter:1];
        }];
    }
}
#pragma mark 清除缓存
- (void)cleanCache{
    
    

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 102;
    [alertView show];
}
-(void)lgout:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 101;
    [alertView show];
    
   
}

+ (void)shareAppWithViewController:(UIViewController *)controller andTitle:(NSString *)title andContent:(NSString *)content andImage:(UIImage *)image andUrl:(NSString *)url
{
    if (controller == nil) {
        controller = [AppDelegate visibleViewController];
    }
    if(title.length <= 0)
    {
        title = @"遇见你";
    }
    if(content.length <= 0)
    {
        content = @"最真的表白，是我欲言又止的沉默";
    }
    if (url.length <= 0) {
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", kAppleID];
        url = str;
    }
//    url = Ash_AWord_First_URL;
    NSString *shareText = [NSString stringWithFormat:@"%@%@",content,url];
    if(!image)
    {
        image = [UIImage imageNamed:@"Icon@2x"];
    }
    
    //设置title
    [UMSocialData defaultData].extConfig.title = [NSString stringWithFormat:@"%@",title];
    //设置url链接
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:kUmengAppkey
                                      shareText:shareText
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,
                                                 UMShareToQQ,
                                                 UMShareToWechatSession,
                                                 UMShareToWechatTimeline,
                                                 UMShareToEmail,
                                                 UMShareToSms,
                                                 nil]
                                       delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    
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
