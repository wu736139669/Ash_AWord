//
//  LoginViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/3/30.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

@interface LoginViewModel : BaseViewModel

@property (nonatomic, strong) NSString* uId; //用户id。

+ (PropertyEntity *)requireLoginWithOpenId:(NSString*)openId withName:(NSString*)name withGender:(NSString*)gender withFigureUrl:(NSString*)figureUrl;
@end
