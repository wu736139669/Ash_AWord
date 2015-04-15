//
//  MyMessageViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/13.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MessageViewModel.h"
#import "MessageTableViewCell.h"
@interface MyMessageViewController ()<MessageTableViewCellDelegate>
{
    NSInteger _page;
    NSMutableArray* _text_voiceArr;
    NSInteger _playIndex;
}
@end

@implementation MyMessageViewController

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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(!_otherUserId){
        self.navigationItem.title = @"我发表的声音";
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%@发表的声音",_otherName];
    }
    [self customViewDidLoad];
    [self headerBeginRefreshing];
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
    [self loadData];
}
-(void)loadData
{
    [MobClick event:kUmen_message];
    
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
