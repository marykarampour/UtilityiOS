//
//  MKUMenuObjects.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUMenuObjects.h"

static NSInteger const MKU_MENU_ITEM_VC_TYPE_NONE = -1;

@implementation MKUMenuObjects

@end

@implementation MKUSectionObject

+ (instancetype)objectIsCollapsable:(BOOL)collapsable expanded:(BOOL)expanded {
    MKUSectionObject *obj = [[MKUSectionObject alloc] init];
    obj.isCollapsable = collapsable;
    obj.expanded = expanded;
    return obj;
}

+ (instancetype)objectIsCollapsable:(BOOL)collapsable {
    return [self objectIsCollapsable:collapsable expanded:NO];
}

+ (instancetype)blankObject {
    return [self objectIsCollapsable:NO];
}

@end

@implementation MKUMenuItemObject

- (instancetype)init {
    if (self = [super init]) {
        self.type = MKU_MENU_ITEM_VC_TYPE_NONE;
    }
    return self;
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass {
    return [self objectWithTitle:title subtitle:nil VCClass:VCClass type:MKU_MENU_ITEM_VC_TYPE_NONE object:nil shouldCopy:YES];
}

+ (instancetype)objectWithTitle:(NSString *)title type:(NSInteger)type {
    return [self objectWithTitle:title subtitle:nil VCClass:nil type:type object:nil shouldCopy:YES];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type {
    return [self objectWithTitle:title subtitle:nil VCClass:VCClass type:type object:nil shouldCopy:YES];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass object:(id)object {
    return [self objectWithTitle:title subtitle:nil VCClass:VCClass type:MKU_MENU_ITEM_VC_TYPE_NONE object:object shouldCopy:YES];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass object:(id)object icon:(UIImage *)icon {
    return [self objectWithTitle:title VCClass:VCClass type:MKU_MENU_ITEM_VC_TYPE_NONE object:object icon:icon];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass action:(ActionObject *)action {
    return [self objectWithTitle:title VCClass:VCClass type:MKU_MENU_ITEM_VC_TYPE_NONE action:action];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type object:(id)object {
    return [self objectWithTitle:title subtitle:nil VCClass:VCClass type:type object:object shouldCopy:YES];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type object:(id)object icon:(UIImage *)icon {
    MKUMenuItemObject *obj = [[MKUMenuItemObject alloc] init];
    obj.title = title;
    obj.VCClass = VCClass;
    obj.type = type;
    obj.object = object;
    obj.shouldCopy = YES;
    obj.selectedIcon = icon;
    obj.deselectedIcon = icon;
    obj.spinnerState = MKU_MENU_SPINNER_STATE_NONE;
    obj.accessoryType = MKU_MENU_ACCESSORY_TYPE_DISCLOSURE;
    return obj;
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type action:(ActionObject *)action {
    return [self objectWithTitle:title VCClass:VCClass type:type action:action icon:nil];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type action:(ActionObject *)action icon:(UIImage *)icon {
    MKUMenuItemObject *obj = [[MKUMenuItemObject alloc] init];
    obj.title = title;
    obj.VCClass = VCClass;
    obj.type = type;
    obj.accessoryType = MKU_MENU_ACCESSORY_TYPE_DISCLOSURE;
    obj.spinnerState = MKU_MENU_SPINNER_STATE_NONE;
    obj.action = action;
    obj.selectedIcon = icon;
    obj.deselectedIcon = icon;
    return obj;
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass icon:(UIImage *)icon {
    return [self objectWithTitle:title VCClass:VCClass type:MKU_MENU_ITEM_VC_TYPE_NONE icon:icon badge:nil];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type icon:(UIImage *)icon {
    return [self objectWithTitle:title VCClass:VCClass type:type icon:icon badge:nil];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type icon:(UIImage *)icon badge:(MKUBadgeItem *)badge {
    MKUMenuItemObject *obj = [[MKUMenuItemObject alloc] init];
    obj.title = title;
    obj.VCClass = VCClass;
    obj.type = type;
    obj.selectedIcon = icon;
    obj.deselectedIcon = icon;
    obj.accessoryType = MKU_MENU_ACCESSORY_TYPE_BADGE;
    obj.badge = badge;
    return obj;
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass icon:(UIImage *)icon badge:(MKUBadgeItem *)badge {
    return [self objectWithTitle:title VCClass:VCClass type:MKU_MENU_ITEM_VC_TYPE_NONE icon:icon badge:badge];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass selectedIcon:(UIImage *)selectedIcon deselectedIcon:(UIImage *)deselectedIcon badge:(MKUBadgeItem *)badge {
    MKUMenuItemObject *obj = [[MKUMenuItemObject alloc] init];
    obj.title = title;
    obj.VCClass = VCClass;
    obj.selectedIcon = selectedIcon;
    obj.deselectedIcon = deselectedIcon;
    obj.accessoryType = MKU_MENU_ACCESSORY_TYPE_BADGE;
    obj.badge = badge;
    return obj;
}

+ (instancetype)objectWithTitle:(NSString *)title subtitle:(NSString *)subtitle VCClass:(Class)VCClass type:(NSInteger)type icon:(UIImage *)icon {
    MKUMenuItemObject *obj = [[MKUMenuItemObject alloc] init];
    obj.title = title;
    obj.subtitle = subtitle;
    obj.VCClass = VCClass;
    obj.type = type;
    obj.selectedIcon = icon;
    obj.deselectedIcon = icon;
    obj.accessoryType = MKU_MENU_ACCESSORY_TYPE_NONE;
    return obj;
}

+ (instancetype)objectWithTitle:(NSString *)title subtitle:(NSString *)subtitle VCClass:(Class)VCClass type:(NSInteger)type object:(id)object shouldCopy:(BOOL)shouldCopy {
    return [self objectWithTitle:title subtitle:subtitle VCClass:VCClass type:type object:object shouldCopy:shouldCopy accessoryType:MKU_MENU_ACCESSORY_TYPE_DISCLOSURE badge:nil];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass accessoryType:(MKU_MENU_ACCESSORY_TYPE)accessoryType badge:(MKUBadgeItem *)badge {
    return [self objectWithTitle:title subtitle:nil VCClass:VCClass type:MKU_MENU_ITEM_VC_TYPE_NONE object:nil shouldCopy:NO accessoryType:MKU_MENU_ACCESSORY_TYPE_DISCLOSURE badge:badge];
}

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type accessoryType:(MKU_MENU_ACCESSORY_TYPE)accessoryType badge:(MKUBadgeItem *)badge {
    return [self objectWithTitle:title subtitle:nil VCClass:VCClass type:type object:nil shouldCopy:NO accessoryType:MKU_MENU_ACCESSORY_TYPE_DISCLOSURE badge:badge];
}

+ (instancetype)objectWithTitle:(NSString *)title subtitle:(NSString *)subtitle VCClass:(Class)VCClass type:(NSInteger)type object:(id)object shouldCopy:(BOOL)shouldCopy accessoryType:(MKU_MENU_ACCESSORY_TYPE)accessoryType badge:(MKUBadgeItem *)badge {
    MKUMenuItemObject *obj = [[MKUMenuItemObject alloc] init];
    obj.title = title;
    obj.subtitle = subtitle;
    obj.VCClass = VCClass;
    obj.type = type;
    obj.object = object;
    obj.shouldCopy = shouldCopy;
    obj.accessoryType = accessoryType;
    obj.spinnerState = MKU_MENU_SPINNER_STATE_NONE;
    obj.badge = badge;
    return obj;
}

@end

@implementation MKUMenuSectionObject

+ (instancetype)sectionWithTitle:(NSString *)title objects:(NSArray<MKUMenuItemObject *> *)objects {
    MKUMenuSectionObject *obj = [[MKUMenuSectionObject alloc] init];
    obj.title = title;
    obj.menuItemObjects = objects;
    obj.isCollapsable = YES;
    obj.expanded = title.length;
    return obj;
}

+ (instancetype)sectionWithObjects:(NSArray<MKUMenuItemObject *> *)objects {
    return [self sectionWithTitle:nil objects:objects];
}

@end
