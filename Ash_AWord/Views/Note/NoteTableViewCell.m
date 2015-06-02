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
#import "SetUpViewController.h"
#import "MyNoteViewController.h"
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
//    _timeLabel.font = [UIFont appFontOfSize:14.0];
    
    _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
    _avatar.layer.masksToBounds = YES;
    
    _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImgView.clipsToBounds  = YES;
    
    _goodBtn.layer.cornerRadius = 3;
    _goodBtn.layer.masksToBounds = YES;
    _shareBtn.layer.cornerRadius = 3;
    _shareBtn.layer.masksToBounds = YES;
    _goodBtn.backgroundColor = [UIColor lineColor];
    _shareBtn.backgroundColor = [UIColor lineColor];
    
    _badBtn.layer.cornerRadius = 3;
    _badBtn.layer.masksToBounds = YES;
    _badBtn.backgroundColor = [UIColor lineColor];
    
    _imageWidth.constant = kScreenWidth-16.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)goodBtnClick:(id)sender
{
    
    if (![AWordUser sharedInstance].isLogin)
    {
        [LoginViewController presentLoginViewControllerInView:nil success:nil];
        return;
    }
    
//    _goodBtn.enabled = NO;
    if (_goodBtn.selected) {
        [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",_text_image.praiseCount-1] forState:UIControlStateNormal];
        [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",_text_image.praiseCount-1] forState:UIControlStateSelected];
    }else{
        [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",_text_image.praiseCount+1] forState:UIControlStateNormal];
        [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",_text_image.praiseCount+1] forState:UIControlStateSelected];
    }
    [self setGoodBtnSelect:!_goodBtn.selected];

    PropertyEntity* pro = [NoteViewModel requirePraiseWithRecordId:_text_image.messageId];
    Text_Image* tempTI = _text_image;
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        NoteViewModel* noteViewModel = (NoteViewModel*)viewModel;
        _goodBtn.enabled = YES;
        if ([noteViewModel success]) {
            
            if (tempTI.hasPraised) {
                tempTI.hasPraised = NO;
                tempTI.praiseCount--;
            }else{
                tempTI.hasPraised = YES;
                tempTI.praiseCount++;
            }
            
        }else{
            [MBProgressHUD errorHudWithView:nil label:noteViewModel.errMessage hidesAfter:1.0];
            [self setGoodBtnSelect:!_goodBtn.selected];
        }
    } failedBlock:^(NSError *error) {
        _goodBtn.enabled = YES;
        [self setGoodBtnSelect:!_goodBtn.selected];
        [MBProgressHUD errorHudWithView:nil label:kNetworkErrorTips hidesAfter:1.0];
    }];
}
-(void)setGoodBtnSelect:(BOOL)isSelect
{
    if (isSelect) {
        _goodBtn.selected = YES;
        _goodBtn.backgroundColor = [UIColor lineColor];

    }else{
        _goodBtn.selected = NO;
        _goodBtn.backgroundColor = [UIColor lineColor];
    }
}
- (IBAction)badBtnClick:(id)sender
{
}

- (IBAction)shareBtnClick:(id)sender
{
    [SetUpViewController shareAppWithViewController:nil andTitle:@"遇见你" andContent:_text_image.content andImage:_contentImgView.image andUrl:[NSString stringWithFormat:@"%@/web/image_share_info?record_id=%ld",Ash_AWord_API_URL,(long)_text_image.messageId]];
    PropertyEntity* pro = [NoteViewModel requireShareWithRecordId:_text_image.messageId];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        if ([viewModel success]) {
            _text_image.shareCount++;
        }
    } failedBlock:^(NSError *error) {
    }];

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

    _userName.text = text_image.ownerName;
    
    [_avatar sd_setImageWithURL:text_image.ownerFigureurl placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    _timeLabel.text = [CommonUtil timeFromtimeSp:text_image.createTime.stringValue];
    _timeLabel.hidden = NO;
    UIFont *font = [UIFont appFontOfSize:14.0];
    CGSize size = CGSizeMake(kScreenWidth-16.0,MAXFLOAT);
    
    CGRect labelRect = [text_image.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    _contentHeight.constant = labelRect.size.height+25;
    _contentTextView.text = text_image.content;
    [_contentImgView sd_setImageWithURL:text_image.imageUrl placeholderImage:pressedColorImg];
    
    [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",(long)text_image.praiseCount] forState:UIControlStateNormal];
    [_goodBtn setTitle:[NSString stringWithFormat:@"%ld",(long)text_image.praiseCount] forState:UIControlStateSelected];
    [_shareBtn setTitle:[NSString stringWithFormat:@"%ld",(long)text_image.shareCount] forState:UIControlStateNormal];
    
    _closeBtn.hidden = YES;
    [self setGoodBtnSelect:text_image.hasPraised];
 


}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([_delegate respondsToSelector:@selector(reportWithIndex:)]) {
        [_delegate reportWithIndex:self.tag];
    }
    return NO;
}
+(CGFloat)heightWith:(Text_Image *)text_image
{
    UIFont *font = [UIFont appFontOfSize:14.0];
    CGSize size = CGSizeMake(kScreenWidth-16.0,MAXFLOAT);
    
    
    CGRect labelRect = [text_image.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    

    CGSize imageSize = CGSizeMake(text_image.imageWidth.floatValue, text_image.imageHeight.floatValue);
    CGFloat imageHeight = imageSize.height;
    if (imageHeight!=0 &&imageSize.width!=0)
    {
        imageHeight = imageHeight/(imageSize.width/(304*[Ash_UIUtil currentScreenSizeRate]));
    }
    if (imageHeight>500) {
        imageHeight = 500;
    }
    return imageHeight+labelRect.size.height+95;
}
- (IBAction)avatarBtnClick:(id)sender {
    if (![_text_image.ownerId isEqualToString:[AWordUser sharedInstance].uid] ) {
        MyNoteViewController* myNoteViewController = [[MyNoteViewController alloc] init];
        myNoteViewController.otherUserId = _text_image.ownerId;
        myNoteViewController.otherName = _text_image.ownerName;
        myNoteViewController.hidesBottomBarWhenPushed = YES;
        [[AppDelegate visibleViewController].navigationController pushViewController:myNoteViewController animated:YES];
    }
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

- (IBAction)closeBtnClick:(id)sender {
}
@end
