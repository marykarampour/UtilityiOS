//
//  NSObject+NavBarButtonTarget.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "NSObject+NavBarButtonTarget.h"
#import "NSObject+Utility.h"
#import "NSArray+Utility.h"
#import <objc/runtime.h>

static char CONTAINER_KEY;
static char BAR_BUTTONs_KEY;
static char TARGETS_KEY;

@interface NSObject ()

@property (nonatomic, weak) UIViewController *viewControllerContainingNavigationBar;
@property (nonatomic, strong) NSDictionary<NSNumber *, NSMutableArray<UIBarButtonItem *> *> *barButtons;

@end

@implementation NSObject (NavtBarButtonTarget)

- (void)setViewControllerContainingNavigationBar:(UIViewController *)viewControllerContainingNavigationBar {
    objc_setAssociatedObject(self, &CONTAINER_KEY, viewControllerContainingNavigationBar, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)viewControllerContainingNavigationBar {
    return objc_getAssociatedObject(self, &CONTAINER_KEY);
}

- (void)setBarButtons:(NSDictionary<NSNumber *,NSMutableArray<UIBarButtonItem *> *> *)barButtons {
    objc_setAssociatedObject(self, &BAR_BUTTONs_KEY, barButtons, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary<NSNumber *,NSMutableArray<UIBarButtonItem *> *> *)barButtons {
    return objc_getAssociatedObject(self, &BAR_BUTTONs_KEY);
}

- (UIBarButtonItem *)buttonOfType:(NSUInteger)type position:(MKU_NAV_BAR_BUTTON_POSITION)position {
    return [self.barButtons[@(position)] objectPassingTest:^BOOL(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        return obj.type == type;
    }];
}

- (UIBarButtonItem *)doneButton {
    return [self.barButtons[@(MKU_NAV_BAR_BUTTON_POSITION_RIGHT)] objectPassingTest:^BOOL(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        return [self isDoneButtonOfType:obj.type];
    }];
}

+ (BOOL)isDoneButtonOfType:(NSUInteger)type {
    return type == MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE || type == MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT || type == MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE;
}

- (BOOL)isDoneButtonOfType:(NSUInteger)type {
    return [self.class isDoneButtonOfType:type];
}
//Because LLDB is useless you need to use these to debug:
//p ((NSArray *)(NSArray *)[self.barButtons allValues])[0][0]
//p ((UIBarButtonItem *)((NSArray *)(NSArray *)[self.barButtons allValues])[0][0]).title
- (void)addButtonOfType:(NSUInteger)type position:(MKU_NAV_BAR_BUTTON_POSITION)position {
    
    UIBarButtonItem *button = [self buttonOfType:type position:position];
    
    if (!self.barButtons) {
        self.barButtons = @{@(MKU_NAV_BAR_BUTTON_POSITION_RIGHT) : [[NSMutableArray alloc] init],
                            @(MKU_NAV_BAR_BUTTON_POSITION_LEFT)  : [[NSMutableArray alloc] init]};
    }
    else if (button) {
        [self.barButtons[@(position)] removeObject:button];
    }
        
    if (type == MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT) {
        button = [UIBarButtonItem editNavBarButtonObject];
    }
    else {
        MKU_NAV_BAR_BUTTON_POSITION position = [self respondsToSelector:@selector(positionForButtonOfType:)] ? [self positionForButtonOfType:type] : MKU_NAV_BAR_BUTTON_POSITION_RIGHT;
        NSString *title = [self respondsToSelector:@selector(titleForButtonOfType:)] ? [self titleForButtonOfType:type] : nil;
        UIImage *image = [self respondsToSelector:@selector(imageForButtonOfType:)] ? [self imageForButtonOfType:type] : nil;
        BOOL enabled = [self respondsToSelector:@selector(isEnabledButtonOfType:)] ? [self isEnabledButtonOfType:type] : NO;
        id target = [self respondsToSelector:@selector(targetForButtonOfType:)] ? [self targetForButtonOfType:type] : self;
        SEL objectAction;
        void(^actionHandler)(id) = button.actionHandler;

        if (target != self)
            objectAction = [self respondsToSelector:@selector(actionForButtonOfType:)] ? [self actionForButtonOfType:type] : button.objectAction;
        else
            objectAction = [target respondsToSelector:@selector(actionForButtonOfType:)] ? [target actionForButtonOfType:type] : button.objectAction;
        
        if (target != self)
            actionHandler = [self respondsToSelector:@selector(actionHandlerForButtonOfType:)] ? [self actionHandlerForButtonOfType:type] : nil;
        else
            [target respondsToSelector:@selector(actionHandlerForButtonOfType:)] ? [target actionHandlerForButtonOfType:type] : nil;
        
        if (image)
            button = [UIBarButtonItem navBarButtonWithImage:image type:type target:self action:@selector(internalButtonPressed:)];
        else if (type < MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_COUNT || 0 < title.length)
            button = [UIBarButtonItem navBarButtonWithTitle:title type:type target:self action:@selector(internalButtonPressed:)];
        else
            button = [UIBarButtonItem spacer];
        
        button.objectAction = objectAction;
        button.actionHandler = actionHandler;
        button.position = position;
        button.enabled = enabled;
        button.type = type;
    }
    
    [self.barButtons[@(position)] addObject:button];
}

- (void)clearBarButtons {
    self.barButtons = nil;
}

- (void)internalButtonPressed:(UIBarButtonItem *)sender {
    [self.viewControllerContainingNavigationBar.view endEditing:YES];
    
    id object;
    if ([self respondsToSelector:@selector(saveObject)])
        object = [self saveObject];
    if (!object)
        object = sender;
    
    id target = self;
    if ([self respondsToSelector:@selector(targetForButtonOfType:)])
        target = [self targetForButtonOfType:sender.type];
    
    if (sender.objectAction && [target respondsToSelector:sender.objectAction])
        [target performSelectorOnMainThread:sender.objectAction withObject:object waitUntilDone:YES];
    else if (sender.actionHandler)
        sender.actionHandler(object);
}

@end

@interface UIViewController ()

@property (nonatomic, strong) NSMutableArray<NSObject<MKUNavBarButtonTargetProtocol> *> *targets;

@end

@implementation UIViewController (NavBarButtonContainer)

- (void)setTargets:(NSMutableArray<NSObject<MKUNavBarButtonTargetProtocol> *> *)targets {
    objc_setAssociatedObject(self, &TARGETS_KEY, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<NSObject<MKUNavBarButtonTargetProtocol> *> *)targets {
    return objc_getAssociatedObject(self, &TARGETS_KEY);
}

- (NSArray<NSObject<MKUNavBarButtonTargetProtocol> *> *)navBarTargets {
    return self.targets;
}

- (void)addNavBarTarget:(NSObject<MKUNavBarButtonTargetProtocol> *)object {
    if (!object || [self.targets containsObject:object]) return;
    
    if (!self.targets)
        self.targets = [[NSMutableArray alloc] init];
    
    [object.viewControllerContainingNavigationBar.targets removeObject:object];
    object.viewControllerContainingNavigationBar = self;
    [self.targets addObject:object];
}

- (void)setNavBarItemsOfTarget:(NSObject<MKUNavBarButtonTargetProtocol> *)object {
    if (object.viewControllerContainingNavigationBar != self) return;
    
    if ([object respondsToSelector:@selector(setNavBarItems)])
        [object setNavBarItems];
    
    NSMutableArray<UIBarButtonItem *> *rightArr = object.barButtons[@(MKU_NAV_BAR_BUTTON_POSITION_RIGHT)];
    NSMutableArray<UIBarButtonItem *> *leftArr = object.barButtons[@(MKU_NAV_BAR_BUTTON_POSITION_LEFT)];
    
    NSInteger indexOfEdit = [rightArr indexOfObjectPassingTest:^BOOL(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.type == MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT && obj.title.length == 0;
    }];
    
    if (indexOfEdit != NSNotFound) {
        [rightArr replaceObjectAtIndex:indexOfEdit withObject:[UIBarButtonItem editNavBarButtonObjectWithEditButton:self.editButtonItem]];
    }
    
    NSArray *rightItems = [self itemsInArray:rightArr inTarget:object];
    NSArray *leftItems = [self itemsInArray:leftArr inTarget:object];
    
    self.navigationItem.rightBarButtonItems = rightItems;
    self.navigationItem.leftBarButtonItems = leftItems;
}

- (void)setNavBarItemsOfTargetAtIndex:(NSUInteger)index {
    [self setNavBarItemsOfTarget:[self.targets nullableObjectAtIndex:index]];
}

- (NSArray *)itemsInArray:(NSArray<UIBarButtonItem *> *)arr inTarget:(NSObject<MKUNavBarButtonTargetProtocol> *)object {
    if (![object respondsToSelector:@selector(hasButtonOfType:)]) return nil;
    
    NSArray *items = [arr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIBarButtonItem * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [object hasButtonOfType:evaluatedObject.type];
    }]];
    
    return items;
}

- (void)setAsNavBarTarget {
    [self addNavBarTarget:self];
    [self setNavBarItemsOfTarget:self];
}

- (void)resetBarButtons {
    [self clearBarButtons];
    [self setAsNavBarTarget];
}

- (void)resetBarButtonsOfTarget:(NSObject<MKUNavBarButtonTargetProtocol> *)object {
    [self clearBarButtons];
    [self setBarButtonsOfTarget:object];
}

- (void)setBarButtonsOfTarget:(NSObject<MKUNavBarButtonTargetProtocol> *)object {
    [self addNavBarTarget:object];
    [self setNavBarItemsOfTarget:object];
}

- (void)resetBarButtonsOfTargets {
    for (NSObject<MKUNavBarButtonTargetProtocol> *obj in self.targets) {
        [self resetBarButtonsOfTarget:obj];
    }
}

- (void)setBarButtonsOfTargets {
    for (NSObject<MKUNavBarButtonTargetProtocol> *obj in self.targets) {
        [self setBarButtonsOfTarget:obj];
    }
}

- (void)setBarButtonsOfViewControllerContainingNavigationBar {
    [self.viewControllerContainingNavigationBar addNavBarTarget:self];
    [self.viewControllerContainingNavigationBar setNavBarItemsOfTarget:self];
}

- (void)resetBarButtonsOfViewControllerContainingNavigationBar {
    [self.viewControllerContainingNavigationBar clearBarButtons];
    [self.viewControllerContainingNavigationBar addNavBarTarget:self];
    [self.viewControllerContainingNavigationBar setNavBarItemsOfTarget:self];
}

@end
