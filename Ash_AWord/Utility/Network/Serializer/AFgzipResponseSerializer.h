//
//  AFgzipResponseSerializer.h
//  iOSFramework
//
//  Created by aDu on 14-10-21.
//  Copyright (c) 2014年 aDu. All rights reserved.
//

#import "AFURLResponseSerialization.h"

@interface AFgzipResponseSerializer : AFHTTPResponseSerializer

/**
 The serializer used to generate requests to be compressed.
 */
@property (readonly, nonatomic, strong) id <AFURLResponseSerialization> serializer;

/**
 Creates and returns an instance of `AFgzipRequestSerializer`, using the specified serializer to generate requests to be compressed.
 */
+ (instancetype)serializerWithSerializer:(id <AFURLResponseSerialization>)serializer;

@end
