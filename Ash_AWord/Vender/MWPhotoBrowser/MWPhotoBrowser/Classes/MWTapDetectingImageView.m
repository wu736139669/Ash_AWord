//
//  UIImageViewTap.m
//  Momento
//
//  Created by Michael Waterfall on 04/11/2009.
//  Copyright 2009 d3i. All rights reserved.
//

#import "MWTapDetectingImageView.h"

@implementation MWTapDetectingImageView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onlongtabed:)];
        longpress.minimumPressDuration = 1.0;///至少按1秒
        longpress.numberOfTouchesRequired = 1;//只有一个触点
        [self addGestureRecognizer:longpress];
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (id)initWithImage:(UIImage *)image {
	if ((self = [super initWithImage:image])) {
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onlongtabed:)];
        longpress.minimumPressDuration = 1.0;///至少按1秒
        longpress.numberOfTouchesRequired = 1;//只有一个触点
        [self addGestureRecognizer:longpress];
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
	if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onlongtabed:)];
        longpress.minimumPressDuration = 1.0;///至少按1秒
        longpress.numberOfTouchesRequired = 1;//只有一个触点
        [self addGestureRecognizer:longpress];
		self.userInteractionEnabled = YES;
	}
	return self;
}


-(void)onlongtabed:(UIGestureRecognizer*)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        [self handleLongTap:gestureRecognizer];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
	switch (tapCount) {
		case 1:
            [self performSelector:@selector(handleSingleTap:) withObject:touch afterDelay:0.3];
			break;
		case 2:
			[self handleDoubleTap:touch];
			break;
		case 3:
			[self handleTripleTap:touch];
			break;
		default:
			break;
	}
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
	if ([_tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)])
		[_tapDelegate imageView:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
	if ([_tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)])
		[_tapDelegate imageView:self doubleTapDetected:touch];
}

- (void)handleTripleTap:(UITouch *)touch {
	if ([_tapDelegate respondsToSelector:@selector(imageView:tripleTapDetected:)])
		[_tapDelegate imageView:self tripleTapDetected:touch];
}
-(void)handleLongTap:(UIGestureRecognizer*)gestureRecognizer{
    if ([_tapDelegate respondsToSelector:@selector(imageView:longTapDetected:)])
        [_tapDelegate imageView:self longTapDetected:gestureRecognizer];
}
@end
