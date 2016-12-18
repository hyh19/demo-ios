//
//  MyView.m
//  CoreGraphics
//
//  Created by Yuhui Huang on 12/18/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "MyView.h"

#define RADIANS(x) ((x)*(M_PI)/180)

@implementation MyView


- (void)drawRect:(CGRect)rect {
    [self drawGlossRect];
}

///-----------------------------------------------------------------------------
/// http://blog.csdn.net/cocoarannie/article/details/9990411
///-----------------------------------------------------------------------------
#pragma mark - UIKit和Core Graphics绘图——字符串，线条，矩形，渐变 -

/**
 绘制字符串
 http://blog.csdn.net/cocoarannie/article/details/9990411
 */
- (void)drawString {
    NSString *string = @"Core Graphics";
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:20],
                            NSForegroundColorAttributeName: [UIColor redColor]};
    [string drawAtPoint:CGPointMake(100, 100) withAttributes:attrs];
}

/**
 绘制图片
 http://blog.csdn.net/cocoarannie/article/details/9990411
 */
- (void)drawImage {
    UIImage *image = [UIImage imageNamed:@"image"];
    [image drawAtPoint:CGPointMake(100, 100)];
}

/**
 绘制直线
 http://blog.csdn.net/cocoarannie/article/details/9990411
 */
- (void)drawLine {
    [[UIColor redColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 200, 200);
    CGContextStrokePath(context);
}

/**
 连续绘制线条，并设置交界样式。
 
 上下文在绘制一条直线后会定格在刚才绘制的线的末端，这样我们可以再通过CGContextAddLineToPoint方
 法来设置立即进行下一条线的绘制。在线的交界处，我们可以设置交界的样式（CGLineJoin），这个枚举中有
 三种样式：
 kCGLineJoinMiter——尖角
 kCGLineJoinBevel——平角
 kCGLineJoinRound——圆形
 
 http://blog.csdn.net/cocoarannie/article/details/9990411
 */
- (void)drawLinesContinuously {
    [[UIColor redColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 6.0);
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddLineToPoint(context, 100, 200);
    CGContextAddLineToPoint(context, 200, 200);
    CGContextStrokePath(context);
}

/**
 绘制矩形
 http://blog.csdn.net/cocoarannie/article/details/9990411
 */
- (void)drawRect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(50, 50, 100, 100);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 3.0);
    CGContextStrokeRect(context, rect);
}

/**
 绘制填充矩形
 http://blog.csdn.net/cocoarannie/article/details/9990411
 */
- (void)drawFillRect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGRect rect = CGRectMake(50, 50, 100, 100);
    CGContextFillRect(context, rect);
}

/**
 绘制线性渐变效果
 http://blog.csdn.net/cocoarannie/article/details/9990411
 */
- (void)drawGradientRect1 {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect strokeRect = CGRectMake(50, 50, 100, 100);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = @[(__bridge id)[UIColor redColor].CGColor,
                        (__bridge id)[UIColor blueColor].CGColor];
    const CGFloat locations[] = {0.0, 1.0};
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(strokeRect), CGRectGetMinY(strokeRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(strokeRect), CGRectGetMaxY(strokeRect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, strokeRect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0); //开始绘制
    CGContextRestoreGState(context);
    
    // 释放资源
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

///-----------------------------------------------------------------------------
/// http://blog.csdn.net/cocoarannie/article/details/10033909
///-----------------------------------------------------------------------------
#pragma mark - UIKit和Core Graphics绘图——绘制虚线，椭圆以及饼图 -

/**
 绘制虚线
 
 虚线绘制主要调用CGContextSetLineDash函数。
 这个函数有4个参数，除了一个是上下文外，phase为初始跳过几个点开始绘制，第三个参数为一个CGFloat
 数组，指定你绘制的样式，绘几个点跳几个点（下面为绘10个点，跳过5个），最后一个参数是上个参数数组元
 素的个数。
 */
- (void)drawLineDash {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetLineDash(context, 0, (CGFloat[]){10, 5}, 2); // 绘制10个跳过5个
    CGContextSetStrokeColorWithColor(context, [[UIColor brownColor] CGColor]);
    CGContextMoveToPoint(context, 0, 100);
    CGContextAddLineToPoint(context, 320, 100);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

/**
 绘制椭圆与圆
 
 CGContextAddEllipseInRect函数
 函数比较简单，只需要上下文和一个矩形参数。默认系统会绘制填充这个矩形内部的最大椭圆，若矩形为正方
 形，则为圆。
 */
- (void)drawEllipse {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, CGRectMake(40, 180, 240, 120));
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

/**
 绘制弧，饼图（Pie Chart）
 
 CGContextAddArc函数是一个画弧的函数，使用并不难，与其他一样，按照参数要求给其赋值就可以了，而且
 这个函数也十分好用，可以借助其实现绘制扇形，绘制饼图。
 */
void drawPieChart(CGContextRef context, CGPoint point, float start_angel, float end_angle, double radius, CGColorRef color) {
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextSetFillColorWithColor(context, color);
    CGContextAddArc(context, point.x, point.y, radius, start_angel, end_angle, 0);
    CGContextFillPath(context);
}

- (void)drawPieCharts {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadow(context, CGSizeMake(0, 10), 10); // 简单的设置了一个阴影
    double radius = 120;
    
    float start = RADIANS(0);
    float end = RADIANS(120);
    drawPieChart(context, self.center, start, end, radius, [[UIColor orangeColor] CGColor]);
    
    start = end;
    end = RADIANS(194);
    drawPieChart(context, self.center, start, end, radius, [[UIColor yellowColor] CGColor]);
    
    start = end;
    end = RADIANS(231);
    drawPieChart(context, self.center, start, end, radius, [[UIColor purpleColor] CGColor]);
    
    start = end;
    end = RADIANS(360);
    drawPieChart(context, self.center, start, end, radius, [[UIColor blueColor] CGColor]);
    
    CGContextRestoreGState(context);
}

///-----------------------------------------------------------------------------
/// http://blog.csdn.net/cocoarannie/article/details/10015345
///-----------------------------------------------------------------------------
#pragma mark - UIKit和Core Graphics绘图——构造路径，阴影以及渐变扩展 -

/**
 用路径画一组对角线
 http://blog.csdn.net/cocoarannie/article/details/10015345
 */
- (void)drawTwoLines {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, screenRect.origin.x, screenRect.origin.y);
    CGPathAddLineToPoint(path, NULL, screenRect.size.width, screenRect.size.height);
    CGPathMoveToPoint(path, NULL, screenRect.size.width, screenRect.origin.y);
    CGPathAddLineToPoint(path, NULL, screenRect.origin.x, screenRect.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 1.0f);
    [[UIColor blueColor] setStroke];
    // 第二个参数为画路径的样式，这里为描线，也可以有填充或者既描线也填充。
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPathRelease(path);
}

/**
 绘制多个矩形
 http://blog.csdn.net/cocoarannie/article/details/10015345
 */
- (void)drawTwoRects {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect rect1 = CGRectMake(20, 20, 200, 100);
    CGRect rect2 = CGRectMake(20, 200, 200, 80);
    CGRect rects[] = {rect1, rect2};
    
    CGPathAddRects(path, NULL, (const CGRect *)rects, 2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 2.0f);
    
    [[UIColor yellowColor] setFill]; // 填充颜色
    [[UIColor blackColor] setStroke]; // 线条颜色
    
    CGContextDrawPath(context, kCGPathFillStroke); // 设置既填充也描线
    
    CGPathRelease(path);
}

/**
 绘制阴影
 
 使用上下文绘制阴影主要用到两个函数
 CGContextSetShadow（）
 三个参数，图形上下文，偏移量（CGSize），模糊值。
 CGContextSetShadowWithColor（）
 增加了一个参数，CGColorRef可以设置阴影的颜色。
 
 http://blog.csdn.net/cocoarannie/article/details/10015345
 */
- (void)drawTwoRectsWithShadow {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect rect1 = CGRectMake(55, 60, 150, 150);
    CGPathAddRect(path, NULL, rect1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextSetShadowWithColor(context, CGSizeMake(10, 10), 20.0f, [[UIColor grayColor] CGColor]);
    [[UIColor purpleColor] setFill];
    CGContextDrawPath(context, kCGPathFill);
    CGPathRelease(path);
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    
    // 由于我们没有对上下文SaveGState和Restore所以，绘制出来的两个矩形都会有阴影。
    CGRect rect2 = CGRectMake(130, 290, 100, 100);
    CGPathAddRect(path2, NULL, rect2);
    CGContextAddPath(context, path2);
    [[UIColor yellowColor] setFill];
    CGContextDrawPath(context, kCGPathFill);
    
    CGPathRelease(path2);
}

/**
 渐变扩展
 
 上篇文章的线性渐变使用的是CGGradientsCreateWithColors函数，这里我们使用细化到颜色成分构成的
 函数来进行CGGradientRef的初始化：
 CGGradientCreateWithColorComponents
 这里比之前函数增加了一个参数，元素数量，而且传入颜色数组也变为了颜色构成的数组。
 
 如果想知道一个颜色比如[UIColor purpleColor]具体构成，可以调用CGColorGetComponents来获取
 其构成，返回一个数组，包括R,G,B以及alpha的值。
 
 http://blog.csdn.net/cocoarannie/article/details/10015345
 */
- (void)drawingGradient
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, (CGFloat[]){
        0.8, 0.2, 0.2, 1.0,
        0.2, 0.8, 0.2, 1.0,
        0.2, 0.2, 0.8, 1.0
    }, (CGFloat[]){
        0.0, 0.5, 1.0
    }, 3);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(100, 200), CGPointMake(220, 280), 0);
    // 修改DrawLinearGradient函数的最后一个参数值来让渐变后边缘颜色扩展到整个屏幕
    CGContextDrawLinearGradient(context, gradient, CGPointMake(100, 200), CGPointMake(220, 280), kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
///-----------------------------------------------------------------------------
/// http://blog.csdn.net/cocoarannie/article/details/10085197
///-----------------------------------------------------------------------------
#pragma mark - UIKit和Core Graphics绘图——绘制光泽，仿射变换与矩阵变换 -
/**
 绘制光泽
 http://blog.csdn.net/cocoarannie/article/details/10085197
 */
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *array = @[(__bridge id)startColor, (__bridge id)endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)array, (CGFloat[]){0.0, 1.0});
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
}

// 在一个矩形上绘制光泽其实可以通过在原有色彩的基础上绘制一层透明度较高的渐变来实现
void drawGlossAndLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    
    drawLinearGradient(context, rect, startColor, endColor);
    
    // 在上半部分绘制透明度渐变
    UIColor *dark = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    UIColor *light = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35];
    CGRect halfRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    drawLinearGradient(context, halfRect, light.CGColor, dark.CGColor);
}

- (void)drawGlossRect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect paintingRect = CGRectMake(50, 50, 200, 200);
    UIColor *lightBlue = [UIColor colorWithRed:105/255.0 green:179/255.0 blue:216/255.0 alpha:1.0];
    UIColor *darkBlue = [UIColor colorWithRed:21/255.0 green:92/255.0 blue:136/255.0 alpha:1.0];
    
    CGContextSaveGState(context);
    CGContextAddRect(context, paintingRect);
    CGContextSetFillColorWithColor(context, lightBlue.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, [[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0] CGColor]);
    CGContextFillPath(context);
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    drawGlossAndLinearGradient(context, paintingRect, lightBlue.CGColor, darkBlue.CGColor);
}

/**
 仿射变换
 在路径中加入仿射变换可以对绘制的图形发生一些变换效果，例如平移、缩放和旋转。
 函数分别为：
 CGAffineTransformMakeTranslation
 CGAffineTransformMakeScale
 CGAffineTransformMakeRotation
 三者都返回一个类型为CGAffineTransform的对象，可以在设置路径的时候添加到参数中。
 http://blog.csdn.net/cocoarannie/article/details/10085197
 */
- (void)pathTranslate {
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform transform = CGAffineTransformMakeTranslation(100, 10);
    CGPathAddRect(path, &transform, CGRectMake(10, 10, 200, 300));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    [[UIColor colorWithRed:.2f green:.6f blue:.8f alpha:1.0f] setFill];
    [[UIColor brownColor] setStroke];
    CGContextSetLineWidth(context, 5.0f);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
    CGPathRelease(path);
}

/**
 矩阵变化
 这里是指二维矩阵变换，对上下文以后绘制的所有内容进行转换。这里不同于Path只是给rect设置变换，矩阵
 变换是以后上下文绘制的内容全部发生变化。
 在上下文中加入矩阵变换的函数为：
 CGContextTranslateCTM
 CGContextScaleCTM
 CGContextRotateCTM（传入弧度）
 http://blog.csdn.net/cocoarannie/article/details/10085197
 */
- (void)contextScale {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(10, 10, 200, 300));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextScaleCTM(context, .5f, .5f);   // 需要在加路径之前使用，上下文设置的所有内容都进行缩放。
    
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 5.0f);
    [[UIColor colorWithRed:.2f green:.6f blue:.8f alpha:1.0f] setFill];
    [[UIColor brownColor] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
    CGPathRelease(path);
}

///-----------------------------------------------------------------------------
/// http://www.cnblogs.com/zenny-chen/archive/2012/02/23/2364152.html
///-----------------------------------------------------------------------------
#pragma mark - Quartz2D之渐变使用初步 -
- (void)drawGradientRect2 {
    
    // 创建Quartz上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    // 创建起点颜色
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.01f, 0.99f, 0.01f, 1.0f});
    
    // 创建终点颜色
    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.99f, 0.99f, 0.01f, 1.0f});
    
    // 创建颜色数组
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,       // 对应起点颜色位置
        1.0f        // 对应终点颜色位置
    });
    
    // 释放颜色数组
    CFRelease(colorArray);
    
    // 释放起点和终点颜色
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0.0f, 0.0f), CGPointMake(320.0f, 460.0f), 0);
    
    // 释放渐变对象
    CGGradientRelease(gradientRef);
}

@end
