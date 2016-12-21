//
//  MyView.m
//  Demo-iOS
//
//  Created by Yuhui Huang on 12/21/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "MyView.h"

@implementation MyView

// 绘制一个矩形边框
//- (void)drawRect:(CGRect)rect {
//    UIRectFrame(CGRectMake(100, 100, 200, 200));
//}

// 绘制一个填充矩形
//- (void)drawRect:(CGRect)rect {
//    UIRectFill(CGRectMake(100, 100, 200, 200));
//}

// 剪裁区域
- (void)drawRect:(CGRect)rect {
    UIRectClip(CGRectMake(100, 100, 10, 10)); // 剪裁区域，该区域外绘制的内容都不显示
    UIRectFill(CGRectMake(100, 100, 200, 200));
}

@end
