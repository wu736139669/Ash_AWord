//
//  NotePublishViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

@interface NotePublishViewModel : BaseViewModel

+ (PropertyEntity *)requireAddNote:(NSString*)content withImage:(UIImage*)image;
@end
