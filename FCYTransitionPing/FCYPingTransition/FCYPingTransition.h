//
//  FCYPingTransition.h
//  FCYTransitionPing
//
//  Created by iFangcy on 15/9/16.
//  Copyright © 2015年 iFangcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCYPingTransition : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  执行动画的按钮
 */
@property (nonatomic, strong) UIButton *pingButton;

@end
