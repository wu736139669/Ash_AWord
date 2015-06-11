//
//  PersonalInfoViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/9.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "CExpandHeader.h"
#import "PersonalTopView.h"



@interface PersonalInfoViewController ()
{
    CExpandHeader *_header;
    PersonalTopView* _personalTopView;
}
@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView removeHeader];
    _personalTopView = [Ash_UIUtil instanceXibView:@"PersonalTopView"];
    [self.tableView setTableHeaderView:_personalTopView];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset <= 0) {
        CGRect f = _topViewImage.frame;
        f.origin.y = -80 - yOffset*0.8;
        _topViewImage.frame = f;
    }else{
        CGRect f = _topViewImage.frame;
        f.origin.y = -80 - yOffset*0.8;
        _topViewImage.frame = f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chatBtnClick:(id)sender {
}
@end
