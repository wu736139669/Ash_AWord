//
//  RegistInfoViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
- (IBAction)avatarBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end
