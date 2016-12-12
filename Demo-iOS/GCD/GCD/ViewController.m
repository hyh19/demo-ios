//
//  ViewController.m
//  GCD
//
//  Created by Yuhui Huang on 12/12/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 并发队列+同步执行：不会开启新线程，执行完一个任务，再执行下一个任务。
- (void)syncConcurrent {
    
    NSLog(@"---- begin ---- ");
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"并发队列+同步执行：第1个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"并发队列+同步执行：第2个代码块 %@++++%d", [NSThread currentThread], i);
        };
    });
    
    NSLog(@"---- end ---- ");
}

// 并发队列+异步执行：可同时开启多线程，任务交替执行。
- (void)asyncConcurrent {
    
    NSLog(@"---- begin ---- ");
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"并发队列+异步执行：第1个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"并发队列+异步执行：第2个代码块 %@++++%d", [NSThread currentThread], i);
        };
    });
    
    NSLog(@"---- end ---- ");
}

// 串行队列+同步执行：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
- (void)syncSerial {
    
    NSLog(@"---- begin ---- ");
    
    dispatch_queue_t queue = dispatch_queue_create("serial.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"串行队列+同步执行：第1个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"串行队列+同步执行：第2个代码块 %@++++%d", [NSThread currentThread], i);
        };
    });
    
    NSLog(@"---- end ---- ");
}

// 串行队列+异步执行：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
- (void)asyncSerial {
    
    NSLog(@"---- begin ---- ");
    
    dispatch_queue_t queue = dispatch_queue_create("serial.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"串行队列+异步执行：第1个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"串行队列+异步执行：第2个代码块 %@++++%d", [NSThread currentThread], i);
        };
    });
    
    NSLog(@"---- end ---- ");
}

// 主队列+同步执行：互等卡住
- (void)syncMain {
    
    NSLog(@"---- begin ---- ");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"主队列+同步执行：第1个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"主队列+同步执行：第2个代码块 %@++++%d", [NSThread currentThread], i);
        };
    });
    
    NSLog(@"---- end ---- ");
}

// 主队列+异步执行：只在主线程中执行任务，执行完一个任务，再执行下一个任务。
- (void)asyncMain {
    
    NSLog(@"---- begin ---- ");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"主队列+异步执行：第1个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"主队列+异步执行：第2个代码块 %@++++%d", [NSThread currentThread], i);
        };
    });
    
    NSLog(@"---- end ---- ");
}

// 线程通讯
- (void)back {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i < 100; ++i) {
            NSLog(@"第1个代码块 %@----%d", [NSThread currentThread], i);
        };
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程----%@",[NSThread currentThread]);
        });
    });
}

// 栅栏方法
- (void)barrier {
    
    NSLog(@"---- begin ---- %@", [NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"第1个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"第2个代码块 %@++++%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"---- barrier ----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"第3个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"第4个代码块 %@++++%d", [NSThread currentThread], i);
        };
    });
    
    NSLog(@"---- end ---- %@", [NSThread currentThread]);
}

// 延时执行
- (void)after {
    NSLog(@"---- now %@ ---- %@", [NSDate date], [NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"---- after %@ ---- %@", [NSDate date], [NSThread currentThread]);
    });
}

// 一次性代码
- (void)once {
    
    static dispatch_once_t onceToken;
    
    // 不需要传入任何队列，只在主线程内执行一次
    dispatch_once(&onceToken, ^{
        NSLog(@"只执行一次 %@", [NSThread currentThread]);
    });
}

// 迭代方法
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(10, queue, ^(size_t t) {
        // 注意：由于队列是并发队列，所以执行任务使用多个线程，任务未必按顺序执行
        NSLog(@"执行第%zu次 %@", t, [NSThread currentThread]);
    });
    
    //    dispatch_queue_t queue = dispatch_queue_create("serial.queue", DISPATCH_QUEUE_SERIAL);
    //    dispatch_apply(10, queue, ^(size_t t) {
    //        // 注意：由于队列是串行队列，所以执行任务使用一个线程，任务按顺序执行
    //        NSLog(@"执行第%zu次 %@", t, [NSThread currentThread]);
    //    });
}

// 队列组
- (void)group {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"第1个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"第2个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"---- notify ---- %@", [NSThread currentThread]);
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self back];
}

@end
