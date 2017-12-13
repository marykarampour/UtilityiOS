//
//  UINavigationController+Transition.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Transition)

- (void)popToViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)pushToBottomViewController:(UIViewController *)viewController withDuration:(CFTimeInterval)duration;
- (void)popFromBottomViewControllerWithDuration:(CFTimeInterval)duration;
- (void)popToRootFromBottomViewControllerWithDuration:(CFTimeInterval)duration;

- (void)pushWithFadeViewController:(UIViewController *)viewController withDuration:(CFTimeInterval)duration;
- (void)popWithFadeViewControllerWithDuration:(CFTimeInterval)duration;
- (void)popToRootWithFadeViewControllerWithDuration:(CFTimeInterval)duration;

@end
