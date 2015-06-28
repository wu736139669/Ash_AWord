//
//  NoteViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/30.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "NoteViewController.h"
#import "NotePublishViewController.h"
#import "NoteTableViewCell.h"
#import "NoteViewModel.h"
#import "UpdateViewModel.h"
#import "ReportViewController.h"
#import "TypeSelectView.h"
#import "TypeSelectBgView.h"
@interface NoteViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,NoteTableViewCellDelegate>
{
    NSInteger _page;
    NSMutableArray* _text_imageArr;
    NSInteger _reportIndex;
    TypeSelectView* _typeSelectView;
    TypeSelectBgView* _typeSelectBgView;
    NSInteger _type;   //_type＝0 代表全部,1代表关注.
}
@end

@implementation NoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _page = 1;
        _text_imageArr = [[NSMutableArray alloc] init];
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
    
    self.navigationItem.title = @"遇见你";
    

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
    
    self.navigationItem.leftBarButtonItem = [Ash_UIUtil leftBarButtonItemWithTarget:self action:@selector(publish) image:[UIImage imageNamed:@"navigationButtonPublish"] highlightedImage:[UIImage imageNamed:@"navigationButtonPublishClick"]];
    self.navigationItem.rightBarButtonItem = [Ash_UIUtil leftBarButtonItemWithTarget:self action:@selector(headerBeginRefreshing) image:[UIImage imageNamed:@"navigationButtonRefresh"] highlightedImage:[UIImage imageNamed:@"navigationButtonRefreshClick"]];
    [self headerBeginRefreshing];
    
    [self checkUpdate];
    
    //注册通知的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:kNotePushSuccessNotificationName object:nil];
    
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

        //启动弹出菜单
        NSMutableArray *menuItems = [NSMutableArray array];
        UIMenuItem *messageRepItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(messageRep:)];
        [menuItems addObject:messageRepItem];

       
        _reportIndex = indexPath.section;
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:menuItems];
        [self becomeFirstResponder];
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

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{

    if (  action == @selector(messageRep:) ) {
        return YES;
    }
    return NO;
}
-(BOOL) canBecomeFirstResponder{
    return YES;
}
-(void)checkUpdate
{
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970];
    NSTimeInterval cha = now - [AWordDefault getLastUpdateTime];
    
    //每天一次
    if (cha/86400 < 1 && cha>0) {
        return;
    }
    PropertyEntity* pro = [UpdateViewModel requireUpdate];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        DLog(@"%@",viewModel);
        UpdateViewModel* updateViewModel = (UpdateViewModel*)viewModel;
        if ([updateViewModel success]) {
            if (updateViewModel.needUpdate==1) {
                [AWordDefault setLastUpdateTime:now];
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:updateViewModel.version_info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alertView show];
            }
        }
    } failedBlock:^(NSError *error) {
        
    }];
}
#pragma mark UIAlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d?mt=8", kAppleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
    [MobClick event:kUmen_note];

    PropertyEntity* pro = [NoteViewModel requireWithOrder_by:Order_by_Time withPage:_page withPage_size:DefaultPageSize withType:_type];
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
    cell.delegate = self;
    cell.tag = indexPath.section;
    return cell;
}
#pragma mark publish
-(void)publish
{
    if (![AWordUser sharedInstance].isLogin)
    {
        [LoginViewController presentLoginViewControllerInView:self success:nil];
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }else{
        [self actionSheet:nil clickedButtonAtIndex:1];
    }
   
}
#pragma mark NoteCellDelegate
-(void)reportWithIndex:(NSInteger)index
{
    _reportIndex = index;
}
#pragma mark UIActonSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
//    picker.allowsEditing = YES;
    picker.delegate = self;
    if (buttonIndex == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    if(buttonIndex == 2)
    {
        return;
    }
    [self presentViewController:picker animated:YES completion:nil];

}
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated: YES completion: ^(void){}];

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    // resize image
    image = [Ash_UIUtil fixOrientation:image];
    image = [Ash_UIUtil compressImageDownToPhoneScreenSize:image];
    [picker dismissViewControllerAnimated:NO completion:nil];

    NotePublishViewController* notePublishViewController = [[NotePublishViewController alloc] init];
    notePublishViewController.publishImage = image;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:notePublishViewController];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
