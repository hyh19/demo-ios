//
//  CustomView.m
//
//  Code generated using QuartzCode 1.50.0 on 10/2/16.
//  www.quartzcodeapp.com
//

#import "CustomView.h"
#import "QCMethod.h"

@interface CustomView ()

@property (nonatomic, assign) BOOL  updateLayerValueForCompletedAnimation;
@property (nonatomic, assign) BOOL  animationAdded;
@property (nonatomic, strong) NSMapTable * completionBlocks;
@property (nonatomic, strong) NSMutableDictionary * layers;


@end

@implementation CustomView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupProperties];
		[self setupLayers];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setupProperties];
		[self setupLayers];
	}
	return self;
}

- (void)setOldAnimProgress:(CGFloat)oldAnimProgress{
	if(!self.animationAdded){
		[self removeAllAnimations];
		[self addOldAnimation];
		self.animationAdded = YES;
		self.layer.speed = 0;
		self.layer.timeOffset = 0;
	}
	else{
		CGFloat totalDuration = 1.86;
		CGFloat offset = oldAnimProgress * totalDuration;
		self.layer.timeOffset = offset;
	}
}

- (void)setupProperties{
	self.completionBlocks = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory valueOptions:NSPointerFunctionsStrongMemory];;
	self.layers = [NSMutableDictionary dictionary];
	self.grayColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1];
	self.progressColor = [UIColor colorWithRed:0.176 green: 0.408 blue:0.996 alpha:1];
	self.finishColor = [UIColor colorWithRed:0.298 green: 0.843 blue:0.267 alpha:1];
}

- (void)setupLayers{
	CAShapeLayer * path = [CAShapeLayer layer];
	path.frame = CGRectMake(140.25, 214.21, 74.86, 52.66);
	path.path = [self pathPath].CGPath;
	[self.layer addSublayer:path];
	self.layers[@"path"] = path;
	
	CAShapeLayer * oval = [CAShapeLayer layer];
	oval.frame = CGRectMake(45.18, 19.97, 209.64, 209.64);
	oval.path = [self ovalPath].CGPath;
	[self.layer addSublayer:oval];
	self.layers[@"oval"] = oval;
	
	CAShapeLayer * oval2 = [CAShapeLayer layer];
	oval2.frame = CGRectMake(45.18, 19.97, 209.64, 209.64);
	oval2.path = [self oval2Path].CGPath;
	[self.layer addSublayer:oval2];
	self.layers[@"oval2"] = oval2;
	
	CAShapeLayer * path2 = [CAShapeLayer layer];
	path2.frame = CGRectMake(113.45, 106.92, 73.11, 35.75);
	path2.path = [self path2Path].CGPath;
	[self.layer addSublayer:path2];
	self.layers[@"path2"] = path2;
	
	CAShapeLayer * path3 = [CAShapeLayer layer];
	path3.frame = CGRectMake(113.45, 107.52, 73.11, 35.15);
	path3.path = [self path3Path].CGPath;
	[self.layer addSublayer:path3];
	self.layers[@"path3"] = path3;
	
	CATextLayer * text = [CATextLayer layer];
	text.frame = CGRectMake(35.75, 241.42, 228.5, 65.75);
	[self.layer addSublayer:text];
	self.layers[@"text"] = text;
	
	[self resetLayerPropertiesForLayerIdentifiers:nil];
}

- (void)resetLayerPropertiesForLayerIdentifiers:(NSArray *)layerIds{
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	if(!layerIds || [layerIds containsObject:@"path"]){
		CAShapeLayer * path = self.layers[@"path"];
		path.hidden      = YES;
		path.fillColor   = nil;
		path.strokeColor = [UIColor colorWithRed:0.831 green: 0.831 blue:0.831 alpha:1].CGColor;
		path.lineWidth   = 15;
	}
	if(!layerIds || [layerIds containsObject:@"oval"]){
		CAShapeLayer * oval = self.layers[@"oval"];
		oval.fillColor   = nil;
		oval.strokeColor = self.grayColor.CGColor;
		oval.lineWidth   = 24;
	}
	if(!layerIds || [layerIds containsObject:@"oval2"]){
		CAShapeLayer * oval2 = self.layers[@"oval2"];
		oval2.lineCap     = kCALineCapRound;
		oval2.lineJoin    = kCALineJoinRound;
		oval2.fillColor   = nil;
		oval2.strokeColor = self.progressColor.CGColor;
		oval2.lineWidth   = 24;
		oval2.strokeStart = 1;
		oval2.strokeEnd   = 0.99;
	}
	if(!layerIds || [layerIds containsObject:@"path2"]){
		CAShapeLayer * path2 = self.layers[@"path2"];
		path2.lineCap     = kCALineCapRound;
		path2.lineJoin    = kCALineJoinRound;
		path2.fillColor   = nil;
		path2.strokeColor = self.grayColor.CGColor;
		path2.lineWidth   = 15;
	}
	if(!layerIds || [layerIds containsObject:@"path3"]){
		CAShapeLayer * path3 = self.layers[@"path3"];
		path3.hidden      = YES;
		[path3 setValue:@(-180 * M_PI/180) forKeyPath:@"transform.rotation"];
		path3.lineCap     = kCALineCapRound;
		path3.lineJoin    = kCALineJoinRound;
		path3.fillColor   = nil;
		path3.strokeColor = self.progressColor.CGColor;
		path3.lineWidth   = 15;
	}
	if(!layerIds || [layerIds containsObject:@"text"]){
		CATextLayer * text = self.layers[@"text"];
		text.hidden          = YES;
		text.contentsScale   = [[UIScreen mainScreen] scale];
		text.string          = @"Completed\n";
		text.font            = (__bridge CFTypeRef)@"HelveticaNeue-Medium";
		text.fontSize        = 39;
		text.alignmentMode   = kCAAlignmentCenter;
		text.foregroundColor = self.finishColor.CGColor;
	}
	
	[CATransaction commit];
}

#pragma mark - Animation Setup

- (void)addOldAnimation{
	[self addOldAnimationCompletionBlock:nil];
}

- (void)addOldAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock{
	[self addOldAnimationReverse:NO totalDuration:1.858 endTime:1 completionBlock:completionBlock];
}

- (void)addOldAnimationReverse:(BOOL)reverseAnimation totalDuration:(CFTimeInterval)totalDuration endTime:(CFTimeInterval)endTime completionBlock:(void (^)(BOOL finished))completionBlock{
	endTime = endTime * totalDuration;
	
	if (completionBlock){
		CABasicAnimation * completionAnim = [CABasicAnimation animationWithKeyPath:@"completionAnim"];;
		completionAnim.duration = endTime;
		completionAnim.delegate = self;
		[completionAnim setValue:@"old" forKey:@"animId"];
		[completionAnim setValue:@(YES) forKey:@"needEndAnim"];
		[self.layer addAnimation:completionAnim forKey:@"old"];
		[self.completionBlocks setObject:completionBlock forKey:[self.layer animationForKey:@"old"]];
	}
	
	if (!reverseAnimation) [self resetLayerPropertiesForLayerIdentifiers:@[@"path", @"oval2", @"path2", @"path3", @"text"]];
	
	self.layer.speed = 1;
	self.animationAdded = NO;
	
	NSString * fillMode = reverseAnimation ? kCAFillModeBoth : kCAFillModeForwards;
	
	////Path animation
	CABasicAnimation * pathTransformAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	pathTransformAnim.fromValue          = @(0);
	pathTransformAnim.toValue            = @(360 * M_PI/180);
	pathTransformAnim.duration           = 0.788 * totalDuration;
	
	CAKeyframeAnimation * pathStrokeColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
	pathStrokeColorAnim.values   = @[(id)self.grayColor.CGColor, 
		 (id)self.progressColor.CGColor, 
		 (id)self.progressColor.CGColor];
	pathStrokeColorAnim.keyTimes = @[@0, @0.0699, @1];
	pathStrokeColorAnim.duration = 0.788 * totalDuration;
	
	CAAnimationGroup * pathOldAnim = [QCMethod groupAnimations:@[pathTransformAnim, pathStrokeColorAnim] fillMode:fillMode];
	if (reverseAnimation) pathOldAnim = (CAAnimationGroup *)[QCMethod reverseAnimation:pathOldAnim totalDuration:totalDuration];
	[self.layers[@"path"] addAnimation:pathOldAnim forKey:@"pathOldAnim"];
	
	////Oval2 animation
	CABasicAnimation * oval2StrokeStartAnim = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
	oval2StrokeStartAnim.fromValue = @1;
	oval2StrokeStartAnim.toValue   = @0;
	oval2StrokeStartAnim.duration  = 0.788 * totalDuration;
	
	CABasicAnimation * oval2StrokeColorAnim = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
	oval2StrokeColorAnim.fromValue = (id)[UIColor colorWithRed:0.176 green: 0.408 blue:0.996 alpha:1].CGColor;
	oval2StrokeColorAnim.toValue   = (id)self.finishColor.CGColor;
	oval2StrokeColorAnim.duration  = 0.041 * totalDuration;
	oval2StrokeColorAnim.beginTime = 0.903 * totalDuration;
	
	CAAnimationGroup * oval2OldAnim = [QCMethod groupAnimations:@[oval2StrokeStartAnim, oval2StrokeColorAnim] fillMode:fillMode];
	if (reverseAnimation) oval2OldAnim = (CAAnimationGroup *)[QCMethod reverseAnimation:oval2OldAnim totalDuration:totalDuration];
	[self.layers[@"oval2"] addAnimation:oval2OldAnim forKey:@"oval2OldAnim"];
	
	////Path2 animation
	CAKeyframeAnimation * path2TransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
	path2TransformAnim.values   = @[@(0), 
		 @(360 * M_PI/180)];
	path2TransformAnim.keyTimes = @[@0, @1];
	path2TransformAnim.duration = 0.788 * totalDuration;
	
	CAKeyframeAnimation * path2StrokeColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
	path2StrokeColorAnim.values   = @[(id)self.grayColor.CGColor, 
		 (id)self.progressColor.CGColor, 
		 (id)self.progressColor.CGColor];
	path2StrokeColorAnim.keyTimes = @[@0, @0.0699, @1];
	path2StrokeColorAnim.duration = 0.788 * totalDuration;
	
	CABasicAnimation * path2HiddenAnim = [CABasicAnimation animationWithKeyPath:@"hidden"];
	path2HiddenAnim.fromValue          = @YES;
	path2HiddenAnim.toValue            = @YES;
	path2HiddenAnim.duration           = 0.058 * totalDuration;
	path2HiddenAnim.beginTime          = 0.788 * totalDuration;
	
	CAAnimationGroup * path2OldAnim = [QCMethod groupAnimations:@[path2TransformAnim, path2StrokeColorAnim, path2HiddenAnim] fillMode:fillMode];
	if (reverseAnimation) path2OldAnim = (CAAnimationGroup *)[QCMethod reverseAnimation:path2OldAnim totalDuration:totalDuration];
	[self.layers[@"path2"] addAnimation:path2OldAnim forKey:@"path2OldAnim"];
	
	////Path3 animation
	CAKeyframeAnimation * path3TransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	path3TransformAnim.values         = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, -1)], 
		 [NSValue valueWithCATransform3D:CATransform3DMakeRotation(1 * M_PI/180, 0, 0, -1)], 
		 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)], 
		 [NSValue valueWithCATransform3D:CATransform3DIdentity]];
	path3TransformAnim.keyTimes       = @[@0, @0.461, @0.814, @1];
	path3TransformAnim.duration       = 0.222 * totalDuration;
	path3TransformAnim.beginTime      = 0.778 * totalDuration;
	path3TransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	CABasicAnimation * path3HiddenAnim = [CABasicAnimation animationWithKeyPath:@"hidden"];
	path3HiddenAnim.fromValue          = @NO;
	path3HiddenAnim.toValue            = @NO;
	path3HiddenAnim.duration           = 0.203 * totalDuration;
	path3HiddenAnim.beginTime          = 0.778 * totalDuration;
	
	CABasicAnimation * path3PathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
	path3PathAnim.fromValue          = (id)[QCMethod alignToBottomPath:[self path3Path] layer:self.layers[@"path3"]].CGPath;
	path3PathAnim.toValue            = (id)[QCMethod alignToBottomPath:[self pathPath] layer:self.layers[@"path3"]].CGPath;
	path3PathAnim.duration           = 0.041 * totalDuration;
	path3PathAnim.beginTime          = 0.903 * totalDuration;
	path3PathAnim.timingFunction     = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	CABasicAnimation * path3PositionAnim = [CABasicAnimation animationWithKeyPath:@"position"];
	path3PositionAnim.fromValue          = [NSValue valueWithCGPoint:CGPointMake(150, 125.094)];
	path3PositionAnim.toValue            = [NSValue valueWithCGPoint:CGPointMake(149, 138)];
	path3PositionAnim.duration           = 0.031 * totalDuration;
	path3PositionAnim.beginTime          = 0.903 * totalDuration;
	path3PositionAnim.timingFunction     = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	CABasicAnimation * path3StrokeColorAnim = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
	path3StrokeColorAnim.fromValue = (id)[UIColor colorWithRed:0.176 green: 0.408 blue:0.996 alpha:1].CGColor;
	path3StrokeColorAnim.toValue   = (id)self.finishColor.CGColor;
	path3StrokeColorAnim.duration  = 0.041 * totalDuration;
	path3StrokeColorAnim.beginTime = 0.903 * totalDuration;
	
	CABasicAnimation * path3LineWidthAnim = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
	path3LineWidthAnim.fromValue          = @15;
	path3LineWidthAnim.toValue            = @20;
	path3LineWidthAnim.duration           = 0.041 * totalDuration;
	path3LineWidthAnim.beginTime          = 0.903 * totalDuration;
	
	CAAnimationGroup * path3OldAnim = [QCMethod groupAnimations:@[path3TransformAnim, path3HiddenAnim, path3PathAnim, path3PositionAnim, path3StrokeColorAnim, path3LineWidthAnim] fillMode:fillMode];
	if (reverseAnimation) path3OldAnim = (CAAnimationGroup *)[QCMethod reverseAnimation:path3OldAnim totalDuration:totalDuration];
	[self.layers[@"path3"] addAnimation:path3OldAnim forKey:@"path3OldAnim"];
	
	////Text animation
	CABasicAnimation * textTransformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
	textTransformAnim.fromValue          = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];;
	textTransformAnim.toValue            = [NSValue valueWithCATransform3D:CATransform3DIdentity];;
	textTransformAnim.duration           = 0.077 * totalDuration;
	textTransformAnim.beginTime          = 0.916 * totalDuration;
	textTransformAnim.timingFunction     = [CAMediaTimingFunction functionWithControlPoints:0.42 :0 :0.737 :1.52];
	
	CABasicAnimation * textHiddenAnim = [CABasicAnimation animationWithKeyPath:@"hidden"];
	textHiddenAnim.fromValue          = @NO;
	textHiddenAnim.toValue            = @NO;
	textHiddenAnim.duration           = 0.077 * totalDuration;
	textHiddenAnim.beginTime          = 0.916 * totalDuration;
	
	CAAnimationGroup * textOldAnim = [QCMethod groupAnimations:@[textTransformAnim, textHiddenAnim] fillMode:fillMode];
	if (reverseAnimation) textOldAnim = (CAAnimationGroup *)[QCMethod reverseAnimation:textOldAnim totalDuration:totalDuration];
	[self.layers[@"text"] addAnimation:textOldAnim forKey:@"textOldAnim"];
}

#pragma mark - Animation Cleanup

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	void (^completionBlock)(BOOL) = [self.completionBlocks objectForKey:anim];;
	if (completionBlock){
		[self.completionBlocks removeObjectForKey:anim];
		if ((flag && self.updateLayerValueForCompletedAnimation) || [[anim valueForKey:@"needEndAnim"] boolValue]){
			[self updateLayerValuesForAnimationId:[anim valueForKey:@"animId"]];
			[self removeAnimationsForAnimationId:[anim valueForKey:@"animId"]];
		}
		completionBlock(flag);
	}
}

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"old"]){
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"path"] animationForKey:@"pathOldAnim"] theLayer:self.layers[@"path"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"oval2"] animationForKey:@"oval2OldAnim"] theLayer:self.layers[@"oval2"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"path2"] animationForKey:@"path2OldAnim"] theLayer:self.layers[@"path2"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"path3"] animationForKey:@"path3OldAnim"] theLayer:self.layers[@"path3"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"text"] animationForKey:@"textOldAnim"] theLayer:self.layers[@"text"]];
	}
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"old"]){
		[self.layers[@"path"] removeAnimationForKey:@"pathOldAnim"];
		[self.layers[@"oval2"] removeAnimationForKey:@"oval2OldAnim"];
		[self.layers[@"path2"] removeAnimationForKey:@"path2OldAnim"];
		[self.layers[@"path3"] removeAnimationForKey:@"path3OldAnim"];
		[self.layers[@"text"] removeAnimationForKey:@"textOldAnim"];
	}
	self.layer.speed = 1;
}

- (void)removeAllAnimations{
	[self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
		[layer removeAllAnimations];
	}];
	self.layer.speed = 1;
}

#pragma mark - Bezier Path

- (UIBezierPath*)pathPath{
	UIBezierPath *pathPath = [UIBezierPath bezierPath];
	[pathPath moveToPoint:CGPointMake(0, 27.251)];
	[pathPath addLineToPoint:CGPointMake(27.803, 52.656)];
	[pathPath addLineToPoint:CGPointMake(74.858, 0)];
	
	return pathPath;
}

- (UIBezierPath*)ovalPath{
	UIBezierPath * ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 210, 210)];
	return ovalPath;
}

- (UIBezierPath*)oval2Path{
	UIBezierPath *oval2Path = [UIBezierPath bezierPath];
	[oval2Path moveToPoint:CGPointMake(104.82, 0)];
	[oval2Path addCurveToPoint:CGPointMake(0, 104.82) controlPoint1:CGPointMake(46.93, 0) controlPoint2:CGPointMake(0, 46.93)];
	[oval2Path addCurveToPoint:CGPointMake(104.82, 209.641) controlPoint1:CGPointMake(0, 162.711) controlPoint2:CGPointMake(46.93, 209.641)];
	[oval2Path addCurveToPoint:CGPointMake(209.641, 104.82) controlPoint1:CGPointMake(162.711, 209.641) controlPoint2:CGPointMake(209.641, 162.711)];
	[oval2Path addCurveToPoint:CGPointMake(104.82, 0) controlPoint1:CGPointMake(209.641, 46.93) controlPoint2:CGPointMake(162.711, 0)];
	
	return oval2Path;
}

- (UIBezierPath*)path2Path{
	UIBezierPath *path2Path = [UIBezierPath bezierPath];
	[path2Path moveToPoint:CGPointMake(0, 35.751)];
	[path2Path addLineToPoint:CGPointMake(35.751, 0)];
	[path2Path addLineToPoint:CGPointMake(73.109, 35.751)];
	
	return path2Path;
}

- (UIBezierPath*)path3Path{
	UIBezierPath *path3Path = [UIBezierPath bezierPath];
	[path3Path moveToPoint:CGPointMake(0, 0)];
	[path3Path addLineToPoint:CGPointMake(36.555, 35.154)];
	[path3Path addLineToPoint:CGPointMake(73.109, 0)];
	
	return path3Path;
}


@end
