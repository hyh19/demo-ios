//
//  ViewController.m
//  Timer
//
//  Created by Yuhui Huang on 12/7/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)timer1 {
    
    __block int timeout = 30; // 倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        
        if (timeout<=0) {
            
            dispatch_source_cancel(timer);
            
        } else {
            
            NSString *time = [NSString stringWithFormat:@"%d", timeout];
            NSLog(@"%@", time);
            
            timeout--;
        }
    });
    
    dispatch_resume(timer);
}

- (void)timer2 {
    
    // 1. 创建GCD定时器
    /*
     DISPATCH_SOURCE_TYPE_TIMER 定时器
     uintptr_t handle  描述信息
     unsigned long mask  传入0
     dispatch_queue_t queue  定时器运行的队列，决定定时器在哪个线程中运行
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    // 2. 设置定时器
    /*
     dispatch_source_t source,  定时器的对象
     dispatch_time_t start,     定时器什么时候开始
     uint64_t interval,         定时器多长时间执行一次
     uint64_t leeway            精准度，0为绝对精准
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    // 3. 设置定时器的任务
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"---GCD---%@", [NSThread currentThread]);
    });
    
    // 4. 恢复定时器
    dispatch_resume(timer);
    
    // 5. 强引用定时器，否则创建出来就会被释放
    self.timer = timer;
}

@end
