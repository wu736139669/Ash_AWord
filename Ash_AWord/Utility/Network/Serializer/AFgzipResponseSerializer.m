//
//  AFgzipResponseSerializer.m
//  iOSFramework
//
//  Created by aDu on 14-10-21.
//  Copyright (c) 2014年 aDu. All rights reserved.
//

#import "AFgzipResponseSerializer.h"

#import "NSData+Godzippa.h"

@interface AFgzipResponseSerializer ()
@property (readwrite, nonatomic, strong) id <AFURLResponseSerialization> serializer;
@end

@implementation AFgzipResponseSerializer

+ (instancetype)serializerWithSerializer:(id<AFURLResponseSerialization>)serializer {
    AFgzipResponseSerializer *gzipSerializer = [self serializer];
    gzipSerializer.serializer = serializer;
    
    return gzipSerializer;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error{
    
    NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
    NSDictionary *headers = httpURLResponse.allHeaderFields;
    NSString *gzipStr = headers[@"Content-Encoding"];
//    NSString *identity = headers[@"Transfer-Encoding"];
    
    NSError *serializationError = nil;
    NSDictionary *json = nil;
    
    if ([gzipStr isEqualToString:@"gzip"]) {
#ifdef DEBUG
        NSData *decompressedData = [data dataByGZipDecompressingDataWithError:nil];
        if (decompressedData) {
            NSLog(@"%@", [NSString stringWithUTF8String:[decompressedData bytes]]);

        }
#endif
        
        if (!serializationError && data) {
            NSError *decompressionError;
            
            NSData *decompressedData = [data dataByGZipDecompressingDataWithError:&decompressionError];
            
            if (!decompressionError && decompressedData) {
                NSError *serializationJSONError;
                json = [NSJSONSerialization JSONObjectWithData:decompressedData
                                                       options:kNilOptions
                                                         error:&serializationJSONError];
                
                if (!serializationJSONError && json) {
                    return json;
                } else {
                    if (error) {
                        *error = serializationJSONError;
                    }
                }
            } else {
                if (error) {
                    *error = decompressionError;
                }
            }
        } else {
            if (error) {
                *error = serializationError;
            }
        }
        
        return json;
    } else {
        
        NSError *serializationJSONError;
        json = [NSJSONSerialization JSONObjectWithData:data
                                               options:kNilOptions
                                                 error:&serializationJSONError];
        
        if (!serializationJSONError && json) {
            return json;
        } else {
            if (error) {
                *error = serializationJSONError;
            }
        }

        return json;
    }
}

#pragma mark - NSCoder

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.serializer = [decoder decodeObjectForKey:NSStringFromSelector(@selector(serializer))];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.serializer forKey:NSStringFromSelector(@selector(serializer))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    AFgzipResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.serializer = self.serializer;
    
    return serializer;
}

@end
