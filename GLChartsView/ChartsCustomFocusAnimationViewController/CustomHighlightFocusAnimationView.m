//
//  CustomHighlightFocusAnimationView.m
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/9.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "CustomHighlightFocusAnimationView.h"

#define AnimationDuration 3
#define AnimationLayerDelay 1

@interface CustomHighlightFocusAnimationView ()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *animationLayer;

@end

@implementation CustomHighlightFocusAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chartsViewFocusViewWillShow) name:GLChartsViewFocusViewWillShow object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chartsViewFocusViewDidHidden) name:GLChartsViewFocusViewDidHidden object:nil];
        
        CGFloat lineWidth = 1;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(lineWidth/2, lineWidth/2, self.bounds.size.width-lineWidth, self.bounds.size.height-lineWidth) cornerRadius:self.bounds.size.height/2];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.path = path.CGPath;
        layer.lineWidth = lineWidth;
        layer.opacity = 0;
        [self.layer addSublayer:layer];
        self.animationLayer = layer;
        
        CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
        [replicator addSublayer:layer];
        replicator.instanceDelay = AnimationLayerDelay;
        replicator.instanceCount = AnimationDuration/AnimationLayerDelay;

        [self.layer addSublayer:replicator];
    }
    return self;
}

- (void)chartsViewFocusViewWillShow {
    CABasicAnimation *an1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    an1.fromValue = @(0);
    an1.toValue = @(3);
//    an1.repeatCount = 0;
//    an1.removedOnCompletion = NO;
//    an1.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *an2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an2.fromValue = @(1);
    an2.toValue = @(0);
//    an2.repeatCount = 0;
//    an2.removedOnCompletion = NO;
//    an2.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[an1,an2];
    group.duration = AnimationDuration;
    group.beginTime = -AnimationDuration;
    group.repeatCount = HUGE;
    group.removedOnCompletion = NO;
    group.delegate = self;
    
    self.animationLayer.fillColor = self.focusColor.CGColor;
//    self.animationLayer.fillColor = kColorRandom.CGColor;

    [self.animationLayer addAnimation:group forKey:@"TransformScaleAndOpacityAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.animationLayer removeAnimationForKey:@"TransformScaleAndOpacityAnimation"];
}

- (void)chartsViewFocusViewDidHidden {
    [self.animationLayer removeAllAnimations];
}

@end
