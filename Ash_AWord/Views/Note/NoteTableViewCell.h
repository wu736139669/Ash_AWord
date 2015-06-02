//
//  NoteTableViewCell.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NoteTableViewCellDelegate<NSObject>
-(void) reportWithIndex:(NSInteger)index;
@end

@class Text_Image;
@interface NoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;
@property (weak, nonatomic)id<NoteTableViewCellDelegate>delegate;
- (IBAction)closeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
- (IBAction)avatarBtnClick:(id)sender;

- (IBAction)imageBtnClick:(id)sender;


- (IBAction)goodBtnClick:(id)sender;
- (IBAction)badBtnClick:(id)sender;
- (IBAction)shareBtnClick:(id)sender;

-(void)setText_Image:(Text_Image*)text_image;
+(CGFloat)heightWith:(Text_Image*)text_image;
@end
