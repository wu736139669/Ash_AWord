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
#import "NoteViewModel.h"
#import "NoteTableViewCell.h"
#import "MessageTableViewCell.h"
#import "MessageViewModel.h"
#import "UserViewModel.h"
#import "ChatMainViewController.h"
@interface PersonalInfoViewController ()<NoteTableViewCellDelegate,MessageTableViewCellDelegate>
{
    CExpandHeader *_header;
    PersonalTopView* _personalTopView;
    UserViewModel* _userViewModel;
    NSMutableArray* _imageArr;
    NSMutableArray* _voiceArr;
    BOOL _isSelectImage;
    NSInteger _imagePage;
    NSInteger _voicePage;
    NSInteger _playIndex;

}
@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customViewDidLoad];
    _isSelectImage = YES;
    _imagePage = 1;
    _voicePage = 1;
    _playIndex = -1;

    self.navigationItem.title = @"个人主页";
    
    _imageArr = [[NSMutableArray alloc] init];
    _voiceArr = [[NSMutableArray alloc] init];

    NSLog(@"%@",[AWordUser sharedInstance].uid);

    if ([_otherUserId isEqualToString:[AWordUser sharedInstance].uid]) {
        _bottomView.hidden = YES;
        _tableBottomHeight.constant = 0.0;
    }
    self.tableView.hidden = YES;
    
    [DejalActivityView activityViewForView:self.view withLabel:kLoadingTips];
    [self headerRereshing];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _personalTopView = [Ash_UIUtil instanceXibView:@"PersonalTopView"];
//    _personalTopView.frame = CGRectMake(0, 0, kScreenWidth, 285*[Ash_UIUtil currentScreenSizeRate]);
    __weak PersonalInfoViewController *weakself = self;
    [_personalTopView setuserInfoViewModel:_userViewModel];
    
    [_personalTopView setIsSelectImg:^(BOOL isSelectImg){
        _isSelectImage = isSelectImg;
        if (isSelectImg) {
            if (_imageArr.count <= 0) {
                [weakself loadData];
            }else{
                [weakself.tableView reloadData];
            }
        }else{
            if (_voiceArr.count <= 0) {
                [weakself loadData];
            }else{
                [weakself.tableView reloadData];
            }
        }
    }];
//    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = _personalTopView;
//    [self.tableView endUpdates];
}
#pragma mark MJRefreshDelegate
-(void)headerRereshing
{
    if (_isSelectImage) {
        _imagePage = 1;
    }else{
        _voicePage = 1;
    }
    [self loadUserInfo];
    
}
-(void)footerRereshing
{
    [self loadData];
}
-(void)loadUserInfo
{
    PropertyEntity* pro = [UserViewModel requireUserInfoWithTargetUid:_otherUserId];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        [DejalActivityView removeView];
        self.tableView.hidden = NO;
        UserViewModel* userViewModel = (UserViewModel*)viewModel;
        if ([userViewModel success]) {
            _userViewModel = viewModel;
            [_personalTopView setuserInfoViewModel:_userViewModel];
            [self loadData];

        }else{
            [MBProgressHUD errorHudWithView:self.view label:userViewModel.errMessage hidesAfter:1.0];
        }
    } failedBlock:^(NSError *error) {
        self.tableView.hidden = NO;
        [DejalActivityView removeView];
    }];
}
-(void)loadData
{
    if (_isSelectImage) {
        PropertyEntity* pro;
        if (_otherUserId && [_otherUserId isEqualToString:[AWordUser sharedInstance].uid]) {
            pro  = [NoteViewModel requireMyWithOrder_by:Order_by_Time withPage:_imagePage withPage_size:DefaultPageSize];
        }else{
            pro = [NoteViewModel requireOhterWithOrder_by:Order_by_Time withPage:_imagePage withPage_size:DefaultPageSize withOtherId:_otherUserId];
        }
        [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
            
            NoteViewModel* noteViewModel = (NoteViewModel*)viewModel;
            
            if (_imagePage <= 1) {
                [_imageArr removeAllObjects];
            }
            if (noteViewModel.text_imagesArr) {
                [_imageArr addObjectsFromArray:noteViewModel.text_imagesArr];
            }
            [self footerEndRefreshing];
            [self headerEndRefreshing];
            if (noteViewModel.text_imagesArr.count<20) {
                [self.tableView removeFooter];
            }else{
                [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            }
            _imagePage++;
            [self.tableView reloadData];
            
        } failedBlock:^(NSError *error) {
            [MBProgressHUD errorHudWithView:self.view label:kNetworkErrorTips hidesAfter:1.0];
            [self footerEndRefreshing];
            [self headerEndRefreshing];
        }];

    }else{
        PropertyEntity* pro ;
        if (_otherUserId && [_otherUserId isEqualToString:[AWordUser sharedInstance].uid]) {
            pro = [MessageViewModel requireMyWithOrder_by:Order_by_Time withPage:_voicePage withPage_size:DefaultPageSize];

            
        }else{
            pro = [MessageViewModel requireOhterWithOrder_by:Order_by_Time withPage:_voicePage withPage_size:DefaultPageSize withOtherId:_otherUserId];

        }
        [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
            
            MessageViewModel* noteViewModel = (MessageViewModel*)viewModel;
            
            if (_voicePage <= 1) {
                [_voiceArr removeAllObjects];
            }
            if (noteViewModel.text_voicesArr) {
                [_voiceArr addObjectsFromArray:noteViewModel.text_voicesArr];
            }
            [self footerEndRefreshing];
            [self headerEndRefreshing];
            if (noteViewModel.text_voicesArr.count<DefaultPageSize) {
                [self.tableView removeFooter];
            }else{
                [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            }
            _voicePage++;
            [self.tableView reloadData];
            
        } failedBlock:^(NSError *error) {
            [MBProgressHUD errorHudWithView:self.view label:kNetworkErrorTips hidesAfter:1.0];
            [self footerEndRefreshing];
            [self headerEndRefreshing];
        }];

    }
    
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

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isSelectImage) {
        return _imageArr.count;
    }else{
        return _voiceArr.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSelectImage) {
        Text_Image* text_image = [_imageArr objectAtIndex:indexPath.section];
        return [NoteTableViewCell heightWith:text_image];
    }else{
        Text_Voice* text_voice = [_voiceArr objectAtIndex:indexPath.section];
        return [MessageTableViewCell heightWith:text_voice];
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"NoteTableViewCell";
    if (_isSelectImage) {
        cellIdentifier = @"NoteTableViewCell";
        NoteTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            UINib* nib = [UINib nibWithNibName:@"NoteTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Text_Image* text_image = [_imageArr objectAtIndex:indexPath.section];
        cell.delegate = self;
        cell.tag = indexPath.section;
        [cell setText_Image:text_image];
//        if (_isShowDel) {
//            cell.closeBtn.hidden = NO;
//            cell.closeBtn.tag = indexPath.section;
//            cell.timeLabel.hidden = YES;
//            [cell.closeBtn addTarget:self action:@selector(msgDel:) forControlEvents:UIControlEventTouchUpInside];
//        }
        return cell;
    }else{
        cellIdentifier = [NSString stringWithFormat:@"MessageTableViewCell%ld",indexPath.section];
        MessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            UINib* nib = [UINib nibWithNibName:@"MessageTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Text_Voice* text_voice = [_voiceArr objectAtIndex:indexPath.section];
        [cell setText_Voice:text_voice];
        cell.tag = indexPath.section;
        cell.delegate = self;
//        if (_isShowDel) {
//            cell.closeBtn.hidden = NO;
//            cell.closeBtn.tag = indexPath.section;
//            cell.timeLabel.hidden = YES;
//            [cell.closeBtn addTarget:self action:@selector(msgDel:) forControlEvents:UIControlEventTouchUpInside];
//        }
        
        return cell;

    }
    return nil;
}
-(void)playWithIndex:(NSInteger)index
{
    
    if (index != _playIndex) {
        if (_playIndex == -1) {
        }else{
            MessageTableViewCell* cell = (MessageTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_playIndex]];
            [cell stopPlay];
            
        }
    }
    _playIndex = index;
}
#pragma mark NoteCellDelegate
-(void)reportWithIndex:(NSInteger)index
{
//    _reportIndex = index;
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
    ChatMainViewController* chatMainViewController = [[ChatMainViewController alloc] init];
    chatMainViewController.otherUserAvatar = _userViewModel.userInfo.figureurl;
    chatMainViewController.otherUserName = _userViewModel.userInfo.name;
    chatMainViewController.otherUserId = _otherUserId;
    [self.navigationController pushViewController:chatMainViewController animated:YES];
}
@end
