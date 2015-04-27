//
//  FeedbackViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/27.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface FeedbackViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentTextView;
- (IBAction)completeBtnClick:(id)sender;

@end
