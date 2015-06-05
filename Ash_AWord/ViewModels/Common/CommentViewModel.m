//
//  CommentViewModel.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/5.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "CommentViewModel.h"

@implementation CommentInfoViewModel
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
@end
@implementation CommentViewModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [dic setObject:@"comments" forKey:@"commentInfoArr"];
    return dic;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}
+ (NSValueTransformer *)commentInfoArrJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CommentInfoViewModel.class];
}

+(PropertyEntity*)requireAddCommentWithReconrdId:(NSInteger)recordId withContent:(NSString *)content
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOST;
    pro.reqURL = @"rs/text_image/add_comment";
    pro.responesOBJ = self.class;
    pro.pro = @{
                @"record_id": [NSString stringWithFormat:@"%ld",recordId],
                @"content": content,
                };
    
    return pro;
}
+(PropertyEntity*)requireLoadCommentWithRecordId:(NSInteger)recordId withPage:(NSInteger)page withPage_size:(NSInteger)page_size
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithGET;
    pro.reqURL = @"rs/text_image/load_comment";
    pro.responesOBJ = self.class;
    pro.pro = @{@"record_id": [NSString stringWithFormat:@"%ld",recordId],
                @"page": [NSString stringWithFormat:@"%ld",page],
                @"page_size": [NSString stringWithFormat:@"%ld",page_size],
                };
    
    return pro;
}
@end
