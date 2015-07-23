//
//  POPAnimation.m
//  NavigationTransion
//
//  Created by 胡金友 on 15/7/16.
//  Copyright (c) 2015年 胡金友. All rights reserved.
//

#import "POPAnimation.h"

@interface POPAnimation()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation POPAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 返回动画执行的时间
    return 0.25;
}

// transitionContext可以看做是一个工具，用来获取一些列动画执行相关的对象，并且通知系统动画是否完成等功能。
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    _transitionContext = transitionContext;
    
    // 获取动画来自的那个控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // 获取转场到的那个控制器
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // 转场动画是两个控制器视图时间的动画，需要一个containerView来作为动画的“舞台”，让动画执行
    UIView *containerView = [transitionContext containerView];
    
#if 1
    
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    // 执行动画，我们让fromVC的视图移动到屏幕的最右侧
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    } completion:^(BOOL finished) {
        // 当动画执行完成，这个方法必须要调用，否则系统会认为其余的任何操作都在动画执行过程中
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
#else
    
    [containerView addSubview:toViewController.view];
    [containerView sendSubviewToBack:toViewController.view];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromViewController];
    
    CGRect finalPosition = CGRectOffset(initialFrame, bounds.size.width, 0);
    
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.frame = finalPosition;
    }completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
    
    
#endif
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}

@end
