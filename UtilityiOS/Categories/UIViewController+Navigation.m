//
//  UIViewController+Navigation.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIViewController+Navigation.h"
#import "AppDelegate.h"

@implementation UIViewController (Navigation)

- (void)popToViewControllerAtIndex:(NSUInteger)index {
    
    if (self.navigationController.viewControllers.count > index) {
        UIViewController *presentingView = self.navigationController.viewControllers[index];
        if (presentingView) {
            [self.navigationController popToViewController:presentingView animated:YES];
        }
    }
}

- (void)popToViewControllerOfClass:(Class)cls {
    
    for (NSUInteger i=0; i<self.navigationController.viewControllers.count; i++) {
        UIViewController *presentingView = self.navigationController.viewControllers[i];
        if ([presentingView class] == cls) {
            [self.navigationController popToViewController:presentingView animated:YES];
            return;
        }
    }
}

- (UIViewController *)previousViewController {
    
    if (self.navigationController.viewControllers.count < 2) return nil;
    NSUInteger index = self.navigationController.viewControllers.count - 1;
    return self.navigationController.viewControllers[index - 1];
}

- (void)presentViewController:(__kindof UIViewController *)VC animationType:(CATransitionSubtype)type timingFunction:(CAMediaTimingFunctionName)timingFunction completion:(void (^)(void))completion {
    [self presentViewController:VC animationType:type timingFunction:timingFunction completion:completion fullScreen:YES];
}

- (void)presentViewController:(UIViewController *)VC animationType:(CATransitionSubtype)type timingFunction:(CAMediaTimingFunctionName)timingFunction completion:(void (^)(void))completion fullScreen:(BOOL)fullScreen {
    if (type.length) {
        CATransition *transition = [[CATransition alloc] init];
        transition.duration = [Constants TransitionAnimationDuration];
        transition.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
        transition.type = kCATransitionPush;
        transition.subtype = type;
        [self.view.window.layer addAnimation:transition forKey:nil];
    }
    
    if (fullScreen)
        VC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:VC animated:(type.length == 0) completion:completion];
}

- (void)dismissViewControllerAnimationType:(CATransitionSubtype)type timingFunction:(CAMediaTimingFunctionName)timingFunction completion:(void (^)(void))completion {
    
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = [Constants TransitionAnimationDuration];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    transition.type = kCATransitionPush;
    transition.subtype = type;
    
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:completion];
}

- (void)presentPopover:(UIViewController *)VC fromSource:(UIView *)source size:(CGSize)size {
    [self presentPopover:VC fromSource:source size:size rect:CGRectNull];
}

- (void)presentPopover:(UIViewController *)VC fromSource:(UIView *)source size:(CGSize)size rect:(CGRect)rect {
    if (!VC) return;
    
    VC.modalPresentationStyle = UIModalPresentationPopover;
    VC.preferredContentSize = size;
    
    UIBarButtonItem *item = [source isKindOfClass:[UIBarButtonItem class]] ? (UIBarButtonItem *)source : nil;
    if (item) {
        VC.popoverPresentationController.barButtonItem = item;
    }
    else {
        UIView *view = [source isKindOfClass:[UIView class]] ? (UIView *)source : self.view;
        if (CGRectIsNull(rect)) rect = CGRectMake(view.frame.size.width / 2.0, view.frame.size.height / 2.0, 2.0, 2.0);
        
        VC.popoverPresentationController.sourceView = view;
        VC.popoverPresentationController.sourceRect = rect;
    }
    
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)updateNavBarMode:(MKU_THEME_STYLE)mode {
    if (IS_IPHONE) {
        [(AppDelegate *)([UIApplication sharedApplication].delegate) setNavbarTintMode:mode];
    }
}

@end

