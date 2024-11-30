//
//  UIBarButtonItem+NavBarButtonObject.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIBarButtonItem+NavBarButtonObject.h"
#import "NSObject+NavBarButtonTarget.h"
#import <objc/runtime.h>

static char BUTTON_TYPE_KEY;
static char BUTTON_POSITION_KEY;
static char ACTION_KEY;
static char ACTION_HANDLER_KEY;

@implementation UIBarButtonItem (NavBarButtonObject)

- (void)setType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    objc_setAssociatedObject(self, &BUTTON_TYPE_KEY, @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MKU_NAV_BAR_BUTTON_TYPE)type {
    return [objc_getAssociatedObject(self, &BUTTON_TYPE_KEY) integerValue];
}

- (void)setPosition:(MKU_NAV_BAR_BUTTON_POSITION)position {
    objc_setAssociatedObject(self, &BUTTON_POSITION_KEY, @(position), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MKU_NAV_BAR_BUTTON_POSITION)position {
    return [objc_getAssociatedObject(self, &BUTTON_POSITION_KEY) integerValue];
}

- (void)setObjectAction:(SEL)objectAction {
    objc_setAssociatedObject(self, &ACTION_KEY, [NSValue valueWithPointer:objectAction], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (objectAction) [self setActionHandler:nil];
}

- (SEL)objectAction {
    return [(NSValue *)objc_getAssociatedObject(self, &ACTION_KEY) pointerValue];
}

- (void)setActionHandler:(void (^)(id))actionHandler {
    objc_setAssociatedObject(self, &ACTION_HANDLER_KEY, actionHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (actionHandler) [self setObjectAction:nil];
}

- (void (^)(id))actionHandler {
    return objc_getAssociatedObject(self, &ACTION_HANDLER_KEY);
}

+ (instancetype)editNavBarButtonObject {
    UIBarButtonItem *obj = [[UIBarButtonItem alloc] init];
    obj.type = MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT;
    obj.position = MKU_NAV_BAR_BUTTON_POSITION_RIGHT;
    return obj;
}

+ (instancetype)editNavBarButtonObjectWithEditButton:(UIBarButtonItem *)edit {
    edit.type = MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT;
    edit.position = MKU_NAV_BAR_BUTTON_POSITION_RIGHT;
    return edit;
}

+ (instancetype)navBarButtonWithTitle:(NSString *)title type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target enabled:(BOOL)enabled {
    return [self navBarButtonWithTitle:title type:type target:target action:nil objectAction:nil actionHandler:nil enabled:enabled];
}

+ (instancetype)navBarButtonWithTitle:(NSString *)title type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target action:(SEL)action objectAction:(SEL)objectAction actionHandler:(void (^)(id))actionHandler enabled:(BOOL)enabled {
    UIBarButtonItem *obj = [self navBarButtonWithTitle:title type:type target:target action:action];
    obj.objectAction = objectAction;
    obj.actionHandler = actionHandler;
    obj.enabled = enabled;
    return obj;
}

+ (instancetype)navBarButtonWithImage:(UIImage *)image type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target action:(SEL)action objectAction:(SEL)objectAction actionHandler:(void (^)(id))actionHandler enabled:(BOOL)enabled {
    UIBarButtonItem *obj = [self navBarButtonWithImage:image type:type target:target action:action];
    obj.objectAction = objectAction;
    obj.actionHandler = actionHandler;
    obj.enabled = enabled;
    return obj;
}

+ (instancetype)navBarButtonWithImage:(UIImage *)image type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target action:(SEL)action {
    UIBarButtonItem *obj = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    obj.type = type;
    return obj;
}

+ (instancetype)navBarButtonWithTitle:(NSString *)title type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target action:(SEL)action {
    UIBarButtonItemStyle style = [self isDoneButtonOfType:type] ? UIBarButtonItemStyleDone : UIBarButtonItemStylePlain;
    UIBarButtonItem *obj;
    if (0 < title.length)
        obj = [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
    else
        obj = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(NSInteger)type target:target action:action];
    obj.type = type;
    return obj;
}

+ (instancetype)spacer {
    UIBarButtonItem *obj = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    obj.width = 32.0;
    return obj;
}

@end
