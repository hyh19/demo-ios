//
//  VideoRecordViewControllerOne.m
//  Media
//
//  Created by Yuhui Huang on 12/22/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "VideoRecordViewControllerOne.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

/**
 录制视频：使用UIImagePickerController
 http://www.cnblogs.com/kenshincui/p/4186022.html
 */
@interface VideoRecordViewControllerOne () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// 是否录制视频，如果为YES表示录制视频，NO代表拍照。
@property (assign, nonatomic) BOOL isVideo;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
// 播放器，用于录制完视频后播放视频。
@property (strong, nonatomic) AVPlayer *player;
// 照片展示视图
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation VideoRecordViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    _isVideo = NO;
}

// 点击拍照按钮
- (IBAction)takeClick:(UIButton *)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) { // 如果是拍照
        UIImage *image;
        // 如果允许编辑则获得编辑后的照片，否则获取原始照片。
        if (self.imagePicker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage]; // 获取编辑后的照片
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage]; // 获取原始照片
        }
        [self.photo setImage:image]; // 显示照片
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); // 保存到相簿
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) { // 如果是录制视频
        NSURL *URL = [info objectForKey:UIImagePickerControllerMediaURL]; // 视频路径
        NSString *path  =[URL path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            // 保存视频到相簿，注意也可以使用ALAssetsLibrary来保存。
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil); // 保存视频到相簿
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera; // 设置image picker的来源，这里设置为摄像头。
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear; // 设置使用哪个摄像头，这里设置为后置摄像头。
        if (self.isVideo) {
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
            _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo; // 设置摄像头模式（拍照，录制视频）。
        } else {
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        _imagePicker.allowsEditing = YES; // 允许编辑
        _imagePicker.delegate = self; // 设置代理，检测操作。
    }
    return _imagePicker;
}

// 视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息：%@", error.localizedDescription);
    } else {
        NSLog(@"视频保存成功");
        // 录制完之后自动播放
        NSURL *URL = [NSURL fileURLWithPath:videoPath];
        _player = [AVPlayer playerWithURL:URL];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame = self.photo.frame;
        [self.photo.layer addSublayer:playerLayer];
        [_player play];
    }
}

@end
