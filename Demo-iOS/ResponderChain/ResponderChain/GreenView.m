//
//  GreenView.m
//  ResponderChain
//
//  Created by Yuhui Huang on 12/18/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "GreenView.h"

@implementation GreenView

/**
 获取当前View的各级响应者
 http://www.cocoachina.com/ios/20160113/14896.html
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 如果不调用父类的方法，则不会打印EventDebug中的相关信息
//    [super touchesBegan:touches withEvent:event];
    UIResponder *next = [self nextResponder];
    NSMutableString *prefix = @"".mutableCopy;
    
    while (next != nil) {
        NSLog(@"%@%@", prefix, [next class]);
        [prefix appendString: @"--"];
        next = [next nextResponder];
    }
}

@end
