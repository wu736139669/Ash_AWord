//
//  UIPlaceHolderTextView.m
//  WangsuTraffic
//
//  Created by 华桂 陈 on 12-2-23.
//  Copyright (c) 2012年 ChinaNetCenter. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView

@synthesize placeHolderLabel = placeHolderLabel_;
@synthesize placeholder = placeholder_;
@synthesize placeholderColor = placeholderColor_;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel_ == nil )
        {
            placeHolderLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(4,8,self.bounds.size.width,0)];
            placeHolderLabel_.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel_.numberOfLines = 0;
            placeHolderLabel_.font = self.font;
            placeHolderLabel_.backgroundColor = [UIColor clearColor];
            placeHolderLabel_.textColor = self.placeholderColor;
            placeHolderLabel_.alpha = 0;
            placeHolderLabel_.tag = 999;
            [self addSubview:placeHolderLabel_];
        }
        
        placeHolderLabel_.text = self.placeholder;
        [placeHolderLabel_ sizeToFit];
        [self sendSubviewToBack:placeHolderLabel_];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}
@end
