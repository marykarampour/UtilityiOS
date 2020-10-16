//
//  UIViewController+Utility.m
//  KaChing!
//
//  Created by Maryam Karampour on 2017-12-09.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "UIViewController+Utility.h"

@implementation UIViewController (Utility)

- (void)setChildView:(UIViewController *)childVC forSubView:(UIView * __strong *)view {
    [self addChildViewController:childVC];
    [childVC willMoveToParentViewController:self];
    [childVC beginAppearanceTransition:YES animated:YES];
    if ([*view isKindOfClass:[UIView class]]) {
        *view = childVC.view;
    }
    else {
        self.view = childVC.view;
    }
    [childVC endAppearanceTransition];
    [childVC didMoveToParentViewController:self];
}

- (CGFloat)topBarHeight {
    if (@available(iOS 11.0, *)) {
        return 0.0;
    }
    else {
        return self.navigationController.navigationBar.frame.size.height + [Constants safeAreaHeight];
    }
}

- (void)presentViewController:(UIViewController *)VC animationType:(NSString *)type timingFunction:(NSString *)timingFunction completion:(void (^)(void))completion {
    if (type.length) {
        CATransition *transition = [[CATransition alloc] init];
        transition.duration = [Constants TransitionAnimationDuration];
        transition.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
        transition.type = kCATransitionPush;
        transition.subtype = type;
        [self.view.window.layer addAnimation:transition forKey:nil];
    }

    if (@available(iOS 13.0, *)) {
        VC.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    [self presentViewController:VC animated:(type.length == 0) completion:completion];
}

- (void)dismissViewControllerAnimationType:(NSString *)type timingFunction:(NSString *)timingFunction completion:(void (^)(void))completion {
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = [Constants TransitionAnimationDuration];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    transition.type = kCATransitionPush;
    transition.subtype = type;
    
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:completion];
}

@end
