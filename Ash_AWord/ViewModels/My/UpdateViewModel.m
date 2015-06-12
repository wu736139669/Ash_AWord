//
//  UpdateViewModel.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/8.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "UpdateViewModel.h"

@implementation UpdateViewModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [dic setObject:@"need_update" forKey:@"needUpdate"];
    [dic setObject:@"version" forKey:@"version"];
    [dic setObject:@"version_info" forKey:@"version_info"];

    return dic;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    // Store a value that needs to be determined locally upon initialization.
    
    return self;
}

+(PropertyEntity*)requireUpdate
{
    
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;

    NSDictionary* dic = @{@"version": [CommonUtil getVersion],
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10001",
                };
    return pro;
}
@end
