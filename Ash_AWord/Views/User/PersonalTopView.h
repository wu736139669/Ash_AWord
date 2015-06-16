//
//  PersonalTopView.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/10.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^IsSelectImage)(BOOL);

@class UserViewModel;
@interface PersonalTopView : UIView
@property (strong, nonatomic)IsSelectImage isSelectImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
- (IBAction)avatarBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
- (IBAction)voiceBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
- (IBAction)imageBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionCountLabel;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Width;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line3Height;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2Width;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
- (IBAction)attentionBtnClick:(id)sender;

-(void)setuserInfoViewModel:(UserViewModel*)userViewModel;
@end
