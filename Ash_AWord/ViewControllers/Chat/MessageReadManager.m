/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "MessageReadManager.h"
//#import "UIImageView+EMWebCache.h"
#import "EMCDDeviceManager.h"
#import "AppDelegate.h"
static MessageReadManager *detailInstance = nil;

@interface MessageReadManager()

@property (strong, nonatomic) UIWindow *keyWindow;

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) UINavigationController *photoNavigationController;

@property (strong, nonatomic) UIAlertView *textAlertView;

@end

@implementation MessageReadManager

+ (id)defaultManager
{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            detailInstance = [[self alloc] init];
        });
    }
    
    return detailInstance;
}

#pragma mark - getter

- (UIWindow *)keyWindow
{
    if(_keyWindow == nil)
    {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    return _keyWindow;
}

- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

- (MWPhotoBrowser *)photoBrowser
{
    
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        //是否显示分享按钮
        _photoBrowser.displayActionButton = YES;
        //左右分页切换
        _photoBrowser.displayNavArrows = YES;
        //是否显示选择按钮
        _photoBrowser.displaySelectionButtons = NO;
        //是否显示条件控制控件
        _photoBrowser.alwaysShowControls = YES;
        //是否全屏
        _photoBrowser.zoomPhotosToFill = YES;
        
        //允许使用网络查看所有图片
        _photoBrowser.enableGrid = YES;
        //是否第一张
        _photoBrowser.startOnGrid = YES;
        _photoBrowser.enableSwipeToDismiss = YES;
        [_photoBrowser showNextPhotoAnimated:YES];
        [_photoBrowser showPreviousPhotoAnimated:YES];
        [_photoBrowser setCurrentPhotoIndex:0];
    
    
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    }
    
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    
    return nil;
}


#pragma mark - private


#pragma mark - public

- (void)showBrowserWithImages:(NSArray *)imageArray
{
    if (imageArray && [imageArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imageArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                photo = [MWPhoto photoWithImage:object];
            }
            else if ([object isKindOfClass:[NSURL class]])
            {
                photo = [MWPhoto photoWithURL:object];
            }
            else if ([object isKindOfClass:[NSString class]])
            {
                
            }
            [photoArray addObject:photo];
        }
        
        self.photos = photoArray;
    }
    

    [[AppDelegate visibleViewController].navigationController pushViewController:self.photoBrowser animated:YES];
}

- (BOOL)prepareMessageAudioModel:(MessageModel *)messageModel
                      updateViewCompletion:(void (^)(MessageModel *prevAudioModel, MessageModel *currentAudioModel))updateCompletion
{
    BOOL isPrepare = NO;
    
    if(messageModel.type == eMessageBodyType_Voice)
    {
        MessageModel *prevAudioModel = self.audioMessageModel;
        MessageModel *currentAudioModel = messageModel;
        self.audioMessageModel = messageModel;
        
        BOOL isPlaying = messageModel.isPlaying;
        if (isPlaying) {
            messageModel.isPlaying = NO;
            self.audioMessageModel = nil;
            currentAudioModel = nil;
            [[EMCDDeviceManager sharedInstance] stopPlaying];
        }
        else {
            messageModel.isPlaying = YES;
            prevAudioModel.isPlaying = NO;
            isPrepare = YES;
            
            if (!messageModel.isPlayed) {
                messageModel.isPlayed = YES;
                EMMessage *chatMessage = messageModel.message;
                if (chatMessage.ext) {
                    NSMutableDictionary *dict = [chatMessage.ext mutableCopy];
                    if (![[dict objectForKey:@"isPlayed"] boolValue]) {
                        [dict setObject:@YES forKey:@"isPlayed"];
                        chatMessage.ext = dict;
                        [chatMessage updateMessageExtToDB];
                    }
                }
            }
        }
        
        if (updateCompletion) {
            updateCompletion(prevAudioModel, currentAudioModel);
        }
    }
    
    return isPrepare;
}

- (MessageModel *)stopMessageAudioModel
{
    MessageModel *model = nil;
    if (self.audioMessageModel.type == eMessageBodyType_Voice) {
        if (self.audioMessageModel.isPlaying) {
            model = self.audioMessageModel;
        }
        self.audioMessageModel.isPlaying = NO;
        self.audioMessageModel = nil;
    }
    
    return model;
}


@end
