//
//  UpdateViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/8.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

@interface UpdateViewModel : BaseViewModel
@property(assign,nonatomic)BOOL update;
@property(readonly,nonatomic)NSString* version;
@property(readonly,nonatomic)NSString* version_info;

+ (PropertyEntity *)requireUpdate;
@end
