//
//  UIViewController+HeaderFooterContainer.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2025-07-22.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIViewController+HeaderFooterContainer.h"
#import <objc/runtime.h>

static char VIEWCONTROLER_HEADER_KEY;

@implementation UIViewController (HeaderFooterContainer)

- (void)setHeaderDelegate:(__kindof MKUHeaderFooterContainerViewController *)headerDelegate {
    objc_setAssociatedObject(self, &VIEWCONTROLER_HEADER_KEY, headerDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (__kindof MKUHeaderFooterContainerViewController *)headerDelegate {
    return objc_getAssociatedObject(self, &VIEWCONTROLER_HEADER_KEY);
}

- (void)setContainerHeaderNextTitle:(NSString *)title {
    [self saveButton].title = title;
}

- (void)setContainerHeaderNextEnabled:(BOOL)enabled {
    [self saveButton].enabled = enabled;
}

- (UIBarButtonItem *)saveButton {
    UIBarButtonItem *button = [self.headerDelegate doneButton];
    return button ? button : [self doneButton];
}

@end
