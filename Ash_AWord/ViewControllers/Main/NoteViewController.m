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
@interface NoteViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSInteger _page;
    NSMutableArray* _text_imageArr;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customViewDidLoad];
    
    self.navigationItem.title = @"文字";
    self.navigationItem.leftBarButtonItem = [Ash_UIUtil leftBarButtonItemWithTarget:self action:@selector(publish) image:[UIImage imageNamed:@"navigationButtonPublish"] highlightedImage:[UIImage imageNamed:@"navigationButtonPublishClick"]];
    self.navigationItem.rightBarButtonItem = [Ash_UIUtil leftBarButtonItemWithTarget:self action:@selector(headerBeginRefreshing) image:[UIImage imageNamed:@"navigationButtonRefresh"] highlightedImage:[UIImage imageNamed:@"navigationButtonRefreshClick"]];
    [self headerBeginRefreshing];
}

#pragma mark MJRefreshDelegate
-(void)headerRereshing
{
    [_text_imageArr removeAllObjects];
    _page=1;
    [self loadData];
}
-(void)footerRereshing
{
    _page++;
    [self footerEndRefreshing];
}
-(void)loadData
{
    PropertyEntity* pro = [NoteViewModel requireWithOrder_by:Order_by_Time withPage:_page withPage_size:20];
    [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
        
        NoteViewModel* noteViewModel = (NoteViewModel*)viewModel;
        if (noteViewModel.text_imagesArr.count<20) {
            [self.tableView removeFooter];
        }else{
            [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        }
        if (noteViewModel.text_imagesArr) {
            [_text_imageArr addObjectsFromArray:noteViewModel.text_imagesArr];
        }
        [self footerEndRefreshing];
        [self headerEndRefreshing];
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
#pragma mark publish
-(void)publish
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }else{
        [self actionSheet:nil clickedButtonAtIndex:1];
    }
   
}

#pragma mark UIActonSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
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
