//
//  AspectsDemo.m
//  Demo-iOS
//
//  Created by Yuhui Huang on 30/12/2016.
//  Copyright © 2016 Yuhui Huang. All rights reserved.
//

#import "AspectsDemo.h"

@interface AspectsDemo ()

@end

@implementation AspectsDemo

//+ (void)load {
//    
//    [AspectsDemo aspect_hookSelector:@selector(viewWillAppear:)
//                         withOptions:AspectPositionBefore
//                          usingBlock:^(id<AspectInfo> info, BOOL animated) {
//                              NSLog(@"%@----%@", [[info instance] class], NSStringFromSelector([[info originalInvocation] selector]));
//                          }
//                               error:NULL];
//    
//    [AspectsDemo aspect_hookSelector:@selector(viewDidLoad)
//                         withOptions:AspectPositionAfter
//                          usingBlock:^(id<AspectInfo> info) {
//                              NSLog(@"%@----%@", [[info instance] class], NSStringFromSelector([[info originalInvocation] selector]));
//                          }
//                               error:NULL];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [self aspect_hookSelector:@selector(helloAspects)
                  withOptions:AspectPositionAfter
                   usingBlock:^(id<AspectInfo> info) {
                       NSLog(@"after helloAspects");
                   }
                        error:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)helloAspects {
    NSLog(@"helloAspects");
}

@end
