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

- (BOOL)success;

- (BOOL)needLogin;

@end
