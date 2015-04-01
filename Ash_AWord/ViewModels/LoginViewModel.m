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
    return @{
             @"uId": @"uid",
             };
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
    pro.reqURL = @"rs/login";
    pro.responesOBJ = self.class;
    pro.pro = @{@"openid": openId,
                @"name": name,
                @"gender": gender,
                @"figureurl": figureUrl
                };
    
    return pro;
}
@end
