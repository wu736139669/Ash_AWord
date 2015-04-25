//
//  ModifyPassWordViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPassWordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNewPswTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondNewPswTextField;
- (IBAction)completeBtnClick:(id)sender;

@end
