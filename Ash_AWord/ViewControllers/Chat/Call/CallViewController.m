//
//  CallViewController.m
//  ChatDemo-UI2.0
//
//  Created by dhc on 15/4/13.
//  Copyright (c) 2015年 dhc. All rights reserved.
//

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "CallViewController.h"
#import "EMCallSession.h"
#import "EaseMob.h"
#define kAlertViewTag_Close 100

@interface CallViewController (){
    NSString * _audioCategory;
    NSString* _avatar;
}

@end

@implementation CallViewController

- (instancetype)initWithSession:(EMCallSession *)session
                     isIncoming:(BOOL)isIncoming withName:(NSString *)name withAvatar:(NSString *)avatar
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _callSession = session;
        _isIncoming = isIncoming;
        _timeLabel.text = @"";
        _timeLength = 0;
        _chatter = name;
        _avatar = avatar;
        [[EaseMob sharedInstance].callManager removeDelegate:self];
        [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
        if(!isIncoming && session.type==eCallSessionTypeAudio)
        {
            [self _beginRing];

        }
        g_callCenter = [[CTCallCenter alloc] init];
        g_callCenter.callEventHandler=^(CTCall* call)
        {
            if(call.callState == CTCallStateIncoming)
            {
                NSLog(@"Call is incoming");
                [_timeTimer invalidate];
                [self _stopRing];
                
                [[EaseMob sharedInstance].callManager asyncEndCall:_callSession.sessionId reason:eCallReason_Hangup];
                [self _close];
            }
        };

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupSubviews];
    
    _nameLabel.text = _chatter;
    if (_callSession.type == eCallSessionTypeVideo) {
        [self _initializeCamera];
        [_session startRunning];
        [self.view addGestureRecognizer:self.tapRecognizer];
        [self.view bringSubviewToFront:_topView];
        [self.view bringSubviewToFront:_actionView];
        
#warning 要提前设置视频通话对方图像的显示区域
        _callSession.displayView = _openGLView;
    }
    
    if (_isIncoming) {
        _statusLabel.text = @"等待接听...";
        [_actionView addSubview:_answerButton];
        [_actionView addSubview:_rejectButton];
    }
    else{
        _statusLabel.text = @"正在建立连接...";
        [_actionView addSubview:_hangupButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_session) {
        [_session stopRunning];
        [_session removeInput:_captureInput];
        [_session removeOutput:_captureOutput];
        _session = nil;
    }
    
    if (_ringPlayer) {
        [_ringPlayer stop];
        _ringPlayer = nil;
    }
    
    if (_timeTimer) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
    
    if (_smallView) {
        [_smallCaptureLayer removeFromSuperlayer];
        _smallCaptureLayer = nil;
        _smallView = nil;
    }
    
    if (_openGLView) {
        _openGLView = nil;
    }
    
    if (_imageDataBuffer) {
        free(_imageDataBuffer);
        _imageDataBuffer = nil;
    }
}

#pragma makr - property

- (UITapGestureRecognizer *)tapRecognizer
{
    if (_tapRecognizer == nil) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
    }
    
    return _tapRecognizer;
}

#pragma mark - subviews

- (void)_setupSubviews
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.image = [UIImage imageNamed:@"callBg.png"];
    [self.view addSubview:bgImageView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, _topView.frame.size.width - 20, 20)];
    _statusLabel.font = [UIFont systemFontOfSize:15.0];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:self.statusLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_statusLabel.frame), _topView.frame.size.width, 15)];
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_timeLabel];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_topView.frame.size.width - 50) / 2, CGRectGetMaxY(_statusLabel.frame) + 20, 50, 50)];
//    _headerImageView.image = DefaultUserIcon;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_avatar] placeholderImage:DefaultUserIcon];
    [_topView addSubview:_headerImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerImageView.frame) + 5, _topView.frame.size.width, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = _chatter;
    [_topView addSubview:_nameLabel];
    
    _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180)];
    _actionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_actionView];

    CGFloat tmpWidth = _actionView.frame.size.width / 2;
    _silenceButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 40) / 2, 20, 40, 40)];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence"] forState:UIControlStateNormal];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence_h"] forState:UIControlStateSelected];
    [_silenceButton addTarget:self action:@selector(silenceAction) forControlEvents:UIControlEventTouchUpInside];
    
    _silenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_silenceButton.frame), CGRectGetMaxY(_silenceButton.frame) + 5, 40, 20)];
    _silenceLabel.backgroundColor = [UIColor clearColor];
    _silenceLabel.textColor = [UIColor whiteColor];
    _silenceLabel.font = [UIFont systemFontOfSize:13.0];
    _silenceLabel.textAlignment = NSTextAlignmentCenter;
    _silenceLabel.text = @"静音";
    
    _speakerOutButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 40) / 2, _silenceButton.frame.origin.y, 40, 40)];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out"] forState:UIControlStateNormal];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out_h"] forState:UIControlStateSelected];
    [_speakerOutButton addTarget:self action:@selector(speakerOutAction) forControlEvents:UIControlEventTouchUpInside];
    
    _speakerOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_speakerOutButton.frame), CGRectGetMaxY(_speakerOutButton.frame) + 5, 40, 20)];
    _speakerOutLabel.backgroundColor = [UIColor clearColor];
    _speakerOutLabel.textColor = [UIColor whiteColor];
    _speakerOutLabel.font = [UIFont systemFontOfSize:13.0];
    _speakerOutLabel.textAlignment = NSTextAlignmentCenter;
    _speakerOutLabel.text = @"免提";
    
    _rejectButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 100) / 2, CGRectGetMaxY(_speakerOutLabel.frame) + 30, 100, 40)];
    [_rejectButton setTitle:@"拒接" forState:UIControlStateNormal];
    [_rejectButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_rejectButton addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    
    _answerButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 100) / 2, _rejectButton.frame.origin.y, 100, 40)];
    [_answerButton setTitle:@"接听" forState:UIControlStateNormal];
    [_answerButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
    
    _hangupButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, _rejectButton.frame.origin.y, 200, 40)];
    [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
    [_hangupButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_hangupButton addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_initializeCamera
{
    //1.大窗口显示层
    _openGLView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _openGLView.backgroundColor = [UIColor clearColor];
    _openGLView.sessionPreset = AVCaptureSessionPreset352x288;
    [self.view addSubview:_openGLView];
    
    //2.小窗口视图
    CGFloat width = 80;
    CGFloat height = _openGLView.frame.size.height / _openGLView.frame.size.width * width;
    _smallView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, CGRectGetMaxY(_statusLabel.frame), width, height)];
    _smallView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_smallView];
    
    //3.创建会话层
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:_openGLView.sessionPreset];
    
    //4.创建、配置输入设备
    AVCaptureDevice *device;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *tmp in devices)
    {
        if (tmp.position == AVCaptureDevicePositionFront)
        {
            device = tmp;
            break;
        }
    }
    
    NSError *error = nil;
    _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    [_session beginConfiguration];
    if(!error){
        [_session addInput:_captureInput];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error.localizedFailureReason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    //5.创建、配置输出
    _captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    _captureOutput.videoSettings = _openGLView.outputSettings;
//    [[_captureOutput connectionWithMediaType:AVMediaTypeVideo] setVideoMinFrameDuration:CMTimeMake(1, 15)];
    _captureOutput.minFrameDuration = CMTimeMake(1, 15);
//    _captureOutput.minFrameDuration = _openGLView.videoMinFrameDuration;
    _captureOutput.alwaysDiscardsLateVideoFrames = YES;
    dispatch_queue_t outQueue = dispatch_queue_create("com.gh.cecall", NULL);
    [_captureOutput setSampleBufferDelegate:self queue:outQueue];
    [_session addOutput:_captureOutput];
    [_session commitConfiguration];
    
    //6.小窗口显示层
    _smallCaptureLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _smallCaptureLayer.frame = CGRectMake(0, 0, width, height);
    _smallCaptureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_smallView.layer addSublayer:_smallCaptureLayer];
}

#pragma mark - ring

- (void)_beginRing
{
    [_ringPlayer stop];

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    [audioSession setActive:YES error:nil];
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];

    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)_stopRing
{
    [_ringPlayer stop];
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
}

#pragma mark - private

- (void)_insertMessageWithStr:(NSString *)str
{
    EMChatText *chatText = [[EMChatText alloc] initWithText:str];
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:_callSession.sessionChatter bodies:@[textBody]];
    message.isRead = YES;
    message.deliveryState = eMessageDeliveryState_Delivered;
    [[EaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"insertCallMessage" object:message];
}

- (void)_close
{
    _callSession = nil;
    _openGLView.hidden = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [_timeTimer invalidate];
    _timeTimer = nil;
    
    [_session stopRunning];
    [_session removeInput:_captureInput];
    [_session removeOutput:_captureOutput];
    _session = nil;
    
    [_smallCaptureLayer removeFromSuperlayer];
    _smallCaptureLayer = nil;
    _smallView = nil;
    
    [_openGLView removeFromSuperview];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        [[EaseMob sharedInstance].callManager removeDelegate:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"callControllerClose" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewTag_Close)
    {
        [[EaseMob sharedInstance].callManager asyncEndCall:_callSession.sessionId reason:eCallReason_Null];
        _callSession = nil;
        [self _close];
    }
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

void YUV420spRotate90(UInt8 *  dst, UInt8* src, size_t srcWidth, size_t srcHeight)
{
    size_t wh = srcWidth * srcHeight;
    size_t uvHeight = srcHeight >> 1;//uvHeight = height / 2
    size_t uvWidth = srcWidth>>1;
    size_t uvwh = wh>>2;
    //旋转Y
    int k = 0;
    for(int i = 0; i < srcWidth; i++) {
        int nPos = wh-srcWidth;
        for(int j = 0; j < srcHeight; j++) {
            dst[k] = src[nPos + i];
            k++;
            nPos -= srcWidth;
        }
    }
    for(int i = 0; i < uvWidth; i++) {
        int nPos = wh+uvwh-uvWidth;
        for(int j = 0; j < uvHeight; j++) {
            dst[k] = src[nPos + i];
            dst[k+uvwh] = src[nPos + i+uvwh];
            k++;
            nPos -= uvWidth;
        }
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (_callSession.status != eCallSessionStatusAccepted) {
        return;
    }
    
#warning 捕捉数据输出，根据自己需求可随意更改
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
    {
//        UInt8 *bufferbasePtr = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
        UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1);
//        printf("addr diff1:%d,diff2:%d\n",bufferPtr-bufferbasePtr,bufferPtr1-bufferPtr);
        
//        size_t buffeSize = CVPixelBufferGetDataSize(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
//        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t bytesrow0 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
        size_t bytesrow1  = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 1);
//        size_t bytesrow2 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 2);
//        printf("buffeSize:%d,width:%d,height:%d,bytesPerRow:%d,bytesrow0 :%d,bytesrow1 :%d,bytesrow2 :%d\n",buffeSize,width,height,bytesPerRow,bytesrow0,bytesrow1,bytesrow2);

        if (_imageDataBuffer == nil) {
            _imageDataBuffer = (UInt8 *)malloc(width * height * 3 / 2);
        }
        UInt8 *pY = bufferPtr;
        UInt8 *pUV = bufferPtr1;
        UInt8 *pU = _imageDataBuffer + width * height;
        UInt8 *pV = pU + width * height / 4;
        for(int i =0; i < height; i++)
        {
            memcpy(_imageDataBuffer + i * width, pY + i * bytesrow0, width);
        }
        
        for(int j = 0; j < height / 2; j++)
        {
            for(int i = 0; i < width / 2; i++)
            {
                *(pU++) = pUV[i<<1];
                *(pV++) = pUV[(i<<1) + 1];
            }
            pUV += bytesrow1;
        }
        
        YUV420spRotate90(bufferPtr, _imageDataBuffer, width, height);
        [[EaseMob sharedInstance].callManager processPreviewData:(char *)bufferPtr width:width height:height];
        
        /*We unlock the buffer*/
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
}


#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession
                    changeReason:(EMCallStatusChangedReason)reason
                           error:(EMError *)error
{
    if(![_callSession.sessionId isEqualToString:callSession.sessionId]){
        return;
    }
    
//    [self hideHud];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(error){
        [self _stopRing];

        _statusLabel.text = @"连接失败";
        [self _insertMessageWithStr:@"通话失败"];
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:NSLocalizedString(error.description, error.description) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        errorAlert.tag = kAlertViewTag_Close;
        [errorAlert show];
        
        return;
    }
    
    if (callSession.status == eCallSessionStatusDisconnected) {
        [self _stopRing];

        NSLog(@"callSession.status == eCallSessionStatusDisconnected");
        _statusLabel.text = @"通话已挂断";
        NSString *str = @"通话结束";
        if(_timeLength == 0)
        {
            if (reason == eCallReason_Hangup) {
                str = @"取消通话";
            }
            else if (reason == eCallReason_Reject){
                str = @"拒接通话";
            }
            else if (reason == eCallReason_Busy){
                str = @"正在通话中";
            }
        }
        [self _insertMessageWithStr:str];
        [self _close];
    }
    else if (callSession.status == eCallSessionStatusAccepted)
    {
        [self _stopRing];

        _statusLabel.text = @"可以通话了...";
        _timeLength = 0;
        _timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];

        if(_isIncoming)
        {
            [_answerButton removeFromSuperview];
            [_rejectButton removeFromSuperview];
            [_actionView addSubview:_hangupButton];
        }
        [_actionView addSubview:_silenceButton];
        [_actionView addSubview:_silenceLabel];
        [_actionView addSubview:_speakerOutButton];
        [_actionView addSubview:_speakerOutLabel];
    }
}

#pragma mark - UITapGestureRecognizer

- (void)viewTapAction:(UITapGestureRecognizer *)tap
{
    _topView.hidden = !_topView.hidden;
    _actionView.hidden = !_actionView.hidden;
}

#pragma mark - action

- (void)silenceAction
{
    _silenceButton.selected = !_silenceButton.selected;
    [[EaseMob sharedInstance].callManager markCallSession:_callSession.sessionId asSilence:_silenceButton.selected];
}

- (void)speakerOutAction
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (_speakerOutButton.selected) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }else {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
    [audioSession setActive:YES error:nil];
    _speakerOutButton.selected = !_speakerOutButton.selected;
}

- (void)rejectAction
{
    [_timeTimer invalidate];
    [self _stopRing];
//    [self showHint:@"拒接通话..."];
    [MBProgressHUD hudWithView:self.view label:@"拒接通话..."];

    
    [[EaseMob sharedInstance].callManager asyncEndCall:_callSession.sessionId reason:eCallReason_Reject];
}

- (void)answerAction
{
//    [self showHint:@"正在初始化通话..."];
    [MBProgressHUD hudWithView:self.view label:@"正在初始化通话..."];

    [self _stopRing];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    _audioCategory = audioSession.category;
    if(![_audioCategory isEqualToString:AVAudioSessionCategoryPlayAndRecord]){
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
    
    [[EaseMob sharedInstance].callManager asyncAnswerCall:_callSession.sessionId];
}

- (void)hangupAction
{
    _openGLView.hidden = YES;
    [_timeTimer invalidate];
    [self _stopRing];
//    [self showHint:@"正在结束通话..."];
    [MBProgressHUD hudWithView:self.view label:@"正在结束通话..."];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:_audioCategory error:nil];
    [audioSession setActive:YES error:nil];
    
    [[EaseMob sharedInstance].callManager asyncEndCall:_callSession.sessionId reason:eCallReason_Hangup];
}

+ (BOOL)canVideoWithAlertStr:(NSString *)str
{
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        if(!([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized)){
            NSString* alertMsg = [NSString stringWithFormat:@"%@请在iOS\"设置中\"-\"隐私\"-\"相机\"中打开",str];
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:alertMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alt show];
            return NO;
        }
    }
    
    return YES;
}

@end
