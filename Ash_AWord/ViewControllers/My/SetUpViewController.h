//
//  SetUpViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "ViewController.h"

@interface SetUpViewController : ViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

+ (void)shareAppWithViewController:(UIViewController *)controller andTitle:(NSString *)title andContent:(NSString *)content andImage:(UIImage *)image andUrl:(NSString *)url;
@end
