//
//  NoteCommentViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRefreshViewController.h"
@class Text_Image;
@interface NoteCommentViewController : BaseRefreshViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
- (IBAction)commentBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic)Text_Image* text_image;

@end
