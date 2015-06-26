//
//  Ash_UIUtil.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/31.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "Ash_UIUtil.h"
#import <DTCoreText.h>
#import "EaseMob.h"
@implementation Ash_UIUtil

+(void)EaseMobLoginWithUserName:(NSString *)userName
{
    
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:userName password:EasePassword withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            DLog(@"注册成功");
            [self loginWithUserName:username];
        }else if (error.errorCode == EMErrorServerDuplicatedAccount) {
            [self loginWithUserName:username];
        }else{
            [self loginWithUserName:username];  
        }
    } onQueue:nil];

}
+(void)loginWithUserName:(NSString*)userName
{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:EasePassword completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            DLog(@"登陆成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotificationName object:nil];

        }
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        options.nickname = [AWordUser sharedInstance].userName;
        options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
    } onQueue:nil];
}
+(CABasicAnimation*)getrotationAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    return rotationAnimation;
}
//讨厌警告
-(id)diskImageDataBySearchingAllPathsForKey:(id)key{return nil;}
+(CGSize)downloadImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;
    
    NSString* absoluteString = URL.absoluteString;
    
#ifdef dispatch_main_sync_safe
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image)
        {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if(image)
        {
            return image.size;
        }
    }
#endif
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self downloadPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self downloadGIFImageSizeWithRequest:request];
    }
    else{
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    return size;
}
+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
+ (id)instanceXibView:(NSString*)xibName
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

+ (void)autoArrangeWidgetsWithConstraints:(NSArray *) constraints width:(CGFloat) width containerWidth:(CGFloat) containerWidth
{
    CGFloat step = (containerWidth - (width * constraints.count)) / (constraints.count + 1);
    for (int i = 0; i < constraints.count; i ++)
    {
        NSLayoutConstraint * constraint = constraints[i];
        constraint.constant = step * (i + 1) + (width * i);
    }
}

+(BOOL)phoneNumberRegularExpression:(NSString*)phoneNumber
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^1([3578][0-9]|45|47)[0-9]{8}" options:0 error:&error];
    
    if (phoneNumber !=nil)
    {
        //从urlString中截取数据
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:phoneNumber options:0 range:NSMakeRange(0, [phoneNumber length])];
        
        NSRange resultRange = [firstMatch rangeAtIndex:0];
        //从urlString中截取数据
        NSString *result = [phoneNumber substringWithRange:resultRange];
        
        if([result isEqualToString:@""]||![result isEqualToString:phoneNumber])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return NO;
    }
}

+ (UIBarButtonItem *)rightBarButtonItemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [btn setImage:image forState:UIControlStateNormal];
    if (highlightedImage) {
        [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    }    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
//    if (iOSVersion >= 7.0)
//    {
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
//    }
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}

+ (UIBarButtonItem *)leftBarButtonItemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [btn setImage:image forState:UIControlStateNormal];
    if (highlightedImage) {
        [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
//    if (iOSVersion >= 7.0)
//    {
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//    }
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}

+ (UISearchBar *)navigationItemSearchBarWithPlaceholder:(NSString *)title
{
    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    search.tintColor = [UIColor appMainColor];
    search.placeholder = title;
    search.barStyle = UIBarStyleDefault;
    [search setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
    
    //修改searchBar的输入框的背景色
    for(UIView *view in search.subviews)
    {
        for (UIView *subView in view.subviews)
        {
            if ([subView isKindOfClass:[UITextField class]])
            {
                [(UITextField *)subView setBackgroundColor:[UIColor searchBarColor]];
            }
        }
    }
    return search;
}

/**
 *  防止相机获取相片图片旋转
 *
 *  @param aImage 修改前的图片
 *
 *  @return 正常的相片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(UIImage*)compressImageDownToPhoneScreenSize:(UIImage*)theImage{
    
    UIImage * bigImage = theImage;
    
    float actualHeight = bigImage.size.height;
    float actualWidth = bigImage.size.width;
    float radio = 1.0;
    float pixel = 2048*1536;
    float pixelImg = actualHeight*actualWidth;
    
    if (pixelImg>pixel)
    {
        actualWidth = actualWidth*pixel/pixelImg;
        actualHeight = actualHeight*pixel/pixelImg;
    }
    //    if (actualHeight > kScreenHeight)
    //    {
    //
    //        actualWidth = actualWidth*(kScreenHeight/actualHeight);
    //        actualHeight = kScreenHeight;
    //    }else if(actualWidth > kScreenWidth)
    //    {
    //
    //        actualHeight = actualHeight*(kScreenWidth/actualWidth);
    //        actualWidth = kScreenWidth;
    //    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth*radio, actualHeight*radio);
    UIGraphicsBeginImageContext(rect.size);
    [bigImage drawInRect:rect]; // scales image to rect
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //RETURN
    return theImage;
}

/**
 * 获取当前屏幕与4寸屏幕比例
 * 4寸返回1.0
 * 4.7返回1.17185
 * 5.5寸返回1.29375
 */
+ (CGFloat)currentScreenSizeRate
{
    return kScreenWidth/320;
}
+(CGSize)calculateSizeWithHtmlstring:(NSString *)htmlstr limitWidth:(CGFloat)width withFontSize:(NSInteger)fontSize
{
    NSDictionary* optionsDic = [Ash_UIUtil getHtmlDicWithFontSize:fontSize];
    NSData *data = [htmlstr dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:optionsDic documentAttributes:nil];
    DTAttributedTextContentView *attributedTextContextView = [[DTAttributedTextContentView alloc] initWithFrame:CGRectMake(0, 0, width, 500)];
    attributedTextContextView.attributedString = string;
    CGSize size = [attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:width];
    return size;
}
+(NSDictionary*)getHtmlDicWithFontSize:(NSInteger)fontSize
{
     NSDictionary* optionsDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:kCTTextAlignmentLeft],DTDefaultTextAlignment,[UIColor blackColor],DTDefaultTextColor,[NSNumber numberWithInteger:fontSize], DTDefaultFontSize,[[UIFont appFontOfSize:1] fontName],DTDefaultFontName,[UIColor appMainColor],DTDefaultLinkColor,[NSNumber numberWithBool:NO], DTDefaultLinkDecoration, nil];
    return optionsDic;
}
@end

@implementation UIFont (CustomFont)

+ (UIFont *)appFontOfSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)appBoldFontOfSize:(CGFloat)size
{
    return [UIFont boldSystemFontOfSize:size];
}

@end

@implementation UIColor (CustomColor)

// 例如： @"#123456"
+ (UIColor *)colorWithHexString:(NSString *)str alpha:(CGFloat)alpha
{
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    UInt32 x = (UInt32)strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x alpha:alpha];
}

// 例如 0x123456
+ (UIColor *)colorWithHex:(UInt32)col alpha:(CGFloat)alpha
{
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:alpha];
}

+ (UIColor *)appMainColor
{
    return [UIColor appMainColorAlpha:1];
}

+(UIColor *)searchBarColor
{
    return [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
}

+(UIColor *)searchButtonColor
{
    return [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
}

+(UIColor *)headerBackgroundColor
{
    return [UIColor colorWithHexString:@"#F6F6F6" alpha:1];
}

+ (UIColor *)appMainColorAlpha:(CGFloat)alpha
{
    return [UIColor colorWithHexString:@"#68d430" alpha:1];
}

+ (UIColor *)appNavBackgroundColor
{
    return [UIColor whiteColor];
}

+(UIColor *)appTableBackgroundColor
{
    return [UIColor whiteColor];
}
/**
 * 按钮颜色：蓝绿色
 */
+ (UIColor *)buttonMainColor
{
    return [UIColor appMainColorAlpha:1];
}
+ (UIColor *)greenYujianniColor
{
    return [UIColor colorWithHexString:@"#61BFA9" alpha:1];

}
/**
 * 按钮颜色：浅灰色
 */
+ (UIColor *)buttonSubColor
{
    return [UIColor colorWithHexString:@"#e5e5e5" alpha:1];
}

/**
 * 按钮文字颜色：黑色，配合的按钮颜色：buttonMainColor
 */
+ (UIColor *)buttonTextColor
{
    return [UIColor whiteColor];
}

/**
 * 按钮文字颜色：灰色，配合的按钮颜色：buttonSubColor
 */
+ (UIColor *)buttonTextSubColor
{
    return [UIColor colorWithHexString:@"#7d7d7d" alpha:1];
}

/**
 * 页面背景颜色
 */
+ (UIColor *)genenalBackgroudColor
{
    return [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
}

/**
 * 所有页面统一的字体颜色
 */
+ (UIColor *)textColor
{
    return [UIColor blackColor];
}

/**
 * 所有页面统一的字体次颜色
 */
+ (UIColor *)textSubColor
{
    return [UIColor colorWithHexString:@"#7d7d7d" alpha:1];
}

+ (UIColor *)buttonBorderColor
{
    return [UIColor colorWithHexString:@"#eeeeee" alpha:1];
}
+ (UIColor *)lineColor
{
    return [UIColor colorWithHexString:@"#dcdcdc" alpha:1];
}

+ (UIColor *)lineColor2
{
    return [UIColor colorWithHexString:@"#535353" alpha:1];
}

+ (UIColor *)textSubColor2
{
    return [UIColor colorWithHexString:@"#898989" alpha:1];
}

+ (UIColor *)homeBackgroundColor2
{
    return [UIColor colorWithHexString:@"#434343" alpha:1];
}

+ (UIColor *)imagePlaceholderColor
{
    return [UIColor colorWithHexString:@"#e5e5e5" alpha:1];
}

@end

@implementation UIImage(custom)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)imageSize
{
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation UIButton(custom)

+ (UIButton *)buttonWithImageName:(NSString *)imageName
{
    UIImage *back = [UIImage imageNamed:imageName];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, back.size.width, back.size.height)];
    [button setBackgroundImage:back forState:UIControlStateNormal];
    return button;
}

- (void)setImageWithColor:(UIColor *)color
{
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    //    [self setBackgroundImage:[UIImage imageWithColor:[UIColor pressedBrownColor]] forState:UIControlStateHighlighted];
    //    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:3];
}

/**
 * 设置background颜色：buttonMainColor，字体颜色：buttonTextColor
 */
- (void)setWithMainColor
{
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor buttonMainColor]] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor buttonTextColor] forState:UIControlStateNormal];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:3];
}

- (void)setWithMainColorAndDefaultBorderColor
{
    [self setWithMainColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)setDefaultHighlitedTitleColor
{
    UIColor *color = self.titleLabel.textColor;
    [self setTitleColor:[color colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
}

/**
 * 设置background颜色：buttonSubColor，字体颜色：buttonTextSubColor
 */
- (void)setWithSubColor
{
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor buttonSubColor]] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor buttonTextSubColor] forState:UIControlStateNormal];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:3];
}

@end

@implementation UIViewController(customViewController)

- (void)customViewDidLoad
{
    self.view.backgroundColor = [UIColor genenalBackgroudColor];
    self.navigationController.view.backgroundColor = [UIColor appNavBackgroundColor];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (iOS7AndLater)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
#endif
}


@end

@implementation UIWebView(userAgent)

+ (void)addUserAgent
{
    NSString *oldAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *version = [NSString stringWithFormat:@"%@.%@",appVersion, buildVersion];
    NSString *userAgentP1 = @"ufun/";
    NSString *myAgent = [NSString stringWithFormat:@" %@%@", userAgentP1, version];
    
    NSRange range = [oldAgent rangeOfString:userAgentP1];
    if (range.location == NSNotFound)
    {
        NSString *newAgent = [oldAgent stringByAppendingString:myAgent];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", newAgent, @"User-Agent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
}
@end
