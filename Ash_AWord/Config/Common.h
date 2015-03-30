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

#define Ash_AWord_API_URL @"mobi.yingyinglicai.com:8443/front"

#endif
