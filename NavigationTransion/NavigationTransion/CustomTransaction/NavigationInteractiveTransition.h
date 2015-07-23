//
//  NavigationInteractiveTransition.h
//  NavigationTransion
//
//  Created by 胡金友 on 15/7/16.
//  Copyright (c) 2015年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationInteractiveTransition : NSObject <UINavigationControllerDelegate>

- (instancetype)initWithViweController:(UIViewController *)vc;
- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;

@end
