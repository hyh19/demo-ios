//
//  ViewController.m
//  NSOperation
//
//  Created by Yuhui Huang on 12/13/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "ViewController.h"
#import "YHOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

///-----------------------------------------------------------------------------
/// 疯狂iOS讲义（下）
///-----------------------------------------------------------------------------
#pragma mark - 疯狂iOS讲义（下） -

/**
 疯狂iOS讲义（下）
 */
- (void)addBlockOperationToQueue {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"%i----%@", i, [NSThread currentThread]);
        }
    }];
    
    [queue addOperation:op];
}

/**
 疯狂iOS讲义（下）
 */
- (void)addInvocationOperationToQueue {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    [queue addOperation:op];
}

- (void)run {
    for (int i = 0; i < 100; ++i) {
        NSLog(@"Invocation %i----%@", i, [NSThread currentThread]);
    }
}

/**
 疯狂iOS讲义（下）
 */
- (void)addCustomOperationToQueue {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    YHOperation *operation = [[YHOperation alloc] init];
    
    [queue addOperation:operation];
}

///-----------------------------------------------------------------------------
/// http://www.jianshu.com/p/4b1d77054b35
///-----------------------------------------------------------------------------
#pragma mark - 《iOS多线程——彻底学会多线程之『NSOperation』》 -

/**
 在没有使用NSOperationQueue、单独使用NSInvocationOperation的情况下，NSInvocationOperation
 在主线程执行操作，并没有开启新线程。
 http://www.jianshu.com/p/4b1d77054b35
 */
- (void)startInvocationOperation {
    // 创建NSInvocationOperation对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    // 调用start方法开始执行操作
    [op start];
}

/**
 在没有使用NSOperationQueue、单独使用NSBlockOperation的情况下，NSBlockOperation也是在主
 线程执行操作，并没有开启新线程。
 http://www.jianshu.com/p/4b1d77054b35
 */
- (void)startBlockOperation {
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"%i----%@", i, [NSThread currentThread]);
        }
    }];
    
    [op start];
}

/**
 通过addExecutionBlock:就可以为NSBlockOperation添加额外的操作，这些额外的操作就会在其他线程
 并发执行。
 http://www.jianshu.com/p/4b1d77054b35
 */
- (void)addExecutionBlock {
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        // 在主线程执行
        NSLog(@"代码块1----%@", [NSThread currentThread]);
    }];
    
    // 添加额外的任务（在子线程执行）
    [op addExecutionBlock:^{
        NSLog(@"代码块2----%@", [NSThread currentThread]);
    }];
    
    [op addExecutionBlock:^{
        NSLog(@"代码块3----%@", [NSThread currentThread]);
    }];
    
    [op addExecutionBlock:^{
        NSLog(@"代码块4----%@", [NSThread currentThread]);
    }];
    
    [op start];
}

/**
 在没有使用NSOperationQueue、单独使用自定义子类的情况下，是在主线程执行操作，并没有开启新线程。
 http://www.jianshu.com/p/4b1d77054b35
 */
- (void)startCustomOperation {
    YHOperation *op = [[YHOperation alloc] init];
    [op start];
}

/**
 NSInvocationOperation和NSOperationQueue结合后能够开启新线程，进行并发执行，
 NSBlockOperation和NSOperationQueue也能够开启新线程，进行并发执行。
 http://www.jianshu.com/p/4b1d77054b35
 */
- (void)addOperationsToQueue {
    
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 创建NSInvocationOperation
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    // 创建NSBlockOperation
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"Block %i++++%@", i, [NSThread currentThread]);
        }
    }];
    
    // 添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}

/**
 无需先创建任务，直接将任务block加入到队列中。
 可以看出addOperationWithBlock:和NSOperationQueue结合能够开启新线程，进行并发执行。
 http://www.jianshu.com/p/4b1d77054b35
 */
- (void)addBlockToQueue {
    
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 添加操作到队列中
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"Block %i++++%@", i, [NSThread currentThread]);
        }
    }];
}

/**
 之前我们说过，NSOperationQueue创建的其他队列同时具有串行、并发功能，上边我们演示了并发功能，那
 么他的串行功能是如何实现的？
 
 这里有个关键参数maxConcurrentOperationCount，叫做最大并发数。
 
 最大并发数：maxConcurrentOperationCount
 - maxConcurrentOperationCount默认情况下为-1，表示不进行限制，默认为并发执行。
 - 当maxConcurrentOperationCount为1时，进行串行执行。
 - 当maxConcurrentOperationCount大于1时，进行并发执行，当然这个值不应超过系统限制，即使自己设
 置一个很大的值，系统也会自动调整。
 
 可以看出：当最大并发数为1时，任务是按顺序串行执行的。当最大并发数为2时，任务是并发执行的。而且开启
 线程数量是由系统决定的，不需要我们来管理。
 
 http://www.jianshu.com/p/4b1d77054b35
 */
- (void)concurrentOperation {
    
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 设置最大并发操作数
    queue.maxConcurrentOperationCount = 1;
    
    // 添加操作
    [queue addOperationWithBlock:^{
        NSLog(@"1----%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"2----%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"3----%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"4----%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"5----%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"6----%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.01];
    }];
}

/**
 NSOperation和NSOperationQueue最吸引人的地方是它能添加操作之间的依赖关系。比如说有A、B两个操
 作，其中A执行完操作，B才能执行操作，那么就需要让B依赖于A。
 http://www.jianshu.com/p/4b1d77054b35
 */
- (void)addDependency {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"代码块1 %i----%@", i, [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"代码块2 %i++++%@", i, [NSThread currentThread]);
        }
    }];
    
    [op2 addDependency:op1]; // 让op2依赖于op1，则先执行完成op1，再执行op2
    
    [queue addOperation:op1];
    [queue addOperation:op2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addDependency];
}

@end
