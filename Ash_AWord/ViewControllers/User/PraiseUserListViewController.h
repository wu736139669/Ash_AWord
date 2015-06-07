//
//  PraiseUserListViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/5.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface PraiseUserListViewController : BaseRefreshViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(assign, nonatomic)NSInteger recordId;
@property(strong, nonatomic)NSArray* firstPraiseUserArr;
@end
