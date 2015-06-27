//
//  AWordUser.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "AWordUser.h"
static AWordUser *sharedObj = nil;
@implementation AWordUser

+(AWordUser*)sharedInstance
{
    if (!sharedObj)
    {
        sharedObj = [[self alloc] init];
        sharedObj.uid = [AWordDefault getUid];
        sharedObj.isLogin = [AWordDefault getIsLogin];
        sharedObj.userName = [AWordDefault getUserName];
        sharedObj.userAvatar = [AWordDefault getUserAvatar];
        sharedObj.userGender = [AWordDefault getUserGender];
        sharedObj.loginType = [AWordDefault getLoginType];
        sharedObj.headBgImg = [AWordDefault getHeadBgImg];
        sharedObj.signature = [AWordDefault getSignature];
        sharedObj.notReadCommentNum = 0;
        sharedObj.myNewFollowerCount = 0;
    }
    return sharedObj;
}

-(void)setLoginType:(NSInteger)loginType
{
    _loginType = loginType;
    [AWordDefault setLoginType:loginType];
}

-(void)setUserName:(NSString *)userName
{
    _userName = userName;
    [AWordDefault setUserName:userName];
}
-(void)setUid:(NSString *)uid
{
    _uid = uid;
    [AWordDefault setUid:uid];

}
-(void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [AWordDefault setIsLogin:isLogin];
}
-(void)setUserGender:(NSString *)userGender
{
    _userGender = userGender;
    [AWordDefault setUserGender:userGender];
}
-(void)setUserAvatar:(NSString *)userAvatar
{
    _userAvatar = userAvatar;
    [AWordDefault setUserAvatar:userAvatar];
}
-(void)setHeadBgImg:(UIImage *)headBgImg
{
    _headBgImg = headBgImg;
    [AWordDefault setHeadBgImg:headBgImg];
}
-(void)setSignature:(NSString *)signature
{
    _signature = signature;
    [AWordDefault setSignature:signature];
}
@end
