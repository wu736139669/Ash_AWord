//
//  CommentGoodListCellTableViewCell.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "CommentGoodListCellTableViewCell.h"
#import "UserViewModel.h"

@implementation CommentGoodListCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setUserInfoArr:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showMoreBtnClick:(id)sender {
}

-(void)setUserInfoArr:(NSArray *)userInfoArr
{
    
    for (UIView* view in [_barBtImageView subviews]) {
        if (view.tag != 100) {
            [view removeFromSuperview];
        }
    }
    for (int i=0; i<userInfoArr.count; i++) {
        if (i*50+10 > kScreenWidth-40) {
            break;
        }
        UserInfoViewModel* userInfoViewModel = [userInfoArr objectAtIndex:i];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*48+10, 18, 36, 36)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:userInfoViewModel.figureurl] placeholderImage:DefaultUserIcon];
        [_barBtImageView addSubview:imageView];
    }
    if (userInfoArr.count == 0) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, 300, 36)];
        label.text = @"还没有人点赞呢～";
        label.textColor = [UIColor lightGrayColor];
        [_barBtImageView addSubview:label];
        [_showMoreBtn setEnabled:NO];
    }else
    {
        [_showMoreBtn setEnabled:YES];
    }
}

@end
