//
//  AppDelegate.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/26.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "MobClick.h"
#import "MainViewController.h"
#import "EaseMob.h"
#import "PersonalInfoViewController.h"
@interface AppDelegate ()<UIAlertViewDelegate>
{
    NSString* _otherUserId;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _otherUserId = nil;
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
    
    NSString* apnsCertName = EaseMobApnsCertName_Dev;
#if DEBUG
    apnsCertName = EaseMobApnsCertName_Dev;
#else
    apnsCertName = EaseMobApnsCertNameProduct;
#endif
    
    //注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    [[EaseMob sharedInstance] registerSDKWithAppKey:EaseMobAppKey apnsCertName:apnsCertName];
    // 需要在注册sdk后写上该方法
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    _mainViewController = [[MainViewController alloc] init];
    self.window.rootViewController = _mainViewController;
    _mainViewController.delegate = self;

    //登陆聊天的
    if ([AWordUser sharedInstance].isLogin)
    {
        [Ash_UIUtil EaseMobLoginWithUserName:[AWordUser sharedInstance].uid];
    }

    [self setUmeng];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];

}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    DLog(@"error -- %@",error);
}
// 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
//        TTAlertNoTitle(NSLocalizedString(@"apns.failToBindDeviceToken", @"Fail to bind device token"));
    }
}



// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString* info = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    _otherUserId = [userInfo objectForKey:@"f"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到消息"
                                                    message:info
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:@"点击查看",nil];
    [alert show];
    
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString* info = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    _otherUserId = [userInfo objectForKey:@"f"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到消息"
                                                    message:info
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:@"点击查看",nil];
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && _otherUserId && ![_otherUserId isEqualToString:@""]) {
        
        PersonalInfoViewController* personalInfoViewController = [[PersonalInfoViewController alloc] initWithNibName:@"PersonalInfoViewController" bundle:nil];
        personalInfoViewController.hidesBottomBarWhenPushed = YES;
        personalInfoViewController.otherUserId = _otherUserId;
        [[AppDelegate visibleViewController].navigationController pushViewController:personalInfoViewController animated:YES];
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark -  UITabBarController
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

/**
 * 当前可视viewController
 */
+ (UIViewController *)visibleViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
    if ([tab isKindOfClass:[UITabBarController class]])
    {
        return ([(UINavigationController *)[[tab viewControllers] objectAtIndex:tab.selectedIndex] visibleViewController]);
    }
    return nil;
}

#pragma mark methods
-(void)setUmeng
{
//    [WXApi registerApp:kWXAppId];
    [UMSocialData setAppKey:kUmengAppkey];
    [UMSocialWechatHandler setWXAppId:kWXAppId appSecret:kWXAppSecret url:@"http://121.43.150.13/QuestionServer/home.html"];
    [UMSocialQQHandler setQQWithAppId:kQQAppId appKey:kQQAppSecret url:@"http://121.43.150.13/QuestionServer/home.html"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    [MobClick startWithAppkey:kUmengAppkey reportPolicy:REALTIME channelId:@"App Store"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
#ifdef DEBUG
    //    [MobClick setLogEnabled:YES];
    [UMSocialData openLog:YES];
#endif

}
@end
