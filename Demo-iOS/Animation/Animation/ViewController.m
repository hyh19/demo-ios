//
//  ViewController.m
//  Animation
//
//  Created by Yuhui Huang on 12/5/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)onDisplayLink:(CADisplayLink *)link {
    NSLog(@"%@", [NSDate date]);
}

@end
