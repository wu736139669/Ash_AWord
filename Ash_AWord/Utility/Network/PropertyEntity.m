//
//  PropertyEntity.m
//  iOSFramework
//
//  Created by xmfish on 14-9-22.
//  Copyright (c) 2014年 aDu. All rights reserved.
//

#import "PropertyEntity.h"
#import "NSString+HXAddtions.h"
@implementation proFile

@end

@implementation PropertyEntity

- (NSDictionary *)encodePro
{

    NSMutableDictionary* dic;
    if ([_pro objectForKey:@"root"]) {
        dic = [NSMutableDictionary dictionaryWithDictionary:[_pro objectForKey:@"root"]];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    if ([AWordUser sharedInstance].isLogin && [AWordUser sharedInstance].uid) {
        [dic setObject:[AWordUser sharedInstance].uid forKey:@"uid"];
    }
    NSString* command = [_pro objectForKey:@"command"];
    NSString* version = [CommonUtil getVersion];
    NSString* root = [NSString jsonStringWithDictionary:dic];
    
    NSString* sign = [NSString stringWithFormat:@"%@%@%@%@", command, root, version, Sign_Key];
    sign = [sign md5];
    
    NSDictionary* resultDic = @{@"root":root,
                                @"version":version,
                                @"command":command,
                                @"sign":sign};
    
    return resultDic;
}

@end
