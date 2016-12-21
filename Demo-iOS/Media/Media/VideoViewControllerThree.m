//
//  VideoViewControllerThree.m
//  Media
//
//  Created by Yuhui Huang on 12/21/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "VideoViewControllerThree.h"
#import <AVFoundation/AVFoundation.h>

/**
 播放视频：使用AVPlayer
 http://www.cnblogs.com/kenshincui/p/4186022.html
 */
@interface VideoViewControllerThree ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation VideoViewControllerThree

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)dealloc {
    [self removeNotificationObserver];
    [self removeKeyPathObserverFromPlayerItem:self.player.currentItem];
}

- (void)setupUI {
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300);
    [self.view.layer addSublayer:playerLayer];
}

- (AVPlayer *)player {
    if (!_player) {
        AVPlayerItem *playerItem = [self getPlayItem];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addProgressObserver];
        [self addKeyPathObserverToPlayerItem:playerItem];
    }
    return _player;
}

- (AVPlayerItem *)getPlayItem {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video.mp4" ofType:nil];
    NSURL *URL = [NSURL fileURLWithPath:path];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:URL];
    return playerItem;
}

- (void)addNotificationObserver {
    // 给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"视频播放完成.");
}

- (void)addProgressObserver {
    AVPlayerItem *playerItem = self.player.currentItem;
    // 这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        NSLog(@"当前播放进度 %.2f.", current/total);
    }];
}

- (void)addKeyPathObserverToPlayerItem:(AVPlayerItem *)playerItem {
    // 监听播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听网络加载情况
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKeyPathObserverFromPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVPlayerItem *playerItem = object;
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放...视频总长度:%.2f", CMTimeGetSeconds(playerItem.duration));
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; // 本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds; // 缓冲总长度
        NSLog(@"共缓冲：%.2f秒", totalBuffer);
    }
}

// 播放或暂停
- (IBAction)playClick:(UIButton *)sender {
    if (self.player.rate == 0) { // 目前是暂停状态
        [self.player play];
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
    } else if (self.player.rate == 1) { // 目前是播放状态
        [self.player pause];
        [sender setTitle:@"Play" forState:UIControlStateNormal];
    }
}

// 切换视频
- (IBAction)replaceClick:(UIButton *)sender {
    [self removeNotificationObserver];
    [self removeKeyPathObserverFromPlayerItem:self.player.currentItem];
    AVPlayerItem *newItem = [self getPlayItem];
    [self addKeyPathObserverToPlayerItem:newItem];
    [self.player replaceCurrentItemWithPlayerItem:newItem];
    [self addNotificationObserver];
}

@end
