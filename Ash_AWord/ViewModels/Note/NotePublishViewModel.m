//
//  NotePublishViewModel.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "NotePublishViewModel.h"

@implementation NotePublishViewModel


+(PropertyEntity*)requireAddNote:(NSString *)content withImage:(UIImage *)image
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    proFile *file = [[proFile alloc] init];
    file.name = @"img";
    file.img = [NSArray arrayWithObject:image];
    pro.pFile = file;
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"content": content,
                          };
    pro.pro = @{@"root": dic,
                @"command": @"20001",
                };
    return pro;
}
@end
