//
//  PraiseUserListViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/5.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "PraiseUserListViewController.h"
#import "PraiseUserListTableViewCell.h"
#import "UserViewModel.h"

@interface PraiseUserListViewController ()
{
    NSInteger _page;
    NSMutableArray* _dataArr;
}
@end

@implementation PraiseUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"最近点赞的用户";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _page = 1;
    _dataArr = [[NSMutableArray alloc] init];
    if (_firstPraiseUserArr.count > 0) {
        [_dataArr addObjectsFromArray:_firstPraiseUserArr];
        if (_dataArr.count >= DefaultPageSize) {
            [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        }
    }else
    {
        [self headerBeginRefreshing];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark MJRefreshDelegate
-(void)headerRereshing
{
    _page=1;
    [self loadData];
}
-(void)footerRereshing
{
    [self loadData];
}
-(void)loadData
{
    
    PropertyEntity* pro = [UserViewModel requireLoadPraiseUserWithRecordId:_recordId withPage:1 withPage_size:DefaultPageSize];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        if ([viewModel success]) {
            UserViewModel* userViewModel = (UserViewModel*)viewModel;
            
            if (_page <= 1) {
                [_dataArr removeAllObjects];
            }
            if (userViewModel.userInfoArr) {
                [_dataArr addObjectsFromArray:userViewModel.userInfoArr];
            }
            [self footerEndRefreshing];
            [self headerEndRefreshing];
            if (userViewModel.userInfoArr.count<DefaultPageSize) {
                [self.tableView removeFooter];
            }else{
                [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            }
            _page++;
        }else{
            [MBProgressHUD errorHudWithView:self.view label:[viewModel errMessage] hidesAfter:1.0];
        }
        [self.tableView reloadData];

    } failedBlock:^(NSError *error) {
        [MBProgressHUD errorHudWithView:self.view label:kNetworkErrorTips hidesAfter:1.0];
        [self footerEndRefreshing];
        [self headerEndRefreshing];
    }];
    
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"cellIdentifier";
    PraiseUserListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        UINib* nib = nil;
        nib = [UINib nibWithNibName:@"PraiseUserListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    UserInfoViewModel* userInfoViewModel = [_dataArr objectAtIndex:indexPath.row];

    [cell setUserInfoViewModel:userInfoViewModel];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
