//
//  MainViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/3/30.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MainViewController.h"
#import "NoteViewController.h"
#import "MessageViewController.h"
#import "MyViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationController* _noteNav = [[UINavigationController alloc] initWithRootViewController:[[NoteViewController alloc] init]];
        UINavigationController* _messageNav = [[UINavigationController alloc] initWithRootViewController:[[MessageViewController alloc] init]];
        UINavigationController* _myNav = [[UINavigationController alloc] initWithRootViewController:[[MyViewController alloc] init]];
        if (iOS7AndLater) {
            [_noteNav setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"遇见你" image:[UIImage imageNamed:@"tabbarQuotation-dark"] selectedImage:[UIImage imageNamed:@"tabbarQuotationClick"]]];
            
            [_messageNav setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"听你说" image:[UIImage imageNamed:@"tabbarVoice-dark"] selectedImage:[UIImage imageNamed:@"tabbarVoiceClick"]]];
            
            [_myNav setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"tabbarSetup-dark"] selectedImage:[UIImage imageNamed:@"tabbarSetupClick"]]];
        }else{
            UITabBarItem* item1 = [[UITabBarItem alloc] init];
            [item1 setFinishedSelectedImage:[UIImage imageNamed:@"tabbarQuotationClick"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbarQuotation-dark"]];
            item1.title = @"遇见你";
            
            _noteNav.tabBarItem = item1;
            UITabBarItem* item2 = [[UITabBarItem alloc] init];
            [item2 setFinishedSelectedImage:[UIImage imageNamed:@"tabbarVoiceClick"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbarVoice-dark"]];
            item2.title = @"听你说";
            
            _messageNav.tabBarItem = item2;
            UITabBarItem* item3 = [[UITabBarItem alloc] init];
            [item3 setFinishedSelectedImage:[UIImage imageNamed:@"tabbarSetupClick"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbarSetup-dark"]];
            item3.title = @"我";
            _myNav.tabBarItem = item3;
        }
        
        self.viewControllers = @[_noteNav, _messageNav, _myNav];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    [UIBarButtonItem.appearance setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
