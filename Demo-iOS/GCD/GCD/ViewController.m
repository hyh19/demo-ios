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

///-----------------------------------------------------------------------------
/// http://www.jianshu.com/p/2d57c72016c6
///-----------------------------------------------------------------------------
#pragma mark - http://www.jianshu.com/p/2d57c72016c6 -

/**
 并发队列+同步执行：不会开启新线程，执行完一个任务，再执行下一个任务。
 
 - 从执行结果中可以看到，所有任务都是在主线程中执行的。由于只有一个线程，所以任务只能一个一个执行。
 - 同时我们还可以看到，所有任务都在打印的begin和end之间，这说明任务是添加到队列中马上执行的。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
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

/**
 并发队列+异步执行：可同时开启多线程，任务交替执行。
 
 - 从执行结果中可以看出，除了主线程，又开启了其他线程，并且任务是交替着同时执行的。
 - 另一方面可以看出，所有任务是在打印的begin和end之后才开始执行的。说明任务不是马上执行，而是将所有
 任务添加到队列之后才开始同步执行。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
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

/**
 串行队列+同步执行：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 
 - 从执行结果中可以看到，所有任务都是在主线程中执行的，并没有开启新的线程。而且由于是串行队列，所以
 按顺序一个一个执行。
 - 同时我们还可以看到，所有任务都在打印的begin和end之间，这说明任务是添加到队列中马上执行的。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
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

/**
 串行队列+异步执行：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 
 - 从执行结果中可以看出，开启了一条新线程，但是任务还是串行，所以任务是一个一个执行。
 - 另一方面可以看出，所有任务是在打印的begin和end之后才开始执行的。说明任务不是马上执行，而是将所
 有任务添加到队列之后才开始同步执行。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
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

/**
 主队列+同步执行：互等卡住（在主线程中调用）
 
 这时候，我们惊奇地发现，在主线程中使用主队列+同步执行，任务不再执行了，而且end也没有打印。这是为什么呢？
 这是因为我们在主线程中执行这段代码。我们把任务放到了主队列中，也就是放到了主线程的队列中。而同步执
 行有个特点，就是对于任务是立马执行的。那么当我们把第一个任务放进主队列中，它就会立马执行。但是主线
 程现在正在处理syncMain方法，所以任务需要等syncMain执行完才能执行。而syncMain执行到第一个任务
 的时候，又要等第一个任务执行完才能往下执行第二个和第三个任务。
 那么，现在的情况就是syncMain方法和第一个任务都在等对方执行完毕。这样大家互相等待，所以就卡住了，
 所以我们的任务执行不了，而且end也没有打印。
 
 如果不在主线程中调用，而在其他线程中调用会如何呢？
 
 dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
 
 dispatch_async(queue, ^{
     [self syncMain];
 });
 
 - 在其他线程中使用主队列+同步执行可看到：所有任务都是在主线程中执行的，并没有开启新的线程。而且由
 于主队列是串行队列，所以按顺序一个一个执行。
 - 同时我们还可以看到，所有任务都在打印的begin和end之间，这说明任务是添加到队列中马上执行的。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
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

/**
 主队列+异步执行：只在主线程中执行任务，执行完一个任务，再执行下一个任务。
 
 - 我们发现所有任务都在主线程中，虽然是异步执行，具备开启线程的能力，但因为是主队列，所以所有任务都
 在主线程中，并且一个接一个执行。
 - 另一方面可以看出，所有任务是在打印的begin和end之后才开始执行的。说明任务不是马上执行，而是将所有
 任务添加到队列之后才开始同步执行（因为主队列是串行队列）。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
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

/**
 在iOS开发过程中，我们一般在主线程里边进行UI刷新，例如：点击、滚动、拖拽等事件。我们通常把一些耗时
 的操作放在其他线程，比如说图片下载、文件上传等耗时操作。而当我们有时候在其他线程完成了耗时操作时，
 需要回到主线程，那么就用到了线程之间的通讯。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
- (void)backMain {
    
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

/**
 我们有时需要异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。这样我们就需要一个
 相当于栅栏一样的一个方法将两组异步执行的操作组给分割起来，当然这里的操作组里可以包含一个或多个任务。
 这就需要用到dispatch_barrier_async方法在两个操作组间形成栅栏。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
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

/**
 当我们需要延迟执行一段代码时，就需要用到GCD的dispatch_after方法。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
- (void)after {
    NSLog(@"---- now %@ ---- %@", [NSDate date], [NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"---- after %@ ---- %@", [NSDate date], [NSThread currentThread]);
    });
}

/**
 我们在创建单例、或者有整个程序运行过程中只执行一次的代码时，我们就用到了GCD的dispatch_once方法。
 使用dispatch_once函数能保证某段代码在程序运行过程中只被执行一次。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
- (void)once {
    
    static dispatch_once_t onceToken;
    
    // 不需要传入任何队列，只在主线程内执行一次
    dispatch_once(&onceToken, ^{
        NSLog(@"只执行一次 %@", [NSThread currentThread]);
    });
}

/**
 通常我们会用for循环遍历，但是GCD给我们提供了快速迭代的方法dispatch_apply，使我们可以同时遍历。
 比如说遍历0~5这6个数字，for循环的做法是每次取出一个元素，逐个遍历。dispatch_apply可以同时遍历
 多个数字。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
- (void)apply1 {
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

/**
 有时候我们会有这样的需求：分别异步执行2个耗时操作，然后当2个耗时操作都执行完毕后再回到主线程执行
 操作。这时候我们可以用到GCD的队列组。
 
 - 我们可以先把任务放到队列中，然后将队列放入队列组中。
 - 调用队列组的dispatch_group_notify回到主线程执行操作。
 
 http://www.jianshu.com/p/2d57c72016c6
 */
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

///-----------------------------------------------------------------------------
/// http://blog.csdn.net/growinggiant/article/details/41077221
///-----------------------------------------------------------------------------
#pragma mark - http://blog.csdn.net/growinggiant/article/details/41077221 -

/**
 一般都是把一个任务放到一个串行的queue中，如果这个任务被拆分了，被放置到多个串行的queue中，但实际还是需要这个任务同步执行，那么就会有问题，因为多个串行queue之间是并行的。
 那该如何是好呢？
 这时候就可以使用dispatch_set_target_queue了。
 如果将多个串行的queue使用dispatch_set_target_queue指定到了同一目标（该目标是串行队列），那么多个串行queue在目标queue上就是同步执行的，不再是并行执行。
 
 http://blog.csdn.net/growinggiant/article/details/41077221
 */
- (void)target1 {
    
    dispatch_queue_t targetQueue = dispatch_queue_create("target.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue1 = dispatch_queue_create("queue.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue.2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("queue.3", DISPATCH_QUEUE_SERIAL);
    
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    
    dispatch_async(queue1, ^{
        NSLog(@"1 in");
        [NSThread sleepForTimeInterval:3.f];
        NSLog(@"1 out");
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"2 in");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"2 out");
    });
    
    dispatch_async(queue3, ^{
        NSLog(@"3 in");
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"3 out");
    });
}

///-----------------------------------------------------------------------------
/// http://www.jianshu.com/p/a28c5bbd5b4a
///-----------------------------------------------------------------------------
#pragma mark - http://www.jianshu.com/p/a28c5bbd5b4a -

/**
 刚刚我们说了系统的Global Queue是可以指定优先级的，那我们如何给自己创建的队列执行优先级呢？
 这里我们就可以用到dispatch_set_target_queue这个方法。
 我把自己创建的队列塞到了系统提供的global_queue队列中，我们可以理解为：我们自己创建的queue其实
 是位于global_queue中执行，所以改变global_queue的优先级，也就改变了我们自己所创建的queue的优
 先级。所以我们常用这种方式来管理子队列。
 
 http://www.jianshu.com/p/a28c5bbd5b4a
 */
- (void)target2 {
    
    dispatch_queue_t serialQueue = dispatch_queue_create("serial.queue", NULL);
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    // 相当于把前者变为后者的子队列，而子队列的优先级与其父队列的优先级一致，所以就达到了改变优先级的目的
    dispatch_set_target_queue(serialQueue, globalQueue);
    
    dispatch_async(serialQueue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"第1个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"第2个代码块 %@----%d", [NSThread currentThread], i);
        };
    });
}

/**
 这个方法虽然会开启多个线程来遍历这个数组，但是在遍历完成之前会阻塞主线程。
 http://www.jianshu.com/p/a28c5bbd5b4a
 */
- (void)apply2 {
    
    NSLog(@"---- begin ---- %@", [NSThread currentThread]);
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 迭代完成后，才会回到主线程
    dispatch_apply([array count], queue, ^(size_t index) {
        NSLog(@"执行第%zu次 ---- %@", index, [NSThread currentThread]);
    });
    
    NSLog(@"---- end ---- %@", [NSThread currentThread]);
}

/**
 队列的挂起和恢复
 http://www.jianshu.com/p/a28c5bbd5b4a
 */
- (void)suspend {
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; ++i) {
            NSLog(@"%i ---- %@", i, [NSThread currentThread]);
            if (50 == i) {
                NSLog(@"-------------------- suspend --------------------");
                dispatch_suspend(queue);
                sleep(3);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 我们甚至可以在不同的线程对这个队列进行挂起和恢复，因为GCD是对队列的管理。
                    dispatch_resume(queue);
                });
            }
        }
    });
}

///-----------------------------------------------------------------------------
/// http://www.tanhao.me/pieces/392.html
///-----------------------------------------------------------------------------
#pragma mark - http://www.tanhao.me/pieces/392.html -
/**
 dispatch_semaphore_create 创建一个semaphore
 dispatch_semaphore_signal 发送一个信号
 dispatch_semaphore_wait 等待信号
 
 简单介绍一下这三个函数：
 第一个函数有一个整形的参数，我们可以理解为信号的总量，
 dispatch_semaphore_signal是发送一个信号，自然会让信号总量加1，
 dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，
 并让信号总量-1，根据这样的原理，我们便可以快速创建一个并发控制。
 
 简单介绍一下这一段代码：
 创建了一个初始值为10的semaphore，每一次for循环都会创建一个新的线程，线程结束的时候会发送一个信
 号，线程创建之前会信号等待，所以当同时创建了10个线程之后，for循环就会阻塞，等待有线程结束之后会
 增加一个信号才继续执行，如此就形成了对并发的控制，如上就是一个并发数为10的一个线程队列。
 
 http://www.tanhao.me/pieces/392.html
 */
- (void)semaphore {
    
    dispatch_group_t group = dispatch_group_create();
    
    // 信号总量（或者叫可用信号总量）相当于最大线程并发数是10
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (int i = 0; i < 100; ++i) {
        // 当信号总量（或者叫可用信号总量）少于0的时候就会一直等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i ---- %@", i, [NSThread currentThread]);
            sleep(2);
            // 发送一个信号，信号总量加1，可以理解为“我占用的可用线程数用完了，其他人可以用来”
            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

///-----------------------------------------------------------------------------
/// http://www.jianshu.com/p/ae786a4cf3b1
///-----------------------------------------------------------------------------
#pragma mark - http://www.jianshu.com/p/ae786a4cf3b1 -

/**
 注意不要嵌套使用同步执行的串行队列任务
 http://www.jianshu.com/p/ae786a4cf3b1
 */
- (void)nestSyncSerial {
//    // 自定义串行队列嵌套执行同步任务，产生死锁。
//    dispatch_queue_t queue = dispatch_queue_create("serial.queue", DISPATCH_QUEUE_SERIAL);
//        dispatch_sync(queue, ^{
//        NSLog(@"会执行的代码");
//        dispatch_sync(queue, ^{
//            NSLog(@"代码不执行");
//        });
//    });
    
    // 异步执行串行队列，嵌套同步执行串行队列，同步执行的串行队列中的任务将不会被执行，其他程序正常执行。
    dispatch_queue_t queue = dispatch_queue_create("serial.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"会执行的代码");
        dispatch_sync(queue, ^{
            NSLog(@"代码不执行");
        });
    });
}

/**
 自定义并发队列嵌套执行同步任务（不会产生死锁，程序正常运行）
 http://www.jianshu.com/p/ae786a4cf3b1
 */
- (void)nestSyncConcurrent {
    
    NSLog(@"---- begin ---- %@", [NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        NSLog(@"先加入队列 ---- %@", [NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"次加入队列 ---- %@", [NSThread currentThread]);
        });
    });
    
    NSLog(@"---- end ---- %@", [NSThread currentThread]);
}

/**
 这个不是很懂，要继续详细了解
 http://www.jianshu.com/p/ae786a4cf3b1
 */
- (void)groupWait {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"---- begin ---- %@", [NSThread currentThread]);
    
    dispatch_group_async(group, queue, ^{
        
        long isExecuteOver = dispatch_group_wait(group, delay);
        
        if (isExecuteOver) {
            NSLog(@"wait over");
        } else {
            NSLog(@"not over");
        }
        
        NSLog(@"任务1 ---- %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务2 ---- %@", [NSThread currentThread]);
    });
    
    NSLog(@"---- end ---- %@", [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self groupWait];
}

@end
