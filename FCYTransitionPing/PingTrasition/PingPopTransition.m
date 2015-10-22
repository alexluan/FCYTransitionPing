//
//  PingPopTransition.m
//  FCYTransitionPing
//
//  Created by iFangcy on 15/7/11.
//  Copyright (c) 2015年 iFangcy. All rights reserved.
//

#import "PingPopTransition.h"

@interface PingPopTransition ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation PingPopTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.7f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    self.transitionContext = transitionContext;
    
    UIViewController *fromVC = (UIViewController *)[transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview: toVC.view];
    [containerView addSubview: fromVC.view];
    
    
    UIButton *button = self.popButton;
    
    // 黑色按钮
    UIButton *popButton = [[UIButton alloc] initWithFrame: CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width, button.frame.size.height)];
    popButton.backgroundColor = button.backgroundColor;
    popButton.layer.cornerRadius = button.frame.size.width * 0.5;
    popButton.alpha = 0;
    popButton.transform = CGAffineTransformScale(popButton.transform, 0.1, 0.1);
    [fromVC.view addSubview: popButton];
    
    // 黑色按钮动画
    [UIView animateWithDuration: [self transitionDuration: transitionContext] delay: 0.0f options: UIViewAnimationOptionCurveEaseInOut animations:^{
        
        popButton.alpha = 1;
        popButton.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        popButton.alpha = 0;
    }];
    
    // 画2个贝索斯曲线
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect: button.frame];
    
    CGPoint startPoint;
    
    // 判断触发点在那个象限
    if (button.frame.origin.x > (toVC.view.frame.size.width / 2)) {
        
        if (button.frame.origin.y < (toVC.view.frame.size.height / 2)) {
            
            // 第一象限
            startPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds) + 30);
        }else {
            
            // 第四象限
            startPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else {
        
        if (button.frame.origin.y < (toVC.view.frame.size.height / 2)) {
            
            // 第二象限
            startPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds) + 30);
        }else {
            
            // 第三象限
            startPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }
    
    CGFloat radius = sqrt(startPoint.x * startPoint.x + startPoint.y * startPoint.y);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect: CGRectInset(button.frame, - radius, - radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath: @"path"];
    pingAnimation.fromValue = (__bridge id)((startPath.CGPath));
    pingAnimation.toValue = (__bridge id)((finalPath.CGPath));
    pingAnimation.duration = [self transitionDuration: transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    
    pingAnimation.delegate = self;
    
    [maskLayer addAnimation: pingAnimation forKey: @"pingInvert"];
}

#pragma mark ---  CABasicAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self.transitionContext completeTransition: ![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    
}

- (void)animationDidStart:(CAAnimation *)anim {
    
    
}

















@end
