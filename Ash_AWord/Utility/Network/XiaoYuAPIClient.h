//
//  XiaoYuAPIClient.h
//  iOSFramework
//
//  Created by xmfish on 14-9-22.
//  Copyright (c) 2014年 aDu. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface XiaoYuAPIClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;
+ (NSString *)getApiBaseString;
@end
