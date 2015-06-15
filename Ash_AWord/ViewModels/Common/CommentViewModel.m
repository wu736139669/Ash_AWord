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
             @"commentType": @"type",
             @"toUserId":@"toUserId",
             @"toUserName":@"toUserName",
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

+(PropertyEntity*)requireAddCommentWithReconrdId:(NSInteger)recordId withContent:(NSString *)content WithType:(CommentType)commentType withToUid:(NSString *)otherId
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{
                          @"recordId": [NSString stringWithFormat:@"%ld",recordId],
                          @"content": content,
                          @"type" : [NSString stringWithFormat:@"%u",commentType],
                          @"toUserId": otherId,
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10201",
                };
    return pro;
}
+(PropertyEntity*)requireLoadCommentWithRecordId:(NSInteger)recordId withPage:(NSInteger)page withPage_size:(NSInteger)page_size WithType:(CommentType)commentType
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"recordId": [NSString stringWithFormat:@"%ld",recordId],
                          @"page": [NSString stringWithFormat:@"%ld",page],
                          @"pageSize": [NSString stringWithFormat:@"%ld",page_size],
                          @"type" : [NSString stringWithFormat:@"%u",commentType],
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10203",
                };
    return pro;
}
@end
