//
//  Common.h
//  Ash_AWord
//
//  Created by xmfish on 15/3/30.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#ifndef Ash_AWord_Common_h
#define Ash_AWord_Common_h

#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"%@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif


/**
 * app store上的Apple ID
 */
#define kAppleID 983458853

/**
 *  系统版本
 */
#define iOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue]) //系统版本
#define iOS7AndLater   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define isiPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define isiPhone4s ([[UIScreen mainScreen] bounds].size.height == 480)

/**
 *  获取当前window宽高
 */
#define kScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#define kMainScreenFrame ([[UIScreen mainScreen] bounds])


//通知名
#define kLoginSuccessNotificationName  @"kLoginSuccessNotificationName"
#define kLogoutSuccessNotificationName @"kLogoutSuccessNotificationName"

#define kReceiveMessage @"kReceiveMessage"

//发表
#define kNotePushSuccessNotificationName  @"kNotePushSuccessNotificationName"
#define kMessagePushSuccessNotificationName  @"kMessagePushSuccessNotificationName"


//文字标签
#define kNetworkErrorTips @"网络连接失败"
#define kSSoErrorTips @"授权失败，请重新授权"
#define kLoginTips @"登录中"
#define kLoadingTips @"加载中。。。"
/**
 *    接口地址
 */

#define Ash_AWord_API_URL @"http://121.43.150.13/QuestionServer/rs/yjn/post"
#define Ash_AWord_First_URL @"http://www.yujianni520.com"
#define Ash_AWord_Share_URL @"http://admin.yujianni520.com/QuestionServer/web"
#define Ash_Aword_Base_URL @"http://admin.yujianni520.com/QuestionServer"
//#define Ash_AWord_API_URL @"http://192.168.1.3:8080/QuestionServer"
#define Sign_Key @"yjn@jjyy123"

/**
 *环信信息
 */
#define EaseMobApnsCertName_Dev @"yujianni"
#define EaseMobApnsCertNameProduct @"yujianni_product"
#define EaseMobAppKey @"ash#ashyujianni"
#define EasePassword @"123456"
/**
 * 微信开放平台信息
 */
#define kWXAppId @"wx557ac33ef4304d7c"
#define kWXAppSecret @"2a83b6118050b45a4df74911719b94e4"

/**
 * QQ开放平台信息
 */
#define kQQAppId @"1104488347"
#define kQQAppSecret @"IxBvKx29FgwjQdig"

#define kUmengAppkey @"551cf898fd98c586460011d1"

/**
 * 友盟的数据
 */
#define kUmen_wxlogin @"wxlogin"
#define kUmen_qqlogin @"qqlogin"
#define kUmen_sinalogin @"sinalogin"
#define kUmen_note @"note"
#define kUmen_addnote @"addnote"
#define kUmen_message @"message"
#define kUmen_addmessage @"addmessage"
#define kUmen_logout @"logout"
/**
 *  调整图片的宽度
 */
#define NEWIMAGE_SIZE  700.f

#define DefaultUserIcon [UIImage imageNamed:@"defaultUserIcon"]

#define DefaultPageSize 20
typedef enum{
    Image_Type = 0,
    Voice_Type = 1,
}CommentType;
#endif
