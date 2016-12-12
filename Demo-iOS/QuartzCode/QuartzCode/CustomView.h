//
//  CustomView.h
//
//  Code generated using QuartzCode 1.50.0 on 10/2/16.
//  www.quartzcodeapp.com
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CustomView : UIView

@property (nonatomic, strong) UIColor * grayColor;
@property (nonatomic, strong) UIColor * progressColor;
@property (nonatomic, strong) UIColor * finishColor;
@property (nonatomic, assign) CGFloat  oldAnimProgress;

- (void)addOldAnimation;
- (void)addOldAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock;
- (void)addOldAnimationReverse:(BOOL)reverseAnimation totalDuration:(CFTimeInterval)totalDuration endTime:(CFTimeInterval)endTime completionBlock:(void (^)(BOOL finished))completionBlock;
- (void)removeAnimationsForAnimationId:(NSString *)identifier;
- (void)removeAllAnimations;

@end
