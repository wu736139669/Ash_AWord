//
//  PropertyEntity.m
//  iOSFramework
//
//  Created by xmfish on 14-9-22.
//  Copyright (c) 2014年 aDu. All rights reserved.
//

#import "PropertyEntity.h"
#import "XMFishBaseCode.h"

@implementation proFile

@end

@implementation PropertyEntity

- (NSDictionary *)encodePro
{
//    XMFishBaseCode *bc = [[XMFishBaseCode alloc] init];
//    
//    [bc setToken:nil];
//    [bc setCallback:_url];
//    if (_pro)
//    {
//        [bc setParams:[NSMutableDictionary dictionaryWithDictionary:_pro]];
//    }
//    
//    NSMutableString *key = [[NSMutableString alloc]initWithString:[bc getBaseCode]];
//    [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dic = @{@"mkey":key};

    NSMutableDictionary* dic;
    if (_pro) {
        dic = [NSMutableDictionary dictionaryWithDictionary:_pro];
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    if ([AWordUser sharedInstance].isLogin && [AWordUser sharedInstance].uid) {
        [dic setObject:[AWordUser sharedInstance].uid forKey:@"uid"];

    }
    return dic;
}

@end
