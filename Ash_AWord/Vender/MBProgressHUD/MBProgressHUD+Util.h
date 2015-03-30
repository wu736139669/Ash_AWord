//
//  MBProgressHUD+Util.h
//  ManagerDemo
//
//  Created by xmfish on 14-8-12.
//  Copyright (c) 2014年 ash. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Util)
/**
 * Finds all HUD subviews and returns them.
 *
 * @param view The view that is going to be searched.
 * @return All found HUD views (array of MBProgressHUD objects).
 */

+ (void)hudWithView:(UIView *)view label:(NSString *)msg;

+ (void)errorHudWithView:(UIView *)view label:(NSString *)msg hidesAfter:(NSTimeInterval)delay;

+ (void)checkHudWithView:(UIView *)view label:(NSString *)msg hidesAfter:(NSTimeInterval)delay;
@end
