//
//  UpdateViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/8.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

@interface UpdateViewModel : BaseViewModel
@property(assign,nonatomic)NSInteger needUpdate;     //是否需要更新
@property(readonly,nonatomic)NSString* version;
@property(readonly,nonatomic)NSString* version_info;

+ (PropertyEntity *)requireUpdate;
@end
