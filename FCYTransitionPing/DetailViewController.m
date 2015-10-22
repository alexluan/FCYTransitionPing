//
//  DetailViewController.m
//  FCYTransitionPing
//
//  Created by iFangcy on 15/7/11.
//  Copyright (c) 2015年 iFangcy. All rights reserved.
//

#import "DetailViewController.h"
#import "PingPopTransition.h"

@interface DetailViewController ()

- (IBAction)popButtonDidClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *popButton;

// 可交互的转场
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentTransition;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popButton.layer.masksToBounds = YES;
    self.popButton.layer.cornerRadius = self.popButton.frame.size.width * 0.5;
    
    // 手势返回
    UIScreenEdgePanGestureRecognizer *edgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget: self action: @selector(edgeGestureEvent:)];
    edgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer: edgeGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    self.navigationController.delegate = self;
}

- (IBAction)popButtonDidClick:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated: YES];
}

// 手势返回
- (void) edgeGestureEvent: (UIPanGestureRecognizer *) recognizer {
    
    CGFloat percent = [recognizer translationInView: self.view].x / (self.view.bounds.size.width);
    percent = MIN(1.0, (MAX(0.0, percent)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        self.percentTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated: YES];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        [self.percentTransition updateInteractiveTransition: percent];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        if (percent > 0.3) {
            
            [self.percentTransition finishInteractiveTransition];
        }else {
            
            [self.percentTransition cancelInteractiveTransition];
        }
        self.percentTransition = nil;
    }
    
}

#pragma mark --- 手势返回

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return self.percentTransition;
}

#pragma mark ---  UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPop) {
        
        PingPopTransition *popTransition = [[PingPopTransition alloc] init];
        popTransition.popButton = self.popButton;
        
        return popTransition;
    }else {
        
        return nil;
    }
    
}

@end
