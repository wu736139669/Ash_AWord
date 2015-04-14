//
//  MessagePublihViewModel.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/13.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MessagePublihViewModel.h"

@implementation MessagePublihViewModel

+(PropertyEntity*)requireAddMessage:(NSString *)content withFile:(NSData *)fileData withTime:(NSInteger)time
{
    PropertyEntity *pro = [[PropertyEntity alloc] init];
    pro.requireType = HTTPRequestTypeWithPOSTDATA;
    proFile *file = [[proFile alloc] init];
    file.name = @"wav";
    file.img = [NSArray arrayWithObject:fileData];;
    pro.pFile = file;
    pro.reqURL = @"rs/text_voice/add";
    pro.responesOBJ = self.class;
    //    content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    pro.pro = @{@"content": content,
                @"voiceLength":[NSNumber numberWithInteger:time],
                };
    return pro;
}

@end
