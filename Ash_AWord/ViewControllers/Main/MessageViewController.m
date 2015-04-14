//
//  MessageViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/30.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MessageViewController.h"
#import "MessagePublishViewController.h"
#import "MessageViewModel.h"
#import "MessageTableViewCell.h"
#import "AudioPlayer.h"
@interface MessageViewController ()<MessageTableViewCellDelegate>
{
    NSInteger _page;
    NSMutableArray* _text_voiceArr;
    NSInteger _playIndex;
}
@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _page = 1;
        _text_voiceArr = [[NSMutableArray alloc] init];
        _playIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customViewDidLoad];

    
    self.navigationItem.title = @"听你说";
    self.navigationItem.leftBarButtonItem = [Ash_UIUtil leftBarButtonItemWithTarget:self action:@selector(publish) image:[UIImage imageNamed:@"navigationButtonPublish"] highlightedImage:[UIImage imageNamed:@"navigationButtonPublishClick"]];
    self.navigationItem.rightBarButtonItem = [Ash_UIUtil leftBarButtonItemWithTarget:self action:@selector(headerBeginRefreshing) image:[UIImage imageNamed:@"navigationButtonRefresh"] highlightedImage:[UIImage imageNamed:@"navigationButtonRefreshClick"]];
    [self headerBeginRefreshing];
}
#pragma publish
-(void)publish
{
    MessagePublishViewController* messagePublishViewController = [[MessagePublishViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:messagePublishViewController];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark MJRefreshDelegate
-(void)headerRereshing
{
    _playIndex = -1;
    _page=1;
    [self loadData];
}
-(void)footerRereshing
{
//    _page++;
    [self loadData];
}
-(void)loadData
{
    [MobClick event:kUmen_note attributes:nil];
    
    PropertyEntity* pro = [MessageViewModel requireWithOrder_by:Order_by_Time withPage:_page withPage_size:20];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        
        MessageViewModel* noteViewModel = (MessageViewModel*)viewModel;
        if (_page <= 1) {
            [_text_voiceArr removeAllObjects];
        }
        if (noteViewModel.text_voicesArr) {
            [_text_voiceArr addObjectsFromArray:noteViewModel.text_voicesArr];
        }
        [self footerEndRefreshing];
        [self headerEndRefreshing];
        if (noteViewModel.text_voicesArr.count<20) {
            [self.tableView removeFooter];
        }else{
            [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        }
        _page++;
        [self.tableView reloadData];
        
    } failedBlock:^(NSError *error) {
//        _page--;
        [MBProgressHUD errorHudWithView:self.view label:kNetworkErrorTips hidesAfter:1.0];
        [self footerEndRefreshing];
        [self headerEndRefreshing];
    }];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _text_voiceArr.count;
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
    Text_Voice* text_voice = [_text_voiceArr objectAtIndex:indexPath.section];
    return [MessageTableViewCell heightWith:text_voice];
    //    return 140;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",indexPath.section];
    MessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:@"MessageTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Text_Voice* text_voice = [_text_voiceArr objectAtIndex:indexPath.section];
    [cell setText_Voice:text_voice];
    cell.tag = indexPath.section;
    cell.delegate = self;
    return cell;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
