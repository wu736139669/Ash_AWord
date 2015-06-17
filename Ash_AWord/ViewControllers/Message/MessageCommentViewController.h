//
//  MessageCommentViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/17.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRefreshViewController.h"
@class Text_Voice;
@interface MessageCommentViewController : BaseRefreshViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
- (IBAction)commentBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic)Text_Voice* text_Voice;

@end
