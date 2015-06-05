//
//  UIImageView＋Reloading.m
//  XiaoYu
//
//  Created by xmfish on 14-8-21.
//  Copyright (c) 2014年 Benson. All rights reserved.
//

#import "UIImageView+Reloading.h"

#import <execinfo.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (Swizzle)


+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_ {
    
	Method origMethod = class_getInstanceMethod(self, origSel_);
	if (!origMethod) {
		return NO;
	}
	Method altMethod = class_getInstanceMethod(self, altSel_);
	if (!altMethod) {
		return NO;
	}
	
	class_addMethod(self,
					origSel_,
					class_getMethodImplementation(self, origSel_),
					method_getTypeEncoding(origMethod));
	class_addMethod(self,
					altSel_,
					class_getMethodImplementation(self, altSel_),
					method_getTypeEncoding(altMethod));
	
	method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
	return YES;
}

+ (BOOL)jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_ {
	return [object_getClass((id)self) jr_swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}

@end


static char imageURLKey;
static char imageStatusKey;
static char imageTapEventKey;
static char imageOriginalModelKey;
@implementation UIImageView (SY)
+ (void)load
{
    [UIImageView jr_swizzleMethod:@selector(cancelCurrentImageLoad) withMethod:@selector(sy_cancelCurrentImageLoad) error:nil];
}

- (UIButton *)sy_progressView:(BOOL)isCreate
{
    static char imageProgressKey;
    UIButton *progressView = objc_getAssociatedObject(self, &imageProgressKey);
    if (isCreate)
    {
        if (progressView == nil)
        {
            progressView = [UIButton buttonWithType:UIButtonTypeCustom];
            progressView.frame = self.bounds;
            progressView.hidden = YES;
            progressView.backgroundColor = [UIColor clearColor];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点击重新加载图片"];
            NSRange strRange = {0,[str length]};
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
            [progressView setAttributedTitle:str forState:UIControlStateNormal];
//            [progressView setTitle:@"点击加载图片" forState:UIControlStateNormal];
            [progressView setTitle:@"图片加载中" forState:UIControlStateDisabled];
            progressView.titleLabel.shadowColor = [UIColor whiteColor];
            progressView.titleLabel.shadowOffset = CGSizeMake(1, 1);
            [progressView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [progressView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            progressView.titleLabel.adjustsFontSizeToFitWidth = YES;
            CGSize size = CGSizeMake(progressView.frame.size.width,2000);
            CGSize labelsize = [progressView.titleLabel.text sizeWithFont:progressView.titleLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
            progressView.frame = CGRectMake(0.0, 0.0, labelsize.width, labelsize.height);
            progressView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            [progressView addTarget:self action:@selector(reloadImageURL) forControlEvents:UIControlEventTouchUpInside];
            progressView.enabled = NO;
            objc_setAssociatedObject(self, &imageProgressKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        __weak UIImageView* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself addSubview:progressView];
        });
    }
    return progressView;
}

- (UIViewContentMode)originalViewContentMode
{
    NSNumber *value = objc_getAssociatedObject(self, &imageOriginalModelKey);
    int mode = -1;
    if (value)
    {
        mode = [value intValue];
    }
    if (mode < 0 || mode > UIViewContentModeBottomRight)
    {
        return -1;
    }
    else
    {
        return mode;
    }
}

- (void)setOriginalViewContentMode:(UIViewContentMode)originalViewContentMode
{
    NSNumber *value = [[NSNumber alloc] initWithInt:originalViewContentMode];
    objc_setAssociatedObject(self, &imageOriginalModelKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LKImageViewStatus)status
{
    NSNumber *value = objc_getAssociatedObject(self, &imageStatusKey);
    if (value)
    {
        return [value intValue];
    }
    return LKImageViewStatusNone;
}

- (void)setStatus:(LKImageViewStatus)status
{
    objc_setAssociatedObject(self, &imageStatusKey, @(status), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setImageURLFromCache:(id)imageURL
{
    [self sy_loadTapEvent];
    self.status = LKImageViewStatusLoaded;
    objc_setAssociatedObject(self, &imageURLKey, imageURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setImageURL:(id)imageURL
{
    [self sy_loadTapEvent];
    objc_setAssociatedObject(self, &imageURLKey, imageURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (imageURL)
    {
        [self reloadImageURL];
    }
    else
    {
        [self sy_cancelCurrentImageLoad];
        self.image = nil;
        self.backgroundColor = [UIColor colorWithRed:233/255.0 green:228/255.0 blue:223/255.0 alpha:1];
        self.status = LKImageViewStatusNone;
        
        UIButton *pv = [self sy_progressView:NO];
        [pv removeFromSuperview];
    }
}

- (void)sy_loadTapEvent
{
    static char tapEventLoadedKey;
    id loaded = objc_getAssociatedObject(self, &tapEventLoadedKey);
    if (loaded == nil)
    {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sy_handleTapEvent:)];
        [self addGestureRecognizer:tap];
        objc_setAssociatedObject(self, &tapEventLoadedKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id)getImageURL
{
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)sy_cancelCurrentImageLoad
{
    if ([self getImageURL])
    {
        void *callstack[2];
        int frames = backtrace(callstack, 2);
        char **strs = backtrace_symbols(callstack, 2);
        NSString *func_name = nil;
        if (frames > 1 && strs && strs[1])
        {
            func_name = [NSString stringWithUTF8String:strs[1]];
        }
        free(strs);
        
        //如果从外部调用 cancelImageLoad  才进行扫尾工作
        if ([func_name rangeOfString:@"UIImageView(WebCache)"].length == 0)
        {
            UIButton *pv = [self sy_progressView:NO];
//            pv.hidden = YES;
            [pv removeFromSuperview];
            
            self.status = LKImageViewStatusNone;
        }
    }
    [self sy_cancelCurrentImageLoad];
}

- (void)reloadImageURL
{
    id imageURL = [self getImageURL];
    if ([imageURL isKindOfClass:[NSString class]])
    {
        if ([imageURL isEqualToString:@""] == NO)
        {
            imageURL = [NSURL URLWithString:imageURL];
        }
    }
    if ([imageURL isKindOfClass:[NSURL class]] == NO)
    {
        return;
    }
    
    [self sy_cancelCurrentImageLoad];
    
    self.image = nil;
    self.backgroundColor = [UIColor colorWithRed:233/255.0 green:228/255.0 blue:223/255.0 alpha:1];
    
    __weak UIImageView *wself = self;
    if([self originalViewContentMode] < 0){
        [self setOriginalViewContentMode:self.contentMode];
    }
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    self.status = LKImageViewStatusLoading;
    
    __weak __block UIButton *pv = [self sy_progressView:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        pv.hidden = NO;
        pv.enabled = NO;
    });
    
    [self sd_setImageWithURL:imageURL placeholderImage:self.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        float pvalue = MAX(0, MIN(1, receivedSize / (float) expectedSize));
        dispatch_async(dispatch_get_main_queue(), ^{
//            [pv.titleLabel setText:[NSString stringWithFormat:@"图片加载中%.1f %%",pvalue*100]];
            pv.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"图片加载中%.1f %%",pvalue*100]];
            NSRange strRange = {0,[str length]};
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:strRange];
            [pv setAttributedTitle:str forState:UIControlStateDisabled];

            pv.hidden = NO;
        });
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(!pv){
            pv = [wself sy_progressView:NO];
        }
        
        if (image)
        {
            pv.hidden = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [pv removeFromSuperview];
            });
            
            if([wself originalViewContentMode]>=0){
                
                if(wself.contentMode != [wself originalViewContentMode]){
                    wself.contentMode = [wself originalViewContentMode];
                    [wself setNeedsDisplay];
                }
            }
            else if (wself.contentMode != UIViewContentModeScaleAspectFill)
            {
                wself.contentMode = UIViewContentModeScaleAspectFill;
                [wself setNeedsDisplay];
            }
            
            wself.status = LKImageViewStatusLoaded;
            wself.backgroundColor = [UIColor clearColor];
            [wself setOriginalViewContentMode:-1];
            
        }
        else
        {
            if (error)
            {
                
                wself.status = LKImageViewStatusFail;
                [wself setOriginalViewContentMode:-1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    pv.enabled = YES;
                });
            }
        }
    }];
}

- (void)setOnTouchTapBlock:(void (^)(UIImageView *))onTouchTapBlock
{
    [self sy_loadTapEvent];
    objc_setAssociatedObject(self, &imageTapEventKey, onTouchTapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIImageView *))onTouchTapBlock
{
    return objc_getAssociatedObject(self, &imageTapEventKey);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self getImageURL] && self.status != LKImageViewStatusFail && self.onTouchTapBlock == nil)
    {
        return NO;
    }
    if (self.status == LKImageViewStatusLoading || self.status == LKImageViewStatusFail) {
        UIButton* pv = [self sy_progressView:NO];
        if (self.status == LKImageViewStatusFail  && [pv pointInside:[self convertPoint:point toView:pv] withEvent:event]) {
            return YES;
        }
        return NO;
    }
    return [super pointInside:point withEvent:event];
}
- (void)sy_handleTapEvent:(UITapGestureRecognizer *)sender
{
    switch (self.status)
    {
        case LKImageViewStatusFail:
            [self reloadImageURL];
            break;
        default:
            if (self.onTouchTapBlock)
            {
                self.onTouchTapBlock(self);
            }
            break;
    }
}
@end
