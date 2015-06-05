//
//  UserInfoViewModel.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/4.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "UserViewModel.h"

@implementation UserInfoViewModel



@end

@implementation UserViewModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [dic setObject:@"users" forKey:@"userInfoArr"];
    return dic;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}
+ (NSValueTransformer *)userInfoArrJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:UserInfoViewModel.class];
}
+(PropertyEntity*)requireLoadPraiseUserWithRecordId:(NSInteger)recordId withPage:(NSInteger)page withPage_size:(NSInteger)page_size
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.reqURL = @"rs/text_image/load_praise_user";
    pro.responesOBJ = self.class;
    pro.pro = @{@"record_id": [NSString stringWithFormat:@"%ld",recordId],
                @"page": [NSString stringWithFormat:@"%ld",(long)page],
                @"page_size": [NSString stringWithFormat:@"%ld",(long)page_size],
                };
    
    return pro;
}

@end