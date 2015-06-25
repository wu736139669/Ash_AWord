//
//  ChatMainViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/18.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageTableView.h"
@interface ChatMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet MessageTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (strong, nonatomic)NSString* otherUserName;
@property (strong, nonatomic)NSString* otherUserAvatar;
@property (strong, nonatomic)NSString* otherUserId;
@end
