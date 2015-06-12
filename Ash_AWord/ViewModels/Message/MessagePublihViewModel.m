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
    pro.responesOBJ = self.class;
    NSDictionary* dic = @{@"content": content,
                          @"voiceLength":[NSNumber numberWithInteger:time],
                          };
    pro.pro = @{@"root": dic,
                @"command": @"30001",
                };
    return pro;
}

@end
