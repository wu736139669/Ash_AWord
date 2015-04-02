//
//  NoteTableViewCell.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "NoteTableViewCell.h"
#import "NoteViewModel.h"
#import "AppDelegate.h"
#import "MWPhotoBrowser.h"
@interface NoteTableViewCell()<MWPhotoBrowserDelegate>
@end
@implementation NoteTableViewCell
{
    Text_Image* _text_image;
}
- (void)awakeFromNib {
    // Initialization code
    _contentLabel.font = [UIFont appFontOfSize:14.0];
    _contentTextView.font = [UIFont appFontOfSize:14.0];
    _contentTextView.scrollEnabled = NO;
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
    _text_image = text_image;
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
    _contentHeight.constant = labelRect.size.height+25;
    _contentTextView.text = text_image.content;
    [_contentImgView sd_setImageWithURL:text_image.imageUrl placeholderImage:pressedColorImg];

}
+(CGFloat)heightWith:(Text_Image *)text_image
{
    UIFont *font = [UIFont appFontOfSize:14.0];
    CGSize size = CGSizeMake(300*[Ash_UIUtil currentScreenSizeRate],MAXFLOAT);
    
    
    CGRect labelRect = [text_image.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    
    CGSize imageSize = [Ash_UIUtil downloadImageSizeWithURL:text_image.imageUrl];
//    CGSize imageSize = CGSizeMake(320, 600);
    CGFloat imageHeight = imageSize.height;
    if (imageHeight!=0 &&imageSize.width!=0)
    {
        imageHeight = imageHeight/(imageSize.width/(304*[Ash_UIUtil currentScreenSizeRate]));
    }
    return imageHeight+labelRect.size.height+95;
}
- (IBAction)imageBtnClick:(id)sender {
    
    MWPhotoBrowser *pBrowser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    //是否显示分享按钮
    pBrowser.displayActionButton = YES;
    //左右分页切换
    pBrowser.displayNavArrows = YES;
    //是否显示选择按钮
    pBrowser.displaySelectionButtons = NO;
    //是否显示条件控制控件
    pBrowser.alwaysShowControls = YES;
    //是否全屏
    pBrowser.zoomPhotosToFill = YES;
    
    //允许使用网络查看所有图片
    pBrowser.enableGrid = YES;
    //是否第一张
    pBrowser.startOnGrid = YES;
    pBrowser.enableSwipeToDismiss = YES;
    [pBrowser showNextPhotoAnimated:YES];
    [pBrowser showPreviousPhotoAnimated:YES];
    [pBrowser setCurrentPhotoIndex:0];
    [[AppDelegate visibleViewController].navigationController pushViewController:pBrowser animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}

-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [[MWPhoto alloc]initWithURL:_text_image.imageUrl];
    return photo;
}

@end
