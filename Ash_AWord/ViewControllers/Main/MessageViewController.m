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
#import "ReportViewController.h"
#import "TypeSelectView.h"
#import "TypeSelectBgView.h"
@interface MessageViewController ()<MessageTableViewCellDelegate>
{
    NSInteger _page;
    NSMutableArray* _text_voiceArr;
    NSInteger _playIndex;
    NSInteger _reportIndex;
    TypeSelectView* _typeSelectView;
    TypeSelectBgView* _typeSelectBgView;
    NSInteger _type;   //_type＝0 代表全部,1代表关注.
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
        _reportIndex = -1;
        _type = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customViewDidLoad];

    
    _typeSelectBgView = [Ash_UIUtil instanceXibView:@"TypeSelectBgView"];
    _typeSelectBgView.frame = self.view.frame;
    [self.view addSubview:_typeSelectBgView];
    _typeSelectBgView.typeIndex = _type;
    [_typeSelectBgView.allBtn addTarget:self action:@selector(selectTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_typeSelectBgView.attentionBtn addTarget:self action:@selector(selectTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_typeSelectBgView hide];
    
    _typeSelectView = [Ash_UIUtil instanceXibView:@"TypeSelectView"];
    [_typeSelectView.typeBtn addTarget:self action:@selector(showTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
    _typeSelectView.frame = CGRectMake(0, 0, 60, 40);
    self.navigationItem.titleView = _typeSelectView;
    
    
    self.navigationItem.title = @"听你说";
    self.navigationItem.leftBarButtonItem = [Ash_UIUtil leftBarButtonItemWithTarget:self action:@selector(publish) image:[UIImage imageNamed:@"navigationButtonPublish"] highlightedImage:[UIImage imageNamed:@"navigationButtonPublishClick"]];
    self.navigationItem.rightBarButtonItem = [Ash_UIUtil leftBarButtonItemWithTarget:self action:@selector(headerBeginRefreshing) image:[UIImage imageNamed:@"navigationButtonRefresh"] highlightedImage:[UIImage imageNamed:@"navigationButtonRefreshClick"]];
    
    [self headerBeginRefreshing];
    
    //注册通知的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:kMessagePushSuccessNotificationName object:nil];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGr];
    
    NSMutableArray *menuItems = [NSMutableArray array];
    UIMenuItem *messageRepItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(messageRep:)];
    [menuItems addObject:messageRepItem];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:menuItems];
}

-(void)selectTypeBtn:(UIButton*)button
{
    [_typeSelectBgView hide];
    if (_type == button.tag) {
        return;
    }else{
        _type = button.tag;
        if (_type == 0) {
            _typeSelectView.titleLabel.text = @"全部";
        }else{
            _typeSelectView.titleLabel.text = @"关注";
        }
        _typeSelectBgView.typeIndex = _type;
        [self headerBeginRefreshing];
        
    }
}
-(void)showTypeSelect:(id)sender
{
    if (_typeSelectBgView.hidden) {
        [_typeSelectBgView show];
    }
}


-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if(indexPath == nil) return ;
        //add your code here
        NSMutableArray *menuItems = [NSMutableArray array];
        [self becomeFirstResponder];
        
        UIMenuItem *messageRepItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(messageRep:)];
        
        [menuItems addObject:messageRepItem];
        
        
        _reportIndex = indexPath.section;
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:menuItems];
        CGRect targetRect = cell.frame;
        targetRect.origin.x = point.x;
        targetRect.origin.y = point.y;
        targetRect.size.height = 50;
        targetRect.size.width = 0;
        [menu setTargetRect:targetRect inView:self.tableView];
        [menu setMenuVisible:YES animated:YES];
    }
}
-(void)messageRep:(id)sender {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    
    if (_reportIndex>=0) {
        ReportViewController* reportViewController = [[ReportViewController alloc] init];
        Text_Voice* text_Voice = [_text_voiceArr objectAtIndex:_reportIndex];
        reportViewController.authorName = text_Voice.ownerName;
        reportViewController.msgId = text_Voice.messageId;
        reportViewController.msgType = Message_Voice_Type;
        reportViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reportViewController animated:YES];
    }
    
    
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (  action == @selector(messageRep:)) {
        return YES;
    }
    return NO;
}
-(BOOL) canBecomeFirstResponder{
    return YES;
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
    [MobClick event:kUmen_message];
    
    PropertyEntity* pro = [MessageViewModel requireWithOrder_by:Order_by_Time withPage:_page withPage_size:DefaultPageSize withType:_type];
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
    NSString* cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",(long)indexPath.section];
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
#pragma mark NoteCellDelegate
-(void)reportWithIndex:(NSInteger)index
{
    _reportIndex = index;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
