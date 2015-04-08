//
//  MyNoteViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/8.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRefreshViewController.h"
@interface MyNoteViewController : BaseRefreshViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSString* otherUserId;
@property (strong, nonatomic)NSString* otherName;
@end
