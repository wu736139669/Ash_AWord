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
@interface MessageListViewController ()<UIAlertViewDelegate>
{
    NSInteger _page;
    NSMutableArray* _dataArr;
    NSMutableArray* _userArr;

    BOOL _ifRefresh;
}
@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customViewDidLoad];
//    _userArr = [NSMutableArray array];
    
    self.navigationItem.title = @"消息列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空列表" style:UIBarButtonItemStyleDone target:self action:@selector(clearList)];
    
    _ifRefresh = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_ifRefresh) {
        [self.tableView.header beginRefreshing];
    }else{
        [self loadData];
    }
    
}

-(void)clearList
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确认清空" message:@"是否清空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    alertView.tag = 0;
    [alertView show];
}
#pragma mark --UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //删除
    if (buttonIndex == 1) {
        if ([[EaseMob sharedInstance].chatManager removeAllConversationsWithDeleteMessages:YES append2Chat:YES]) {
            [_dataArr removeAllObjects];
            [self.tableView reloadData];
        }
    }
}

-(void)headerRereshing
{
    _page=1;
    _ifRefresh = YES;
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
    
    if (!_ifRefresh) {
        [self.tableView reloadData];
        return;
    }
    NSMutableArray* uidArr = [NSMutableArray array];
    for (EMConversation* conversation  in _dataArr) {
        [uidArr addObject:conversation.chatter];
    }
    PropertyEntity* pro = [UserViewModel requireUserListWithUid:uidArr];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        
        if ([viewModel success]) {
            _userArr = [NSMutableArray arrayWithArray:[(UserViewModel*)viewModel userBaseInfoArr]];
            _ifRefresh = NO;
        }else{
            [_dataArr removeAllObjects];
//            [MBProgressHUD errorHudWithView:self.view label:[viewModel errMessage] hidesAfter:1.0];
        }

        [self.tableView reloadData];
        [self headerEndRefreshing];
    } failedBlock:^(NSError *error) {
        [MBProgressHUD errorHudWithView:self.view label:kNetworkErrorTips hidesAfter:1.0];

        [_dataArr removeAllObjects];
        [self.tableView reloadData];
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
       EMConversation* conversation = [_dataArr objectAtIndex:indexPath.row];
        if ( [[EaseMob sharedInstance].chatManager removeConversationByChatter:conversation.chatter deleteMessages:YES append2Chat:YES]) {
            [_dataArr removeObjectAtIndex:indexPath.row];
            // Delete the row from the data source.
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

        
    }
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
