//
//  NoteTableViewCell.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "NoteTableViewCell.h"
#import "NoteViewModel.h"
@implementation NoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _contentLabel.font = [UIFont appFontOfSize:14.0];
    _timeLabel.font = [UIFont appFontOfSize:14.0];
    
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)goodBtnClick:(id)sender
{
}

- (IBAction)badBtnClick:(id)sender
{
}

- (IBAction)shareBtnClick:(id)sender
{
}
-(void)setText_Image:(Text_Image *)text_image
{
    CGSize imageSize = _contentImgView.frame.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor colorWithWhite:0.6 alpha:0.5] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    
    _timeLabel.text = text_image.createTime;
    UIFont *font = [UIFont appFontOfSize:14.0];
    CGSize size = CGSizeMake(300*[Ash_UIUtil currentScreenSizeRate],MAXFLOAT);
    
    CGRect labelRect = [text_image.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    _contentHeight.constant = labelRect.size.height;
    _contentLabel.text = text_image.content;
    [_contentImgView sd_setImageWithURL:text_image.imageUrl placeholderImage:pressedColorImg];

}
+(CGFloat)heightWith:(Text_Image *)text_image
{
    UIFont *font = [UIFont appFontOfSize:14.0];
    CGSize size = CGSizeMake(300*[Ash_UIUtil currentScreenSizeRate],MAXFLOAT);
    
    CGRect labelRect = [text_image.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    CGSize imageSize = [Ash_UIUtil downloadImageSizeWithURL:text_image.imageUrl];
    CGFloat imageHeight = imageSize.height;
    if (imageHeight!=0 &&imageSize.width!=0) {
        imageHeight = imageHeight/(imageSize.width/(304*[Ash_UIUtil currentScreenSizeRate]));
    }
    return imageHeight+labelRect.size.height+85;
}
@end
