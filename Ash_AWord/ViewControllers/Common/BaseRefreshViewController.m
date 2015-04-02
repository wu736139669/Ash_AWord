//
//  BaseRefreshViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/31.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseRefreshViewController.h"


@interface BaseRefreshViewController ()

@end

@implementation BaseRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self customViewDidLoad];
    self.tableView.separatorColor = [UIColor clearColor];
}

#pragma mark MJRefreshDelegate
- (void)headerRereshing
{
    
}

- (void)footerRereshing
{
    
}
- (void)headerBeginRefreshing
{
    [self.tableView.header beginRefreshing];
}
-(void)headerEndRefreshing
{
    [self.tableView.header endRefreshing];
}
-(void)footerBeginRefreshing
{
    [self.tableView.footer beginRefreshing];
}
-(void)footerEndRefreshing
{
    [self.tableView.footer endRefreshing];
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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

@end
