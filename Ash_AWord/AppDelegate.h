//
//  AppDelegate.h
//  Ash_AWord
//
//  Created by xmfish on 15/3/26.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    MainViewController* _mainViewController;

}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController* mainViewController;


/**
 * 当前可视viewController
 */
+ (UIViewController *)visibleViewController;

@end

