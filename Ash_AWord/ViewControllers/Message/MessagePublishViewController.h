//
//  MessagePublishViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/9.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface MessagePublishViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentTextView;
- (IBAction)recordDragUp:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
- (IBAction)recordBtnDown:(id)sender;
- (IBAction)recordBtnClick:(id)sender;
- (IBAction)playBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteRecordClick;
@property (weak, nonatomic) IBOutlet UILabel *nowTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *playProgressView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *recordBgView;
- (IBAction)deleteRecordBtnClick:(id)sender;

@end
