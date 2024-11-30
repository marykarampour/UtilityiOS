//
//  UIViewController+IndexPath.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIViewController+IndexPath.h"
#import <objc/runtime.h>

static char UIVIEWCONTROLER_INDEXPATH_KEY;

@implementation UIViewController (IndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, &UIVIEWCONTROLER_INDEXPATH_KEY, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    return (NSIndexPath *)objc_getAssociatedObject(self, &UIVIEWCONTROLER_INDEXPATH_KEY);
}

@end
