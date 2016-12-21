//
//  VideoViewControllerTwo.m
//  Media
//
//  Created by Yuhui Huang on 12/21/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "VideoViewControllerTwo.h"
#import <MediaPlayer/MediaPlayer.h>

/**
 播放视频：使用MPMoviePlayerViewController
 http://www.cnblogs.com/kenshincui/p/4186022.html
 */
@interface VideoViewControllerTwo ()

@property (nonatomic, strong) MPMoviePlayerViewController *playerViewController;

@end

@implementation VideoViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSURL *)getFileURL {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video.mp4" ofType:nil];
    NSURL *URL = [NSURL fileURLWithPath:path];
    return URL;
}

- (NSURL *)getNetworkURL {
    NSString *URLString = @"http://192.168.1.161/video.mp4";
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:URLString];
    return URL;
}

- (MPMoviePlayerViewController *)playerViewController {
    if (!_playerViewController) {
        NSURL *URL = [self getFileURL];
        _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        [self observeNotifications];
    }
    return _playerViewController;
}

- (IBAction)playClick:(UIButton *)sender {
    // 保证每次点击都重新创建视频播放控制器视图，避免再次点击时不播放的问题。
    self.playerViewController = nil;
    [self presentMoviePlayerViewControllerAnimated:self.playerViewController];
}

- (void)observeNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.playerViewController.moviePlayer];
    [center addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.playerViewController.moviePlayer];
}

- (void)mediaPlayerPlaybackStateChange:(NSNotification *)notification {
    switch (self.playerViewController.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li", self.playerViewController.moviePlayer.playbackState);
            break;
    }
}


- (void)mediaPlayerPlaybackFinished:(NSNotification *)notification {
    NSLog(@"播放完成.%li", self.playerViewController.moviePlayer.playbackState);
}

@end
