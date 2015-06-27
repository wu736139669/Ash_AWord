//
//  BaseViewModel.h
//  TheLifeCircle
//
//  Created by xmfish on 14/12/30.
//  Copyright (c) 2014年 小鱼网. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "NSString+HXAddtions.h"
typedef enum {
    Order_by_Time = 0,
    Order_by_Good = 1,
}Order_by;
@interface BaseViewModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSNumber* errCode;
@property (nonatomic, readonly) NSString *errMessage;
@property (nonatomic, readonly) NSInteger notReadCommentNum;//用户发表的所有记录的未读评论总数（每个接口都会返回该项）
@property (nonatomic, readonly) NSInteger myNewFollowerCount;//用户上一次加载关注自己的用户列表之后新关注自己的用户数（每个接口都会返回该项）

- (BOOL)success;

- (BOOL)needLogin;

@end
