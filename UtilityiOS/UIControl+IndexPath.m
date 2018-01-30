//
//  UIControl+IndexPath.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "UIControl+IndexPath.h"
#import <objc/runtime.h>

static char UICONTROL_INDEXPATH_KEY;

@implementation UIControl (IndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, &UICONTROL_INDEXPATH_KEY, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    return (NSIndexPath *)objc_getAssociatedObject(self, &UICONTROL_INDEXPATH_KEY);
}

@end
