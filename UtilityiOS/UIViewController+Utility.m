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
        return [self nabbarHeight] + [Constants safeAreaHeight];
    }
}

- (CGFloat)tabbarHeight {
    return ((!self.tabBarController || self.tabBarController.tabBar.isHidden) ? 0.0 : self.tabBarController.tabBar.frame.size.height);
}

- (CGFloat)nabbarHeight {
    return self.navigationController.navigationBar.frame.size.height;
}

- (CGFloat)visibleViewHeight {
    return [Constants screenHeight]-[Constants safeAreaHeight]-[self nabbarHeight]-[self tabbarHeight];
}

- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}

- (UIViewController *)previousViewController {
    if (self.navigationController.viewControllers.count < 2) return nil;
    NSUInteger index = self.navigationController.viewControllers.count - 1;
    return self.navigationController.viewControllers[index - 1];
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

- (void)removeBackBarButtonText {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (UIBarButtonItem *)navBarButtonWithAction:(SEL)action type:(NAV_BAR_ITEM_TYPE)type title:(NSString *)title systemItem:(UIBarButtonSystemItem)item image:(UIImage *)image {
    
    UIBarButtonItem *button;
    
    switch (type) {
        case NAV_BAR_ITEM_TYPE_TITLE:
            button = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:action];
            break;
        case NAV_BAR_ITEM_TYPE_SYSTEM:
            button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:action];
            break;
        case NAV_BAR_ITEM_TYPE_IMAGE:
            button = [[UIBarButtonItem alloc] initWithImage:image style:0 target:self action:action];
            break;
        default:
            break;
    }
    return button;
}

- (void)addTapToDismissKeyboard {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

- (void)addTapWithAction:(SEL)action {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}
@end
