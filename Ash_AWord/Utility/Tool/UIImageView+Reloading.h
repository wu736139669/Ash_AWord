//
//  UIImageView＋Reloading.h
//  XiaoYu
//  可以显示进度，还可以失败重新下载
//  Created by xmfish on 14-8-21.
//  Copyright (c) 2014年 Benson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
typedef NS_ENUM(NSInteger, LKImageViewStatus){
    LKImageViewStatusNone = 0,
    LKImageViewStatusLoaded = 1,
    LKImageViewStatusLoading = 2,
    LKImageViewStatusFail = 3
};
@interface UIImageView(Reloading)
//加载的图片 url地址 可以是 NSString 或 NSURL
@property(copy, nonatomic) id imageURL;

//这个不会设置 image  只会保存ImageURL
- (void)setImageURLFromCache:(id)imageURL;

//当前状态
@property LKImageViewStatus status;

//图片点击事件  不用再手动添加UITapGestureRecognizer
@property(copy, nonatomic) void(^onTouchTapBlock)(UIImageView *imageView);

//重新加载图片
- (void)reloadImageURL;
@end
