//
//  CircleRippleView.m
//  Qmsocks
//
//  Created by 杰刘 on 2017/7/17.
//  Copyright © 2017年 qm1024.com. All rights reserved.
//

#import "CircleRippleView.h"

@interface CircleRippleView ()

@property (nonatomic, strong) CAShapeLayer *circleShapeLayer;

@end

@implementation CircleRippleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpLayers];
    }
    return self;
}

- (void)setUpLayers
{
    CGFloat width = self.bounds.size.width;
    
    self.circleShapeLayer = [CAShapeLayer layer];
    _circleShapeLayer.bounds = CGRectMake(0, 0, width, 60);
    _circleShapeLayer.position = CGPointMake(width / 2.0, width / 2.0);
    _circleShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, 60) cornerRadius:20].CGPath;
    _circleShapeLayer.fillColor = [UIColor colorWithRed:255/255.0 green:36/255.0 blue:91/255.0 alpha:1].CGColor;
    _circleShapeLayer.opacity = 0.0;
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.bounds = CGRectMake(0, 0, width, width);
    replicator.position = CGPointMake(width / 2.0, width / 2.0);
    replicator.instanceDelay = 0.5;
    replicator.instanceCount = 8;
    
    [replicator addSublayer:_circleShapeLayer];
    [self.layer addSublayer:replicator];
}

- (void)startAnimation
{
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.fromValue = [NSNumber numberWithFloat:1];
    alphaAnim.toValue = [NSNumber numberWithFloat:0.0];
    
    CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DScale(t, 0.0, 0.0, 0.0);
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
    CATransform3D t3 = CATransform3DScale(t, 1.0, 1.0, 0.0);
    scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[alphaAnim, scaleAnim];
    groupAnimation.duration = 3.0;
    groupAnimation.autoreverses = NO;
    groupAnimation.repeatCount = HUGE;
    
    [_circleShapeLayer addAnimation:groupAnimation forKey:nil];
}

- (void)stopAnimation
{
    [_circleShapeLayer removeAllAnimations];
}


@end
