//
//  PersonalInfoViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/9.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "ViewController.h"
#import "BaseRefreshViewController.h"
@interface PersonalInfoViewController : BaseRefreshViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *topViewImage;
- (IBAction)chatBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end
