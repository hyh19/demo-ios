//
//  ViewController.m
//  QuartzCode
//
//  Created by Yuhui Huang on 10/2/16.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
#import "JMWhenTapped.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomView *view = [[CustomView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(CGSizeMake(300, 300));
    }];
    
    __block CGFloat progress = 0;
    [self.view whenTapped:^{
        progress += 0.1;
        if (progress > 1) {
            progress = 0;
        }
        [view setOldAnimProgress:progress];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
