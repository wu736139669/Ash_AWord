//
//  MessageCommentViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/17.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MessageCommentViewController.h"
#import "MessageTableViewCell.h"
#import "CommentTextView.h"
#import "CommentGoodListCellTableViewCell.h"
#import "PraiseUserListViewController.h"
#import "MessageViewModel.h"
#import "UserViewModel.h"
#import "CommentViewModel.h"
#import "CommentTableViewCell.h"
@interface MessageCommentViewController ()
{
    MessageTableViewCell* _headView;
    CommentTextView* _commentTextView;
    CommentGoodListCellTableViewCell* _commentGoodListCellTableViewCell;
    NSInteger _page;
    NSMutableArray* _commentInfoArr;
    BOOL _isFirstLoad;

}
@end

@implementation MessageCommentViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _page = 1;
    _isFirstLoad = YES;

    _commentInfoArr = [[NSMutableArray alloc] init];
    [self customViewDidLoad];
    self.navigationItem.title = @"评论";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _headView = [Ash_UIUtil instanceXibView:@"MessageTableViewCell"];
    [_headView setText_Voice:_text_Voice];
    CGFloat height = [MessageTableViewCell heightWith:_text_Voice];
    _headView.frame = CGRectMake(0, 0, kScreenWidth, height);
    _headView.isComment = YES;
    UIView* tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height+80)];
    [tableHeadView addSubview:_headView];
    
    _commentGoodListCellTableViewCell = [Ash_UIUtil instanceXibView:@"CommentGoodListCellTableViewCell"];
    _commentGoodListCellTableViewCell.frame = CGRectMake(0, height, kScreenWidth, 80);
    
    __weak  MessageCommentViewController* weakSelf = self;
    [_commentGoodListCellTableViewCell setShowPraiseList:^(void){
        PraiseUserListViewController *praiseUserListViewController = [[PraiseUserListViewController alloc] init];
        praiseUserListViewController.hidesBottomBarWhenPushed = YES;
        praiseUserListViewController.recordId = weakSelf.text_Voice.messageId;
        praiseUserListViewController.userListType = UserList_Praise_Type;
        praiseUserListViewController.commentType = Voice_Type;
        [weakSelf.navigationController pushViewController:praiseUserListViewController animated:YES];
    }
     ];
    [tableHeadView addSubview:_commentGoodListCellTableViewCell];
    
    self.tableView.tableHeaderView = tableHeadView;
    
    
    _lineView.backgroundColor = [UIColor lineColor];
    _lineHeight.constant = 0.5;
    
    CGFloat top = 0; // 顶端盖高度
    CGFloat bottom = 0 ; // 底端盖高度
    CGFloat left = 50; // 左端盖宽度
    CGFloat right = 30; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    UIImage *img=[UIImage imageNamed:@"toolbar_light_comment.png"];
    img=[img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [_commentBtn setBackgroundImage:img forState:UIControlStateNormal];
    
    
    _commentTextView = [Ash_UIUtil instanceXibView:@"CommentTextView"];
    _commentTextView.frame = self.view.frame;
    _commentTextView.commentType = Voice_Type;

    [_commentTextView setComentComplete:^(){
        _isFirstLoad = NO;
        _page = 1;
        [weakSelf loadData];
    }];
    [self.view addSubview:_commentTextView];
    _commentTextView.recordId = _text_Voice.messageId;
    _commentTextView.aothourId = _text_Voice.ownerId;
    [_commentTextView setHidden:YES];
    
    
    [self loadData];
    [self requirePraiseUser];

}
-(void)requirePraiseUser
{
    PropertyEntity* pro = [UserViewModel requireLoadPraiseUserWithRecordId:_text_Voice.messageId withPage:1 withPage_size:10 withType:Voice_Type];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        if ([viewModel success]) {
            [_commentGoodListCellTableViewCell setUserInfoArr:[(UserViewModel*)viewModel userInfoArr]];
        }
    } failedBlock:^(NSError *error) {
        
    }];
}

#pragma mark MJRefreshDelegate
-(void)headerRereshing
{
    _page=1;
    [self requirePraiseUser];
    [self loadData];
}
-(void)footerRereshing
{
    [self loadData];
}
-(void)loadData
{
    [MobClick event:kUmen_note];
    
    PropertyEntity* pro = [CommentViewModel requireLoadCommentWithRecordId:_text_Voice.messageId withPage:_page withPage_size:DefaultPageSize WithType:Voice_Type];
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
        if (_isFirstLoad) {
            CGPoint point = self.tableView.contentOffset;
            point.y = _headView.frame.size.height;
            [self.tableView setContentOffset:point animated:YES];
            
            _isFirstLoad = NO;
        }
        
        
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
    BOOL isReplyOwnew = YES;
    if (![commentInfoViewModel.toUserId isEqualToString:_text_Voice.ownerId]) {
        isReplyOwnew = NO;
    }
    return [CommentTableViewCell getHeightWithCommentInfoViewModel:commentInfoViewModel isReplyOwner:isReplyOwnew];
    
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
    cell.commentType = Voice_Type;

    CommentInfoViewModel* commentInfoViewModel = [_commentInfoArr objectAtIndex:indexPath.row];
    commentInfoViewModel.status = 1;
    cell.ownerId = _text_Voice.ownerId;
    [cell setCommentWithUid:^(NSString* ownerId){
        [_commentTextView showWithUid:ownerId];
    }];
    [cell setDelCommentSuccess:^(void){
        _isFirstLoad = NO;
        _page = 1;
        [self loadData];
    }];
    [cell setCommentInfoViewModel:commentInfoViewModel];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommentInfoViewModel* commentInfoViewModel = [_commentInfoArr objectAtIndex:indexPath.row];
    [_commentTextView showWithUid:commentInfoViewModel.ownerId];
    
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

- (IBAction)commentBtnClick:(id)sender {
    [_commentTextView showWithUid:_text_Voice.ownerId];

}
@end
