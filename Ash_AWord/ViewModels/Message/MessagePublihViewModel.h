//
//  MessagePublihViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/13.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

@interface MessagePublihViewModel : BaseViewModel

+ (PropertyEntity *)requireAddMessage:(NSString*)content withFile:(NSData*)fileData withTime:(NSInteger)time;
@end
