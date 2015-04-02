//
//  BaseRefreshViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/3/31.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
@interface BaseRefreshViewController : ViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (void)headerRereshing;
- (void)footerRereshing;
- (void)headerBeginRefreshing;
- (void)headerEndRefreshing;
- (void)footerBeginRefreshing;
- (void)footerEndRefreshing;
@end
