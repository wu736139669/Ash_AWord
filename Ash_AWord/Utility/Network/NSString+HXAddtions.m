//
//  NSString+HXAddtions.m
//  HXWeb
//
//  Created by hufeng on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+HXAddtions.h"

@implementation NSString (HXAddtions)

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
            ];
}
+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"]; 
    return reString;
}
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
        
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }else if([object isKindOfClass:[NSNumber class]]){
        value = [NSString jsonStringWithString:[object stringValue]];
    }
    return value;
}

+(NSString *) jsonStringWithRTArray:(NSArray *)array{
    NSMutableString *reString = [[NSMutableString alloc] init];
    [reString appendString:@"{"];
    NSMutableArray *values = [[NSMutableArray alloc] initWithArray:array];
    for (int i=0; i<[values count]; i++) {
        NSString *tempString = [values objectAtIndex:i];
        NSString *value = [NSString jsonStringWithString:tempString];
        if (i%2 == 0) {
            [reString appendFormat:@"%@:",value];
        }else{
            if (i == [values count]-1) {
                [reString appendFormat:@"%@",value];
            }else{
                [reString appendFormat:@"%@,",value];
            }
        }
    }
    [reString appendFormat:@"}"];
    return reString;
}
@end