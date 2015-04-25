//
//  RegistAccountViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstPassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondPassWordTextField;

- (IBAction)nextBtnClick:(id)sender;
- (IBAction)userNoticeBtnClick:(id)sender;

@end
