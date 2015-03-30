//
//  XiaoYuAPIClient.m
//  iOSFramework
//
//  Created by xmfish on 14-9-22.
//  Copyright (c) 2014年 aDu. All rights reserved.
//

#import "XiaoYuAPIClient.h"

#import "AFgzipResponseSerializer.h"

#import "AFURLRequestSerialization.h"

@implementation XiaoYuAPIClient



+ (instancetype)sharedClient
{
    static XiaoYuAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[XiaoYuAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[self getApiBaseString]]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        [_sharedClient.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
//        [_sharedClient.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        
//        [_sharedClient.requestSerializer setValue:@"identity" forHTTPHeaderField:@"Accept-Encoding"];
        
//        _sharedClient.responseSerializer = [AFgzipResponseSerializer serializerWithSerializer:[AFHTTPResponseSerializer serializer]];
//
//        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
//        [_sharedClient.responseSerializer setValue:@"gizp" forKey:@"Content-Encoding"];
//        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
    });
    
    return _sharedClient;
}

+ (NSString *)getApiBaseString
{
    return  Ash_AWord_API_URL;
}

@end
