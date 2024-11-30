//
//  UIViewController+Utility.m
//  KaChing!
//
//  Created by Maryam Karampour on 2017-12-09.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "UIViewController+Utility.h"
#import "NSObject+Utility.h"
#import "NSArray+Utility.h"
#import <objc/runtime.h>

static char UIVIEWCONTROLER_ACTION_KEY;

@implementation UIViewController (Utility)

- (void)setChildView:(UIViewController *)childVC forSubView:(UIView * __strong *)view {
    if (!childVC) return;
    
    [self addChildViewController:childVC];
    [childVC willMoveToParentViewController:self];
    [childVC beginAppearanceTransition:YES animated:YES];
    if (!(*view) || [*view isKindOfClass:[UIView class]]) {
        *view = childVC.view;
    }
    else {
        self.view = childVC.view;
    }
    [childVC endAppearanceTransition];
    [childVC didMoveToParentViewController:self];
}

- (CGFloat)topBarHeight {
    if (@available(iOS 11.0, *)) {
        return 0.0;
    }
    else {
        return [self nabbarHeight] + [Constants safeAreaHeight];
    }
}

- (CGFloat)tabbarHeight {
    return ((!self.tabBarController || self.tabBarController.tabBar.isHidden) ? 0.0 : self.tabBarController.tabBar.frame.size.height);
}

- (CGFloat)nabbarHeight {
    return self.navigationController.navigationBar.frame.size.height;
}

- (CGFloat)visibleViewHeight {
    return [Constants screenHeight]-[Constants safeAreaHeight]-[self nabbarHeight]-[self tabbarHeight];
}

- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}

- (UIViewController *)previousViewController {
    if (self.navigationController.viewControllers.count < 2) return nil;
    NSUInteger index = self.navigationController.viewControllers.count - 1;
    return self.navigationController.viewControllers[index - 1];
}

- (void)presentViewController:(UIViewController *)VC animationType:(NSString *)type timingFunction:(NSString *)timingFunction completion:(void (^)(void))completion {
    
    if (type.length) {
        
        CATransition *transition = [[CATransition alloc] init];
        transition.duration = [Constants TransitionAnimationDuration];
        transition.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
        transition.type = kCATransitionPush;
        transition.subtype = type;
        [self.view.window.layer addAnimation:transition forKey:nil];
    }
    
    if (@available(iOS 13.0, *)) {
        VC.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:VC animated:(type.length == 0) completion:completion];
}

- (void)dismissViewControllerAnimationType:(NSString *)type timingFunction:(NSString *)timingFunction completion:(void (^)(void))completion {
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = [Constants TransitionAnimationDuration];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    transition.type = kCATransitionPush;
    transition.subtype = type;
    
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:completion];
}

- (void)removeBackBarButtonText {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (UIBarButtonItem *)navBarButtonWithAction:(SEL)action type:(NAV_BAR_ITEM_TYPE)type title:(NSString *)title systemItem:(UIBarButtonSystemItem)item image:(UIImage *)image {
    
    UIBarButtonItem *button;
    
    switch (type) {
        case NAV_BAR_ITEM_TYPE_TITLE:
            button = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:action];
            break;
        case NAV_BAR_ITEM_TYPE_SYSTEM:
            button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:action];
            break;
        case NAV_BAR_ITEM_TYPE_IMAGE:
            button = [[UIBarButtonItem alloc] initWithImage:image style:0 target:self action:action];
            break;
        default:
            break;
    }
    return button;
}

- (void)setSelectedAction:(MKU_LIST_ITEM_SELECTED_ACTION)selectedAction {
    objc_setAssociatedObject(self, &UIVIEWCONTROLER_ACTION_KEY, @(selectedAction), OBJC_ASSOCIATION_RETAIN);
}

- (MKU_LIST_ITEM_SELECTED_ACTION)selectedAction {
    return [objc_getAssociatedObject(self, &UIVIEWCONTROLER_ACTION_KEY) integerValue];
}

+ (UIBarButtonItem *)spacer {
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = [Constants BarButtonItemSpaceWidth];
    return space;
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)item {
    [self addBarButtonItem:item isLeft:YES];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)item spacer:(BOOL)spacer {
    [self addBarButtonItem:item isLeft:NO spacer:spacer];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)item {
    [self addRightBarButtonItem:item spacer:NO];
}

- (void)addBarButtonItem:(UIBarButtonItem *)item isLeft:(BOOL)isLeft {
    [self addBarButtonItem:item isLeft:isLeft spacer:NO];
}

- (void)addBarButtonItem:(UIBarButtonItem *)item isLeft:(BOOL)isLeft spacer:(BOOL)spacer {
    if (!item) return;
    
    NSArray <UIBarButtonItem *> *items = isLeft ? self.navigationItem.leftBarButtonItems : self.navigationItem.rightBarButtonItems;
    if ([items containsObject:item]) return;
    
    NSMutableArray <UIBarButtonItem *> *arr = [NSMutableArray mutableArrayWithNullableArray:items];
    if (!arr) arr = [[NSMutableArray alloc] init];
    
    if (spacer)
        [arr addObject:[self.class spacer]];
    [arr addObject:item];
    
    if (isLeft)
        self.navigationItem.leftBarButtonItems = arr;
    else
        self.navigationItem.rightBarButtonItems = arr;
}

- (void)removeLeftBarButtonItem:(UIBarButtonItem *)item {
    [self removeBarButtonItem:item isLeft:NO];
}

- (void)removeRightBarButtonItem:(UIBarButtonItem *)item {
    [self removeBarButtonItem:item isLeft:NO];
}

- (void)removeBarButtonItem:(UIBarButtonItem *)item isLeft:(BOOL)isLeft {
    if (!item) return;
    
    NSArray <UIBarButtonItem *> *items = isLeft ? self.navigationItem.leftBarButtonItems : self.navigationItem.rightBarButtonItems;
    if (![items containsObject:item]) return;
    
    NSMutableArray <UIBarButtonItem *> *arr = [NSMutableArray mutableArrayWithNullableArray:items];
    
    [arr removeObject:item];
    
    if (isLeft)
        self.navigationItem.leftBarButtonItems = arr;
    else
        self.navigationItem.rightBarButtonItems = arr;
}

- (NSMutableArray<UIBarButtonItem *> *)combinedNavBarItemsWithObjects:(NSArray<MKUBarButtonObject *> *)objects {
    
    NSMutableArray <UIBarButtonItem *> *items = [UIViewController navbarItemsInViewController:self];
    
    for (MKUBarButtonObject *obj in objects) {
        if (obj.state == MKU_TENARY_TYPE_NO)
            [items removeObject:obj.button];
        if (obj.state == MKU_TENARY_TYPE_YES && ![items containsObject:obj.button])
            [items addObject:obj.button];
    }
    return items;
}

+ (NSMutableArray<UIBarButtonItem *> *)navbarItemsInViewController:(UIViewController *)viewController {
    return [NSMutableArray mutableArrayWithNullableArray:viewController.navigationItem.rightBarButtonItems];
}

- (void)addTapToDismissKeyboard {
    [self addTapWithAction:@selector(handleTap:)];
}

- (void)addTapWithAction:(SEL)action {
    [self addTapWithAction:action target:self];
}

- (void)addTapWithAction:(SEL)action target:(id)target {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}

@end

@implementation MKUBarButtonObject

+ (instancetype)objectWithButton:(UIBarButtonItem *)button state:(MKU_TENARY_TYPE)state {
    MKUBarButtonObject *obj = [[MKUBarButtonObject alloc] init];
    obj.button = button;
    obj.state = state;
    return obj;
}

@end

