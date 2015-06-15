//
//  CommentTextView.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/4.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommentComplete)(void);

@interface CommentTextView : UIView

@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, strong) NSString* aothourId;
@property (nonatomic, strong) CommentComplete comentComplete;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)sendBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;

- (IBAction)bgBtnClick:(id)sender;

-(void)showWithUid:(NSString*)uid;;
-(void)hide;
@end
