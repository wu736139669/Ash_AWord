//
//  RequireEngine.h
//  iOSFramework
//
//  Created by xmfish on 14-9-22.
//  Copyright (c) 2014年 aDu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XiaoYuAPIClient.h"

@class PropertyEntity;

typedef void (^CompletionBlock) (id viewModel);
typedef void (^FailedBlock) (NSError *error);


@interface RequireEngine : NSObject

+ (AFHTTPRequestOperation *)requireWithProperty:(PropertyEntity *)proper completionBlock:(CompletionBlock)completionBlock failedBlock:(FailedBlock)failedBlock;

@end
