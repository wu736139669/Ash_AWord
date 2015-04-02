//
//  UIPlaceHolderTextView.h
//  WangsuTraffic
//
//  Created by 华桂 陈 on 12-2-23.
//  Copyright (c) 2012年 ChinaNetCenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView 
{
@private
    NSString *placeholder_;
    UIColor *placeholderColor_;
    UILabel *placeHolderLabel_;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end