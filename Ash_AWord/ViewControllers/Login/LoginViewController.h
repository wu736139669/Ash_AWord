//
//  LoginViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/3/31.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UINavigationControllerDelegate>
- (IBAction)qqLoginBtnClick:(id)sender;
- (IBAction)sianLoginBtnClick:(id)sender;
- (IBAction)weixinLoginBtnClick:(id)sender;
- (IBAction)closeBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (strong, nonatomic)void (^loginSuccessBlock)();

@property (weak, nonatomic) IBOutlet UIButton *wxBtn;

+ (LoginViewController *)shareLoginViewController;


+ (void)presentLoginViewControllerInView:(UIViewController *)vc success:(void (^)(void))completion;
@end
