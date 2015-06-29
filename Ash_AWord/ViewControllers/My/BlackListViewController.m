//
//  BlackListViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/28.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BlackListViewController.h"
#import "PraiseUserListTableViewCell.h"
#import "UserViewModel.h"
#import "PersonalInfoViewController.h"
@interface BlackListViewController ()
{
    NSMutableArray* _userArr;
}
@end

@implementation BlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"黑名单";
    
    [self customViewDidLoad];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView.header beginRefreshing];

    
}

-(void)headerRereshing
{
    [self loadData];
}
-(void)footerRereshing
{
    [self loadData];
}
-(void)loadData
{
    [[EaseMob sharedInstance].chatManager asyncFetchBlockedListWithCompletion:^(NSArray *blockedList, EMError *error) {
        if (!error) {
            NSMutableArray* dataArr = [[NSMutableArray alloc] initWithArray:blockedList];
            NSMutableArray* uidArr = [NSMutableArray array];
            for (NSString* userid  in dataArr) {
                [uidArr addObject:userid];
            }
            if(uidArr.count > 0){
                PropertyEntity* pro = [UserViewModel requireUserListWithUid:uidArr];
                [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
                    
                    if ([viewModel success]) {
                        _userArr = [NSMutableArray arrayWithArray:[(UserViewModel*)viewModel userBaseInfoArr]];
                    }
                    
                    [self.tableView reloadData];
                    [self headerEndRefreshing];
                } failedBlock:^(NSError *error) {
                    [MBProgressHUD errorHudWithView:self.view label:kNetworkErrorTips hidesAfter:1.0];
                    
                    [self.tableView reloadData];
                    [self headerEndRefreshing];
                }];
  
            }else{
                [self.tableView reloadData];
                [self headerEndRefreshing];
            }
          

        }
    } onQueue:nil];
    
    
    
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _userArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0;
    
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
    
    UserInfoViewModel* userInfoViewModel = [_userArr objectAtIndex:indexPath.row];

    [cell setUserInfoViewModel:userInfoViewModel];
    return cell;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UserInfoViewModel* userInfoViewModel = [_userArr objectAtIndex:indexPath.row];

        [[EaseMob sharedInstance].chatManager asyncUnblockBuddy:userInfoViewModel.uid withCompletion:^(NSString *username, EMError *error) {
            if (!error) {
                [_userArr removeObjectAtIndex:indexPath.row];
                // Delete the row from the data source.
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

            }
        } onQueue:nil];
        
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserInfoViewModel* userInfoViewModel = [_userArr objectAtIndex:indexPath.row];
    PersonalInfoViewController* personalInfoViewController = [[PersonalInfoViewController alloc] init];
    personalInfoViewController.hidesBottomBarWhenPushed = YES;
    personalInfoViewController.otherUserId = userInfoViewModel.uid;
    [self.navigationController pushViewController:personalInfoViewController animated:YES];
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
