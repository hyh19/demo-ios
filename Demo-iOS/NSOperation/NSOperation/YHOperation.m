//
//  YHOperation.m
//  NSOperation
//
//  Created by Yuhui Huang on 12/13/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "YHOperation.h"

@implementation YHOperation

- (void)main {
    for (int i = 0; i < 100; ++i) {
        NSLog(@"Custom %i====%@", i, [NSThread currentThread]);
    }
}

@end
