//
//  MessageListViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListTableViewCell.h"
#import "ChatMainViewController.h"
#import "UserViewModel.h"
@interface MessageListViewController ()
{
    NSInteger _page;
    NSMutableArray* _dataArr;
    NSMutableArray* _userArr;

}
@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customViewDidLoad];
    _userArr = [NSMutableArray array];
    
    self.navigationItem.title = @"消息列表";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView removeFooter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];

}
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
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    _dataArr = [[NSMutableArray alloc] initWithArray:sorte];
    
    NSMutableArray* uidArr = [NSMutableArray array];
    for (EMConversation* conversation  in _dataArr) {
        [uidArr addObject:conversation.chatter];
    }
    PropertyEntity* pro = [UserViewModel requireUserListWithUid:uidArr];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        
        if ([viewModel success]) {
            [_userArr removeAllObjects];
            _userArr = [NSMutableArray arrayWithArray:[(UserViewModel*)viewModel userBaseInfoArr]];
        }

        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failedBlock:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
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
    NSString* cellIdentifier = @"MessageListTableViewCell";
    MessageListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        UINib* nib = nil;
        nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    EMConversation* conversation = [_dataArr objectAtIndex:indexPath.row];
    [cell setEMConversation:conversation];
    UserInfoViewModel* userinfo;
    for (UserInfoViewModel* user in _userArr) {
        if ([user.uid isEqualToString:conversation.chatter]) {
            userinfo = user;
            break;
        }
    }
    [cell setUserInfo:userinfo];

    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation* conversation = [_dataArr objectAtIndex:indexPath.row];

    ChatMainViewController* chatMainViewController = [[ChatMainViewController alloc] init];
    chatMainViewController.otherUserId = conversation.chatter;
    chatMainViewController.otherUserName = conversation.chatter;
    for (UserInfoViewModel* user in _userArr) {
        if ([user.uid isEqualToString:conversation.chatter]) {
            chatMainViewController.otherUserAvatar = user.figureurl;
            chatMainViewController.otherUserName = user.name;
            break;
        }
    }


    [self.navigationController pushViewController:chatMainViewController animated:YES];
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
