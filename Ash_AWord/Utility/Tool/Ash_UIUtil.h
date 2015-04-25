//
//  Ash_UIUtil.h
//  Ash_AWord
//
//  Created by xmfish on 15/3/31.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ash_UIUtil : NSObject

+(CGSize)downloadImageSizeWithURL:(id)imageURL;
/**
 * 通过类名出创建xib类
 */
+(id)instanceXibView:(NSString*)xibName;
/**
 * 等分排列若干相同控件
 * 参数1：各个控件距离父视图的距离约束数组
 * 参数2：控件的自身款或者高
 * 参数3：父视图的宽度
 */
+(void)autoArrangeWidgetsWithConstraints:(NSArray *) constraints width:(CGFloat) width containerWidth:(CGFloat) containerWidth;
/**
 *  手机号码正则
 *
 *  @param phoneNumber 手机号
 *
 *  @return 是否正确
 */
+(BOOL)phoneNumberRegularExpression:(NSString*)phoneNumber;

/**
 * 创建自定义UIBarButtonItem，用于右边
 */
+ (UIBarButtonItem *)rightBarButtonItemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highlightedImage:(UIImage*)highlightedImage;

/**
 * 创建自定义UIBarButtonItem，用于左边
 */
+ (UIBarButtonItem *)leftBarButtonItemWithTarget:(id)target action:(SEL)action image:(UIImage *)image highlightedImage:(UIImage*)highlightedImage;

+ (CGFloat)currentScreenSizeRate;

/**
 *  创建导航栏顶部的搜索框
 *
 *  @param title placeholder
 *
 *  @return searchBar
 */
+ (UISearchBar *)navigationItemSearchBarWithPlaceholder:(NSString *)title;

/**
 *  防止相机获取相片图片旋转
 *
 *  @param aImage 修改前的图片
 *
 *  @return 正常的相片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 *     压缩图片到屏幕大小
 *
 *    @param originImage原图
 *    @return 压缩后的图片
 */
+(UIImage*)compressImageDownToPhoneScreenSize:(UIImage*)originImage;


@end

@interface UIFont (CustomFont)

+ (UIFont *)appFontOfSize:(CGFloat)size;

+ (UIFont *)appBoldFontOfSize:(CGFloat)size;

@end

@interface UIColor (CustomColor)

/**
 * 十六进制数转换UIColor
 * 例如： 0x123456
 */
+ (UIColor *)colorWithHex:(UInt32)col alpha:(CGFloat)alpha;

/**
 * 十六进制字符串转换UIColor
 * 例如： @"#123456"
 */
+ (UIColor *)colorWithHexString:(NSString *)str alpha:(CGFloat)alpha;


/**
 * app风格主色
 */
+ (UIColor *)appMainColor;
+ (UIColor *)appMainColorAlpha:(CGFloat)alpha;

/**
 *  导航背景颜色
 */
+ (UIColor *)appNavBackgroundColor;

/**
 *  Table页面背景颜色
 */
+ (UIColor *)appTableBackgroundColor;

/**
 * 所有UIViewController统一的背景颜色
 */
+ (UIColor *)genenalBackgroudColor;

/**
 *
 */
+(UIColor *)greenYujianniColor;
/**
 * 按钮颜色：蓝绿色
 */
+ (UIColor *)buttonMainColor;

/**
 * 按钮颜色：浅灰色
 */
+ (UIColor *)buttonSubColor;

/**
 * 按钮文字颜色：黑色，配合的按钮颜色：buttonMainColor
 */
+ (UIColor *)buttonTextColor;

/**
 * 按钮文字颜色：灰色，配合的按钮颜色：buttonSubColor
 */
+ (UIColor *)buttonTextSubColor;

/**
 * 所有页面统一的字体颜色
 */
+ (UIColor *)textColor;

/**
 * 所有页面统一的字体次颜色
 */
+ (UIColor *)textSubColor;

/**
 * 按钮描边颜色
 */
+ (UIColor *)buttonBorderColor;
/**
 * 线条颜色
 */
+ (UIColor *)lineColor;

//首页顶部类型选择中间线条颜色
+ (UIColor *)lineColor2;

//首页顶部类型选择文字灰颜色
+ (UIColor *)textSubColor2;

//首页顶部类型选择背景颜色
+ (UIColor *)homeBackgroundColor2;

//searchBar的背景颜色
+ (UIColor *)searchBarColor;

//搜索按钮的颜色
+ (UIColor *)searchButtonColor;

//头部视图的背景
+(UIColor *)headerBackgroundColor;

//图片默认颜色
+ (UIColor *)imagePlaceholderColor;
@end

@interface UIImage(custom)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)imageSize;

@end

@interface UIButton(custom)
+ (UIButton *)buttonWithImageName:(NSString *)imageName;
- (void)setImageWithColor:(UIColor *)color;

/**
 * 设置background颜色：buttonMainColor，字体颜色：buttonTextColor
 */
- (void)setWithMainColor;

- (void)setWithMainColorAndDefaultBorderColor;

/**
 * 设置button title color为正常颜色的alpha0.5值效果
 */
- (void)setDefaultHighlitedTitleColor;

/**
 * 设置background颜色：buttonSubColor，字体颜色：buttonTextSubColor
 */
- (void)setWithSubColor;

@end

@interface UIWebView(userAgent)

/**
 * 每次程序重启将被系统重置默认的useragent
 *如果需要自定义添加ua，需在每次启动程序执行此方法
 */
+ (void)addUserAgent;
@end


@interface UIViewController(customViewController)

/**
 * 通用的自定义：比如背景色、iOS7适配等，在viewDidLoad之后调用
 */
- (void)customViewDidLoad;

@end
