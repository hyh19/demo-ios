//
//  ViewController.m
//  NSThread
//
//  Created by Yuhui Huang on 12/14/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

///-----------------------------------------------------------------------------
/// http://www.jianshu.com/p/cbaeea5368b1
///-----------------------------------------------------------------------------
#pragma mark - iOS多线程：彻底学会多线程之『pthread、NSThread』 -

/**
 pthread_create(&thread, NULL, run, NULL); 中各项参数含义：
 第一个参数&thread是线程对象
 第二个和第四个是线程属性，可赋值NULL
 第三个run表示指向函数的指针（run对应函数里是需要在新线程中执行的任务）
 
 http://www.jianshu.com/p/cbaeea5368b1
 */
- (void)pthread {
    pthread_t thread;
    pthread_create(&thread, NULL, run, NULL);
}

// 新线程调用方法，里边为需要执行的任务
void* run(void *param) {
    NSLog(@"%@", [NSThread currentThread]);
    return NULL;
}

/**
 先创建线程，再启动线程
 http://www.jianshu.com/p/cbaeea5368b1
 */
- (void)createThread1 {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(task) object:nil];
    [thread start];
}

/**
 创建线程后自动启动线程
 http://www.jianshu.com/p/cbaeea5368b1
 */
- (void)createThread2 {
    [NSThread detachNewThreadSelector:@selector(task) toTarget:self withObject:nil];
}

/**
 隐式创建并启动线程
 http://www.jianshu.com/p/cbaeea5368b1
 */
- (void)createThread3 {
    [self performSelectorInBackground:@selector(task) withObject:nil];
}

- (void)task {
    for (int i = 0; i < 100; ++i){
        NSLog(@"%d----%@", i, [NSThread currentThread]);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self createThread3];
}

@end
