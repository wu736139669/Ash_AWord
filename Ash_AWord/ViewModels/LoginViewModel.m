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
    [dic setObject:@"signature" forKey:@"signature"];
    [dic setObject:@"gender" forKey:@"gender"];
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
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"openid": openId,
                          @"name": name,
                          @"gender": gender,
                          @"figureurl": figureUrl
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10002",
                };
    
    return pro;
}
+(PropertyEntity*)requireRegistWithUserName:(NSString *)userName withNickName:(NSString *)nickName withPassword:(NSString *)password withGender:(NSString *)gender withAvatar:(UIImage *)avatarImg
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    
    proFile *file = [[proFile alloc] init];
    file.name = @"img";
    file.img = [NSArray arrayWithObject:avatarImg];
    pro.pFile = file;
    
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"username": userName,
                          @"password": password,
                          @"gender": gender,
                          @"name": nickName
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10003",
                };
    return pro;
}

+(PropertyEntity*)requireLoginWithUserName:(NSString *)userName withPassWord:(NSString *)passWord
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"username": userName,
                          @"password": passWord,
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10004",
                };
    return pro;

}
+(PropertyEntity*)requireModifyPassWord:(NSString *)newPassword withOldPaaaWord:(NSString *)oldPassWord
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"oldPassword": oldPassWord,
                          @"newPassword": newPassword,
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10005",
                };
    return pro;
}

+(PropertyEntity*)requireModifyInfoWithNickName:(NSString *)nickName withGender:(NSString *)gender withAvatarImg:(UIImage *)avatarImg withSignature:(NSString *)signature
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    proFile *file = [[proFile alloc] init];
    file.name = @"img";
    if (avatarImg) {
        file.img = [NSArray arrayWithObject:avatarImg];
    }
    pro.pFile = file;
    
    NSDictionary* dic = @{@"gender": gender,
                          @"name": nickName,
                          @"signature": signature,
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10006",};
    return pro;
}
+(PropertyEntity*)requireReportWith:(Msg_Type)type withMsgId:(NSInteger)msgId withContent:(NSString *)content
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{
                          
                          @"type": [NSString stringWithFormat:@"%u",type],
                          @"recordId": [NSString stringWithFormat:@"%ld",(long)msgId],
                          @"content": content,
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10007",};
    return pro;
}
+(PropertyEntity*)requireFeedbackWithContent:(NSString *)content
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{
                          @"content": content,
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10008",};
    return pro;
}
@end
