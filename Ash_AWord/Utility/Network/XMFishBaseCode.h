//
//  XMFishBaseCode.h
//  FanLiKa
//
//  Created by aDu on 14-10-23.
//  Copyright (c) 2014年 xmfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMFishBaseCode : NSObject

@property (nonatomic, strong, readwrite) NSString *token;
@property (nonatomic, strong, readwrite) NSString *callback;
@property (nonatomic, strong, readwrite) NSMutableDictionary *params;

@property (nonatomic, strong, readwrite) NSString *uid;
@property (nonatomic, strong, readwrite) NSString *username;
@property (nonatomic, strong, readwrite) NSString *cityId;

@property (nonatomic, strong, readwrite) NSString *mobile;

- (NSString *)getBaseCode;

+ (NSString *)getWkey;

@end
