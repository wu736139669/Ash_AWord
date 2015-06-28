//
//  NoteViewModel.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "NoteViewModel.h"
@implementation Text_Image
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content": @"content",
             @"createTime": @"createTime",
             @"hasPraised" : @"hasPraised",
             @"messageId": @"id",
             @"imageUrl" : @"imageUrl",
             @"ownerId" : @"ownerId",
             @"praiseCount": @"praiseCount",
             @"imageWidth" : @"imageInfo.width",
             @"imageHeight" : @"imageInfo.height",
             @"ownerFigureurl" : @"ownerFigureurl",
             @"ownerName" : @"ownerName",
             @"shareCount": @"shareCount",
             @"hasShared": @"hasShared",
             @"commentCount": @"commentCount"
             };
}
+ (NSValueTransformer *)imageUrlJSONTransformer {
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

@implementation NoteViewModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [dic setObject:@"text_images" forKey:@"text_imagesArr"];
    [dic setObject:@"text_image" forKey:@"text_image"];
    return dic;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}
+ (NSValueTransformer *)text_imagesArrJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Text_Image.class];
}

+ (NSValueTransformer *)text_imageJSONTransformer{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Text_Image.class];
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
    NSString* command = @"20004";
    if (type == 1) {
        command = @"20009";
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
                @"command": @"20003",
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
                @"command": @"20002",
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
                @"command": @"20005",
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
                @"command": @"20007",
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
                @"command": @"20006",
                };
    
    return pro;
}

+(PropertyEntity*)requireNoteWithRecordId:(NSInteger)recordId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    pro.isCache = YES;
    pro.cacheKey = [NSString stringWithFormat:@"20010-%ld",recordId];
    NSDictionary* dic = @{
                          @"recordId": [NSString stringWithFormat:@"%ld",recordId],
                          
                          };
    pro.pro = @{@"root": dic,
                @"command": @"20010",
                };
    return pro;
}

@end
