//
//  UIViewController+Utility.h
//  KaChing!
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

NS_ASSUME_NONNULL_BEGIN

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

@end

NS_ASSUME_NONNULL_END
