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
#import "PersonalInfoViewController.h"
@interface PraiseUserListViewController ()
{
    NSInteger _page;
    NSMutableArray* _dataArr;
    NSMutableArray* _newArr; //新关注的用户
    BOOL _isShowNewFans;   //代表是否有显示新粉丝
}
@end

@implementation PraiseUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isShowNewFans = NO;
    self.navigationItem.title = @"最近点赞";
    if (_userListType == UserList_Attention_Type) {
        self.navigationItem.title = @"关注";
    }else if(_userListType == UserList_Fans_Type){
        if ([_targetId isEqualToString:[AWordUser sharedInstance].uid] && [AWordUser sharedInstance].myNewFollowerCount>0) {
            _isShowNewFans = YES;
        }
        self.navigationItem.title = @"粉丝";
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _page = 1;
    _dataArr = [[NSMutableArray alloc] init];
    _newArr = [[NSMutableArray alloc] init];
    if (_firstPraiseUserArr.count > 0) {
        [_dataArr addObjectsFromArray:_firstPraiseUserArr];
        if (_dataArr.count >= DefaultPageSize) {
            [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        }
    }else
    {
        [self loadNewUserList];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadNewUserList
{
    if (!_isShowNewFans) {
        [self headerBeginRefreshing];
        return;
    }
    [self.tableView.header beginRefreshing];
    PropertyEntity* pro = [UserViewModel requireNewUserList];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        if ([viewModel success]) {
            UserViewModel* userViewModel = (UserViewModel*)viewModel;
            
            if (userViewModel.userInfoArr) {
                [_newArr addObjectsFromArray:userViewModel.userInfoArr];
            }
            
        }
        [self headerRereshing];
        
    } failedBlock:^(NSError *error) {
        [self headerRereshing];
    }];

    
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
    
    PropertyEntity* pro;
    if (_userListType == UserList_Praise_Type) {
        pro = [UserViewModel requireLoadPraiseUserWithRecordId:_recordId withPage:_page withPage_size:DefaultPageSize withType:_commentType];
    }else if (_userListType == UserList_Attention_Type){
        pro = [UserViewModel requireLoadUserListWithTargetUid:_targetId withType:1 withPage:_page withPage_size:DefaultPageSize];
    }else{
        pro = [UserViewModel requireLoadUserListWithTargetUid:_targetId withType:2 withPage:_page withPage_size:DefaultPageSize];

    }

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
    if (_newArr.count>0) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_newArr.count>0 && section==0) {
        return _newArr.count;
    }
    return _dataArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (_newArr.count>0) {
        return 30.0;
    }
    return 10.0;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0 && _newArr.count>0) {
        return @"新粉丝";
    }else if(section==1){
        return @"全部粉丝";
    }
    return @"";
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
    
    UserInfoViewModel* userInfoViewModel;
    if (indexPath.section==0 && _newArr.count>0) {
        userInfoViewModel = [_newArr objectAtIndex:indexPath.row];
    }else{
        userInfoViewModel = [_dataArr objectAtIndex:indexPath.row];

    }

    [cell setUserInfoViewModel:userInfoViewModel];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoViewModel* userInfoViewModel;
    if (indexPath.section==0 && _newArr.count>0) {
        userInfoViewModel = [_newArr objectAtIndex:indexPath.row];
    }else{
        userInfoViewModel = [_dataArr objectAtIndex:indexPath.row];
        
    }
    PersonalInfoViewController* personalInfoViewController = [[PersonalInfoViewController alloc] init];
    personalInfoViewController.hidesBottomBarWhenPushed = YES;
    personalInfoViewController.otherUserId = userInfoViewModel.uid;
    [self.navigationController pushViewController:personalInfoViewController animated:YES];
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
