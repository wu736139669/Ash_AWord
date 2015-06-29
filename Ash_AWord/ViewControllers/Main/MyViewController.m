//
//  MyViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/30.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MyViewController.h"
#import "UMSocial.h"
#import "LoginViewModel.h"
#import "LoginViewController.h"
#import "SetUpViewController.h"
#import "MyNoteViewController.h"
#import "MyMessageViewController.h"
#import "SetUserInfoViewController.h"
#import "MessageListViewController.h"
#import "MyMessageTableViewCell.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "PersonalInfoViewController.h"
#import "PraiseUserListViewController.h"
#import "MyRelateViewController.h"
@interface MyViewController ()
{
    NSArray* cellTitleArr;
    
}
@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customViewDidLoad];

    
    self.navigationItem.title = @"我的";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    self.navigationItem.rightBarButtonItem = [Ash_UIUtil leftBarButtonItemWithTarget:self action:@selector(goSetUp) image:[UIImage imageNamed:@"mine-setting-icon"] highlightedImage:[UIImage imageNamed:@"mine-setting-icon-click"]];
    
    //注册通知的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kLoginSuccessNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kLogoutSuccessNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kReceiveMessage object:nil];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)goSetUp
{
    SetUpViewController* setUpViewController = [[SetUpViewController alloc] init];
    setUpViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setUpViewController animated:YES];
}
-(void)loginSuccess
{
    [self.tableView reloadData];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2 || section == 3) {
        return 2;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"cell";
    if (indexPath.section == 4 || (indexPath.section==2&&indexPath.row==1) || indexPath.section==1) {
        cellIdentifier = @"MyMessageTableViewCell";
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        if (indexPath.section == 4 || (indexPath.section==1&&indexPath.row==1) || indexPath.section==1) {
            UINib* nib = nil;
            nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    switch (indexPath.section) {
        case 0:
        {
            
            if ([AWordUser sharedInstance].isLogin) {
                cell.textLabel.text = [AWordUser sharedInstance].userName;
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[AWordUser sharedInstance].userAvatar] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
            }else{
                cell.textLabel.text = @"登录";
                [cell.imageView setImage:[UIImage imageNamed:@"defaultUserIcon"]];
            }
            
            

        }
            break;
        case 1:
        {
            cell.textLabel.text = @"与我相关";
            [(MyMessageTableViewCell*)cell setUnReadColor:[UIColor appMainColor]];
            [(MyMessageTableViewCell*)cell setUnReadCount:[AWordUser sharedInstance].notReadCommentNum];
        }
            break;
        case 2:
        {
            if (indexPath.row == 0 ) {
                cell.textLabel.text = @"我的关注";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"我的粉丝";
                [(MyMessageTableViewCell*)cell setUnReadColor:[UIColor appMainColor]];
                [(MyMessageTableViewCell*)cell setUnReadCount:[AWordUser sharedInstance].myNewFollowerCount];
            }
        }
            break;
        case 3:
        {
            if (indexPath.row == 0 ) {
                cell.textLabel.text = @"我发表的图片";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"我发表的声音";
            }
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"消息";
            
            NSInteger count = [((AppDelegate*)[UIApplication sharedApplication].delegate).mainViewController setupUnreadMessageCount];
            [(MyMessageTableViewCell*)cell setUnReadColor:[UIColor appMainColor]];
            [(MyMessageTableViewCell*)cell setUnReadCount:count];
            
        }
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if (![AWordUser sharedInstance].isLogin)
            {
                [LoginViewController presentLoginViewControllerInView:self success:nil];
            }else{
                if([AWordUser sharedInstance].loginType == 1)
                {
                    
                    PersonalInfoViewController* personalInfoViewController = [[PersonalInfoViewController alloc] init];
                    personalInfoViewController.hidesBottomBarWhenPushed = YES;
                    personalInfoViewController.otherUserId = [AWordUser sharedInstance].uid;
                    [self.navigationController pushViewController:personalInfoViewController animated:YES];
                }

            }

        }
            break;
        case 1:
        {
            if (![AWordUser sharedInstance].isLogin)
            {
                [LoginViewController presentLoginViewControllerInView:self success:nil];
            }else{
                MyRelateViewController* myRelateViewController = [[MyRelateViewController alloc] init];
                myRelateViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myRelateViewController animated:YES];
            }
            
        }
            break;
        case 2:
        {
            if (![AWordUser sharedInstance].isLogin)
            {
                [LoginViewController presentLoginViewControllerInView:self success:nil];
            }else
            {
                PraiseUserListViewController* praiseUserListViewController = [[PraiseUserListViewController alloc] init];
                praiseUserListViewController.targetId = [AWordUser sharedInstance].uid;
                praiseUserListViewController.userListType = UserList_Fans_Type;
                praiseUserListViewController.hidesBottomBarWhenPushed = YES;
                if (indexPath.row == 0) {
                    praiseUserListViewController.userListType = UserList_Attention_Type;
                }else{
                    praiseUserListViewController.userListType = UserList_Fans_Type;
                }
                [self.navigationController pushViewController:praiseUserListViewController animated:YES];

            }

        }
            break;
        case 3:
        {
            if (![AWordUser sharedInstance].isLogin)
            {
                [LoginViewController presentLoginViewControllerInView:self success:nil];
            }else
            {
                if (indexPath.row == 0) {
                    MyNoteViewController* myNoteViewController = [[MyNoteViewController alloc] init];
                    myNoteViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myNoteViewController animated:YES];
                }else{
                    MyMessageViewController* myNoteViewController = [[MyMessageViewController alloc] init];
                    myNoteViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myNoteViewController animated:YES];
                }
            }
            
        }
            break;
        case 4:
        {
            MessageListViewController* messageListViewController = [[MessageListViewController alloc] init];
            messageListViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:messageListViewController animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
