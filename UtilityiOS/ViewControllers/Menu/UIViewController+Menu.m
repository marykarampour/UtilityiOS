//
//  UIViewController+Menu.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIViewController+Menu.h"
#import "MKUTableViewController.h"
#import "NSArray+Utility.h"
#import <objc/runtime.h>

static char MENU_OBJECTS_KEY;

@implementation UIViewController (Menu)

- (void)setMenuObjects:(NSArray<MKUMenuSectionObject *> *)menuObjects {
    objc_setAssociatedObject(self, &MENU_OBJECTS_KEY, menuObjects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self respondsToSelector:@selector(didSetMenuObjects:)])
        [self didSetMenuObjects:menuObjects];
}

- (NSArray<MKUMenuSectionObject *> *)menuObjects {
    return objc_getAssociatedObject(self, &MENU_OBJECTS_KEY);
}

#pragma mark - items

- (MKUMenuItemObject *)menuObjectAtIndexPath:(NSIndexPath *)indexPath {
    return self.menuObjects[indexPath.section].menuItemObjects[[self indexForIndexPath:indexPath]];
}

- (NSString *)titleForItem:(NSIndexPath *)indexPath {
    if (self.menuObjects.count <= indexPath.section)
        return nil;
    if (self.menuObjects[indexPath.section].menuItemObjects.count <= [self indexForIndexPath:indexPath])
        return nil;
    return [self menuObjectAtIndexPath:indexPath].title;
}

- (NSString *)subtitleForItem:(NSIndexPath *)indexPath {
    if (self.menuObjects.count <= indexPath.section)
        return nil;
    if (self.menuObjects[indexPath.section].menuItemObjects.count <= [self indexForIndexPath:indexPath])
        return nil;
    return [self menuObjectAtIndexPath:indexPath].subtitle;
}

- (NSString *)anyTitleForSection:(NSInteger)section {
    if (self.menuObjects.count <= section)
        return nil;
    for (MKUMenuItemObject *obj in self.menuObjects[section].menuItemObjects) {
        if (0 < obj.title.length) {
            return obj.title;
        }
    }
    return nil;
}

- (NSUInteger)indexForIndexPath:(NSIndexPath *)indexPath {
    if ([self isKindOfClass:[UITableViewController class]])
        return indexPath.row;
    return indexPath.item;
}

#pragma mark - badges

- (void)updateMenuBadge:(MKUBadgeItem *)badge {
    [self menuObjectForBadge:badge].badge = badge;
    [self dispatchDelegateToReload];
}

- (MKUMenuItemObject *)menuObjectForBadge:(MKUBadgeItem *)badge {
    
    __block MKUMenuItemObject *item;
    
    [self.menuObjects enumerateObjectsUsingBlock:^(MKUMenuSectionObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        item = [obj.menuItemObjects objectPassingTest:^BOOL(MKUMenuItemObject *obj, NSUInteger idx, BOOL *stop) {
            return obj.badge.type == badge.type;
        }];
        
        if (item) *stop = YES;
    }];
    return item;
}
//It would be nice if runtime properties could be inspected
//p ((MKUMenuItemObject *)((MKUMenuSectionObject *)self.menuObjects.firstObject).menuItemObjects.firstObject).badge.type

#pragma mark - transitions

- (void)transitionToViewAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *VC = [self nextViewControllerForIndexPath:indexPath];
    if ([self respondsToSelector:@selector(willTransitionToView:atIndexPath:)])
        [self willTransitionToView:VC atIndexPath:indexPath];
    [self.navigationController pushViewController:VC animated:YES];
}

- (UIViewController *)nextViewControllerForIndexPath:(NSIndexPath *)indexPath {
    
    MKUMenuItemObject *obj = [self menuObjectAtIndexPath:indexPath];
    UIViewController *nextViewController;
    
    if ([obj.VCClass instancesRespondToSelector:@selector(initWithMKUType:)] && 0 <= obj.type) {
        nextViewController = [[obj.VCClass alloc] initWithMKUType:obj.type];
    }
    else {
        nextViewController = [[obj.VCClass alloc] init];
    }
    
    if (obj.object) {
        BOOL objectCanCopy = [obj.object respondsToSelector:@selector(copyWithZone:)] && obj.shouldCopy;
        
        if ([nextViewController respondsToSelector:@selector(setObject:)]) {
            [nextViewController performSelectorOnMainThread:@selector(setObject:) withObject:objectCanCopy ? [obj.object copy] : obj.object waitUntilDone:YES];
        }
    }
    
    if (obj.action) {
        BOOL canCopy = [obj.action.object respondsToSelector:@selector(copyWithZone:)] && obj.shouldCopy;
        id target;
        
        if ([obj.action.target respondsToSelector:obj.action.action]) {
            target = obj.action.target;
        }
        else if ([nextViewController respondsToSelector:obj.action.action]) {
            target = nextViewController;
        }
        else if (0 < obj.action.title.length) {
            SEL selector = NSSelectorFromString(obj.action.title);
            if ([nextViewController respondsToSelector:selector]) {
                target = [nextViewController performSelector:selector];
            }
        }
        
        [target performSelectorOnMainThread:obj.action.action withObject:canCopy ? [obj.action.object copy] : obj.action.object waitUntilDone:YES];
    }
    
    if (obj.class != [MKUMenuItemObject class]) {
        //Only subclass's properties
        NSSet *properties = [MKUMenuItemObject propertyNames];
        
        for (NSString *key in properties) {
            NSObject *object = [obj valueForKey:key];
            BOOL respondsToKey = [nextViewController respondsToSelector:NSSelectorFromString(key)];
            
            if (respondsToKey) {
                BOOL objectCanCopy = [object respondsToSelector:@selector(copyWithZone:)] && obj.shouldCopy;
                [nextViewController performSelectorOnMainThread:NSSelectorFromString(key) withObject:objectCanCopy ? [object copy] : object waitUntilDone:YES];
            }
        }
    }
    
    if ([nextViewController isKindOfClass:[MKUTableViewController class]] &&
        !((MKUTableViewController *)nextViewController).refreshDelegate) {
        ((MKUTableViewController *)nextViewController).refreshDelegate = self;
    }
    
    if ([nextViewController conformsToProtocol:@protocol(MKUViewControllerTransitionProtocol)] &&
        !((id<MKUViewControllerTransitionProtocol>)nextViewController).transitionDelegate) {
        ((id<MKUViewControllerTransitionProtocol>)nextViewController).transitionDelegate = self;
    }
    
    return nextViewController;
}

- (void)handleViewController:(UIViewController *)viewController didReturnWithObject:(id)object {
    [self.navigationController popToViewController:self animated:YES];
}

- (void)dispatchDelegateToReload {
    if ([self respondsToSelector:@selector(reload)]) [self reload];
}

@end

