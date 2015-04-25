//
//  MessageViewModel.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/13.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MessageViewModel.h"
@implementation Text_Voice
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content": @"content",
             @"createTime": @"createTime",
             @"hasPraised" : @"hasPraised",
             @"messageId": @"id",
             @"voiceUrl" : @"voiceUrl",
             @"ownerId" : @"ownerId",
             @"praiseCount": @"praiseCount",
             @"voiceLength" : @"voiceInfo.voiceLength",
             @"ownerFigureurl" : @"ownerFigureurl",
             @"ownerName" : @"ownerName",
             @"shareCount": @"shareCount",
             @"hasShared": @"hasShared",
             };
}
+ (NSValueTransformer *)voiceUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
+ (NSValueTransformer *)ownerFigureurlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    //    self.content = [self.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // Store a value that needs to be determined locally upon initialization.
    
    return self;
}
@end

@implementation MessageViewModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [dic setObject:@"text_voices" forKey:@"text_voicesArr"];
    return dic;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}
+ (NSValueTransformer *)text_voicesArrJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Text_Voice.class];
}

+(PropertyEntity*)requireWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.reqURL = @"rs/text_voice/load_public";
    pro.responesOBJ = self.class;
    pro.pro = @{@"order_by": [NSString stringWithFormat:@"%u",order_by],
                @"page": [NSString stringWithFormat:@"%ld",page],
                @"page_size": [NSString stringWithFormat:@"%ld",page_size],
                };
    
    return pro;
}

+(PropertyEntity*)requireOhterWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size withOtherId:(NSString *)otherid
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.reqURL = @"rs/text_voice/load_others";
    pro.responesOBJ = self.class;
    pro.pro = @{@"order_by": [NSString stringWithFormat:@"%u",order_by],
                @"page": [NSString stringWithFormat:@"%ld",page],
                @"page_size": [NSString stringWithFormat:@"%ld",page_size],
                @"target_uid": otherid
                };
    
    return pro;
}
+(PropertyEntity*)requireMyWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.reqURL = @"rs/text_voice/load_my";
    pro.responesOBJ = self.class;
    pro.pro = @{@"order_by": [NSString stringWithFormat:@"%u",order_by],
                @"page": [NSString stringWithFormat:@"%ld",page],
                @"page_size": [NSString stringWithFormat:@"%ld",page_size],
                };
    
    return pro;
}
+(PropertyEntity*)requirePraiseWithRecordId:(NSInteger)recordId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.reqURL = @"rs/text_voice/praise";
    pro.responesOBJ = self.class;
    pro.pro = @{
                @"record_id": [NSString stringWithFormat:@"%ld",recordId],
                
                };
    
    return pro;
}
+(PropertyEntity*)requireShareWithRecordId:(NSInteger)recordId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.reqURL = @"rs/text_voice/share";
    pro.responesOBJ = self.class;
    pro.pro = @{
                @"record_id": [NSString stringWithFormat:@"%ld",recordId],
                
                };
    
    return pro;
}
+(PropertyEntity*)requireDelWithRecordId:(NSInteger)recordId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.reqURL = @"rs/text_voice/del";
    pro.responesOBJ = self.class;
    pro.pro = @{
                @"record_id": [NSString stringWithFormat:@"%ld",recordId],
                
                };
    
    return pro;
}
@end
