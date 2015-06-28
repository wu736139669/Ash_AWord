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
             @"commentCount": @"commentCount",
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
    [dic setObject:@"text_voice" forKey:@"text_voice"];

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
+ (NSValueTransformer *)text_voiceJSONTransformer{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Text_Voice.class];
}
+(PropertyEntity*)requireWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size withType:(NSInteger)type
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"orderBy": [NSString stringWithFormat:@"%u",order_by],
                          @"page": [NSString stringWithFormat:@"%ld",(long)page],
                          @"pageSize": [NSString stringWithFormat:@"%ld",(long)page_size],
                          };
    
    NSString* command = @"30004";
    if (type == 1) {
        command = @"30009";
    }
    pro.pro = @{@"root": dic,
                @"command": command,
                };
    
    return pro;
}

+(PropertyEntity*)requireOhterWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size withOtherId:(NSString *)otherid
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"orderBy": [NSString stringWithFormat:@"%u",order_by],
                          @"page": [NSString stringWithFormat:@"%ld",page],
                          @"pageSize": [NSString stringWithFormat:@"%ld",page_size],
                          @"targetUid": otherid
                          };
    pro.pro = @{@"root": dic,
                @"command": @"30003",
                };
    
    return pro;
}
+(PropertyEntity*)requireMyWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"orderBy": [NSString stringWithFormat:@"%u",order_by],
                          @"page": [NSString stringWithFormat:@"%ld",page],
                          @"pageSize": [NSString stringWithFormat:@"%ld",page_size],
                          };
    pro.pro = @{@"root": dic,
                @"command": @"30002",
                };
    
    return pro;
}
+(PropertyEntity*)requirePraiseWithRecordId:(NSInteger)recordId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{
                          @"recordId": [NSString stringWithFormat:@"%ld",recordId],
                          
                          };
    pro.pro = @{@"root": dic,
                @"command": @"30005",
                };
    
    return pro;
}
+(PropertyEntity*)requireShareWithRecordId:(NSInteger)recordId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{
                          @"recordId": [NSString stringWithFormat:@"%ld",recordId],
                          
                          };
    pro.pro = @{@"root": dic,
                @"command": @"30007",
                };
    
    return pro;
}
+(PropertyEntity*)requireDelWithRecordId:(NSInteger)recordId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{
                          @"recordId": [NSString stringWithFormat:@"%ld",recordId],
                          
                          };
    pro.pro = @{@"root": dic,
                @"command": @"30006",
                };
    
    return pro;
}
+(PropertyEntity*)requireMessageWithRecordId:(NSInteger)recordId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    pro.isCache = YES;
    pro.cacheKey = [NSString stringWithFormat:@"30010-%ld",recordId];
    NSDictionary* dic = @{
                          @"recordId": [NSString stringWithFormat:@"%ld",recordId],
                          
                          };
    pro.pro = @{@"root": dic,
                @"command": @"30010",
                };
    
    return pro;
}
@end
