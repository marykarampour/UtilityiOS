//
//  UIControl+IndexPath.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "UIControl+IndexPath.h"
#import <objc/runtime.h>

static char UICONTROL_INDEXPATH_KEY;
static char UICONTROL_GUID_KEY;

@implementation UIControl (IndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, &UICONTROL_INDEXPATH_KEY, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath {
    return (NSIndexPath *)objc_getAssociatedObject(self, &UICONTROL_INDEXPATH_KEY);
}

- (void)setGUID:(NSString *)GUID {
    objc_setAssociatedObject(self, &UICONTROL_GUID_KEY, GUID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)GUID {
    return (NSString *)objc_getAssociatedObject(self, &UICONTROL_GUID_KEY);
}

@end
