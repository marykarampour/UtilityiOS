//
//  UIBarButtonItem+IndexPath.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIBarButtonItem+IndexPath.h"
#import <objc/runtime.h>

static char UIBARBUTTONITEM_INDEXPATH_KEY;

@implementation UIBarButtonItem (IndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, &UIBARBUTTONITEM_INDEXPATH_KEY, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    return (NSIndexPath *)objc_getAssociatedObject(self, &UIBARBUTTONITEM_INDEXPATH_KEY);
}

@end
