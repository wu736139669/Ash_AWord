//
//  MyMessageTableViewCell.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MyMessageTableViewCell.h"

@implementation MyMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _unReadCountLabel.layer.cornerRadius = 10.0;
    _unReadCountLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUnReadCount:(NSInteger)unReadConut
{
    if (unReadConut > 0) {
        _unReadCountLabel.hidden = NO;
        _unReadCountLabel.text = [NSString stringWithFormat:@"%ld",unReadConut];
    }else{
        _unReadCountLabel.hidden = YES;
    }
}
@end
