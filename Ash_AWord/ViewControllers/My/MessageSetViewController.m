//
//  MessageSetViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/6/28.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MessageSetViewController.h"
#import "MessageSetTableViewCell.h"
#import "EMAlertView.h"
@interface MessageSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    EMPushNotificationNoDisturbStatus _noDisturbingStatus;
    NSInteger _noDisturbingStart;
    NSInteger _noDisturbingEnd;
}
@end

@implementation MessageSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customViewDidLoad];
    self.title = @"消息推送设置";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
   

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(savePushOptions)];
    _noDisturbingStart = -1;
    _noDisturbingEnd = -1;
    _noDisturbingStatus = -1;
    [self refreshPushOptions];

    [self.tableView reloadData];
}
#pragma mark - action

- (void)savePushOptions
{
    BOOL isUpdate = NO;
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    
    if (options.noDisturbingStartH != _noDisturbingStart || options.noDisturbingEndH != _noDisturbingEnd){
        isUpdate = YES;
        options.noDisturbStatus = _noDisturbingStatus;
        options.noDisturbingStartH = _noDisturbingStart;
        options.noDisturbingEndH = _noDisturbingEnd;
    }
    
    if (isUpdate) {
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {
            if (!error) {
                [MBProgressHUD checkHudWithView:self.view label:@"保存成功" hidesAfter:1.0];
            }else{
                [MBProgressHUD checkHudWithView:self.view label:@"服务器异常,保存失败" hidesAfter:1.0];

            }
        } onQueue:nil];
    }
    
}


- (void)refreshPushOptions
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    _noDisturbingStatus = options.noDisturbStatus;
    if (_noDisturbingStatus != ePushNotificationNoDisturbStatusClose) {
        _noDisturbingStart = options.noDisturbingStartH;
        _noDisturbingEnd = options.noDisturbingEndH;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"setting.notDisturb", @"No disturbing");
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"MessageSetTableViewCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"setting.open", @"Open");
        cell.accessoryType = _noDisturbingStatus == ePushNotificationNoDisturbStatusDay ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = NSLocalizedString(@"setting.nightOpen", @"only open at night (22:00 - 7:00)");
        cell.accessoryType = _noDisturbingStatus == ePushNotificationNoDisturbStatusCustom ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = NSLocalizedString(@"setting.close", @"Close");
        cell.accessoryType = _noDisturbingStatus == ePushNotificationNoDisturbStatusClose ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL needReload = YES;
    
    switch (indexPath.row) {
        case 0:
        {
            needReload = NO;
            [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                    message:NSLocalizedString(@"setting.sureNotDisturb", @"this setting will cause all day in the don't disturb mode, will no longer receive push messages. Whether or not to continue?")
                            completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                                switch (buttonIndex) {
                                    case 0: {
                                    } break;
                                    default: {
                                        self->_noDisturbingStart = 0;
                                        self->_noDisturbingEnd = 24;
                                        self->_noDisturbingStatus = ePushNotificationNoDisturbStatusDay;
                                        [tableView reloadData];
                                    } break;
                                }
                                
                            } cancelButtonTitle:NSLocalizedString(@"no", @"NO")
                          otherButtonTitles:NSLocalizedString(@"yes", @"YES"), nil];
            
        } break;
        case 1:
        {
            _noDisturbingStart = 22;
            _noDisturbingEnd = 7;
            _noDisturbingStatus = ePushNotificationNoDisturbStatusCustom;
        }
            break;
        case 2:
        {
            _noDisturbingStart = -1;
            _noDisturbingEnd = -1;
            _noDisturbingStatus = ePushNotificationNoDisturbStatusClose;
        }
            break;
            
        default:
            break;
    }
    
    if (needReload) {
        [tableView reloadData];
    }

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
