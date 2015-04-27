//
//  LoginViewModel.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/30.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [dic setObject:@"uid" forKey:@"uId"];
    [dic setObject:@"figureurl" forKey:@"figureurl"];
    [dic setObject:@"name" forKey:@"userName"];
    return dic;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    // Store a value that needs to be determined locally upon initialization.
    
    return self;
}

+(PropertyEntity*)requireLoginWithOpenId:(NSString *)openId withName:(NSString *)name withGender:(NSString *)gender withFigureUrl:(NSString *)figureUrl
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOST;
    pro.reqURL = @"rs/common/login";
    pro.responesOBJ = self.class;
    pro.pro = @{@"openid": openId,
                @"name": name,
                @"gender": gender,
                @"figureurl": figureUrl
                };
    
    return pro;
}
+(PropertyEntity*)requireRegistWithUserName:(NSString *)userName withNickName:(NSString *)nickName withPassword:(NSString *)password withGender:(NSString *)gender withAvatar:(UIImage *)avatarImg
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.reqURL = @"rs/common/register";
    pro.responesOBJ = self.class;
    
    proFile *file = [[proFile alloc] init];
    file.name = @"img";
    file.img = [NSArray arrayWithObject:avatarImg];
    pro.pFile = file;
    
    pro.pro = @{@"username": userName,
                @"password": password,
                @"gender": gender,
                @"name": nickName
                };
    
    return pro;
}

+(PropertyEntity*)requireLoginWithUserName:(NSString *)userName withPassWord:(NSString *)passWord
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOST;
    pro.reqURL = @"rs/common/login_local";
    pro.responesOBJ = self.class;
    pro.pro = @{@"username": userName,
                @"password": passWord,
                };
    
    return pro;

}
+(PropertyEntity*)requireModifyPassWord:(NSString *)newPassword withOldPaaaWord:(NSString *)oldPassWord
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOST;
    pro.reqURL = @"rs/common/edit_password";
    pro.responesOBJ = self.class;
    pro.pro = @{@"old_password": oldPassWord,
                @"new_password": newPassword,
                };
    
    return pro;
}

+(PropertyEntity*)requireModifyInfoWithNickName:(NSString *)nickName withGender:(NSString *)gender withAvatarImg:(UIImage *)avatarImg
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.reqURL = @"rs/common/edit_userinfo";
    pro.responesOBJ = self.class;
    proFile *file = [[proFile alloc] init];
    file.name = @"img";
    if (avatarImg) {
        file.img = [NSArray arrayWithObject:avatarImg];
    }
    pro.pFile = file;
    
    pro.pro = @{
                
                @"gender": gender,
                @"name": nickName
                };
    
    return pro;
}
+(PropertyEntity*)requireReportWith:(Msg_Type)type withMsgId:(NSInteger)msgId withContent:(NSString *)content
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOST;
    pro.reqURL = @"rs/common/tip_off";
    pro.responesOBJ = self.class;
    pro.pro = @{
                
                @"type": [NSString stringWithFormat:@"%u",type],
                @"record_id": [NSString stringWithFormat:@"%ld",(long)msgId],
                @"content": content,
                };
    
    return pro;
}
+(PropertyEntity*)requireFeedbackWithContent:(NSString *)content
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOST;
    pro.reqURL = @"rs/common/feedback";
    pro.responesOBJ = self.class;
    pro.pro = @{
                @"content": content,
                };
    
    return pro;
}
@end
