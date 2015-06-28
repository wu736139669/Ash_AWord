//
//  TypeSelectBgView.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/28.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeSelectBgView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
- (IBAction)allBtnClick:(id)sender;
- (IBAction)bgBtnClick:(id)sender;
- (IBAction)attentionBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property(nonatomic, assign)NSInteger typeIndex;
-(void)show;
-(void)hide;
@end
