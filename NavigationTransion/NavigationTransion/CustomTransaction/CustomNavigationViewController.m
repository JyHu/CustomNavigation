//
//  CustomNavigationViewController.m
//  NavigationTransion
//
//  Created by 胡金友 on 15/7/16.
//  Copyright (c) 2015年 胡金友. All rights reserved.
//

#import "CustomNavigationViewController.h"
#import "NavigationInteractiveTransition.h"
#import <objc/runtime.h>

/**
 *  @author JyHu, 15-07-23 11:07:04
 *
 *  <#Description#>
 *
 *
 *  @since  v 1.0
 */
#define kAnimationTypeControl 2


@interface CustomNavigationViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIPanGestureRecognizer *panGesture;

#if kAnimationTypeControl == 1
@property (nonatomic, strong) NavigationInteractiveTransition *navT;
#endif

@end

@implementation CustomNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#if kAnimationTypeControl > 0
    [self customNavigationBar];
    
    [self addGlobalGestureAndResponse];
#endif
}

- (void)customNavigationBar
{
    if ([self.navigationBar respondsToSelector:@selector(setShadowImage:)])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationBar];
            navBarHairlineImageView.hidden = YES;
        }
        else
        {
            self.navigationBar.shadowImage = [[UIImage alloc] init];
        }
    }
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height == 0.5) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)addGlobalGestureAndResponse
{
#if kAnimationTypeControl > 0
//    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
//    gesture.enabled = NO;
//    UIView *gestureView = gesture.view;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
    panGesture.delegate = self;
    panGesture.maximumNumberOfTouches = 1;
//    [gestureView addGestureRecognizer:panGesture];
    
    [self.interactivePopGestureRecognizer.view addGestureRecognizer:panGesture];
    self.interactivePopGestureRecognizer.enabled = NO;
    
#if kAnimationTypeControl == 1
    
    _navT = [[NavigationInteractiveTransition alloc] initWithViweController:self];
    [panGesture addTarget:_navT action:@selector(handleControllerPop:)];
    
#elif kAnimationTypeControl == 2
    
    // 获取系统收拾的target数组
    NSArray *targes = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    
    // 获取它的唯一对象，它是一个叫UIGestureRecognizerTarget得私有类，他有一个属性叫做_target
    id gestureRecognizerTarget = [targes firstObject];
    
    // 获取 _target:_UINavigationInteractiveTransition，他有一个方法叫做handleNavigationTransition:
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"target"];
    
    // 获取它的方法签名
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    
    // 创建一个与系统一模一样的收拾，我们只把它的类改为UIPanGestureRecognizer
    [panGesture addTarget:navigationInteractiveTransition action:handleTransition];
    
    // 由于是私有方法，所以苹果不会考虑开发者的使用而进行维护，所以，当系统版本更新的时候有很小的可能性修改这些方法，所以需要对此方法进行判断处理
    if (![navigationInteractiveTransition respondsToSelector:handleTransition])
    {
        [panGesture removeTarget:navigationInteractiveTransition action:handleTransition];
    }
    
#endif
    
#endif
    
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
