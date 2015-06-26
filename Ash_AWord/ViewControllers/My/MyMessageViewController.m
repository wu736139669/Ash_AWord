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
#import "ReportViewController.h"
@interface MyMessageViewController ()<MessageTableViewCellDelegate>
{
    NSInteger _page;
    NSMutableArray* _text_voiceArr;
    NSInteger _playIndex;
    NSInteger _reportIndex;
    BOOL _isShowDel;

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
        _reportIndex = -1;
        _isShowDel = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(!_otherUserId){
        self.navigationItem.title = @"我发表的声音";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(showDelBtn)];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%@发表的声音",_otherName];
    }
    [self customViewDidLoad];
    [self headerBeginRefreshing];
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGr];
    
    NSMutableArray *menuItems = [NSMutableArray array];
    UIMenuItem *messageRepItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(messageRep:)];
    [menuItems addObject:messageRepItem];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:menuItems];
}
-(void)showDelBtn
{
    if (_isShowDel) {
        self.navigationItem.rightBarButtonItem.title = @"管理";
        _isShowDel = NO;
    }else{
        _isShowDel = YES;
        self.navigationItem.rightBarButtonItem.title = @"取消";
        
    }
    [self.tableView reloadData];
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
        
        if (!_otherUserId) {
            UIMenuItem *messageDelItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(messageDel:)];
            
            [menuItems addObject:messageDelItem];
        }
        
        
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
-(void)messageDel:(id)sender
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确认删除" message:@"是否删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag = 0;
    [alertView show];
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
    if (  action == @selector(messageRep:) || action == @selector(messageDel:)) {
        return YES;
    }
    return NO;
}
-(BOOL) canBecomeFirstResponder{
    return YES;
}

#pragma mark --UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //删除
    if (buttonIndex == 1) {
        Text_Voice* text_Voice = [_text_voiceArr objectAtIndex:_reportIndex];
        PropertyEntity* pro = [MessageViewModel requireDelWithRecordId:text_Voice.messageId];
        [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
            
            MessageViewModel* noteViewModel = (MessageViewModel*)viewModel;
            
            if ([noteViewModel success]) {
                [self headerBeginRefreshing];
            }else
            {
                [MBProgressHUD errorHudWithView:self.view label:noteViewModel.errMessage hidesAfter:1.0];
            }
            
        } failedBlock:^(NSError *error) {
            [MBProgressHUD errorHudWithView:self.view label:kNetworkErrorTips hidesAfter:1.0];
        }];
    }
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
    
    PropertyEntity* pro ;
    if (_otherUserId) {
        pro = [MessageViewModel requireOhterWithOrder_by:Order_by_Time withPage:_page withPage_size:20 withOtherId:_otherUserId];

    }else{
        pro = [MessageViewModel requireMyWithOrder_by:Order_by_Time withPage:_page withPage_size:20];

    }
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
    if (_isShowDel) {
        cell.closeBtn.hidden = NO;
        cell.closeBtn.tag = indexPath.section;
        cell.timeLabel.hidden = YES;
        [cell.closeBtn addTarget:self action:@selector(msgDel:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}
-(void)msgDel:(UIButton*)button
{
    _reportIndex = button.tag;
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确认删除" message:@"是否删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag = 0;
    [alertView show];
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
