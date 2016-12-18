//
//  CircleView.m
//  LXDEventChain
//
//  Created by 滕雪 on 15/12/27.
//  Copyright © 2015年 滕雪. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
    [path stroke];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击圆形区域");
}

/**
 只有圆形区域可以点击，其他区域不可点击
 http://www.cocoachina.com/ios/20160113/14896.html
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
    return [path containsPoint: point];
}

@end
