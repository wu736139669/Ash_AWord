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
    [dic setObject:@"friends" forKey:@"friendUserArr"];
    [dic setObject:@"userinfo" forKey:@"userInfo"];
    [dic setObject:@"userBaseInfos" forKey:@"userBaseInfoArr"];
    return dic;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self != nil){
        if (_friendUserArr && !_userInfoArr) {
            _userInfoArr = _friendUserArr;
        }
    };
    
    return self;
}
+ (NSValueTransformer *)userBaseInfoArrJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:UserInfoViewModel.class];
}
+ (NSValueTransformer *)userInfoArrJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:UserInfoViewModel.class];
}
+ (NSValueTransformer *)friendUserArrJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:UserInfoViewModel.class];
}
+ (NSValueTransformer *)userInfoJSONTransformer{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:UserInfoViewModel.class];
}
+(PropertyEntity*)requireLoadPraiseUserWithRecordId:(NSInteger)recordId withPage:(NSInteger)page withPage_size:(NSInteger)page_size withType:(CommentType)type
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;

    
    NSDictionary* dic = @{@"recordId": [NSString stringWithFormat:@"%ld",recordId],
                          @"page": [NSString stringWithFormat:@"%ld",page],
                          @"pageSize": [NSString stringWithFormat:@"%ld",page_size],
                          };
    
    NSString* command = @"20008";
    if (type == Voice_Type) {
        command = @"30008";
    }
    pro.pro = @{@"root": dic,
                @"command": command,
                };
    return pro;
}
+(PropertyEntity*)requireUserInfoWithTargetUid:(NSString *)targetUid
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    
    
    NSDictionary* dic = @{@"targetUid": targetUid,
                          };
    pro.pro = @{@"root": dic,
                @"command": @"10009",
                };
    return pro;
}

+(PropertyEntity*)requireAttentionWithTargetUid:(NSString *)targetUid withIsAttention:(BOOL)isAttention
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    
    NSString* command = @"10101";
    if (!isAttention) {
        command = @"10102";
    }
    NSDictionary* dic = @{@"targetUid": targetUid,
                          };
    pro.pro = @{@"root": dic,
                @"command": command,
                };
    return pro;
}
+(PropertyEntity*)requireLoadUserListWithTargetUid:(NSString *)targetUid withType:(NSInteger)isAttention withPage:(NSInteger)page withPage_size:(NSInteger)page_size
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    
    
    NSDictionary* dic = @{@"targetUid": targetUid,
                          @"page": [NSString stringWithFormat:@"%ld",page],
                          @"pageSize": [NSString stringWithFormat:@"%ld",page_size],
                          };
    NSString* command = @"10103";
    if (isAttention == 2) {
        command = @"10104";
    }
    pro.pro = @{@"root": dic,
                @"command": command,
                };
    return pro;
}
+(PropertyEntity*)requireNewUserList
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    
    
    NSDictionary* dic = @{
                          @"page": [NSString stringWithFormat:@"%d",1],
                          @"pageSize": [NSString stringWithFormat:@"%d",100],
                          };
    NSString* command = @"10106";

    pro.pro = @{@"root": dic,
                @"command": command,
                };
    return pro;
}
+(PropertyEntity*)requireUserListWithUid:(NSArray *)uidArr
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    pro.responesOBJ = self.class;
    
    if (uidArr.count == 0) {
        uidArr = [NSArray array];
    }
    NSDictionary* dic = @{@"targetUids": uidArr,
                          };
    NSString* command = @"10010";

    pro.pro = @{@"root": dic,
                @"command": command,
                };
    return pro;
}
@end