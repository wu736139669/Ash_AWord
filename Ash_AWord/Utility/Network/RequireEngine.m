//
//  RequireEngine.m
//  iOSFramework
//
//  Created by xmfish on 14-9-22.
//  Copyright (c) 2014年 aDu. All rights reserved.
//

#import "RequireEngine.h"
#import "PropertyEntity.h"

#import "MTLJSONAdapter.h"
#import "NSData+Godzippa.h"

#import "EGOCache.h"

@implementation RequireEngine

+ (void)saveCacheWithAPIKey:(NSString *)apiKey property:(PropertyEntity *)proper data:(id)tweet{
    if (proper.isCache) {
        SEL selector = NSSelectorFromString(@"errCode");
        IMP imp = [tweet methodForSelector:selector];
        NSString* (*func)(id, SEL) = (void *)imp;
        NSString *tmpErrCode = func(tweet, selector);
        DLog(@"%@", tmpErrCode);
        
        if ([tmpErrCode isKindOfClass:[NSString class]] && [tmpErrCode isEqualToString:@"0"]) {
            [[EGOCache globalCache] setObject:tweet forKey:apiKey];
            
        }
    }
}

+ (void)responseFromCacheWithAPIKey:(NSString *)apiKey property:(PropertyEntity *)proper completionBlock:(CompletionBlock)completionBlock{
    if (proper.isCache && [[EGOCache globalCache] hasCacheForKey:apiKey]) {
        completionBlock([[EGOCache globalCache] objectForKey:apiKey]);
    }
}

+ (AFHTTPRequestOperation *)requireWithProperty:(PropertyEntity *)proper completionBlock:(CompletionBlock)completionBlock failedBlock:(FailedBlock)failedBlock{
    
    NSString *apiKey = proper.url;
    if (proper.pro && proper.pro[@"page"])
    {
        apiKey = [apiKey stringByAppendingFormat:@"%@",proper.pro[@"page"]];
    }
    
    if (proper.requireType == HTTPRequestTypeWithGET) {
        return [[XiaoYuAPIClient sharedClient] GET:[proper reqURL]
                                        parameters: [proper encodePro]
                                           success:^(AFHTTPRequestOperation * __unused task, id json) {
                                               DLog(@"%@", json);

                                               if(json)
                                               {
                                                   NSError *error = nil;
                                                   id tweet = [MTLJSONAdapter modelOfClass:[proper.responesOBJ class] fromJSONDictionary:json error:&error];
                                                   
                                                   if (completionBlock)
                                                   {
                                                       completionBlock(tweet);
                                                   }
                                                   
                                                   [self saveCacheWithAPIKey:apiKey property:proper data:tweet];
                                               }
                                               else
                                               {
                                                   
                                                   if (completionBlock)
                                                   {
                                                       completionBlock(nil);
                                                   }
                                               }
                                           }
                                           failure:^(AFHTTPRequestOperation *__unused task, NSError *error) {
                                               DLog(@"%@", error.description);
                                               
                                               if (failedBlock)
                                               {
                                                   failedBlock(error);
                                               }else
                                               {
                                                   [MBProgressHUD errorHudWithView:nil label:kNetworkErrorTips hidesAfter:1.0];
                                               }
                                            
                                               [self responseFromCacheWithAPIKey:apiKey property:proper completionBlock:completionBlock];
                                           }];
    } else if(proper.requireType == HTTPRequestTypeWithPOST){
        return [[XiaoYuAPIClient sharedClient] POST:[proper reqURL]
                                        parameters:[proper encodePro]
                                           success:^(AFHTTPRequestOperation * __unused task, id JSON) {
                                               
                                               DLog(@"%@", JSON);
                                               
                                               NSError *error = nil;
                                               id tweet = [MTLJSONAdapter modelOfClass:[proper.responesOBJ class] fromJSONDictionary:JSON error:&error];
                                               
                                               if (completionBlock) {
                                                   completionBlock(tweet);
                                               }
                                               
                                               [self saveCacheWithAPIKey:apiKey property:proper data:tweet];
                                           }
                                           failure:^(AFHTTPRequestOperation *__unused task, NSError *error) {
                                               NSLog(@"%@", error.description);
                                               
                                               if (failedBlock) {
                                                   failedBlock(error);
                                               }
                                               
                                               [self responseFromCacheWithAPIKey:apiKey property:proper completionBlock:completionBlock];
                                           }];
    } else if(proper.requireType == HTTPRequestTypeWithPOSTDATA){
        return [[XiaoYuAPIClient sharedClient] POST:[proper reqURL]
                                         parameters:[proper encodePro]
                          constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                              for (int i = 0; i < proper.pFile.img.count; i++) {
                                                  UIImage *uploadImage = proper.pFile.img[i];
                                                  NSString *proName = [proper.pFile.name stringByAppendingFormat:@"%d", i];
//                                                  NSData* data =  UIImageJPEGRepresentation(uploadImage, 0.5);
//                                                  DLog(@"%ld kB",data.length/(8*1024));
                                                  [formData appendPartWithFileData:UIImageJPEGRepresentation(uploadImage, 0.5) name:proper.pFile.img.count == 1 ? proper.pFile.name : proName fileName:[proName stringByAppendingString:@".jpg" ] mimeType:@"image/jpg"];
                                              }
                                            }
                                            success:^(AFHTTPRequestOperation * __unused task, id JSON) {
                                                
                                                DLog(@"%@", JSON);
                                                
                                                NSError *error = nil;
                                                id tweet = [MTLJSONAdapter modelOfClass:[proper.responesOBJ class] fromJSONDictionary:JSON error:&error];
                                                
                                                if (completionBlock) {
                                                    completionBlock(tweet);
                                                }
                                                
                                                [self saveCacheWithAPIKey:apiKey property:proper data:tweet];
                                            }
                                            failure:^(AFHTTPRequestOperation *__unused task, NSError *error) {
                                                NSLog(@"%@", error.description);
                                                
                                                if (failedBlock) {
                                                    failedBlock(error);
                                                }
                                                
                                                [self responseFromCacheWithAPIKey:apiKey property:proper completionBlock:completionBlock];
                                            }];
    } else {
        NSAssert(proper.requireType == HTTPRequestTypeWithGET || proper.requireType == HTTPRequestTypeWithPOST, @"you must set requireType to GET or POST, or write something");
        return nil;
    }
}

@end
