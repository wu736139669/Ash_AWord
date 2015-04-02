//
//  NotePublishViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "ViewController.h"
#import "UIPlaceHolderTextView.h"
@interface NotePublishViewController : ViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (nonatomic,strong)UIImage* publishImage;
@end
