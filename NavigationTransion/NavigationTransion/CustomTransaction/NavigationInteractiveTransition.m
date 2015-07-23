//
//  NavigationInteractiveTransition.m
//  NavigationTransion
//
//  Created by 胡金友 on 15/7/16.
//  Copyright (c) 2015年 胡金友. All rights reserved.
//

#import "NavigationInteractiveTransition.h"
#import "POPAnimation.h"

@interface NavigationInteractiveTransition()

@property (nonatomic, weak) UINavigationController *nav;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation NavigationInteractiveTransition

- (id)initWithViweController:(UIViewController *)vc
{
    self = [super init];
    if (self)
    {
        self.nav = (UINavigationController *)vc;
        self.nav.delegate = self;
    }
    return self;
}

// 把用户的每次pan手势操作作为一次pop动画的执行
- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer
{
    // interactivePopTransition就是方法2返回的对象，我们需要更新它的进度来控制pop动画的流程，我们用手指在试图中得位置与视图宽度比例作为它的进度
    CGFloat progress = [recognizer translationInView:recognizer.view].x / recognizer.view.bounds.size.width;
    
    // 稳定进度区间，让它在0.0（未完成） ~ 1.0（完成）之间
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        // 收拾开始，新建一个监控对象
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        
        // 告诉控制器开始执行pop动画
        [self.nav popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        // 更新收拾的完成进度
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        
        // 手势结束时如果进度大于一半，那么久完成pop操作，否则重来
        if (progress > 0.5)
        {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

/**
 *  @author JyHu, 15-07-16 10:07:33
 *
 *  苹果提供给我们用来重写控制器之间转场动画的（POP或者PUSH）--方法1
 *
 *  @param navigationController <#navigationController description#>
 *  @param operation            <#operation description#>
 *  @param fromVC               <#fromVC description#>
 *  @param toVC                 <#toVC description#>
 *
 *  @return <#return value description#>
 *
 *  @since  v 6.3.0
 */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    // 判断如果当前执行的是POP操作，就返回我们自定义的pop动画对象
    if (operation == UINavigationControllerOperationPop)
    {
        return [[POPAnimation alloc] init];
    }
    else if (operation == UINavigationControllerOperationPush)
    {
        
    }
    return nil;
}

/**
 *  @author JyHu, 15-07-16 10:07:15
 *
 *  苹果让我们返回一个交互的对象，用来实时管理控制器之间专场动画的完成度，通过它我们可以让控制器的专场动画与用户交互，如果上面的那个代理方法返回是nil，则该方法是不会调用 -- 方法2
 *
 *  @param navigationController <#navigationController description#>
 *  @param animationController  <#animationController description#>
 *
 *  @return <#return value description#>
 *
 *  @since  v 6.3.0
 */
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    // 传过来当前的动画对象animationController，判断如果是我们自定义的pop动画对象，那么就返回interactivePopTransition来监控动画完成度。
    if ([animationController isKindOfClass:[POPAnimation class]])
    {
        return self.interactivePopTransition;
    }
    
    return nil;
}


@end
