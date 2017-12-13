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

@end
