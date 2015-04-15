//
//  MyNoteViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/8.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MyNoteViewController.h"
#import "NoteViewModel.h"
#import "NoteTableViewCell.h"
@interface MyNoteViewController ()
{
    NSInteger _page;
    NSMutableArray* _text_imageArr;
}
@end

@implementation MyNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _page = 1;
        _text_imageArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(!_otherUserId){
        self.navigationItem.title = @"我发表的图片";
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%@发表的图片",_otherName];
    }
    [self customViewDidLoad];
    [self headerBeginRefreshing];
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
    if (!_otherUserId) {
        pro  = [NoteViewModel requireMyWithOrder_by:Order_by_Time withPage:_page withPage_size:20];
    }else{
        pro = [NoteViewModel requireOhterWithOrder_by:Order_by_Time withPage:_page withPage_size:20 withOtherId:_otherUserId];
    }
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        
        NoteViewModel* noteViewModel = (NoteViewModel*)viewModel;
        
        if (_page <= 1) {
            [_text_imageArr removeAllObjects];
        }
        if (noteViewModel.text_imagesArr) {
            [_text_imageArr addObjectsFromArray:noteViewModel.text_imagesArr];
        }
        [self footerEndRefreshing];
        [self headerEndRefreshing];
        if (noteViewModel.text_imagesArr.count<20) {
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
    return _text_imageArr.count;
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
    Text_Image* text_image = [_text_imageArr objectAtIndex:indexPath.section];
    return [NoteTableViewCell heightWith:text_image];
    //    return 140;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellIdentifier";
    NoteTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:@"NoteTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Text_Image* text_image = [_text_imageArr objectAtIndex:indexPath.section];
    [cell setText_Image:text_image];
    return cell;
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
