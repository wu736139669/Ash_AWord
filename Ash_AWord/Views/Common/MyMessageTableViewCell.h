//
//  MyMessageTableViewCell.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *unReadCountLabel;

-(void)setUnReadCount:(NSInteger)unReadConut;
@end
