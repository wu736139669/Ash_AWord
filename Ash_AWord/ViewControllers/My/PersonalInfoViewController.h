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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)chatBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property (nonatomic, strong)NSString* otherUserId;
@end
