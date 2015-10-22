//
//  FCYPingTransition.m
//  FCYTransitionPing
//
//  Created by iFangcy on 15/9/16.
//  Copyright © 2015年 iFangcy. All rights reserved.
//

#import "FCYPingTransition.h"

@interface FCYPingTransition ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation FCYPingTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    self.transitionContext = transitionContext;
    
    // 开始、结束2个控制器
    UIViewController *fromVC = (UIViewController *) [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController *toVC = (UIViewController *) [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    
    // 动画容器 view
    UIView *contentView = [transitionContext containerView];
    
    
    UIButton *button = self.pingButton;
    UIButton *pingButton = [[UIButton alloc] initWithFrame: CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, button.frame.size.height)];
    
    pingButton.backgroundColor = button.backgroundColor;
    pingButton.alpha = 1;
    pingButton.layer.cornerRadius = pingButton.frame.size.width * 0.5;
    [toVC.view addSubview: pingButton];
    
    
    [UIView animateWithDuration: [self transitionDuration: transitionContext] delay: 0.0f options: UIViewAnimationOptionCurveEaseIn animations:^{
        
        pingButton.transform = CGAffineTransformScale(pingButton.transform, 0.1, 0.1);
        pingButton.alpha = 0;
        
        button.transform = CGAffineTransformScale(button.transform, 0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            button.transform = CGAffineTransformIdentity;
        }
    }];
    
    [contentView addSubview: fromVC.view];
    [contentView addSubview: toVC.view];
    
    UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithOvalInRect: button.frame];
    // 创建2个圆形的贝索斯曲线，一个是 button 的 size，另一个是拥有足够覆盖屏幕的半径，最终的动画就是在2个贝索斯曲线之间进行切换
    CGPoint finalPoint;
    if (button.frame.origin.x > (toVC.view.bounds.size.width / 2)) {
        
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            
            // 第一象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds) + 30);
        }else {
            
            // 第四象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else {
        
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            
            // 第二象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds) + 30);
        }else {
            
            // 第三象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }
    
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect: CGRectInset(button.frame, - radius, - radius)];
    
    // 创建一个 CAShapeLayer 用于负责展示圆形的遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
    maskLayerAnimation.fromValue = (__bridge id)((maskStartBP.CGPath));
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = [self transitionDuration: transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    
    [maskLayer addAnimation: maskLayerAnimation forKey: @"path"];
}

#pragma mark --- CABasicAnimation Delegate
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self.transitionContext completeTransition: ![self.transitionContext transitionWasCancelled]];
    
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

- (void)animationDidStart:(CAAnimation *)anim {
    
    
}

@end
