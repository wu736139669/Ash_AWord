//
//  BaseViewModel.h
//  TheLifeCircle
//
//  Created by xmfish on 14/12/30.
//  Copyright (c) 2014年 小鱼网. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface BaseViewModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger errCode;
@property (nonatomic, readonly) NSString *errMessage;

- (BOOL)success;

- (BOOL)needLogin;

@end
