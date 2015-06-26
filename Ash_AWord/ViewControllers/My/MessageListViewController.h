//
//  MessageListViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRefreshViewController.h"
@interface MessageListViewController : BaseRefreshViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
