//
//  UIViewController+Utility.h
//  UtilityiOS!
//
//  Created by Maryam Karampour on 2017-12-09.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>

typedef NS_ENUM(NSUInteger, NAV_BAR_ITEM_TYPE) {
    NAV_BAR_ITEM_TYPE_TITLE,
    NAV_BAR_ITEM_TYPE_SYSTEM,
    NAV_BAR_ITEM_TYPE_IMAGE
};


@interface MKUBarButtonObject : NSObject

@property (nonatomic, strong) UIBarButtonItem *button;
/** @param state Indicates whether the the button should be added to the navbar, removed from it, or no action be taken, */
@property (nonatomic, assign) MKU_TENARY_TYPE state;

+ (instancetype)objectWithButton:(UIBarButtonItem *)button state:(MKU_TENARY_TYPE)state;

@end

@protocol MKUViewControllerActionProtocol <NSObject>

@optional
@property (nonatomic, assign) MKU_LIST_ITEM_SELECTED_ACTION selectedAction;

@end

@interface UIViewController (Action) <MKUViewControllerActionProtocol>

@end

@protocol MKUViewControllerViewProtocol <NSObject>

@optional
- (void)refreshViews;

@end

@interface UIViewController (Utility)

/** @brief Use to add a view controller as a child view controller
 @param view will get the value of childVC.view. If view = nil self.view is used instead */
- (void)setChildView:(UIViewController * _Nonnull)childVC forSubView:(UIView * __strong *)view;

/** @brief height of safe areas, status bar and/or nav bar when applicable. Only relevent in iOS lower than 11.0 */
- (CGFloat)topBarHeight;

- (CGFloat)tabbarHeight;
- (CGFloat)nabbarHeight;
/** @brief visible area of view, excluding nav bar, tab bar, status bar */
- (CGFloat)visibleViewHeight;
- (BOOL)isVisible;

- (void)addTapToDismissKeyboard;
- (void)addTapWithAction:(SEL)action;

- (UIViewController *)previousViewController;

- (void)presentViewController:(__kindof UIViewController *)VC animationType:(NSString *)type timingFunction:(NSString *)timingFunction completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimationType:(NSString *)type timingFunction:(NSString *)timingFunction completion:(void (^)(void))completion;

- (void)removeBackBarButtonText;

- (UIBarButtonItem *)navBarButtonWithAction:(SEL)action type:(NAV_BAR_ITEM_TYPE)type title:(NSString *)title systemItem:(UIBarButtonSystemItem)item image:(UIImage *)image;
+ (UIBarButtonItem *)spacer;
- (void)addLeftBarButtonItem:(UIBarButtonItem *)item;
- (void)addRightBarButtonItem:(UIBarButtonItem *)item;
- (void)addRightBarButtonItem:(UIBarButtonItem *)item spacer:(BOOL)spacer;
- (void)removeLeftBarButtonItem:(UIBarButtonItem *)item;
- (void)removeRightBarButtonItem:(UIBarButtonItem *)item;
- (void)addBarButtonItem:(UIBarButtonItem *)item isLeft:(BOOL)isLeft;
- (void)addBarButtonItem:(UIBarButtonItem *)item isLeft:(BOOL)isLeft spacer:(BOOL)spacer;
- (void)removeBarButtonItem:(UIBarButtonItem *)item isLeft:(BOOL)isLeft;
- (NSMutableArray<UIBarButtonItem *> *)combinedNavBarItemsWithObjects:(NSArray<MKUBarButtonObject *> *)objects;
+ (NSMutableArray<UIBarButtonItem *> *)navbarItemsInViewController:(UIViewController *)viewController;

@end

