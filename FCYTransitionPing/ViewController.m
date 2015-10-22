//
//  ViewController.m
//  FCYTransitionPing
//
//  Created by iFangcy on 15/7/11.
//  Copyright (c) 2015年 iFangcy. All rights reserved.
//

#import "ViewController.h"
#import "PingTrasition.h"

@interface ViewController ()

- (IBAction)pingButtonDidClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pingButton.layer.masksToBounds = YES;
    self.pingButton.layer.cornerRadius = self.pingButton.frame.size.width * 0.5;
}

// 主要 UINavigationControllerDelegate 要在这里设置
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    self.navigationController.delegate = self;
}

#pragma mark --- UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        PingTrasition *ping = [[PingTrasition alloc] init];
        ping.pingButton = self.pingButton;
        return ping;
    }else{
        return nil;
    }
}

- (IBAction)pingButtonDidClick:(id)sender {
    
}
@end
