//
//  SetUserInfoViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
@interface SetUserInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *signatureTextView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
- (IBAction)avatarBtnClick:(id)sender;

@end
