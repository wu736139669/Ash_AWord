//
//  ReportViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customViewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"举报";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(report)];
    
//    _reportContentTextView.backgroundColor = [UIColor lineColor];
    _reportContentTextView.placeholder = @"请输入举报原因";
    _reportNameLabel.text = [NSString stringWithFormat:@"举报作者%@的内容",_authorName];
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
}
-(void)report
{
    
}
-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
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
