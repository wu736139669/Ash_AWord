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
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
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
            if (indexPath.row == 0 ) {
                cell.textLabel.text = @"我发表的图片";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"我发表的声音";
            }
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"推荐给朋友";
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
                    SetUserInfoViewController* setUserInfoViewController = [[SetUserInfoViewController alloc] init];
                    setUserInfoViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:setUserInfoViewController animated:YES];
                }

            }

        }
            break;
        case 1:
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
