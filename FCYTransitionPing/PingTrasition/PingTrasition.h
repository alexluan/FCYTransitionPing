//
//  PingTrasition.h
//  FCYTransitionPing
//
//  Created by iFangcy on 15/7/11.
//  Copyright (c) 2015年 iFangcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PingTrasition : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  执行动画的按钮
 */
@property (nonatomic, strong) UIButton *pingButton;

@end
