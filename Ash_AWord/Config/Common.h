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

#define kNetworkErrorTips @"网络连接失败"

/**
 *    接口地址
 */

#define Ash_AWord_API_URL @"http://121.43.150.13/QuestionServer"

/**
 * 微信开放平台信息
 */
#define kWXAppId @"wx8fbd37e4da758bbd"
#define kWXAppSecret @"de1415014dd1437d187042326bd5888e"

/**
 * QQ开放平台信息
 */
#define kQQAppId @"1104070329"
#define kQQAppSecret @"Lkk4P8GrTkcliKZo"

#define kUmengAppkey @"551958aafd98c5cc010006d8"


#endif
