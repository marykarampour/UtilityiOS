//
//  UITextView+IndexPath.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <objc/runtime.h>

static char UITEXTVIEW_INDEXPATH_KEY;

@implementation UITextView (IndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, &UITEXTVIEW_INDEXPATH_KEY, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    return (NSIndexPath *)objc_getAssociatedObject(self, &UITEXTVIEW_INDEXPATH_KEY);
}

@end

