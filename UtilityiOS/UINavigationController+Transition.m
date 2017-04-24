//
//  UINavigationController+Transition.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "UINavigationController+Transition.h"

@implementation UINavigationController (Transition)

- (void)pushToBottomViewController:(UIViewController *)viewController withDuration:(CFTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:nil];
    [self pushViewController:viewController animated:NO];
}

- (void)popFromBottomViewControllerWithDuration:(CFTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popViewControllerAnimated:NO];
}

- (void)popToRootFromBottomViewControllerWithDuration:(CFTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popToRootViewControllerAnimated:NO];
}

- (void)pushWithFadeViewController:(UIViewController *)viewController withDuration:(CFTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self pushViewController:viewController animated:NO];
}

- (void)popWithFadeViewControllerWithDuration:(CFTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popViewControllerAnimated:NO];
}

- (void)popToRootWithFadeViewControllerWithDuration:(CFTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popToRootViewControllerAnimated:NO];
}

@end
