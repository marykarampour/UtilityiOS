//
//  UIViewController+ViewControllerTransition.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIViewController+ViewControllerTransition.h"
#import <objc/runtime.h>

static char UIVIEWCONTROLER_TRANSITION_KEY;

@implementation UIViewController (ViewControllerTransition)

- (void)setTransitionDelegate:(id<MKUViewControllerTransitionDelegate>)transitionDelegate {
    objc_setAssociatedObject(self, &UIVIEWCONTROLER_TRANSITION_KEY, transitionDelegate, OBJC_ASSOCIATION_ASSIGN);
    
    if ([self respondsToSelector:@selector(didSetTransitionDelegate:)])
        [self didSetTransitionDelegate:transitionDelegate];
}

- (id<MKUViewControllerTransitionDelegate>)transitionDelegate {
    return objc_getAssociatedObject(self, &UIVIEWCONTROLER_TRANSITION_KEY);
}

- (void)dispathTransitionDelegateToReturnWithObject:(NSObject *)object {
    [self dispathTransitionDelegateToReturnWithResult:VC_TRANSITION_RESULT_TYPE_OK object:object];
}

- (void)dismissAndDispathTransitionDelegateToReturnWithObject:(NSObject *)object {
    [self dispathTransitionDelegateToReturnWithObject:object];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dispathTransitionDelegateToReturnWithResult:(VC_TRANSITION_RESULT_TYPE)result object:(NSObject *)object {
    if ([self.transitionDelegate respondsToSelector:@selector(viewController:didReturnWithResultType:object:)]) {
        [self.transitionDelegate viewController:self didReturnWithResultType:result object:object];
    }
}

@end
