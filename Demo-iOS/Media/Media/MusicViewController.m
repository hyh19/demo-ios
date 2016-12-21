//
//  MusicViewController.m
//  Media
//
//  Created by Yuhui Huang on 12/21/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "MusicViewController.h"
#import <AVFoundation/AVFoundation.h>

/**
 播放音乐文件
 http://www.cnblogs.com/kenshincui/p/4186022.html
 */
@interface MusicViewController () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self play];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 开启远程监控事件，监听耳机等的操作
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 注销远程监控事件
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}

- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSString *musicFile = [[NSBundle mainBundle]pathForResource:@"music.mp3" ofType:nil];
        NSURL *fileURL = [NSURL fileURLWithPath:musicFile];
        NSError *error = nil;
        // 初始化播放器，注意这里的URL参数只能是文件路径，不支持HTTP URL
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        
        // 设置播放器属性
        _audioPlayer.numberOfLoops = 0; // 设置为0不循环
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay]; // 加载音频文件到缓存
        if (error) {
            NSLog(@"初始化播放器过程发生错误，错误信息：%@", error.localizedDescription);
            return nil;
        }
        
        // 设置后台播放模式
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        // 添加通知，拔出耳机后暂停播放。
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return _audioPlayer;
}

- (void)play {
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate = [NSDate distantPast]; // 恢复定时器
    }
}

- (void)pause {
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        self.timer.fireDate = [NSDate distantFuture]; // 暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复。
    }
}

- (void)updateProgress {
    float progress = self.audioPlayer.currentTime/self.audioPlayer.duration;
    NSLog(@"Pgoress ---- %f", progress);
}

// 输出设备改变的回调操作
- (void)routeChange:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    int changeReason = [info[AVAudioSessionRouteChangeReasonKey] intValue];
    // 旧输出不可用
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription = info[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = [routeDescription.outputs firstObject];
        // 原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"音乐播放完成...");
    // 根据实际情况播放完成可以将会话关闭，其他音频应用继续播放。
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.audioPlayer isPlaying]) {
        [self pause];
    } else {
        [self play];
    }
}

@end
