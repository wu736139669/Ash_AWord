//
//  MessagePublishViewController.m
//  Ash_AWord
//
//  Created by xmfish on 15/4/9.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MessagePublishViewController.h"
#import "MessagePublihViewModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MessagePublishViewController ()<AVAudioRecorderDelegate,UIAlertViewDelegate,UITextViewDelegate,MBProgressHUDDelegate,AVAudioPlayerDelegate,AVAudioSessionDelegate>
{
    UIImage* recordImage;
    UIImageView* recordImageView;
    NSInteger _textLeft;
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_avPlay;
    NSTimer *_timer;
    NSTimer *_playTimer;
    NSURL *_urlPlay;
    NSString* _fileUrl;
}
@end

@implementation MessagePublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"发表声音";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
    
    
    _contentHeight.constant = kScreenHeight-216-64-60;
    _textLeft = 500;
    _contentTextView.placeholder = @"录下你好听的声音，配上美美的文字。so good！";
    _contentTextView.delegate = self;
    
    

    _recordBgView.layer.masksToBounds = YES;
    _recordBgView.layer.cornerRadius = 8.0;
    
    recordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice-record-level"]];
    recordImageView.contentMode = UIViewContentModeBottom;
    recordImageView.clipsToBounds = YES;
    [_recordBgView addSubview:recordImageView];
    [self setImageFrame:0.0];


    _recordBgView.hidden = NO;
    _recordBgView.alpha = 0.0;
    _recordBgView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2-50);
    [self.view addSubview:_recordBgView];
    // 单击的 Recognizer
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
    
    _playBtn.enabled = NO;
    _deleteRecordClick.hidden = YES;
    [self audio];

}
-(void)publish
{
    if (_contentTextView.text.length>0 && _avPlay.duration>0) {
        [MobClick event:kUmen_addmessage];
        
        NSData *audioData = [NSData dataWithContentsOfFile:_fileUrl];
        if (audioData == nil) {
            return;
        }
        
        [MBProgressHUD hudWithView:self.view label:@"发布中"];
        
        PropertyEntity* pro = [MessagePublihViewModel requireAddMessage:_contentTextView.text withFile:audioData withTime:_avPlay.duration];
        [RequireEngine requireWithProperty:pro completionBlock:^(id viewModel) {
            MessagePublihViewModel* messagePublihViewModel = (MessagePublihViewModel*)viewModel;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([messagePublihViewModel success]) {
                [MBProgressHUD checkHudWithView:self.view label:@"发布成功" hidesAfter:1.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotePushSuccessNotificationName object:nil];

                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [MBProgressHUD errorHudWithView:self.view label:messagePublihViewModel.errMessage hidesAfter:1.0];
            }
        } failedBlock:^(NSError *error) {
            [MBProgressHUD errorHudWithView:self.view label:kNetworkErrorTips hidesAfter:2.0];
            
        }];
    }

}
-(void)setImageFrame:(CGFloat)xoffset
{
    recordImageView.frame = CGRectMake(36.5, (1.0-xoffset)*63+12.5, 29, xoffset*63);

}
-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
}
-(void)initAudioPlayer
{
    if (!_avPlay) {
        _avPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:_urlPlay error:nil];
        _avPlay.volume = 1.0f;
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
        _avPlay.delegate = self;
    }
    
}
- (void)audio
{
    if (![self canRecord])
    {
   
        [[[UIAlertView alloc] initWithTitle:nil
                                message:[NSString stringWithFormat:@"应用需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"]
                               delegate:nil
                      cancelButtonTitle:@"好"
                      otherButtonTitles:nil] show];

        return;
    }
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _fileUrl = [NSString stringWithFormat:@"%@/lll.aac", strUrl];
//    _fileUrl = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/lll.wav"];
    NSURL *url = [NSURL fileURLWithPath:_fileUrl];
    _urlPlay = url;
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    NSError * sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];

    
    NSError *error;
    //初始化
    _recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    [_recorder prepareToRecord];
}

-(void)cancel
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"退出此次编辑" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
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
#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_contentTextView resignFirstResponder];
        return NO;
    }
#define MY_MAX 500
    if ((textView.text.length - range.length + text.length) > MY_MAX)
    {
        NSString *substring = [text substringToIndex:MY_MAX - (textView.text.length - range.length)];
        NSMutableString *lastString = [textView.text mutableCopy];
        [lastString replaceCharactersInRange:range withString:substring];
        textView.text = [lastString copy];
        return NO;
    }
    else
    {
        _textLeft = 500-(textView.text.length-range.length+text.length);
        _lengthLabel.text = [NSString stringWithFormat:@"%ld",(long)_textLeft];
        return YES;
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1 && alertView.tag==999) {
        [_recorder deleteRecording];
        _deleteRecordClick.hidden = YES;
        _recordBtn.enabled = YES;
        _playBtn.enabled = NO;
        _totalTimeLabel.text = @"00:00";
        _nowTimeLabel.text = @"00:00";
        _playProgressView.progress = 0;
        _avPlay.delegate = nil;
        _avPlay = nil;
        [_timer invalidate];
        _timer = nil;
        [_playTimer invalidate];
        _playTimer = nil;
        _recorder = nil;
        [self audio];
    }else if (buttonIndex==1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)updateIndicateur
{

    _nowTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)_avPlay.currentTime/60, (long)_avPlay.currentTime%60];
    _totalTimeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)_avPlay.duration/60, (long)_avPlay.duration%60];
    _playProgressView.progress = _avPlay.currentTime/_avPlay.duration;
}


- (void)detectionVoice
{
    [_recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    [self setImageFrame:lowPassResults];

}
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    
    return bCanRecord;
}

- (IBAction)recordBtnDown:(id)sender {

    [_recorder recordForDuration:600];
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    }
    _recordBgView.alpha = 1.0;

}

- (IBAction)recordBtnClick:(id)sender
{
    [_timer invalidate];
    _timer = nil;
    [_recorder stop];
    [UIView animateWithDuration:0.3 animations:^{
        _recordBgView.alpha = 0.0;
    }];
    
}

- (IBAction)playBtnClick:(id)sender {
    

    if (_playBtn.selected == NO) {
        [self initAudioPlayer];
        _playBtn.selected = YES;
        [_avPlay prepareToPlay];
        [_avPlay play];
        if (!_playTimer) {
            _playTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(updateIndicateur) userInfo:nil repeats:YES];
        }
    }else{
        _playBtn.selected = NO;
        [_playTimer invalidate];
        _playTimer = nil;
        [_avPlay pause];

    }

}

- (IBAction)recordDragUp:(id)sender {

    [self recordBtnClick:sender];
}

#pragma mark -AVAudioPlayDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _playBtn.selected = NO;
    [_playTimer invalidate];
    _playTimer = nil;

}
#pragma mark -AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    _playBtn.enabled = YES;
    _recordBtn.enabled = NO;
    _deleteRecordClick.hidden = NO;
    [_timer invalidate];
    _timer = nil;
    [UIView animateWithDuration:0.3 animations:^{
        _recordBgView.alpha = 0.0;
    }];
    [self initAudioPlayer];
    
    NSString* time = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)_avPlay.duration/60,(long)_avPlay.duration%60];
    _totalTimeLabel.text = time;

}
- (IBAction)deleteRecordBtnClick:(id)sender {

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否删除录音" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 999;
    [alertView show];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _timer = nil;
    _playTimer = nil;
}
@end
