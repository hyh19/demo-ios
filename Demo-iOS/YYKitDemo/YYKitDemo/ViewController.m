//
//  ViewController.m
//  YYKitDemo
//
//  Created by Yuhui Huang on 23/12/2016.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "ViewController.h"
#import <YYKit/YYKit.h>
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface MyView : UIView

@end

@implementation MyView

- (void)drawRect:(CGRect)rect {
    [self bezierPathWithText];
}

// 用文字来生成贝塞尔曲线
- (void)bezierPathWithText {
    [[UIColor redColor] setStroke];
    UIBezierPath *path = [UIBezierPath bezierPathWithText:@"Hello, YYKit!" font:[UIFont systemFontOfSize:30]];
    [path stroke];
}

@end

@interface ViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bezierPathWithText];
}

// 截图
- (void)snapshotImage {
    UIImage *image = [self.view snapshotImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (void)selecteText {
    self.view.backgroundColor = [UIColor yellowColor];
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor redColor];
    textField.text = @"Hello, YYKit!";
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(200, 40));
        make.center.equalTo(self.view);
    }];
    self.textField = textField;
}

// 用文字来生成贝塞尔曲线
- (void)bezierPathWithText {
    MyView *view = [[MyView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(300, 100));
        make.center.equalTo(self.view);
    }];
}

@end
