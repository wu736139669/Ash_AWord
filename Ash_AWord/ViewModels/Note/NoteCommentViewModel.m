//
//  NoteCommentViewModel.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/2.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "NoteCommentViewModel.h"

@implementation NoteCommentInfoViewModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content": @"content",
             @"createTime": @"createTime",
             @"commentId": @"id",
             @"ownerId" : @"ownerId",
             @"ownerFigureurl" : @"ownerFigureurl",
             @"ownerName" : @"ownerName",
             };
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
@implementation NoteCommentViewModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [dic setObject:@"comments" forKey:@"commentArr"];
    return dic;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}
+ (NSValueTransformer *)commentArrJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:NoteCommentInfoViewModel.class];
}


+(PropertyEntity*)requireLoadWithPage:(NSInteger)page withPage_size:(NSInteger)page_size withRecordId:(NSString *)recordId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.reqURL = @"rs/text_image/load_comment";
    pro.responesOBJ = self.class;
    pro.pro = @{@"record_id": recordId,
                @"page": [NSString stringWithFormat:@"%ld",(long)page],
                @"page_size": [NSString stringWithFormat:@"%ld",(long)page_size],
                };
    
    return pro;
}
+(PropertyEntity*)requireAddwithRecordId:(NSString *)recordId withContent:(NSString *)content
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    
    NSDictionary* dic = @{@"recordId": recordId,
                          @"content": content,
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10201",
                };
    return pro;
}
@end
