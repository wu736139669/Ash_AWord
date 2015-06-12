//
//  CommonUtil.h
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kNetworkTypeNone    = 0,
    kNetworkType2G      = 1,
    kNetworkType3G      = 2,
    kNetworkType4G      = 3,
    kNetworkTypeLET     = 4,
    kNetworkTypeWiFi    = 5,
}
NetworkType;

@interface CommonUtil : NSObject

//获取版本号
+(NSString*)getVersion;
//获取系统网络类型
+ (NetworkType)networkType;

//设备类型比如iPhone3,1(iphone4)
+ (NSString *)getUtsName;

+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;

/**
 *   NSdate转为日历
 */
+(NSDateComponents*)componentsWithDate:(NSDate*)date;
/**
 *   NSdate相差天数
 */
+(NSInteger)dayWithBeginDate:(NSDate*)beginDate withEndDate:(NSDate*)endDate;
/**
 *   NSdate返回与指定NSdate相差天数的新的NSDate
 */
+(NSDate*)newDateWithDate:(NSDate*)oldDate withOffSetDay:(NSInteger)day;
//时间戳转时间
+(NSString*)timeFromtimeSp:(NSString*)timeSp;
//判断是否同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

+ (BOOL) validateUserName:(NSString *)name;

+ (BOOL) validateNickname:(NSString *)nickname;
@end

@interface NSString (MD5Extensions)
- (NSString *)md5;
@end

@interface NSData (MD5Extensions)
- (NSString*)md5;
@end
