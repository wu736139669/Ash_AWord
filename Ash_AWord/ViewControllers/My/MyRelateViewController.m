//
//  MyRelateViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/27.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MyRelateViewController.h"
#import "CommentTableViewCell.h"
#import "CommentViewModel.h"
#import "NoteCommentViewController.h"
#import "MessageCommentViewController.h"
@interface MyRelateViewController ()
{
    NSMutableArray* _commentInfoArr;
    NSInteger _page;

}
@end

@implementation MyRelateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _page = 1;
    _commentInfoArr = [[NSMutableArray alloc] init];
    
    [self customViewDidLoad];
    
    self.navigationItem.title = @"与我相关";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"已读" style:UIBarButtonItemStyleDone target:self action:@selector(readAll)];
    
    [self headerBeginRefreshing];
}
#pragma mark 标记已读
-(void)readAll
{
    [RequireEngine requireWithProperty:[CommentViewModel requireReadAllComment] completionBlock:^(id viewModel) {
        if ([viewModel success]) {
            [self headerBeginRefreshing];
        }
    } failedBlock:nil];
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
    [MobClick event:kUmen_note];
    
    PropertyEntity* pro = [CommentViewModel requireLoadMyCommentWithPage:_page withPage_size:DefaultPageSize];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        
        if ([viewModel success]) {
            CommentViewModel* commentViewModel = (CommentViewModel*)viewModel;
            
            if (_page <= 1) {
                [_commentInfoArr removeAllObjects];
            }
            if (commentViewModel.commentInfoArr) {
                [_commentInfoArr addObjectsFromArray:commentViewModel.commentInfoArr];
            }
            [self footerEndRefreshing];
            [self headerEndRefreshing];
            if (commentViewModel.commentInfoArr.count<DefaultPageSize) {
                [self.tableView removeFooter];
            }else{
                [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            }
            _page++;
        }else
        {
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
    
    return _commentInfoArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentInfoViewModel* commentInfoViewModel = [_commentInfoArr objectAtIndex:indexPath.row];
    return [CommentTableViewCell getHeightWithCommentInfoViewModel:commentInfoViewModel isReplyOwner:NO];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 5.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",(long)indexPath.section];
    CommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        UINib* nib = nil;
        nib = [UINib nibWithNibName:@"CommentTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    CommentInfoViewModel* commentInfoViewModel = [_commentInfoArr objectAtIndex:indexPath.row];
    cell.isAllowReport = NO;
    
    __weak MyRelateViewController* weakself = self;
    [cell setCommentWithUid:^(NSString* uid){
        [weakself tableView:tableView didSelectRowAtIndexPath:indexPath];
    }];
    [cell setCommentInfoViewModel:commentInfoViewModel];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentInfoViewModel* commentInfoViewModel = [_commentInfoArr objectAtIndex:indexPath.row];
    
    [RequireEngine requireWithProperty:[CommentViewModel requireReadCommentWithCommentId:commentInfoViewModel.commentId.integerValue] completionBlock:^(id viewModel) {
        commentInfoViewModel.status = 1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } failedBlock:nil];
    if (commentInfoViewModel.commentType == Image_Type) {
        NoteCommentViewController* noteCommentViewController = [[NoteCommentViewController alloc] init];
        noteCommentViewController.hidesBottomBarWhenPushed = YES;
        noteCommentViewController.recordId = commentInfoViewModel.recordId;
        [self.navigationController pushViewController:noteCommentViewController animated:YES];
    }else{
        MessageCommentViewController* messageCommentViewController = [[MessageCommentViewController alloc] init];
        messageCommentViewController.hidesBottomBarWhenPushed = YES;
        messageCommentViewController.recordId = commentInfoViewModel.recordId;
        [self.navigationController pushViewController:messageCommentViewController animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
     CommentInfoViewModel* commentInfoViewModel = [_commentInfoArr objectAtIndex:indexPath.row];
    if ([commentInfoViewModel.ownerId isEqualToString:[AWordUser sharedInstance].uid]) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CommentInfoViewModel* commentInfoViewModel = [_commentInfoArr objectAtIndex:indexPath.row];
        [RequireEngine requireWithProperty:[CommentViewModel requireDelCommentWithCommentId:commentInfoViewModel.commentId.integerValue] completionBlock:^(id viewModel) {
            commentInfoViewModel.status = 1;
            [_commentInfoArr removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failedBlock:nil];
        
    }
}

-(void)dealloc
{
    
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
