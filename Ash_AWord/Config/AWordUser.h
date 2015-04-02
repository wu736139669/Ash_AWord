//
//  AWordUser.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWordUser : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString* userGender;
+(AWordUser*)sharedInstance;

@end
