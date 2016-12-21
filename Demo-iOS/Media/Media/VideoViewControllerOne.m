//
//  VideoViewControllerOne.m
//  Media
//
//  Created by Yuhui Huang on 12/21/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "VideoViewControllerOne.h"
#import <MediaPlayer/MediaPlayer.h>

/**
 播放视频：使用MPMoviePlayerController
 http://www.cnblogs.com/kenshincui/p/4186022.html
 */
@interface VideoViewControllerOne ()

@property (nonatomic, strong) MPMoviePlayerController *playerController;

@end

@implementation VideoViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 播放
    [self.playerController play];
    
    // 监听通知
    [self observeNotifications];
    
    // 获取缩略图
    [self thumbnailImageRequest];
}

- (void)dealloc {
    // 移除所有通知监听
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

// 创建媒体播放控制器
- (MPMoviePlayerController *)playerController {
    if (!_playerController) {
        NSURL *URL = [self getFileURL];
        _playerController = [[MPMoviePlayerController alloc] initWithContentURL:URL];
        _playerController.view.frame = self.view.bounds;
        _playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_playerController.view];
    }
    return _playerController;
}

// 获取视频缩略图
- (void)thumbnailImageRequest {
    [self.playerController requestThumbnailImagesAtTimes:@[@2.0,@5.5] timeOption:MPMovieTimeOptionNearestKeyFrame];
}

// 监听播放状态
- (void)observeNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.playerController];
    [center addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.playerController];
    [center addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.playerController];
}

// 播放状态改变，注意播放完成时的状态是暂停
- (void)mediaPlayerPlaybackStateChange:(NSNotification *)notification {
    switch (self.playerController.playbackState) {
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
            NSLog(@"播放状态:%li",self.playerController.playbackState);
            break;
    }
}

// 播放完成
- (void)mediaPlayerPlaybackFinished:(NSNotification *)notification {
    NSLog(@"播放完成.%li", self.playerController.playbackState);
}

// 获取缩略图
- (void)mediaPlayerThumbnailRequestFinished:(NSNotification *)notification {
    NSLog(@"视频截图完成.");
    UIImage *image = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    // 保存图片到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

@end
