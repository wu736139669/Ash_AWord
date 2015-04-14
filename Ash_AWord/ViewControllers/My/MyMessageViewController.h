//
//  MyMessageViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/13.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface MyMessageViewController : BaseRefreshViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic)NSString* otherUserId;
@property (strong, nonatomic)NSString* otherName;
@end
