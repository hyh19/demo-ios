//
//  ViewController.m
//  Media
//
//  Created by Yuhui Huang on 12/21/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self playSoundEffect:@"sound.caf"];
}

/**
 播放音效完成后的回调函数
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData) {
    NSLog(@"播放完成...");
}

/**
 播放音效文件
 http://www.cnblogs.com/kenshincui/p/4186022.html
 */
- (void)playSoundEffect:(NSString *)name {
    
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    
    NSURL *fileURL = [NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID = 0;
    // 此函数会将音效文件加入到系统音频服务中并返回一个长整形ID
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileURL), &soundID);
    
    // 播放完成后的回调操作
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    // 播放音效
    AudioServicesPlaySystemSound(soundID);
    // 播放音效并震动
    AudioServicesPlayAlertSound(soundID);
}


@end
