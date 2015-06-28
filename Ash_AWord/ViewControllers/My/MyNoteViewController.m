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
#import "ReportViewController.h"
@interface MyNoteViewController ()<NoteTableViewCellDelegate>
{
    NSInteger _page;
    NSMutableArray* _text_imageArr;
    NSInteger _reportIndex;
    BOOL _isShowDel;
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
        _reportIndex = -1;
        _isShowDel = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(!_otherUserId){
        self.navigationItem.title = @"我发表的图片";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(showDelBtn)];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%@发表的图片",_otherName];
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
        //        NSLog(@"%ld",indexPath.section);
        //启动弹出菜单
        NSMutableArray *menuItems = [NSMutableArray array];
        [self becomeFirstResponder];
        
        //        UIMenuItem *messageCopyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(messageCopy:)];
        //        [menuItems addObject:messageCopyItem];
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
-(void)messageRep:(id)sender {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    
    if (_reportIndex>=0) {
        ReportViewController* reportViewController = [[ReportViewController alloc] init];
        Text_Image* text_image = [_text_imageArr objectAtIndex:_reportIndex];
        reportViewController.authorName = text_image.ownerName;
        reportViewController.msgId = text_image.messageId;
        reportViewController.msgType = Note_Img_Type;
        reportViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reportViewController animated:YES];
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
        Text_Image* text_Image = [_text_imageArr objectAtIndex:_reportIndex];
        PropertyEntity* pro = [NoteViewModel requireDelWithRecordId:text_Image.messageId];
        [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
            
            NoteViewModel* noteViewModel = (NoteViewModel*)viewModel;
            
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
    cell.delegate = self;
    cell.tag = indexPath.section;
    [cell setText_Image:text_image];
    if (_isShowDel) {
        cell.closeBtn.hidden = NO;
        cell.closeBtn.tag = indexPath.section;
        cell.timeLabel.hidden = YES;
        [cell.closeBtn addTarget:self action:@selector(msgDel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
-(void)reportWithIndex:(NSInteger)index
{
    _reportIndex = index;
}
-(void)msgDel:(UIButton*)button
{
    _reportIndex = button.tag;
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确认删除" message:@"是否删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag = 0;
    [alertView show];
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

@end
