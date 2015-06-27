//
//  AWordDefault.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "AWordDefault.h"

@implementation AWordDefault

+(void)setIsLogin:(BOOL)isLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"islogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL)getIsLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"];
}

+(void)setUid:(NSString *)uid
{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getUid
{
   return [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
}

+(void)setUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getUserName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
}

+(void)setUserAvatar:(NSString *)userAvatar
{
    [[NSUserDefaults standardUserDefaults] setObject:userAvatar forKey:@"useravatar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getUserAvatar
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"useravatar"];

}

+(void)setUserGender:(NSString *)userGender
{
    [[NSUserDefaults standardUserDefaults] setObject:userGender forKey:@"usergender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getUserGender
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"usergender"];
    
}
+(void)setLastUpdateTime:(NSTimeInterval)date
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:date] forKey:@"updatetime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSTimeInterval)getLastUpdateTime
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"updatetime"];
}
+(void)setLoginType:(NSInteger)loginType
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:loginType] forKey:@"logintype"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSInteger)getLoginType
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"logintype"];
}

+(void)setSignature:(NSString *)sinagure
{
    [[NSUserDefaults standardUserDefaults] setObject:sinagure forKey:@"sinagure"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)getSignature
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"sinagure"];
    
}
+(BOOL)setHeadBgImg:(UIImage *)headBgImg
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"headbg.png"]];   // 保存文件的名称
    return [UIImagePNGRepresentation(headBgImg)writeToFile: filePath atomically:YES];
}
+(UIImage*)getHeadBgImg
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"headbg.png"]];   // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    return img;
}
@end
