//
//  NoteCommentViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "NoteCommentViewController.h"
#import "NoteTableViewCell.h"
#import "NoteViewModel.h"
#import "CommentTextView.h"
#import "CommentGoodListCellTableViewCell.h"
#import "UserViewModel.h"
#import "CommentViewModel.h"
#import "CommentTableViewCell.h"
#import "PraiseUserListViewController.h"
#import "ReportViewController.h"
@interface NoteCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NoteTableViewCell* _headView;
    CommentGoodListCellTableViewCell* _commentGoodListCellTableViewCell;
    NSMutableArray* _commentInfoArr;
    NSInteger _reportIndex;
}
@property (nonatomic, assign)    NSInteger page;
@property (nonatomic, assign)    BOOL isFirstLoad;
@property (nonatomic, weak)    CommentTextView* commentTextView;
@end

@implementation NoteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _page = 1;
    _isFirstLoad = YES;
    _reportIndex = -1;
    _commentInfoArr = [[NSMutableArray alloc] init];
    [self customViewDidLoad];
    self.navigationItem.title = @"评论";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    if (_text_image) {
        [self initView];
        [self loadData];
        [self requirePraiseUser];
    }else{
        [self loadRecordInfo];
    }
    


}

-(void)initView
{
    _headView = [Ash_UIUtil instanceXibView:@"NoteTableViewCell"];
    [_headView setText_Image:_text_image];
    CGFloat height = [NoteTableViewCell heightWith:_text_image];
    _headView.frame = CGRectMake(0, 0, kScreenWidth, height);
    _headView.isComment = YES;
    UIView* tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height+80)];
    [tableHeadView addSubview:_headView];
    
    _commentGoodListCellTableViewCell = [Ash_UIUtil instanceXibView:@"CommentGoodListCellTableViewCell"];
    _commentGoodListCellTableViewCell.frame = CGRectMake(0, height, kScreenWidth, 80);
    
    __weak  NoteCommentViewController* weakSelf = self;
    [_commentGoodListCellTableViewCell setShowPraiseList:^(void){
        PraiseUserListViewController *praiseUserListViewController = [[PraiseUserListViewController alloc] init];
        praiseUserListViewController.hidesBottomBarWhenPushed = YES;
        praiseUserListViewController.recordId = weakSelf.text_image.messageId;
        praiseUserListViewController.userListType = UserList_Praise_Type;
        praiseUserListViewController.commentType = Image_Type;
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
    _commentTextView.commentType = Image_Type;
    [_commentTextView setComentComplete:^(){
        weakSelf.isFirstLoad = NO;
        weakSelf.page = 1;
        [weakSelf loadData];
    }];
    [self.view addSubview:_commentTextView];
    _commentTextView.recordId = _text_image.messageId;
    _commentTextView.aothourId = _text_image.ownerId;
    [_commentTextView setHidden:YES];

}
-(void)loadRecordInfo
{
    PropertyEntity* pro = [NoteViewModel requireNoteWithRecordId:_recordId];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        if ([viewModel success]) {
            if (_text_image)
            {
                _text_image = [(NoteViewModel*)viewModel text_image];
                if (_headView)
                {
                    [_headView setText_Image:_text_image];
                }
                return ;
            }
            _text_image = [(NoteViewModel*)viewModel text_image];
            [self initView];
            [self loadData];
            [self requirePraiseUser];
        }
    } failedBlock:^(NSError *error){
        [self initView];
        [self loadData];
        [self requirePraiseUser];
    }];
}
-(void)requirePraiseUser
{
    PropertyEntity* pro = [UserViewModel requireLoadPraiseUserWithRecordId:_text_image.messageId withPage:1 withPage_size:10 withType:Image_Type];
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
    
    PropertyEntity* pro = [CommentViewModel requireLoadCommentWithRecordId:_text_image.messageId withPage:_page withPage_size:DefaultPageSize WithType:Image_Type];
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
//            //计算内容加上点赞列表cell高于显示多少，移动到能看到点赞列表。
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
    if (![commentInfoViewModel.toUserId isEqualToString:_text_image.ownerId]) {
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
    cell.commentType = Image_Type;
    CommentInfoViewModel* commentInfoViewModel = [_commentInfoArr objectAtIndex:indexPath.row];
    cell.ownerId = _text_image.ownerId;
    commentInfoViewModel.status = 1;
    __weak NoteCommentViewController* weakself = self;

    [cell setCommentWithUid:^(NSString* ownerId){
        [weakself.commentTextView showWithUid:ownerId];
    }];
    [cell setDelCommentSuccess:^(void){
        weakself.isFirstLoad = NO;
        weakself.page = 1;
        [weakself loadData];
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
-(void)dealloc
{
    
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
    [_commentTextView showWithUid:_text_image.ownerId];

}
@end
