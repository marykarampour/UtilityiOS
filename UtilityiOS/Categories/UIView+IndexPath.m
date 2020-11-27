//
//  UIView+IndexPath.m
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-20.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "UIView+IndexPath.h"
#import <objc/runtime.h>

static char UICONTROL_INDEXPATH_KEY;

@implementation UIView (IndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, &UICONTROL_INDEXPATH_KEY, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    return (NSIndexPath *)objc_getAssociatedObject(self, &UICONTROL_INDEXPATH_KEY);
}
@end
