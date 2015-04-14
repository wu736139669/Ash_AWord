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
    pro.reqURL = @"rs/text_image/add";
    pro.responesOBJ = self.class;
//    content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    pro.pro = @{@"content": content,
                };
    return pro;
}
@end
