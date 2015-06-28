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
#import <AVFoundation/AVFoundation.h>
#import "ChatMainViewController.h"
#import "CallViewController.h"
#import "EMCDDeviceManager.h"
#import "AppDelegate.h"
@interface MainViewController ()<UIAlertViewDelegate, IChatManagerDelegate, EMCallManagerDelegate>
{
    UINavigationController* _noteNav;
    UINavigationController* _messageNav;
    UINavigationController* _myNav;
    EMConnectionState _connectionState;

}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

static const CGFloat kDefaultPlaySoundInterval = 10.0;
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kMessageType = @"MessageType";

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _noteNav = [[UINavigationController alloc] initWithRootViewController:[[NoteViewController alloc] init]];
        _messageNav = [[UINavigationController alloc] initWithRootViewController:[[MessageViewController alloc] init]];
        _myNav = [[UINavigationController alloc] initWithRootViewController:[[MyViewController alloc] init]];
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
    [[UITabBar appearance] setTintColor:[UIColor appMainColor]];
    
    [UIBarButtonItem.appearance setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    
    
    //聊天用的
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
#warning 把self注册为SDK的delegate
    [self registerNotifications];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callControllerClose:) name:@"callControllerClose" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:kLogoutSuccessNotificationName object:nil];
    self.selectedIndex = 0;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的

    [self didUnreadMessagesCountChanged];

}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
//                [[ApplyViewController shareController] clear];
//                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            } onQueue:nil];
        }
    }
    else if (alertView.tag == 100) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    } else if (alertView.tag == 101) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}




// 统计未读消息数
-(NSInteger)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];

    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_myNav) {
        if (unreadCount > 0) {
            _myNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _myNav.tabBarItem.badgeValue = nil;
        }
    }
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
    return unreadCount;

}


- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
}

#pragma mark - call

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    if (!bCanRecord) {
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"未获得授权使用麦克风" message:@"请在iOS\"设置中\"-\"隐私\"-\"麦克风\"中打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alt show];
    }
    
    return bCanRecord;
}


#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveMessage object:nil];

    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
//    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    self.lastPlaySoundDate = [NSDate date];

    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        return;
    }
    
    //保存最后一次响铃时间
    
    UIViewController* viewController = [AppDelegate visibleViewController];
    if (![viewController isKindOfClass:[ChatMainViewController class]]) {
        // 收到消息时，播放音频
        [[EMCDDeviceManager sharedInstance] playNewMessageSound];
        // 收到消息时，震动
        [[EMCDDeviceManager sharedInstance] playVibration];
    }

}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.vidio", @"Vidio");
            }
                break;
            default:
                break;
        }
        
        NSString *title  = @"";
        if (message.ext)
        {
            title = [message.ext objectForKey:@"username"];
        }
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:[message.ext objectForKey:@"username"] forKey:kConversationChatter];
    
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    DLog(@"%ld",application.applicationIconBadgeNumber);
    application.applicationIconBadgeNumber += 1;
}





#pragma mark - IChatManagerDelegate 登录状态变化
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    [self setupUnreadMessageCount];
}
- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    [MBProgressHUD checkHudWithView:self.view label:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...") hidesAfter:1.0];
//    [self hideHud];
//    [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
//    [self hideHud];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//
//    if (error) {
//        [MBProgressHUD checkHudWithView:self.view label:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection") hidesAfter:1.0];
//    }else{
//        [MBProgressHUD checkHudWithView:self.view label:NSLocalizedString(@"reconnection.success", @"reconnection successful！") hidesAfter:1.0];
//    }
}

#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    if (callSession.status == eCallSessionStatusConnected)
    {
        EMError *error = nil;
        do {
            BOOL isShowPicker = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowPicker"] boolValue];
            if (isShowPicker) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:@"不能进行通话"];
                break;
            }
            
            if (![self canRecord]) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:@"不能进行通话"];
                break;
            }
            
#warning 在后台不能进行视频通话
            if(callSession.type == eCallSessionTypeVideo && ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground || ![CallViewController canVideoWithAlertStr:@"有人想与你视频,如果需要视频,"])){
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:@"不能进行视频通话"];
                break;
            }
            
            if (!isShowPicker){
                [[EaseMob sharedInstance].callManager removeDelegate:self];
                CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:YES withName:@"" withAvatar:@""];
                callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:callController animated:NO completion:nil];
            }
        } while (0);
        
        if (error) {
            [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Hangup];
            return;
        }
    }
}
- (void)callOutWithChatter:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        if (![self canRecord]) {
            return;
        }
        
        EMError *error = nil;
        NSString *chatter = [object objectForKey:@"chatter"];
        EMCallSessionType type = [[object objectForKey:@"type"] intValue];
        NSString* username = [object objectForKey:@"username"];
        NSString* useravatar = [object objectForKey:@"useravatar"];
        EMCallSession *callSession = nil;
        if (type == eCallSessionTypeAudio) {
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:50 error:&error];
        }
        else if (type == eCallSessionTypeVideo){
            if (![CallViewController canVideoWithAlertStr:@""]) {
                return;
            }
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:50 error:&error];
        }
        
        if (callSession && !error) {
            [[EaseMob sharedInstance].callManager removeDelegate:self];
            
            CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:NO withName:username withAvatar:useravatar];
            callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:callController animated:NO completion:nil];
        }
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error") message:error.description delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (void)callControllerClose:(NSNotification *)notification
{
    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    [audioSession setActive:YES error:nil];
    
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}
#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatMainViewController class]]) {
        ChatMainViewController *chatController = (ChatMainViewController *)self.navigationController.topViewController;
//        [chatController hideImagePicker];
    }
    else if(_myNav)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_myNav];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatMainViewController class]]) {
            ChatMainViewController *chatController = (ChatMainViewController *)self.navigationController.topViewController;
//            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatMainViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
//                    NSString *conversationChatter = userInfo[kConversationChatter];
//                    ChatMainViewController *chatViewController = (ChatMainViewController *)obj;
//                    if (![chatViewController.chatter isEqualToString:conversationChatter])
//                    {
//                        [self.navigationController popViewControllerAnimated:NO];
//                        EMMessageType messageType = [userInfo[kMessageType] intValue];
//                        chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//                        switch (messageType) {
//                            case eMessageTypeGroupChat:
//                            {
//                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//                                for (EMGroup *group in groupArray) {
//                                    if ([group.groupId isEqualToString:conversationChatter]) {
//                                        chatViewController.title = group.groupSubject;
//                                        break;
//                                    }
//                                }
//                            }
//                                break;
//                            default:
//                                chatViewController.title = conversationChatter;
//                                break;
//                        }
//                        [self.navigationController pushViewController:chatViewController animated:NO];
//                    }
//                    *stop= YES;
                }
            }
            else
            {
//                ChatViewController *chatViewController = (ChatViewController *)obj;
//                NSString *conversationChatter = userInfo[kConversationChatter];
//                EMMessageType messageType = [userInfo[kMessageType] intValue];
//                chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//                switch (messageType) {
//                    case eMessageTypeGroupChat:
//                    {
//                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//                        for (EMGroup *group in groupArray) {
//                            if ([group.groupId isEqualToString:conversationChatter]) {
//                                chatViewController.title = group.groupSubject;
//                                break;
//                            }
//                        }
//                    }
//                        break;
//                    default:
//                        chatViewController.title = conversationChatter;
//                        break;
//                }
//                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_myNav)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_myNav];
    }
}

- (void)dealloc
{
    [self unregisterNotifications];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
